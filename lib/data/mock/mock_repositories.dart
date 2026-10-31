import 'dart:math';

import '../../core/utils/app_images.dart';

import '../models/account.dart';
import '../models/catalog.dart';
import '../models/chat.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../repositories/repositories.dart';
import 'mock_data.dart';

/// Kho dữ liệu dùng chung giữa các mock repository (giả lập database).
class MockDb {
  MockDb() {
    reset();
  }

  late AppUser? currentUser;
  late List<AppUser> users;
  late List<Gig> gigs;
  late List<Review> reviews;
  late List<Order> orders;
  late List<Conversation> conversations;
  late List<ChatMessage> messages;
  late List<QuickResponse> quickResponses;
  late List<String> labels;
  late List<SavedList> savedLists;
  late List<AppNotification> notifications;
  late List<String> history;
  late Set<String> interests;
  late Availability? availability;
  late List<FeedbackEntry> feedback;
  late Map<String, String> passwords;
  OnboardingAnswers? onboarding;

  void reset() {
    currentUser = null;
    // Luôn sao chép thành list có thể sửa (dữ liệu mẫu có thể là const).
    users = [MockData.me(), ...MockData.users()];
    gigs = [...MockData.gigs()];
    reviews = [...MockData.reviews()];
    orders = [...MockData.orders()];
    conversations = [...MockData.conversations()];
    messages = [...MockData.messages()];
    quickResponses = [...MockData.quickResponses];
    labels = [...kDefaultChatLabels];
    savedLists = [...MockData.savedLists()];
    notifications = [...MockData.notifications()];
    history = [...MockData.browsingHistory()];
    for (final g in gigs) {
      AppImages.registerGig(g.id, g.imageSeeds.first);
    }
    for (final u in users) {
      AppImages.registerUser(u.id, displayName: u.displayName, username: u.username);
    }
    interests = {'social', 'brand'};
    availability = null;
    feedback = [];
    passwords = {'minhanh@gmail.com': 'Matkhau1', 'minhanh_vg': 'Matkhau1'};
    onboarding = null;
  }

  AppUser? user(String id) {
    for (final u in users) {
      if (u.id == id) return u;
    }
    return null;
  }

  String newId() => Random().nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
}

mixin _Latency {
  Duration get latency;
  Future<void> wait() => latency == Duration.zero ? Future.value() : Future.delayed(latency);
}

// ===================================================================== AUTH
class MockAuthRepository with _Latency implements AuthRepository {
  MockAuthRepository(this.db, {this.latency = const Duration(milliseconds: 500)});
  final MockDb db;
  @override
  final Duration latency;

  @override
  AppUser? get currentUser => db.currentUser;

  void _setMe(AppUser u) {
    db.currentUser = u;
    final i = db.users.indexWhere((e) => e.id == u.id);
    if (i >= 0) {
      db.users[i] = u;
    } else {
      db.users.add(u);
    }
  }

  @override
  Future<AppUser?> restoreSession() async => db.currentUser;

  @override
  Future<AppUser> signIn({required String emailOrUsername, required String password}) async {
    await wait();
    final key = emailOrUsername.trim().toLowerCase();
    if (key.isEmpty || password.isEmpty) {
      throw AuthException(AuthError.missingCredentials);
    }
    final saved = db.passwords[key];
    if (saved == null) throw AuthException(AuthError.userNotFound);
    if (saved != password) throw AuthException(AuthError.wrongPassword);
    final me = db.users.firstWhere(
      (u) => u.email.toLowerCase() == key || u.username.toLowerCase() == key,
      orElse: MockData.me,
    );
    _setMe(me);
    return me;
  }

  @override
  Future<AppUser> signUp({required String username, required String email, required String password}) async {
    await wait();
    final u = username.trim().toLowerCase();
    final e = email.trim().toLowerCase();
    if (db.users.any((x) => x.username.toLowerCase() == u)) {
      throw AuthException(AuthError.usernameTaken);
    }
    if (db.passwords.containsKey(e)) throw AuthException(AuthError.emailTaken);
    final me = MockData.me().copyWith(username: u, displayName: username.trim(), email: e, emailVerified: false);
    db.passwords[e] = password;
    db.passwords[u] = password;
    _setMe(me);
    return me;
  }

  @override
  Future<AppUser> signInWithProvider(String provider) async {
    await wait();
    final me = MockData.me().copyWith(emailVerified: true);
    _setMe(me);
    return me;
  }

  @override
  Future<void> signOut() async {
    await wait();
    db.currentUser = null;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await wait();
    if (!email.contains('@')) throw AuthException(AuthError.invalidEmail);
  }

  @override
  Future<void> resendVerification() => wait();

  @override
  Future<AppUser> verifyEmail() async {
    await wait();
    final me = db.currentUser!.copyWith(emailVerified: true);
    _setMe(me);
    return me;
  }

  @override
  Future<AppUser> updateEmail(String newEmail) async {
    await wait();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(newEmail.trim())) {
      throw AuthException(AuthError.invalidEmail);
    }
    final me = db.currentUser!.copyWith(email: newEmail.trim(), emailVerified: false);
    _setMe(me);
    return me;
  }

  @override
  Future<AppUser> updateProfile(AppUser user) async {
    await wait();
    _setMe(user);
    return user;
  }

  @override
  Future<AppUser> becomeSeller() async {
    await wait();
    final me = db.currentUser!.copyWith(isSeller: true);
    _setMe(me);
    return me;
  }

  @override
  Future<void> deleteAccount({required String reason}) async {
    await wait();
    final hasActive = db.orders.any((o) => o.buyerId == db.currentUser?.id && o.status.isActive);
    if (hasActive) {
      throw AuthException(AuthError.activeOrders);
    }
    db.currentUser = null;
  }

  @override
  Future<void> deactivateAccount() async {
    await wait();
    db.currentUser = null;
  }

  @override
  Future<void> saveOnboarding(OnboardingAnswers answers) async {
    await wait();
    db.onboarding = answers;
    if (answers.interests.isNotEmpty) db.interests = {...answers.interests};
  }
}

// ===================================================================== CATALOG
class MockCatalogRepository with _Latency implements CatalogRepository {
  MockCatalogRepository(this.db, {this.latency = const Duration(milliseconds: 300)});
  final MockDb db;
  @override
  final Duration latency;

  @override
  Future<List<Category>> categories() async {
    await wait();
    return MockData.categories;
  }

  static String _norm(String s) => s.toLowerCase().trim();

  @override
  Future<List<Gig>> search(GigFilter f) async {
    await wait();
    final q = _norm(f.query);
    final levelOf = {for (final u in db.users) u.id: u.level.name};
    var list = db.gigs.where((g) {
      if (q.isNotEmpty) {
        final hay = _norm('${g.title} ${g.tags.join(' ')} ${g.subcategoryId}');
        final words = q.split(RegExp(r'\s+'));
        if (!words.every(hay.contains)) return false;
      }
      if (f.categoryId != null && g.categoryId != f.categoryId) return false;
      if (f.subcategoryId != null && g.subcategoryId != f.subcategoryId) return false;
      if (f.minPrice != null && g.priceFrom < f.minPrice!) return false;
      if (f.maxPrice != null && g.priceFrom > f.maxPrice!) return false;
      if (f.maxDeliveryDays != null && g.fastestDelivery > f.maxDeliveryDays!) return false;
      if (f.proOnly && !g.isPro) return false;
      if (f.sellerLevels.isNotEmpty && !f.sellerLevels.contains(levelOf[g.sellerId])) return false;
      return true;
    }).toList();
    switch (f.sort) {
      case GigSort.priceLow:
        list.sort((a, b) => a.priceFrom.compareTo(b.priceFrom));
      case GigSort.priceHigh:
        list.sort((a, b) => b.priceFrom.compareTo(a.priceFrom));
      case GigSort.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case GigSort.bestSelling:
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case GigSort.newest:
        list = list.reversed.toList();
      case GigSort.relevance:
        break;
    }
    return list;
  }

  @override
  Future<Gig?> gigById(String id) async {
    await wait();
    for (final g in db.gigs) {
      if (g.id == id) return g;
    }
    return null;
  }

  @override
  Future<List<Gig>> gigsBySeller(String sellerId) async {
    await wait();
    return db.gigs.where((g) => g.sellerId == sellerId).toList();
  }

  @override
  Future<List<Gig>> popularGigs() async {
    await wait();
    final l = [...db.gigs]..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return l;
  }

  @override
  Future<AppUser?> userById(String id) async {
    await wait();
    return db.user(id);
  }

  @override
  Future<List<AppUser>> usersByIds(List<String> ids) async {
    await wait();
    return [for (final id in ids) ?db.user(id)];
  }

  @override
  Future<List<Review>> reviewsForSeller(String sellerId) async {
    await wait();
    return db.reviews.where((r) => r.sellerId == sellerId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<String>> suggestions(String query) async {
    await wait();
    final q = _norm(query);
    if (q.isEmpty) return const [];
    final pool = <String>{
      for (final c in MockData.categories) ...c.subcategories.map((s) => s.name.toLowerCase()),
      for (final g in db.gigs) ...g.tags,
    };
    return pool.where((s) => s.contains(q)).take(8).toList();
  }

  @override
  Future<List<String>> relatedSearches(String query) async {
    await wait();
    return const ['phát triển website', 'dựng video', 'thumbnail youtube', 'logo động', 'thiết kế app'];
  }
}

// ===================================================================== ORDERS
class MockOrderRepository with _Latency implements OrderRepository {
  MockOrderRepository(this.db, {this.latency = const Duration(milliseconds: 400)});
  final MockDb db;
  @override
  final Duration latency;

  /// Phí dịch vụ: 5% + 25.000đ, làm tròn.
  static int serviceFeeFor(int subtotal) => (subtotal * 0.05).round() + 25000;

  Order _get(String id) => db.orders.firstWhere((o) => o.id == id);

  Order _put(Order o) {
    final i = db.orders.indexWhere((e) => e.id == o.id);
    if (i >= 0) {
      db.orders[i] = o;
    } else {
      db.orders.insert(0, o);
    }
    return o;
  }

  Order _addEvent(Order o, OrderEvent e) => o.copyWith(events: [...o.events, e]);

  @override
  Future<List<Order>> buyerOrders(String userId) async {
    await wait();
    return db.orders.where((o) => o.buyerId == userId).toList();
  }

  @override
  Future<List<Order>> sellerOrders(String userId) async {
    await wait();
    return db.orders.where((o) => o.sellerId == userId).toList();
  }

  @override
  Future<Order?> orderById(String id) async {
    await wait();
    for (final o in db.orders) {
      if (o.id == id) return o;
    }
    return null;
  }

  @override
  Future<Order> placeOrder({
    required String buyerId,
    required Gig gig,
    required CheckoutDraft draft,
    required String paymentMethod,
  }) async {
    await wait();
    final pkg = gig.packages[draft.packageIndex];
    final extras = gig.extras.where((e) => draft.extraIds.contains(e.id)).toList();
    var subtotal = pkg.price;
    var days = pkg.deliveryDays;
    final extraLabels = <String>[];
    for (final e in extras) {
      final qty = draft.extraQuantities[e.id] ?? 1;
      subtotal += e.price * qty;
      days += e.extraDays * qty;
      extraLabels.add(qty > 1 ? '${e.title} x$qty' : e.title);
    }
    if (days < 1) days = 1;
    final now = DateTime.now();
    final order = Order(
      id: db.newId(),
      gigId: gig.id,
      gigTitle: gig.title,
      gigImageSeed: gig.imageSeeds.first,
      buyerId: buyerId,
      sellerId: gig.sellerId,
      packageTier: pkg.tier,
      packageTitle: pkg.title,
      packageFeatures: [
        for (final f in pkg.features.entries)
          if (f.value.isNotEmpty) f.value == '✓' ? f.key : '${f.value} ${f.key.toLowerCase()}',
        pkg.revisions < 0 ? 'Không giới hạn lượt chỉnh sửa' : '${pkg.revisions} lượt chỉnh sửa',
      ],
      extras: extraLabels,
      subtotal: subtotal,
      serviceFee: serviceFeeFor(subtotal),
      status: gig.requirements.isEmpty ? OrderStatus.inProgress : OrderStatus.awaitingRequirements,
      createdAt: now,
      dueDate: now.add(Duration(days: days)),
      paymentMethod: paymentMethod,
      events: [
        OrderEvent(type: OrderEventType.created, title: 'Đã tạo đơn hàng', at: now),
        if (gig.requirements.isEmpty) OrderEvent(type: OrderEventType.started, title: 'Đơn hàng bắt đầu', at: now),
      ],
    );
    return _put(order);
  }

  @override
  Future<Order> placeOfferOrder({required String buyerId, required CustomOffer offer}) async {
    await wait();
    final gig = db.gigs.firstWhere((g) => g.id == offer.gigId, orElse: () => db.gigs.first);
    final now = DateTime.now();
    // Đánh dấu báo giá trong hội thoại là đã chấp nhận.
    for (var i = 0; i < db.messages.length; i++) {
      final m = db.messages[i];
      if (m.offer?.id == offer.id) {
        db.messages[i] = ChatMessage(
          id: m.id,
          conversationId: m.conversationId,
          senderId: m.senderId,
          sentAt: m.sentAt,
          type: m.type,
          text: m.text,
          offer: m.offer!.copyWith(status: OfferStatus.accepted),
          replyTo: m.replyTo,
          relatedGigId: m.relatedGigId,
        );
      }
    }
    return _put(
      Order(
        id: db.newId(),
        gigId: gig.id,
        gigTitle: gig.title,
        gigImageSeed: gig.imageSeeds.first,
        buyerId: buyerId,
        sellerId: offer.sellerId,
        packageTier: 'Báo giá riêng',
        packageTitle: offer.title,
        packageFeatures: [
          if (offer.isMilestone) ...offer.milestones.map((m) => m.title) else ...offer.serviceOptions,
          '${offer.revisions} lượt chỉnh sửa',
        ],
        subtotal: offer.isMilestone ? offer.milestones.first.price : offer.totalPrice,
        serviceFee: serviceFeeFor(offer.isMilestone ? offer.milestones.first.price : offer.totalPrice),
        status: offer.requestRequirements ? OrderStatus.awaitingRequirements : OrderStatus.inProgress,
        createdAt: now,
        dueDate: now.add(Duration(days: offer.totalDays)),
        events: [OrderEvent(type: OrderEventType.created, title: 'Đã tạo đơn hàng từ báo giá riêng', at: now)],
      ),
    );
  }

  @override
  Future<Order> submitRequirements(String orderId, Map<String, String> answers) async {
    await wait();
    final now = DateTime.now();
    var o = _get(orderId).copyWith(requirementAnswers: answers, status: OrderStatus.inProgress);
    o = _addEvent(o, OrderEvent(type: OrderEventType.requirementsSubmitted, title: 'Đã gửi yêu cầu đơn hàng', at: now));
    o = _addEvent(o, OrderEvent(type: OrderEventType.started, title: 'Đơn hàng bắt đầu', at: now));
    return _put(o);
  }

  @override
  Future<Order> deliver(String orderId, Delivery delivery) async {
    await wait();
    var o = _get(orderId).copyWith(
      status: OrderStatus.delivered,
      deliveries: [..._get(orderId).deliveries, delivery],
      reviewDeadline: DateTime.now().add(const Duration(days: 3)),
    );
    o = _addEvent(
      o,
      OrderEvent(type: OrderEventType.delivered, title: 'Đã giao đơn hàng', at: delivery.at, body: delivery.message),
    );
    return _put(o);
  }

  @override
  Future<Order> approveDelivery(String orderId) async {
    await wait();
    var o = _get(orderId).copyWith(status: OrderStatus.completed);
    o = _addEvent(o, OrderEvent(type: OrderEventType.completed, title: 'Đơn hàng đã hoàn thành', at: DateTime.now()));
    return _put(o);
  }

  @override
  Future<Order> requestRevision(String orderId, String message) async {
    await wait();
    var o = _get(orderId).copyWith(status: OrderStatus.revisionRequested);
    o = _addEvent(
      o,
      OrderEvent(
        type: OrderEventType.revisionRequested,
        title: 'Đã yêu cầu chỉnh sửa',
        body: message,
        at: DateTime.now(),
      ),
    );
    return _put(o);
  }

  @override
  Future<Order> requestExtension(
    String orderId, {
    required int days,
    required String message,
    required bool fromSeller,
  }) async {
    await wait();
    final now = DateTime.now();
    var o = _get(orderId).copyWith(
      status: OrderStatus.disputed,
      pendingRequest: PendingRequest(
        kind: 'extend',
        fromSeller: fromSeller,
        message: message,
        extraDays: days,
        at: now,
        previousStatus: _get(orderId).status,
      ),
    );
    o = _addEvent(
      o,
      OrderEvent(
        type: OrderEventType.extensionRequested,
        title: fromSeller ? 'Người bán yêu cầu gia hạn $days ngày' : 'Đã yêu cầu gia hạn $days ngày',
        body: message,
        at: now,
      ),
    );
    return _put(o);
  }

  @override
  Future<Order> respondToRequest(String orderId, {required bool accept}) async {
    await wait();
    final cur = _get(orderId);
    final req = cur.pendingRequest;
    if (req == null) return cur;
    final now = DateTime.now();
    var o = cur.copyWith(clearPending: true, status: req.previousStatus ?? OrderStatus.inProgress);
    if (req.kind == 'cancel' && accept) {
      o = o.copyWith(status: OrderStatus.cancelled);
      o = _addEvent(o, OrderEvent(type: OrderEventType.cancelled, title: 'Đơn hàng đã bị huỷ', at: now));
      return _put(o);
    }
    o = _addEvent(
      o,
      OrderEvent(
        type: accept ? OrderEventType.resolutionAccepted : OrderEventType.resolutionDeclined,
        title: accept ? 'Đã chấp nhận yêu cầu' : 'Đã từ chối yêu cầu',
        at: now,
      ),
    );
    if (accept && req.kind == 'extend') {
      final due = cur.dueDate.add(Duration(days: req.extraDays));
      o = o.copyWith(dueDate: due);
      o = _addEvent(
        o,
        OrderEvent(
          type: OrderEventType.deliveryDateUpdated,
          title: 'Ngày giao được cập nhật thành ${due.day}/${due.month}/${due.year}',
          at: now,
        ),
      );
    }
    return _put(o);
  }

  @override
  Future<Order> extendReviewTime(String orderId, int days) async {
    await wait();
    final cur = _get(orderId);
    final base = cur.reviewDeadline ?? DateTime.now();
    return _put(cur.copyWith(reviewDeadline: base.add(Duration(days: days))));
  }

  @override
  Future<Order> requestCancel(String orderId, {required String reason, required String message}) async {
    await wait();
    final now = DateTime.now();
    var o = _get(orderId).copyWith(
      status: OrderStatus.disputed,
      pendingRequest: PendingRequest(
        kind: 'cancel',
        fromSeller: false,
        message: '$reason\n$message',
        at: now,
        previousStatus: _get(orderId).status,
      ),
    );
    o = _addEvent(
      o,
      OrderEvent(
        type: OrderEventType.extensionRequested,
        title: 'Đã gửi yêu cầu huỷ đơn',
        body: 'Người bán có tối đa 2 ngày để chấp nhận hoặc từ chối.',
        at: now,
      ),
    );
    return _put(o);
  }

  @override
  Future<Order> leaveReview(String orderId, OrderReview review) async {
    await wait();
    final cur = _get(orderId);
    var o = cur.copyWith(review: review);
    o = _addEvent(
      o,
      OrderEvent(type: OrderEventType.reviewed, title: 'Bạn đã để lại đánh giá', body: review.text, at: DateTime.now()),
    );
    final buyer = db.user(cur.buyerId);
    db.reviews.insert(
      0,
      Review(
        id: db.newId(),
        sellerId: cur.sellerId,
        gigId: cur.gigId,
        authorName: buyer?.username ?? 'Ẩn danh',
        authorSeed: buyer?.avatarSeed ?? 0,
        rating: review.overall,
        text: review.text,
        createdAt: DateTime.now(),
        price: cur.subtotal,
      ),
    );
    return _put(o);
  }

  @override
  Future<Order> reviewBuyer(String orderId, String text, int rating) async {
    await wait();
    var o = _get(orderId).copyWith(sellerReviewOfBuyer: text);
    o = _addEvent(
      o,
      OrderEvent(type: OrderEventType.reviewed, title: 'Bạn đã đánh giá người mua', body: text, at: DateTime.now()),
    );
    return _put(o);
  }

  @override
  Future<Order> tip(String orderId, int amount) async {
    await wait();
    var o = _get(orderId).copyWith(tip: amount);
    o = _addEvent(o, OrderEvent(type: OrderEventType.tipped, title: 'Bạn đã gửi tiền tip', at: DateTime.now()));
    return _put(o);
  }

  @override
  Future<Order> addExtra(String orderId, GigExtra extra) async {
    await wait();
    final cur = _get(orderId);
    var o = cur.copyWith(
      extras: [...cur.extras, extra.title],
      subtotal: cur.subtotal + extra.price,
      serviceFee: serviceFeeFor(cur.subtotal + extra.price),
      dueDate: cur.dueDate.add(Duration(days: max(0, extra.extraDays))),
    );
    o = _addEvent(
      o,
      OrderEvent(type: OrderEventType.extraAdded, title: 'Đã thêm dịch vụ: ${extra.title}', at: DateTime.now()),
    );
    return _put(o);
  }
}

// ===================================================================== CHAT
class MockChatRepository with _Latency implements ChatRepository {
  MockChatRepository(this.db, {this.latency = const Duration(milliseconds: 250)});
  final MockDb db;
  @override
  final Duration latency;

  @override
  Future<List<Conversation>> conversations(String userId) async {
    await wait();
    return [...db.conversations]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<List<ChatMessage>> messages(String conversationId) async {
    await wait();
    return db.messages.where((m) => m.conversationId == conversationId).toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }

  @override
  Future<Conversation> conversationWith(String userId, String otherUserId) async {
    await wait();
    for (final c in db.conversations) {
      if (c.participantId == otherUserId) return c;
    }
    final c = Conversation(
      id: 'c_${db.newId()}',
      participantId: otherUserId,
      lastMessage: '',
      updatedAt: DateTime.now(),
    );
    db.conversations.add(c);
    return c;
  }

  @override
  Future<ChatMessage> send(ChatMessage message) async {
    await wait();
    final m = ChatMessage(
      id: db.newId(),
      conversationId: message.conversationId,
      senderId: message.senderId,
      sentAt: message.sentAt,
      text: message.text,
      type: message.type,
      fileName: message.fileName,
      fileSize: message.fileSize,
      offer: message.offer,
      replyTo: message.replyTo,
      relatedGigId: message.relatedGigId,
    );
    db.messages.add(m);
    final i = db.conversations.indexWhere((c) => c.id == m.conversationId);
    if (i >= 0) {
      final preview = switch (m.type) {
        MessageType.file => 'Đã gửi một tệp: ${m.fileName}',
        MessageType.offer => 'Đã gửi một báo giá riêng.',
        MessageType.videoCall => 'Lời mời gọi video',
        _ => m.text,
      };
      db.conversations[i] = db.conversations[i].copyWith(
        lastMessage: preview,
        updatedAt: m.sentAt,
        archived: false,
        hasCustomOffer: m.type == MessageType.offer ? true : null,
      );
    }
    return m;
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    await wait();
    final i = db.conversations.indexWhere((c) => c.id == conversation.id);
    if (i >= 0) db.conversations[i] = conversation;
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    await wait();
    db.conversations.removeWhere((c) => c.id == conversationId);
    db.messages.removeWhere((m) => m.conversationId == conversationId);
  }

  @override
  Future<CustomOffer> updateOffer(String messageId, OfferStatus status) async {
    await wait();
    final i = db.messages.indexWhere((m) => m.id == messageId);
    final m = db.messages[i];
    final offer = m.offer!.copyWith(status: status);
    db.messages[i] = ChatMessage(
      id: m.id,
      conversationId: m.conversationId,
      senderId: m.senderId,
      sentAt: m.sentAt,
      type: m.type,
      text: m.text,
      offer: offer,
      replyTo: m.replyTo,
      relatedGigId: m.relatedGigId,
      fileName: m.fileName,
      fileSize: m.fileSize,
    );
    return offer;
  }

  @override
  Future<List<QuickResponse>> quickResponses() async {
    await wait();
    return [...db.quickResponses];
  }

  @override
  Future<QuickResponse> saveQuickResponse(QuickResponse response) async {
    await wait();
    final i = db.quickResponses.indexWhere((q) => q.id == response.id);
    if (i >= 0) {
      db.quickResponses[i] = response;
    } else {
      db.quickResponses.add(response);
    }
    return response;
  }

  @override
  Future<List<String>> labels() async {
    await wait();
    return [...db.labels];
  }

  @override
  Future<void> addLabel(String label) async {
    await wait();
    if (!db.labels.contains(label)) db.labels.add(label);
  }
}

// ===================================================================== ACCOUNT
class MockAccountRepository with _Latency implements AccountRepository {
  MockAccountRepository(this.db, {this.latency = const Duration(milliseconds: 250)});
  final MockDb db;
  @override
  final Duration latency;

  @override
  Future<List<SavedList>> savedLists(String userId) async {
    await wait();
    return [...db.savedLists];
  }

  @override
  Future<SavedList> saveList(SavedList list) async {
    await wait();
    final i = db.savedLists.indexWhere((l) => l.id == list.id);
    if (i >= 0) {
      db.savedLists[i] = list;
    } else {
      db.savedLists.add(list);
    }
    return list;
  }

  @override
  Future<void> deleteList(String listId) async {
    await wait();
    db.savedLists.removeWhere((l) => l.id == listId);
  }

  @override
  Future<List<AppNotification>> notifications(String userId) async {
    await wait();
    return [...db.notifications];
  }

  @override
  Future<void> markNotificationsRead(String userId) async {
    await wait();
    db.notifications = [for (final n in db.notifications) n.copyWith(read: true)];
  }

  @override
  Future<List<String>> browsingHistory(String userId) async {
    await wait();
    return [...db.history];
  }

  @override
  Future<void> addToHistory(String userId, String gigId) async {
    db.history
      ..remove(gigId)
      ..insert(0, gigId);
  }

  @override
  Future<void> clearHistory(String userId, {String? gigId}) async {
    await wait();
    if (gigId == null) {
      db.history.clear();
    } else {
      db.history.remove(gigId);
    }
  }

  @override
  Future<Set<String>> interests(String userId) async {
    await wait();
    return {...db.interests};
  }

  @override
  Future<void> saveInterests(String userId, Set<String> subcategoryIds) async {
    await wait();
    db.interests = {...subcategoryIds};
  }

  @override
  Future<SellerStats> sellerStats(String userId) async {
    await wait();
    return MockData.sellerStats();
  }

  @override
  Future<List<LevelRequirement>> levelRequirements() async {
    await wait();
    return MockData.levelRequirements;
  }

  @override
  Future<Availability?> availability(String userId) async {
    await wait();
    return db.availability;
  }

  @override
  Future<void> saveAvailability(String userId, Availability? availability) async {
    await wait();
    db.availability = availability;
  }

  @override
  Future<List<Brief>> briefs(String userId) async {
    await wait();
    return MockData.briefs();
  }

  @override
  Future<void> sendFeedback(FeedbackEntry entry) async {
    await wait();
    db.feedback.add(entry);
  }

  @override
  Future<int> balance(String userId) async {
    await wait();
    return 0;
  }
}
