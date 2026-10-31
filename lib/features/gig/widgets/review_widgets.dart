import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';

/// Ba tiêu chí đánh giá suy ra từ điểm tổng (dữ liệu mock không lưu riêng).
List<({String label, double value})> ratingCriteria(AppLocalizations l, double rating) {
  double c(double d) => (rating + d).clamp(1, 5).toDouble();
  return [
    (label: l.gigCriteriaCommunication, value: c(0.1)),
    (label: l.gigCriteriaQuality, value: c(0)),
    (label: l.gigCriteriaValue, value: c(-0.1)),
  ];
}

/// Khối "Đánh giá tổng quan ★ 4.8" + 3 tiêu chí.
class RatingSummary extends StatelessWidget {
  const RatingSummary({super.key, required this.rating, this.count});
  final double rating;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    Widget row(String label, double v, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: bold ? context.textTheme.titleMedium : TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
            ),
          ),
          Icon(Icons.star_rounded, size: bold ? 22 : 17, color: cs.onSurface),
          Gaps.h2,
          Text(
            v.toStringAsFixed(1),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: bold ? 17 : 14),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row(l.gigRatingOverall, rating, bold: true),
        if (count != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(l.gigReviewCount(Fmt.number(count!)), style: context.textTheme.bodySmall),
          ),
        for (final c in ratingCriteria(l, rating)) row(c.label, c.value),
      ],
    );
  }
}

enum ReviewSort { relevant, newest, positive, negative }

extension ReviewSortX on ReviewSort {
  String localized(AppLocalizations l) => switch (this) {
    ReviewSort.relevant => l.sortRelevance,
    ReviewSort.newest => l.sortNewest,
    ReviewSort.positive => l.gigReviewSortPositive,
    ReviewSort.negative => l.gigReviewSortNegative,
  };

  IconData get icon => switch (this) {
    ReviewSort.relevant => Icons.auto_awesome_outlined,
    ReviewSort.newest => Icons.schedule_rounded,
    ReviewSort.positive => Icons.thumb_up_alt_outlined,
    ReviewSort.negative => Icons.thumb_down_alt_outlined,
  };
}

List<Review> sortReviews(List<Review> list, ReviewSort sort) {
  final l = [...list];
  switch (sort) {
    case ReviewSort.relevant:
      // Ưu tiên đánh giá dài + có phản hồi.
      int score(Review r) => r.text.length + (r.sellerResponse != null ? 200 : 0) + (r.rating * 40).round();
      l.sort((a, b) => score(b).compareTo(score(a)));
    case ReviewSort.newest:
      l.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case ReviewSort.positive:
      l.sort((a, b) => b.rating.compareTo(a.rating));
    case ReviewSort.negative:
      l.sort((a, b) => a.rating.compareTo(b.rating));
  }
  return l;
}

/// Bottom sheet "Sắp xếp theo" cho đánh giá.
Future<ReviewSort?> showReviewSortSheet(BuildContext context, ReviewSort current) => showModalBottomSheet<ReviewSort>(
  context: context,
  builder: (ctx) => SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.sm),
          child: Text(ctx.l10n.gigSortBy, style: ctx.textTheme.titleMedium),
        ),
        for (final s in ReviewSort.values)
          ListTile(
            key: ValueKey('review_sort_${s.name}'),
            leading: Icon(s.icon),
            title: Text(s.localized(ctx.l10n), style: const TextStyle(fontWeight: FontWeight.w500)),
            trailing: s == current ? const Icon(Icons.check_rounded) : null,
            onTap: () => Navigator.pop(ctx, s),
          ),
        Gaps.v8,
      ],
    ),
  ),
);

/// Một đánh giá: tác giả, quốc gia, sao, nội dung, phản hồi người bán.
class ReviewTile extends StatefulWidget {
  const ReviewTile({super.key, required this.review, this.sellerName, this.compact = false});
  final Review review;
  final String? sellerName;
  final bool compact;

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  bool _showResponse = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.review;
    final cs = context.colors;
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(name: r.authorName, seed: r.authorSeed, size: 36),
              Gaps.h10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.authorName, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(r.authorCountry, style: context.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.star_rounded, size: 17, color: cs.onSurface),
              Text(r.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          Gaps.v4,
          Text(Fmt.ago(r.createdAt), style: context.textTheme.bodySmall),
          Gaps.v8,
          Text(r.text, maxLines: widget.compact ? 4 : null, overflow: widget.compact ? TextOverflow.ellipsis : null),
          if (!widget.compact && (r.price != null || r.durationDays != null)) ...[
            Gaps.v10,
            Wrap(
              spacing: Space.lg,
              runSpacing: Space.xs,
              children: [
                if (r.price != null) _meta(context, l.gigReviewPrice, Fmt.money(r.price!)),
                if (r.durationDays != null) _meta(context, l.gigReviewDuration, Fmt.days(r.durationDays!)),
              ],
            ),
          ],
          if (r.sellerResponse != null) ...[
            Gaps.v10,
            InkWell(
              onTap: () => setState(() => _showResponse = !_showResponse),
              borderRadius: BorderRadius.circular(Space.sm),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: 10),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(Space.sm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.reply_rounded, size: 18, color: cs.onSurfaceVariant),
                        Gaps.h6,
                        Expanded(
                          child: Text(
                            l.gigSellerResponse,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: cs.onSurface),
                          ),
                        ),
                        Text(
                          _showResponse ? l.gigResponseHide : l.gigResponseRead,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (_showResponse) ...[
                      Gaps.v6,
                      if (widget.sellerName != null) Text(widget.sellerName!, style: context.textTheme.bodySmall),
                      Text(r.sellerResponse!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _meta(BuildContext context, String k, String v) => Text.rich(
    TextSpan(
      children: [
        TextSpan(text: '$k: ', style: context.textTheme.bodySmall),
        TextSpan(
          text: v,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    ),
  );
}
