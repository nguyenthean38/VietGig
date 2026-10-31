import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';

/// Giá trị một tính năng của gói: "✓" → dấu tích xanh, rỗng → gạch ngang, còn lại là chữ.
Widget _featureValue(BuildContext context, String v, {TextStyle? style}) {
  if (v == '✓') return Icon(Icons.check_rounded, size: 20, color: context.tokens.brand);
  if (v.isEmpty) return Icon(Icons.remove_rounded, size: 20, color: context.colors.outline);
  return Text(v, textAlign: TextAlign.center, style: style);
}

/// Khối chọn gói (tab Cơ bản/Tiêu chuẩn/Cao cấp), chi tiết gói, nút "Tiếp tục" và "So sánh gói".
class GigPackagesSection extends StatelessWidget {
  const GigPackagesSection({super.key, required this.gig, required this.selected, required this.onSelect});
  final Gig gig;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final p = gig.packages[selected.clamp(0, gig.packages.length - 1)];
    const bold = TextStyle(fontWeight: FontWeight.w600);
    Widget line(String k, String v, {bool feature = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(k, style: TextStyle(color: cs.onSurfaceVariant)),
          ),
          if (feature) _featureValue(context, v, style: bold) else Text(v, style: bold),
        ],
      ),
    );

    return Padding(
      padding: Insets.page,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: cs.outlineVariant)),
            ),
            child: Row(children: [for (var i = 0; i < gig.packages.length; i++) Expanded(child: _tab(context, i))]),
          ),
          Gaps.v16,
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Column(
              key: ValueKey('pkg_body_$selected'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(p.title, style: context.textTheme.titleMedium),
                Gaps.v6,
                Text(p.description, style: TextStyle(color: cs.onSurfaceVariant, height: 1.45)),
                Gaps.v10,
                line(l.gigDeliveryTime, Fmt.days(p.deliveryDays)),
                line(l.gigRevisions, p.revisionsLocalized(l)),
                for (final f in p.features.entries) line(f.key, f.value, feature: true),
              ],
            ),
          ),
          Gaps.v16,
          PrimaryButton(
            key: const ValueKey('gig_continue'),
            label: l.gigContinueWithPrice(Fmt.money(p.price)),
            onPressed: () => context.push('/checkout/${gig.id}?pkg=$selected'),
          ),
          Gaps.v4,
          TextButton(
            key: const ValueKey('compare_pkgs'),
            onPressed: () => showComparePackagesSheet(context, gig: gig, onSelect: onSelect),
            child: Text(l.gigComparePackages, style: const TextStyle(decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, int i) {
    final cs = context.colors;
    final active = i == selected;
    return InkWell(
      key: ValueKey('pkg_tab_$i'),
      onTap: () => onSelect(i),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Space.md, horizontal: Space.xs),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: active ? cs.onSurface : Colors.transparent, width: 2.5)),
        ),
        child: Column(
          children: [
            Text(
              gig.packages[i].tier,
              style: TextStyle(fontSize: 12, color: active ? cs.onSurface : cs.onSurfaceVariant),
            ),
            Gaps.v2,
            FittedBox(
              child: Text(
                Fmt.money(gig.packages[i].price),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                  color: active ? cs.onSurface : cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet "So sánh gói": bảng các gói theo giá, thời gian, số lần sửa, tính năng.
void showComparePackagesSheet(BuildContext context, {required Gig gig, required ValueChanged<int> onSelect}) {
  final featureKeys = <String>{for (final p in gig.packages) ...p.features.keys}.toList();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      final cs = ctx.colors;
      final l = ctx.l10n;
      Widget cell(Widget child, {bool head = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: Space.xs),
        child: head
            ? DefaultTextStyle.merge(
                style: const TextStyle(fontWeight: FontWeight.w700),
                child: child,
              )
            : child,
      );
      Widget val(String v) => Center(child: _featureValue(ctx, v, style: const TextStyle(fontSize: 13)));
      TableRow row(String label, List<Widget> values, {bool head = false}) => TableRow(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.outlineVariant)),
        ),
        children: [
          cell(
            Text(label, style: TextStyle(fontSize: 13, color: head ? cs.onSurface : cs.onSurfaceVariant)),
            head: head,
          ),
          for (final v in values) cell(v, head: head),
        ],
      );
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (ctx, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xxl),
          children: [
            Row(
              children: [
                Expanded(child: Text(l.gigComparePackages, style: ctx.textTheme.titleLarge)),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: l.commonClose,
                ),
              ],
            ),
            Table(
              key: const ValueKey('compare_table'),
              columnWidths: const {0: FlexColumnWidth(1.3)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                row(l.gigPackage, [
                  for (final p in gig.packages) Center(child: Text(p.tier, textAlign: TextAlign.center)),
                ], head: true),
                row(l.gigReviewPrice, [
                  for (final p in gig.packages)
                    Center(
                      child: FittedBox(
                        child: Text(Fmt.money(p.price), style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                ]),
                row(l.gigDeliveryTime, [for (final p in gig.packages) val(Fmt.days(p.deliveryDays))]),
                row(l.gigRevisions, [for (final p in gig.packages) val(p.revisionsLocalized(l))]),
                for (final k in featureKeys) row(k, [for (final p in gig.packages) val(p.features[k] ?? '')]),
              ],
            ),
            Gaps.v16,
            Row(
              children: [
                for (var i = 0; i < gig.packages.length; i++) ...[
                  if (i > 0) Gaps.h8,
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 42), padding: EdgeInsets.zero),
                      onPressed: () {
                        Navigator.pop(ctx);
                        onSelect(i);
                      },
                      child: Text(l.gigSelectPackage(gig.packages[i].tier), style: const TextStyle(fontSize: 12.5)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    },
  );
}
