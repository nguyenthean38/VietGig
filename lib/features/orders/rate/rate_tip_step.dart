import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/order_widgets.dart';
import 'rate_parts.dart';

/// Mức tip có sẵn (VND).
const rateTipPresets = [25000, 50000, 100000];

/// Bước cuối: cảm ơn + gửi tip.
class RateTipStep extends StatelessWidget {
  const RateTipStep({
    super.key,
    required this.bundle,
    required this.overall,
    required this.tip,
    required this.customTip,
    required this.busy,
    required this.onPreset,
    required this.onCustom,
    required this.onSend,
    required this.onDone,
  });
  final OrderBundle bundle;
  final double overall;
  final int? tip;
  final bool customTip;
  final bool busy;
  final ValueChanged<int> onPreset;
  final VoidCallback onCustom;
  final VoidCallback onSend;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final o = bundle.order;
    final cs = context.colors;
    final name = otherName(l, bundle);
    final rating = o.review?.overall ?? overall;
    Widget cell(String label, bool sel, VoidCallback onTap, String key) => InkWell(
      key: ValueKey(key),
      onTap: onTap,
      borderRadius: Radii.mdAll,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: Radii.mdAll,
          border: Border.all(color: sel ? cs.onSurface : cs.outline, width: sel ? 2 : 1),
        ),
        child: Text(label, style: TextStyle(fontWeight: sel ? FontWeight.w700 : FontWeight.w500, fontSize: 15)),
      ),
    );
    Widget preset(int i) {
      final v = rateTipPresets[i];
      return Expanded(child: cell(Fmt.money(v), !customTip && tip == v, () => onPreset(v), 'tip_$v'));
    }

    return RatePage(
      items: [
        Gaps.v16,
        RateAvatar(bundle),
        Gaps.v12,
        if (rating > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StarRating(value: rating, size: 24),
              Gaps.h6,
              Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        RateTitle(o.review != null ? l.ordersRateThanksReview : l.ordersRateThanks),
        if (o.tip > 0)
          Text(l.ordersRateTipped(Fmt.money(o.tip), name), textAlign: TextAlign.center)
        else ...[
          Text(
            l.ordersRateTipPrompt(name),
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          Gaps.v20,
          Row(children: [preset(0), Gaps.h10, preset(1)]),
          Gaps.v10,
          Row(
            children: [
              preset(2),
              Gaps.h10,
              Expanded(
                child: cell(
                  customTip && tip != null ? Fmt.money(tip!) : l.ordersRateCustom,
                  customTip,
                  onCustom,
                  'tip_custom',
                ),
              ),
            ],
          ),
        ],
      ],
      bottom: o.tip > 0
          ? PrimaryButton(key: const ValueKey('rate_done'), label: l.commonDone, onPressed: onDone)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  key: const ValueKey('tip_send'),
                  label: tip == null ? l.ordersRateSendTip : l.ordersRateSendTipAmount(Fmt.money(tip!)),
                  loading: busy,
                  onPressed: tip == null ? null : onSend,
                ),
                Gaps.v8,
                Text(l.ordersRateNoFee, textAlign: TextAlign.center, style: context.textTheme.bodySmall),
              ],
            ),
    );
  }
}
