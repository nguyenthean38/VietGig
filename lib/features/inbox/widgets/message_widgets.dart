import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/chat.dart';
import '../../../data/models/user.dart';

export 'offer_card.dart';

/// "Hôm nay" / "Hôm qua" / "8 Th6, 2026".
String dayLabel(DateTime d, AppLocalizations l) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(DateTime(d.year, d.month, d.day)).inDays;
  if (diff == 0) return l.inboxToday;
  if (diff == 1) return l.timeYesterday;
  return Fmt.dateMedium(d);
}

/// Nội dung dạng chữ của tin nhắn (dùng để sao chép, chuyển tiếp, trích dẫn).
String messagePlainText(AppLocalizations l, ChatMessage m) => switch (m.type) {
  MessageType.file => l.inboxPlainFile(m.fileName ?? ''),
  MessageType.offer => l.inboxPlainOffer(m.offer?.title ?? '', Fmt.money(m.offer?.totalPrice ?? 0)),
  MessageType.videoCall => m.text.isEmpty ? l.inboxVideoInvite : m.text,
  _ => m.text,
};

/// Phân cách ngày giữa các tin nhắn.
class DateSeparator extends StatelessWidget {
  const DateSeparator(this.date, {super.key});
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: 5),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(Space.xl),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Text(
            dayLabel(date, context.l10n),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

/// Banner an toàn đầu cuộc trò chuyện.
class SafetyBanner extends StatelessWidget {
  const SafetyBanner({super.key, required this.onLearnMore});
  final VoidCallback onLearnMore;
  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.xxl, Space.lg, Space.xxl, Space.xs),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user_outlined, size: 16, color: context.tokens.brand),
              Gaps.h6,
              Flexible(
                child: Text(
                  context.l10n.inboxSafetyTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: cs.onSurface),
                ),
              ),
            ],
          ),
          Gaps.v4,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: context.l10n.inboxSafetyBanner),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: onLearnMore,
                    child: Text(
                      context.l10n.inboxLearnMore,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }
}

/// Thẻ tệp đính kèm.
class FileCard extends StatelessWidget {
  const FileCard({super.key, required this.name, this.size, this.onTap});
  final String name;
  final String? size;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final ext = name.contains('.') ? name.split('.').last.toUpperCase() : 'FILE';
    final isImage = ['JPG', 'JPEG', 'PNG', 'HEIC'].contains(ext);
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 110,
            color: cs.surfaceContainerHighest,
            alignment: Alignment.center,
            child: isImage
                ? PlaceholderImage(seed: name.hashCode, icon: Icons.image_outlined, height: 110)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 38,
                        color: ext == 'PDF' ? context.tokens.danger : cs.onSurfaceVariant,
                      ),
                      Gaps.v4,
                      Text(
                        ext,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13.5),
                  ),
                ),
                if (size != null) ...[Gaps.h8, Text(size!, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant))],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Tin nhắn này liên quan tới:" + thẻ gig.
class RelatedGigCard extends StatelessWidget {
  const RelatedGigCard({super.key, required this.gig, this.sellerName, this.onTap, this.onClose});
  final Gig gig;
  final String? sellerName;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.l10n.inboxRelatedTo, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
        Gaps.v6,
        AppCard(
          padding: const EdgeInsets.all(10),
          onTap: onTap,
          child: Row(
            children: [
              PlaceholderImage(
                seed: gig.imageSeeds.isEmpty ? 0 : gig.imageSeeds.first,
                label: gig.imageLabel,
                width: 56,
                height: 42,
                radius: Radii.sm,
              ),
              Gaps.h10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gig.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, height: 1.3),
                    ),
                    if (sellerName != null)
                      Text(sellerName!, style: TextStyle(fontSize: 11.5, color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  key: const ValueKey('related_gig_close'),
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: onClose,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Một tin nhắn dạng danh sách: avatar + tên + giờ, nội dung bên dưới.
class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.isMe,
    required this.content,
    this.showHeader = true,
    this.onLongPress,
  });

  final ChatMessage message;
  final AppUser? sender;
  final bool isMe;
  final Widget content;
  final bool showHeader;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final name = isMe ? context.l10n.inboxYou : (sender?.displayName ?? context.l10n.inboxUser);
    return InkWell(
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.fromLTRB(Space.lg, showHeader ? Space.md : Space.xs, Space.lg, Space.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 32,
              child: showHeader ? UserAvatar(user: sender, name: name, size: 32) : null,
            ),
            Gaps.h10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.xs, top: 1),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                          Gaps.h6,
                          Text(Fmt.time(message.sentAt), style: TextStyle(fontSize: 11.5, color: cs.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  if (message.replyTo != null && message.replyTo!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        border: Border(left: BorderSide(color: context.tokens.brand, width: 3)),
                        borderRadius: BorderRadius.circular(Radii.xs),
                      ),
                      child: Text(
                        message.replyTo!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant),
                      ),
                    ),
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
