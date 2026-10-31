import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/account.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/user.dart';
import '../../gig/widgets/discovery_widgets.dart';
import '../saved_lists_screen.dart';

/// Đầu trang chi tiết danh sách: ảnh ghép + lớp phủ tối, nút quay lại, menu, tên & người tạo.
class SavedListHeader extends StatelessWidget {
  const SavedListHeader({
    super.key,
    required this.list,
    required this.index,
    required this.username,
    required this.onMenu,
  });
  final SavedList list;
  final Map<String, Gig> index;
  final String username;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final l = context.l10n;
    return SizedBox(
      height: 210 + top,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ListCollage(list: list, index: index),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [context.tokens.overlay, Colors.black87],
              ),
            ),
          ),
          Positioned(
            top: top + Space.sm,
            left: 0,
            right: Space.sm,
            child: Row(
              children: [
                const AppBackButton(),
                const Spacer(),
                CircleIconButton(
                  key: const ValueKey('list_menu'),
                  icon: Icons.more_horiz_rounded,
                  tooltip: l.savedOptions,
                  onPressed: onMenu,
                ),
              ],
            ),
          ),
          Positioned(
            left: Space.lg,
            right: Space.lg,
            bottom: 18,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        list.name,
                        key: const ValueKey('list_title'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Gaps.h6,
                    Icon(
                      list.isPublic ? Icons.public_rounded : Icons.lock_outline_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ],
                ),
                Gaps.v4,
                Text(
                  l.savedCreatedBy(username.isEmpty ? l.savedCreatedByYou : username),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab "Dịch vụ" của danh sách: hàng gig (ảnh, tiêu đề, đánh giá, giá) + nút bỏ lưu.
class SavedListGigsTab extends StatelessWidget {
  const SavedListGigsTab({super.key, required this.gigs, required this.onRemove});
  final List<Gig> gigs;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (gigs.isEmpty) {
      return EmptyState(
        icon: Icons.favorite_border_rounded,
        title: l.savedNoGigsTitle,
        message: l.savedNoGigsMessage,
        actionLabel: l.savedExploreGigs,
        onAction: () => context.go('/search'),
        compact: true,
      );
    }
    final cs = context.colors;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      itemCount: gigs.length,
      separatorBuilder: (_, _) => Gaps.v4,
      itemBuilder: (context, i) {
        final g = gigs[i];
        return InkWell(
          key: ValueKey('list_gig_${g.id}'),
          onTap: () => context.push('/gig/${g.id}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlaceholderImage(
                  seed: g.imageSeeds.first,
                  label: g.imageLabel,
                  width: 120,
                  height: 86,
                  radius: Radii.md,
                ),
                Gaps.h12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(height: 1.3)),
                      Gaps.v4,
                      RatingText(rating: g.rating, count: g.reviewCount, size: 12.5),
                      Gaps.v4,
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${l.commonFrom} ',
                              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                            ),
                            TextSpan(
                              text: Fmt.money(g.priceFrom),
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: ValueKey('unsave_${g.id}'),
                  tooltip: l.savedUnsave,
                  onPressed: () => onRemove(g.id),
                  icon: Icon(Icons.favorite_rounded, color: context.tokens.danger),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tab "Người bán" của danh sách: lưới thẻ người bán + nút bỏ lưu.
class SavedListSellersTab extends StatelessWidget {
  const SavedListSellersTab({super.key, required this.users, required this.onRemove});
  final List<AppUser> users;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (users.isEmpty) {
      return EmptyState(
        icon: Icons.person_add_alt_outlined,
        title: l.savedNoSellersTitle,
        message: l.savedNoSellersMessage,
        compact: true,
      );
    }
    return GridView.builder(
      padding: Insets.pageAll,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Space.md,
        crossAxisSpacing: Space.md,
        mainAxisExtent: 180,
      ),
      itemCount: users.length,
      itemBuilder: (context, i) {
        final u = users[i];
        return AppCard(
          key: ValueKey('list_seller_${u.id}'),
          padding: const EdgeInsets.all(10),
          onTap: () => context.push('/user/${u.id}'),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Gaps.v6,
                    UserAvatar(user: u, size: 60, showOnline: true),
                    Gaps.v8,
                    Text(
                      u.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Gaps.v4,
                    SellerBadges(user: u, alignment: WrapAlignment.center),
                    Gaps.v4,
                    RatingText(rating: u.rating, count: u.reviewCount, size: 12.5, compact: true),
                  ],
                ),
              ),
              Positioned(
                right: -Space.sm,
                top: -Space.sm,
                child: IconButton(
                  key: ValueKey('unsave_seller_${u.id}'),
                  tooltip: l.savedUnsave,
                  onPressed: () => onRemove(u.id),
                  icon: Icon(Icons.favorite_rounded, color: context.tokens.danger, size: 22),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
