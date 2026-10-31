import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

/// Các hàm định dạng hiển thị, theo ngôn ngữ đang chọn (vi mặc định, en).
class Fmt {
  Fmt._();

  /// Chuỗi ngôn ngữ hiện tại (app gọi [use] khi đổi ngôn ngữ). Mặc định tiếng Việt.
  static AppLocalizations _l = lookupAppLocalizations(const Locale('vi'));
  static NumberFormat _num = NumberFormat.decimalPattern('vi');

  static void use(AppLocalizations l) {
    if (l.localeName == _l.localeName) return;
    _l = l;
    _num = NumberFormat.decimalPattern(_isEn ? 'en' : 'vi');
  }

  static bool get _isEn => _l.localeName.startsWith('en');

  /// 250000 -> "250.000 ₫" (vi) / "250,000 ₫" (en)
  static String money(num value) => '${_num.format(value.round())} ₫';

  /// 250000 -> "250K", 1500000 -> "1,5Tr" (vi) / "1.5M" (en)
  static String moneyShort(num value) {
    if (value >= 1000000) {
      final v = value / 1000000;
      final txt = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1);
      return _isEn ? '${txt}M' : '${txt.replaceAll('.', ',')}Tr';
    }
    if (value >= 1000) return '${(value / 1000).round()}K';
    return value.round().toString();
  }

  /// 16690 -> "16.690" (vi) / "16,690" (en)
  static String number(num value) => _num.format(value);

  /// Số thập phân 1 chữ số: 4.3 -> "4,3" (vi) / "4.3" (en)
  static String decimal(num value, [int digits = 1]) {
    final t = value.toStringAsFixed(digits);
    return _isEn ? t : t.replaceAll('.', ',');
  }

  /// "12/06/2026"
  static String date(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

  /// "12 Th6, 2026" (vi) / "Jun 12, 2026" (en)
  static String dateMedium(DateTime d) => _isEn ? DateFormat.yMMMd('en').format(d) : '${d.day} Th${d.month}, ${d.year}';

  /// "Tháng 5/2018" (vi) / "May 2018" (en)
  static String monthYear(DateTime d) => _isEn ? DateFormat.yMMMM('en').format(d) : 'Tháng ${d.month}/${d.year}';

  /// "14:05"
  static String time(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';

  /// "14:05 12/06/2026"
  static String dateTime(DateTime d) => '${time(d)} ${date(d)}';

  /// Hiển thị giờ trong danh sách hội thoại: hôm nay -> giờ, trong tuần -> thứ, còn lại -> ngày.
  static String chatStamp(DateTime d, {DateTime? now}) {
    now ??= DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return time(d);
    if (diff == 1) return _l.timeYesterday;
    if (diff < 7) return weekday(d);
    return date(d);
  }

  static String weekday(DateTime d) => switch (d.weekday) {
    1 => _l.weekday1,
    2 => _l.weekday2,
    3 => _l.weekday3,
    4 => _l.weekday4,
    5 => _l.weekday5,
    6 => _l.weekday6,
    _ => _l.weekday7,
  };

  /// "3 phút trước", "2 giờ trước", "5 ngày trước", "2 tháng trước"
  static String ago(DateTime d, {DateTime? now}) {
    now ??= DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 1) return _l.timeJustNow;
    if (diff.inHours < 1) return _l.timeMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return _l.timeHoursAgo(diff.inHours);
    if (diff.inDays < 30) return _l.timeDaysAgo(diff.inDays);
    if (diff.inDays < 365) return _l.timeMonthsAgo(diff.inDays ~/ 30);
    return _l.timeYearsAgo(diff.inDays ~/ 365);
  }

  /// Đếm ngược: (ngày, giờ, phút) còn lại tới [target].
  static ({int days, int hours, int minutes}) countdown(DateTime target, {DateTime? now}) {
    now ??= DateTime.now();
    var diff = target.difference(now);
    if (diff.isNegative) diff = Duration.zero;
    return (days: diff.inDays, hours: diff.inHours % 24, minutes: diff.inMinutes % 60);
  }

  static String days(int n) => _l.timeNDays(n);

  static String _two(int n) => n.toString().padLeft(2, '0');
}
