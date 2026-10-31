import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/app_controllers.dart';
import 'widgets/settings_widgets.dart';

/// Chọn tiền tệ hiển thị (giá vẫn thanh toán bằng VND).
class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  static const currencies = [
    (value: 'VND - ₫', flag: '🇻🇳'),
    (value: 'USD - \$', flag: '🇺🇸'),
    (value: 'EUR - €', flag: '🇪🇺'),
    (value: 'GBP - £', flag: '🇬🇧'),
    (value: 'JPY - ¥', flag: '🇯🇵'),
    (value: 'KRW - ₩', flag: '🇰🇷'),
    (value: 'CNY - ¥', flag: '🇨🇳'),
    (value: 'SGD - S\$', flag: '🇸🇬'),
    (value: 'THB - ฿', flag: '🇹🇭'),
    (value: 'AUD - A\$', flag: '🇦🇺'),
    (value: 'CAD - C\$', flag: '🇨🇦'),
  ];

  /// Tên tiền tệ đã dịch theo mã ISO (3 ký tự đầu của [value]).
  static String nameOf(AppLocalizations l, String code) => switch (code) {
    'VND' => l.profileCurrencyVnd,
    'USD' => l.profileCurrencyUsd,
    'EUR' => l.profileCurrencyEur,
    'GBP' => l.profileCurrencyGbp,
    'JPY' => l.profileCurrencyJpy,
    'KRW' => l.profileCurrencyKrw,
    'CNY' => l.profileCurrencyCny,
    'SGD' => l.profileCurrencySgd,
    'THB' => l.profileCurrencyThb,
    'AUD' => l.profileCurrencyAud,
    'CAD' => l.profileCurrencyCad,
    _ => code,
  };

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsController>();
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(title: l.profileCurrency),
      body: ListView(
        padding: const EdgeInsets.only(bottom: Space.xxl),
        children: [
          for (final c in currencies)
            TickRow(
              key: ValueKey('cur_${c.value.substring(0, 3)}'),
              leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
              title: nameOf(l, c.value.substring(0, 3)),
              subtitle: c.value,
              selected: s.currency == c.value,
              onTap: () {
                s.setCurrency(c.value);
                showAppSnack(context, l.profileCurrencyChanged(c.value));
              },
            ),
        ],
      ),
    );
  }
}
