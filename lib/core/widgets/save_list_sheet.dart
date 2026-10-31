// Lưu dịch vụ / người bán vào danh sách yêu thích.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import '../l10n/l10n.dart';
import '../utils/app_images.dart';
import 'feedback.dart';
import 'visuals.dart';

/// Nút tim lưu gig – mở sheet chọn danh sách.
class SaveGigButton extends StatelessWidget {
  const SaveGigButton({super.key, required this.gigId, this.size = 22, this.circle = false});
  final String gigId;
  final double size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final saved = context.select<SavedController, bool>((c) => c.isGigSaved(gigId));
    final icon = Icon(
      saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      color: saved ? context.tokens.danger : (circle ? context.colors.onSurface : context.colors.outline),
      size: size,
    );
    return IconButton(
      key: ValueKey('save_$gigId'),
      tooltip: saved ? context.l10n.commonSaved : context.l10n.commonSave,
      onPressed: () => showSaveToListSheet(context, gigId: gigId),
      style: circle
          ? IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surface, fixedSize: const Size(40, 40))
          : null,
      icon: icon,
    );
  }
}

/// Bottom sheet "Danh sách đã lưu": chọn danh sách để lưu gig hoặc người bán.
Future<void> showSaveToListSheet(BuildContext context, {String? gigId, String? sellerId}) async {
  final session = context.read<SessionController>();
  if (!session.isSignedIn) {
    final go = await confirmDialog(
      context,
      title: context.l10n.saveSignInTitle,
      message: context.l10n.saveSignInMessage,
      confirmLabel: context.l10n.commonSignIn,
    );
    if (go && context.mounted) context.push('/auth/signin');
    return;
  }
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _SaveSheet(gigId: gigId, sellerId: sellerId),
  );
}

class _SaveSheet extends StatelessWidget {
  const _SaveSheet({this.gigId, this.sellerId});
  final String? gigId;
  final String? sellerId;

  Future<void> _create(BuildContext context) async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.saveCreateNewTitle),
        content: TextField(
          key: const ValueKey('new_list_name'),
          controller: ctrl,
          autofocus: true,
          maxLength: 40,
          decoration: InputDecoration(hintText: ctx.l10n.saveListNameHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.commonCancel)),
          FilledButton(
            key: const ValueKey('create_list_ok'),
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            style: FilledButton.styleFrom(minimumSize: const Size(80, 40)),
            child: Text(ctx.l10n.commonCreate),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty || !context.mounted) return;
    final saved = context.read<SavedController>();
    final l = await saved.createList(name);
    if (gigId != null) await saved.toggleGigInList(l.id, gigId!);
    if (sellerId != null) await saved.toggleSellerInList(l.id, sellerId!);
  }

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<SavedController>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(context.l10n.saveSheetTitle, style: Theme.of(context).textTheme.titleMedium)),
                TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.commonDone)),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                key: const ValueKey('create_new_list'),
                onPressed: () => _create(context),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  context.l10n.saveCreateNewLink,
                  style: const TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
            for (final l in saved.lists)
              ListTile(
                key: ValueKey('list_${l.id}'),
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: l.gigIds.isEmpty
                        ? Container(color: Theme.of(context).colorScheme.surfaceContainerHighest)
                        : PlaceholderImage(seed: l.gigIds.first.hashCode, image: AppImages.gigCover(l.gigIds.first)),
                  ),
                ),
                title: Text(l.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  l.isEmpty
                      ? context.l10n.saveListEmpty
                      : context.l10n.saveListCount(l.gigIds.length, l.sellerIds.length),
                ),
                trailing: Icon(
                  (gigId != null ? l.gigIds.contains(gigId) : l.sellerIds.contains(sellerId))
                      ? Icons.check_rounded
                      : null,
                ),
                onTap: () {
                  if (gigId != null) saved.toggleGigInList(l.id, gigId!);
                  if (sellerId != null) saved.toggleSellerInList(l.id, sellerId!);
                },
              ),
          ],
        ),
      ),
    );
  }
}
