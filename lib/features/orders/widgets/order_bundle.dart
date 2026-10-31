import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/order.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/repositories.dart';
import '../../../state/app_controllers.dart';
import '../../../state/session_controller.dart';

/// Đơn hàng kèm dịch vụ và người dùng phía bên kia.
class OrderBundle {
  const OrderBundle({required this.order, this.gig, this.other});
  final Order order;
  final Gig? gig;
  final AppUser? other;
}

/// Tải đơn + gig + đối tác. Gọi trong initState.
Future<OrderBundle?> fetchOrderBundle(BuildContext context, String orderId) {
  final orders = context.read<OrdersController>();
  final catalog = context.read<CatalogRepository>();
  final me = context.read<SessionController>().userId;
  return () async {
    final o = await orders.fetch(orderId);
    if (o == null) return null;
    final gig = await catalog.gigById(o.gigId);
    final other = await catalog.userById(o.buyerId == me ? o.sellerId : o.buyerId);
    return OrderBundle(order: o, gig: gig, other: other);
  }();
}

/// Hiển thị loading / không tìm thấy / dữ liệu, luôn dùng bản đơn mới nhất từ [OrdersController].
class OrderBundleView extends StatelessWidget {
  const OrderBundleView({super.key, required this.orderId, required this.future, required this.builder});
  final String orderId;
  final Future<OrderBundle?> future;
  final Widget Function(BuildContext context, OrderBundle bundle) builder;

  @override
  Widget build(BuildContext context) => AsyncView<OrderBundle?>(
    future: future,
    builder: (context, data) {
      if (data == null) return const OrderNotFound();
      final live = context.watch<OrdersController>().byId(orderId) ?? data.order;
      return builder(context, OrderBundle(order: live, gig: data.gig, other: data.other));
    },
  );
}

class OrderNotFound extends StatelessWidget {
  const OrderNotFound({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return EmptyState(
      icon: Icons.search_off_rounded,
      title: l.ordersNotFoundTitle,
      message: l.ordersNotFoundMessage,
      actionLabel: l.ordersNotFoundAction,
      onAction: () => context.go('/orders'),
    );
  }
}

/// Tên người phía bên kia của đơn (hoặc tên mặc định).
String otherName(AppLocalizations l, OrderBundle b) => b.other?.displayName ?? l.ordersUnknownUser;
