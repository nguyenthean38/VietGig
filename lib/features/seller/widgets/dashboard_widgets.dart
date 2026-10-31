import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/order.dart';
import '../../../data/models/user.dart';

/// Lời chào đầu bảng điều khiển người bán.
class SellerDashHeader extends StatelessWidget {
  const SellerDashHeader({super.key, required this.user});
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.sellerDashGreeting(user?.displayName ?? l.sellerDashGreetingFallback),
                  style: TextStyle(fontSize: 15, color: context.colors.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.v2,
                Text(
                  l.sellerDashWelcomeBack,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.3),
                ),
              ],
            ),
          ),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.go('/profile'),
            child: UserAvatar(user: user, name: user?.displayName, size: 48, showOnline: true),
          ),
        ],
      ),
    );
  }
}

/// Banner "Hoàn thiện hồ sơ người bán".
class SellerSetupBanner extends StatelessWidget {
  const SellerSetupBanner({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
      padding: const EdgeInsets.fromLTRB(Space.lg, 14, Space.sm, 14),
      decoration: BoxDecoration(color: context.tokens.brandStrong, borderRadius: Radii.lgAll),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.sellerDashSetupTitle,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Gaps.v6,
                Text(l.sellerDashSetupBody, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.35)),
                Gaps.v10,
                InkWell(
                  onTap: () => context.push('/seller/gigs'),
                  child: Text(
                    l.sellerDashSetupLink,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            key: const ValueKey('seller_banner_close'),
            tooltip: l.commonClose,
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// Một dòng "Việc cần làm" có bộ đếm.
class SellerTodoTile extends StatelessWidget {
  const SellerTodoTile({
    super.key,
    required this.count,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final int count;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: context.textTheme.bodySmall),
                ],
              ),
            ),
            Gaps.h12,
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: count > 0 ? context.tokens.brand : null,
                border: count > 0 ? null : Border.all(color: cs.outline),
              ),
              child: Text(
                '$count',
                style: TextStyle(fontWeight: FontWeight.w700, color: count > 0 ? Colors.white : cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dòng thống kê có mũi tên xu hướng.
class SellerStatLine extends StatelessWidget {
  const SellerStatLine({super.key, required this.label, required this.value, required this.up});
  final String label;
  final String value;
  final bool up;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Space.sm),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        Gaps.h4,
        Icon(
          up ? Icons.arrow_upward_rounded : Icons.remove_rounded,
          size: 16,
          color: up ? context.tokens.brand : context.colors.onSurfaceVariant,
        ),
      ],
    ),
  );
}

/// Nhãn nhỏ + giá trị đậm.
class SellerMetric extends StatelessWidget {
  const SellerMetric(this.label, this.value, {super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: context.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
      Gaps.v4,
      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    ],
  );
}

/// Hai widget chia đôi chiều ngang.
class SellerPairRow extends StatelessWidget {
  const SellerPairRow({super.key, required this.a, required this.b});
  final Widget a;
  final Widget b;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: a),
      Gaps.h12,
      Expanded(child: b),
    ],
  );
}

/// Thẻ đơn hàng đang thực hiện.
class SellerActiveOrderTile extends StatelessWidget {
  const SellerActiveOrderTile({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: Insets.cardSm,
    onTap: () => context.push('/orders/${order.id}'),
    child: Row(
      children: [
        PlaceholderImage(seed: order.gigImageSeed, radius: Space.sm, width: 64, height: 52),
        Gaps.h12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.gigTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Gaps.v6,
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OrderStatusPill(order.status),
                  Text(context.l10n.sellerDashDue(Fmt.date(order.dueDate)), style: context.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        Gaps.h8,
        Text(Fmt.money(order.subtotal), style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}
