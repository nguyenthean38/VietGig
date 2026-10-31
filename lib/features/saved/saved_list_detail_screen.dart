import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/account.dart';
import '../../data/models/catalog.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import '../gig/widgets/discovery_widgets.dart';
import 'saved_lists_screen.dart';
import 'widgets/saved_list_parts.dart';

/// Chi tiết một danh sách đã lưu.
class SavedListDetailScreen extends StatefulWidget {
  const SavedListDetailScreen({super.key, required this.listId});
  final String listId;

  @override
  State<SavedListDetailScreen> createState() => _SavedListDetailScreenState();
}

class _SavedListDetailScreenState extends State<SavedListDetailScreen> {
  late final Future<Map<String, Gig>> _index;
  late final Future<Map<String, AppUser>> _users;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    final catalog = context.read<CatalogRepository>();
    _index = loadGigIndex(catalog);
    final ids = context.read<SavedController>().byId(widget.listId)?.sellerIds ?? const <String>[];
    _users = catalog.usersByIds(ids).then((l) => {for (final u in l) u.id: u});
  }

  Future<void> _menu(SavedList list) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Consumer<SavedController>(
          builder: (ctx, saved, _) {
            final current = saved.byId(list.id) ?? list;
            final l = ctx.l10n;
            final danger = ctx.tokens.danger;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  key: const ValueKey('list_public'),
                  secondary: const Icon(Icons.public_rounded),
                  title: Text(l.savedPublicTitle),
                  subtitle: Text(l.savedPublicSubtitle),
                  value: current.isPublic,
                  onChanged: (v) => saved.setPublic(current.id, v),
                ),
                ListTile(
                  key: const ValueKey('list_share'),
                  leading: const Icon(Icons.ios_share_rounded),
                  title: Text(l.savedShare),
                  onTap: () => Navigator.pop(ctx, 'share'),
                ),
                ListTile(
                  key: const ValueKey('list_rename'),
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(l.savedRename),
                  onTap: () => Navigator.pop(ctx, 'rename'),
                ),
                ListTile(
                  key: const ValueKey('list_delete'),
                  leading: Icon(Icons.delete_outline_rounded, color: danger),
                  title: Text(l.savedDeleteList, style: TextStyle(color: danger)),
                  onTap: () => Navigator.pop(ctx, 'delete'),
                ),
                Gaps.v8,
              ],
            );
          },
        ),
      ),
    );
    if (!mounted || action == null) return;
    final saved = context.read<SavedController>();
    final l = context.l10n;
    switch (action) {
      case 'share':
        final current = saved.byId(list.id);
        if (current != null && !current.isPublic) {
          final ok = await confirmDialog(
            context,
            title: l.savedMakePublicTitle,
            message: l.savedMakePublicMessage,
            confirmLabel: l.savedMakePublicConfirm,
          );
          if (!ok || !mounted) return;
          await saved.setPublic(list.id, true);
        }
        if (mounted) await copyLink(context, '/saved/${list.id}');
      case 'rename':
        final name = await askListName(context, title: l.savedRenameTitle, initial: list.name, ok: l.commonSave);
        if (name == null || !mounted) return;
        await saved.rename(list.id, name);
        if (mounted) showAppSnack(context, l.savedRenamed(name));
      case 'delete':
        final ok = await confirmDialog(
          context,
          title: l.savedDeleteTitle,
          message: l.savedDeleteMessage(list.name),
          confirmLabel: l.commonDelete,
          destructive: true,
        );
        if (!ok || !mounted) return;
        setState(() => _deleting = true);
        await saved.deleteList(list.id);
        if (!mounted) return;
        showAppSnack(context, l.savedListDeleted(list.name));
        context.canPop() ? context.pop() : context.go('/saved');
    }
  }

  Future<void> _removeGig(SavedList list, String gigId) async {
    final saved = context.read<SavedController>();
    await saved.toggleGigInList(list.id, gigId);
    if (!mounted) return;
    showAppSnack(
      context,
      context.l10n.savedRemovedFrom(list.name),
      onUndo: () => saved.toggleGigInList(list.id, gigId),
    );
  }

  Future<void> _removeSeller(SavedList list, String sellerId) async {
    final saved = context.read<SavedController>();
    await saved.toggleSellerInList(list.id, sellerId);
    if (!mounted) return;
    showAppSnack(
      context,
      context.l10n.savedRemovedFrom(list.name),
      onUndo: () => saved.toggleSellerInList(list.id, sellerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<SavedController>();
    final list = saved.byId(widget.listId);
    final l = context.l10n;
    if (list == null) {
      return Scaffold(
        appBar: const SimpleAppBar(title: ''),
        body: _deleting || !saved.loaded
            ? const Center(child: CircularProgressIndicator())
            : EmptyState(
                icon: Icons.playlist_remove_rounded,
                title: l.savedNotFoundTitle,
                message: l.savedNotFoundMessage,
                actionLabel: l.savedBackToLists,
                onAction: () => context.go('/saved'),
              ),
      );
    }
    final username = context.select<SessionController, String>((s) => s.user?.username ?? '');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: FutureBuilder<Map<String, Gig>>(
          future: _index,
          builder: (context, snap) {
            final index = snap.data;
            return Column(
              children: [
                SavedListHeader(list: list, index: index ?? const {}, username: username, onMenu: () => _menu(list)),
                TabBar(
                  tabAlignment: TabAlignment.fill,
                  tabs: [
                    Tab(key: const ValueKey('list_tab_gigs'), text: l.savedTabGigs(list.gigIds.length)),
                    Tab(key: const ValueKey('list_tab_sellers'), text: l.savedTabSellers(list.sellerIds.length)),
                  ],
                ),
                Expanded(
                  child: index == null
                      ? const Center(child: CircularProgressIndicator())
                      : TabBarView(
                          children: [
                            SavedListGigsTab(
                              gigs: [for (final id in list.gigIds) ?index[id]],
                              onRemove: (id) => _removeGig(list, id),
                            ),
                            _sellers(list),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sellers(SavedList list) => FutureBuilder<Map<String, AppUser>>(
    future: _users,
    builder: (context, snap) {
      if (!snap.hasData) return const Center(child: CircularProgressIndicator());
      return SavedListSellersTab(
        users: [for (final id in list.sellerIds) ?snap.data![id]],
        onRemove: (id) => _removeSeller(list, id),
      );
    },
  );
}
