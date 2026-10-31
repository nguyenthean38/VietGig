import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../state/app_controllers.dart';

/// Nhãn nhỏ màu xanh dương trong danh sách hội thoại.
class ChatLabelChip extends StatelessWidget {
  const ChatLabelChip(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: Space.xxs),
    decoration: BoxDecoration(color: context.tokens.info, borderRadius: BorderRadius.circular(Radii.xs)),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600),
    ),
  );
}

/// Bottom sheet "Chọn nhãn" (chọn nhiều). Trả về tập nhãn mới, null nếu huỷ.
Future<Set<String>?> showLabelPicker(BuildContext context, {required Set<String> initial}) =>
    showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _LabelPicker(initial: initial),
    );

class _LabelPicker extends StatefulWidget {
  const _LabelPicker({required this.initial});
  final Set<String> initial;
  @override
  State<_LabelPicker> createState() => _LabelPickerState();
}

class _LabelPickerState extends State<_LabelPicker> {
  late final Set<String> _selected = {...widget.initial};
  final _newCtrl = TextEditingController();
  bool _adding = false;

  @override
  void dispose() {
    _newCtrl.dispose();
    super.dispose();
  }

  Future<void> _addLabel() async {
    final name = _newCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _adding = false);
      return;
    }
    final inbox = context.read<InboxController>();
    if (!inbox.labels.contains(name)) await inbox.addLabel(name);
    if (!mounted) return;
    setState(() {
      _selected.add(name);
      _newCtrl.clear();
      _adding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final labels = context.watch<InboxController>().labels;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.sm, Space.xs),
                child: Row(
                  children: [
                    Expanded(child: Text(l.inboxLabelPickerTitle, style: context.textTheme.titleLarge)),
                    TextButton(
                      key: const ValueKey('labels_apply'),
                      onPressed: () => Navigator.pop(context, _selected),
                      child: Text(l.inboxApply, style: const TextStyle(decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final lb in labels)
                      InkWell(
                        key: ValueKey('label_$lb'),
                        onTap: () => setState(() => _selected.contains(lb) ? _selected.remove(lb) : _selected.add(lb)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.md),
                          child: Row(
                            children: [
                              Icon(
                                _selected.contains(lb)
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                size: 22,
                                color: _selected.contains(lb) ? cs.onSurface : cs.onSurfaceVariant,
                              ),
                              Gaps.h12,
                              Expanded(child: Text(lb, style: const TextStyle(fontSize: 15))),
                            ],
                          ),
                        ),
                      ),
                    if (_adding)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(Space.xl, Space.xs, Space.xl, Space.sm),
                        child: TextField(
                          key: const ValueKey('label_new_field'),
                          controller: _newCtrl,
                          autofocus: true,
                          maxLength: 30,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: l.inboxNewLabelHint,
                            counterText: '',
                            suffixIcon: IconButton(
                              key: const ValueKey('label_new_save'),
                              icon: const Icon(Icons.check_rounded),
                              onPressed: _addLabel,
                            ),
                          ),
                          onSubmitted: (_) => _addLabel(),
                        ),
                      )
                    else
                      ListTile(
                        key: const ValueKey('label_add'),
                        leading: Icon(Icons.add_rounded, color: cs.onSurfaceVariant),
                        title: Text(l.inboxAddLabel, style: TextStyle(color: cs.onSurfaceVariant)),
                        onTap: () => setState(() => _adding = true),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
