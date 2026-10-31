import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';

/// Id người bán dùng làm dịch vụ mẫu khi người dùng chưa có dịch vụ nào.
const _sampleSellerId = 'u_hoang';

class _GigsData {
  const _GigsData(this.gigs, {required this.sample});
  final List<Gig> gigs;
  final bool sample;
}

/// "Chia sẻ dịch vụ của bạn" – danh sách dịch vụ của người bán.
class MyGigsScreen extends StatefulWidget {
  const MyGigsScreen({super.key});

  @override
  State<MyGigsScreen> createState() => _MyGigsScreenState();
}

class _MyGigsScreenState extends State<MyGigsScreen> {
  late Future<_GigsData> _future;

  /// Gig đang tạm dừng (chỉ lưu cục bộ).
  final Set<String> _paused = {};

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_GigsData> _load() async {
    final repo = context.read<CatalogRepository>();
    final mine = await repo.gigsBySeller(context.read<SessionController>().userId);
    if (mine.isNotEmpty) return _GigsData(mine, sample: false);
    return _GigsData(await repo.gigsBySeller(_sampleSellerId), sample: true);
  }

  Future<void> _share(Gig g) async {
    await Clipboard.setData(ClipboardData(text: 'https://vietgig.vn/gig/${g.id}'));
    if (mounted) showAppSnack(context, context.l10n.sellerGigsLinkCopied);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: SimpleAppBar(title: context.l10n.sellerGigsShare),
    body: AsyncView<_GigsData>(future: _future, builder: _body),
  );

  Widget _body(BuildContext context, _GigsData d) {
    final l = context.l10n;
    final t = context.tokens;
    return ListView(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxxl),
      children: [
        Text(l.sellerGigsShareTitle, style: context.textTheme.titleLarge),
        Gaps.v4,
        Text(l.sellerGigsShareDesc, style: context.textTheme.bodySmall),
        if (d.sample) ...[
          Gaps.v12,
          Container(
            padding: Insets.cardSm,
            decoration: BoxDecoration(color: t.infoSoft, borderRadius: Radii.mdAll),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: t.info, size: 20),
                Gaps.h10,
                Expanded(
                  child: Text(l.sellerGigsSampleNote, style: TextStyle(color: context.colors.onSurface, fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        if (d.gigs.isEmpty)
          EmptyState(
            icon: Icons.storefront_outlined,
            title: l.sellerGigsEmptyTitle,
            message: l.sellerGigsEmptyMessage,
            compact: true,
          )
        else
          for (final g in d.gigs)
            _GigShareCard(
              gig: g,
              sample: d.sample,
              active: !_paused.contains(g.id),
              onToggle: (v) {
                setState(() => v ? _paused.remove(g.id) : _paused.add(g.id));
                showAppSnack(context, v ? l.sellerGigsResumed : l.sellerGigsPausedSnack);
              },
              onShare: () => _share(g),
            ),
        Gaps.v16,
        Text(l.sellerGigsBoost, style: context.textTheme.titleLarge),
        Gaps.v12,
        const _PromoBanner(),
      ],
    );
  }
}

class _GigShareCard extends StatelessWidget {
  const _GigShareCard({
    required this.gig,
    required this.sample,
    required this.active,
    required this.onToggle,
    required this.onShare,
  });
  final Gig gig;
  final bool sample;
  final bool active;
  final ValueChanged<bool> onToggle;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    return AppCard(
      margin: const EdgeInsets.only(bottom: Space.md),
      padding: Insets.cardSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => context.push('/gig/${gig.id}'),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlaceholderImage(
                  seed: gig.imageSeeds.isEmpty ? 0 : gig.imageSeeds.first,
                  label: gig.imageLabel,
                  radius: Space.sm,
                  width: 84,
                  height: 64,
                ),
                Gaps.h12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gig.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Gaps.v4,
                      if (gig.reviewCount == 0)
                        Text(l.sellerGigsNoReviews, style: context.textTheme.bodySmall)
                      else
                        RatingText(rating: gig.rating, count: gig.reviewCount, size: 12.5),
                      Gaps.v4,
                      Text(
                        '${l.commonFrom} ${Fmt.money(gig.priceFrom)}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gaps.v8,
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? context.tokens.brand : cs.onSurfaceVariant,
                ),
              ),
              Gaps.h6,
              Expanded(
                child: Text(
                  active ? l.sellerGigsActive : l.sellerGigsPaused,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant),
                ),
              ),
              if (sample)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(l.sellerGigsSample, style: context.textTheme.bodySmall),
                ),
              Switch(key: ValueKey('gig_active_${gig.id}'), value: active, onChanged: onToggle),
            ],
          ),
          OutlinedButton.icon(
            key: ValueKey('gig_share_${gig.id}'),
            onPressed: onShare,
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            label: Text(l.sellerGigsShare),
          ),
        ],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () =>
          infoDialog(context, title: l.sellerGigsPromoTitle, message: l.sellerGigsPromoBody, ok: l.sellerGotIt),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.tokens.info, const Color(0xFFD94F7C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.15)),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.campaign_rounded, color: Colors.white, size: 48),
                      Gaps.v6,
                      Text(
                        l.sellerGigsPromoBanner,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.sellerGigsFeatured, style: context.textTheme.bodySmall),
                Gaps.v4,
                Text(l.sellerGigsPromoHeadline, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
