import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../gig/widgets/discovery_widgets.dart';
import 'widgets/filter_screen.dart';
import 'widgets/subcategory_strip.dart';

/// Kết quả tìm kiếm + bộ lọc + sắp xếp.
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key, this.query = '', this.categoryId, this.subcategoryId});
  final String query;
  final String? categoryId;
  final String? subcategoryId;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

typedef _Results = ({List<Gig> gigs, Map<String, AppUser> sellers});

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late GigFilter _filter;
  String? _style;
  late Future<_Results> _future;
  late final Future<List<Category>> _categories;
  late final Future<List<String>> _related;

  @override
  void initState() {
    super.initState();
    _filter = GigFilter(query: widget.query.trim(), categoryId: widget.categoryId, subcategoryId: widget.subcategoryId);
    final catalog = context.read<CatalogRepository>();
    _categories = catalog.categories();
    _related = widget.query.trim().isEmpty ? Future.value(const []) : catalog.relatedSearches(widget.query);
    _reload();
  }

  void _reload() {
    final catalog = context.read<CatalogRepository>();
    _future = catalog.search(_filter).then((gigs) async {
      final users = await catalog.usersByIds({for (final g in gigs) g.sellerId}.toList());
      return (gigs: gigs, sellers: {for (final u in users) u.id: u});
    });
  }

  void _apply(GigFilter f) => setState(() {
    _filter = f;
    _reload();
  });

  bool get _hasFilters =>
      _filter.activeCount > 0 || _style != null || (_filter.categoryId != null && widget.categoryId == null);

  void _clearFilters() => setState(() {
    _style = null;
    _filter = GigFilter(query: _filter.query, categoryId: widget.categoryId, sort: _filter.sort);
    _reload();
  });

  Future<void> _openFilter() async {
    final f = await openGigFilter(context, _filter);
    if (f != null) _apply(f);
  }

  Future<void> _openSort() async {
    final s = await showActionSheet<GigSort>(
      context,
      title: context.l10n.gigSortBy,
      actions: [
        for (final s in GigSort.values)
          SheetAction(
            label: s.localized(context.l10n),
            value: s,
            icon: s == _filter.sort ? Icons.check_rounded : Icons.sort_rounded,
          ),
      ],
    );
    if (s != null) _apply(_filter.copyWith(sort: s));
  }

  Future<void> _openDelivery() async {
    final d = await showActionSheet<int>(
      context,
      title: context.l10n.searchDeliveryTime,
      actions: [
        for (final o in deliveryOptions)
          SheetAction(
            label: deliveryLabel(context.l10n, o),
            value: o ?? 0,
            icon: _filter.maxDeliveryDays == o ? Icons.check_rounded : Icons.schedule_rounded,
          ),
      ],
    );
    if (d == null) return;
    _apply(d == 0 ? _filter.copyWith(clearDelivery: true) : _filter.copyWith(maxDeliveryDays: d));
  }

  Future<void> _openStyle(List<Gig> gigs) async {
    final styles = {
      for (final g in gigs)
        if (g.style.isNotEmpty) g.style,
    }.toList()..sort();
    if (styles.isEmpty) {
      showAppSnack(context, context.l10n.searchNoStyles, success: false);
      return;
    }
    final s = await showActionSheet<String>(
      context,
      title: context.l10n.searchStyle,
      actions: [
        SheetAction(
          label: context.l10n.searchAllStyles,
          value: '',
          icon: _style == null ? Icons.check_rounded : Icons.palette_outlined,
        ),
        for (final st in styles)
          SheetAction(label: st, value: st, icon: _style == st ? Icons.check_rounded : Icons.palette_outlined),
      ],
    );
    if (s != null) setState(() => _style = s.isEmpty ? null : s);
  }

  String _title(List<Category>? cats) {
    if (_filter.query.isNotEmpty) return _filter.query;
    for (final c in cats ?? const <Category>[]) {
      for (final s in c.subcategories) {
        if (s.id == _filter.subcategoryId) return s.name;
      }
      if (c.id == _filter.categoryId && _filter.subcategoryId == null) return c.name;
    }
    return context.l10n.searchAllServices;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<_Results>(
          future: _future,
          builder: (context, snap) {
            final loading = snap.connectionState != ConnectionState.done;
            final all = snap.data?.gigs ?? const <Gig>[];
            final gigs = _style == null ? all : all.where((g) => g.style == _style).toList();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _topBar(context)),
                SliverToBoxAdapter(child: _relatedRow(context)),
                SliverToBoxAdapter(child: _shopBy(context, all)),
                SliverToBoxAdapter(
                  child: SubcategoryStrip(
                    categories: _categories,
                    gigs: all,
                    categoryId: _filter.categoryId,
                    selectedId: _filter.subcategoryId,
                    onTap: (sub, cat, selected) => _apply(
                      selected
                          ? _filter.copyWith(clearSubcategory: true)
                          : _filter.copyWith(subcategoryId: sub.id, categoryId: cat.id),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _countRow(context, loading ? null : gigs.length)),
                if (snap.hasError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.error_outline_rounded,
                      title: l.commonErrorTitle,
                      message: '${snap.error}',
                      actionLabel: l.commonRetry,
                      onAction: () => setState(_reload),
                    ),
                  )
                else if (loading)
                  const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator()))
                else if (gigs.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      key: const ValueKey('results_empty'),
                      icon: Icons.search_off_rounded,
                      title: l.searchNoResults,
                      message: _hasFilters ? l.searchNoResultsFiltered : l.searchNoResultsHint,
                      actionLabel: _hasFilters ? l.searchClearFilters : l.searchBrowseCategories,
                      onAction: _hasFilters ? _clearFilters : () => context.go('/search'),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: Space.xxl),
                    sliver: SliverList.builder(
                      itemCount: gigs.length,
                      itemBuilder: (context, i) =>
                          DiscoveryGigTile(gig: gigs[i], seller: snap.data!.sellers[gigs[i].sellerId]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, Space.sm, Space.lg, Space.xs),
    child: Row(
      children: [
        const AppBackButton(),
        Gaps.h8,
        Expanded(
          child: FutureBuilder<List<Category>>(
            future: _categories,
            builder: (context, snap) => FakeSearchField(
              key: const ValueKey('results_search'),
              text: _title(snap.data),
              hasValue: true,
              onTap: () => context.pushReplacement('/search/input?q=${Uri.encodeQueryComponent(_filter.query)}'),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _relatedRow(BuildContext context) => FutureBuilder<List<String>>(
    future: _related,
    builder: (context, snap) {
      final items = snap.data ?? const <String>[];
      if (items.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(context, context.l10n.searchRelated),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: Insets.page,
              itemCount: items.length,
              separatorBuilder: (_, _) => Gaps.h8,
              itemBuilder: (context, i) => ActionChip(
                label: Text(items[i]),
                onPressed: () => context.pushReplacement('/search/results?q=${Uri.encodeQueryComponent(items[i])}'),
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget _shopBy(BuildContext context, List<Gig> all) {
    final f = _filter;
    final l = context.l10n;
    final chips = <({String label, bool active, VoidCallback onTap, Key key, IconData? icon})>[
      (
        label: f.activeCount > 0 ? l.searchChipAllCount(f.activeCount) : l.searchChipAll,
        active: f.activeCount > 0,
        onTap: _openFilter,
        key: const ValueKey('open_filter'),
        icon: Icons.tune_rounded,
      ),
      (
        label: l.searchChipCategory,
        active: f.categoryId != null,
        onTap: _openFilter,
        key: const ValueKey('chip_category'),
        icon: null,
      ),
      (
        label: _style ?? l.searchStyle,
        active: _style != null,
        onTap: () => _openStyle(all),
        key: const ValueKey('chip_style'),
        icon: null,
      ),
      (
        label: l.searchChipIncludes,
        active: f.proOnly,
        onTap: _openFilter,
        key: const ValueKey('chip_includes'),
        icon: null,
      ),
      (
        label: f.maxDeliveryDays == null ? l.searchChipDelivery : deliveryLabel(l, f.maxDeliveryDays),
        active: f.maxDeliveryDays != null,
        onTap: _openDelivery,
        key: const ValueKey('chip_delivery'),
        icon: null,
      ),
      (
        label: l.searchSellerLevel,
        active: f.sellerLevels.isNotEmpty,
        onTap: _openFilter,
        key: const ValueKey('chip_level'),
        icon: null,
      ),
      (
        label: l.searchChipBudget,
        active: f.minPrice != null || f.maxPrice != null,
        onTap: _openFilter,
        key: const ValueKey('chip_budget'),
        icon: null,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(context, l.searchShopBy),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: Insets.page,
            itemCount: chips.length,
            separatorBuilder: (_, _) => Gaps.h8,
            itemBuilder: (context, i) => Center(
              child: SelectChip(
                key: chips[i].key,
                label: chips[i].label,
                icon: chips[i].icon,
                selected: chips[i].active,
                onTap: chips[i].onTap,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _countRow(BuildContext context, int? count) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.lg, 10, Space.xs, Space.xxs),
    child: Row(
      children: [
        Expanded(
          child: Text(
            count == null ? context.l10n.searchSearching : context.l10n.searchResultCount(Fmt.number(count)),
            key: const ValueKey('results_count'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        TextButton.icon(
          key: const ValueKey('sort_btn'),
          onPressed: _openSort,
          icon: const Icon(Icons.swap_vert_rounded, size: 18),
          label: Text(_filter.sort.localized(context.l10n)),
        ),
      ],
    ),
  );

  Widget _label(BuildContext context, String t) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.sm),
    child: Text(t, style: context.textTheme.titleSmall),
  );
}
