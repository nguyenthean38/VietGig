import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:viet_gig/state/app_controllers.dart';
import 'package:viet_gig/state/session_controller.dart';

import 'helpers.dart';

/// Bật chế độ người bán rồi về tab Trang chủ.
Future<void> enterSellerMode(WidgetTester tester) async {
  final ctx = tester.element(find.byType(Scaffold).first);
  await ctx.read<SessionController>().setSellerMode(true);
  GoRouter.of(ctx).go('/home');
  await settle(tester);
}

void main() {
  testWidgets('Dashboard người bán hiển thị cấp độ, điểm và nav 4 mục', (tester) async {
    // Mở một màn của người bán trước để tránh dựng HomeScreen (người mua).
    await pumpApp(tester, location: '/seller/availability');
    await enterSellerMode(tester);
    expect(tester.takeException(), isNull);

    expect(find.text('Chào mừng trở lại'), findsOneWidget);
    expect(find.text('Cấp độ của tôi'), findsOneWidget);
    expect(find.text('Điểm thành công'), findsOneWidget);
    expect(find.text('4,3'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('1 / 5'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_2')), findsNothing);
    expect(find.byKey(const ValueKey('nav_0')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_4')), findsOneWidget);

    // Đóng banner.
    await tester.tap(find.byKey(const ValueKey('seller_banner_close')));
    await settle(tester, 5);
    expect(find.text('Hoàn thiện hồ sơ người bán'), findsNothing);

    // Mở trang cấp độ.
    await tester.tap(find.byKey(const ValueKey('dash_level')));
    await settle(tester);
    expect(find.text('Tổng quan cấp độ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Thu nhập: số dư, đổi khoảng thời gian, rút tiền', (tester) async {
    await pumpApp(tester, location: '/seller/earnings');
    expect(tester.takeException(), isNull);
    expect(find.text('Có thể rút'), findsWidgets);
    expect(find.byKey(const ValueKey('earnings_available')), findsOneWidget);
    expect(find.text('30 ngày qua'), findsOneWidget);
    expect(find.text('Tổng thu nhập: 125.000 ₫'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('earnings_range')));
    await settle(tester, 10);
    await tester.tap(find.text('Năm ngoái'));
    await settle(tester, 10);
    expect(find.text('Năm ngoái'), findsOneWidget);
    expect(find.text('Tổng thu nhập: 0 ₫'), findsOneWidget);

    // Tab đơn hoàn thành.
    await tester.tap(find.byKey(const ValueKey('earnings_tab_1')));
    await settle(tester, 5);
    expect(find.text('Tổng đơn hoàn thành: 0'), findsOneWidget);

    // Rút tiền qua MoMo.
    await tester.tap(find.byKey(const ValueKey('earnings_withdraw')));
    await settle(tester, 10);
    await tester.tap(find.text('Ví MoMo'));
    await settle(tester, 10);
    expect(find.textContaining('Đã gửi yêu cầu rút'), findsOneWidget);
    final btn = tester.widget<FilledButton>(find.byKey(const ValueKey('earnings_withdraw')));
    expect(btn.onPressed, isNull);

    // Dòng doanh thu mở giải thích.
    await tester.drag(find.byType(ListView).first, const Offset(0, -2000));
    await settle(tester, 10);
    await tester.tap(find.text('Chi phí đến nay'));
    await settle(tester, 10);
    expect(find.text('Đã hiểu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tổng quan cấp độ mở bảng hệ thống cấp độ', (tester) async {
    await pumpApp(tester, location: '/seller/level');
    expect(find.byKey(const ValueKey('level_name')), findsOneWidget);
    expect(find.text('Chỉ số hiệu suất'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('level_help')));
    await settle(tester, 10);
    expect(find.text('Hệ thống cấp độ'), findsOneWidget);
    expect(find.byKey(const ValueKey('level_system_sheet')), findsOneWidget);
    expect(find.text('Top Rated'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Đặt ngày bận → hiển thị → xoá', (tester) async {
    await pumpApp(tester, location: '/seller/availability');
    expect(find.byKey(const ValueKey('avail_set')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('avail_set')));
    await settle(tester, 10);
    expect(find.text('Xác nhận ngày'), findsOneWidget);

    // Chọn lý do.
    await tester.tap(find.byKey(const ValueKey('avail_reason')));
    await settle(tester, 10);
    await tester.tap(find.text('Đi nghỉ').last, warnIfMissed: false);
    await settle(tester, 10);
    await tester.enterText(find.byKey(const ValueKey('avail_note')), 'Nghỉ lễ cùng gia đình');
    await tester.tap(find.byKey(const ValueKey('avail_confirm')));
    await settle(tester);

    expect(find.text('Đã xác nhận ngày bận của bạn'), findsOneWidget);
    expect(find.text('Ngày bận sắp tới'), findsOneWidget);
    expect(find.byKey(const ValueKey('avail_range')), findsOneWidget);
    expect(find.textContaining('Đi nghỉ'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('avail_edit')));
    await settle(tester, 10);
    expect(find.text('Lưu thay đổi'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('avail_delete')));
    await settle(tester, 10);
    await tester.tap(find.byKey(const ValueKey('confirm_ok')));
    await settle(tester);

    expect(find.byKey(const ValueKey('avail_set')), findsOneWidget);
    expect(find.text('Đã xoá lịch bận'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tuỳ chọn brief: nút Lưu khoá tới khi thay đổi, lưu thành công', (tester) async {
    await pumpApp(tester, location: '/seller/briefs');
    expect(find.text('Phù hợp với bạn'), findsOneWidget);
    expect(find.text('Chưa có brief phù hợp…'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('briefs_intro_next')));
    await settle(tester, 5);
    expect(find.text('Tab phù hợp của bạn'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('briefs_more')));
    await settle(tester, 10);
    await tester.tap(find.text('Tuỳ chọn brief'));
    await settle(tester, 10);

    FilledButton saveBtn() => tester.widget<FilledButton>(
      find.descendant(of: find.byKey(const ValueKey('brief_prefs_save')), matching: find.byType(FilledButton)),
    );
    expect(saveBtn().onPressed, isNull);
    await tester.enterText(find.byKey(const ValueKey('brief_min_price')), '200000');
    await tester.pump();
    expect(saveBtn().onPressed, isNotNull);
    await tester.tap(find.byKey(const ValueKey('brief_prefs_save')));
    await settle(tester, 10);
    expect(find.text('Đã cập nhật tuỳ chọn brief'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mẫu báo giá: tạo mẫu và vuốt xoá', (tester) async {
    await pumpApp(tester, location: '/seller/offer-templates');
    expect(find.text('Tạo mẫu cho báo giá riêng'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('template_add')));
    await settle(tester, 10);
    // Validate khi để trống.
    await tester.tap(find.byKey(const ValueKey('tpl_save')));
    await tester.pump();
    expect(find.text('Vui lòng nhập tên mẫu'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('tpl_name')), 'Gói cao cấp');
    await tester.enterText(find.byKey(const ValueKey('tpl_price')), '500000');
    await tester.tap(find.byKey(const ValueKey('tpl_save')));
    await settle(tester, 10);

    expect(find.text('Gói cao cấp'), findsOneWidget);
    expect(find.text('500.000 ₫'), findsOneWidget);
    expect(find.text('Thanh toán một lần | Giao trong 7 ngày'), findsOneWidget);

    await tester.drag(find.text('Gói cao cấp'), const Offset(-500, 0));
    await settle(tester, 10);
    expect(find.text('Tạo mẫu cho báo giá riêng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Chia sẻ dịch vụ hiển thị dịch vụ mẫu', (tester) async {
    await pumpApp(tester, location: '/seller/gigs');
    expect(find.text('Chia sẻ dịch vụ của bạn'), findsOneWidget);
    expect(find.text('Chia sẻ dịch vụ'), findsWidgets);
    expect(find.text('Tăng lượt truy cập'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Không tràn layout ở chiều rộng 360px', (tester) async {
    for (final loc in [
      '/seller/earnings',
      '/seller/level',
      '/seller/availability',
      '/seller/briefs',
      '/seller/gigs',
      '/seller/offer-templates',
    ]) {
      await pumpApp(tester, location: loc, size: const Size(360, 740));
      expect(tester.takeException(), isNull, reason: loc);
    }
    await enterSellerMode(tester);
    expect(tester.takeException(), isNull, reason: 'dashboard');
    expect(find.text('Chào mừng trở lại'), findsOneWidget);
  });
  testWidgets('Tiếng Anh: thu nhập và dashboard người bán hiển thị chữ tiếng Anh', (tester) async {
    await pumpApp(tester, location: '/seller/earnings');
    final ctx = tester.element(find.byType(Scaffold).first);
    ctx.read<SettingsController>().setLocale(const Locale('en'));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Earnings'), findsWidgets);
    expect(find.text('Available to withdraw'), findsWidgets);
    expect(find.text('Last 30 days'), findsOneWidget);
    expect(find.text('Withdraw'), findsOneWidget);
    expect(find.text('Có thể rút'), findsNothing);

    await enterSellerMode(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('My level'), findsOneWidget);
    expect(find.text('Success score'), findsOneWidget);
    expect(find.text('To-dos'), findsOneWidget);
    expect(find.text('Chào mừng trở lại'), findsNothing);
  });
}
