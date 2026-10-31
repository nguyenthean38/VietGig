import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../data/models/account.dart';
import '../../../data/models/user.dart';
import 'level_hex_icon.dart';

/// Bottom sheet có tiêu đề và đoạn giải thích.
Future<void> showExplainSheet(BuildContext context, {required String title, required String body}) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: ctx.textTheme.titleLarge),
              Gaps.v10,
              Text(body, style: ctx.textTheme.bodyMedium?.copyWith(color: ctx.colors.onSurfaceVariant, height: 1.45)),
              Gaps.v20,
              FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.sellerGotIt)),
            ],
          ),
        ),
      ),
    );

/// Bảng "Hệ thống cấp độ" so sánh yêu cầu của các cấp.
Future<void> showLevelSystemSheet(BuildContext context, List<LevelRequirement> reqs) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (ctx) => _LevelSystemSheet(reqs: reqs),
);

class _LevelSystemSheet extends StatelessWidget {
  const _LevelSystemSheet({required this.reqs});
  final List<LevelRequirement> reqs;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final levels = [SellerLevel.level1, SellerLevel.level2, SellerLevel.topRated];
    final border = BoxDecoration(
      border: Border(bottom: BorderSide(color: cs.outlineVariant)),
    );
    TableRow row(String label, List<String> cells) => TableRow(
      decoration: border,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.md),
          child: Text(label, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
        ),
        for (final c in cells)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.md),
            child: Text(
              c,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xl),
        child: Column(
          key: const ValueKey('level_system_sheet'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.sellerLevelSystem, style: context.textTheme.titleLarge),
            Gaps.v6,
            Text(l.sellerLevelSystemDesc, style: context.textTheme.bodySmall),
            Gaps.v16,
            Table(
              columnWidths: const {0: FlexColumnWidth(1.5)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: border,
                  children: [
                    Text(l.sellerLevelColumn, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                    for (final lv in levels)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            LevelHexIcon(level: lv, size: 26),
                            Gaps.v4,
                            Text(
                              lv.localized(l),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: levelColor(lv)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                row(l.sellerSuccessScore, [for (final r in reqs) '${r.successScore}']),
                row(l.sellerRating, [for (final r in reqs) fmtRating(r.rating)]),
                row(l.sellerResponseRate, [for (final r in reqs) '${r.responseRate}%']),
                row(l.sellerOrders, [for (final r in reqs) '${r.orders}']),
                row(l.sellerClients, [for (final r in reqs) '${r.uniqueClients}']),
                row(l.sellerEarnings, [for (final r in reqs) Fmt.moneyShort(r.earnings)]),
              ],
            ),
            Gaps.v12,
            Text(l.sellerLevelTopRatedNote, style: context.textTheme.bodySmall),
            Gaps.v16,
            FilledButton(onPressed: () => Navigator.pop(context), child: Text(l.commonClose)),
          ],
        ),
      ),
    );
  }
}
