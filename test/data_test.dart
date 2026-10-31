import 'package:flutter_test/flutter_test.dart';
import 'package:viet_gig/core/utils/format.dart';
import 'package:viet_gig/data/mock/mock_data.dart';
import 'package:viet_gig/data/mock/mock_repositories.dart';
import 'package:viet_gig/data/models/catalog.dart';
import 'package:viet_gig/data/models/chat.dart';
import 'package:viet_gig/data/models/order.dart';
import 'package:viet_gig/data/models/user.dart';
import 'package:viet_gig/data/repositories/repositories.dart';
import 'package:viet_gig/state/app_controllers.dart';
import 'package:viet_gig/state/session_controller.dart';

void main() {
  late MockDb db;
  const z = Duration.zero;

  setUp(() => db = MockDb());

  group('Định dạng', () {
    test('tiền VND', () {
      expect(Fmt.money(250000), '250.000 ₫');
      expect(Fmt.moneyShort(1500000), '1,5Tr');
      expect(Fmt.moneyShort(250000), '250K');
    });
    test('ngày & đếm ngược', () {
      expect(Fmt.date(DateTime(2026, 6, 9)), '09/06/2026');
      final now = DateTime(2026, 1, 1, 10);
      final c = Fmt.countdown(now.add(const Duration(days: 2, hours: 3, minutes: 5)), now: now);
      expect((c.days, c.hours, c.minutes), (2, 3, 5));
      expect(Fmt.ago(now.subtract(const Duration(hours: 2)), now: now), '2 giờ trước');
    });
  });

  group('Auth', () {
    test('đăng nhập sai mật khẩu báo lỗi', () async {
      final auth = MockAuthRepository(db, latency: z);
      expect(() => auth.signIn(emailOrUsername: 'minhanh@gmail.com', password: 'sai'), throwsA(isA<AuthException>()));
    });

    test('đăng nhập đúng bằng email hoặc username', () async {
      final auth = MockAuthRepository(db, latency: z);
      final u = await auth.signIn(emailOrUsername: 'MinhAnh_VG', password: 'Matkhau1');
      expect(u.id, MockData.meId);
      expect(auth.currentUser, isNotNull);
    });

    test('đăng ký trùng username bị từ chối', () async {
      final auth = MockAuthRepository(db, latency: z);
      expect(
        () => auth.signUp(username: 'baologo', email: 'x@y.com', password: 'Abcdefg1'),
        throwsA(isA<AuthException>()),
      );
    });

    test('không xoá được tài khoản khi còn đơn đang chạy', () async {
      final auth = MockAuthRepository(db, latency: z);
      await auth.signIn(emailOrUsername: 'minhanh@gmail.com', password: 'Matkhau1');
      expect(() => auth.deleteAccount(reason: 'Khác'), throwsA(isA<AuthException>()));
    });

    test('SessionController: đăng ký cần onboarding, bật chế độ người bán', () async {
      final s = SessionController(MockAuthRepository(db, latency: z));
      await s.restore();
      expect(s.status, SessionStatus.signedOut);
      await s.signUp('nguoimoi', 'moi@gmail.com', 'Matkhau1');
      expect(s.isSignedIn, isTrue);
      expect(s.needsOnboarding, isTrue);
      s.skipOnboarding();
      await s.setSellerMode(true);
      expect(s.sellerMode, isTrue);
      expect(s.user!.isSeller, isTrue);
      await s.signOut();
      expect(s.status, SessionStatus.signedOut);
      expect(s.sellerMode, isFalse);
    });
  });

  group('Tìm kiếm', () {
    test('theo từ khoá', () async {
      final c = MockCatalogRepository(db, latency: z);
      final r = await c.search(const GigFilter(query: 'logo'));
      expect(r, isNotEmpty);
      expect(r.every((g) => '${g.title} ${g.tags}'.toLowerCase().contains('logo')), isTrue);
    });

    test('lọc giá, Pro, cấp người bán và sắp xếp', () async {
      final c = MockCatalogRepository(db, latency: z);
      final all = await c.search(const GigFilter());
      final cheap = await c.search(const GigFilter(maxPrice: 300000));
      expect(cheap.length, lessThan(all.length));
      expect(cheap.every((g) => g.priceFrom <= 300000), isTrue);
      final pro = await c.search(const GigFilter(proOnly: true));
      expect(pro.every((g) => g.isPro), isTrue);
      final top = await c.search(GigFilter(sellerLevels: {SellerLevel.topRated.name}));
      expect(top.every((g) => g.sellerId == 'u_hoang' || g.sellerId == 'u_bao'), isTrue);
      final sorted = await c.search(const GigFilter(sort: GigSort.priceLow));
      for (var i = 1; i < sorted.length; i++) {
        expect(sorted[i].priceFrom, greaterThanOrEqualTo(sorted[i - 1].priceFrom));
      }
    });

    test('không có kết quả', () async {
      final c = MockCatalogRepository(db, latency: z);
      expect(await c.search(const GigFilter(query: 'xyzkhongton')), isEmpty);
    });
  });

  group('Đơn hàng', () {
    test('đặt hàng tính tiền extra + phí dịch vụ + ngày giao', () async {
      final repo = MockOrderRepository(db, latency: z);
      final gig = db.gigs.firstWhere((g) => g.id == 'g_logo3');
      final o = await repo.placeOrder(
        buyerId: MockData.meId,
        gig: gig,
        draft: const CheckoutDraft(
          gigId: 'g_logo3',
          packageIndex: 1,
          extraIds: {'x_page'},
          extraQuantities: {'x_page': 2},
        ),
        paymentMethod: 'MoMo',
      );
      expect(o.subtotal, 2375000 + 2 * 125000);
      expect(o.serviceFee, MockOrderRepository.serviceFeeFor(o.subtotal));
      expect(o.status, OrderStatus.awaitingRequirements);
      expect(o.dueDate.difference(o.createdAt).inDays, 4 + 2);
    });

    test('vòng đời: yêu cầu → giao → sửa → giao → duyệt → đánh giá → tip', () async {
      final repo = MockOrderRepository(db, latency: z);
      final gig = db.gigs.firstWhere((g) => g.id == 'g_app');
      var o = await repo.placeOrder(
        buyerId: MockData.meId,
        gig: gig,
        draft: const CheckoutDraft(gigId: 'g_app', packageIndex: 0),
        paymentMethod: 'Thẻ',
      );
      o = await repo.submitRequirements(o.id, {'q': 'a'});
      expect(o.status, OrderStatus.inProgress);
      o = await repo.deliver(o.id, Delivery(message: 'Xong', files: const ['a.zip'], at: DateTime.now()));
      expect(o.status, OrderStatus.delivered);
      expect(o.reviewDeadline, isNotNull);
      o = await repo.requestRevision(o.id, 'Sửa màu');
      expect(o.status, OrderStatus.revisionRequested);
      o = await repo.deliver(o.id, Delivery(message: 'Đã sửa', files: const [], at: DateTime.now()));
      o = await repo.approveDelivery(o.id);
      expect(o.status, OrderStatus.completed);
      final before = db.reviews.length;
      o = await repo.leaveReview(o.id, const OrderReview(overall: 5, text: 'Rất tốt, cảm ơn!'));
      expect(o.review, isNotNull);
      expect(db.reviews.length, before + 1);
      o = await repo.tip(o.id, 50000);
      expect(o.tip, 50000);
      expect(o.events.map((e) => e.type), contains(OrderEventType.tipped));
    });

    test('gia hạn: chấp nhận thì dời ngày giao', () async {
      final repo = MockOrderRepository(db, latency: z);
      final due = db.orders.firstWhere((o) => o.id == 'a8f21c').dueDate;
      var o = await repo.requestExtension('a8f21c', days: 2, message: 'Xin thêm 2 ngày', fromSeller: true);
      expect(o.pendingRequest, isNotNull);
      o = await repo.respondToRequest('a8f21c', accept: true);
      expect(o.pendingRequest, isNull);
      expect(o.dueDate, due.add(const Duration(days: 2)));
      expect(o.status, OrderStatus.inProgress);
    });

    test('huỷ: người bán chấp nhận thì đơn bị huỷ', () async {
      final repo = MockOrderRepository(db, latency: z);
      await repo.requestCancel('a8f21c', reason: 'Khác', message: 'Đổi kế hoạch');
      final o = await repo.respondToRequest('a8f21c', accept: true);
      expect(o.status, OrderStatus.cancelled);
    });

    test('OrdersController cập nhật danh sách sau khi thao tác', () async {
      final c = OrdersController(MockOrderRepository(db, latency: z));
      await c.load(MockData.meId);
      expect(c.buying.length, 3);
      expect(c.selling.length, 1);
      await c.approve('c31d77');
      expect(c.byId('c31d77')!.status, OrderStatus.completed);
      expect(c.activeBuyingCount, 1);
    });
  });

  group('Tin nhắn', () {
    test('gửi tin cập nhật xem trước và bỏ lưu trữ', () async {
      final c = InboxController(MockChatRepository(db, latency: z));
      await c.load(MockData.meId);
      expect(c.unreadCount, 1);
      await c.send(
        ChatMessage(id: '', conversationId: 'c_mai', senderId: MockData.meId, sentAt: DateTime.now(), text: 'Chào bạn'),
      );
      final conv = c.byId('c_mai')!;
      expect(conv.lastMessage, 'Chào bạn');
      expect(conv.archived, isFalse);
      expect(c.conversations.first.id, 'c_mai');
    });

    test('mở hội thoại mới với người chưa từng nhắn', () async {
      final c = InboxController(MockChatRepository(db, latency: z));
      await c.load(MockData.meId);
      final conv = await c.open('u_an');
      expect(conv.participantId, 'u_an');
      final again = await c.open('u_an');
      expect(again.id, conv.id);
    });

    test('báo giá cột mốc: tổng giá và cập nhật trạng thái', () async {
      final repo = MockChatRepository(db, latency: z);
      final m = (await repo.messages('c_hoang')).firstWhere((m) => m.type == MessageType.offer);
      expect(m.offer!.totalPrice, 5000000);
      expect(m.offer!.totalDays, 7);
      final o = await repo.updateOffer(m.id, OfferStatus.declined);
      expect(o.status, OfferStatus.declined);
    });
  });

  group('Danh sách đã lưu', () {
    test('tạo, lưu gig, đổi tên, xoá', () async {
      final c = SavedController(MockAccountRepository(db, latency: z));
      await c.load(MockData.meId);
      final l = await c.createList('Yêu thích');
      expect(c.isGigSaved('g_voice'), isFalse);
      await c.toggleGigInList(l.id, 'g_voice');
      expect(c.isGigSaved('g_voice'), isTrue);
      await c.rename(l.id, 'Đã đổi');
      expect(c.byId(l.id)!.name, 'Đã đổi');
      await c.unsaveGig('g_voice');
      expect(c.isGigSaved('g_voice'), isFalse);
      await c.deleteList(l.id);
      expect(c.byId(l.id), isNull);
    });

    test('lịch sử xem: thêm lên đầu, xoá', () async {
      final c = SavedController(MockAccountRepository(db, latency: z));
      await c.load(MockData.meId);
      await c.visit('g_voice');
      expect(c.history.first, 'g_voice');
      await c.clearHistory(gigId: 'g_voice');
      expect(c.history.contains('g_voice'), isFalse);
      await c.clearHistory();
      expect(c.history, isEmpty);
    });
  });
}
