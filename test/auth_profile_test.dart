import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:viet_gig/data/mock/mock_repositories.dart';
import 'package:viet_gig/features/auth/onboarding_screen.dart';
import 'package:viet_gig/features/auth/sign_in_screen.dart';
import 'package:viet_gig/features/auth/sign_up_screen.dart';
import 'package:viet_gig/features/auth/welcome_screen.dart';
import 'package:viet_gig/features/profile/appearance_screen.dart';
import 'package:viet_gig/features/profile/profile_screen.dart';
import 'package:viet_gig/state/app_controllers.dart';
import 'package:viet_gig/state/session_controller.dart';

import 'helpers.dart';

/// Lấy FilledButton bên trong PrimaryButton có key [k].
FilledButton _btn(WidgetTester t, String k) =>
    t.widget<FilledButton>(find.descendant(of: find.byKey(ValueKey(k)), matching: find.byType(FilledButton)));

Future<void> _tap(WidgetTester t, Finder f) async {
  await t.ensureVisible(f);
  await t.pump();
  await t.tap(f);
  await settle(t, 10);
}

/// Trang chủ (thuộc nhóm khác) có thể báo overflow ở widget chung – bỏ qua lỗi overflow
/// không nằm trong features/auth hoặc features/profile để test tập trung vào luồng của nhóm này.
void _ignoreForeignOverflow() {
  final orig = FlutterError.onError;
  FlutterError.onError = (d) {
    final msg = d.toString();
    if (msg.contains('overflowed') && !msg.contains('features/auth') && !msg.contains('features/profile')) return;
    orig?.call(d);
  };
  addTearDown(() => FlutterError.onError = orig);
}

void main() {
  testWidgets('Đăng nhập sai mật khẩu -> hiện lỗi', (t) async {
    await pumpApp(t, location: '/welcome', signedIn: false);
    await _tap(t, find.byKey(const ValueKey('welcome_signin')));
    await settle(t);
    expect(find.byType(SignInScreen), findsOneWidget);
    await t.enterText(find.byKey(const ValueKey('signin_id')), 'minhanh@gmail.com');
    await t.enterText(find.byKey(const ValueKey('signin_password')), 'saimatkhau');
    await _tap(t, find.byKey(const ValueKey('signin_submit')));
    expect(find.byKey(const ValueKey('auth_error')), findsOneWidget);
    expect(find.textContaining('Mật khẩu không đúng'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('Đăng nhập trống -> báo lỗi validate', (t) async {
    await pumpApp(t, location: '/welcome', signedIn: false);
    await _tap(t, find.byKey(const ValueKey('welcome_signin')));
    await settle(t);
    await _tap(t, find.byKey(const ValueKey('signin_submit')));
    expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
  });

  testWidgets('Đăng nhập đúng -> rời màn đăng nhập', (t) async {
    _ignoreForeignOverflow();
    await pumpApp(t, location: '/welcome', signedIn: false);
    await _tap(t, find.byKey(const ValueKey('welcome_signin')));
    await settle(t);
    await t.enterText(find.byKey(const ValueKey('signin_id')), 'minhanh@gmail.com');
    await t.enterText(find.byKey(const ValueKey('signin_password')), 'Matkhau1');
    await _tap(t, find.byKey(const ValueKey('signin_submit')));
    await settle(t);
    expect(find.byType(SignInScreen), findsNothing);
    final session = t.element(find.byType(Navigator).first).read<SessionController>();
    expect(session.isSignedIn, isTrue);
  });

  testWidgets('Đăng ký mật khẩu yếu -> nút bị khoá, mật khẩu mạnh -> mở khoá', (t) async {
    await pumpApp(t, location: '/welcome', signedIn: false);
    await _tap(t, find.byKey(const ValueKey('welcome_buy')));
    await settle(t);
    expect(find.byType(SignUpScreen), findsOneWidget);
    await t.enterText(find.byKey(const ValueKey('signup_username')), 'thanh_tung');
    await t.enterText(find.byKey(const ValueKey('signup_email')), 'tung@gmail.com');
    await t.enterText(find.byKey(const ValueKey('signup_password')), 'abc');
    await t.pump();
    expect(_btn(t, 'signup_submit').onPressed, isNull);
    await t.enterText(find.byKey(const ValueKey('signup_password')), 'Matkhau9');
    await t.pump();
    expect(_btn(t, 'signup_submit').onPressed, isNotNull);
  });

  testWidgets('Đăng ký -> onboarding 3 bước -> hoàn tất', (t) async {
    _ignoreForeignOverflow();
    final db = MockDb();
    await pumpApp(t, location: '/welcome', signedIn: false, db: db);
    await _tap(t, find.byKey(const ValueKey('welcome_buy')));
    await settle(t);
    await t.enterText(find.byKey(const ValueKey('signup_username')), 'thanh_tung');
    await t.enterText(find.byKey(const ValueKey('signup_email')), 'tung@gmail.com');
    await t.enterText(find.byKey(const ValueKey('signup_password')), 'Matkhau9');
    await t.pump();
    await _tap(t, find.byKey(const ValueKey('signup_submit')));
    await settle(t);
    expect(find.byType(OnboardingScreen), findsOneWidget);

    await _tap(t, find.byKey(const ValueKey('purpose_work')));
    expect(find.text('Tiếp tục'), findsOneWidget);
    await _tap(t, find.byKey(const ValueKey('onb_next')));
    await _tap(t, find.byKey(const ValueKey('interest_social')));
    await _tap(t, find.byKey(const ValueKey('onb_next')));
    await _tap(t, find.byKey(const ValueKey('exp_online')));
    expect(find.text('Hoàn tất'), findsOneWidget);
    await _tap(t, find.byKey(const ValueKey('onb_next')));
    await settle(t);

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(db.onboarding?.purposes, contains('work'));
    expect(db.onboarding?.interests, contains('social'));
    expect(db.onboarding?.experience, 'online');
  });

  testWidgets('Chế độ khách -> trang Tài khoản dạng khách', (t) async {
    _ignoreForeignOverflow();
    await pumpApp(t, location: '/welcome', signedIn: false);
    expect(find.byType(WelcomeScreen), findsOneWidget);
    await _tap(t, find.byKey(const ValueKey('welcome_skip')));
    await settle(t);
    await _tap(t, find.byKey(const ValueKey('nav_4')));
    await settle(t);
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Khách'), findsOneWidget);
    expect(find.text('Chào mừng đến VietGig!'), findsOneWidget);
    expect(find.byKey(const ValueKey('guest_join')), findsOneWidget);
    expect(find.byKey(const ValueKey('guest_language')), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('Trang Tài khoản người dùng có nút kích hoạt + chuyển chế độ người bán', (t) async {
    await pumpApp(t, location: '/profile');
    expect(find.text('minhanh_vg'), findsOneWidget);
    expect(find.byKey(const ValueKey('activate_account')), findsOneWidget);
    expect(find.text('Thu nhập'), findsNothing);
    await _tap(t, find.byKey(const ValueKey('seller_mode_switch')));
    await settle(t);
    final session = t.element(find.byType(ProfileScreen)).read<SessionController>();
    expect(session.sellerMode, isTrue);
    expect(find.text('Thu nhập'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('Đổi giao diện tối cập nhật SettingsController', (t) async {
    await pumpApp(t, location: '/settings/appearance');
    expect(find.byType(AppearanceScreen), findsOneWidget);
    await _tap(t, find.byKey(const ValueKey('theme_dark')));
    final s = t.element(find.byType(AppearanceScreen)).read<SettingsController>();
    expect(s.themeMode, ThemeMode.dark);
    await _tap(t, find.byKey(const ValueKey('theme_system')));
    expect(s.themeMode, ThemeMode.system);
    expect(t.takeException(), isNull);
  });

  testWidgets('Đăng xuất -> về màn chào mừng', (t) async {
    await pumpApp(t, location: '/settings/account');
    await _tap(t, find.byKey(const ValueKey('menu_logout')));
    await _tap(t, find.byKey(const ValueKey('confirm_ok')));
    await settle(t);
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('Xoá tài khoản khi có đơn đang chạy -> dialog lỗi', (t) async {
    await pumpApp(t, location: '/settings/deactivate');
    await _tap(t, find.byKey(const ValueKey('choice_delete')));
    await _tap(t, find.byKey(const ValueKey('deactivate_continue')));
    expect(find.text('Điều gì xảy ra khi bạn xoá tài khoản?'), findsOneWidget);
    await _tap(t, find.byKey(const ValueKey('deactivate_continue')));
    expect(_btn(t, 'deactivate_continue').onPressed, isNull);
    await _tap(t, find.byKey(const ValueKey('reason_other')));
    await _tap(t, find.byKey(const ValueKey('deactivate_continue')));
    await _tap(t, find.byKey(const ValueKey('confirm_ok')));
    await settle(t);
    expect(find.text('Bạn không thể thực hiện thao tác này'), findsOneWidget);
    final session = t.element(find.byType(Scaffold).first).read<SessionController>();
    expect(session.isSignedIn, isTrue);
  });

  testWidgets('Gửi góp ý -> validate rồi hiện dialog cảm ơn', (t) async {
    final db = MockDb();
    await pumpApp(t, location: '/feedback?kind=idea', db: db);
    await _tap(t, find.byKey(const ValueKey('feedback_submit')));
    expect(find.text('Vui lòng chọn một khu vực'), findsOneWidget);
    await _tap(t, find.byKey(const ValueKey('area_inbox')));
    await t.enterText(find.byKey(const ValueKey('feedback_text')), 'Thêm bộ lọc tin nhắn chưa đọc trong hộp thư');
    await _tap(t, find.byKey(const ValueKey('contact_yes')));
    await _tap(t, find.byKey(const ValueKey('feedback_submit')));
    expect(find.text('Cảm ơn bạn đã chia sẻ ý tưởng'), findsOneWidget);
    expect(db.feedback, hasLength(1));
  });

  testWidgets('Cập nhật email không hợp lệ -> báo lỗi', (t) async {
    await pumpApp(t, location: '/settings/email');
    await t.enterText(find.byKey(const ValueKey('new_email')), 'abc');
    await _tap(t, find.byKey(const ValueKey('update_email_submit')));
    expect(find.text('Email không hợp lệ'), findsOneWidget);
  });

  testWidgets('Đổi sang tiếng Anh qua màn Ngôn ngữ -> trang Tài khoản hiện tiếng Anh', (t) async {
    await pumpApp(t, location: '/settings/language');
    expect(find.text('Ngôn ngữ'), findsOneWidget);
    await _tap(t, find.byKey(const ValueKey('lang_en')));
    final s = t.element(find.byType(Scaffold).first).read<SettingsController>();
    expect(s.locale, const Locale('en'));
    expect(s.languageName, 'English');
    // Giao diện đổi ngay + snack xác nhận bằng ngôn ngữ mới.
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Language changed to English'), findsOneWidget);

    GoRouter.of(t.element(find.byType(Scaffold).first)).go('/profile');
    await settle(t);
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Selling mode'), findsOneWidget);
    expect(find.text('My VietGig'), findsOneWidget);
    expect(find.text('Chế độ người bán'), findsNothing);

    await _tap(t, find.byKey(const ValueKey('menu_preferences')));
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('Chọn lại Tiếng Việt -> giao diện về tiếng Việt', (t) async {
    await pumpApp(t, location: '/settings/language');
    await _tap(t, find.byKey(const ValueKey('lang_en')));
    expect(find.text('Language'), findsOneWidget);
    await _tap(t, find.byKey(const ValueKey('lang_vi')));
    final s = t.element(find.byType(Scaffold).first).read<SettingsController>();
    expect(s.locale, const Locale('vi'));
    expect(find.text('Ngôn ngữ'), findsOneWidget);
    expect(find.text('Đã chuyển ngôn ngữ sang Tiếng Việt'), findsOneWidget);

    GoRouter.of(t.element(find.byType(Scaffold).first)).go('/profile');
    await settle(t);
    expect(find.text('Chế độ người bán'), findsOneWidget);
    expect(find.text('Selling mode'), findsNothing);
    expect(t.takeException(), isNull);
  });

  testWidgets('Cài đặt thông báo hiện nhãn đã dịch theo khoá', (t) async {
    await pumpApp(t, location: '/settings/notifications');
    expect(find.text('Tin nhắn hộp thư'), findsOneWidget);
    expect(find.text('inbox'), findsNothing);
    t.element(find.byType(Scaffold).first).read<SettingsController>().setLocale(const Locale('en'));
    await settle(t);
    expect(find.text('Push notifications'), findsOneWidget);
    expect(find.text('Tin nhắn hộp thư'), findsNothing);
  });

  testWidgets('Các màn cài đặt mở không lỗi', (t) async {
    for (final loc in [
      '/notifications',
      '/profile',
      '/settings/account',
      '/settings/appearance',
      '/settings/deactivate',
      '/feedback?kind=bug',
      '/settings/email',
      '/settings/preferences',
      '/settings/notifications',
      '/settings/language',
      '/settings/currency',
      '/settings/balance',
      '/settings/edit-profile',
      '/invite',
      '/support',
      '/verify-email',
    ]) {
      await pumpApp(t, location: loc, size: const Size(360, 740), signedIn: true);
      expect(t.takeException(), isNull, reason: loc);
      // Bản tiếng Anh (chuỗi dài hơn) cũng không tràn.
      t.element(find.byType(Scaffold).first).read<SettingsController>().setLocale(const Locale('en'));
      await settle(t);
      expect(t.takeException(), isNull, reason: '$loc (en)');
    }
  });
}
