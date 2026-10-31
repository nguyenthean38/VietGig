import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/app_icons.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/chat.dart';
import '../../data/models/order.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import '../../core/utils/app_images.dart';
import '../gig/widgets/discovery_widgets.dart';
import 'widgets/home_banners.dart';
import 'widgets/home_cards.dart';

/// Trang chủ người mua.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> _categories;
  late Future<Map<String, Gig>> _gigIndex;
  late Future<List<Gig>> _popular;

  Set<String>? _interests;
  String? _interestsFor;

  Future<List<HomeOfferItem>>? _offers;
  String _offersKey = '';

  @override
  void initState() {
    super.initState();
    final catalog = context.read<CatalogRepository>();
    _categories = catalog.categories();
    _gigIndex = loadGigIndex(catalog);
    _popular = catalog.popularGigs();
    InterestsSync.version.addListener(_reloadInterests);
    _reloadInterests();
  }

  @override
  void dispose() {
    InterestsSync.version.removeListener(_reloadInterests);
    super.dispose();
  }

  Future<void> _reloadInterests() async {
    final session = context.read<SessionController>();
    if (!session.isSignedIn) return;
    final uid = session.userId;
    _interestsFor = uid;
    final s = await context.read<AccountRepository>().interests(uid);
    if (mounted) setState(() => _interests = s);
  }

  Future<void> _toggleInterest(String id) async {
    final session = context.read<SessionController>();
    final repo = context.read<AccountRepository>();
    final next = {...?_interests};
    final added = next.add(id);
    if (!added) next.remove(id);
    setState(() => _interests = next);
    await repo.saveInterests(session.userId, next);
    if (!mounted) return;
    showAppSnack(context, added ? context.l10n.homeInterestAdded : context.l10n.homeInterestRemoved);
  }

  /// Tải báo giá riêng đang chờ từ các hội thoại có báo giá.
  Future<List<HomeOfferItem>> _loadOffers(InboxController inbox, List<Conversation> convs) async {
    final out = <HomeOfferItem>[];
    for (final c in convs) {
      final msgs = await inbox.messages(c.id);
      for (final m in msgs.reversed) {
        final o = m.offer;
        if (m.type == MessageType.offer && o != null) {
          if (o.status == OfferStatus.pending) out.add(HomeOfferItem(c, m, o));
          break;
        }
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final user = session.user;
    final signedIn = session.isSignedIn;
    if (signedIn && _interestsFor != session.userId) {
      _interestsFor = session.userId;
      WidgetsBinding.instance.addPostFrameCallback((_) => _reloadInterests());
    }

    final inbox = context.watch<InboxController>();
    final offerConvs = signedIn
        ? inbox.conversations.where((c) => c.hasCustomOffer && !c.archived).toList()
        : <Conversation>[];
    final key = offerConvs.map((c) => '${c.id}@${c.updatedAt.millisecondsSinceEpoch}').join(',');
    if (key != _offersKey) {
      _offersKey = key;
      _offers = offerConvs.isEmpty ? Future.value(const []) : _loadOffers(inbox, offerConvs);
    }

    final orders = context.watch<OrdersController>();
    final active = signedIn ? orders.buying.where((o) => o.status.isActive).toList() : <Order>[];
    final history = signedIn ? context.watch<SavedController>().history : const <String>[];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            if (!signedIn) return;
            await Future.wait([orders.refresh(), inbox.refresh()]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: Insets.tabBottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(context),
                if (user != null && !user.emailVerified) VerifyEmailBanner(email: user.email),
                if (!signedIn) const GuestSignInCard(),
                _popularServices(context),
                if (signedIn) _offerSection(context),
                if (active.isNotEmpty) ...[
                  SectionHeader(title: context.l10n.homeActiveOrders, onAction: () => context.go('/orders')),
                  _activeOrders(context, active),
                ],
                if (signedIn) _interestSection(context),
                if (history.isNotEmpty) _historySection(context, history),
                _popularGigs(context),
                const InviteBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ header
  Widget _header(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.sm, Space.xs),
    child: Column(
      children: [
        Row(
          children: [
            const SizedBox(width: Space.huge),
            const Expanded(child: Center(child: BrandLogo(size: 28))),
            IconButton(
              key: const ValueKey('home_grid'),
              tooltip: context.l10n.homeCategoriesTooltip,
              onPressed: () => context.go('/search'),
              icon: const Icon(Icons.grid_view_rounded),
            ),
          ],
        ),
        Gaps.v10,
        Padding(
          padding: const EdgeInsets.only(right: Space.sm),
          child: FakeSearchField(key: const ValueKey('home_search'), onTap: () => context.push('/search/input')),
        ),
      ],
    ),
  );

  // ---------------------------------------------------------------- popular
  Widget _popularServices(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionHeader(title: context.l10n.homePopularServices, onAction: () => context.go('/search')),
      SizedBox(
        height: 150,
        child: FutureBuilder<List<Category>>(
          future: _categories,
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(child: Text(context.l10n.homeCategoriesError));
            }
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            final subs = <({Subcategory sub, Category cat})>[
              for (final c in snap.data!)
                for (final s in c.subcategories) (sub: s, cat: c),
            ]..sort((a, b) => b.sub.gigCount.compareTo(a.sub.gigCount));
            final top = subs.take(10).toList();
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: Insets.page,
              itemCount: top.length,
              separatorBuilder: (_, _) => Gaps.h12,
              itemBuilder: (context, i) {
                final it = top[i];
                return InkWell(
                  key: ValueKey('popular_${it.sub.id}'),
                  borderRadius: Radii.mdAll,
                  onTap: () => context.push('/search/results?sub=${it.sub.id}&category=${it.cat.id}'),
                  child: SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 120,
                          child: PlaceholderImage(
                            image: AppImages.subcategory(it.sub.id),
                            seed: it.sub.id.hashCode,
                            radius: Radii.md,
                            icon: AppIcons.of(it.sub.icon),
                          ),
                        ),
                        Gaps.v6,
                        Text(
                          it.sub.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.25),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  );

  // ------------------------------------------------------------ custom offers
  Widget _offerSection(BuildContext context) => FutureBuilder<List<HomeOfferItem>>(
    future: _offers,
    builder: (context, snap) {
      final items = snap.data ?? const [];
      if (items.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: context.l10n.homeCustomOffers, onAction: () => context.go('/inbox')),
          SizedBox(
            height: 232 * MediaQuery.textScalerOf(context).scale(14) / 14,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: Insets.page,
              itemCount: items.length,
              separatorBuilder: (_, _) => Gaps.h12,
              itemBuilder: (context, i) => HomeOfferCard(
                item: items[i],
                width: items.length == 1 ? MediaQuery.sizeOf(context).width - Space.xxxl : 300,
              ),
            ),
          ),
        ],
      );
    },
  );

  // ----------------------------------------------------------- active orders
  Widget _activeOrders(BuildContext context, List<Order> active) => SizedBox(
    height: 150,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: Insets.page,
      itemCount: active.length,
      separatorBuilder: (_, _) => Gaps.h12,
      itemBuilder: (context, i) => HomeActiveOrderCard(
        order: active[i],
        width: active.length == 1 ? MediaQuery.sizeOf(context).width - Space.xxxl : 300.0,
      ),
    ),
  );

  // --------------------------------------------------------------- interests
  Widget _interestSection(BuildContext context) => FutureBuilder<List<Category>>(
    future: _categories,
    builder: (context, snap) {
      if (!snap.hasData || _interests == null) return const SizedBox.shrink();
      final picks = <Subcategory>[for (final c in snap.data!) ...c.subcategories.take(2)].take(12).toList();
      final chunks = <List<Subcategory>>[];
      for (var i = 0; i < picks.length; i += 3) {
        chunks.add(picks.sublist(i, (i + 3).clamp(0, picks.length)));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: context.l10n.homeInterestsTitle, onAction: () => context.push('/interests')),
          SizedBox(
            height: 3 * 58.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: Insets.page,
              itemCount: chunks.length,
              separatorBuilder: (_, _) => Gaps.h12,
              itemBuilder: (context, i) => SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.78,
                child: Column(
                  children: [
                    for (final s in chunks[i])
                      InterestRow(sub: s, selected: _interests!.contains(s.id), onToggle: () => _toggleInterest(s.id)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  // ----------------------------------------------------------------- history
  Widget _historySection(BuildContext context, List<String> history) => FutureBuilder<Map<String, Gig>>(
    future: _gigIndex,
    builder: (context, snap) {
      if (!snap.hasData) return const SizedBox.shrink();
      final gigs = [for (final id in history) ?snap.data![id]];
      if (gigs.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: context.l10n.homeRecentlyViewed, onAction: () => context.push('/history')),
          GigStrip(gigs: gigs.take(10).toList()),
        ],
      );
    },
  );

  Widget _popularGigs(BuildContext context) => FutureBuilder<List<Gig>>(
    future: _popular,
    builder: (context, snap) {
      if (!snap.hasData || snap.data!.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: context.l10n.homeMostLoved, onAction: () => context.push('/search/results?q=')),
          GigStrip(gigs: snap.data!.take(8).toList()),
        ],
      );
    },
  );
}
