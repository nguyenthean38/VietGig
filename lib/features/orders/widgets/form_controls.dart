import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';

/// Nút radio tự vẽ (tránh API Radio.groupValue đã deprecated).
class RadioDot extends StatelessWidget {
  const RadioDot({super.key, required this.selected, this.size = 22});
  final bool selected;
  final double size;
  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? cs.onSurface : cs.outline, width: selected ? size * 0.3 : 1.5),
      ),
    );
  }
}

/// Ô vuông đánh dấu tự vẽ.
class CheckDot extends StatelessWidget {
  const CheckDot({super.key, required this.selected, this.size = 22});
  final bool selected;
  final double size;
  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? cs.onSurface : Colors.transparent,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: selected ? cs.onSurface : cs.outline, width: 1.5),
      ),
      child: selected ? Icon(Icons.check_rounded, size: size * 0.7, color: cs.surface) : null,
    );
  }
}

/// Một dòng lựa chọn radio.
class RadioRow extends StatelessWidget {
  const RadioRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
    this.subtitle,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          RadioDot(selected: selected),
          Gaps.h12,
          if (leading != null) ...[leading!, Gaps.h10],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 15)),
                if (subtitle != null) Text(subtitle!, style: context.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Bộ đếm −/+.
class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
    this.keyPrefix = 'qty',
  });
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    Widget btn(IconData i, bool enabled, VoidCallback f, String k) => InkResponse(
      key: ValueKey('${keyPrefix}_$k'),
      onTap: enabled ? f : null,
      radius: 20,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: cs.outline),
        ),
        child: Icon(i, size: 18, color: enabled ? cs.onSurface : cs.outline),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(Icons.remove_rounded, value > min, () => onChanged(value - 1), 'minus'),
        SizedBox(
          width: 40,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        btn(Icons.add_rounded, value < max, () => onChanged(value + 1), 'plus'),
      ],
    );
  }
}
