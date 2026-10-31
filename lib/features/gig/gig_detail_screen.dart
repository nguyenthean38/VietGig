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
import '../../state/session_controller.dart';
import 'widgets/discovery_widgets.dart';
import 'widgets/gig_packages.dart';
import 'widgets/gig_seller_sections.dart';

/// Chi tiết dịch vụ (gig).
class GigDetailScreen extends StatefulWidget {
  const GigDetailScreen({super.key, required this.gigId});
  final String gigId;

  @override
  State<GigDetailScreen> createState() => _GigDetailScreenState();
}

typedef _GigData = ({Gig? gig, AppUser? seller, List<Review> reviews, List<Gig> otherGigs, Map<String, Gig> index});

class _GigDetailScreenState extends State<GigDetailScreen> {
  late Future<_GigData> _future;
  int _pkg = 0;
  int _page = 0;
  bool _descExpanded = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_GigData> _load() async {
    final catalog = context.read<CatalogRepository>();
    final session = context.read<SessionController>();
    final saved = context.read<SavedController>();
    final gig = await catalog.gigById(widget.gigId);
    if (gig == null) {
      return (
        gig: null,
        seller: null,
        reviews: const <Review>[],
        otherGigs: const <Gig>[],
        index: const <String, Gig>{},
      );
    }
    if (session.isSignedIn) saved.visit(gig.id);
    final results = await Future.wait<Object?>([
      catalog.userById(gig.sellerId),
      catalog.reviewsForSeller(gig.sellerId),
      catalog.gigsBySeller(gig.sellerId),
      loadGigIndex(catalog),
    ]);
    final reviews = [...results[1] as List<Review>]
      ..sort((a, b) => (b.gigId == gig.id ? 1 : 0).compareTo(a.gigId == gig.id ? 1 : 0));
    return (
      gig: gig,
      seller: results[0] as AppUser?,
      reviews: reviews,
      otherGigs: (results[2] as List<Gig>).where((g) => g.id != gig.id).toList(),
      index: results[3] as Map<String, Gig>,
    );
  }

  Future<void> _more(Gig gig) async {
    final l = context.l10n;
    final a = await showActionSheet<String>(
      context,
      actions: [
        SheetAction(label: l.gigShare, value: 'share', icon: Icons.ios_share_rounded),
        SheetAction(label: l.gigReport, value: 'report', icon: Icons.flag_outlined, destructive: true),
      ],
    );
    if (!mounted || a == null) return;
    if (a == 'share') {
      await copyLink(context, '/gig/${gig.id}');
    } else {
      final reason = await showActionSheet<String>(
        context,
        title: l.gigReportTitle,
        actions: [
          SheetAction(label: l.gigReportCopyright, value: 'copyright'),
          SheetAction(label: l.gigReportContent, value: 'content'),
          SheetAction(label: l.gigReportSpam, value: 'spam'),
          SheetAction(label: l.gigReportOther, value: 'other'),
        ],
      );
      if (reason != null && mounted) {
        showAppSnack(context, l.gigReportThanks);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AsyncView<_GigData>(
      future: _future,
      builder: (context, d) {
        final gig = d.gig;
        if (gig == null) {
          return SafeArea(
            child: Column(
              children: [
                const Align(alignment: Alignment.centerLeft, child: AppBackButton()),
                Expanded(
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    title: context.l10n.gigNotFoundTitle,
                    message: context.l10n.gigNotFoundMessage,
                    actionLabel: context.l10n.gigNotFoundAction,
                    onAction: () => context.go('/search'),
                  ),
                ),
              ],
            ),
          );
        }
        return Stack(
          children: [
            _content(context, d, gig),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Space.sm, Space.sm, Space.lg, 0),
                  child: Row(
                    children: [
                      const AppBackButton(),
                      const Spacer(),
                      SaveGigButton(gigId: gig.id, circle: true),
                      Gaps.h8,
                      CircleIconButton(
                        key: const ValueKey('gig_more'),
                        icon: Icons.more_horiz_rounded,
                        tooltip: context.l10n.gigMore,
                        onPressed: () => _more(gig),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (d.seller != null)
              Positioned(
                right: Space.lg,
                bottom: Space.lg + MediaQuery.paddingOf(context).bottom,
                child: FloatingChatButton(
                  key: const ValueKey('gig_chat'),
                  seed: d.seller!.avatarSeed,
                  name: d.seller!.displayName,
                  onPressed: () => context.push('/contact/${gig.sellerId}?gig=${gig.id}'),
                ),
              ),
          ],
        );
      },
    ),
  );

  Widget _content(BuildContext context, _GigData d, Gig gig) {
    final seller = d.seller;
    final cs = context.colors;
    final history = context.watch<SavedController>().history.where((id) => id != gig.id);
    final recent = [for (final id in history) ?d.index[id]].take(8).toList();
    return ListView(
      key: const ValueKey('gig_scroll'),
      padding: EdgeInsets.only(bottom: 100 + MediaQuery.paddingOf(context).bottom),
      children: [
        _gallery(context, gig),
        if (seller != null) _sellerRow(context, seller),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, 0),
          child: Text(gig.title, style: context.textTheme.headlineSmall),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, 10, Space.lg, 0),
          child: Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              RatingText(rating: gig.rating, count: gig.reviewCount),
              if (gig.isChoice) const ChoiceTag(),
              if (gig.isPro) const ProTag(),
            ],
          ),
        ),
        _description(context, gig),
        const Divider(height: 32, indent: Space.lg, endIndent: Space.lg),
        GigPackagesSection(gig: gig, selected: _pkg, onSelect: (i) => setState(() => _pkg = i)),
        if (gig.faqs.isNotEmpty) ...[
          const Divider(height: 32, indent: Space.lg, endIndent: Space.lg),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xs),
            child: Text(context.l10n.gigFaqTitle, style: context.textTheme.titleLarge),
          ),
          for (final f in gig.faqs)
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: Insets.page,
                childrenPadding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.md),
                expandedAlignment: Alignment.centerLeft,
                title: Text(f.question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                children: [Text(f.answer, style: TextStyle(color: cs.onSurfaceVariant))],
              ),
            ),
        ],
        if (seller != null) ...[
          const Divider(height: 32, indent: Space.lg, endIndent: Space.lg),
          GigAboutSeller(seller: seller, gig: gig),
          const Divider(height: 32, indent: Space.lg, endIndent: Space.lg),
          GigReviewsPreview(seller: seller, reviews: d.reviews),
          if (seller.portfolio.isNotEmpty) ...[
            SectionHeader(
              title: context.l10n.gigPortfolio,
              onAction: () => context.push('/user/${seller.id}/portfolio'),
            ),
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: Insets.page,
                itemCount: seller.portfolio.length,
                separatorBuilder: (_, _) => Gaps.h12,
                itemBuilder: (context, i) => PortfolioThumb(
                  item: seller.portfolio[i],
                  width: 160,
                  onTap: () => context.push('/portfolio/${seller.id}/${seller.portfolio[i].id}'),
                ),
              ),
            ),
          ],
        ],
        if (d.otherGigs.isNotEmpty) ...[
          SectionHeader(
            title: context.l10n.gigMoreFromSeller(seller?.displayName ?? context.l10n.gigSellerFallback),
            onAction: () => context.push('/user/${gig.sellerId}?tab=1'),
          ),
          GigStrip(gigs: d.otherGigs),
        ],
        if (recent.isNotEmpty) ...[
          SectionHeader(title: context.l10n.gigRecentlyViewed, onAction: () => context.push('/history')),
          GigStrip(gigs: recent),
        ],
      ],
    );
  }

  Widget _gallery(BuildContext context, Gig gig) {
    final seeds = gig.imageSeeds.isEmpty ? [0] : gig.imageSeeds;
    final top = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: 280 + top,
      child: Stack(
        children: [
          PageView.builder(
            key: const ValueKey('gig_gallery'),
            itemCount: seeds.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => PlaceholderImage(seed: seeds[i], label: i == 0 ? gig.imageLabel : ''),
          ),
          Positioned(
            right: Space.lg,
            bottom: Space.md,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: Space.xs),
              decoration: const BoxDecoration(color: Colors.black54, borderRadius: Radii.lgAll),
              child: Text(
                '${_page + 1} / ${seeds.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellerRow(BuildContext context, AppUser seller) => InkWell(
    key: const ValueKey('gig_seller'),
    onTap: () => context.push('/user/${seller.id}'),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, 14, Space.lg, 6),
      child: Row(
        children: [
          UserAvatar(user: seller, size: 46, showOnline: true),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(seller.displayName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
                Gaps.v4,
                Wrap(
                  spacing: Space.sm,
                  runSpacing: Space.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SellerBadges(user: seller),
                    RatingText(rating: seller.rating, count: seller.reviewCount, size: 12.5),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: context.colors.onSurfaceVariant),
        ],
      ),
    ),
  );

  Widget _description(BuildContext context, Gig gig) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.lg, 14, Space.lg, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: Text(
            gig.description,
            maxLines: _descExpanded ? null : 4,
            overflow: _descExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(height: 1.5),
          ),
        ),
        if (gig.description.length > 160)
          InkWell(
            key: const ValueKey('desc_more'),
            onTap: () => setState(() => _descExpanded = !_descExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                _descExpanded ? context.l10n.gigShowLess : context.l10n.gigShowMore,
                style: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
              ),
            ),
          ),
      ],
    ),
  );
}
