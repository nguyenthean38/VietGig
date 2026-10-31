import 'package:flutter/material.dart';

import '../../data/models/user.dart';
import '../theme/app_colors.dart';
import '../utils/app_images.dart';
import '../l10n/l10n.dart';

/// Ảnh minh hoạ giả (thay cho ảnh thật khi chưa có backend/storage).
/// Vẽ nền gradient + hình khối + chữ, ổn định theo [seed].
class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({
    super.key,
    required this.seed,
    this.label = '',
    this.radius = 0,
    this.width,
    this.height,
    this.icon,
    this.image,
  });

  final int seed;

  /// Ảnh cụ thể (asset hoặc URL http). Nếu null sẽ tìm ảnh mẫu theo [seed].
  final String? image;
  final String label;
  final double radius;
  final double? width;
  final double? height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final src = image ?? AppImages.photo(seed);
    if (src != null) {
      final fallback = _gradient(context);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          width: width,
          height: height,
          child: src.startsWith('http')
              ? Image.network(src, fit: BoxFit.cover, errorBuilder: (_, _, _) => fallback)
              : Image.asset(src, fit: BoxFit.cover, errorBuilder: (_, _, _) => fallback),
        ),
      );
    }
    return _gradient(context);
  }

  Widget _gradient(BuildContext context) {
    final c1 = AppColors.fromSeed(seed);
    final c2 = AppColors.fromSeed(seed + 5);
    final dark = c1.computeLuminance() < 0.45;
    final fg = dark ? Colors.white : AppColors.ink;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c1, Color.lerp(c1, c2, 0.35)!],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, box) {
              final s = box.biggest.shortestSide.isFinite ? box.biggest.shortestSide : 120.0;
              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    right: -s * 0.18,
                    top: -s * 0.18,
                    child: _Blob(size: s * 0.75, color: c2.withValues(alpha: 0.55)),
                  ),
                  Positioned(
                    left: -s * 0.12,
                    bottom: -s * 0.22,
                    child: _Blob(size: s * 0.6, color: Colors.white.withValues(alpha: 0.14), square: seed.isEven),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: label.isEmpty
                          ? Icon(icon ?? Icons.image_outlined, color: fg.withValues(alpha: 0.85), size: s * 0.3)
                          : FittedBox(
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: fg,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color, this.square = false});
  final double size;
  final Color color;
  final bool square;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: square ? BoxShape.rectangle : BoxShape.circle,
      borderRadius: square ? BorderRadius.circular(size * 0.2) : null,
    ),
  );
}

/// Avatar người dùng: chữ cái đầu trên nền màu theo seed + chấm online.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.user,
    this.name,
    this.seed,
    this.size = 40,
    this.showOnline = false,
    this.online,
    this.photo,
    this.allowPhoto = true,
  });

  /// false = luôn hiện chữ cái đầu (VD logo công ty).
  final bool allowPhoto;

  /// Ảnh đại diện (asset/URL). Mặc định tìm theo người dùng hoặc tên.
  final String? photo;
  final AppUser? user;
  final String? name;
  final int? seed;
  final double size;
  final bool showOnline;
  final bool? online;

  @override
  Widget build(BuildContext context) {
    final n = user?.displayName ?? name ?? '?';
    final s = seed ?? user?.avatarSeed ?? n.hashCode;
    final initials =
        user?.initials ??
        (n.trim().isEmpty ? '?' : n.trim().split(RegExp(r'\s+')).take(2).map((e) => e[0]).join().toUpperCase());
    final bg = AppColors.fromSeed(s);
    final fg = bg.computeLuminance() < 0.5 ? Colors.white : AppColors.ink;
    final isOnline = online ?? user?.online ?? false;
    final src = !allowPhoto
        ? null
        : photo ??
              (user != null ? AppImages.avatarForUser(user!.id) : null) ??
              (user == null ? AppImages.avatarForName(n) : null);
    final text = Text(
      initials,
      style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: size * 0.38),
    );
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: src == null
                ? text
                : (src.startsWith('http')
                      ? Image.network(
                          src,
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => text,
                        )
                      : Image.asset(
                          src,
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => text,
                        )),
          ),
          if (showOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  color: isOnline ? context.tokens.brand : context.colors.outline,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Logo chữ "VietGig." của app.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 30, this.color});
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'vietgig',
            style: TextStyle(color: c),
          ),
          TextSpan(
            text: '.',
            style: TextStyle(color: context.tokens.brand),
          ),
        ],
      ),
      style: TextStyle(fontSize: size, fontWeight: FontWeight.w800, letterSpacing: -1.2, height: 1),
    );
  }
}

/// Biểu tượng app dạng ô vuông bo góc màu xanh.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 48});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: context.tokens.brand, shape: BoxShape.circle),
    child: Text(
      'vg',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size * 0.4, letterSpacing: -1),
    ),
  );
}

/// Minh hoạ đơn giản cho trạng thái rỗng (thay cho ảnh vẽ tay).
class Illustration extends StatelessWidget {
  const Illustration({super.key, required this.icon, this.size = 120});
  final IconData icon;
  final double size;
  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.82,
            height: size * 0.82,
            decoration: BoxDecoration(color: context.tokens.brandSoft, shape: BoxShape.circle),
          ),
          Positioned(
            right: size * 0.08,
            top: size * 0.1,
            child: Icon(Icons.auto_awesome, color: context.tokens.brand, size: size * 0.18),
          ),
          Icon(icon, size: size * 0.42, color: fg),
        ],
      ),
    );
  }
}
