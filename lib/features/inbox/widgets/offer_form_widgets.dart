import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';

/// Giá tối thiểu của báo giá / cột mốc.
const kMinOfferPrice = 50000;

/// Số cột mốc tối đa.
const kMaxMilestones = 6;

/// Lấy số tiền từ chuỗi nhập (bỏ ký tự không phải số).
int? parseMoney(String s) => int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), ''));

/// Khoảng cách giữa các phần của form báo giá.
class OfferGap extends StatelessWidget {
  const OfferGap({super.key});
  @override
  Widget build(BuildContext context) => Gaps.v24;
}

/// Tiêu đề một phần, có thể kèm liên kết hành động (VD "Đổi").
class OfferSectionHeader extends StatelessWidget {
  const OfferSectionHeader(this.title, {super.key, this.action, this.onAction, this.actionKey});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final Key? actionKey;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(child: Text(title, style: context.textTheme.titleMedium)),
        if (action != null)
          InkWell(
            key: actionKey,
            onTap: onAction,
            child: Text(
              action!,
              style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    ),
  );
}

/// Dòng báo lỗi dưới trường nhập (ẩn khi [error] null).
class OfferErrorText extends StatelessWidget {
  const OfferErrorText(this.error, {super.key});
  final String? error;
  @override
  Widget build(BuildContext context) => error == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(error!, style: TextStyle(color: context.tokens.danger, fontSize: 12.5)),
        );
}

/// Một dòng thiết lập: nhãn (+ phụ đề) bên trái, giá trị/nút bên phải.
class OfferFieldRow extends StatelessWidget {
  const OfferFieldRow({super.key, required this.label, this.value, this.subtitle, this.onTap, this.trailing});
  final String label;
  final String? value;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Space.md),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    Gaps.v2,
                    Text(subtitle!, style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant)),
                  ],
                ],
              ),
            ),
            Gaps.h8,
            if (trailing != null)
              trailing!
            else ...[
              if (value != null && value!.isNotEmpty)
                Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}

/// Ô nhập tiền (chỉ số, căn phải, hậu tố ₫).
class MoneyField extends StatelessWidget {
  const MoneyField({super.key, required this.fieldKey, required this.controller});
  final Key fieldKey;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: TextField(
      key: fieldKey,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
      textAlign: TextAlign.right,
      decoration: const InputDecoration(
        isDense: true,
        hintText: '0',
        suffixText: '₫',
        contentPadding: EdgeInsets.symmetric(horizontal: Space.md, vertical: 10),
      ),
    ),
  );
}
