import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/order.dart';

/// Dải gợi ý thêm dịch vụ (extras) cho đơn đang thực hiện.
class OrderExtrasStrip extends StatelessWidget {
  const OrderExtrasStrip({
    super.key,
    required this.order,
    required this.extras,
    required this.busy,
    required this.onAdd,
    required this.onClose,
  });
  final Order order;
  final List<GigExtra> extras;
  final bool busy;
  final ValueChanged<GigExtra> onAdd;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cs = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: Space.lg, right: Space.xs),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l.ordersDetailExtrasTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5),
                  ),
                ),
                IconButton(
                  key: const ValueKey('extras_close'),
                  tooltip: l.ordersDetailHide,
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 128,
            child: ListView.separated(
              padding: Insets.page,
              scrollDirection: Axis.horizontal,
              itemCount: extras.length,
              separatorBuilder: (_, _) => Gaps.h10,
              itemBuilder: (_, i) {
                final e = extras[i];
                final added = order.extras.contains(e.title);
                return Container(
                  width: 200,
                  padding: Insets.cardSm,
                  decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: Radii.mdAll),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                      const Spacer(),
                      Text(
                        Fmt.money(e.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Gaps.v6,
                      Row(
                        children: [
                          SizedBox(
                            height: 34,
                            child: FilledButton(
                              key: ValueKey('add_extra_${e.id}'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: Space.md),
                                minimumSize: const Size(0, 34),
                              ),
                              onPressed: busy ? null : () => onAdd(e),
                              child: Text(
                                added ? l.ordersDetailAddMore : l.ordersDetailAdd,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
