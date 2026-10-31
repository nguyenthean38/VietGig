import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viet_gig/app.dart';
import 'package:viet_gig/data/mock/mock_repositories.dart';
import 'package:viet_gig/data/services.dart';

/// Tạo services mock không độ trễ cho test.
AppServices testServices({MockDb? db}) => AppServices.mock(latency: Duration.zero, db: db);

/// Khởi chạy toàn bộ app ở [location].
/// [signedIn] = true: đăng nhập sẵn tài khoản mẫu (minhanh@gmail.com / Matkhau1).
Future<AppServices> pumpApp(
  WidgetTester tester, {
  String location = '/home',
  bool signedIn = true,
  MockDb? db,
  Size size = const Size(400, 860),
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final services = testServices(db: db);
  if (signedIn) {
    await services.auth.signIn(emailOrUsername: 'minhanh@gmail.com', password: 'Matkhau1');
  }
  await tester.pumpWidget(VietGigApp(services: services, initialLocation: location));
  await settle(tester);
  return services;
}

/// pumpAndSettle có giới hạn (tránh treo vì animation lặp như spinner).
Future<void> settle(WidgetTester tester, [int frames = 30]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
