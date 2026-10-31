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
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import '../gig/widgets/discovery_widgets.dart';

/// Màn hình nhập từ khoá: lịch sử, gợi ý, tìm người bán.
class SearchInputScreen extends StatefulWidget {
  const SearchInputScreen({super.key, this.initialQuery = ''});
  final String initialQuery;

  /// Lịch sử tìm kiếm (giữ trong phiên chạy app).
  static final List<String> history = [];

  @override
  State<SearchInputScreen> createState() => _SearchInputScreenState();
}

class _SearchInputScreenState extends State<SearchInputScreen> with SingleTickerProviderStateMixin {
  late final TextEditingController _ctrl;
  late final TabController _tabs;
  late final Future<Map<String, Gig>> _gigIndex;
  late final Future<List<AppUser>> _sellers;
  Future<List<String>>? _suggestions;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery);
    _tabs = TabController(length: 2, vsync: this)..addListener(() => setState(() {}));
    final catalog = context.read<CatalogRepository>();
    _gigIndex = loadGigIndex(catalog);
    _sellers = _gigIndex.then((m) => catalog.usersByIds({for (final g in m.values) g.sellerId}.toList()));
    if (widget.initialQuery.isNotEmpty) _suggestions = catalog.suggestions(widget.initialQuery);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _tabs.dispose();
    super.dispose();
  }

  String get _q => _ctrl.text.trim();

  void _onChanged(String v) {
    setState(() {
      _suggestions = v.trim().isEmpty ? null : context.read<CatalogRepository>().suggestions(v);
    });
  }

  void _submit([String? value]) {
    final q = (value ?? _q).trim();
    if (q.isEmpty) return;
    final h = SearchInputScreen.history;
    h
      ..remove(q)
      ..insert(0, q);
    if (h.length > 10) h.removeLast();
    context.pushReplacement('/search/results?q=${Uri.encodeQueryComponent(q)}');
  }

  void _cancel() => context.canPop() ? context.pop() : context.go('/search');

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.xs, Space.xs),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const ValueKey('search_field'),
                      controller: _ctrl,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: _onChanged,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: _tabs.index == 0 ? l.gigSearchHint : l.searchSellersHint,
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        isDense: true,
                        suffixIcon: _ctrl.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: l.commonDelete,
                                icon: const Icon(Icons.cancel_rounded, size: 18),
                                onPressed: () {
                                  _ctrl.clear();
                                  _onChanged('');
                                },
                              ),
                      ),
                    ),
                  ),
                  TextButton(key: const ValueKey('search_cancel'), onPressed: _cancel, child: Text(l.commonCancel)),
                ],
              ),
            ),
            TabBar(
              controller: _tabs,
              tabAlignment: TabAlignment.fill,
              tabs: [
                Tab(text: l.searchTabGigs),
                Tab(text: l.searchTabSellers),
              ],
            ),
            Expanded(
              child: TabBarView(controller: _tabs, children: [_gigsTab(context), _sellersTab(context)]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gigsTab(BuildContext context) {
    final l = context.l10n;
    if (_q.isNotEmpty) {
      return FutureBuilder<List<String>>(
        future: _suggestions,
        builder: (context, snap) {
          final items = snap.data ?? const <String>[];
          return ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              _label(context, l.searchSuggestions),
              ListTile(
                key: const ValueKey('search_submit_tile'),
                leading: const Icon(Icons.search_rounded),
                title: _queryTitle(l.searchForQuery(_marker), _q),
                onTap: _submit,
              ),
              if (snap.connectionState == ConnectionState.waiting && items.isEmpty)
                const LinearProgressIndicator(minHeight: 2),
              for (final s in items)
                ListTile(
                  key: ValueKey('suggest_$s'),
                  leading: const Icon(Icons.search_rounded),
                  title: _highlight(context, s, _q),
                  trailing: IconButton(
                    tooltip: l.searchFillField,
                    icon: const Icon(Icons.north_west_rounded, size: 18),
                    onPressed: () {
                      _ctrl.text = s;
                      _ctrl.selection = TextSelection.collapsed(offset: s.length);
                      _onChanged(s);
                    },
                  ),
                  onTap: () => _submit(s),
                ),
            ],
          );
        },
      );
    }
    final history = SearchInputScreen.history;
    final signedIn = context.watch<SessionController>().isSignedIn;
    final viewed = signedIn ? context.watch<SavedController>().history : const <String>[];
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        if (history.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.sm, 0),
            child: Row(
              children: [
                Expanded(child: Text(l.searchHistory, style: context.textTheme.bodySmall)),
                TextButton(
                  key: const ValueKey('clear_search_history'),
                  onPressed: () => setState(history.clear),
                  child: Text(l.searchClearHistory, style: TextStyle(color: context.tokens.danger)),
                ),
              ],
            ),
          ),
          for (final h in history)
            ListTile(
              key: ValueKey('history_$h'),
              leading: const Icon(Icons.history_rounded),
              title: Text(h),
              trailing: IconButton(
                tooltip: l.commonDelete,
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: () => setState(() => history.remove(h)),
              ),
              onTap: () => _submit(h),
            ),
        ] else
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.xl, Space.lg, Space.sm),
            child: Text(l.searchKeywordHint, style: context.textTheme.bodySmall),
          ),
        if (viewed.isNotEmpty)
          FutureBuilder<Map<String, Gig>>(
            future: _gigIndex,
            builder: (context, snap) {
              if (!snap.hasData) return const SizedBox.shrink();
              final gigs = [for (final id in viewed) ?snap.data![id]].take(4).toList();
              if (gigs.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeader(
                    title: l.searchRecentlyViewed,
                    actionLabel: l.searchManage,
                    onAction: () => context.push('/history'),
                  ),
                  for (final g in gigs)
                    InkWell(
                      onTap: () => context.push('/gig/${g.id}'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
                        child: GigThumbRow(
                          seed: g.imageSeeds.first,
                          label: g.imageLabel,
                          title: g.title,
                          subtitle: '${l.commonFrom} ${Fmt.money(g.priceFrom)}',
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _sellersTab(BuildContext context) => FutureBuilder<List<AppUser>>(
    future: _sellers,
    builder: (context, snap) {
      if (snap.hasError) {
        return EmptyState(icon: Icons.error_outline_rounded, title: context.l10n.searchSellersLoadError);
      }
      if (!snap.hasData) return const Center(child: CircularProgressIndicator());
      final q = _q.toLowerCase();
      final list = snap.data!
          .where((u) => q.isEmpty || u.displayName.toLowerCase().contains(q) || u.username.toLowerCase().contains(q))
          .toList();
      if (list.isEmpty) {
        return EmptyState(
          icon: Icons.person_search_outlined,
          title: context.l10n.searchSellerNotFound,
          message: context.l10n.searchSellerNoMatch(_q),
          compact: true,
        );
      }
      return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: list.length,
        itemBuilder: (context, i) {
          final u = list[i];
          return ListTile(
            key: ValueKey('seller_${u.id}'),
            leading: UserAvatar(user: u, size: 44, showOnline: true),
            title: Text(u.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('@${u.username} • ${u.headline}', maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: RatingText(rating: u.rating, size: 13),
            onTap: () => context.push('/user/${u.id}'),
          );
        },
      );
    },
  );

  Widget _label(BuildContext context, String t) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.lg, 14, Space.lg, Space.xs),
    child: Text(t, style: context.textTheme.bodySmall),
  );

  /// Dấu giữ chỗ cho từ khoá trong chuỗi dịch (để in đậm riêng phần từ khoá).
  static const _marker = '%%Q%%';

  /// Tiêu đề "Tìm "logo"" với từ khoá in đậm.
  Widget _queryTitle(String template, String q) {
    final i = template.indexOf(_marker);
    if (i < 0) return Text(template);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: template.substring(0, i)),
          TextSpan(
            text: q,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: template.substring(i + _marker.length)),
        ],
      ),
    );
  }

  Widget _highlight(BuildContext context, String text, String q) {
    final i = text.toLowerCase().indexOf(q.toLowerCase());
    if (i < 0) return Text(text);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text.substring(0, i)),
          TextSpan(
            text: text.substring(i, i + q.length),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: text.substring(i + q.length)),
        ],
      ),
    );
  }
}
