import 'package:flutter/material.dart';

import '../../data/models/order.dart';
import '../../data/models/user.dart';
import '../utils/format.dart';
import '../l10n/l10n.dart';

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.bg, required this.fg, this.trailing, this.fontSize = 11.5});
  final String text;
  final Color bg;
  final Color fg;
  final Widget? trailing;
  final double fontSize;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(color: fg, fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
        if (trailing != null) ...[const SizedBox(width: 4), trailing!],
      ],
    ),
  );
}

class VettedProBadge extends StatelessWidget {
  const VettedProBadge({super.key});
  @override
  Widget build(BuildContext context) =>
      _Pill(text: 'Vetted Pro', bg: context.tokens.vettedBg, fg: context.tokens.vettedFg);
}

class TopRatedBadge extends StatelessWidget {
  const TopRatedBadge({super.key});
  @override
  Widget build(BuildContext context) => _Pill(
    text: 'Top Rated',
    bg: context.tokens.topRatedBg,
    fg: context.tokens.topRatedFg,
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Icon(Icons.diamond, size: 9, color: context.tokens.topRatedFg),
        ),
      ),
    ),
  );
}

/// Nhãn cấp độ người bán (Cấp 1, Cấp 2, Top Rated, Mới).
class LevelBadge extends StatelessWidget {
  const LevelBadge(this.level, {super.key});
  final SellerLevel level;
  @override
  Widget build(BuildContext context) {
    if (level == SellerLevel.topRated) return const TopRatedBadge();
    final n = switch (level) {
      SellerLevel.level1 => 1,
      SellerLevel.level2 => 2,
      _ => 0,
    };
    return _Pill(
      text: level.localized(context.l10n),
      bg: context.colors.surfaceContainerHighest,
      fg: context.colors.onSurface,
      trailing: n == 0
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(n, (_) => Icon(Icons.diamond, size: 9, color: context.colors.onSurface)),
            ),
    );
  }
}

/// Huy hiệu "Pro" nhỏ trên ảnh gig.
class ProTag extends StatelessWidget {
  const ProTag({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: context.tokens.proTag, borderRadius: BorderRadius.circular(4)),
    child: const Text(
      'Pro',
      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
    ),
  );
}

class ChoiceTag extends StatelessWidget {
  const ChoiceTag({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: context.colors.onSurface, borderRadius: BorderRadius.circular(4)),
    child: Text(
      context.l10n.badgeChoice,
      style: TextStyle(color: context.colors.surface, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .3),
    ),
  );
}

/// Nhãn trạng thái đơn hàng.
class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill(this.status, {super.key});
  final OrderStatus status;
  @override
  Widget build(BuildContext context) => _Pill(
    text: status.localized(context.l10n),
    bg: status.bg(context.tokens, context.colors),
    fg: status.fg(context.tokens, context.colors),
    fontSize: 10.5,
  );
}

/// "★ 4.8 (16.690)"
class RatingText extends StatelessWidget {
  const RatingText({super.key, required this.rating, this.count, this.size = 14, this.compact = false});
  final double rating;
  final int? count;
  final double size;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size + 3, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: size),
        ),
        if (count != null) ...[
          const SizedBox(width: 4),
          Text(
            '(${compact ? Fmt.moneyShort(count!).replaceAll('Tr', 'M') : Fmt.number(count!)})',
            style: TextStyle(color: muted, fontSize: size - 1),
          ),
        ],
      ],
    );
  }
}

/// Hàng sao để chọn/hiển thị đánh giá.
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.value, this.onChanged, this.size = 28, this.labels, this.color});

  final double value;
  final ValueChanged<int>? onChanged;
  final double size;

  /// Nhãn dưới mỗi sao (VD: "Kém", "Tạm", ...).
  final List<String>? labels;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final on = color ?? Theme.of(context).colorScheme.onSurface;
    final off = Theme.of(context).colorScheme.outline;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = value >= i + 1;
        final half = !filled && value > i;
        final star = Icon(
          filled ? Icons.star_rounded : (half ? Icons.star_half_rounded : Icons.star_rounded),
          size: size,
          color: filled || half ? on : off,
        );
        final child = labels == null
            ? star
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  star,
                  const SizedBox(height: 2),
                  Text(labels![i], style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.5)),
                ],
              );
        if (onChanged == null) return child;
        return InkResponse(
          key: ValueKey('star_${i + 1}'),
          onTap: () => onChanged!(i + 1),
          radius: size * 0.7,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.12),
            child: child,
          ),
        );
      }),
    );
  }
}

/// Chấm đỏ có số (badge thông báo).
class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count, required this.child});
  final int count;
  final Widget child;
  @override
  Widget build(BuildContext context) => Badge(
    isLabelVisible: count > 0,
    backgroundColor: context.tokens.badge,
    label: Text('$count', style: const TextStyle(fontSize: 10)),
    child: child,
  );
}
