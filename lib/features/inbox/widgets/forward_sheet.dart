import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../state/app_controllers.dart';
import 'inbox_common.dart';

/// Bottom sheet "Chuyển tiếp tin nhắn": chọn nhiều người nhận.
/// Trả về danh sách id hội thoại được chọn.
Future<Set<String>?> showForwardSheet(
  BuildContext context, {
  required String preview,
  required String excludeConversationId,
}) => showModalBottomSheet<Set<String>>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _ForwardSheet(preview: preview, exclude: excludeConversationId),
);

class _ForwardSheet extends StatefulWidget {
  const _ForwardSheet({required this.preview, required this.exclude});
  final String preview;
  final String exclude;
  @override
  State<_ForwardSheet> createState() => _ForwardSheetState();
}

class _ForwardSheetState extends State<_ForwardSheet> with ParticipantCache {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final list = context
        .watch<InboxController>()
        .conversations
        .where((c) => c.id != widget.exclude && !c.blocked && !c.isSpam)
        .toList();
    ensureUsers(list.map((c) => c.participantId));
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xs, Space.sm, Space.lg, 0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                Expanded(
                  child: Text(l.inboxForwardTitle, textAlign: TextAlign.center, style: context.textTheme.titleMedium),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.sm),
            padding: Insets.cardSm,
            width: double.infinity,
            decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: Radii.mdAll),
            child: Text(
              widget.preview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, Space.xs),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l.inboxRecentConversations, style: context.textTheme.titleSmall),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? EmptyState(icon: Icons.forum_outlined, title: l.inboxNoOtherConversations, compact: true)
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final c = list[i];
                      final u = users[c.participantId];
                      final sel = _selected.contains(c.id);
                      return InkWell(
                        key: ValueKey('fwd_${c.id}'),
                        onTap: () => setState(() => sel ? _selected.remove(c.id) : _selected.add(c.id)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                sel ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                color: sel ? cs.onSurface : cs.outline,
                              ),
                              Gaps.h12,
                              UserAvatar(user: u, name: u?.displayName ?? '?', size: 40, showOnline: true),
                              Gaps.h12,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u?.displayName ?? l.inboxUser,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5),
                                    ),
                                    Text(
                                      c.lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          BottomActionBar(
            child: PrimaryButton(
              key: const ValueKey('fwd_send'),
              label: _selected.isEmpty ? l.inboxForward : l.inboxForwardCount(_selected.length),
              onPressed: _selected.isEmpty ? null : () => Navigator.pop(context, _selected),
            ),
          ),
        ],
      ),
    );
  }
}
