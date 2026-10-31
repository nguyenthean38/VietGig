import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/order_widgets.dart';
import 'status_banners.dart';

/// Khối yêu cầu huỷ / gia hạn đang chờ phản hồi.
class OrderPendingRequestBlock extends StatelessWidget {
  const OrderPendingRequestBlock({
    super.key,
    required this.bundle,
    required this.seller,
    required this.busy,
    required this.onRespond,
  });
  final OrderBundle bundle;
  final bool seller;
  final bool busy;
  final ValueChanged<bool> onRespond;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    final o = bundle.order;
    final r = o.pendingRequest!;
    final mine = r.fromSeller == seller;
    final isCancel = r.kind == 'cancel';
    final other = otherName(l, bundle);
    final deadline = r.at.add(const Duration(days: 2));
    final small = context.textTheme.bodySmall;
    final String text;
    if (isCancel) {
      text = mine ? l.ordersDetailCancelRequestedByYou : l.ordersDetailCancelRequestedBy(other);
    } else {
      text = mine
          ? l.ordersDetailExtensionRequestedByYou(r.extraDays)
          : l.ordersDetailExtensionRequestedBy(other, r.extraDays);
    }
    return Padding(
      padding: orderDetailBlockPadding,
      child: AppCard(
        key: const ValueKey('pending_request'),
        borderColor: t.warning.withValues(alpha: 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.gavel_rounded, color: t.warning, size: 20),
                Gaps.h8,
                Expanded(
                  child: Text(
                    isCancel ? l.ordersDetailCancelRequestTitle : l.ordersDetailExtensionRequestTitle,
                    style: TextStyle(color: t.warning, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Gaps.v8,
            Text(text, style: const TextStyle(fontSize: 14)),
            if (r.message.trim().isNotEmpty) ...[
              Gaps.v10,
              Container(
                width: double.infinity,
                padding: Insets.cardSm,
                decoration: BoxDecoration(color: context.colors.surfaceContainerHighest, borderRadius: Radii.mdAll),
                child: Text(r.message.trim(), style: const TextStyle(fontSize: 13.5, height: 1.4)),
              ),
            ],
            if (!isCancel) ...[
              Gaps.v10,
              SummaryRow(l.ordersDetailExtensionLength, l.timeNDays(r.extraDays)),
              SummaryRow(l.ordersDetailNewDueDate, Fmt.date(o.dueDate.add(Duration(days: r.extraDays)))),
            ],
            Gaps.v8,
            if (mine)
              Row(
                children: [
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  Gaps.h10,
                  Expanded(child: Text(l.ordersDetailAwaitingResponse(other, Fmt.dateTime(deadline)), style: small)),
                ],
              )
            else ...[
              Text(l.ordersDetailRespondBefore(Fmt.dateTime(deadline)), style: small),
              Gaps.v12,
              PrimaryButton(
                key: const ValueKey('accept_request'),
                label: l.ordersDetailAccept,
                loading: busy,
                onPressed: () => onRespond(true),
              ),
              Gaps.v8,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  key: const ValueKey('decline_request'),
                  onPressed: busy ? null : () => onRespond(false),
                  child: Text(l.ordersDetailDecline),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
