// Các loại nút dùng chung.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n.dart';
import 'visuals.dart';

/// Nút tròn trắng có bóng nhẹ (back, tim, menu ...).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = 40,
    this.iconColor,
    this.background,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final Color? iconColor;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: background ?? cs.surface,
        shape: const CircleBorder(),
        elevation: 0,
        shadowColor: Colors.black26,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(icon, size: size * 0.52, color: iconColor ?? cs.onSurface),
          ),
        ),
      ),
    );
  }
}

/// Nút back tròn chuẩn.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed, this.close = false});
  final VoidCallback? onPressed;
  final bool close;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Center(
      child: CircleIconButton(
        icon: close ? Icons.close_rounded : Icons.arrow_back_ios_new_rounded,
        size: 40,
        tooltip: close ? context.l10n.commonClose : context.l10n.commonBack,
        onPressed: onPressed ?? () => context.canPop() ? context.pop() : context.go('/home'),
      ),
    ),
  );
}

/// Nút chính (đen) có trạng thái loading.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.expand = true,
    this.color,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool expand;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 19), const SizedBox(width: 8)],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );
    final btn = FilledButton(
      onPressed: loading ? null : onPressed,
      style: color == null ? null : FilledButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
      child: child,
    );
    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

/// Nút "Liên hệ" nổi kèm avatar (như nút "Chat" trên trang gig).
class FloatingChatButton extends StatelessWidget {
  const FloatingChatButton({super.key, required this.seed, required this.name, required this.onPressed, this.label});
  final int seed;
  final String name;
  final String? label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    elevation: 6,
    shadowColor: Colors.black26,
    shape: const StadiumBorder(),
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(seed: seed, name: name, size: 34, showOnline: true, online: true),
            const SizedBox(width: 8),
            Text(
              label ?? context.l10n.commonMessage,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ],
        ),
      ),
    ),
  );
}
