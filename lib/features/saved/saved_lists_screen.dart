import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/account.dart';
import '../../data/models/catalog.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import '../gig/widgets/discovery_widgets.dart';

/// Hộp thoại nhập tên danh sách (tạo mới / đổi tên). Trả về tên đã trim hoặc null.
/// [title] mặc định "Tạo danh sách mới", [ok] mặc định "Tạo".
Future<String?> askListName(BuildContext context, {String? title, String initial = '', String? ok}) async {
  final l = context.l10n;
  final ctrl = TextEditingController(text: initial);
  final formKey = GlobalKey<FormState>();
  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title ?? l.saveCreateNewTitle),
      content: Form(
        key: formKey,
        child: TextFormField(
          key: const ValueKey('list_name_field'),
          controller: ctrl,
          autofocus: true,
          maxLength: 40,
          decoration: InputDecoration(hintText: l.saveListNameHint),
          validator: (v) => (v ?? '').trim().isEmpty ? l.savedNameRequired : null,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.commonCancel)),
        FilledButton(
          key: const ValueKey('list_name_ok'),
          style: FilledButton.styleFrom(minimumSize: const Size(80, 40)),
          onPressed: () {
            if (formKey.currentState!.validate()) Navigator.pop(ctx, ctrl.text.trim());
          },
          child: Text(ok ?? l.commonCreate),
        ),
      ],
    ),
  );
  // Không dispose ngay: hộp thoại còn đang chạy hiệu ứng đóng.
  return name;
}

/// "Danh sách của tôi".
class SavedListsScreen extends StatefulWidget {
  const SavedListsScreen({super.key});

  @override
  State<SavedListsScreen> createState() => _SavedListsScreenState();
}

class _SavedListsScreenState extends State<SavedListsScreen> {
  late final Future<Map<String, Gig>> _index;

  @override
  void initState() {
    super.initState();
    _index = loadGigIndex(context.read<CatalogRepository>());
  }

  Future<void> _create() async {
    final saved = context.read<SavedController>();
    final name = await askListName(context);
    if (name == null || !mounted) return;
    if (saved.lists.any((l) => l.name.toLowerCase() == name.toLowerCase())) {
      showAppSnack(context, context.l10n.savedListExists(name), success: false);
      return;
    }
    await saved.createList(name);
    if (mounted) showAppSnack(context, context.l10n.savedListCreated(name));
  }

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<SavedController>();
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(
        title: l.savedListsTitle,
        actions: [TextButton(key: const ValueKey('create_list'), onPressed: _create, child: Text(l.savedCreateList))],
      ),
      body: !saved.loaded
          ? const Center(child: CircularProgressIndicator())
          : saved.lists.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border_rounded,
              title: l.savedListsEmptyTitle,
              message: l.savedListsEmptyMessage,
              actionLabel: l.savedExploreVietGig,
              onAction: () => context.go('/search'),
            )
          : FutureBuilder<Map<String, Gig>>(
              future: _index,
              builder: (context, snap) {
                final index = snap.data ?? const <String, Gig>{};
                return RefreshIndicator(
                  onRefresh: () => saved.load(context.read<SessionController>().userId),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, 96),
                    itemCount: saved.lists.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 18),
                    itemBuilder: (context, i) => _ListCard(list: saved.lists[i], index: index),
                  ),
                );
              },
            ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({required this.list, required this.index});
  final SavedList list;
  final Map<String, Gig> index;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    return InkWell(
      key: ValueKey('saved_list_${list.id}'),
      borderRadius: Radii.lgAll,
      onTap: () => context.push('/saved/${list.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 170,
            child: ListCollage(list: list, index: index),
          ),
          Gaps.v8,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    Gaps.v2,
                    Text(
                      list.isEmpty ? l.saveListEmpty : l.saveListCount(list.gigIds.length, list.sellerIds.length),
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                list.isPublic ? Icons.public_rounded : Icons.lock_outline_rounded,
                size: 18,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Ảnh ghép 3 ô (1 lớn + 2 nhỏ) cho danh sách.
class ListCollage extends StatelessWidget {
  const ListCollage({super.key, required this.list, required this.index});
  final SavedList list;
  final Map<String, Gig> index;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final gigs = [for (final id in list.gigIds) ?index[id]];
    Widget cell(int i) => i < gigs.length
        ? PlaceholderImage(seed: gigs[i].imageSeeds.first, label: gigs[i].imageLabel)
        : i == 0 && list.sellerIds.isNotEmpty
        ? Container(
            color: cs.surfaceContainerHighest,
            child: Icon(Icons.people_alt_outlined, size: 40, color: cs.onSurfaceVariant),
          )
        : Container(color: cs.surfaceContainerHighest);
    return ClipRRect(
      borderRadius: Radii.lgAll,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 2, child: cell(0)),
          const SizedBox(width: 3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: cell(1)),
                const SizedBox(height: 3),
                Expanded(child: cell(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
