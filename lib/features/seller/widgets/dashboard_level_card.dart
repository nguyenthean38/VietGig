import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/account.dart';
import '../../../data/models/user.dart';
import 'level_hex_icon.dart';
import 'target_progress_bar.dart';

/// Thẻ cấp độ + chỉ số chính trên bảng điều khiển người bán.
class SellerDashLevelCard extends StatelessWidget {
  const SellerDashLevelCard({super.key, required this.stats, required this.level, required this.next});
  final SellerStats stats;
  final SellerLevel level;
  final LevelRequirement? next;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final s = stats;
    final divider = Divider(height: 1, color: cs.outlineVariant);
    const cellPad = EdgeInsets.all(14);
    Widget cell(Widget child, {VoidCallback? onTap, Key? key}) => Expanded(
      child: InkWell(
        key: key,
        onTap: onTap,
        child: Padding(padding: cellPad, child: child),
      ),
    );
    Widget label(String t) => Text(t, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant));
    Widget big(String t) => Text(t, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800));

    String target(int v, int? t, {bool money = false}) {
      final f = money ? Fmt.moneyShort : (num x) => '$x';
      return t == null ? f(v) : '${f(v)} / ${f(t)}';
    }

    Widget line(String label, String v) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: Space.md),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );

    Widget metric(String title, String value, Widget bar) => cell(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [label(title), Gaps.v10, big(value), Gaps.v8, bar],
      ),
    );

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                cell(
                  key: const ValueKey('dash_level'),
                  onTap: () => context.push('/seller/level'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: label(l.sellerDashMyLevel)),
                          Icon(Icons.chevron_right_rounded, size: 18, color: cs.onSurfaceVariant),
                        ],
                      ),
                      Gaps.v10,
                      LevelHexIcon(level: level, size: 34),
                      Gaps.v6,
                      Text(level.localized(l), style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                VerticalDivider(width: 1, color: cs.outlineVariant),
                metric(
                  l.sellerSuccessScore,
                  s.successScore?.toString() ?? '–',
                  TargetProgressBar(
                    value: (s.successScore ?? 0).toDouble(),
                    max: 10,
                    target: next?.successScore.toDouble(),
                  ),
                ),
              ],
            ),
          ),
          divider,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                metric(
                  l.sellerRating,
                  s.rating == 0 ? '–' : fmtRating(s.rating),
                  TargetProgressBar(value: s.rating, max: 5, target: next?.rating),
                ),
                VerticalDivider(width: 1, color: cs.outlineVariant),
                metric(
                  l.sellerResponseRate,
                  '${s.responseRate}%',
                  TargetProgressBar(value: s.responseRate.toDouble(), max: 100, target: next?.responseRate.toDouble()),
                ),
              ],
            ),
          ),
          divider,
          line(l.sellerOrders, target(s.ordersCount, next?.orders)),
          divider,
          line(l.sellerClients, target(s.uniqueClients, next?.uniqueClients)),
          divider,
          line(l.sellerEarnings, '${target(s.totalEarnings, next?.earnings, money: true)} ₫'),
        ],
      ),
    );
  }
}
