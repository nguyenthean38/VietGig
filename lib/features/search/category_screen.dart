import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/app_icons.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../gig/widgets/discovery_widgets.dart';

/// Trang danh mục: mô tả, lưới danh mục con, dịch vụ nổi bật.
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

typedef _Data = ({Category? category, List<Gig> gigs, Map<String, AppUser> sellers});

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<_Data> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_Data> _load() async {
    final catalog = context.read<CatalogRepository>();
    final cats = await catalog.categories();
    final c = cats.where((c) => c.id == widget.categoryId).firstOrNull;
    if (c == null) return (category: null, gigs: const <Gig>[], sellers: const <String, AppUser>{});
    final gigs = await catalog.search(GigFilter(categoryId: c.id, sort: GigSort.rating));
    final users = await catalog.usersByIds({for (final g in gigs) g.sellerId}.toList());
    return (category: c, gigs: gigs, sellers: {for (final u in users) u.id: u});
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(
        title: '',
        actions: [
          IconButton(
            tooltip: l.navSearch,
            onPressed: () => context.push('/search/input'),
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: AsyncView<_Data>(
        future: _future,
        builder: (context, d) {
          final c = d.category;
          if (c == null) {
            return EmptyState(
              icon: Icons.category_outlined,
              title: l.searchCategoryNotFound,
              actionLabel: l.commonBack,
              onAction: () => context.pop(),
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: Space.xxxl),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs),
                child: Text(c.name, textAlign: TextAlign.center, style: context.textTheme.headlineSmall),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.xxxl),
                child: Text(
                  l.searchCategoryIntro(c.subtitle.toLowerCase()),
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
                ),
              ),
              Gaps.v16,
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: Insets.page,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: Space.md,
                  crossAxisSpacing: Space.md,
                  mainAxisExtent: 128,
                ),
                itemCount: c.subcategories.length,
                itemBuilder: (context, i) {
                  final s = c.subcategories[i];
                  return AppCard(
                    key: ValueKey('catsub_${s.id}'),
                    padding: Insets.cardSm,
                    onTap: () => context.push('/search/results?sub=${s.id}&category=${c.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(AppIcons.of(s.icon), size: 30),
                        const Spacer(),
                        Text(
                          s.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, height: 1.25),
                        ),
                        Gaps.v2,
                        Text(l.searchServiceCount(Fmt.number(s.gigCount)), style: context.textTheme.bodySmall),
                      ],
                    ),
                  );
                },
              ),
              SectionHeader(
                title: l.searchFeatured,
                onAction: d.gigs.isEmpty ? null : () => context.push('/search/results?category=${c.id}'),
              ),
              if (d.gigs.isEmpty)
                EmptyState(
                  icon: Icons.storefront_outlined,
                  title: l.searchNoGigsTitle,
                  message: l.searchNoGigsMessage,
                  compact: true,
                )
              else
                for (final g in d.gigs.take(6)) DiscoveryGigTile(gig: g, seller: d.sellers[g.sellerId]),
            ],
          );
        },
      ),
    );
  }
}
