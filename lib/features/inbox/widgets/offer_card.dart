import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/chat.dart';

/// Thẻ báo giá riêng trong cuộc trò chuyện.
class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    required this.isSeller,
    required this.onView,
    required this.onDecline,
    required this.onWithdraw,
  });
  final CustomOffer offer;

  /// Người đang xem là người bán đã gửi báo giá.
  final bool isSeller;
  final VoidCallback onView;
  final VoidCallback onDecline;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final expired =
        offer.status == OfferStatus.pending && offer.expiresAt != null && offer.expiresAt!.isBefore(DateTime.now());
    final status = expired ? OfferStatus.expired : offer.status;
    final pending = status == OfferStatus.pending;

    Widget info(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(top: Space.sm),
      child: Row(
        children: [
          Icon(icon, size: 17, color: cs.onSurfaceVariant),
          Gaps.h8,
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
          ),
        ],
      ),
    );

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  offer.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              if (!pending) ...[Gaps.h8, _StatusPill(status)],
            ],
          ),
          Gaps.v6,
          Text(
            offer.description,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13.5, height: 1.4),
          ),
          Gaps.v4,
          if (offer.isMilestone)
            info(Icons.flag_outlined, l.inboxMilestoneCount(offer.milestones.length))
          else
            info(Icons.schedule_rounded, l.inboxDeliverIn(offer.deliveryDays)),
          if (offer.serviceOptions.isNotEmpty)
            info(
              Icons.add_circle_outline_rounded,
              l.inboxOptionsSummary(offer.serviceOptions.length, offer.serviceOptions.join(', ')),
            ),
          info(Icons.payments_outlined, l.inboxOfferPrice(Fmt.money(offer.totalPrice))),
          if (pending && offer.expiresAt != null)
            info(Icons.timer_outlined, l.inboxOfferExpiresAt(Fmt.dateTime(offer.expiresAt!))),
          const SizedBox(height: 14),
          if (!isSeller)
            PrimaryButton(key: ValueKey('offer_view_${offer.id}'), label: l.inboxViewFullOffer, onPressed: onView)
          else
            OutlinedButton(
              key: ValueKey('offer_view_${offer.id}'),
              onPressed: onView,
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
              child: Text(l.inboxViewFullOffer),
            ),
          if (pending) ...[
            Gaps.v8,
            OutlinedButton(
              key: ValueKey(isSeller ? 'offer_withdraw_${offer.id}' : 'offer_decline_${offer.id}'),
              onPressed: isSeller ? onWithdraw : onDecline,
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
              child: Text(isSeller ? l.inboxWithdrawOffer : l.inboxDecline),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill(this.status);
  final OfferStatus status;
  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final (bg, fg) = switch (status) {
      OfferStatus.accepted => (t.brandSoft, t.brandStrong),
      OfferStatus.declined || OfferStatus.withdrawn => (t.dangerSoft, t.danger),
      _ => (t.warningSoft, t.warning),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Radii.xs)),
      child: Text(
        status.localized(context.l10n),
        style: TextStyle(color: fg, fontSize: 11.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Thẻ lời mời gọi video.
class VideoCallCard extends StatelessWidget {
  const VideoCallCard({
    super.key,
    required this.messageId,
    required this.fromMe,
    required this.declined,
    required this.onJoin,
    required this.onDecline,
    required this.onGuidelines,
  });
  final String messageId;
  final bool fromMe;
  final bool declined;
  final VoidCallback onJoin;
  final VoidCallback onDecline;
  final VoidCallback onGuidelines;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final t = context.tokens;
    final l = context.l10n;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: t.infoSoft, borderRadius: BorderRadius.circular(Space.sm)),
            child: Icon(Icons.videocam_rounded, color: t.info, size: 22),
          ),
          Gaps.v10,
          Text(
            fromMe ? l.inboxVideoSent : l.inboxVideoJoinPrompt,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
          ),
          Gaps.v4,
          GestureDetector(
            onTap: onGuidelines,
            child: Text(
              l.inboxVideoGuidelinesLink,
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Gaps.v8,
          Text(l.inboxVideoRecorded, style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant, height: 1.35)),
          Gaps.v12,
          if (declined)
            Row(
              children: [
                Icon(Icons.call_end_rounded, size: 18, color: cs.onSurfaceVariant),
                Gaps.h6,
                Text(l.inboxVideoDeclinedLabel, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
              ],
            )
          else ...[
            PrimaryButton(key: ValueKey('video_join_$messageId'), label: l.inboxJoin, color: t.info, onPressed: onJoin),
            Gaps.v8,
            OutlinedButton(
              key: ValueKey('video_decline_$messageId'),
              onPressed: onDecline,
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
              child: Text(fromMe ? l.inboxCancelInvite : l.inboxDecline),
            ),
          ],
        ],
      ),
    );
  }
}
