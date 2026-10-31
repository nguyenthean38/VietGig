import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/order_widgets.dart';

/// Sheet "Chưa sẵn sàng". Trả về 'revision' | 'time' | 'resolution'.
Future<String?> showNotReadySheet(BuildContext context) => showModalBottomSheet<String>(
  context: context,
  builder: (ctx) {
    final l = ctx.l10n;
    final plum = ctx.tokens.plum;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            key: const ValueKey('sheet_revision'),
            leading: const Icon(Icons.replay_rounded),
            title: Text(l.ordersDetailRequestRevision, style: const TextStyle(fontWeight: FontWeight.w500)),
            onTap: () => Navigator.pop(ctx, 'revision'),
          ),
          ListTile(
            key: const ValueKey('sheet_more_time'),
            leading: const Icon(Icons.more_time_rounded),
            title: Row(
              children: [
                Flexible(
                  child: Text(l.ordersDetailNeedMoreTime, style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
                Gaps.h8,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: Space.xxs),
                  decoration: BoxDecoration(color: plum.withValues(alpha: 0.12), borderRadius: Radii.smAll),
                  child: Text(
                    l.ordersDetailNewTag,
                    style: TextStyle(color: plum, fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.pop(ctx, 'time'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, Space.md),
            child: InkWell(
              onTap: () => Navigator.pop(ctx, 'resolution'),
              child: Text.rich(
                TextSpan(
                  text: l.ordersDetailResolutionPrefix,
                  children: [
                    TextSpan(
                      text: l.ordersResolutionCenter,
                      style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: '.'),
                  ],
                  style: ctx.textTheme.bodySmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
);

/// Sheet chọn số ngày thêm để xem bản giao (1–5). Trả về số ngày đã chọn.
Future<int?> showMoreTimeSheet(BuildContext context, {required DateTime base}) {
  var days = 0;
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) {
        final l = ctx.l10n;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.ordersDetailMoreTimeTitle, style: ctx.textTheme.titleMedium),
                Gaps.v6,
                Text(l.ordersDetailMoreTimeMessage, style: ctx.textTheme.bodySmall),
                Gaps.v8,
                for (var d = 1; d <= 5; d++)
                  RadioRow(
                    key: ValueKey('review_days_$d'),
                    label: l.timeNDays(d),
                    selected: days == d,
                    onTap: () => setS(() => days = d),
                  ),
                if (days > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: Space.sm),
                    child: Text(
                      l.ordersDetailNewReviewDeadline(Fmt.dateTime(base.add(Duration(days: days)))),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                const SizedBox(height: 14),
                PrimaryButton(
                  key: const ValueKey('review_days_submit'),
                  label: l.ordersDetailExtendReview,
                  onPressed: days == 0 ? null : () => Navigator.pop(ctx, days),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
