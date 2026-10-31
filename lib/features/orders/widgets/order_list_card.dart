import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/order.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/repositories.dart';

/// Danh sách đơn của một tab trong màn Quản lý đơn hàng (có thể nhóm theo hạn giao).
class OrderListView extends StatelessWidget {
  const OrderListView({
    super.key,
    required this.orders,
    required this.grouped,
    required this.seller,
    required this.onRefresh,
  });
  final List<Order> orders;
  final bool grouped;
  final bool seller;
  final Future<void> Function() onRefresh;

  String _group(AppLocalizations l, Order o) {
    final h = o.dueDate.difference(DateTime.now()).inHours;
    if (h < 0) return l.ordersGroupOverdue;
    if (h < 48) return l.ordersGroupDue2Days;
    if (h < 24 * 5 + 24) return l.ordersGroupDue2To5Days;
    return l.ordersGroupDueLater;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final children = <Widget>[];
    if (orders.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: EmptyState(
            icon: Icons.inventory_2_outlined,
            title: l.ordersEmptyTitle,
            message: seller ? l.ordersEmptySellerMessage : l.ordersEmptyBuyerMessage,
            actionLabel: seller ? l.ordersEmptySellerAction : l.ordersEmptyBuyerAction,
            onAction: () => seller ? context.push('/seller/gigs') : context.go('/search'),
          ),
        ),
      );
    } else {
      String? last;
      for (final o in orders) {
        if (grouped) {
          final g = _group(l, o);
          if (g != last) {
            children.add(
              Padding(
                padding: EdgeInsets.fromLTRB(Space.lg, last == null ? Space.xl : Space.md, Space.lg, 10),
                child: Text(g, style: context.textTheme.titleMedium),
              ),
            );
            last = g;
          }
        }
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 6),
            child: OrderListCard(order: o, seller: seller),
          ),
        );
      }
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: grouped ? 0 : 10, bottom: Space.navBarClearance),
        children: children,
      ),
    );
  }
}

/// Bộ nhớ đệm người dùng để thẻ đơn không nháy khi cuộn.
final Map<String, AppUser?> _userCache = {};

/// Thẻ một đơn hàng trong danh sách.
class OrderListCard extends StatefulWidget {
  const OrderListCard({super.key, required this.order, required this.seller});
  final Order order;
  final bool seller;

  @override
  State<OrderListCard> createState() => _OrderListCardState();
}

class _OrderListCardState extends State<OrderListCard> {
  late Future<AppUser?> _user;

  String get _otherId => widget.seller ? widget.order.buyerId : widget.order.sellerId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant OrderListCard old) {
    super.didUpdateWidget(old);
    if (old.order.id != widget.order.id) _load();
  }

  void _load() {
    final id = _otherId;
    _user = _userCache.containsKey(id)
        ? Future.value(_userCache[id])
        : context.read<CatalogRepository>().userById(id).then((u) => _userCache[id] = u);
  }

  Future<void> _menu() async {
    final o = widget.order;
    final l = context.l10n;
    final v = await showActionSheet<String>(
      context,
      title: l.ordersCardMenuTitle(o.code),
      actions: [
        SheetAction(label: l.ordersCardMenuOpen, value: 'open', icon: Icons.receipt_long_outlined),
        SheetAction(
          label: widget.seller ? l.ordersCardMenuChatBuyer : l.ordersCardMenuChatSeller,
          value: 'chat',
          icon: Icons.chat_bubble_outline_rounded,
        ),
        if (o.status.isActive)
          SheetAction(label: l.ordersResolutionCenter, value: 'resolution', icon: Icons.support_agent_rounded),
        SheetAction(label: l.ordersCopyCode, value: 'copy', icon: Icons.copy_rounded),
      ],
    );
    if (!mounted || v == null) return;
    switch (v) {
      case 'open':
        context.push('/orders/${o.id}');
      case 'chat':
        context.push('/contact/$_otherId');
      case 'resolution':
        context.push('/orders/${o.id}/resolution');
      case 'copy':
        await Clipboard.setData(ClipboardData(text: o.code));
        if (mounted) showAppSnack(context, context.l10n.ordersCodeCopied(o.code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final l = context.l10n;
    final cs = context.colors;
    return AppCard(
      key: ValueKey('order_card_${o.id}'),
      onTap: () => context.push('/orders/${o.id}'),
      padding: const EdgeInsets.fromLTRB(14, 14, 6, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: Space.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlaceholderImage(seed: o.gigImageSeed, width: 72, height: 54, radius: 8),
                Gaps.h12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Fmt.money(o.total), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 3),
                      Text(
                        o.gigTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13.5, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gaps.v12,
          Padding(
            padding: const EdgeInsets.only(right: Space.sm),
            child: FutureBuilder<AppUser?>(
              future: _user,
              builder: (context, snap) {
                final u = snap.data;
                return Row(
                  children: [
                    UserAvatar(user: u, name: u == null ? '…' : null, size: 24),
                    Gaps.h8,
                    Expanded(
                      child: Text(
                        u?.displayName ??
                            (snap.connectionState == ConnectionState.done ? l.ordersCardUser : l.ordersCardLoading),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                      ),
                    ),
                    Gaps.h8,
                    OrderStatusPill(o.status),
                  ],
                );
              },
            ),
          ),
          Divider(height: 18, color: cs.outlineVariant),
          Row(
            children: [
              Icon(Icons.event_outlined, size: 16, color: cs.onSurfaceVariant),
              Gaps.h6,
              Expanded(
                child: Text(
                  o.status.isActive ? l.ordersCardDue(Fmt.date(o.dueDate)) : l.ordersCardPlaced(Fmt.date(o.createdAt)),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                key: ValueKey('order_menu_${o.id}'),
                tooltip: l.ordersOptions,
                onPressed: _menu,
                icon: const Icon(Icons.more_horiz_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
