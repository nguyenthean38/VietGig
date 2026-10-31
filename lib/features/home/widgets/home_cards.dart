import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/chat.dart';
import '../../../data/models/order.dart';
import '../../gig/widgets/discovery_widgets.dart';

/// Báo giá riêng đang chờ, kèm hội thoại và tin nhắn chứa nó.
class HomeOfferItem {
  const HomeOfferItem(this.conversation, this.message, this.offer);
  final Conversation conversation;
  final ChatMessage message;
  final CustomOffer offer;
}

/// Avatar nhỏ + tên người bán (tải theo id).
class _SellerLine extends StatelessWidget {
  const _SellerLine({required this.sellerId, required this.size, this.style});
  final String sellerId;
  final double size;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => UserBuilder(
    userId: sellerId,
    builder: (context, u) => Row(
      children: [
        UserAvatar(user: u, name: u?.displayName ?? '…', size: size),
        Gaps.h6,
        Flexible(
          child: Text(u?.displayName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
        ),
      ],
    ),
  );
}

/// Thẻ "Báo giá riêng dành cho bạn".
class HomeOfferCard extends StatelessWidget {
  const HomeOfferCard({super.key, required this.item, required this.width});
  final HomeOfferItem item;
  final double width;

  @override
  Widget build(BuildContext context) {
    final o = item.offer;
    final l = context.l10n;
    return SizedBox(
      width: width,
      child: AppCard(
        key: ValueKey('offer_${o.id}'),
        padding: Insets.cardSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlaceholderImage(
                  seed: o.gigId.hashCode,
                  image: AppImages.gigCover(o.gigId),
                  width: 56,
                  height: 56,
                  radius: Space.sm,
                ),
                Gaps.h10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SellerLine(
                        sellerId: o.sellerId,
                        size: 20,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      Gaps.v4,
                      Text(
                        o.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              l.homeOfferSummary(Fmt.money(o.totalPrice), Fmt.days(o.totalDays)),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            if (o.expiresAt != null) ...[
              Gaps.v2,
              Text(
                l.homeOfferExpires(Fmt.dateTime(o.expiresAt!)),
                style: TextStyle(color: context.colors.onSurfaceVariant, fontSize: 12),
              ),
            ],
            Gaps.v10,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: ValueKey('offer_chat_${o.id}'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 40)),
                    onPressed: () => context.push('/chat/${item.conversation.id}'),
                    child: Text(l.homeOfferOpenChat),
                  ),
                ),
                Gaps.h10,
                Expanded(
                  child: FilledButton(
                    key: ValueKey('offer_view_${o.id}'),
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                    onPressed: () => context.push('/chat/${item.conversation.id}/offer/${item.message.id}'),
                    child: Text(l.homeOfferView),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Thẻ đơn hàng đang thực hiện (gig, người bán, trạng thái, hạn giao).
class HomeActiveOrderCard extends StatelessWidget {
  const HomeActiveOrderCard({super.key, required this.order, required this.width});
  final Order order;
  final double width;

  @override
  Widget build(BuildContext context) {
    final o = order;
    return SizedBox(
      width: width,
      child: AppCard(
        key: ValueKey('home_order_${o.id}'),
        onTap: () => context.push('/orders/${o.id}'),
        padding: Insets.cardSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GigThumbRow(seed: o.gigImageSeed, title: o.gigTitle, subtitle: Fmt.money(o.total)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _SellerLine(sellerId: o.sellerId, size: 22, style: context.textTheme.bodySmall),
                ),
                OrderStatusPill(o.status),
              ],
            ),
            Gaps.v6,
            Text(context.l10n.homeOrderDue(Fmt.date(o.dueDate)), style: context.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
