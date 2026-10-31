import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/user.dart';

/// App bar màn chat: avatar + tên + trạng thái online, nút đơn hàng và tuỳ chọn.
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key, required this.other, required this.onOrders, required this.onMenu});

  final AppUser? other;

  /// null = vô hiệu.
  final VoidCallback? onOrders;
  final VoidCallback? onMenu;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final other = this.other;
    final name = other?.displayName ?? l.inboxMessagesTitle;
    return AppBar(
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      leadingWidth: 56,
      leading: const AppBackButton(),
      titleSpacing: Space.sm,
      title: InkWell(
        onTap: other != null && other.isSeller ? () => context.push('/user/${other.id}') : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (other != null) ...[UserAvatar(user: other, size: 34, showOnline: true), Gaps.h10],
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  if (other != null)
                    Text(
                      other.online ? l.inboxOnline : l.inboxLocalTime(Fmt.time(DateTime.now())),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: other.online ? context.tokens.brand : cs.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          key: const ValueKey('chat_orders'),
          tooltip: l.inboxActiveOrdersTitle,
          onPressed: onOrders,
          icon: const Icon(Icons.assignment_outlined),
        ),
        IconButton(
          key: const ValueKey('chat_menu'),
          tooltip: l.inboxOptionsTooltip,
          onPressed: onMenu,
          icon: const Icon(Icons.more_horiz_rounded),
        ),
        Gaps.h4,
      ],
    );
  }
}
