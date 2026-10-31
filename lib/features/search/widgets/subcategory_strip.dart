import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/format.dart';
import '../../../data/models/catalog.dart';

/// Dải thẻ danh mục con cuộn ngang trên trang kết quả tìm kiếm.
///
/// Nếu [categoryId] khác null: hiện mọi danh mục con của danh mục đó; ngược lại chỉ hiện
/// các danh mục con có trong [gigs]. Bấm thẻ gọi [onTap] (thẻ đang chọn = [selectedId]).
class SubcategoryStrip extends StatelessWidget {
  const SubcategoryStrip({
    super.key,
    required this.categories,
    required this.gigs,
    required this.onTap,
    this.categoryId,
    this.selectedId,
  });

  final Future<List<Category>> categories;
  final List<Gig> gigs;
  final String? categoryId;
  final String? selectedId;
  final void Function(Subcategory sub, Category cat, bool selected) onTap;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Category>>(
    future: categories,
    builder: (context, snap) {
      if (!snap.hasData) return const SizedBox.shrink();
      final cats = snap.data!;
      final subs = <({Subcategory sub, Category cat})>[];
      if (categoryId != null) {
        final c = cats.where((c) => c.id == categoryId);
        if (c.isNotEmpty) subs.addAll(c.first.subcategories.map((s) => (sub: s, cat: c.first)));
      } else {
        final present = {for (final g in gigs) g.subcategoryId};
        for (final c in cats) {
          for (final s in c.subcategories) {
            if (present.contains(s.id)) subs.add((sub: s, cat: c));
          }
        }
      }
      if (subs.isEmpty) return const SizedBox.shrink();
      final cs = context.colors;
      return SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(Space.lg, 14, Space.lg, Space.xs),
          itemCount: subs.length,
          separatorBuilder: (_, _) => Gaps.h10,
          itemBuilder: (context, i) {
            final e = subs[i];
            final selected = selectedId == e.sub.id;
            return InkWell(
              key: ValueKey('sub_${e.sub.id}'),
              borderRadius: Radii.mdAll,
              onTap: () => onTap(e.sub, e.cat, selected),
              child: Container(
                width: 118,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: Radii.mdAll,
                  border: Border.all(color: selected ? cs.onSurface : cs.outlineVariant, width: selected ? 1.6 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(AppIcons.of(e.sub.icon), size: 22),
                    Gaps.v4,
                    Text(
                      e.sub.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.2),
                    ),
                    Gaps.v2,
                    Text(
                      context.l10n.searchServiceCount(Fmt.number(e.sub.gigCount)),
                      maxLines: 1,
                      style: context.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
