import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/account.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import 'widgets/seller_widgets.dart';

class _LevelData {
  const _LevelData(this.stats, this.reqs);
  final SellerStats stats;
  final List<LevelRequirement> reqs;
}

/// Tổng quan cấp độ người bán.
class LevelOverviewScreen extends StatefulWidget {
  const LevelOverviewScreen({super.key});

  @override
  State<LevelOverviewScreen> createState() => _LevelOverviewScreenState();
}

class _LevelOverviewScreenState extends State<LevelOverviewScreen> {
  late Future<_LevelData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_LevelData> _load() async {
    final repo = context.read<AccountRepository>();
    final uid = context.read<SessionController>().userId;
    final r = await Future.wait([repo.sellerStats(uid), repo.levelRequirements()]);
    return _LevelData(r[0] as SellerStats, r[1] as List<LevelRequirement>);
  }

  @override
  Widget build(BuildContext context) {
    final level = context.select<SessionController, SellerLevel>((s) => s.user?.level ?? SellerLevel.newSeller);
    return FutureBuilder<_LevelData>(
      future: _future,
      builder: (context, snap) => Scaffold(
        appBar: SimpleAppBar(
          title: context.l10n.sellerLevelTitle,
          actions: [
            CircleIconButton(
              key: const ValueKey('level_help'),
              icon: Icons.help_outline_rounded,
              tooltip: context.l10n.sellerLevelSystem,
              onPressed: snap.hasData ? () => showLevelSystemSheet(context, snap.data!.reqs) : null,
            ),
          ],
        ),
        body: AsyncView<_LevelData>(future: _future, builder: (context, d) => _body(context, d, level)),
      ),
    );
  }

  Widget _body(BuildContext context, _LevelData d, SellerLevel level) {
    final l = context.l10n;
    final s = d.stats;
    final next = nextRequirement(level, d.reqs);
    final nextLevel = next == null ? null : requirementLevel(d.reqs.indexOf(next));
    final cs = context.colors;
    String pct(double v, double t) => t <= 0 ? '100%' : '${(v / t * 100).clamp(0, 100).round()}%';
    final reach = l.sellerLevelReachNext;
    List<(String, String)> rows(String Function(LevelRequirement r) f) => [
      for (final (i, r) in d.reqs.indexed) (requirementLevel(i).localized(l), f(r)),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxxl),
      children: [
        Center(child: LevelHexIcon(level: level, size: 96)),
        Gaps.v10,
        Center(
          child: Text(
            level.localized(l),
            key: const ValueKey('level_name'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ),
        Gaps.v4,
        Center(
          child: Text(
            nextLevel == null ? l.sellerLevelTopReached : l.sellerLevelNext(nextLevel.localized(l)),
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ),
        Gaps.v24,
        _LevelTrack(current: level),
        const SizedBox(height: 28),
        Text(l.sellerLevelPerformance, style: context.textTheme.titleLarge),
        Gaps.v4,
        Text(l.sellerLevelBasedOn, style: context.textTheme.bodySmall),
        const SizedBox(height: 14),
        _MetricCard(
          title: l.sellerSuccessScore,
          info: l.sellerLevelSuccessInfo,
          value: s.successScore?.toString() ?? '–',
          bar: TargetProgressBar(
            value: (s.successScore ?? 0).toDouble(),
            max: 10,
            target: next?.successScore.toDouble(),
            showScale: true,
            scaleLabels: ('0', '${next?.successScore ?? ''}', '10'),
          ),
          footer: next == null ? null : (reach, '${next.successScore}'),
        ),
        _MetricCard(
          title: l.sellerRating,
          info: l.sellerLevelRatingInfo,
          value: s.rating == 0 ? '–' : fmtRating(s.rating),
          bar: TargetProgressBar(
            value: s.rating,
            max: 5,
            target: next?.rating,
            showScale: true,
            scaleLabels: ('0', next == null ? '' : fmtRating(next.rating), '5'),
          ),
          footer: next == null ? null : (reach, fmtRating(next.rating)),
        ),
        _MetricCard(
          title: l.sellerResponseRate,
          info: l.sellerLevelResponseInfo,
          value: '${s.responseRate}%',
          bar: TargetProgressBar(
            value: s.responseRate.toDouble(),
            max: 100,
            target: next?.responseRate.toDouble(),
            showScale: true,
            scaleLabels: ('0%', '${next?.responseRate ?? ''}%', '100%'),
          ),
          footer: next == null ? null : (reach, '${next.responseRate}%'),
        ),
        _TargetCard(
          title: l.sellerOrders,
          info: l.sellerLevelOrdersInfo,
          value: '${s.ordersCount} / ${next?.orders ?? s.ordersCount}',
          progress: pct(s.ordersCount.toDouble(), (next?.orders ?? 0).toDouble()),
          rows: rows((r) => '${r.orders}'),
        ),
        _TargetCard(
          title: l.sellerLevelUniqueClients,
          info: l.sellerLevelUniqueClientsInfo,
          value: '${s.uniqueClients} / ${next?.uniqueClients ?? s.uniqueClients}',
          progress: pct(s.uniqueClients.toDouble(), (next?.uniqueClients ?? 0).toDouble()),
          rows: rows((r) => '${r.uniqueClients}'),
        ),
        _TargetCard(
          title: l.sellerEarnings,
          info: l.sellerLevelEarningsInfo,
          value: '${Fmt.moneyShort(s.totalEarnings)} / ${Fmt.moneyShort(next?.earnings ?? s.totalEarnings)} ₫',
          progress: pct(s.totalEarnings.toDouble(), (next?.earnings ?? 0).toDouble()),
          rows: rows((r) => Fmt.money(r.earnings)),
        ),
      ],
    );
  }
}

/// Thanh tiến trình các cấp: Mới → Cấp 1 → Cấp 2 → Top Rated.
class _LevelTrack extends StatelessWidget {
  const _LevelTrack({required this.current});
  final SellerLevel current;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    const levels = SellerLevel.values;
    return Row(
      children: [
        for (var i = 0; i < levels.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                  child: levels[i] == current
                      ? Icon(Icons.arrow_drop_down_rounded, color: cs.onSurface, size: 26)
                      : null,
                ),
                Gaps.v4,
                Opacity(
                  opacity: levels[i].index <= current.index ? 1 : 0.45,
                  child: LevelHexIcon(level: levels[i], size: levels[i] == current ? 34 : 26),
                ),
                Gaps.v6,
                Text(
                  levels[i].localized(context.l10n),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: levels[i] == current ? FontWeight.w700 : FontWeight.w500,
                    color: levels[i] == current ? cs.onSurface : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (i < levels.length - 1)
            Container(
              width: 18,
              height: 2,
              margin: const EdgeInsets.only(bottom: Space.xs),
              color: levels[i + 1].index <= current.index ? context.tokens.brand : cs.outline,
            ),
        ],
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.title, required this.info, required this.value});
  final String title;
  final String info;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Flexible(
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ),
      IconButton(
        visualDensity: VisualDensity.compact,
        tooltip: context.l10n.sellerLevelExplain,
        icon: Icon(Icons.info_outline_rounded, size: 18, color: context.colors.onSurfaceVariant),
        onPressed: () => showExplainSheet(context, title: title, body: info),
      ),
      const Spacer(),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
    ],
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.info, required this.value, required this.bar, this.footer});
  final String title;
  final String info;
  final String value;
  final Widget bar;
  final (String, String)? footer;

  @override
  Widget build(BuildContext context) => AppCard(
    margin: const EdgeInsets.only(bottom: Space.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CardTitle(title: title, info: info, value: value),
        Gaps.v8,
        bar,
        if (footer != null) ...[Gaps.v12, _Footer(label: footer!.$1, value: footer!.$2)],
      ],
    ),
  );
}

class _Footer extends StatelessWidget {
  const _Footer({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      border: Border(left: BorderSide(color: context.tokens.brand, width: 2)),
    ),
    child: Row(
      children: [
        Expanded(child: Text(label, style: context.textTheme.bodySmall)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    ),
  );
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({
    required this.title,
    required this.info,
    required this.value,
    required this.progress,
    required this.rows,
  });
  final String title;
  final String info;
  final String value;
  final String progress;

  /// (tên cấp, giá trị mục tiêu).
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    return AppCard(
      margin: const EdgeInsets.only(bottom: Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardTitle(title: title, info: info, value: value),
          Gaps.v4,
          _Footer(label: l.sellerLevelProgressNext, value: progress),
          Gaps.v8,
          for (final r in rows)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: cs.outlineVariant)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l.sellerLevelTarget(r.$1), style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                  ),
                  Text(r.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
