import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';

/// Bottom sheet chọn một giá trị trong danh sách.
Future<T?> pickFromList<T>(
  BuildContext context, {
  required String title,
  required List<T> values,
  required String Function(T) label,
  T? current,
  String keyPrefix = 'pick',
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (ctx) => ConstrainedBox(
    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.6),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.sm),
            child: Text(title, style: ctx.textTheme.titleLarge),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final v in values)
                  ListTile(
                    key: ValueKey('${keyPrefix}_$v'),
                    title: Text(
                      label(v),
                      style: TextStyle(fontWeight: v == current ? FontWeight.w700 : FontWeight.w500),
                    ),
                    trailing: v == current ? Icon(Icons.check_rounded, color: ctx.tokens.brand) : null,
                    onTap: () => Navigator.pop(ctx, v),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

/// Chọn thời gian giao (1–30 ngày).
Future<int?> pickDeliveryDays(BuildContext context, {int? current, String keyPrefix = 'days'}) => pickFromList<int>(
  context,
  title: context.l10n.inboxDeliveryTime,
  values: List.generate(30, (i) => i + 1),
  label: Fmt.days,
  current: current,
  keyPrefix: keyPrefix,
);

/// Chọn số lượt sửa (0–10).
Future<int?> pickRevisions(BuildContext context, {int? current, String keyPrefix = 'rev'}) {
  final l = context.l10n;
  return pickFromList<int>(
    context,
    title: l.inboxRevisionsTitle,
    values: List.generate(11, (i) => i),
    label: (v) => v == 0 ? l.inboxNoRevisions : l.inboxRevisionsCount(v),
    current: current,
    keyPrefix: keyPrefix,
  );
}

/// Chọn thời hạn báo giá.
Future<int?> pickOfferExpiry(BuildContext context, {int? current}) => pickFromList<int>(
  context,
  title: context.l10n.inboxOfferExpiry,
  values: const [1, 3, 7, 14],
  label: Fmt.days,
  current: current,
  keyPrefix: 'exp',
);

/// Sheet "Liên kết với dịch vụ".
Future<Gig?> showGigPicker(BuildContext context, {required List<Gig> gigs, Gig? current}) => showModalBottomSheet<Gig>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (ctx) => ConstrainedBox(
    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.75),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.sm),
            child: Text(ctx.l10n.inboxLinkGigTitle, style: ctx.textTheme.titleLarge),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
              children: [
                for (final g in gigs)
                  AppCard(
                    key: ValueKey('pick_gig_${g.id}'),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    borderColor: g.id == current?.id ? ctx.colors.onSurface : null,
                    onTap: () => Navigator.pop(ctx, g),
                    child: GigThumbRow(
                      seed: g.imageSeeds.isEmpty ? 0 : g.imageSeeds.first,
                      label: g.imageLabel,
                      title: g.title,
                      subtitle: g.packages.isEmpty
                          ? null
                          : '${ctx.l10n.commonFrom} ${Fmt.money(g.packages.first.price)}',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

/// Sheet chọn hình thức thanh toán. Trả về true = theo cột mốc.
Future<bool?> showPaymentTypeSheet(BuildContext context, {required bool milestone}) => showModalBottomSheet<bool>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (ctx) {
    final l = ctx.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.inboxPayTypeTitle, style: ctx.textTheme.titleLarge),
            Gaps.v4,
            Text(l.inboxPayTypeSubtitle, style: ctx.textTheme.bodySmall),
            Gaps.v16,
            OptionTile(
              key: const ValueKey('pay_single'),
              label: l.inboxPaySingle,
              description: l.inboxPaySingleDesc,
              icon: Icons.receipt_long_outlined,
              selected: !milestone,
              onTap: () => Navigator.pop(ctx, false),
            ),
            Gaps.v12,
            OptionTile(
              key: const ValueKey('pay_milestone'),
              label: l.inboxPayMilestone,
              description: l.inboxPayMilestoneDesc,
              icon: Icons.flag_outlined,
              selected: milestone,
              onTap: () => Navigator.pop(ctx, true),
            ),
          ],
        ),
      ),
    );
  },
);
