import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/order.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import 'widgets/order_list_card.dart';
import 'widgets/order_widgets.dart';

enum _Sort { due, newest, priceHigh, priceLow }

extension on _Sort {
  String localized(AppLocalizations l) => switch (this) {
    _Sort.due => l.ordersSortDue,
    _Sort.newest => l.ordersSortNewest,
    _Sort.priceHigh => l.sortPriceHigh,
    _Sort.priceLow => l.sortPriceLow,
  };
}

class _Tab {
  const _Tab(this.label, this.test, {this.grouped = false});
  final String label;
  final bool Function(Order o) test;
  final bool grouped;
}

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  _Sort _sort = _Sort.due;
  final Set<OrderStatus> _statusFilter = {};

  static bool _working(Order o) => const {
    OrderStatus.awaitingRequirements,
    OrderStatus.inProgress,
    OrderStatus.revisionRequested,
    OrderStatus.disputed,
  }.contains(o.status);

  List<_Tab> _tabs(AppLocalizations l, bool seller) => seller
      ? [
          _Tab(
            l.ordersTabNeedsAction,
            (o) =>
                const {
                  OrderStatus.awaitingRequirements,
                  OrderStatus.revisionRequested,
                  OrderStatus.disputed,
                }.contains(o.status) ||
                (o.status == OrderStatus.inProgress && o.dueDate.difference(DateTime.now()).inHours < 24),
          ),
          _Tab(l.ordersTabInProgress, (o) => o.status == OrderStatus.inProgress, grouped: true),
          _Tab(l.ordersTabNew, (o) => o.status.isActive && DateTime.now().difference(o.createdAt).inDays < 2),
          _Tab(l.ordersTabDelivered, (o) => o.status == OrderStatus.delivered),
          _Tab(l.ordersTabCompleted, (o) => o.status == OrderStatus.completed),
          _Tab(l.ordersTabCancelled, (o) => o.status == OrderStatus.cancelled),
        ]
      : [
          _Tab(l.ordersTabInProgress, _working, grouped: true),
          _Tab(l.ordersTabDelivered, (o) => o.status == OrderStatus.delivered),
          _Tab(l.ordersTabCompleted, (o) => o.status == OrderStatus.completed),
          _Tab(l.ordersTabCancelled, (o) => o.status == OrderStatus.cancelled),
        ];

  List<Order> _apply(List<Order> list) {
    final l = list.where((o) => _statusFilter.isEmpty || _statusFilter.contains(o.status)).toList();
    switch (_sort) {
      case _Sort.due:
        l.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      case _Sort.newest:
        l.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case _Sort.priceHigh:
        l.sort((a, b) => b.total.compareTo(a.total));
      case _Sort.priceLow:
        l.sort((a, b) => a.total.compareTo(b.total));
    }
    return l;
  }

  Future<void> _openFilter() async {
    final l = context.l10n;
    var sort = _sort;
    final statuses = {..._statusFilter};
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(l.ordersFilterTitle, style: ctx.textTheme.titleMedium)),
                    TextButton(
                      onPressed: () => setSheet(() {
                        sort = _Sort.due;
                        statuses.clear();
                      }),
                      child: Text(l.ordersFilterReset),
                    ),
                  ],
                ),
                BlockTitle(
                  l.ordersFilterSortBy,
                  padding: const EdgeInsets.only(top: Space.sm, bottom: Space.xs),
                ),
                for (final s in _Sort.values)
                  RadioRow(
                    key: ValueKey('sort_${s.name}'),
                    label: s.localized(l),
                    selected: sort == s,
                    onTap: () => setSheet(() => sort = s),
                  ),
                BlockTitle(l.ordersFilterStatus, padding: const EdgeInsets.only(top: Space.lg, bottom: 10)),
                Wrap(
                  spacing: Space.sm,
                  runSpacing: Space.sm,
                  children: [
                    SelectChip(
                      label: l.ordersFilterAll,
                      selected: statuses.isEmpty,
                      showCheck: true,
                      onTap: () => setSheet(statuses.clear),
                    ),
                    for (final s in OrderStatus.values)
                      SelectChip(
                        label: _cap(s.localized(l)),
                        selected: statuses.contains(s),
                        showCheck: true,
                        onTap: () => setSheet(() => statuses.contains(s) ? statuses.remove(s) : statuses.add(s)),
                      ),
                  ],
                ),
                Gaps.v20,
                PrimaryButton(
                  key: const ValueKey('filter_apply'),
                  label: l.ordersApply,
                  onPressed: () => Navigator.pop(ctx, true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (ok == true && mounted) {
      setState(() {
        _sort = sort;
        _statusFilter
          ..clear()
          ..addAll(statuses);
      });
    }
  }

  static String _cap(String s) => s.isEmpty ? s : s[0] + s.substring(1).toLowerCase();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final seller = context.watch<SessionController>().sellerMode;
    final orders = context.watch<OrdersController>();
    final unread = context.watch<NotificationsController>().unreadCount;
    final source = seller ? orders.selling : orders.buying;
    final tabs = _tabs(l, seller);
    final filtered = _apply(source);

    return DefaultTabController(
      key: ValueKey('orders_tabs_$seller'),
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          centerTitle: true,
          leadingWidth: 64,
          leading: Center(
            child: CountBadge(
              count: unread,
              child: CircleIconButton(
                key: const ValueKey('orders_bell'),
                icon: Icons.notifications_none_rounded,
                tooltip: l.ordersNotifications,
                onPressed: () => context.push('/notifications'),
              ),
            ),
          ),
          title: Text(l.ordersManageTitle),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleIconButton(
                  key: const ValueKey('orders_filter'),
                  icon: Icons.tune_rounded,
                  tooltip: l.ordersFilterTitle,
                  onPressed: _openFilter,
                ),
                if (_statusFilter.isNotEmpty || _sort != _Sort.due)
                  Positioned(
                    right: 2,
                    top: 8,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(color: context.tokens.brand, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
            Gaps.h12,
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [for (final t in tabs) Tab(text: l.ordersTabWithCount(t.label, source.where(t.test).length))],
          ),
        ),
        body: orders.loading && source.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  for (final t in tabs)
                    OrderListView(
                      orders: filtered.where(t.test).toList(),
                      grouped: t.grouped && _sort == _Sort.due,
                      seller: seller,
                      onRefresh: orders.refresh,
                    ),
                ],
              ),
      ),
    );
  }
}
