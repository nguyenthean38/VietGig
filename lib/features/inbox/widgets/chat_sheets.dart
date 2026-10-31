import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/chat.dart';
import '../../../data/models/order.dart';
import '../../../state/app_controllers.dart';
import 'conversation_actions.dart';

/// Sheet đính kèm. Trả về một trong: album, camera, file, offer, quick, video.
Future<String?> showAttachSheet(BuildContext context, {required bool seller}) => showModalBottomSheet<String>(
  context: context,
  showDragHandle: true,
  builder: (ctx) {
    final l = ctx.l10n;
    Widget item(String value, IconData icon, String label) => InkWell(
      key: ValueKey('attach_$value'),
      onTap: () => Navigator.pop(ctx, value),
      borderRadius: Radii.lgAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: Space.xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: ctx.colors.onSurface),
            Gaps.v6,
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.2),
            ),
          ],
        ),
      ),
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.md),
        child: GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisExtent: 100),
          children: [
            item('album', Icons.photo_library_outlined, l.inboxAttachAlbum),
            item('camera', Icons.photo_camera_outlined, l.inboxAttachCamera),
            item('file', Icons.attach_file_rounded, l.inboxAttachFile),
            if (seller) ...[
              item('offer', Icons.request_quote_outlined, l.inboxAttachOffer),
              item('quick', Icons.bolt_rounded, l.inboxQuickReplies),
              item('video', Icons.videocam_outlined, l.inboxAttachVideo),
            ],
          ],
        ),
      ),
    );
  },
);

/// Hộp thoại trước khi tham gia cuộc gọi video. Hiện snack nếu đồng ý.
Future<void> showJoinCallDialog(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final l = ctx.l10n;
      return AlertDialog(
        icon: Icon(Icons.shield_outlined, size: 40, color: ctx.tokens.brand),
        title: Text(l.inboxSafetyTitle, textAlign: TextAlign.center),
        content: Text(l.inboxCallDialogMessage, textAlign: TextAlign.center),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                key: const ValueKey('video_open'),
                style: FilledButton.styleFrom(backgroundColor: ctx.tokens.info, foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.inboxOpenCall),
              ),
              Gaps.v8,
              OutlinedButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.commonCancel)),
            ],
          ),
        ],
      );
    },
  );
  if (ok == true && context.mounted) showAppSnack(context, context.l10n.inboxCallConnecting);
}

/// Hướng dẫn gọi video.
Future<void> showCallGuidelines(BuildContext context) => infoDialog(
  context,
  title: context.l10n.inboxCallGuidelinesTitle,
  message: context.l10n.inboxCallGuidelinesMessage,
  ok: context.l10n.inboxGotIt,
);

/// Hộp thoại "Giữ an toàn trên VietGig".
Future<void> showSafetyInfo(BuildContext context) => infoDialog(
  context,
  title: context.l10n.inboxSafetyDialogTitle,
  message: context.l10n.inboxSafetyDialogMessage,
  ok: context.l10n.inboxGotIt,
);

/// Menu "Tuỳ chọn" của màn chat (gắn sao, lưu trữ, chặn, báo cáo).
Future<void> showChatMenu(BuildContext context, Conversation c) async {
  final l = context.l10n;
  final action = await showActionSheet<String>(
    context,
    actions: [
      SheetAction(
        label: c.starred ? l.inboxUnstar : l.inboxStar,
        value: 'star',
        icon: c.starred ? Icons.star_rounded : Icons.star_border_rounded,
      ),
      SheetAction(
        label: c.archived ? l.inboxUnarchive : l.inboxArchive,
        value: 'archive',
        icon: Icons.inventory_2_outlined,
      ),
      SheetAction(label: c.blocked ? l.inboxUnblock : l.inboxBlock, value: 'block', icon: Icons.block_rounded),
      SheetAction(label: l.inboxReport, value: 'report', icon: Icons.flag_outlined, destructive: true),
    ],
  );
  if (action == null || !context.mounted) return;
  switch (action) {
    case 'star':
      await ConversationActions.toggleStar(context, c);
    case 'archive':
      await ConversationActions.toggleArchive(context, c);
    case 'block':
      await ConversationActions.toggleBlock(context, c);
    case 'report':
      await ConversationActions.report(context);
  }
}

/// Sheet thao tác khi nhấn giữ tin nhắn. Trả về reply / forward / copy.
Future<String?> showMessageActions(BuildContext context, {required bool canCopy}) {
  final l = context.l10n;
  return showActionSheet<String>(
    context,
    actions: [
      SheetAction(label: l.inboxReply, value: 'reply', icon: Icons.reply_rounded),
      SheetAction(label: l.inboxForward, value: 'forward', icon: Icons.forward_rounded),
      if (canCopy) SheetAction(label: l.inboxCopy, value: 'copy', icon: Icons.copy_rounded),
    ],
  );
}

/// Hỏi xác nhận rút lại (người bán) hoặc từ chối (người mua) báo giá.
Future<bool> confirmOfferStatus(BuildContext context, {required bool withdraw}) {
  final l = context.l10n;
  return confirmDialog(
    context,
    title: withdraw ? l.inboxWithdrawOfferTitle : l.inboxDeclineOfferTitle,
    message: withdraw ? l.inboxWithdrawOfferMessage : l.inboxDeclineOfferMessage,
    confirmLabel: withdraw ? l.inboxWithdraw : l.inboxDecline,
    destructive: true,
  );
}

/// Gửi bản sao của [m] (nội dung [plain]) tới các hội thoại [ids].
Future<void> forwardMessage(
  BuildContext context, {
  required ChatMessage m,
  required String plain,
  required Set<String> ids,
  required String senderId,
}) async {
  final inbox = context.read<InboxController>();
  final isFile = m.type == MessageType.file;
  for (final cid in ids) {
    await inbox.send(
      ChatMessage(
        id: '',
        conversationId: cid,
        senderId: senderId,
        sentAt: DateTime.now(),
        type: isFile ? MessageType.file : MessageType.text,
        text: isFile ? '' : plain,
        fileName: m.fileName,
        fileSize: m.fileSize,
      ),
    );
  }
  if (context.mounted) showAppSnack(context, context.l10n.inboxForwarded(ids.length));
}

/// Sheet "Đơn hàng đang thực hiện" với đối tác [partnerId] (tên hiển thị [name]).
Future<void> showActiveOrdersSheet(BuildContext context, {required String? partnerId, required String name}) {
  final ctrl = context.read<OrdersController>();
  final orders = [
    ...ctrl.buying,
    ...ctrl.selling,
  ].where((o) => o.status.isActive && (o.sellerId == partnerId || o.buyerId == partnerId)).toList();
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) {
      final l = ctx.l10n;
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.7),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.sm),
                child: Text(l.inboxActiveOrdersTitle, style: ctx.textTheme.titleLarge),
              ),
              if (orders.isEmpty)
                EmptyState(
                  icon: Icons.assignment_outlined,
                  title: l.inboxNoOrdersTitle,
                  message: l.inboxNoOrdersMessage(name),
                  compact: true,
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(Space.lg, Space.xs, Space.lg, Space.lg),
                    itemCount: orders.length,
                    separatorBuilder: (_, _) => Gaps.v10,
                    itemBuilder: (_, i) {
                      final o = orders[i];
                      return AppCard(
                        key: ValueKey('chat_order_${o.id}'),
                        padding: Insets.cardSm,
                        onTap: () {
                          Navigator.pop(ctx);
                          context.push('/orders/${o.id}');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GigThumbRow(
                              seed: o.gigImageSeed,
                              title: o.gigTitle,
                              subtitle: l.inboxOrderDue(Fmt.date(o.dueDate), Fmt.money(o.subtotal)),
                            ),
                            Gaps.v8,
                            OrderStatusPill(o.status),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
