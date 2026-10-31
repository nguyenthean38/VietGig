import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/chat.dart';
import '../../../data/models/user.dart';
import '../../../state/app_controllers.dart';
import 'label_picker.dart';

/// Các thao tác trên hội thoại dùng chung cho Hộp thư và màn Chat.
class ConversationActions {
  ConversationActions._();

  static Future<void> toggleArchive(BuildContext context, Conversation c) async {
    final inbox = context.read<InboxController>();
    final archive = !c.archived;
    await inbox.update(c.copyWith(archived: archive));
    if (!context.mounted) return;
    final l = context.l10n;
    showAppSnack(context, archive ? l.inboxArchivedOne : l.inboxUnarchivedOne, onUndo: () => inbox.update(c));
  }

  static Future<void> toggleStar(BuildContext context, Conversation c) async {
    final inbox = context.read<InboxController>();
    await inbox.update(c.copyWith(starred: !c.starred));
    if (!context.mounted) return;
    showAppSnack(context, c.starred ? context.l10n.inboxUnstarred : context.l10n.inboxStarredOne);
  }

  static Future<void> toggleRead(BuildContext context, Conversation c) async {
    final inbox = context.read<InboxController>();
    await inbox.update(c.copyWith(unread: c.unread > 0 ? 0 : 1));
    if (!context.mounted) return;
    showAppSnack(context, c.unread > 0 ? context.l10n.inboxMarkedRead : context.l10n.inboxMarkedUnread);
  }

  static Future<void> changeLabels(BuildContext context, Conversation c) async {
    final inbox = context.read<InboxController>();
    final result = await showLabelPicker(context, initial: c.labels);
    if (result == null) return;
    final latest = inbox.byId(c.id) ?? c;
    await inbox.update(latest.copyWith(labels: result));
    if (!context.mounted) return;
    showAppSnack(context, context.l10n.inboxLabelsUpdated);
  }

  static Future<void> toggleBlock(BuildContext context, Conversation c) async {
    final inbox = context.read<InboxController>();
    final l = context.l10n;
    if (!c.blocked) {
      final ok = await confirmDialog(
        context,
        title: l.inboxBlockTitle,
        message: l.inboxBlockMessage,
        confirmLabel: l.inboxBlock,
        destructive: true,
      );
      if (!ok) return;
    }
    await inbox.update(c.copyWith(blocked: !c.blocked));
    if (!context.mounted) return;
    showAppSnack(context, c.blocked ? l.inboxUserUnblocked : l.inboxUserBlocked, onUndo: () => inbox.update(c));
  }

  /// Trả về true nếu đã xoá.
  static Future<bool> delete(BuildContext context, Conversation c) async {
    final inbox = context.read<InboxController>();
    final l = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l.inboxDeleteTitle,
      message: l.inboxDeleteMessage,
      confirmLabel: l.commonDelete,
      destructive: true,
    );
    if (!ok) return false;
    await inbox.delete(c.id);
    if (context.mounted) showAppSnack(context, l.inboxDeletedOne);
    return true;
  }

  static Future<void> report(BuildContext context) async {
    final l = context.l10n;
    final reason = await showActionSheet<String>(
      context,
      title: l.inboxReportTitle,
      actions: [
        SheetAction(label: l.inboxReportFraud, value: 'fraud', icon: Icons.gpp_maybe_outlined),
        SheetAction(label: l.inboxReportOffsite, value: 'offsite', icon: Icons.payments_outlined),
        SheetAction(label: l.inboxReportAbuse, value: 'abuse', icon: Icons.sentiment_very_dissatisfied_outlined),
        SheetAction(label: l.inboxReportSpam, value: 'spam', icon: Icons.report_gmailerrorred_outlined),
      ],
    );
    if (reason == null || !context.mounted) return;
    showAppSnack(context, l.inboxReportThanks);
  }

  /// Bottom sheet "Thêm" của một hội thoại.
  static Future<void> showMore(BuildContext context, Conversation c, AppUser? user) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => _MoreSheet(conversation: c, user: user),
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case 'read':
        await toggleRead(context, c);
      case 'star':
        await toggleStar(context, c);
      case 'labels':
        await changeLabels(context, c);
      case 'archive':
        await toggleArchive(context, c);
      case 'block':
        await toggleBlock(context, c);
      case 'delete':
        await delete(context, c);
    }
  }
}

class _MoreSheet extends StatelessWidget {
  const _MoreSheet({required this.conversation, required this.user});
  final Conversation conversation;
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final danger = context.tokens.danger;
    final l = context.l10n;
    final c = conversation;
    final name = user?.displayName ?? l.inboxUser;
    Widget item(String value, IconData icon, String label, {bool destructive = false}) => ListTile(
      key: ValueKey('more_$value'),
      leading: Icon(icon, color: destructive ? danger : cs.onSurface),
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w500, color: destructive ? danger : null),
      ),
      onTap: () => Navigator.pop(context, value),
    );
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: Radii.mdAll),
              child: Row(
                children: [
                  UserAvatar(user: user, name: name, size: 32),
                  Gaps.h10,
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            item(
              'read',
              c.unread > 0 ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined,
              c.unread > 0 ? l.inboxMarkRead : l.inboxMarkUnread,
            ),
            item(
              'star',
              c.starred ? Icons.star_rounded : Icons.star_border_rounded,
              c.starred ? l.inboxUnstar : l.inboxStar,
            ),
            item('labels', Icons.sell_outlined, l.inboxChangeLabels),
            item('archive', Icons.inventory_2_outlined, c.archived ? l.inboxUnarchive : l.inboxArchive),
            item('block', Icons.block_rounded, c.blocked ? l.inboxUnblock : l.inboxBlock),
            item('delete', Icons.delete_outline_rounded, l.commonDelete, destructive: true),
            Gaps.v8,
          ],
        ),
      ),
    );
  }
}
