import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/app_controllers.dart';
import 'widgets/settings_widgets.dart';

/// Giao diện: Sáng / Tối / Hệ thống – đổi ngay lập tức.
class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsController>();
    final l = context.l10n;
    final options = [
      (mode: ThemeMode.light, label: l.profileThemeLight, key: 'light'),
      (mode: ThemeMode.dark, label: l.profileThemeDark, key: 'dark'),
      (mode: ThemeMode.system, label: l.profileThemeSystemShort, key: 'system'),
    ];
    return Scaffold(
      appBar: SimpleAppBar(title: l.profileAppearance),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.xxl, Space.lg, Space.xxl),
        children: [
          Row(
            children: [
              for (final o in options)
                Expanded(
                  child: InkWell(
                    key: ValueKey('theme_${o.key}'),
                    borderRadius: Radii.lgAll,
                    onTap: () => s.setThemeMode(o.mode),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Space.sm),
                      child: Column(
                        children: [
                          _PhonePreview(mode: o.mode, selected: s.themeMode == o.mode),
                          Gaps.v10,
                          Text(o.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Gaps.v8,
                          RadioDot(selected: s.themeMode == o.mode),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Gaps.v24,
          Text(l.profileAppearanceSystemNote, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Điện thoại thu nhỏ minh hoạ giao diện (luôn vẽ bản sáng/tối cố định, không theo theme hiện tại).
class _PhonePreview extends StatelessWidget {
  const _PhonePreview({required this.mode, required this.selected});
  final ThemeMode mode;
  final bool selected;

  Widget _screen(BuildContext context, bool dark) {
    // Màu minh hoạ lấy từ bảng màu sáng/tối cố định của app.
    final scheme = dark ? _darkPreview : _lightPreview;
    return Container(
      color: scheme.bg,
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: context.tokens.brand, shape: BoxShape.circle),
            ),
          ),
          Gaps.v6,
          for (var i = 0; i < 4; i++) ...[
            Container(height: 6, width: i.isEven ? double.infinity : 30, color: scheme.line),
            const SizedBox(height: 5),
          ],
          Row(
            children: [
              Expanded(child: Container(height: 16, color: scheme.line)),
              Gaps.h4,
              Expanded(child: Container(height: 16, color: scheme.line)),
            ],
          ),
        ],
      ),
    );
  }

  static final _lightScheme = AppTheme.light().colorScheme;
  static final _darkScheme = AppTheme.dark().colorScheme;
  static final _lightPreview = (bg: _lightScheme.surface, line: _lightScheme.outline);
  static final _darkPreview = (bg: _darkScheme.surface, line: _darkScheme.outline);

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Container(
      width: 74,
      height: 130,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: _darkScheme.surfaceContainerHighest,
        border: Border.all(color: selected ? context.tokens.brand : cs.outline, width: selected ? 2.5 : 1),
      ),
      child: ClipRRect(
        borderRadius: Radii.mdAll,
        child: mode == ThemeMode.system
            ? Stack(
                children: [
                  Positioned.fill(child: _screen(context, false)),
                  Positioned.fill(
                    child: ClipPath(clipper: _DiagonalClipper(), child: _screen(context, true)),
                  ),
                ],
              )
            : _screen(context, mode == ThemeMode.dark),
      ),
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
