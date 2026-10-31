import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Hộp thoại nhập một giá trị; [validate] trả về chuỗi lỗi hoặc null nếu hợp lệ.
/// [confirmLabel] mặc định là "Áp dụng" (đã dịch).
Future<String?> showTextInputDialog(
  BuildContext context, {
  required String title,
  required String? Function(String value) validate,
  String initial = '',
  String? hint,
  String? helper,
  String? suffix,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  TextCapitalization textCapitalization = TextCapitalization.none,
  String? confirmLabel,
  Key? fieldKey,
  Key? confirmKey,
}) => showDialog<String>(
  context: context,
  builder: (ctx) => _TextInputDialog(
    title: title,
    validate: validate,
    initial: initial,
    hint: hint,
    helper: helper,
    suffix: suffix,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    textCapitalization: textCapitalization,
    confirmLabel: confirmLabel ?? ctx.l10n.ordersApply,
    fieldKey: fieldKey,
    confirmKey: confirmKey,
  ),
);

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({
    required this.title,
    required this.validate,
    required this.initial,
    this.hint,
    this.helper,
    this.suffix,
    this.keyboardType,
    this.inputFormatters,
    required this.textCapitalization,
    required this.confirmLabel,
    this.fieldKey,
    this.confirmKey,
  });
  final String title;
  final String? Function(String) validate;
  final String initial;
  final String? hint;
  final String? helper;
  final String? suffix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final String confirmLabel;
  final Key? fieldKey;
  final Key? confirmKey;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final _ctrl = TextEditingController(text: widget.initial);
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _ok() {
    final v = _ctrl.text.trim();
    final e = widget.validate(v);
    if (e != null) {
      setState(() => _error = e);
    } else {
      Navigator.pop(context, v);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title, style: context.textTheme.titleMedium),
    content: TextField(
      key: widget.fieldKey,
      controller: _ctrl,
      autofocus: true,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      onSubmitted: (_) => _ok(),
      decoration: InputDecoration(
        hintText: widget.hint,
        helperText: widget.helper,
        suffixText: widget.suffix,
        errorText: _error,
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.commonCancel)),
      FilledButton(key: widget.confirmKey, onPressed: _ok, child: Text(widget.confirmLabel)),
    ],
  );
}

/// Bottom sheet nhập lời nhắn nhiều dòng (tối thiểu [minLength] ký tự).
/// [submitLabel] mặc định là "Gửi" (đã dịch).
Future<String?> showMessageSheet(
  BuildContext context, {
  required String title,
  String? subtitle,
  String? hint,
  int minLength = 5,
  String? submitLabel,
  Key? fieldKey,
  Key? submitKey,
}) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  builder: (ctx) => _MessageSheet(
    title: title,
    subtitle: subtitle,
    hint: hint,
    minLength: minLength,
    submitLabel: submitLabel ?? ctx.l10n.ordersSend,
    fieldKey: fieldKey,
    submitKey: submitKey,
  ),
);

class _MessageSheet extends StatefulWidget {
  const _MessageSheet({
    required this.title,
    this.subtitle,
    this.hint,
    required this.minLength,
    required this.submitLabel,
    this.fieldKey,
    this.submitKey,
  });
  final String title;
  final String? subtitle;
  final String? hint;
  final int minLength;
  final String submitLabel;
  final Key? fieldKey;
  final Key? submitKey;

  @override
  State<_MessageSheet> createState() => _MessageSheetState();
}

class _MessageSheetState extends State<_MessageSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: context.textTheme.titleMedium),
            if (widget.subtitle != null) ...[Gaps.v6, Text(widget.subtitle!, style: context.textTheme.bodySmall)],
            Gaps.v12,
            CountedTextField(
              fieldKey: widget.fieldKey,
              controller: _ctrl,
              maxLength: 1000,
              minLines: 4,
              maxLines: 6,
              hint: widget.hint,
              onChanged: (_) => setState(() {}),
            ),
            Gaps.v8,
            PrimaryButton(
              key: widget.submitKey,
              label: widget.submitLabel,
              onPressed: _ctrl.text.trim().length < widget.minLength
                  ? null
                  : () => Navigator.pop(context, _ctrl.text.trim()),
            ),
          ],
        ),
      ),
    ),
  );
}
