import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/app_icons.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import '../gig/widgets/discovery_widgets.dart';

/// Tab "Tìm kiếm": ô tìm kiếm + Danh mục / Sở thích.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Category>> _categories;
  Future<List<Object>>? _interests;

  @override
  void initState() {
    super.initState();
    _categories = context.read<CatalogRepository>().categories();
    _loadInterests();
    InterestsSync.version.addListener(_onSync);
  }

  @override
  void dispose() {
    InterestsSync.version.removeListener(_onSync);
    super.dispose();
  }

  void _onSync() {
    if (mounted) setState(_loadInterests);
  }

  void _loadInterests() {
    final s = context.read<SessionController>();
    _interests = s.isSignedIn
        ? Future.wait<Object>([_categories, context.read<AccountRepository>().interests(s.userId)])
        : null;
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.xs),
              child: FakeSearchField(key: const ValueKey('explore_search'), onTap: () => context.push('/search/input')),
            ),
            TabBar(
              tabAlignment: TabAlignment.fill,
              tabs: [
                Tab(text: context.l10n.searchTabCategories),
                Tab(text: context.l10n.searchTabInterests),
              ],
            ),
            Expanded(child: TabBarView(children: [_categoriesTab(context), _interestsTab(context)])),
          ],
        ),
      ),
    ),
  );

  Widget _categoriesTab(BuildContext context) => AsyncView<List<Category>>(
    future: _categories,
    builder: (context, cats) => ListView.builder(
      padding: Insets.tabBottom,
      itemCount: cats.length,
      itemBuilder: (context, i) {
        final c = cats[i];
        return MenuTile(
          key: ValueKey('cat_${c.id}'),
          icon: AppIcons.of(c.icon),
          title: c.name,
          subtitle: c.subtitle,
          onTap: () => context.push('/category/${c.id}'),
        );
      },
    ),
  );

  Widget _interestsTab(BuildContext context) {
    final l = context.l10n;
    if (_interests == null) {
      return EmptyState(
        icon: Icons.favorite_border_rounded,
        title: l.searchInterestsGuestTitle,
        message: l.searchInterestsGuestMessage,
        actionLabel: l.commonSignIn,
        onAction: () => context.push('/auth/signin'),
      );
    }
    return FutureBuilder<List<Object>>(
      future: _interests,
      builder: (context, snap) {
        if (snap.hasError) {
          return EmptyState(
            icon: Icons.error_outline_rounded,
            title: l.searchInterestsLoadError,
            actionLabel: l.commonRetry,
            onAction: () => setState(_loadInterests),
          );
        }
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final cats = snap.data![0] as List<Category>;
        final mine = snap.data![1] as Set<String>;
        final all = [
          for (final c in cats)
            for (final s in c.subcategories) (sub: s, cat: c),
        ];
        final selected = all.where((e) => mine.contains(e.sub.id)).toList();
        final others = all.where((e) => !mine.contains(e.sub.id)).take(10).toList();

        Widget tile(({Subcategory sub, Category cat}) e, {Widget? trailing}) => ListTile(
          key: ValueKey('explore_interest_${e.sub.id}'),
          contentPadding: Insets.page,
          leading: Icon(AppIcons.of(e.sub.icon), size: 26),
          title: Text(e.sub.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(e.cat.name),
          trailing: trailing,
          onTap: () => context.push('/search/results?sub=${e.sub.id}&category=${e.cat.id}'),
        );

        return ListView(
          padding: Insets.tabBottom,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.xl, Space.sm, Space.xs),
              child: Row(
                children: [
                  Expanded(child: Text(l.searchYourInterests, style: context.textTheme.titleLarge)),
                  if (selected.isNotEmpty)
                    TextButton(
                      onPressed: () => context.push('/interests'),
                      child: Text(l.searchEdit, style: const TextStyle(decoration: TextDecoration.underline)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: Insets.page,
              child: Text(l.searchInterestsHint, style: context.textTheme.bodySmall),
            ),
            if (selected.isEmpty)
              Padding(
                padding: Insets.pageAll,
                child: PrimaryButton(
                  key: const ValueKey('choose_interests'),
                  label: l.searchChooseInterests,
                  onPressed: () => context.push('/interests'),
                ),
              )
            else
              for (final e in selected) tile(e),
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.xxl, Space.lg, Space.xs),
              child: Text(l.searchYouMayLike, style: context.textTheme.titleLarge),
            ),
            for (final e in others)
              tile(
                e,
                trailing: IconButton(
                  tooltip: l.searchAddInterest,
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  onPressed: () async {
                    final s = context.read<SessionController>();
                    await context.read<AccountRepository>().saveInterests(s.userId, {...mine, e.sub.id});
                    InterestsSync.bump();
                    if (context.mounted) showAppSnack(context, context.l10n.searchInterestAdded(e.sub.name));
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
