import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// Thông báo nhanh ở cuối màn hình (có nút Hoàn tác tuỳ chọn).
void showAppSnack(BuildContext context, String message, {VoidCallback? onUndo, bool success = true}) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
            color: success ? context.tokens.brand : context.tokens.danger,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
      action: onUndo == null
          ? null
          : SnackBarAction(label: context.l10n.commonUndo, textColor: Colors.white, onPressed: onUndo),
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Hộp thoại xác nhận. Trả về true nếu người dùng đồng ý.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String? confirmLabel,
  String? cancelLabel,
  bool destructive = false,
}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
      content: message == null ? null : Text(message),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx, false),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
                child: Text(cancelLabel ?? ctx.l10n.commonCancel),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                key: const ValueKey('confirm_ok'),
                onPressed: () => Navigator.pop(ctx, true),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  backgroundColor: destructive ? ctx.tokens.danger : null,
                  foregroundColor: destructive ? Colors.white : null,
                ),
                child: Text(confirmLabel ?? ctx.l10n.commonAgree),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return r ?? false;
}

/// Hộp thoại thông báo một nút.
Future<void> infoDialog(BuildContext context, {required String title, String? message, String ok = 'OK'}) =>
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
        content: message == null ? null : Text(message),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(ok)),
          ),
        ],
      ),
    );

/// Một hành động trong bottom sheet.
class SheetAction<T> {
  const SheetAction({required this.label, required this.value, this.icon, this.destructive = false, this.subtitle});
  final String label;
  final T value;
  final IconData? icon;
  final bool destructive;
  final String? subtitle;
}

/// Bottom sheet danh sách hành động; trả về value được chọn.
Future<T?> showActionSheet<T>(BuildContext context, {String? title, required List<SheetAction<T>> actions}) =>
    showModalBottomSheet<T>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
              ),
            for (final a in actions)
              ListTile(
                leading: a.icon == null
                    ? null
                    : Icon(a.icon, color: a.destructive ? ctx.tokens.danger : Theme.of(ctx).colorScheme.onSurface),
                title: Text(
                  a.label,
                  style: TextStyle(color: a.destructive ? ctx.tokens.danger : null, fontWeight: FontWeight.w500),
                ),
                subtitle: a.subtitle == null ? null : Text(a.subtitle!),
                onTap: () => Navigator.pop(ctx, a.value),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
