import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';

/// Nút viên thuốc "Sửa"/"Xong" trên app bar Hộp thư.
class InboxPillButton extends StatelessWidget {
  const InboxPillButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surfaceContainerHighest,
    shape: const StadiumBorder(),
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
      ),
    ),
  );
}

/// Thanh thao tác hàng loạt ở chế độ Sửa.
class InboxEditBar extends StatelessWidget {
  const InboxEditBar({
    super.key,
    required this.hasSelection,
    required this.allArchived,
    required this.anyUnread,
    required this.onArchive,
    required this.onRead,
    required this.onMore,
  });

  final bool hasSelection;
  final bool allArchived;
  final bool anyUnread;
  final VoidCallback onArchive;
  final VoidCallback onRead;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.colors.outlineVariant)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs),
        child: Row(
          children: [
            _BarButton(
              key: const ValueKey('edit_archive'),
              label: allArchived ? l.inboxUnarchive : l.inboxArchive,
              onTap: hasSelection ? onArchive : null,
            ),
            _BarButton(
              key: const ValueKey('edit_read'),
              label: anyUnread || !hasSelection ? l.inboxMarkRead : l.inboxMarkUnread,
              onTap: hasSelection ? onRead : null,
            ),
            _BarButton(key: const ValueKey('edit_more'), label: l.inboxMore, onTap: hasSelection ? onMore : null),
          ],
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: 10)),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: onTap == null ? cs.onSurfaceVariant.withValues(alpha: 0.5) : cs.onSurface,
          ),
        ),
      ),
    );
  }
}
