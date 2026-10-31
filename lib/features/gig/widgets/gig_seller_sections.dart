import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/user.dart';
import 'review_widgets.dart';

/// "Th5/2021" / "5/2021" – tháng tham gia của người bán, hoặc "—".
String memberSinceLabel(AppLocalizations l, DateTime? d) =>
    d == null ? '—' : l.gigMemberSinceValue('${d.month}', '${d.year}');

/// Mục "Về người bán" trong chi tiết gig.
class GigAboutSeller extends StatelessWidget {
  const GigAboutSeller({super.key, required this.seller, required this.gig});
  final AppUser seller;
  final Gig gig;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    Widget info(String k, String v) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k, style: context.textTheme.bodySmall),
          Gaps.v2,
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
    return Padding(
      padding: Insets.page,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.gigAboutSeller, style: context.textTheme.titleLarge),
          Gaps.v12,
          InkWell(
            onTap: () => context.push('/user/${seller.id}'),
            child: Row(
              children: [
                UserAvatar(user: seller, size: 60, showOnline: true),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(seller.displayName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      if (seller.headline.isNotEmpty)
                        Text(seller.headline, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
                      Gaps.v4,
                      RatingText(rating: seller.rating, count: seller.reviewCount, size: 13),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              info(l.gigFrom, seller.city.isEmpty ? seller.country : seller.city),
              info(l.gigMemberSince, memberSinceLabel(l, seller.memberSince)),
            ],
          ),
          Gaps.v12,
          Row(
            children: [
              info(l.gigAvgResponse, l.gigHours(seller.responseHours)),
              info(l.gigLanguages, seller.languages.join(', ')),
            ],
          ),
          if (seller.bio.isNotEmpty) ...[
            Gaps.v12,
            Text(
              seller.bio,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 14),
          OutlinedButton(
            key: const ValueKey('gig_contact'),
            onPressed: () => context.push('/contact/${seller.id}?gig=${gig.id}'),
            child: Text(l.gigContact),
          ),
        ],
      ),
    );
  }
}

/// Mục đánh giá trong chi tiết gig: tổng quan + 3 đánh giá đầu + nút "Xem tất cả".
class GigReviewsPreview extends StatelessWidget {
  const GigReviewsPreview({super.key, required this.seller, required this.reviews});
  final AppUser seller;
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) => Padding(
    padding: Insets.page,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RatingSummary(rating: seller.rating, count: seller.reviewCount),
        Gaps.v8,
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.md),
            child: Text(context.l10n.gigNoReviews, style: context.textTheme.bodySmall),
          )
        else ...[
          for (final r in reviews.take(3)) ...[
            const Divider(),
            ReviewTile(review: r, sellerName: seller.displayName, compact: true),
          ],
          Gaps.v4,
          OutlinedButton(
            key: const ValueKey('gig_all_reviews'),
            onPressed: () => context.push('/user/${seller.id}/reviews'),
            child: Text(context.l10n.gigSeeAllReviews(Fmt.number(seller.reviewCount))),
          ),
        ],
      ],
    ),
  );
}
