import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/chat.dart';
import '../../../state/app_controllers.dart';

/// Bottom sheet danh sách "Trả lời nhanh". Trả về nội dung mẫu được chọn.
Future<String?> showQuickResponses(BuildContext context) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const _QuickResponseSheet(),
);

class _QuickResponseSheet extends StatefulWidget {
  const _QuickResponseSheet();
  @override
  State<_QuickResponseSheet> createState() => _QuickResponseSheetState();
}

class _QuickResponseSheetState extends State<_QuickResponseSheet> {
  late Future<List<QuickResponse>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<InboxController>().quickResponses();
  }

  Future<void> _addNew() async {
    final saved = await showNewQuickResponse(context);
    if (saved == null || !mounted) return;
    setState(() => _future = context.read<InboxController>().quickResponses());
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.sm, Space.xs),
              child: Row(
                children: [
                  Expanded(child: Text(l.inboxQuickReplies, style: context.textTheme.titleLarge)),
                  TextButton.icon(
                    key: const ValueKey('quick_add'),
                    onPressed: _addNew,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(l.inboxAddNew),
                  ),
                ],
              ),
            ),
            Flexible(
              child: AsyncView<List<QuickResponse>>(
                future: _future,
                builder: (context, list) => list.isEmpty
                    ? EmptyState(
                        icon: Icons.bolt_rounded,
                        title: l.inboxQuickEmptyTitle,
                        message: l.inboxQuickEmptyMessage,
                        compact: true,
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: Space.md),
                        itemCount: list.length,
                        separatorBuilder: (_, _) => Divider(height: 1, indent: Space.xl, color: cs.outlineVariant),
                        itemBuilder: (context, i) {
                          final q = list[i];
                          return ListTile(
                            key: ValueKey('quick_${q.id}'),
                            contentPadding: const EdgeInsets.symmetric(horizontal: Space.xl),
                            title: Text(q.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            subtitle: Text(q.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                            onTap: () => Navigator.pop(context, q.body),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sheet "Trả lời nhanh mới": Tên + Nội dung. Trả về mẫu đã lưu.
Future<QuickResponse?> showNewQuickResponse(BuildContext context) => showModalBottomSheet<QuickResponse>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => const _NewQuickResponse(),
);

class _NewQuickResponse extends StatefulWidget {
  const _NewQuickResponse();
  @override
  State<_NewQuickResponse> createState() => _NewQuickResponseState();
}

class _NewQuickResponseState extends State<_NewQuickResponse> {
  final _name = TextEditingController();
  final _body = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(_refresh);
    _body.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _name.dispose();
    _body.dispose();
    super.dispose();
  }

  bool get _valid => _name.text.trim().isNotEmpty && _body.text.trim().isNotEmpty;

  Future<void> _save() async {
    setState(() => _saving = true);
    final r = await context.read<InboxController>().saveQuickResponse(
      QuickResponse(
        id: 'q_${DateTime.now().microsecondsSinceEpoch}',
        title: _name.text.trim(),
        body: _body.text.trim(),
      ),
    );
    if (!mounted) return;
    showAppSnack(context, context.l10n.inboxQuickSaved);
    Navigator.pop(context, r);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xs, Space.sm, Space.lg, 0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                Expanded(
                  child: Text(l.inboxQuickNewTitle, textAlign: TextAlign.center, style: context.textTheme.titleMedium),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.inboxQuickName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  Gaps.v8,
                  TextField(
                    key: const ValueKey('quick_name'),
                    controller: _name,
                    maxLength: 40,
                    decoration: InputDecoration(hintText: l.inboxQuickNameHint),
                  ),
                  Gaps.v12,
                  Text(l.inboxQuickBody, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  Gaps.v8,
                  CountedTextField(
                    fieldKey: const ValueKey('quick_body'),
                    controller: _body,
                    hint: l.inboxQuickBodyHint,
                    maxLength: 2500,
                    minLines: 5,
                    maxLines: 8,
                  ),
                  Gaps.v4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, size: 16, color: cs.onSurfaceVariant),
                      Gaps.h6,
                      Expanded(
                        child: Text(
                          l.inboxQuickTip('{username}'),
                          style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Space.xl, Space.xs, Space.xl, Space.md),
              child: PrimaryButton(
                key: const ValueKey('quick_save'),
                label: l.commonSave,
                loading: _saving,
                onPressed: _valid ? _save : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
