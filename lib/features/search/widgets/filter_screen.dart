import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/repositories.dart';
import '../../gig/widgets/discovery_widgets.dart';

/// Mở bộ lọc toàn màn hình; trả về bộ lọc mới (null nếu đóng).
Future<GigFilter?> openGigFilter(BuildContext context, GigFilter initial) => Navigator.of(
  context,
).push<GigFilter>(MaterialPageRoute(fullscreenDialog: true, builder: (_) => GigFilterScreen(initial: initial)));

/// Các mốc thời gian giao (số ngày tối đa; null = bất kỳ).
const deliveryOptions = <int?>[null, 1, 3, 7];

/// Nhãn của một mốc trong [deliveryOptions].
String deliveryLabel(AppLocalizations l, int? days) => switch (days) {
  null => l.searchAny,
  1 => l.searchDelivery24h,
  _ => l.searchDeliveryUpTo(days),
};

class GigFilterScreen extends StatefulWidget {
  const GigFilterScreen({super.key, required this.initial});
  final GigFilter initial;

  @override
  State<GigFilterScreen> createState() => _GigFilterScreenState();
}

class _GigFilterScreenState extends State<GigFilterScreen> {
  late GigFilter _f;
  late final TextEditingController _min;
  late final TextEditingController _max;
  late final Future<List<Category>> _categories;
  late final Future<Map<String, int>> _counts;
  late final Future<List<Object>> _catData;
  Future<int>? _resultCount;
  bool _priceInvalid = false;

  @override
  void initState() {
    super.initState();
    _f = widget.initial;
    _min = TextEditingController(text: _f.minPrice?.toString() ?? '');
    _max = TextEditingController(text: _f.maxPrice?.toString() ?? '');
    final catalog = context.read<CatalogRepository>();
    _categories = catalog.categories();
    _counts = catalog.search(GigFilter(query: _f.query)).then((list) {
      final m = <String, int>{'': list.length};
      for (final g in list) {
        m[g.categoryId] = (m[g.categoryId] ?? 0) + 1;
      }
      return m;
    });
    _catData = Future.wait<Object>([_categories, _counts]);
    _recount();
  }

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  void _recount() {
    _resultCount = context.read<CatalogRepository>().search(_f).then((l) => l.length);
  }

  void _update(GigFilter f) => setState(() {
    _f = f;
    _recount();
  });

  void _onPrice() {
    final min = int.tryParse(_min.text);
    final max = int.tryParse(_max.text);
    setState(() {
      _priceInvalid = min != null && max != null && min > max;
      _f = GigFilter(
        query: _f.query,
        categoryId: _f.categoryId,
        subcategoryId: _f.subcategoryId,
        minPrice: min,
        maxPrice: max,
        maxDeliveryDays: _f.maxDeliveryDays,
        sellerLevels: _f.sellerLevels,
        proOnly: _f.proOnly,
        sort: _f.sort,
      );
      _recount();
    });
  }

  void _clearAll() {
    _min.clear();
    _max.clear();
    _update(GigFilter(query: _f.query, sort: _f.sort));
    _priceInvalid = false;
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(
        title: l.searchFilterTitle,
        close: true,
        actions: [
          TextButton(
            key: const ValueKey('filter_clear'),
            onPressed: _clearAll,
            child: Text(l.searchClearAll, style: const TextStyle(decoration: TextDecoration.underline)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
        children: [
          _title(context, l.searchChipCategory),
          FutureBuilder<List<Object>>(
            future: _catData,
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Padding(
                  padding: Insets.pageAll,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final cats = snap.data![0] as List<Category>;
              final counts = snap.data![1] as Map<String, int>;
              Widget radio(String? id, String label) {
                final selected = _f.categoryId == id;
                return InkWell(
                  key: ValueKey('filter_cat_${id ?? 'all'}'),
                  onTap: () => _update(
                    id == null
                        ? _f.copyWith(clearCategory: true, clearSubcategory: true)
                        : _f.copyWith(categoryId: id, clearSubcategory: true),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: label,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: ' (${Fmt.number(counts[id ?? ''] ?? 0)})',
                                  style: TextStyle(color: cs.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                          color: selected ? cs.onSurface : cs.outline,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(children: [radio(null, l.searchAllCategories), for (final c in cats) radio(c.id, c.name)]);
            },
          ),
          const Divider(height: 32),
          _title(context, l.searchPriceRange),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('filter_min'),
                  controller: _min,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => _onPrice(),
                  decoration: InputDecoration(labelText: l.searchPriceMin, hintText: l.searchAny),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('–')),
              Expanded(
                child: TextField(
                  key: const ValueKey('filter_max'),
                  controller: _max,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => _onPrice(),
                  decoration: InputDecoration(labelText: l.searchPriceMax, hintText: l.searchAny),
                ),
              ),
            ],
          ),
          if (_priceInvalid)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(l.searchPriceError, style: TextStyle(color: cs.error, fontSize: 12.5)),
            ),
          const Divider(height: 32),
          _title(context, l.searchSellerLevel),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final lv in SellerLevel.values.reversed)
                FlexChip(
                  key: ValueKey('filter_level_${lv.name}'),
                  label: lv == SellerLevel.newSeller ? l.gigNewSeller : lv.localized(l),
                  selected: _f.sellerLevels.contains(lv.name),
                  showCheck: true,
                  onTap: () {
                    final s = {..._f.sellerLevels};
                    s.contains(lv.name) ? s.remove(lv.name) : s.add(lv.name);
                    _update(_f.copyWith(sellerLevels: s));
                  },
                ),
            ],
          ),
          const Divider(height: 32),
          SwitchListTile(
            key: const ValueKey('filter_pro'),
            contentPadding: EdgeInsets.zero,
            value: _f.proOnly,
            onChanged: (v) => _update(_f.copyWith(proOnly: v)),
            title: Text(l.searchProOnly, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(l.searchProOnlyDesc),
          ),
          const Divider(height: 32),
          _title(context, l.searchDeliveryTime),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final d in deliveryOptions)
                FlexChip(
                  key: ValueKey('filter_delivery_${d ?? 0}'),
                  label: deliveryLabel(l, d),
                  showCheck: true,
                  selected: _f.maxDeliveryDays == d,
                  onTap: () => _update(d == null ? _f.copyWith(clearDelivery: true) : _f.copyWith(maxDeliveryDays: d)),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: FutureBuilder<int>(
          future: _resultCount,
          builder: (context, snap) => PrimaryButton(
            key: const ValueKey('filter_apply'),
            label: snap.hasData ? l.searchShowResultsCount(snap.data!) : l.searchShowResults,
            onPressed: _priceInvalid ? null : () => Navigator.pop(context, _f),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String t) => Padding(
    padding: const EdgeInsets.only(bottom: Space.sm),
    child: Text(t, style: context.textTheme.titleMedium),
  );
}
