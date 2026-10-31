import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';

/// Định dạng số thẻ thành nhóm 4 chữ số.
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 19 ? digits.substring(0, 19) : digits;
    final b = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i > 0 && i % 4 == 0) b.write(' ');
      b.write(capped[i]);
    }
    final t = b.toString();
    return TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
  }
}

/// Định dạng MM/YY.
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var d = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (d.length > 4) d = d.substring(0, 4);
    final deleting = newValue.text.length < oldValue.text.length;
    final t = d.length > 2 || (d.length == 2 && !deleting) ? '${d.substring(0, 2)}/${d.substring(2)}' : d;
    return TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
  }
}

/// Kiểm tra Luhn.
bool luhnValid(String digits) {
  if (digits.length < 13 || digits.length > 19) return false;
  var sum = 0;
  var alt = false;
  for (var i = digits.length - 1; i >= 0; i--) {
    var n = digits.codeUnitAt(i) - 48;
    if (alt) {
      n *= 2;
      if (n > 9) n -= 9;
    }
    sum += n;
    alt = !alt;
  }
  return sum % 10 == 0;
}

/// Modal "Thêm thẻ mới". Trả về `true` khi thêm thành công.
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _number = TextEditingController();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _exp = TextEditingController();
  final _cvv = TextEditingController();
  bool _saving = false;
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_number, _first, _last, _exp, _cvv]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_number, _first, _last, _exp, _cvv]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _digits => _number.text.replaceAll(' ', '');

  String? get _numberError {
    if (_digits.isEmpty) return null;
    if (_digits.length < 13) return null;
    return luhnValid(_digits) ? null : context.l10n.ordersAddCardInvalidNumber;
  }

  String? get _expError {
    final t = _exp.text;
    if (t.length < 5) return null;
    final m = int.tryParse(t.substring(0, 2)) ?? 0;
    final y = 2000 + (int.tryParse(t.substring(3)) ?? 0);
    if (m < 1 || m > 12) return context.l10n.ordersAddCardInvalidMonth;
    final now = DateTime.now();
    if (DateTime(y, m + 1).isBefore(DateTime(now.year, now.month + 1))) return context.l10n.ordersAddCardExpired;
    return null;
  }

  bool get _valid =>
      luhnValid(_digits) &&
      _first.text.trim().isNotEmpty &&
      _last.text.trim().isNotEmpty &&
      _exp.text.length == 5 &&
      _expError == null &&
      RegExp(r'^\d{3,4}$').hasMatch(_cvv.text);

  String get _brand {
    if (_digits.startsWith('4')) return 'VISA';
    if (RegExp(r'^5[1-5]').hasMatch(_digits) || RegExp(r'^2[2-7]').hasMatch(_digits)) return 'MASTERCARD';
    if (RegExp(r'^3[47]').hasMatch(_digits)) return 'AMEX';
    if (_digits.startsWith('35')) return 'JCB';
    return '';
  }

  Future<void> _submit() async {
    setState(() => _touched = true);
    if (!_valid) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    context.pop(true);
  }

  InputDecoration _dec(String label, {String? error, Widget? suffix}) =>
      InputDecoration(labelText: label, errorText: error, suffixIcon: suffix);

  @override
  Widget build(BuildContext context) {
    final masked = _digits.padRight(16, '•');
    final groups = [for (var i = 0; i < 16; i += 4) masked.substring(i, i + 4)].join('  ');
    final l = context.l10n;
    final cs = context.colors;
    final darkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: SimpleAppBar(title: l.ordersAddCardTitle, close: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
        children: [
          // Thẻ xem trước
          AspectRatio(
            aspectRatio: 1.7,
            child: Container(
              padding: const EdgeInsets.all(Space.xl),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Space.lg),
                gradient: LinearGradient(
                  colors: [darkTheme ? cs.surfaceContainerHighest : cs.onSurface, context.tokens.brandStrong],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sim_card_outlined, color: Colors.white70, size: 30),
                      const Spacer(),
                      Text(
                        _brand,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                    ],
                  ),
                  const Spacer(),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(groups, style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1.5)),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_first.text} ${_last.text}'.trim().isEmpty
                              ? l.ordersAddCardHolderPlaceholder
                              : '${_last.text} ${_first.text}'.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      Text(
                        _exp.text.isEmpty ? 'MM/YY' : _exp.text,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Gaps.v20,
          TextField(
            key: const ValueKey('card_number'),
            controller: _number,
            keyboardType: TextInputType.number,
            inputFormatters: [_CardNumberFormatter()],
            decoration: _dec(
              l.ordersAddCardNumber,
              error: _numberError ?? (_touched && !luhnValid(_digits) ? l.ordersAddCardNumberRequired : null),
              suffix: const Icon(Icons.credit_card_rounded),
            ),
          ),
          Gaps.v12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('card_last'),
                  controller: _last,
                  textCapitalization: TextCapitalization.words,
                  decoration: _dec(
                    l.ordersAddCardLastName,
                    error: _touched && _last.text.trim().isEmpty ? l.ordersAddCardRequired : null,
                  ),
                ),
              ),
              Gaps.h12,
              Expanded(
                child: TextField(
                  key: const ValueKey('card_first'),
                  controller: _first,
                  textCapitalization: TextCapitalization.words,
                  decoration: _dec(
                    l.ordersAddCardFirstName,
                    error: _touched && _first.text.trim().isEmpty ? l.ordersAddCardRequired : null,
                  ),
                ),
              ),
            ],
          ),
          Gaps.v12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('card_exp'),
                  controller: _exp,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_ExpiryFormatter()],
                  decoration: _dec('MM/YY', error: _expError),
                ),
              ),
              Gaps.h12,
              Expanded(
                child: TextField(
                  key: const ValueKey('card_cvv'),
                  controller: _cvv,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                  decoration: _dec(
                    'CVV',
                    suffix: Tooltip(
                      message: l.ordersAddCardCvvHelp,
                      triggerMode: TooltipTriggerMode.tap,
                      child: Icon(Icons.help_outline_rounded, size: 20, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gaps.v16,
          Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 16, color: cs.onSurfaceVariant),
              Gaps.h6,
              Expanded(child: Text(l.ordersAddCardSecure, style: context.textTheme.bodySmall)),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          key: const ValueKey('card_submit'),
          icon: Icons.lock_rounded,
          label: l.ordersAddCardPay,
          loading: _saving,
          onPressed: _valid ? _submit : null,
        ),
      ),
    );
  }
}
