import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/account.dart';
import '../../data/models/order.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import 'widgets/dashboard_level_card.dart';
import 'widgets/dashboard_widgets.dart';
import 'widgets/seller_widgets.dart';

class _DashData {
  const _DashData(this.stats, this.reqs, this.briefs);
  final SellerStats stats;
  final List<LevelRequirement> reqs;
  final List<Brief> briefs;
}

/// Trang chủ ở chế độ người bán.
class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  late Future<_DashData> _future;
  bool _showBanner = true;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DashData> _load() async {
    final repo = context.read<AccountRepository>();
    final uid = context.read<SessionController>().userId;
    final r = await Future.wait([repo.sellerStats(uid), repo.levelRequirements(), repo.briefs(uid)]);
    return _DashData(r[0] as SellerStats, r[1] as List<LevelRequirement>, r[2] as List<Brief>);
  }

  Future<void> _refresh() async {
    final orders = context.read<OrdersController>();
    final inbox = context.read<InboxController>();
    final f = _load();
    setState(() {
      _future = f;
    });
    await Future.wait([f, orders.refresh(), inbox.refresh()]);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionController>().user;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: context.tokens.brand,
          onRefresh: _refresh,
          child: FutureBuilder<_DashData>(
            future: _future,
            builder: (context, snap) {
              final children = <Widget>[
                SellerDashHeader(user: user),
                if (_showBanner) SellerSetupBanner(onClose: () => setState(() => _showBanner = false)),
              ];
              if (snap.hasError) {
                children.add(
                  EmptyState(
                    icon: Icons.error_outline_rounded,
                    title: context.l10n.sellerDashLoadError,
                    message: '${snap.error}',
                    actionLabel: context.l10n.commonRetry,
                    onAction: () => setState(() {
                      _future = _load();
                    }),
                  ),
                );
              } else if (snap.connectionState != ConnectionState.done) {
                children.add(
                  const Padding(
                    padding: EdgeInsets.all(Space.huge),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              } else {
                children.addAll(_content(context, snap.data!, user?.level ?? SellerLevel.newSeller));
              }
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: Insets.tabBottom,
                children: children,
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, _DashData d, SellerLevel level) {
    final l = context.l10n;
    final s = d.stats;
    final next = nextRequirement(level, d.reqs);
    final orders = context.watch<OrdersController>();
    final unread = context.watch<InboxController>().unreadCount;
    final active = orders.selling.where((o) => o.status.isActive).toList();
    final toDeliver = orders.selling
        .where((o) => o.status == OrderStatus.inProgress || o.status == OrderStatus.revisionRequested)
        .length;

    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, 0),
        child: SellerDashLevelCard(stats: s, level: level, next: next),
      ),
      SectionHeader(title: l.sellerDashTodoTitle),
      Padding(
        padding: Insets.page,
        child: AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SellerTodoTile(
                key: const ValueKey('todo_messages'),
                count: unread,
                title: l.sellerDashUnreadMessages(unread),
                subtitle: unread == 0 ? l.sellerDashUnreadNone : l.sellerDashUnreadSome,
                onTap: () => context.go('/inbox'),
              ),
              Divider(height: 1, color: context.colors.outlineVariant),
              SellerTodoTile(
                key: const ValueKey('todo_orders'),
                count: toDeliver,
                title: l.sellerDashOrdersToDeliver(toDeliver),
                subtitle: toDeliver == 0 ? l.sellerDashOrdersNone : l.sellerDashOrdersSome,
                onTap: () => context.go('/orders'),
              ),
            ],
          ),
        ),
      ),
      SectionHeader(
        title: l.sellerDashMyGigs,
        actionLabel: l.sellerDashManage,
        onAction: () => context.push('/seller/gigs'),
      ),
      Padding(
        padding: Insets.page,
        child: AppCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l.sellerDashStats, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Text(l.sellerDashLast7Days, style: context.textTheme.bodySmall),
                ],
              ),
              Gaps.v8,
              SellerStatLine(label: l.sellerDashImpressions, value: Fmt.number(s.impressions), up: s.impressions > 0),
              SellerStatLine(label: l.sellerDashClicks, value: Fmt.number(s.clicks), up: s.clicks > 0),
              SellerStatLine(
                label: l.sellerDashConversion,
                value: '${s.conversion.toStringAsFixed(2).replaceAll('.', ',')}%',
                up: s.conversion > 0,
              ),
            ],
          ),
        ),
      ),
      SectionHeader(
        title: l.sellerDashBriefsTitle,
        actionLabel: l.sellerDashLearnMore,
        onAction: () => context.push('/seller/briefs'),
      ),
      Padding(
        padding: Insets.page,
        child: AppCard(
          onTap: () => context.push('/seller/briefs'),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.briefs.isEmpty ? l.sellerDashBriefsEmpty : l.sellerDashBriefsCount(d.briefs.length),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Gaps.v4,
                    Text(l.sellerDashBriefsDesc, style: context.textTheme.bodySmall),
                  ],
                ),
              ),
              Gaps.h12,
              Icon(Icons.description_outlined, color: context.tokens.brand, size: 30),
            ],
          ),
        ),
      ),
      SectionHeader(
        title: l.sellerEarnings,
        actionLabel: l.sellerDashViewDetails,
        onAction: () => context.push('/seller/earnings'),
      ),
      Padding(
        padding: Insets.page,
        child: AppCard(
          child: Column(
            children: [
              SellerPairRow(
                a: SellerMetric(
                  l.sellerAvailable,
                  Fmt.money(s.availableForWithdrawal),
                  key: const ValueKey('dash_available'),
                ),
                b: SellerMetric(l.sellerDashEarningsThisMonth, Fmt.money(s.earningsThisMonth)),
              ),
              const SizedBox(height: 14),
              SellerPairRow(
                a: SellerMetric(l.sellerDashAvgPrice, Fmt.money(s.avgSellingPrice)),
                b: SellerMetric(l.sellerActiveOrders, '${s.activeOrders} (${Fmt.moneyShort(s.activeOrdersValue)})'),
              ),
              const SizedBox(height: 14),
              SellerPairRow(
                a: SellerMetric(l.sellerPaymentsClearing, Fmt.money(s.paymentsClearing)),
                b: SellerMetric(l.sellerDashCancelledOrders, '${s.cancelledOrders}'),
              ),
            ],
          ),
        ),
      ),
      SectionHeader(title: l.sellerDashActiveOrdersTitle),
      if (orders.loading && orders.selling.isEmpty)
        const Padding(
          padding: EdgeInsets.all(Space.xxl),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (active.isEmpty)
        Padding(
          padding: Insets.page,
          child: AppCard(
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined, color: context.colors.onSurfaceVariant),
                Gaps.h12,
                Expanded(child: Text(l.sellerDashNoActiveOrders)),
              ],
            ),
          ),
        )
      else
        for (final o in active)
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, 10),
            child: SellerActiveOrderTile(order: o),
          ),
    ];
  }
}
