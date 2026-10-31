import 'mock/mock_repositories.dart';
import 'repositories/repositories.dart';

/// Gom tất cả repository. Đổi sang Firebase chỉ cần tạo `AppServices.firebase()`
/// trả về các repository cài đặt bằng Firestore/Auth, giao diện không phải sửa.
class AppServices {
  AppServices({
    required this.auth,
    required this.catalog,
    required this.orders,
    required this.chat,
    required this.account,
  });

  final AuthRepository auth;
  final CatalogRepository catalog;
  final OrderRepository orders;
  final ChatRepository chat;
  final AccountRepository account;

  /// [latency] = Duration.zero khi chạy test.
  factory AppServices.mock({Duration? latency, MockDb? db}) {
    final d = db ?? MockDb();
    return AppServices(
      auth: MockAuthRepository(d, latency: latency ?? const Duration(milliseconds: 500)),
      catalog: MockCatalogRepository(d, latency: latency ?? const Duration(milliseconds: 300)),
      orders: MockOrderRepository(d, latency: latency ?? const Duration(milliseconds: 400)),
      chat: MockChatRepository(d, latency: latency ?? const Duration(milliseconds: 250)),
      account: MockAccountRepository(d, latency: latency ?? const Duration(milliseconds: 250)),
    );
  }
}
