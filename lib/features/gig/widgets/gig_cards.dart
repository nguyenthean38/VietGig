import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/user.dart';

// Thẻ gig dùng cho các màn hình khám phá (trang chủ, tìm kiếm, hồ sơ, danh sách lưu).
//
// Đây là phiên bản riêng của feature, tương ứng với các widget core:
//   [DiscoveryGigCard] ~ `GigCard`, [GigStrip] ~ `GigCarousel`, [DiscoveryGigTile] ~ `GigListTile`.
// Khác biệt: chiều cao co giãn theo cỡ chữ hệ thống ([discoveryCardHeight]) và chữ tự thu nhỏ
// (FittedBox) để không tràn ở chiều rộng 360px. Không tạo thêm biến thể mới – nếu cần,
// mở rộng tham số của các widget dưới đây (hoặc hợp nhất vào core).

/// Thẻ gig dọc gọn (ảnh 1.45, đánh giá, tiêu đề 2 dòng, giá "Từ …").
///
/// Chịu được chiều rộng hẹp, không tràn chữ. [onRemove] hiện nút xoá trên ảnh (VD: lịch sử xem).
/// Key: `dgig_<id>`. Bấm mở `/gig/<id>`.
class DiscoveryGigCard extends StatelessWidget {
  const DiscoveryGigCard({super.key, required this.gig, this.width, this.onRemove});
  final Gig gig;
  final double? width;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return SizedBox(
      width: width,
      child: Material(
        color: cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.lgAll,
          side: BorderSide(color: cs.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('dgig_${gig.id}'),
          onTap: () => GoRouter.of(context).push('/gig/${gig.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1.45,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PlaceholderImage(seed: gig.imageSeeds.first, label: gig.imageLabel),
                    if (gig.isPro) const Positioned(left: Space.sm, top: Space.sm, child: ProTag()),
                    if (onRemove != null)
                      Positioned(
                        right: Space.xs,
                        top: Space.xs,
                        child: IconButton(
                          onPressed: onRemove,
                          tooltip: context.l10n.commonDelete,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            fixedSize: const Size(30, 30),
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                          ),
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, Space.xxs, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: RatingText(rating: gig.rating, count: gig.reviewCount, size: 12.5, compact: true),
                          ),
                        ),
                        SizedBox(width: 34, height: 30, child: SaveGigButton(gigId: gig.id, size: 19)),
                      ],
                    ),
                    Text(
                      gig.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, height: 1.3),
                    ),
                    Gaps.v6,
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: Space.sm),
                        child: GigPriceFrom(price: gig.priceFrom, labelSize: 11.5, priceSize: 14),
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

/// Giá "Từ 500.000 ₫" (nhãn nhỏ xám + số đậm), tự thu nhỏ khi hẹp. Dùng chung cho các thẻ gig ở đây.
class GigPriceFrom extends StatelessWidget {
  const GigPriceFrom({super.key, required this.price, this.labelSize = 12, this.priceSize = 15});
  final int price;
  final double labelSize;
  final double priceSize;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${context.l10n.commonFrom} ',
            style: TextStyle(color: context.colors.onSurfaceVariant, fontSize: labelSize),
          ),
          TextSpan(
            text: Fmt.money(price),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: priceSize),
          ),
        ],
      ),
    ),
  );
}

/// Chiều cao phù hợp cho thẻ [DiscoveryGigCard] rộng [width].
/// Chiều cao thẻ: ảnh (tỉ lệ 1.45) + phần chữ, co giãn theo cỡ chữ hệ thống.
double discoveryCardHeight(double width, [double textScale = 1]) => width / 1.45 + 112 * textScale + 16;

/// Dải [DiscoveryGigCard] cuộn ngang, chiều cao tính theo [discoveryCardHeight] và cỡ chữ hệ thống.
class GigStrip extends StatelessWidget {
  const GigStrip({super.key, required this.gigs, this.cardWidth = 200});
  final List<Gig> gigs;
  final double cardWidth;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: discoveryCardHeight(cardWidth, MediaQuery.textScalerOf(context).scale(14) / 14),
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: Insets.page,
      itemCount: gigs.length,
      separatorBuilder: (_, _) => Gaps.h12,
      itemBuilder: (context, i) => Align(
        alignment: Alignment.topCenter,
        child: DiscoveryGigCard(gig: gigs[i], width: cardWidth),
      ),
    ),
  );
}

/// Thẻ gig dạng hàng ngang (ảnh trái, thông tin phải) – chiều cao cố định 138, an toàn khi lồng trong list.
/// Key: `gig_tile_<id>`. Bấm mở `/gig/<id>`.
class DiscoveryGigTile extends StatelessWidget {
  const DiscoveryGigTile({super.key, required this.gig, this.seller});
  final Gig gig;
  final AppUser? seller;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 6),
      child: Material(
        color: cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.lgAll,
          side: BorderSide(color: cs.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('gig_tile_${gig.id}'),
          onTap: () => GoRouter.of(context).push('/gig/${gig.id}'),
          child: SizedBox(
            height: 138,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 124,
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
                    padding: const EdgeInsets.fromLTRB(Space.md, 6, Space.xxs, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: RatingText(rating: gig.rating, count: gig.reviewCount, size: 13),
                              ),
                            ),
                            SizedBox(width: 36, height: 30, child: SaveGigButton(gigId: gig.id, size: 20)),
                          ],
                        ),
                        if (seller != null)
                          Text(
                            seller!.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall,
                          ),
                        Text(
                          gig.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13.5, height: 1.3),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: Space.sm),
                            child: GigPriceFrom(price: gig.priceFrom),
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
      ),
    );
  }
}
