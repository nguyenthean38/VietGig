import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/chat.dart';
import '../../../data/models/user.dart';
import 'label_picker.dart';

/// Một dòng hội thoại trong Hộp thư.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.user,
    required this.editing,
    required this.selected,
    required this.onTap,
    this.onLongPress,
  });

  final Conversation conversation;
  final AppUser? user;
  final bool editing;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final t = context.tokens;
    final l = context.l10n;
    final c = conversation;
    final unread = c.unread > 0;
    final name = user?.displayName ?? l.inboxUnknownUser;
    final preview = c.lastMessage.isEmpty ? l.inboxStartConversation : c.lastMessage;
    return Material(
      color: selected ? cs.surfaceContainerHighest : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                child: editing
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10, top: Space.md),
                        child: Icon(
                          selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          size: 22,
                          color: selected ? cs.onSurface : cs.outline,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              UserAvatar(user: user, name: name, size: 48, showOnline: true),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15.5, fontWeight: unread ? FontWeight.w800 : FontWeight.w700),
                          ),
                        ),
                        if (user?.isVettedPro ?? false) ...[
                          Gaps.h4,
                          Icon(Icons.verified_rounded, size: 16, color: t.vettedFg),
                        ],
                        if (c.starred) ...[Gaps.h4, Icon(Icons.star_rounded, size: 16, color: t.starGold)],
                        const Spacer(),
                        Gaps.h8,
                        Text(
                          Fmt.chatStamp(c.updatedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: unread ? cs.onSurface : cs.onSurfaceVariant,
                            fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            preview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.3,
                              color: unread ? cs.onSurface : cs.onSurfaceVariant,
                              fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (unread)
                          Container(
                            margin: const EdgeInsets.only(left: Space.sm, top: Space.xs),
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(color: t.brand, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    if (c.labels.isNotEmpty) ...[
                      Gaps.v6,
                      Wrap(
                        spacing: Space.xs,
                        runSpacing: Space.xs,
                        children: [for (final lb in c.labels) ChatLabelChip(lb)],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
