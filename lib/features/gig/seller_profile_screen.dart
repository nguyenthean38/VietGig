import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import 'widgets/discovery_widgets.dart';
import 'widgets/seller_about_tab.dart';
import 'widgets/seller_profile_parts.dart';

/// Hồ sơ người bán (5 tab).
class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key, required this.userId, this.initialTab = 0});
  final String userId;
  final int initialTab;

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

typedef _ProfileData = ({AppUser? user, List<Gig> gigs, List<Review> reviews});

class _SellerProfileScreenState extends State<SellerProfileScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late Future<_ProfileData> _future;
  ReviewSort _sort = ReviewSort.relevant;

  /// Khoá ổn định của 5 tab (dùng cho ValueKey `profile_tab_<id>`).
  static const _tabIds = ['about', 'gigs', 'reviews', 'portfolio', 'clients'];

  List<String> _tabLabels(AppLocalizations l) => [
    l.gigTabAbout,
    l.gigTabGigs,
    l.gigTabReviews,
    l.gigPortfolio,
    l.gigTabClients,
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this, initialIndex: widget.initialTab.clamp(0, 4));
    _future = _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<_ProfileData> _load() async {
    final c = context.read<CatalogRepository>();
    final r = await Future.wait<Object?>([
      c.userById(widget.userId),
      c.gigsBySeller(widget.userId),
      c.reviewsForSeller(widget.userId),
    ]);
    return (user: r[0] as AppUser?, gigs: r[1] as List<Gig>, reviews: r[2] as List<Review>);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AsyncView<_ProfileData>(
      future: _future,
      builder: (context, d) {
        final u = d.user;
        if (u == null) {
          return SafeArea(
            child: Column(
              children: [
                const Align(alignment: Alignment.centerLeft, child: AppBackButton()),
                Expanded(
                  child: EmptyState(
                    icon: Icons.person_off_outlined,
                    title: context.l10n.gigUserNotFoundTitle,
                    message: context.l10n.gigUserNotFoundMessage,
                  ),
                ),
              ],
            ),
          );
        }
        return SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverToBoxAdapter(child: _header(context, u)),
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: PinnedTabBarDelegate(
                    TabBar(
                      controller: _tabs,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: [
                        for (final (i, t) in _tabLabels(context.l10n).indexed)
                          Tab(key: ValueKey('profile_tab_${_tabIds[i]}'), text: t),
                      ],
                    ),
                    Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabs,
              children: [
                _tab([SellerAboutTab(user: u)]),
                _tab(_gigsTab(context, u, d.gigs)),
                _tab(_reviewsTab(context, u, d.reviews)),
                _tab(_portfolioTab(context, u)),
                _tab(_clientsTab(context, u)),
              ],
            ),
          ),
        );
      },
    ),
  );

  Widget _tab(List<Widget> slivers) => Builder(
    builder: (context) => CustomScrollView(
      slivers: [
        SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
        ...slivers,
        const SliverToBoxAdapter(child: Gaps.v32),
      ],
    ),
  );

  Widget _header(BuildContext context, AppUser u) {
    final saved = context.select<SavedController, bool>((c) => c.isSellerSaved(u.id));
    return Column(
      children: [
        Row(
          children: [
            const AppBackButton(),
            const Spacer(),
            IconButton(
              tooltip: context.l10n.gigShare,
              onPressed: () => copyLink(context, '/user/${u.id}'),
              icon: const Icon(Icons.ios_share_rounded),
            ),
            Gaps.h8,
          ],
        ),
        UserAvatar(user: u, size: 96, showOnline: true),
        Gaps.v10,
        Text(u.displayName, style: context.textTheme.titleLarge),
        Text('@${u.username}', style: context.textTheme.bodySmall),
        Gaps.v8,
        SellerBadges(user: u, alignment: WrapAlignment.center),
        Gaps.v6,
        RatingText(rating: u.rating, count: u.reviewCount),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, 14, Space.lg, Space.sm),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('save_seller'),
                  onPressed: () => showSaveToListSheet(context, sellerId: u.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: saved ? context.tokens.danger : null,
                    side: saved ? BorderSide(color: context.tokens.danger) : null,
                  ),
                  icon: Icon(saved ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 20),
                  label: Text(saved ? context.l10n.commonSaved : context.l10n.commonSave),
                ),
              ),
              Gaps.h12,
              Expanded(
                child: FilledButton.icon(
                  key: const ValueKey('contact_seller'),
                  onPressed: () => context.push('/contact/${u.id}'),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 19),
                  label: Text(context.l10n.gigContact),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------ Dịch vụ
  List<Widget> _gigsTab(BuildContext context, AppUser u, List<Gig> gigs) {
    if (gigs.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Icons.storefront_outlined,
            title: context.l10n.gigNoGigsTitle,
            message: context.l10n.gigNoGigsMessage(u.displayName),
            compact: true,
          ),
        ),
      ];
    }
    return [
      const SliverToBoxAdapter(child: Gaps.v8),
      SliverList.builder(
        itemCount: gigs.length,
        itemBuilder: (_, i) => DiscoveryGigTile(gig: gigs[i], seller: u),
      ),
    ];
  }

  // ----------------------------------------------------------------- Đánh giá
  List<Widget> _reviewsTab(BuildContext context, AppUser u, List<Review> reviews) {
    final sorted = sortReviews(reviews, _sort);
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
        sliver: SliverList.list(
          children: [
            RatingSummary(rating: u.rating, count: u.reviewCount),
            Gaps.v8,
            Row(
              children: [
                Expanded(child: Text(context.l10n.gigSortBy, style: context.textTheme.bodySmall)),
                Flexible(
                  child: TextButton(
                    key: const ValueKey('profile_review_sort'),
                    onPressed: () async {
                      final s = await showReviewSortSheet(context, _sort);
                      if (s != null) setState(() => _sort = s);
                    },
                    child: Text(
                      _sort.localized(context.l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
            if (sorted.isEmpty)
              EmptyState(
                icon: Icons.rate_review_outlined,
                title: context.l10n.gigNoReviewsTitle,
                message: context.l10n.gigNoReviewsMessage,
                compact: true,
              ),
            for (final r in sorted) ...[const Divider(), ReviewTile(review: r, sellerName: u.displayName)],
            if (sorted.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: Space.sm),
                child: OutlinedButton(
                  onPressed: () => context.push('/user/${u.id}/reviews'),
                  child: Text(context.l10n.gigSeeAllReviewsPlain),
                ),
              ),
          ],
        ),
      ),
    ];
  }

  // ---------------------------------------------------------------- Portfolio
  List<Widget> _portfolioTab(BuildContext context, AppUser u) {
    if (u.portfolio.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(icon: Icons.collections_outlined, title: context.l10n.gigNoPortfolio, compact: true),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.sm),
        sliver: SliverToBoxAdapter(
          child: Text(context.l10n.gigPortfolioIntro(u.displayName), style: context.textTheme.bodySmall),
        ),
      ),
      SliverPadding(
        padding: Insets.page,
        sliver: SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: Space.lg,
            crossAxisSpacing: Space.md,
            childAspectRatio: 0.78,
          ),
          itemCount: u.portfolio.length,
          itemBuilder: (context, i) => PortfolioThumb(
            item: u.portfolio[i],
            onTap: () => context.push('/portfolio/${u.id}/${u.portfolio[i].id}'),
          ),
        ),
      ),
    ];
  }

  // --------------------------------------------------------------- Khách hàng
  List<Widget> _clientsTab(BuildContext context, AppUser u) {
    if (u.clients.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(icon: Icons.business_outlined, title: context.l10n.gigNoClients, compact: true),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: Insets.pageAll,
        sliver: SliverList.separated(
          itemCount: u.clients.length,
          separatorBuilder: (_, _) => Gaps.v12,
          itemBuilder: (context, i) => ClientWorkCard(work: u.clients[i]),
        ),
      ),
    ];
  }
}
