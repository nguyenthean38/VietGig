import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../state/app_controllers.dart';
import 'widgets/settings_widgets.dart';

/// Chọn ngôn ngữ hiển thị: Tiếng Việt / English – đổi giao diện ngay khi chọn.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const languages = [(code: 'vi', flag: '🇻🇳'), (code: 'en', flag: '🇺🇸')];

  static String nameOf(AppLocalizations l, String code) => code == 'en' ? l.languageEnglish : l.languageVietnamese;

  void _select(BuildContext context, SettingsController s, String code) {
    if (s.locale.languageCode == code) return;
    s.setLocale(Locale(code));
    // Thông báo bằng chính ngôn ngữ vừa chọn (context hiện tại vẫn giữ bản dịch cũ tới frame sau).
    final l = lookupAppLocalizations(Locale(code));
    showAppSnack(context, l.profileLanguageChanged(nameOf(l, code)));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsController>();
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(title: l.profileLanguage),
      body: ListView(
        children: [
          for (final lang in languages)
            TickRow(
              key: ValueKey('lang_${lang.code}'),
              leading: Text(lang.flag, style: const TextStyle(fontSize: 22)),
              title: nameOf(l, lang.code),
              selected: s.locale.languageCode == lang.code,
              onTap: () => _select(context, s, lang.code),
            ),
        ],
      ),
    );
  }
}
