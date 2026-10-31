import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Lề chuẩn của các khối trong màn chi tiết đơn.
const orderDetailBlockPadding = EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0);

/// Banner "Cảm ơn bạn đã đặt hàng!" ngay sau khi đặt.
class OrderThanksBanner extends StatelessWidget {
  const OrderThanksBanner({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    // Nền đậm tương phản (đen ở chế độ sáng), chữ màu nền để đọc được cả ở chế độ tối.
    final fg = context.colors.surface;
    return Container(
      margin: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, 0),
      padding: const EdgeInsets.fromLTRB(14, 10, Space.xs, 10),
      decoration: BoxDecoration(color: context.colors.onSurface, borderRadius: Radii.mdAll),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: fg),
          Gaps.h10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.ordersDetailThanksTitle,
                  style: TextStyle(color: fg, fontWeight: FontWeight.w700),
                ),
                Text(l.ordersDetailThanksMessage, style: TextStyle(color: fg.withValues(alpha: 0.7), fontSize: 12.5)),
              ],
            ),
          ),
          IconButton(
            tooltip: l.commonClose,
            onPressed: onClose,
            icon: Icon(Icons.close_rounded, color: fg),
          ),
        ],
      ),
    );
  }
}

/// Banner chờ / gửi yêu cầu khi đơn đang ở trạng thái chờ yêu cầu.
class OrderRequirementsBanner extends StatelessWidget {
  const OrderRequirementsBanner({super.key, required this.seller, required this.onSubmit});
  final bool seller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    final cs = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 0),
      child: AppCard(
        color: t.warningSoft,
        borderColor: t.warning.withValues(alpha: 0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment_late_outlined, color: t.warning),
                Gaps.h10,
                Expanded(
                  child: Text(
                    seller ? l.ordersDetailWaitingRequirements : l.ordersDetailSubmitRequirements,
                    style: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface),
                  ),
                ),
              ],
            ),
            Gaps.v6,
            Text(
              seller ? l.ordersDetailWaitingRequirementsMessage : l.ordersDetailSubmitRequirementsMessage,
              style: TextStyle(fontSize: 13.5, color: cs.onSurfaceVariant),
            ),
            if (!seller) ...[
              Gaps.v12,
              PrimaryButton(
                key: const ValueKey('send_requirements'),
                label: l.ordersDetailSendRequest,
                onPressed: onSubmit,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Nút hành động của người bán: giao đơn, thư gửi khách, gia hạn.
class OrderSellerActions extends StatelessWidget {
  const OrderSellerActions({super.key, required this.onDeliver, required this.onMessage, required this.onExtend});
  final VoidCallback onDeliver;
  final VoidCallback onMessage;
  final VoidCallback onExtend;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 0),
      child: Column(
        children: [
          PrimaryButton(
            key: const ValueKey('deliver_button'),
            icon: Icons.inventory_2_outlined,
            label: l.ordersDetailDeliver,
            onPressed: onDeliver,
          ),
          Gaps.v8,
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('letter_to_buyer'),
                  onPressed: onMessage,
                  icon: const Icon(Icons.mail_outline_rounded, size: 18),
                  label: Text(l.ordersDetailLetterToBuyer),
                ),
              ),
              Gaps.h8,
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('seller_extend'),
                  onPressed: onExtend,
                  icon: const Icon(Icons.more_time_rounded, size: 18),
                  label: Text(l.ordersDetailExtend),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Khối thông báo đơn đã bị huỷ.
class OrderCancelledBlock extends StatelessWidget {
  const OrderCancelledBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: orderDetailBlockPadding,
      child: AppCard(
        child: Row(
          children: [
            Icon(Icons.block_rounded, color: context.colors.onSurfaceVariant),
            Gaps.h10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.ordersDetailCancelledTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Gaps.v2,
                  Text(l.ordersDetailCancelledMessage, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
