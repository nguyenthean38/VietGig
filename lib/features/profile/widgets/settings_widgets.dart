import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';

/// Tiêu đề nhóm trong trang cài đặt.
class GroupTitle extends StatelessWidget {
  const GroupTitle(this.text, {super.key, this.padding = const EdgeInsets.fromLTRB(Space.lg, 26, Space.lg, 6)});
  final String text;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Text(text, style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
  );
}

/// Chấm radio tự vẽ (tránh API Radio.groupValue bị deprecated).
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
        border: Border.all(color: selected ? cs.onSurface : cs.onSurfaceVariant, width: selected ? 6.5 : 1.6),
      ),
    );
  }
}

/// Dòng lựa chọn có radio (danh sách lý do, lựa chọn đơn).
class RadioRow extends StatelessWidget {
  const RadioRow({super.key, required this.label, required this.selected, required this.onTap, this.subtitle});
  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
      child: Row(
        children: [
          RadioDot(selected: selected),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 15, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                if (subtitle != null) Text(subtitle!, style: context.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Thẻ lựa chọn có radio, tiêu đề và mô tả (huỷ kích hoạt / xoá tài khoản).
class RadioCard extends StatelessWidget {
  const RadioCard({
    super.key,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: Radii.lgAll,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: Radii.lgAll,
          border: Border.all(color: selected ? cs.onSurface : cs.outline, width: selected ? 1.8 : 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioDot(selected: selected),
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Gaps.v4,
                  Text(description, style: context.textTheme.bodySmall?.copyWith(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dòng có công tắc.
class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.switchKey,
  });
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Key? switchKey;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.fromLTRB(Space.lg, 10, 10, 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[Gaps.v2, Text(subtitle!, style: context.textTheme.bodySmall)],
                ],
              ),
            ),
            Switch(key: switchKey, value: value, onChanged: onChanged, activeTrackColor: context.tokens.brand),
          ],
        ),
      ),
    );
  }
}

/// Giá trị hiện tại hiển thị bên phải dòng menu.
class TrailingValue extends StatelessWidget {
  const TrailingValue(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 140),
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
      ],
    );
  }
}

/// Dòng lựa chọn có dấu tick ở cuối (ngôn ngữ, tiền tệ).
class TickRow extends StatelessWidget {
  const TickRow({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.leading,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 14)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 15, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                  if (subtitle != null) Text(subtitle!, style: context.textTheme.bodySmall),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_rounded, color: context.tokens.brand),
          ],
        ),
      ),
    );
  }
}

/// Nhãn hiển thị của chế độ giao diện (Sáng / Tối / Theo hệ thống).
String themeModeLabel(AppLocalizations l, ThemeMode m) => switch (m) {
  ThemeMode.light => l.profileThemeLight,
  ThemeMode.dark => l.profileThemeDark,
  ThemeMode.system => l.profileThemeSystem,
};
