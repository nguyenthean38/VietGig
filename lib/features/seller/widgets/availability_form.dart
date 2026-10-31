import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/account.dart';
import '../../../data/repositories/repositories.dart';
import '../../../state/session_controller.dart';

/// Mã lý do bận được lưu trong [Availability.reason].
const availabilityReasons = ['vacation', 'overloaded', 'other'];

/// Nhãn hiển thị của lý do bận (hỗ trợ cả giá trị tiếng Việt cũ).
String availabilityReasonLabel(AppLocalizations l, String reason) => switch (reason) {
  'vacation' || 'Đi nghỉ' => l.sellerAvailReasonVacation,
  'overloaded' || 'Quá tải công việc' => l.sellerAvailReasonOverloaded,
  'other' || 'Khác' => l.sellerAvailReasonOther,
  _ => reason,
};

String _normalizeReason(String? reason) => switch (reason) {
  'vacation' || 'Đi nghỉ' => 'vacation',
  'overloaded' || 'Quá tải công việc' => 'overloaded',
  _ => 'other',
};

enum AvailabilityFormResult { saved, deleted }

/// Bottom sheet đặt / sửa ngày bận. Trả về [AvailabilityFormResult] khi lưu hoặc xoá.
class AvailabilityForm extends StatefulWidget {
  const AvailabilityForm({super.key, this.initial});
  final Availability? initial;

  @override
  State<AvailabilityForm> createState() => _AvailabilityFormState();
}

class _AvailabilityFormState extends State<AvailabilityForm> {
  late DateTime _first;
  late DateTime _last;
  late String _reason;
  late bool _allowContact;
  late final TextEditingController _note;
  bool _saving = false;

  bool get _editing => widget.initial != null;
  bool get _valid => !_last.isBefore(_first);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final a = widget.initial;
    _first = a?.firstDay ?? today;
    _last = a?.lastDay ?? today;
    _reason = _normalizeReason(a?.reason);
    _allowContact = a?.allowContact ?? false;
    _note = TextEditingController(text: a?.note ?? '');
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pick(bool first) async {
    final l = context.l10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final current = first ? _first : _last;
    final picked = await showDatePicker(
      context: context,
      initialDate: current.isBefore(today) ? today : current,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      helpText: first ? l.sellerAvailPickFirst : l.sellerAvailPickLast,
      cancelText: l.commonCancel,
      confirmText: l.sellerAvailPick,
    );
    if (picked == null) return;
    setState(() {
      if (first) {
        _first = picked;
        if (_last.isBefore(_first)) _last = _first;
      } else {
        _last = picked;
      }
    });
  }

  Future<void> _save() async {
    if (!_valid) return;
    setState(() => _saving = true);
    final uid = context.read<SessionController>().userId;
    try {
      await context.read<AccountRepository>().saveAvailability(
        uid,
        Availability(
          firstDay: _first,
          lastDay: _last,
          reason: _reason,
          note: _note.text.trim(),
          allowContact: _allowContact,
        ),
      );
      if (mounted) Navigator.pop(context, AvailabilityFormResult.saved);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnack(context, context.l10n.sellerAvailSaveError('$e'), success: false);
    }
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l.sellerAvailDeleteTitle,
      message: l.sellerAvailDeleteMessage,
      confirmLabel: l.commonDelete,
      destructive: true,
    );
    if (!ok || !mounted) return;
    setState(() => _saving = true);
    await context.read<AccountRepository>().saveAvailability(context.read<SessionController>().userId, null);
    if (mounted) Navigator.pop(context, AvailabilityFormResult.deleted);
  }

  Widget _dateRow(String label, DateTime d, bool first) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Material(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(Space.sm),
          child: InkWell(
            key: ValueKey(first ? 'avail_first' : 'avail_last'),
            borderRadius: BorderRadius.circular(Space.sm),
            onTap: () => _pick(first),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
              child: Text(Fmt.date(d), style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cs = context.colors;
    final muted = context.textTheme.bodySmall?.copyWith(height: 1.4);
    const bold = TextStyle(fontWeight: FontWeight.w600);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xs, Space.sm, Space.lg, 0),
            child: Row(
              children: [
                IconButton(
                  tooltip: l.commonClose,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    _editing ? l.sellerAvailEditTitle : l.sellerAvailSet,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Divider(height: 1, color: cs.outlineVariant),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _dateRow(l.sellerAvailFirstDay, _first, true),
                  _dateRow(l.sellerAvailLastDay, _last, false),
                  if (!_valid)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.xs),
                      child: Text(
                        l.sellerAvailInvalidRange,
                        style: TextStyle(color: context.tokens.danger, fontSize: 13),
                      ),
                    ),
                  Gaps.v10,
                  Divider(color: cs.outlineVariant),
                  Row(
                    children: [
                      Expanded(child: Text(l.sellerAvailReason, style: bold)),
                      PopupMenuButton<String>(
                        key: const ValueKey('avail_reason'),
                        initialValue: _reason,
                        onSelected: (v) => setState(() => _reason = v),
                        itemBuilder: (_) => [
                          for (final r in availabilityReasons)
                            CheckedPopupMenuItem(
                              value: r,
                              checked: r == _reason,
                              child: Text(availabilityReasonLabel(l, r)),
                            ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            availabilityReasonLabel(l, _reason),
                            style: bold.copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.v10,
                  Text(l.sellerAvailNoteLabel, style: bold),
                  Gaps.v8,
                  CountedTextField(
                    fieldKey: const ValueKey('avail_note'),
                    controller: _note,
                    hint: l.sellerAvailNoteHint,
                    maxLength: 120,
                    minLines: 3,
                    maxLines: 4,
                  ),
                  Text(l.sellerAvailNoteHelp, style: muted),
                  Gaps.v16,
                  Row(
                    children: [
                      Expanded(child: Text(l.sellerAvailAllowContact, style: bold)),
                      Switch(
                        key: const ValueKey('avail_contact'),
                        value: _allowContact,
                        onChanged: (v) => setState(() => _allowContact = v),
                      ),
                    ],
                  ),
                  Text(_allowContact ? l.sellerAvailAllowContactOn : l.sellerAvailAllowContactOff, style: muted),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.md),
              child: Column(
                children: [
                  PrimaryButton(
                    key: const ValueKey('avail_confirm'),
                    label: _editing ? l.sellerAvailSaveChanges : l.sellerAvailConfirm,
                    loading: _saving,
                    onPressed: _valid ? _save : null,
                  ),
                  if (_editing) ...[
                    Gaps.v10,
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        key: const ValueKey('avail_delete'),
                        onPressed: _saving ? null : _delete,
                        child: Text(l.sellerAvailDelete),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
