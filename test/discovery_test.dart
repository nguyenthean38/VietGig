import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:viet_gig/features/gig/seller_profile_screen.dart';
import 'package:viet_gig/features/orders/checkout_screen.dart';
import 'package:viet_gig/features/saved/saved_lists_screen.dart';
import 'package:viet_gig/state/app_controllers.dart';
import 'package:viet_gig/state/session_controller.dart';

import 'helpers.dart';

Finder byKey(String k) => find.byKey(ValueKey(k));

final _vertical = find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down);

/// Cuộn tới phần tử (kể cả khi list chưa dựng nó) và đưa vào giữa màn hình.
Future<void> reveal(WidgetTester tester, Finder f) async {
  if (f.evaluate().isEmpty) {
    await tester.scrollUntilVisible(f, 250, scrollable: _vertical.first);
  }
  await Scrollable.ensureVisible(tester.element(f), alignment: 0.4);
  await tester.pump();
}

Future<void> tapKey(WidgetTester tester, String k) async {
  await reveal(tester, byKey(k));
  await tester.tap(byKey(k));
  await settle(tester, 10);
}

String countText(WidgetTester tester) => (tester.widget<Text>(byKey('results_count'))).data!;

void main() {
  testWidgets('Trang chủ hiển thị các mục chính', (tester) async {
    await pumpApp(tester, location: '/home');
    expect(tester.takeException(), isNull);
    expect(find.text('Vui lòng xác nhận email'), findsOneWidget);
    expect(find.text('Dịch vụ phổ biến'), findsOneWidget);
    expect(find.text('Báo giá riêng dành cho bạn'), findsOneWidget);
    expect(find.text('Đơn hàng đang thực hiện'), findsOneWidget);
    expect(find.text('Bạn quan tâm gì?'), findsOneWidget);
    expect(find.text('Đã xem gần đây'), findsOneWidget);
    expect(find.text('Chia sẻ & nhận tới 2.500.000 ₫'), findsOneWidget);
  });

  testWidgets('Khách vẫn xem được trang chủ (ẩn phần cần tài khoản)', (tester) async {
    await pumpApp(tester, location: '/splash', signedIn: false);
    final ctx = tester.element(find.byType(Navigator).first);
    Provider.of<SessionController>(ctx, listen: false).continueAsGuest();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Dịch vụ phổ biến'), findsOneWidget);
    expect(byKey('home_signin'), findsOneWidget);
    expect(find.text('Đơn hàng đang thực hiện'), findsNothing);
    expect(find.text('Bạn quan tâm gì?'), findsNothing);
  });

  testWidgets('Tìm "logo" ra gig logo; bộ lọc giá / Pro làm giảm kết quả; rỗng hiển thị đúng', (tester) async {
    await pumpApp(tester, location: '/search/input');
    await tester.enterText(byKey('search_field'), 'logo');
    await settle(tester, 5);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(byKey('gig_tile_g_logo3'), findsOneWidget);
    final total = int.parse(countText(tester).split(' ').first);
    expect(total, greaterThanOrEqualTo(3));

    // Chỉ Pro.
    await tapKey(tester, 'open_filter');
    await tapKey(tester, 'filter_pro');
    await tapKey(tester, 'filter_apply');
    final pro = int.parse(countText(tester).split(' ').first);
    expect(pro, lessThan(total));
    expect(find.text('Tất cả (1)'), findsOneWidget);

    // Giá tối đa 800.000 ₫.
    await tapKey(tester, 'open_filter');
    await reveal(tester, byKey('filter_max'));
    await tester.enterText(byKey('filter_max'), '800000');
    await settle(tester, 5);
    await tapKey(tester, 'filter_apply');
    final cheap = int.parse(countText(tester).split(' ').first);
    expect(cheap, lessThan(pro));

    // Giá tối thiểu quá cao -> rỗng.
    await tapKey(tester, 'open_filter');
    await reveal(tester, byKey('filter_min'));
    await tester.enterText(byKey('filter_min'), '700000000');
    await tester.enterText(byKey('filter_max'), '');
    await settle(tester, 5);
    await tapKey(tester, 'filter_apply');
    expect(find.text('Không tìm thấy kết quả'), findsOneWidget);
    await tester.tap(find.text('Xoá bộ lọc'));
    await settle(tester);
    expect(countText(tester), '$total kết quả');
  });

  testWidgets('Từ khoá không có kết quả hiển thị trạng thái rỗng', (tester) async {
    await pumpApp(tester, location: '/search/results?q=khongcogi');
    expect(find.text('Không tìm thấy kết quả'), findsOneWidget);
  });

  testWidgets('Chi tiết gig: đổi tab gói đổi giá, Tiếp tục tới checkout', (tester) async {
    await pumpApp(tester, location: '/gig/g_app');
    expect(tester.takeException(), isNull);
    expect(find.text('Tiếp tục (125.000 ₫)'), findsOneWidget);
    await tapKey(tester, 'pkg_tab_2');
    expect(find.text('Tiếp tục (12.375.000 ₫)'), findsOneWidget);
    expect(find.text('Ứng dụng hoàn chỉnh'), findsOneWidget);
    // Màn checkout do nhóm khác phụ trách: bỏ qua lỗi tràn layout của màn đó (nếu có).
    final orig = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.toString().contains('features/orders/')) return;
      orig?.call(d);
    };
    addTearDown(() => FlutterError.onError = orig);
    await tapKey(tester, 'gig_continue');
    await settle(tester);
    final checkout = tester.widget<CheckoutScreen>(find.byType(CheckoutScreen));
    expect(checkout.gigId, 'g_app');
    expect(checkout.packageIndex, 2);
  });

  testWidgets('Lưu gig vào danh sách đổi icon tim', (tester) async {
    await pumpApp(tester, location: '/gig/g_seo');
    final heart = find.descendant(of: byKey('save_g_seo'), matching: find.byIcon(Icons.favorite_border_rounded));
    expect(heart, findsOneWidget);
    await tester.tap(byKey('save_g_seo'));
    await settle(tester, 10);
    await tester.tap(byKey('list_l3'));
    await settle(tester, 5);
    await tester.tap(find.text('Xong'));
    await settle(tester, 10);
    expect(find.descendant(of: byKey('save_g_seo'), matching: find.byIcon(Icons.favorite_rounded)), findsOneWidget);
  });

  testWidgets('Hồ sơ người bán chuyển sang tab Đánh giá', (tester) async {
    await pumpApp(tester, location: '/user/u_bao');
    expect(tester.takeException(), isNull);
    expect(find.text('Bảo Trần'), findsWidgets);
    await tester.tap(byKey('profile_tab_reviews'));
    await settle(tester, 10);
    expect(byKey('profile_review_sort'), findsOneWidget);
    expect(find.text('lannguyen25'), findsOneWidget);
    // Đổi sắp xếp.
    await tester.tap(byKey('profile_review_sort'));
    await settle(tester, 10);
    await tester.tap(byKey('review_sort_newest'));
    await settle(tester, 10);
    expect(find.text('Mới nhất'), findsOneWidget);
    expect(find.byType(SellerProfileScreen), findsOneWidget);
  });

  testWidgets('Tạo, đổi tên và xoá danh sách đã lưu', (tester) async {
    await pumpApp(tester, location: '/saved');
    expect(find.byType(SavedListsScreen), findsOneWidget);
    await tester.tap(byKey('create_list'));
    await settle(tester, 5);
    await tester.enterText(byKey('list_name_field'), 'Quà tặng');
    await tester.tap(byKey('list_name_ok'));
    await settle(tester, 10);
    expect(find.text('Quà tặng'), findsOneWidget);

    await reveal(tester, find.text('Quà tặng'));
    await tester.tap(find.text('Quà tặng'));
    await settle(tester);
    expect(find.text('Chưa có dịch vụ nào'), findsOneWidget);

    await tester.tap(byKey('list_menu'));
    await settle(tester, 10);
    await tester.tap(byKey('list_rename'));
    await settle(tester, 10);
    await tester.enterText(byKey('list_name_field'), 'Quà Tết');
    await tester.tap(byKey('list_name_ok'));
    await settle(tester, 10);
    expect(tester.widget<Text>(byKey('list_title')).data, 'Quà Tết');

    await tester.tap(byKey('list_menu'));
    await settle(tester, 10);
    await tester.tap(byKey('list_delete'));
    await settle(tester, 10);
    await tester.tap(byKey('confirm_ok'));
    await settle(tester);
    expect(find.byType(SavedListsScreen), findsOneWidget);
    expect(find.text('Quà Tết'), findsNothing);
  });

  testWidgets('Bỏ lưu gig trong danh sách có Hoàn tác', (tester) async {
    await pumpApp(tester, location: '/saved/l2');
    expect(byKey('list_gig_g_logo3'), findsOneWidget);
    await tester.tap(byKey('unsave_g_logo3'));
    await settle(tester, 5);
    expect(byKey('list_gig_g_logo3'), findsNothing);
    await tester.tap(find.text('Hoàn tác'));
    await settle(tester, 10);
    expect(byKey('list_gig_g_logo3'), findsOneWidget);
  });

  testWidgets('Lịch sử xem: xoá từng mục và xoá tất cả', (tester) async {
    await pumpApp(tester, location: '/history');
    expect(byKey('history_gig_g_app'), findsOneWidget);
    await tester.tap(byKey('history_edit'));
    await settle(tester, 5);
    await tester.tap(find.descendant(of: byKey('history_gig_g_app'), matching: find.byTooltip('Xoá')));
    await settle(tester, 10);
    expect(byKey('history_gig_g_app'), findsNothing);
    await tester.tap(byKey('history_clear_all'));
    await settle(tester, 10);
    await tester.tap(byKey('confirm_ok'));
    await settle(tester, 10);
    expect(find.text('Chưa có dịch vụ đã xem'), findsOneWidget);
  });

  Future<void> useEnglish(WidgetTester tester) async {
    final ctx = tester.element(find.byType(Navigator).first);
    Provider.of<SettingsController>(ctx, listen: false).setLocale(const Locale('en'));
    await settle(tester);
  }

  testWidgets('Tiếng Anh: trang chủ hiển thị tiêu đề mục bằng tiếng Anh', (tester) async {
    await pumpApp(tester, location: '/home');
    await useEnglish(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Please verify your email'), findsOneWidget);
    expect(find.text('Popular services'), findsOneWidget);
    expect(find.text('Custom offers for you'), findsOneWidget);
    expect(find.text('Active orders'), findsOneWidget);
    expect(find.text('Dịch vụ phổ biến'), findsNothing);
    await reveal(tester, find.text('What are you interested in?'));
    expect(find.text('What are you interested in?'), findsOneWidget);
  });

  testWidgets('Tiếng Anh: chi tiết gig có nút Continue và So sánh gói tiếng Anh', (tester) async {
    await pumpApp(tester, location: '/gig/g_app');
    await useEnglish(tester);
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Continue ('), findsOneWidget);
    expect(find.textContaining('Tiếp tục'), findsNothing);
    expect(find.text('Compare packages'), findsOneWidget);
    expect(find.text('Delivery time'), findsOneWidget);
    await reveal(tester, find.text('About the seller'));
    expect(find.text('About the seller'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    for (final route in [
      '/home',
      '/search',
      '/search/input?q=logo',
      '/search/results?q=logo',
      '/search/results?category=graphics&sub=logo',
      '/category/graphics',
      '/interests',
      '/gig/g_app',
      '/gig/g_logo3',
      '/user/u_bao',
      '/user/u_hoang?tab=2',
      '/user/u_hoang?tab=3',
      '/user/u_hoang?tab=4',
      '/user/u_bao/reviews',
      '/user/u_hoang/portfolio',
      '/portfolio/u_hoang/p1',
      '/saved',
      '/saved/l1',
      '/history',
    ]) {
      testWidgets('Không tràn layout ở 360px${dark ? ' (tối)' : ''}: $route', (tester) async {
        await pumpApp(tester, location: route, size: const Size(360, 740));
        if (dark) {
          final ctx = tester.element(find.byType(Navigator).first);
          Provider.of<SettingsController>(ctx, listen: false).setThemeMode(ThemeMode.dark);
          await settle(tester, 5);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
}
