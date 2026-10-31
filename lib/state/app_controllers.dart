import 'package:flutter/material.dart';

import '../data/models/account.dart';
import '../data/models/catalog.dart';
import '../data/models/chat.dart';
import '../data/models/order.dart';
import '../data/repositories/repositories.dart';

/// Cài đặt giao diện, ngôn ngữ, tiền tệ, thông báo.
class SettingsController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  /// Ngôn ngữ giao diện: 'vi' hoặc 'en'.
  Locale locale = const Locale('vi');
  String currency = 'VND - ₫';
  bool onlineStatus = true;

  /// Khoá thông báo (dịch nhãn bằng `notificationKeyLabel`) -> bật/tắt cho thông báo đẩy.
  final Map<String, bool> push = {
    'inbox': true,
    'orderMessages': true,
    'orderUpdates': true,
    'ratingReminders': true,
    'buyerBriefs': true,
    'myGigs': true,
    'myAccount': true,
    'promotions': true,
  };
  final Map<String, bool> email = {'inbox': true, 'orderUpdates': true, 'promotions': false};

  void setThemeMode(ThemeMode m) {
    themeMode = m;
    notifyListeners();
  }

  /// Tên ngôn ngữ hiện tại (viết bằng chính ngôn ngữ đó).
  String get languageName => locale.languageCode == 'en' ? 'English' : 'Tiếng Việt';

  void setLocale(Locale v) {
    locale = v;
    notifyListeners();
  }

  void setCurrency(String v) {
    currency = v;
    notifyListeners();
  }

  void setOnline(bool v) {
    onlineStatus = v;
    notifyListeners();
  }

  void setPush(String key, bool v) {
    push[key] = v;
    notifyListeners();
  }

  void setEmail(String key, bool v) {
    email[key] = v;
    notifyListeners();
  }
}

/// Danh sách đã lưu + lịch sử xem.
class SavedController extends ChangeNotifier {
  SavedController(this._repo);
  final AccountRepository _repo;
  String _userId = '';

  List<SavedList> lists = [];
  List<String> history = [];
  bool loaded = false;

  Future<void> load(String userId) async {
    _userId = userId;
    lists = await _repo.savedLists(userId);
    history = await _repo.browsingHistory(userId);
    loaded = true;
    notifyListeners();
  }

  bool isGigSaved(String gigId) => lists.any((l) => l.gigIds.contains(gigId));
  bool isSellerSaved(String sellerId) => lists.any((l) => l.sellerIds.contains(sellerId));

  SavedList? byId(String id) {
    for (final l in lists) {
      if (l.id == id) return l;
    }
    return null;
  }

  Future<SavedList> createList(String name) async {
    final l = await _repo.saveList(SavedList(id: 'l_${DateTime.now().microsecondsSinceEpoch}', name: name.trim()));
    lists = [...lists, l];
    notifyListeners();
    return l;
  }

  Future<void> _replace(SavedList l) async {
    await _repo.saveList(l);
    lists = [for (final e in lists) e.id == l.id ? l : e];
    notifyListeners();
  }

  Future<void> rename(String listId, String name) => _replace(byId(listId)!.copyWith(name: name.trim()));
  Future<void> setPublic(String listId, bool v) => _replace(byId(listId)!.copyWith(isPublic: v));

  Future<void> deleteList(String listId) async {
    await _repo.deleteList(listId);
    lists = lists.where((l) => l.id != listId).toList();
    notifyListeners();
  }

  /// Thêm/bỏ gig khỏi một danh sách cụ thể.
  Future<void> toggleGigInList(String listId, String gigId) async {
    final l = byId(listId)!;
    final ids = [...l.gigIds];
    ids.contains(gigId) ? ids.remove(gigId) : ids.add(gigId);
    await _replace(l.copyWith(gigIds: ids));
  }

  Future<void> toggleSellerInList(String listId, String sellerId) async {
    final l = byId(listId)!;
    final ids = [...l.sellerIds];
    ids.contains(sellerId) ? ids.remove(sellerId) : ids.add(sellerId);
    await _replace(l.copyWith(sellerIds: ids));
  }

  /// Bỏ gig khỏi mọi danh sách.
  Future<void> unsaveGig(String gigId) async {
    for (final l in lists.where((l) => l.gigIds.contains(gigId)).toList()) {
      await _replace(l.copyWith(gigIds: l.gigIds.where((g) => g != gigId).toList()));
    }
  }

  Future<void> unsaveSeller(String sellerId) async {
    for (final l in lists.where((l) => l.sellerIds.contains(sellerId)).toList()) {
      await _replace(l.copyWith(sellerIds: l.sellerIds.where((g) => g != sellerId).toList()));
    }
  }

  Future<void> visit(String gigId) async {
    await _repo.addToHistory(_userId, gigId);
    history = [gigId, ...history.where((g) => g != gigId)];
    notifyListeners();
  }

  Future<void> clearHistory({String? gigId}) async {
    await _repo.clearHistory(_userId, gigId: gigId);
    history = gigId == null ? [] : history.where((g) => g != gigId).toList();
    notifyListeners();
  }
}

/// Đơn hàng của người dùng (cả vai trò người mua và người bán).
class OrdersController extends ChangeNotifier {
  OrdersController(this._repo);
  final OrderRepository _repo;
  String _userId = '';

  List<Order> buying = [];
  List<Order> selling = [];
  bool loading = false;

  Future<void> load(String userId) async {
    _userId = userId;
    loading = true;
    notifyListeners();
    buying = await _repo.buyerOrders(userId);
    selling = await _repo.sellerOrders(userId);
    loading = false;
    notifyListeners();
  }

  Future<void> refresh() => load(_userId);

  Order? byId(String id) {
    for (final o in [...buying, ...selling]) {
      if (o.id == id) return o;
    }
    return null;
  }

  Order _merge(Order o) {
    void up(List<Order> l) {
      final i = l.indexWhere((e) => e.id == o.id);
      if (i >= 0) {
        l[i] = o;
      } else {
        l.insert(0, o);
      }
    }

    if (o.buyerId == _userId) up(buying);
    if (o.sellerId == _userId) up(selling);
    notifyListeners();
    return o;
  }

  Future<Order?> fetch(String id) async {
    final o = await _repo.orderById(id);
    if (o != null) _merge(o);
    return o;
  }

  Future<Order> place({required Gig gig, required CheckoutDraft draft, required String paymentMethod}) async =>
      _merge(await _repo.placeOrder(buyerId: _userId, gig: gig, draft: draft, paymentMethod: paymentMethod));

  Future<Order> placeOffer(CustomOffer offer) async =>
      _merge(await _repo.placeOfferOrder(buyerId: _userId, offer: offer));

  Future<Order> submitRequirements(String id, Map<String, String> answers) async =>
      _merge(await _repo.submitRequirements(id, answers));
  Future<Order> deliver(String id, Delivery d) async => _merge(await _repo.deliver(id, d));
  Future<Order> approve(String id) async => _merge(await _repo.approveDelivery(id));
  Future<Order> requestRevision(String id, String msg) async => _merge(await _repo.requestRevision(id, msg));
  Future<Order> requestExtension(
    String id, {
    required int days,
    required String message,
    required bool fromSeller,
  }) async => _merge(await _repo.requestExtension(id, days: days, message: message, fromSeller: fromSeller));
  Future<Order> respond(String id, {required bool accept}) async =>
      _merge(await _repo.respondToRequest(id, accept: accept));
  Future<Order> extendReview(String id, int days) async => _merge(await _repo.extendReviewTime(id, days));
  Future<Order> requestCancel(String id, {required String reason, required String message}) async =>
      _merge(await _repo.requestCancel(id, reason: reason, message: message));
  Future<Order> review(String id, OrderReview r) async => _merge(await _repo.leaveReview(id, r));
  Future<Order> reviewBuyer(String id, String text, int rating) async =>
      _merge(await _repo.reviewBuyer(id, text, rating));
  Future<Order> tip(String id, int amount) async => _merge(await _repo.tip(id, amount));
  Future<Order> addExtra(String id, GigExtra e) async => _merge(await _repo.addExtra(id, e));

  int get activeBuyingCount => buying.where((o) => o.status.isActive).length;
  int get activeSellingCount => selling.where((o) => o.status.isActive).length;
}

/// Hộp thư.
class InboxController extends ChangeNotifier {
  InboxController(this._repo);
  final ChatRepository _repo;
  String _userId = '';

  List<Conversation> conversations = [];
  List<String> labels = [];
  bool loading = false;

  int get unreadCount => conversations.where((c) => !c.archived && c.unread > 0).length;

  Future<void> load(String userId) async {
    _userId = userId;
    loading = true;
    notifyListeners();
    conversations = await _repo.conversations(userId);
    labels = await _repo.labels();
    loading = false;
    notifyListeners();
  }

  Future<void> refresh() => load(_userId);

  Conversation? byId(String id) {
    for (final c in conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<Conversation> open(String otherUserId) async {
    final c = await _repo.conversationWith(_userId, otherUserId);
    if (byId(c.id) == null) conversations = [c, ...conversations];
    notifyListeners();
    return c;
  }

  Future<void> update(Conversation c) async {
    await _repo.updateConversation(c);
    conversations = [for (final e in conversations) e.id == c.id ? c : e];
    notifyListeners();
  }

  Future<void> updateMany(Iterable<Conversation> list) async {
    for (final c in list) {
      await _repo.updateConversation(c);
    }
    final map = {for (final c in list) c.id: c};
    conversations = [for (final e in conversations) map[e.id] ?? e];
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await _repo.deleteConversation(id);
    conversations = conversations.where((c) => c.id != id).toList();
    notifyListeners();
  }

  Future<void> markRead(String id) async {
    final c = byId(id);
    if (c != null && c.unread > 0) await update(c.copyWith(unread: 0));
  }

  Future<void> addLabel(String label) async {
    await _repo.addLabel(label);
    labels = [...labels, label];
    notifyListeners();
  }

  Future<List<ChatMessage>> messages(String conversationId) => _repo.messages(conversationId);

  Future<ChatMessage> send(ChatMessage m) async {
    final sent = await _repo.send(m);
    conversations = await _repo.conversations(_userId);
    notifyListeners();
    return sent;
  }

  Future<CustomOffer> updateOffer(String messageId, OfferStatus status) => _repo.updateOffer(messageId, status);
  Future<List<QuickResponse>> quickResponses() => _repo.quickResponses();
  Future<QuickResponse> saveQuickResponse(QuickResponse r) => _repo.saveQuickResponse(r);
}

/// Thông báo.
class NotificationsController extends ChangeNotifier {
  NotificationsController(this._repo);
  final AccountRepository _repo;
  String _userId = '';
  List<AppNotification> items = [];

  int get unreadCount => items.where((n) => !n.read).length;

  Future<void> load(String userId) async {
    _userId = userId;
    items = await _repo.notifications(userId);
    notifyListeners();
  }

  Future<void> markAllRead() async {
    await _repo.markNotificationsRead(_userId);
    items = [for (final n in items) n.copyWith(read: true)];
    notifyListeners();
  }

  void remove(String id) {
    items = items.where((n) => n.id != id).toList();
    notifyListeners();
  }
}
