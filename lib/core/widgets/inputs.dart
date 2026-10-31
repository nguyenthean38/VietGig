// Điều khiển nhập liệu & lựa chọn dùng chung.

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// Chip chọn được dạng viền (dùng cho bộ lọc, lựa chọn).
class SelectChip extends StatelessWidget {
  const SelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.showCheck = false,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? cs.onSurface : cs.outline, width: selected ? 1.6 : 1),
          color: cs.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCheck && selected) ...[const Icon(Icons.check_rounded, size: 16), const SizedBox(width: 4)],
            if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 6)],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.w500, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ô lựa chọn dạng thẻ có minh hoạ icon (dùng cho onboarding / sở thích).
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.description,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? cs.onSurface : cs.outline, width: selected ? 2 : 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: description == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(icon, size: 40, color: cs.onSurface),
                      Positioned(
                        right: -6,
                        bottom: -2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(color: context.tokens.brand, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(description!, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(icon, size: 40, color: cs.onSurface),
                ],
              ),
      ),
    );
  }
}

/// Bộ đếm ngược ngày/giờ/phút.
class CountdownBox extends StatelessWidget {
  const CountdownBox({super.key, required this.days, required this.hours, required this.minutes, this.dark = false});
  final int days;
  final int hours;
  final int minutes;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget cell(int v, String l) => Expanded(
      child: Column(
        children: [
          Text(
            '$v',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: dark ? Colors.white : cs.onSurface),
          ),
          const SizedBox(height: 2),
          Text(l, style: TextStyle(fontSize: 12, color: dark ? Colors.white70 : cs.onSurfaceVariant)),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: dark ? cs.onSurface : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          cell(days, context.l10n.timeDays),
          cell(hours, context.l10n.timeHours),
          cell(minutes, context.l10n.timeMinutes),
        ],
      ),
    );
  }
}

/// Ô nhập nhiều dòng có bộ đếm ký tự kiểu "0 / 2500".
class CountedTextField extends StatelessWidget {
  const CountedTextField({
    super.key,
    required this.controller,
    this.hint,
    this.maxLength = 2500,
    this.minLines = 5,
    this.maxLines = 10,
    this.onChanged,
    this.fieldKey,
  });
  final TextEditingController controller;
  final String? hint;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) => TextField(
    key: fieldKey,
    controller: controller,
    minLines: minLines,
    maxLines: maxLines,
    maxLength: maxLength,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hint,
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
    ),
  );
}

/// Đường kẻ "Hoặc".
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(context.l10n.commonOr, style: Theme.of(context).textTheme.bodySmall),
        ),
        const Expanded(child: Divider()),
      ],
    ),
  );
}
