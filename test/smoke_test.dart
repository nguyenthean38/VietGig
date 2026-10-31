import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('App khởi động tới trang chủ khi đã đăng nhập', (tester) async {
    await pumpApp(tester, location: '/notifications');
    expect(tester.takeException(), isNull);
    expect(find.text('Thông báo'), findsOneWidget);
  });

  testWidgets('Chưa đăng nhập thì chuyển tới màn hình chào mừng', (tester) async {
    await pumpApp(tester, location: '/splash', signedIn: false);
    expect(tester.takeException(), isNull);
    expect(find.text('Bỏ qua'), findsOneWidget);
  });
}
