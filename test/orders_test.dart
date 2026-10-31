import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:viet_gig/data/models/order.dart';
import 'package:viet_gig/features/orders/manage_orders_screen.dart';
import 'package:viet_gig/state/app_controllers.dart';
import 'package:viet_gig/state/session_controller.dart';

import 'helpers.dart';

OrdersController _orders(WidgetTester tester) =>
    Provider.of<OrdersController>(tester.element(find.byType(Navigator).first), listen: false);

Order _order(WidgetTester tester, String id) => _orders(tester).byId(id)!;

/// Cuộn danh sách dọc đầu tiên cho tới khi thấy [f] (ListView dựng lười).
Future<void> _reveal(WidgetTester tester, Finder f) async {
  if (f.evaluate().isEmpty) {
    final s = find.byWidgetPredicate((w) => w is Scrollable && axisDirectionToAxis(w.axisDirection) == Axis.vertical);
    try {
      await tester.scrollUntilVisible(f, 200, scrollable: s.first, maxScrolls: 20);
    } on StateError {
      await tester.scrollUntilVisible(f, -200, scrollable: s.first, maxScrolls: 40);
    }
    await settle(tester, 8);
  }
  await tester.ensureVisible(f.first);
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await _reveal(tester, f);
  await tester.pump();
  await tester.tap(f.first);
  await settle(tester, 12);
}

Future<void> _tapKey(WidgetTester tester, String key) => _tap(tester, find.byKey(ValueKey(key)));

Future<void> _enter(WidgetTester tester, String key, String text) async {
  final f = find.byKey(ValueKey(key));
  await _reveal(tester, f);
  await tester.enterText(f, text);
  await tester.pump();
}

void main() {
  testWidgets('Danh sách đơn có tab và số đếm đúng', (tester) async {
    await pumpApp(tester, location: '/orders');
    expect(tester.takeException(), isNull);
    expect(find.text('Quản lý đơn hàng'), findsOneWidget);
    expect(find.text('Đang thực hiện (1)'), findsOneWidget);
    expect(find.text('Đã giao (1)'), findsOneWidget);
    expect(find.text('Hoàn thành (0)'), findsOneWidget);
    expect(find.text('Đã huỷ (1)'), findsOneWidget);
    expect(find.text('Đến hạn trong 2–5 ngày'), findsOneWidget);
    expect(find.byKey(const ValueKey('order_card_a8f21c')), findsOneWidget);

    await _tap(tester, find.text('Đã huỷ (1)'));
    expect(find.byKey(const ValueKey('order_card_f0e912')), findsOneWidget);

    await _tap(tester, find.text('Hoàn thành (0)'));
    expect(find.text('Tất cả đơn hàng của bạn ở đây'), findsOneWidget);

    // Bộ lọc
    await _tapKey(tester, 'orders_filter');
    expect(find.text('Sắp xếp & lọc'), findsOneWidget);
    await _tapKey(tester, 'sort_newest');
    await _tapKey(tester, 'filter_apply');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Chế độ người bán hiển thị đơn của khách', (tester) async {
    await pumpApp(tester, location: '/orders');
    final ctx = tester.element(find.byType(ManageOrdersScreen));
    await ctx.read<SessionController>().setSellerMode(true);
    await settle(tester);
    expect(find.text('Cần xử lý (0)'), findsOneWidget);
    expect(find.text('Đang thực hiện (1)'), findsOneWidget);
    await _tap(tester, find.text('Đang thực hiện (1)'));
    expect(find.byKey(const ValueKey('order_card_b55e01')), findsOneWidget);
  });

  testWidgets('Đơn không tồn tại hiển thị trạng thái rỗng', (tester) async {
    await pumpApp(tester, location: '/orders/khongco');
    expect(find.text('Không tìm thấy đơn hàng'), findsOneWidget);
  });

  testWidgets('Đặt hàng: chọn extra → xem lại → MoMo → thanh toán → gửi yêu cầu', (tester) async {
    await pumpApp(tester, location: '/checkout/g_logo3?pkg=1');
    expect(find.text('Nâng cấp'), findsOneWidget);
    final before = _orders(tester).buying.length;

    await _tapKey(tester, 'extra_x_page');
    await _tapKey(tester, 'qty_x_page_plus');
    // 2.375.000 + 2 x 125.000
    expect(find.textContaining('2.625.000'), findsWidgets);
    await _tapKey(tester, 'checkout_continue');
    expect(find.text('Xem lại đơn hàng'), findsOneWidget);
    expect(find.textContaining('Thêm trang/màn hình x2'), findsOneWidget);

    // Thẻ chưa có -> nút thêm phương thức
    expect(find.byKey(const ValueKey('add_payment_method')), findsOneWidget);

    // Mã khuyến mãi
    await _tapKey(tester, 'promo_enter');
    await tester.enterText(find.byKey(const ValueKey('promo_field')), 'sai');
    await _tapKey(tester, 'promo_apply');
    expect(find.text('Mã không hợp lệ hoặc đã hết hạn'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('promo_field')), 'VIETGIG10');
    await _tapKey(tester, 'promo_apply');
    expect(find.textContaining('VIETGIG10'), findsWidgets);

    await _tapKey(tester, 'method_1');
    await _tapKey(tester, 'pay_button');
    await settle(tester);
    expect(find.text('Tuyệt vời! Đơn hàng đã được tạo'), findsOneWidget);
    expect(_orders(tester).buying.length, before + 1);
    final created = _orders(tester).buying.first;
    expect(created.paymentMethod, 'MoMo');
    expect(created.extras, ['Thêm trang/màn hình x2']);
    expect(created.status, OrderStatus.awaitingRequirements);

    await _tapKey(tester, 'success_ok');
    await settle(tester);
    // Màn hình yêu cầu mở trên chi tiết đơn
    expect(find.byKey(const ValueKey('submit_requirements')), findsOneWidget);
    FilledButton btn() => tester.widget<FilledButton>(
      find.descendant(of: find.byKey(const ValueKey('submit_requirements')), matching: find.byType(FilledButton)),
    );
    expect(btn().onPressed, isNull);

    await _enter(tester, 'req_text_0', 'Màu xanh lá, font Inter, phong cách tối giản.');
    await _tapKey(tester, 'req_choice_1_0');
    await _tapKey(tester, 'req_attach_2');
    await _tap(tester, find.text('Tệp'));
    expect(find.text('Tệp-PDF.pdf'), findsOneWidget);
    expect(btn().onPressed, isNotNull);
    await _tapKey(tester, 'submit_requirements');
    await settle(tester);

    final o = _order(tester, created.id);
    expect(o.status, OrderStatus.inProgress);
    expect(o.requirementAnswers.length, 3);
    expect(find.text('Hoạt động'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Thanh toán bằng thẻ: thêm thẻ mới hợp lệ', (tester) async {
    await pumpApp(tester, location: '/checkout/g_logo3?pkg=0');
    await _tapKey(tester, 'checkout_continue');
    await _tapKey(tester, 'add_payment_method');
    expect(find.text('Thêm thẻ mới'), findsOneWidget);
    FilledButton submit() => tester.widget<FilledButton>(
      find.descendant(of: find.byKey(const ValueKey('card_submit')), matching: find.byType(FilledButton)),
    );
    expect(submit().onPressed, isNull);

    await _enter(tester, 'card_number', '4242424242424241');
    expect(find.text('Số thẻ không hợp lệ'), findsOneWidget);
    await _enter(tester, 'card_number', '4242424242424242');
    expect(find.text('4242 4242 4242 4242'), findsOneWidget);
    await _enter(tester, 'card_last', 'Nguyễn');
    await _enter(tester, 'card_first', 'Minh Anh');
    await _enter(tester, 'card_exp', '1230');
    await _enter(tester, 'card_cvv', '123');
    expect(submit().onPressed, isNotNull);
    await _tapKey(tester, 'card_submit');
    await settle(tester);

    expect(find.text('Xem lại đơn hàng'), findsOneWidget);
    expect(find.byKey(const ValueKey('pay_button')), findsOneWidget);
    await _tapKey(tester, 'pay_button');
    await settle(tester);
    expect(find.text('Tuyệt vời! Đơn hàng đã được tạo'), findsOneWidget);
    expect(_orders(tester).buying.first.paymentMethod, 'Thẻ tín dụng/ghi nợ');
    await _tapKey(tester, 'success_ok');
    await settle(tester);
  });

  testWidgets('Duyệt bản giao → hoàn thành → đánh giá 5 sao → tip', (tester) async {});

  testWidgets('Đổi sang tiếng Anh: chi tiết đơn đã giao hiển thị tiếng Anh', (tester) async {
    await pumpApp(tester, location: '/orders/c31d77');
    expect(find.text('Đây là bản giao của bạn'), findsOneWidget);
    expect(find.byKey(const ValueKey('review_deadline')), findsOneWidget);

    await _tapKey(tester, 'download_all');
    expect(find.textContaining('Đang tải 2 tệp'), findsOneWidget);

    await _tapKey(tester, 'approve_delivery');
    expect(find.text('Sẵn sàng nhận bản cuối?'), findsOneWidget);
    await _tapKey(tester, 'confirm_ok');
    await settle(tester);
    expect(_order(tester, 'c31d77').status, OrderStatus.completed);

    // Bước 1: chất lượng
    expect(find.text('Bạn đánh giá chất lượng bản giao thế nào?'), findsOneWidget);
    await _tapKey(tester, 'star_5');
    await _tapKey(tester, 'rate_next');
    // Bước 2: điểm nổi bật
    expect(find.text('Thật tuyệt! Điều gì khiến nó xuất sắc?'), findsOneWidget);
    await _tapKey(tester, 'chip_Sáng tạo');
    await _tapKey(tester, 'rate_next');
    // Bước 3: giá trị
    expect(find.text('Bạn đánh giá giá trị của bản giao?'), findsOneWidget);
    await _tapKey(tester, 'star_5');
    await _tapKey(tester, 'rate_next');
    // Bước 4: đánh giá công khai
    expect(find.text('Viết đánh giá công khai'), findsOneWidget);
    await _enter(tester, 'review_text', 'Ngắn');
    FilledButton submit() => tester.widget<FilledButton>(
      find.descendant(of: find.byKey(const ValueKey('review_submit')), matching: find.byType(FilledButton)),
    );
    expect(submit().onPressed, isNull);
    await _enter(tester, 'review_text', 'Logo rất đẹp, Bảo làm việc chuyên nghiệp và nhanh chóng!');
    await _tapKey(tester, 'review_submit');
    await settle(tester);
    final reviewed = _order(tester, 'c31d77');
    expect(reviewed.review?.overall, 5);
    expect(reviewed.review?.highlights, ['Sáng tạo']);

    // Bước 5: tip
    expect(find.text('Cảm ơn bạn đã đánh giá!'), findsOneWidget);
    await _tapKey(tester, 'tip_custom');
    await tester.enterText(find.byKey(const ValueKey('tip_custom_field')), '1000');
    await _tapKey(tester, 'tip_custom_apply');
    expect(find.text('Số tiền tối thiểu là 25.000 ₫'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('tip_custom_field')), '70000');
    await _tapKey(tester, 'tip_custom_apply');
    await _tapKey(tester, 'tip_50000');
    await _tapKey(tester, 'tip_send');
    await settle(tester);
    expect(_order(tester, 'c31d77').tip, 50000);
    // Quay về chi tiết đơn
    expect(find.text('Đơn hàng đã hoàn thành'), findsWidgets);
    expect(find.textContaining('Bạn đã tip'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Yêu cầu chỉnh sửa và thêm thời gian xem', (tester) async {
    await pumpApp(tester, location: '/orders/c31d77');
    final oldDeadline = _order(tester, 'c31d77').reviewDeadline!;

    await _tapKey(tester, 'not_ready');
    await _tapKey(tester, 'sheet_more_time');
    await _tapKey(tester, 'review_days_2');
    expect(find.textContaining('Hạn duyệt mới'), findsOneWidget);
    await _tapKey(tester, 'review_days_submit');
    await settle(tester);
    expect(_order(tester, 'c31d77').reviewDeadline, oldDeadline.add(const Duration(days: 2)));

    await _tapKey(tester, 'not_ready');
    await _tapKey(tester, 'sheet_revision');
    await _enter(tester, 'revision_field', 'Vui lòng đổi màu chủ đạo sang xanh đậm hơn.');
    await _tapKey(tester, 'revision_submit');
    await settle(tester);
    final o = _order(tester, 'c31d77');
    expect(o.status, OrderStatus.revisionRequested);
    expect(o.events.last.body, 'Vui lòng đổi màu chủ đạo sang xanh đậm hơn.');
    expect(find.text('Đây là bản giao của bạn'), findsNothing);
  });

  testWidgets('Yêu cầu huỷ qua Trung tâm giải quyết', (tester) async {
    await pumpApp(tester, location: '/orders/a8f21c');
    expect(find.byKey(const ValueKey('timeline_due')), findsOneWidget);
    await _tapKey(tester, 'order_more');
    await _tap(tester, find.text('Trung tâm giải quyết'));
    expect(find.text('Chúng tôi giúp gì được cho bạn?'), findsOneWidget);

    await _tapKey(tester, 'res_cancel');
    FilledButton submit() => tester.widget<FilledButton>(
      find.descendant(of: find.byKey(const ValueKey('cancel_submit')), matching: find.byType(FilledButton)),
    );
    expect(submit().onPressed, isNull);
    await _enter(tester, 'cancel_message', 'Mình đổi kế hoạch, xin lỗi bạn nhé.');
    await _tapKey(tester, 'cancel_reason_1');
    await _tapKey(tester, 'cancel_submit');
    await settle(tester);

    final o = _order(tester, 'a8f21c');
    expect(o.status, OrderStatus.disputed);
    expect(o.pendingRequest?.kind, 'cancel');
    // Về chi tiết: hiển thị đang chờ phản hồi
    expect(find.byKey(const ValueKey('pending_request')), findsOneWidget);
    expect(find.textContaining('Đang chờ phản hồi'), findsOneWidget);

    // Mở lại trung tâm giải quyết -> đang giải quyết tranh chấp
    await _tapKey(tester, 'order_more');
    await _tap(tester, find.text('Trung tâm giải quyết'));
    expect(find.byKey(const ValueKey('dispute_in_progress')), findsOneWidget);
  });

  testWidgets('Yêu cầu cập nhật tiến độ gửi tin nhắn', (tester) async {
    await pumpApp(tester, location: '/orders/a8f21c');
    await _tapKey(tester, 'order_more');
    await _tap(tester, find.text('Trung tâm giải quyết'));
    await _tapKey(tester, 'res_update');
    await _enter(tester, 'update_field', 'Chào bạn, đơn tới đâu rồi?');
    await _tapKey(tester, 'update_send');
    expect(find.textContaining('Đã gửi yêu cầu cập nhật'), findsOneWidget);
    expect(find.byKey(const ValueKey('timeline_due')), findsOneWidget);
  });

  testWidgets('Người bán giao đơn b55e01 và gia hạn', (tester) async {
    await pumpApp(tester, location: '/orders/b55e01');
    expect(find.byKey(const ValueKey('deliver_button')), findsOneWidget);
    await _tapKey(tester, 'deliver_button');
    expect(find.text('Giao hàng'), findsOneWidget);

    await _tapKey(tester, 'quick_response');
    await settle(tester);
    final qr = find.byType(ListTile);
    if (qr.evaluate().isNotEmpty) {
      await _tap(tester, qr.first);
    }
    await _enter(tester, 'deliver_message', 'Chào bạn, mình gửi bản thiết kế hoàn chỉnh nhé. Cảm ơn bạn!');
    await _tapKey(tester, 'deliver_attach');
    await _tap(tester, find.text('Tệp'));
    await settle(tester);
    expect(find.text('Tệp-PDF.pdf'), findsOneWidget);
    await _tapKey(tester, 'deliver_submit');
    await settle(tester);

    final o = _order(tester, 'b55e01');
    expect(o.status, OrderStatus.delivered);
    expect(o.deliveries.last.files, ['Tệp-PDF.pdf']);
    expect(find.text('Bạn đã giao đơn hàng'), findsOneWidget);
  });

  testWidgets('Người bán yêu cầu gia hạn và người mua phản hồi được mô phỏng', (tester) async {
    await pumpApp(tester, location: '/orders/b55e01');
    await _tapKey(tester, 'seller_extend');
    await _tapKey(tester, 'res_extend');
    await _tapKey(tester, 'extend_plus');
    expect(find.text('Dự kiến giao ngày'), findsOneWidget);
    await _enter(tester, 'extend_message', 'Mình cần thêm 2 ngày để hoàn thiện.');
    await _tapKey(tester, 'extend_submit');
    await settle(tester);
    final o = _order(tester, 'b55e01');
    expect(o.pendingRequest?.extraDays, 2);
    expect(o.pendingRequest?.fromSeller, isTrue);
    expect(find.textContaining('Đang chờ phản hồi'), findsOneWidget);
  });

  testWidgets('Thêm dịch vụ vào đơn đang thực hiện', (tester) async {
    await pumpApp(tester, location: '/orders/a8f21c');
    final before = _order(tester, 'a8f21c').subtotal;
    await _tapKey(tester, 'add_extra_x_page');
    await _tapKey(tester, 'confirm_ok');
    await settle(tester);
    expect(_order(tester, 'a8f21c').subtotal, before + 125000);
  });

  testWidgets('Không tràn bố cục ở màn hình hẹp 360px', (tester) async {
    for (final loc in [
      '/orders',
      '/orders/a8f21c',
      '/orders/c31d77',
      '/orders/f0e912',
      '/orders/b55e01',
      '/orders/a8f21c/resolution',
      '/orders/b55e01/deliver',
      '/checkout/g_logo3?pkg=2',
      '/add-card',
    ]) {
      await pumpApp(tester, location: loc, size: const Size(360, 740));
      expect(tester.takeException(), isNull, reason: loc);
    }
  });

  testWidgets('Đổi sang tiếng Anh: danh sách đơn hiển thị tiếng Anh', (tester) async {
    await pumpApp(tester, location: '/orders');
    Provider.of<SettingsController>(
      tester.element(find.byType(Navigator).first),
      listen: false,
    ).setLocale(const Locale('en'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Manage orders'), findsOneWidget);
    expect(find.text('In progress (1)'), findsOneWidget);
    expect(find.text('Delivered (1)'), findsOneWidget);
    expect(find.text('Cancelled (1)'), findsOneWidget);
    expect(find.text('Due in 2–5 days'), findsOneWidget);
    expect(find.text('Quản lý đơn hàng'), findsNothing);
  });

  testWidgets('Đổi sang tiếng Anh: chi tiết đơn đã giao hiển thị tiếng Anh', (tester) async {
    await pumpApp(tester, location: '/orders/c31d77');
    Provider.of<SettingsController>(
      tester.element(find.byType(Navigator).first),
      listen: false,
    ).setLocale(const Locale('en'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('DELIVERED'), findsWidgets);
    await _reveal(tester, find.text('Approve delivery'));
    expect(find.text('Approve delivery'), findsOneWidget);
    expect(find.text('Duyệt bản giao'), findsNothing);
    await _reveal(tester, find.text('Activity'));
    expect(find.text('Activity'), findsOneWidget);
  });
}
