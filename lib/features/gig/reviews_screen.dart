import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import 'widgets/discovery_widgets.dart';

/// Toàn bộ đánh giá của người bán, có sắp xếp và lọc.
class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.userId});
  final String userId;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

enum _ReviewFilter { all, five, four, low, responded }

extension on _ReviewFilter {
  String localized(AppLocalizations l) => switch (this) {
    _ReviewFilter.all => l.gigFilterAll,
    _ReviewFilter.five => l.gigFilterFive,
    _ReviewFilter.four => l.gigFilterFour,
    _ReviewFilter.low => l.gigFilterLow,
    _ReviewFilter.responded => l.gigFilterResponded,
  };

  bool test(Review r) => switch (this) {
    _ReviewFilter.all => true,
    _ReviewFilter.five => r.rating >= 4.5,
    _ReviewFilter.four => r.rating >= 3.5 && r.rating < 4.5,
    _ReviewFilter.low => r.rating < 3.5,
    _ReviewFilter.responded => r.sellerResponse != null,
  };
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late final Future<({AppUser? user, List<Review> reviews})> _future;
  ReviewSort _sort = ReviewSort.relevant;
  _ReviewFilter _filter = _ReviewFilter.all;

  @override
  void initState() {
    super.initState();
    final c = context.read<CatalogRepository>();
    _future = Future.wait<Object?>([
      c.userById(widget.userId),
      c.reviewsForSeller(widget.userId),
    ]).then((r) => (user: r[0] as AppUser?, reviews: r[1] as List<Review>));
  }

  Future<void> _pickSort() async {
    final s = await showReviewSortSheet(context, _sort);
    if (s != null) setState(() => _sort = s);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<({AppUser? user, List<Review> reviews})>(
    future: _future,
    builder: (context, snap) {
      final u = snap.data?.user;
      final l = context.l10n;
      return Scaffold(
        appBar: SimpleAppBar(
          title: u == null ? l.gigTabReviews : l.gigReviewCount(Fmt.number(u.reviewCount)),
          actions: [
            IconButton(
              key: const ValueKey('reviews_sort'),
              tooltip: l.gigSortTooltip,
              onPressed: snap.hasData ? _pickSort : null,
              icon: const Icon(Icons.sort_rounded),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            if (snap.hasError) {
              return EmptyState(icon: Icons.error_outline_rounded, title: l.commonErrorTitle, message: '${snap.error}');
            }
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            if (u == null) {
              return EmptyState(icon: Icons.person_off_outlined, title: l.gigSellerNotFound);
            }
            final list = sortReviews(snap.data!.reviews.where(_filter.test).toList(), _sort);
            return ListView(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxxl),
              children: [
                RatingSummary(rating: u.rating, count: u.reviewCount),
                Gaps.v12,
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _ReviewFilter.values.length,
                    separatorBuilder: (_, _) => Gaps.h8,
                    itemBuilder: (context, i) {
                      final f = _ReviewFilter.values[i];
                      return Center(
                        child: SelectChip(
                          key: ValueKey('review_filter_${f.name}'),
                          label: f.localized(l),
                          selected: f == _filter,
                          onTap: () => setState(() => _filter = f),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Space.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.gigReviewsShown(list.length),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                      Flexible(
                        child: TextButton(
                          onPressed: _pickSort,
                          child: Text(
                            _sort.localized(l),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (list.isEmpty)
                  EmptyState(
                    icon: Icons.rate_review_outlined,
                    title: l.gigNoMatchingReviews,
                    actionLabel: _filter == _ReviewFilter.all ? null : l.commonSeeAll,
                    onAction: () => setState(() => _filter = _ReviewFilter.all),
                    compact: true,
                  ),
                for (final r in list) ...[const Divider(), ReviewTile(review: r, sellerName: u.displayName)],
              ],
            );
          },
        ),
      );
    },
  );
}
