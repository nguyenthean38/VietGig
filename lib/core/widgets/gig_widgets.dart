import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/catalog.dart';
import '../../data/models/user.dart';
import '../l10n/l10n.dart';
import '../utils/format.dart';
import 'badges.dart';
import 'save_list_sheet.dart';
import 'visuals.dart';

export 'save_list_sheet.dart';

/// Thẻ gig dạng hàng ngang (ảnh trái, thông tin phải) – dùng ở kết quả tìm kiếm.
class GigListTile extends StatelessWidget {
  const GigListTile({super.key, required this.gig, this.seller, this.onTap});
  final Gig gig;
  final AppUser? seller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      key: ValueKey('gig_tile_${gig.id}'),
      onTap: onTap ?? () => context.push('/gig/${gig.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 128,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 130,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PlaceholderImage(seed: gig.imageSeeds.first, label: gig.imageLabel),
                    if (gig.isPro) const Positioned(left: 6, top: 6, child: ProTag()),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: RatingText(rating: gig.rating, count: gig.reviewCount, size: 13.5),
                            ),
                          ),
                          SizedBox(height: 28, child: SaveGigButton(gigId: gig.id, size: 20)),
                        ],
                      ),
                      if (seller != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(seller!.displayName, style: Theme.of(context).textTheme.bodySmall),
                        ),
                      Text(
                        gig.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, height: 1.3),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${context.l10n.commonFrom} ',
                                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                                ),
                                TextSpan(
                                  text: Fmt.money(gig.priceFrom),
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thẻ gig dọc (ảnh trên) – dùng trong băng chuyền ngang.
class GigCard extends StatelessWidget {
  const GigCard({super.key, required this.gig, this.width = 200, this.onTap, this.onRemove, this.seller});
  final Gig gig;
  final double width;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final AppUser? seller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      child: InkWell(
        key: ValueKey('gig_card_${gig.id}'),
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () => context.push('/gig/${gig.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.45,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PlaceholderImage(seed: gig.imageSeeds.first, label: gig.imageLabel),
                    if (gig.isPro) const Positioned(left: 8, top: 8, child: ProTag()),
                    if (onRemove != null)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: IconButton(
                          onPressed: onRemove,
                          tooltip: context.l10n.commonDelete,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            fixedSize: const Size(30, 30),
                            minimumSize: Size.zero,
                          ),
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 2, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: RatingText(rating: gig.rating, count: gig.reviewCount, size: 12.5),
                          ),
                        ),
                        SizedBox(height: 26, child: SaveGigButton(gigId: gig.id, size: 19)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 36,
                      child: Text(
                        gig.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, height: 1.35),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${context.l10n.commonFrom} ',
                                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11.5),
                              ),
                              TextSpan(
                                text: Fmt.money(gig.priceFrom),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dải thẻ gig cuộn ngang.
class GigCarousel extends StatelessWidget {
  const GigCarousel({super.key, required this.gigs, this.height, this.cardWidth = 200, this.onRemove});
  final List<Gig> gigs;

  /// Mặc định tính theo chiều rộng thẻ (ảnh tỉ lệ 1.45 + phần chữ).
  final double? height;
  final double cardWidth;
  final void Function(Gig gig)? onRemove;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height ?? cardWidth / 1.45 + 140 * MediaQuery.textScalerOf(context).scale(14) / 14,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: gigs.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, i) =>
          GigCard(gig: gigs[i], width: cardWidth, onRemove: onRemove == null ? null : () => onRemove!(gigs[i])),
    ),
  );
}

/// Hàng tóm tắt đơn/gig nhỏ: ảnh vuông + tiêu đề + giá.
class GigThumbRow extends StatelessWidget {
  const GigThumbRow({
    super.key,
    required this.seed,
    required this.title,
    this.trailing,
    this.subtitle,
    this.label = '',
  });
  final int seed;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      PlaceholderImage(seed: seed, label: label, width: 64, height: 48, radius: 8),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, height: 1.3),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
      if (trailing != null) ...[const SizedBox(width: 8), trailing!],
    ],
  );
}
