import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/order.dart';
import '../widgets/order_widgets.dart';
import 'status_banners.dart';

/// Khối bản giao mới nhất (đơn ở trạng thái đã giao).
class OrderDeliveryBlock extends StatelessWidget {
  const OrderDeliveryBlock({
    super.key,
    required this.order,
    required this.seller,
    required this.busy,
    required this.onApprove,
    required this.onNotReady,
  });
  final Order order;
  final bool seller;
  final bool busy;
  final VoidCallback onApprove;
  final VoidCallback onNotReady;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final small = context.textTheme.bodySmall;
    final d = order.deliveries.isEmpty ? null : order.deliveries.last;
    final deadline = order.reviewDeadline;
    return Padding(
      padding: orderDetailBlockPadding,
      child: AppCard(
        key: const ValueKey('delivery_block'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 20),
                Gaps.h8,
                Expanded(
                  child: Text(
                    seller ? l.ordersDetailYouDelivered : l.ordersDetailYourDelivery,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ],
            ),
            if (d != null) ...[
              Gaps.v12,
              Container(
                width: double.infinity,
                padding: Insets.cardSm,
                decoration: BoxDecoration(color: context.colors.surfaceContainerHighest, borderRadius: Radii.mdAll),
                child: Text(d.message, style: const TextStyle(fontSize: 13.5, height: 1.45)),
              ),
              Gaps.v12,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.ordersDetailFileCount(d.files.length),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (d.files.isNotEmpty)
                    TextButton.icon(
                      key: const ValueKey('download_all'),
                      onPressed: () => showAppSnack(context, l.ordersDetailDownloadingAll(d.files.length)),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: Text(l.ordersDetailDownloadAll),
                    ),
                ],
              ),
              for (final f in d.files)
                Padding(
                  padding: const EdgeInsets.only(top: Space.sm),
                  child: FileTile(
                    name: f,
                    size: l.ordersDetailVirusScanned,
                    onTap: () => showAppSnack(context, l.ordersDetailDownloadingFile(f)),
                  ),
                ),
            ],
            Gaps.v16,
            if (seller)
              Text(
                deadline == null
                    ? l.ordersDetailAwaitingBuyerReview
                    : l.ordersDetailBuyerReviewUntil(Fmt.dateTime(deadline)),
                style: small,
              )
            else ...[
              PrimaryButton(
                key: const ValueKey('approve_delivery'),
                label: l.ordersDetailApproveDelivery,
                loading: busy,
                onPressed: onApprove,
              ),
              Gaps.v8,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  key: const ValueKey('not_ready'),
                  onPressed: busy ? null : onNotReady,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l.ordersDetailNotReady),
                      Gaps.h4,
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              Gaps.v10,
              Text(
                deadline == null ? l.ordersDetailReviewHint : l.ordersDetailReviewUntil(Fmt.dateTime(deadline)),
                key: const ValueKey('review_deadline'),
                style: small,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
