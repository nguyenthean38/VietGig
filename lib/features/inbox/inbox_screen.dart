import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/chat.dart';
import '../../state/app_controllers.dart';
import 'widgets/conversation_tile.dart';
import 'widgets/inbox_common.dart';
import 'widgets/inbox_edit_bar.dart';
import 'widgets/swipe_action_tile.dart';

/// Tab Hộp thư: danh sách hội thoại, bộ lọc, vuốt để thao tác, chế độ Sửa.
class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> with ParticipantCache {
  InboxFilter _filter = InboxFilter.all;
  bool _editing = false;
  final Set<String> _selected = {};
  final _openTile = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _openTile.dispose();
    super.dispose();
  }

  void _toggleEdit() => setState(() {
    _editing = !_editing;
    _selected.clear();
    _openTile.value = null;
  });

  void _exitEdit() => setState(() {
    _selected.clear();
    _editing = false;
  });

  Future<void> _pickFilter() async {
    final f = await showInboxFilterSheet(context, current: _filter);
    if (f == null || !mounted) return;
    setState(() {
      _filter = f;
      _selected.clear();
    });
  }

  List<Conversation> _selectedConversations(InboxController inbox) => [for (final id in _selected) ?inbox.byId(id)];

  // ------------------------------------------------ thao tác hàng loạt
  Future<void> _bulkArchive() async {
    final inbox = context.read<InboxController>();
    final list = _selectedConversations(inbox);
    if (list.isEmpty) return;
    final archive = !list.every((c) => c.archived);
    await inbox.updateMany([for (final c in list) c.copyWith(archived: archive)]);
    if (!mounted) return;
    _exitEdit();
    final l = context.l10n;
    showAppSnack(
      context,
      archive ? l.inboxBulkArchived(list.length) : l.inboxBulkUnarchived(list.length),
      onUndo: () => inbox.updateMany(list),
    );
  }

  Future<void> _bulkRead() async {
    final inbox = context.read<InboxController>();
    final list = _selectedConversations(inbox);
    if (list.isEmpty) return;
    final markRead = list.any((c) => c.unread > 0);
    await inbox.updateMany([for (final c in list) c.copyWith(unread: markRead ? 0 : 1)]);
    if (!mounted) return;
    _exitEdit();
    showAppSnack(context, markRead ? context.l10n.inboxMarkedRead : context.l10n.inboxMarkedUnread);
  }

  Future<void> _bulkMore() async {
    final inbox = context.read<InboxController>();
    final l = context.l10n;
    final list = _selectedConversations(inbox);
    if (list.isEmpty) return;
    final n = list.length;
    final allStarred = list.every((c) => c.starred);
    final action = await showActionSheet<String>(
      context,
      title: l.inboxConversationCount(n),
      actions: [
        SheetAction(
          label: allStarred ? l.inboxUnstar : l.inboxStar,
          value: 'star',
          icon: allStarred ? Icons.star_rounded : Icons.star_border_rounded,
        ),
        SheetAction(label: l.inboxChangeLabels, value: 'labels', icon: Icons.sell_outlined),
        SheetAction(label: l.inboxBlock, value: 'block', icon: Icons.block_rounded),
        SheetAction(label: l.commonDelete, value: 'delete', icon: Icons.delete_outline_rounded, destructive: true),
      ],
    );
    if (action == null || !mounted) return;
    switch (action) {
      case 'star':
        await inbox.updateMany([for (final c in list) c.copyWith(starred: !allStarred)]);
        if (mounted) showAppSnack(context, allStarred ? l.inboxUnstarred : l.inboxBulkStarred(n));
      case 'labels':
        final common = list.map((c) => c.labels).reduce((a, b) => a.intersection(b));
        final labels = await showLabelPicker(context, initial: common);
        if (labels == null) return;
        await inbox.updateMany([for (final c in list) (inbox.byId(c.id) ?? c).copyWith(labels: labels)]);
        if (mounted) showAppSnack(context, l.inboxLabelsUpdated);
      case 'block':
        final ok = await confirmDialog(
          context,
          title: l.inboxBlockManyTitle(n),
          message: l.inboxBlockManyMessage,
          confirmLabel: l.inboxBlock,
          destructive: true,
        );
        if (!ok) return;
        await inbox.updateMany([for (final c in list) c.copyWith(blocked: true)]);
        if (mounted) showAppSnack(context, l.inboxUserBlocked, onUndo: () => inbox.updateMany(list));
      case 'delete':
        final ok = await confirmDialog(
          context,
          title: l.inboxDeleteTitle,
          message: l.inboxDeleteManyMessage(n),
          confirmLabel: l.commonDelete,
          destructive: true,
        );
        if (!ok) return;
        for (final c in list) {
          await inbox.delete(c.id);
        }
        if (mounted) showAppSnack(context, l.inboxBulkDeleted(n));
    }
    if (mounted) _exitEdit();
  }

  // ------------------------------------------------ build
  Widget _buildEmpty() {
    final l = context.l10n;
    final noData = _filter == InboxFilter.all;
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight - Space.navBarClearance),
          child: Center(
            child: noData
                ? EmptyState(
                    icon: Icons.mark_email_unread_outlined,
                    title: l.inboxEmptyTitle,
                    message: l.inboxEmptyMessage,
                  )
                : EmptyState(
                    key: const ValueKey('inbox_filter_empty'),
                    icon: Icons.filter_alt_off_outlined,
                    title: l.inboxFilterEmptyTitle,
                    message: l.inboxFilterEmptyMessage(_filter.title(l)),
                    actionLabel: l.inboxClearFilter,
                    onAction: () => setState(() => _filter = InboxFilter.all),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Conversation c) {
    final l = context.l10n;
    final t = context.tokens;
    final user = users[c.participantId];
    final tile = ConversationTile(
      conversation: c,
      user: user,
      editing: _editing,
      selected: _selected.contains(c.id),
      onTap: () {
        if (_editing) {
          setState(() => _selected.contains(c.id) ? _selected.remove(c.id) : _selected.add(c.id));
        } else {
          context.push('/chat/${c.id}');
        }
      },
      onLongPress: _editing
          ? null
          : () => setState(() {
              _editing = true;
              _selected
                ..clear()
                ..add(c.id);
            }),
    );
    return SwipeActionTile(
      key: ValueKey('conv_${c.id}'),
      id: c.id,
      enabled: !_editing,
      openNotifier: _openTile,
      actions: [
        SwipeAction(
          key: ValueKey('swipe_archive_${c.id}'),
          label: c.archived ? l.inboxUnarchive : l.inboxArchive,
          icon: c.archived ? Icons.unarchive_outlined : Icons.inventory_2_outlined,
          color: t.proTag,
          onTap: () => ConversationActions.toggleArchive(context, c),
        ),
        SwipeAction(
          key: ValueKey('swipe_star_${c.id}'),
          label: c.starred ? l.inboxUnstarShort : l.inboxStar,
          icon: c.starred ? Icons.star_rounded : Icons.star_border_rounded,
          color: t.starGold,
          onTap: () => ConversationActions.toggleStar(context, c),
        ),
        SwipeAction(
          key: ValueKey('swipe_more_${c.id}'),
          label: l.inboxMore,
          icon: Icons.more_horiz_rounded,
          color: context.colors.onSurfaceVariant,
          onTap: () => ConversationActions.showMore(context, c, user),
        ),
      ],
      child: tile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final inbox = context.watch<InboxController>();
    final l = context.l10n;
    final all = inbox.conversations;
    ensureUsers(all.map((c) => c.participantId));
    final items = all.where(_filter.matches).toList();
    _selected.removeWhere((id) => !items.any((c) => c.id == id));
    final cs = context.colors;

    final title = _editing
        ? (_selected.isEmpty ? l.inboxSelectTitle : l.inboxSelectedCount(_selected.length))
        : _filter.title(l);

    final Widget body;
    if (inbox.loading && all.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (items.isEmpty) {
      body = _buildEmpty();
    } else {
      body = ListView.separated(
        key: const ValueKey('inbox_list'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: _editing ? 180 : Space.navBarClearance),
        itemCount: items.length,
        separatorBuilder: (_, _) => Divider(height: 1, indent: 76, color: cs.outlineVariant),
        itemBuilder: (context, i) => _buildItem(items[i]),
      );
    }

    final selectedList = _selectedConversations(inbox);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        leadingWidth: 76,
        leading: Padding(
          padding: const EdgeInsets.only(left: Space.sm),
          child: Center(
            child: InboxPillButton(
              key: const ValueKey('inbox_edit'),
              label: _editing ? l.commonDone : l.inboxEdit,
              onTap: _toggleEdit,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(title, key: const ValueKey('inbox_title')),
        actions: [
          IconButton(
            key: const ValueKey('inbox_filter'),
            tooltip: l.inboxFilterTitle,
            onPressed: _pickFilter,
            icon: Badge(
              isLabelVisible: _filter != InboxFilter.all,
              backgroundColor: context.tokens.brand,
              smallSize: 8,
              child: const Icon(Icons.tune_rounded),
            ),
          ),
          Gaps.h8,
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: RefreshIndicator(color: context.tokens.brand, onRefresh: inbox.refresh, child: body),
          ),
          if (_editing)
            Positioned(
              left: 0,
              right: 0,
              bottom: 92 + MediaQuery.paddingOf(context).bottom,
              child: InboxEditBar(
                hasSelection: _selected.isNotEmpty,
                allArchived: _selected.isNotEmpty && selectedList.every((c) => c.archived),
                anyUnread: selectedList.any((c) => c.unread > 0),
                onArchive: _bulkArchive,
                onRead: _bulkRead,
                onMore: _bulkMore,
              ),
            ),
        ],
      ),
    );
  }
}
