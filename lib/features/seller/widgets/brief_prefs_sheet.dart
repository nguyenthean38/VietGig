import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Tuỳ chọn nhận brief (lưu cục bộ – chưa có API trong AccountRepository).
class BriefPrefs {
  const BriefPrefs({this.receive = true, this.minPrice});
  final bool receive;
  final int? minPrice;
}

/// Bottom sheet "Tuỳ chọn brief"; trả về [BriefPrefs] mới khi lưu.
class BriefPrefsSheet extends StatefulWidget {
  const BriefPrefsSheet({super.key, required this.initial});
  final BriefPrefs initial;

  @override
  State<BriefPrefsSheet> createState() => _BriefPrefsSheetState();
}

class _BriefPrefsSheetState extends State<BriefPrefsSheet> {
  late bool _receive = widget.initial.receive;
  late final TextEditingController _price = TextEditingController(text: widget.initial.minPrice?.toString() ?? '');

  int? get _priceValue => int.tryParse(_price.text.trim());
  bool get _changed => _receive != widget.initial.receive || _priceValue != widget.initial.minPrice;

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final muted = context.textTheme.bodySmall?.copyWith(height: 1.4);
    const heading = TextStyle(fontWeight: FontWeight.w700, fontSize: 15);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  child: Text(l.sellerBriefsPrefs, textAlign: TextAlign.center, style: context.textTheme.titleMedium),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: Insets.pageAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.sellerBriefsReceiveTitle, style: heading),
                  Gaps.v4,
                  Text(l.sellerBriefsReceiveDesc, style: muted),
                  Gaps.v8,
                  Row(
                    children: [
                      Expanded(
                        child: Text(l.sellerBriefsReceiveNew, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Switch(
                        key: const ValueKey('brief_receive_switch'),
                        value: _receive,
                        onChanged: (v) => setState(() => _receive = v),
                      ),
                    ],
                  ),
                  Gaps.v16,
                  Text(l.sellerBriefsPriceTitle, style: heading),
                  Gaps.v4,
                  Text(l.sellerBriefsPriceDesc, style: muted),
                  Gaps.v12,
                  Text(l.sellerBriefsMinPrice, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Gaps.v6,
                  TextField(
                    key: const ValueKey('brief_min_price'),
                    controller: _price,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(hintText: l.sellerBriefsPriceHint, suffixText: '₫'),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.md),
              child: PrimaryButton(
                key: const ValueKey('brief_prefs_save'),
                label: l.commonSave,
                onPressed: _changed
                    ? () => Navigator.pop(context, BriefPrefs(receive: _receive, minPrice: _priceValue))
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
