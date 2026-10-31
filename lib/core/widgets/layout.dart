// Khung bố cục dùng chung: app bar, tiêu đề mục, dòng menu, thẻ, trạng thái rỗng.

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'buttons.dart';
import 'visuals.dart';

/// AppBar đơn giản có nút back tròn.
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.close = false,
    this.showBack = true,
    this.bottom,
    this.onBack,
  });
  final String title;
  final List<Widget>? actions;
  final bool close;
  final bool showBack;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => Size.fromHeight(60 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) => AppBar(
    toolbarHeight: 60,
    leadingWidth: 56,
    automaticallyImplyLeading: false,
    leading: showBack ? AppBackButton(close: close, onPressed: onBack) : null,
    title: Text(title),
    actions: [...?actions, const SizedBox(width: 8)],
    bottom: bottom,
  );
}

/// Tiêu đề mục + liên kết "Xem tất cả".
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(16, 24, 16, 12),
  });
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (onAction != null)
          InkWell(
            onTap: onAction,
            child: Text(
              actionLabel ?? context.l10n.commonSeeAll,
              style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
      ],
    ),
  );
}

/// Dòng menu: icon – tiêu đề – mũi tên.
class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.destructive = false,
    this.showChevron = true,
  });
  final String title;
  final IconData? icon;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool destructive;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = destructive ? context.tokens.danger : cs.onSurface;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22, color: destructive ? context.tokens.danger : cs.onSurfaceVariant),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15.5, color: color, fontWeight: FontWeight.w500),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            ?trailing,
            if (trailing == null && showChevron) Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// Trạng thái rỗng.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Illustration(icon: icon, size: compact ? 90 : 130),
          const SizedBox(height: 20),
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
          if (actionLabel != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!, style: const TextStyle(decoration: TextDecoration.underline)),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Khung nút cố định ở cuối màn hình.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child, this.note});
  final Widget child;
  final Widget? note;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (note != null) ...[note!, const SizedBox(height: 10)],
          child,
        ],
      ),
    ),
  );
}

/// Thẻ có viền mảnh, bo góc.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.margin,
    this.color,
    this.borderColor,
  });
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: color ?? cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor ?? cs.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Bọc FutureBuilder với loading / lỗi / dữ liệu.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.future, required this.builder, this.loading});
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? loading;

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: future,
    builder: (context, snap) {
      if (snap.hasError) {
        return EmptyState(
          icon: Icons.error_outline_rounded,
          title: context.l10n.commonErrorTitle,
          message: '${snap.error}',
        );
      }
      if (snap.connectionState != ConnectionState.done) {
        return loading ??
            const Center(
              child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
            );
      }
      return builder(context, snap.data as T);
    },
  );
}
