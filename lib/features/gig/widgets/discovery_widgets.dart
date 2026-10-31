import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/repositories.dart';

export 'gig_cards.dart';
export 'review_widgets.dart';

/// Báo cho các màn hình (trang chủ, khám phá) biết sở thích vừa thay đổi để tải lại.
class InterestsSync {
  InterestsSync._();
  static final version = ValueNotifier<int>(0);
  static void bump() => version.value++;
}

/// Tải toàn bộ gig một lần để tra cứu theo id (lịch sử xem, danh sách lưu...).
Future<Map<String, Gig>> loadGigIndex(CatalogRepository repo) async {
  final all = await repo.search(const GigFilter());
  return {for (final g in all) g.id: g};
}

/// Sao chép liên kết và báo cho người dùng.
Future<void> copyLink(BuildContext context, String path) async {
  try {
    await Clipboard.setData(ClipboardData(text: 'https://vietgig.vn$path'));
  } catch (_) {
    // Bỏ qua lỗi nền tảng (VD: môi trường test).
  }
  if (context.mounted) showAppSnack(context, context.l10n.gigLinkCopied);
}

/// Tải một người dùng theo id (Future tạo trong initState).
class UserBuilder extends StatefulWidget {
  const UserBuilder({super.key, required this.userId, required this.builder});
  final String userId;
  final Widget Function(BuildContext context, AppUser? user) builder;

  @override
  State<UserBuilder> createState() => _UserBuilderState();
}

class _UserBuilderState extends State<UserBuilder> {
  late Future<AppUser?> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<CatalogRepository>().userById(widget.userId);
  }

  @override
  void didUpdateWidget(covariant UserBuilder old) {
    super.didUpdateWidget(old);
    if (old.userId != widget.userId) _future = context.read<CatalogRepository>().userById(widget.userId);
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<AppUser?>(future: _future, builder: (context, snap) => widget.builder(context, snap.data));
}

/// Ô tìm kiếm giả (bấm vào để mở màn hình nhập). [text] mặc định: "Tìm dịch vụ".
class FakeSearchField extends StatelessWidget {
  const FakeSearchField({super.key, required this.onTap, this.text, this.hasValue = false});
  final VoidCallback onTap;
  final String? text;
  final bool hasValue;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: Radii.mdAll,
      child: InkWell(
        borderRadius: Radii.mdAll,
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: hasValue ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Gaps.h12,
              Icon(Icons.search_rounded, size: 20, color: cs.onSurfaceVariant),
              Gaps.h8,
              Flexible(
                child: Text(
                  text ?? context.l10n.gigSearchHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: hasValue ? cs.onSurface : cs.onSurfaceVariant, fontSize: 14.5),
                ),
              ),
              Gaps.h12,
            ],
          ),
        ),
      ),
    );
  }
}

/// Giờ địa phương Việt Nam (UTC+7) dạng "14:05".
String vietnamLocalTime() => Fmt.time(DateTime.now().toUtc().add(const Duration(hours: 7)));

/// Huy hiệu người bán: Vetted Pro + cấp độ.
class SellerBadges extends StatelessWidget {
  const SellerBadges({super.key, required this.user, this.alignment = WrapAlignment.start});
  final AppUser user;
  final WrapAlignment alignment;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: Space.xs,
    alignment: alignment,
    children: [
      if (user.isVettedPro) const VettedProBadge(),
      if (user.level != SellerLevel.newSeller) LevelBadge(user.level),
      if (user.level == SellerLevel.newSeller)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(color: context.tokens.brandSoft, borderRadius: BorderRadius.circular(Radii.xs)),
          child: Text(
            context.l10n.gigNewSeller,
            style: TextStyle(color: context.tokens.brandStrong, fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ),
    ],
  );
}

/// Hàng thẻ portfolio nhỏ (ảnh + tiêu đề).
class PortfolioThumb extends StatelessWidget {
  const PortfolioThumb({super.key, required this.item, required this.onTap, this.width});
  final PortfolioItem item;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) => InkWell(
    key: ValueKey('portfolio_${item.id}'),
    onTap: onTap,
    borderRadius: Radii.mdAll,
    child: SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.25,
            child: PlaceholderImage(
              seed: item.seed,
              image: AppImages.portfolio(item.id).firstOrNull,
              radius: Radii.md,
              icon: Icons.collections_outlined,
            ),
          ),
          Gaps.v6,
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
          ),
          Gaps.v2,
          Row(
            children: [
              Icon(Icons.photo_library_outlined, size: 14, color: context.colors.onSurfaceVariant),
              Gaps.h4,
              Text('${item.imageCount}', style: context.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Chip chọn được kiểu viền (giống SelectChip) nhưng tự xuống dòng/rút gọn khi nhãn dài.
class FlexChip extends StatelessWidget {
  const FlexChip({super.key, required this.label, required this.selected, required this.onTap, this.showCheck = true});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Space.xxl),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: Space.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Space.xxl),
          border: Border.all(color: selected ? cs.onSurface : cs.outline, width: selected ? 1.6 : 1),
          color: selected ? cs.surfaceContainerHighest : cs.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCheck && selected) ...[const Icon(Icons.check_rounded, size: 16), Gaps.h4],
            Flexible(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.w500, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
