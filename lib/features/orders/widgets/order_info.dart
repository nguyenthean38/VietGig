import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/order.dart';
import 'checkout_parts.dart';

/// Dòng "nhãn ....... giá trị".
class SummaryRow extends StatelessWidget {
  const SummaryRow(this.label, this.value, {super.key, this.bold = false, this.valueColor, this.trailing});
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: bold ? 16 : 14.5, fontWeight: bold ? FontWeight.w700 : FontWeight.w400);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: style.copyWith(color: bold ? null : context.colors.onSurfaceVariant)),
          ),
          Gaps.h12,
          trailing ??
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: style.copyWith(color: valueColor),
                ),
              ),
        ],
      ),
    );
  }
}

/// Dòng tính năng có dấu ✓.
class FeatureLine extends StatelessWidget {
  const FeatureLine(this.text, {super.key, this.trailing});
  final String text;
  final String? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: Space.xxs),
          child: Icon(Icons.check_rounded, size: 16, color: context.tokens.brand),
        ),
        Gaps.h8,
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        if (trailing != null) Text(trailing!, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );
}

/// Khối có tiêu đề thu gọn / mở rộng.
class CollapsibleSection extends StatefulWidget {
  const CollapsibleSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = true,
    this.icon,
    this.trailing,
  });
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final IconData? icon;
  final Widget? trailing;

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection> {
  late bool _open = widget.initiallyExpanded;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      InkWell(
        onTap: () => setState(() => _open = !_open),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.md),
          child: Row(
            children: [
              if (widget.icon != null) ...[Icon(widget.icon, size: 20), Gaps.h10],
              Expanded(
                child: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              ?widget.trailing,
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ],
          ),
        ),
      ),
      AnimatedCrossFade(
        firstChild: widget.child,
        secondChild: const SizedBox(width: double.infinity),
        crossFadeState: _open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 200),
      ),
    ],
  );
}

/// Thẻ đơn hàng gọn: ảnh, tiêu đề, trạng thái, giá.
class OrderHeaderCard extends StatelessWidget {
  const OrderHeaderCard({super.key, required this.order, this.onTap});
  final Order order;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => AppCard(
    onTap: onTap,
    padding: Insets.cardSm,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceholderImage(seed: order.gigImageSeed, width: 72, height: 54, radius: 8),
        Gaps.h12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.gigTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, height: 1.3),
              ),
              Gaps.v8,
              Wrap(
                spacing: Space.sm,
                runSpacing: 6,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OrderStatusPill(order.status),
                  Text(Fmt.money(order.total), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Tiêu đề mục nhỏ đậm.
class BlockTitle extends StatelessWidget {
  const BlockTitle(this.text, {super.key, this.padding = const EdgeInsets.only(top: Space.xl, bottom: 10)});
  final String text;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Text(text, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700)),
  );
}

/// Khối thông tin chi tiết đơn (dùng ở chi tiết đơn & trung tâm giải quyết).
class OrderInfoTable extends StatelessWidget {
  const OrderInfoTable({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.ordersInfoDateCode(Fmt.date(order.createdAt), order.code), style: context.textTheme.bodySmall),
        Gaps.v10,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '${order.packageTier} · ${order.packageTitle}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
              ),
            ),
          ],
        ),
        Gaps.v6,
        for (final f in order.packageFeatures) FeatureLine(f),
        for (final e in order.extras) FeatureLine(l.ordersInfoExtra(e)),
        const Divider(height: Space.xxl),
        SummaryRow(l.ordersInfoSubtotal, Fmt.money(order.subtotal)),
        SummaryRow(l.ordersInfoServiceFee, Fmt.money(order.serviceFee)),
        if (order.tip > 0) SummaryRow(l.ordersInfoTip, Fmt.money(order.tip)),
        SummaryRow(l.ordersInfoTotal, Fmt.money(order.total + order.tip), bold: true),
        SummaryRow(l.ordersInfoDueDate, Fmt.date(order.dueDate)),
        SummaryRow(
          l.ordersInfoPaidWith,
          PaymentMethod.fromStored(order.paymentMethod)?.localized(l) ?? order.paymentMethod,
        ),
      ],
    );
  }
}
