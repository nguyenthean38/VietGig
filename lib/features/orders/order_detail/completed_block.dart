import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/order_widgets.dart';
import 'status_banners.dart';

/// Khối đơn đã hoàn thành: banner, đánh giá, tip.
class OrderCompletedBlock extends StatelessWidget {
  const OrderCompletedBlock({super.key, required this.bundle, required this.seller, required this.onRate});
  final OrderBundle bundle;
  final bool seller;

  /// Mở màn đánh giá / tip.
  final VoidCallback onRate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    final cs = context.colors;
    final small = context.textTheme.bodySmall;
    final o = bundle.order;
    final r = o.review;
    return Padding(
      padding: orderDetailBlockPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            color: t.brandSoft,
            borderColor: t.brand.withValues(alpha: 0.4),
            child: Row(
              children: [
                Icon(Icons.verified_rounded, color: t.brand),
                Gaps.h10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.ordersDetailCompletedTitle,
                        style: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface),
                      ),
                      Gaps.v2,
                      Text(l.ordersDetailCompletedMessage, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gaps.v12,
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller ? l.ordersDetailBuyerReview : l.ordersDetailMyReview,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5),
                ),
                Gaps.v10,
                if (r == null)
                  seller
                      ? Text(l.ordersDetailNoBuyerReview, style: small)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(l.ordersDetailShareExperience, style: small),
                            Gaps.v10,
                            PrimaryButton(
                              key: const ValueKey('write_review'),
                              label: l.ordersDetailWriteReview,
                              onPressed: onRate,
                            ),
                          ],
                        )
                else ...[
                  Row(
                    children: [
                      StarRating(value: r.overall, size: 20),
                      Gaps.h8,
                      Text(r.overall.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  if (r.text.isNotEmpty) ...[Gaps.v8, Text(r.text, style: const TextStyle(fontSize: 14, height: 1.4))],
                  if (r.highlights.isNotEmpty) ...[
                    Gaps.v8,
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final h in r.highlights)
                          Chip(
                            label: Text(h, style: const TextStyle(fontSize: 12)),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
          if (!seller) ...[
            Gaps.v12,
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.volunteer_activism_outlined),
                  Gaps.h12,
                  Expanded(
                    child: o.tip > 0
                        ? Text(
                            l.ordersDetailTipped(Fmt.money(o.tip), otherName(l, bundle)),
                            style: const TextStyle(fontSize: 14),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.ordersDetailTipTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
                              Gaps.v2,
                              Text(l.ordersDetailTipMessage, style: const TextStyle(fontSize: 12.5)),
                            ],
                          ),
                  ),
                  if (o.tip == 0)
                    TextButton(
                      key: const ValueKey('detail_tip'),
                      onPressed: onRate,
                      child: Text(l.ordersDetailSendTip),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
