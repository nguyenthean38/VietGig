import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/user.dart';

/// Thẻ dự án với khách hàng doanh nghiệp (tab "Khách hàng").
class ClientWorkCard extends StatefulWidget {
  const ClientWorkCard({super.key, required this.work});
  final ClientWork work;
  @override
  State<ClientWorkCard> createState() => _ClientWorkCardState();
}

class _ClientWorkCardState extends State<ClientWorkCard> {
  bool _more = false;
  @override
  Widget build(BuildContext context) {
    final w = widget.work;
    final l = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(name: w.company, seed: w.seed, size: 40, allowPhoto: false),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.gigClientProject(w.company), style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(w.period, style: context.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v10,
          Text(w.description, maxLines: _more ? null : 3, overflow: _more ? null : TextOverflow.ellipsis),
          if (w.description.length > 100)
            InkWell(
              onTap: () => setState(() => _more = !_more),
              child: Padding(
                padding: const EdgeInsets.only(top: Space.xs),
                child: Text(
                  _more ? l.gigShowLess : l.gigShowMore,
                  style: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                ),
              ),
            ),
          if (w.industry.isNotEmpty) ...[
            Gaps.v8,
            Text(l.gigClientIndustry(w.industry), style: context.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// Giữ TabBar ghim trên đầu NestedScrollView.
class PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  PinnedTabBarDelegate(this.tabBar, this.color);
  final TabBar tabBar;
  final Color color;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(color: color, child: tabBar);

  @override
  bool shouldRebuild(covariant PinnedTabBarDelegate old) => old.tabBar != tabBar || old.color != color;
}
