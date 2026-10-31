import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/chat.dart';
import '../../../data/models/user.dart';
import 'chat_sheets.dart';
import 'message_widgets.dart';

/// Danh sách tin nhắn của màn chat (banner an toàn, phân cách ngày, tin nhắn, "đang soạn tin").
class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.controller,
    required this.messages,
    required this.meId,
    required this.meUser,
    required this.other,
    required this.otherId,
    required this.gigs,
    required this.declinedCalls,
    required this.typing,
    required this.onLongPress,
    required this.onViewOffer,
    required this.onSetOfferStatus,
    required this.onDeclineCall,
    required this.showScrollDown,
    required this.onScrollDown,
  });

  final ScrollController controller;
  final List<ChatMessage> messages;
  final String meId;
  final AppUser? meUser;
  final AppUser? other;
  final String? otherId;
  final Map<String, Gig?> gigs;
  final Set<String> declinedCalls;
  final bool typing;
  final void Function(ChatMessage m) onLongPress;
  final void Function(ChatMessage m) onViewOffer;
  final void Function(ChatMessage m, OfferStatus status) onSetOfferStatus;
  final void Function(ChatMessage m, bool fromMe) onDeclineCall;

  /// Hiện nút cuộn xuống cuối (khi người dùng đã cuộn lên xa).
  final bool showScrollDown;
  final VoidCallback onScrollDown;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final children = <Widget>[SafetyBanner(onLearnMore: () => showSafetyInfo(context))];

    if (messages.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xxl, Space.huge, Space.xxl, Space.xxl),
          child: Column(
            children: [
              UserAvatar(user: other, name: other?.displayName ?? '?', size: 72),
              Gaps.v12,
              Text(other?.displayName ?? '', style: context.textTheme.titleMedium),
              Gaps.v6,
              Text(
                l.inboxStartChatHint(other?.displayName ?? l.inboxPartner),
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    ChatMessage? prev;
    for (final m in messages) {
      final newDay =
          prev == null ||
          prev.sentAt.year != m.sentAt.year ||
          prev.sentAt.month != m.sentAt.month ||
          prev.sentAt.day != m.sentAt.day;
      if (newDay) children.add(DateSeparator(m.sentAt));
      final showHeader =
          newDay ||
          prev.senderId != m.senderId ||
          m.sentAt.difference(prev.sentAt).inMinutes > 10 ||
          m.type == MessageType.offer;
      final isMe = m.senderId == meId;
      children.add(
        MessageTile(
          key: ValueKey('msg_${m.id}'),
          message: m,
          sender: isMe ? meUser : other,
          isMe: isMe,
          showHeader: showHeader,
          onLongPress: () => onLongPress(m),
          content: _content(context, m, isMe),
        ),
      );
      prev = m;
    }

    if (typing) {
      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(58, Space.sm, Space.lg, Space.sm),
          child: Text(
            l.inboxTyping(other?.displayName ?? l.inboxPartnerCap),
            style: TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic, color: cs.onSurfaceVariant),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: ListView(
            key: const ValueKey('chat_list'),
            controller: controller,
            padding: const EdgeInsets.only(bottom: Space.lg),
            children: children,
          ),
        ),
        if (showScrollDown)
          Positioned(
            right: Space.lg,
            bottom: Space.md,
            child: CircleIconButton(
              key: const ValueKey('chat_scroll_down'),
              icon: Icons.arrow_downward_rounded,
              size: 40,
              tooltip: l.inboxScrollDown,
              onPressed: onScrollDown,
            ),
          ),
      ],
    );
  }

  Widget _content(BuildContext context, ChatMessage m, bool isMe) {
    final cs = context.colors;
    final l = context.l10n;
    final related = m.relatedGigId == null ? null : gigs[m.relatedGigId];
    final relatedCard = related == null || m.type == MessageType.offer
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RelatedGigCard(
              gig: related,
              sellerName: related.sellerId == otherId ? other?.displayName : null,
              onTap: () => context.push('/gig/${related.id}'),
            ),
          );
    final text = m.text.isEmpty
        ? null
        : Text(m.text, style: TextStyle(fontSize: 14.5, height: 1.42, color: cs.onSurface));

    switch (m.type) {
      case MessageType.text:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [?text, ?relatedCard]);
      case MessageType.file:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (text != null) ...[text, Gaps.v8],
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: FileCard(
                key: ValueKey('file_${m.id}'),
                name: m.fileName ?? l.inboxAttachment,
                size: m.fileSize,
                onTap: () => showAppSnack(context, l.inboxDownloading(m.fileName ?? l.inboxFileFallback)),
              ),
            ),
            ?relatedCard,
          ],
        );
      case MessageType.offer:
        final offer = m.offer;
        if (offer == null) return const SizedBox.shrink();
        return OfferCard(
          key: ValueKey('offer_card_${m.id}'),
          offer: offer,
          isSeller: offer.sellerId == meId,
          onView: () => onViewOffer(m),
          onDecline: () => onSetOfferStatus(m, OfferStatus.declined),
          onWithdraw: () => onSetOfferStatus(m, OfferStatus.withdrawn),
        );
      case MessageType.videoCall:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (text != null) ...[text, Gaps.v8],
            VideoCallCard(
              messageId: m.id,
              fromMe: isMe,
              declined: declinedCalls.contains(m.id),
              onJoin: () => showJoinCallDialog(context),
              onGuidelines: () => showCallGuidelines(context),
              onDecline: () => onDeclineCall(m, isMe),
            ),
          ],
        );
      case MessageType.system:
        return Text(
          m.text,
          style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: cs.onSurfaceVariant),
        );
    }
  }
}
