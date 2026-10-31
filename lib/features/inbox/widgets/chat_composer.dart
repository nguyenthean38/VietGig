import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../data/models/catalog.dart';
import 'message_widgets.dart';

/// Thanh soạn tin cuối màn chat: thanh trả lời, gig đính kèm, ô nhập và các nút.
class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.canSend,
    required this.onAttach,
    required this.onQuick,
    required this.onSend,
    this.replyName,
    this.replyPreview,
    this.onCancelReply,
    this.pendingGig,
    this.sellerName,
    this.onClosePendingGig,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool canSend;
  final VoidCallback onAttach;
  final VoidCallback onQuick;
  final VoidCallback onSend;

  /// Có giá trị khi đang trả lời một tin nhắn.
  final String? replyName;
  final String? replyPreview;
  final VoidCallback? onCancelReply;

  final Gig? pendingGig;
  final String? sellerName;
  final VoidCallback? onClosePendingGig;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final gig = pendingGig;
    final inputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none);
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: cs.outlineVariant)),
        ),
        padding: const EdgeInsets.all(Space.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (replyName != null)
              Container(
                key: const ValueKey('reply_bar'),
                margin: const EdgeInsets.fromLTRB(Space.sm, 0, 0, Space.sm),
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: context.tokens.brand, width: 3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.inboxReplyingTo(replyName!),
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            replyPreview ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('reply_cancel'),
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: onCancelReply,
                    ),
                  ],
                ),
              ),
            if (gig != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.sm, 0, Space.sm, Space.sm),
                child: RelatedGigCard(gig: gig, sellerName: sellerName, onClose: onClosePendingGig),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  key: const ValueKey('chat_attach'),
                  tooltip: l.inboxAttachTooltip,
                  onPressed: onAttach,
                  icon: const Icon(Icons.add_circle_outline_rounded),
                ),
                Expanded(
                  child: TextField(
                    key: const ValueKey('chat_input'),
                    controller: controller,
                    focusNode: focusNode,
                    minLines: 1,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: l.inboxInputHint,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: cs.outline)),
                    ),
                  ),
                ),
                IconButton(
                  key: const ValueKey('chat_quick'),
                  tooltip: l.inboxQuickReplies,
                  onPressed: onQuick,
                  icon: const Icon(Icons.bolt_rounded),
                ),
                IconButton(
                  key: const ValueKey('chat_send'),
                  tooltip: l.inboxSend,
                  onPressed: canSend ? onSend : null,
                  icon: Icon(Icons.send_rounded, color: canSend ? context.tokens.brand : cs.outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Thanh thay cho ô soạn tin khi đã chặn đối tác.
class ChatBlockedBar extends StatelessWidget {
  const ChatBlockedBar({super.key, required this.onUnblock});
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(Space.lg, 10, Space.sm, 10),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
            Icon(Icons.block_rounded, size: 18, color: cs.onSurfaceVariant),
            Gaps.h8,
            Expanded(
              child: Text(context.l10n.inboxBlockedNotice, style: TextStyle(color: cs.onSurfaceVariant)),
            ),
            TextButton(onPressed: onUnblock, child: Text(context.l10n.inboxUnblock)),
          ],
        ),
      ),
    );
  }
}
