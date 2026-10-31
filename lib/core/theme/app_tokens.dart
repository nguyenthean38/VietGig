import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Màu ngữ nghĩa riêng của VietGig (ngoài ColorScheme của Material).
///
/// Đăng ký trong `ThemeData.extensions`, có bản sáng và tối. Trong widget dùng:
/// `context.tokens.success`, `context.tokens.vettedBg`, ...
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.brand,
    required this.brandStrong,
    required this.brandSoft,
    required this.onBrand,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.navy,
    required this.plum,
    required this.vettedBg,
    required this.vettedFg,
    required this.topRatedBg,
    required this.topRatedFg,
    required this.proTag,
    required this.badge,
    required this.starGold,
    required this.overlay,
  });

  /// Xanh thương hiệu (nút nhấn mạnh, chấm online, biểu đồ).
  final Color brand;

  /// Xanh đậm (header trang Tài khoản).
  final Color brandStrong;

  /// Nền xanh nhạt (ô minh hoạ, nhãn thành công).
  final Color brandSoft;
  final Color onBrand;

  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;

  /// Xanh dương: video call, nút kích hoạt, nhãn hội thoại.
  final Color info;
  final Color infoSoft;

  /// Nền banner xác nhận email.
  final Color navy;

  /// Nền banner mời bạn bè.
  final Color plum;

  final Color vettedBg;
  final Color vettedFg;
  final Color topRatedBg;
  final Color topRatedFg;
  final Color proTag;

  /// Chấm đỏ đếm số (thông báo, tin chưa đọc).
  final Color badge;
  final Color starGold;

  /// Lớp phủ tối trên ảnh.
  final Color overlay;

  static const light = AppTokens(
    brand: AppColors.brand,
    brandStrong: AppColors.brandDark,
    brandSoft: AppColors.brandSoft,
    onBrand: Colors.white,
    success: AppColors.brand,
    successSoft: AppColors.brandSoft,
    warning: AppColors.warning,
    warningSoft: AppColors.warningSoft,
    danger: AppColors.danger,
    dangerSoft: AppColors.dangerSoft,
    info: AppColors.blue,
    infoSoft: AppColors.blueSoft,
    navy: AppColors.navy,
    plum: AppColors.plum,
    vettedBg: AppColors.vettedBg,
    vettedFg: AppColors.vettedFg,
    topRatedBg: AppColors.topRatedBg,
    topRatedFg: AppColors.topRatedFg,
    proTag: Color(0xFF6E5BF5),
    badge: Color(0xFFE5508A),
    starGold: AppColors.starGold,
    overlay: Color(0x99000000),
  );

  static const dark = AppTokens(
    brand: Color(0xFF2ED186),
    brandStrong: Color(0xFF1F4D33),
    brandSoft: Color(0xFF16352A),
    onBrand: Colors.white,
    success: Color(0xFF2ED186),
    successSoft: Color(0xFF16352A),
    warning: Color(0xFFFFA940),
    warningSoft: Color(0xFF3A2A14),
    danger: Color(0xFFFF6B6F),
    dangerSoft: Color(0xFF3B1E20),
    info: Color(0xFF7B95FF),
    infoSoft: Color(0xFF1E2645),
    navy: Color(0xFF26306B),
    plum: Color(0xFF7E2A52),
    vettedBg: Color(0xFF2A2C55),
    vettedFg: Color(0xFFB4B8FF),
    topRatedBg: Color(0xFF3D2A17),
    topRatedFg: Color(0xFFFFB36B),
    proTag: Color(0xFF8B7BFF),
    badge: Color(0xFFFF6AA0),
    starGold: AppColors.starGold,
    overlay: Color(0xB3000000),
  );

  @override
  AppTokens copyWith({
    Color? brand,
    Color? brandStrong,
    Color? brandSoft,
    Color? onBrand,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? info,
    Color? infoSoft,
    Color? navy,
    Color? plum,
    Color? vettedBg,
    Color? vettedFg,
    Color? topRatedBg,
    Color? topRatedFg,
    Color? proTag,
    Color? badge,
    Color? starGold,
    Color? overlay,
  }) => AppTokens(
    brand: brand ?? this.brand,
    brandStrong: brandStrong ?? this.brandStrong,
    brandSoft: brandSoft ?? this.brandSoft,
    onBrand: onBrand ?? this.onBrand,
    success: success ?? this.success,
    successSoft: successSoft ?? this.successSoft,
    warning: warning ?? this.warning,
    warningSoft: warningSoft ?? this.warningSoft,
    danger: danger ?? this.danger,
    dangerSoft: dangerSoft ?? this.dangerSoft,
    info: info ?? this.info,
    infoSoft: infoSoft ?? this.infoSoft,
    navy: navy ?? this.navy,
    plum: plum ?? this.plum,
    vettedBg: vettedBg ?? this.vettedBg,
    vettedFg: vettedFg ?? this.vettedFg,
    topRatedBg: topRatedBg ?? this.topRatedBg,
    topRatedFg: topRatedFg ?? this.topRatedFg,
    proTag: proTag ?? this.proTag,
    badge: badge ?? this.badge,
    starGold: starGold ?? this.starGold,
    overlay: overlay ?? this.overlay,
  );

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppTokens(
      brand: l(brand, other.brand),
      brandStrong: l(brandStrong, other.brandStrong),
      brandSoft: l(brandSoft, other.brandSoft),
      onBrand: l(onBrand, other.onBrand),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      warning: l(warning, other.warning),
      warningSoft: l(warningSoft, other.warningSoft),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      info: l(info, other.info),
      infoSoft: l(infoSoft, other.infoSoft),
      navy: l(navy, other.navy),
      plum: l(plum, other.plum),
      vettedBg: l(vettedBg, other.vettedBg),
      vettedFg: l(vettedFg, other.vettedFg),
      topRatedBg: l(topRatedBg, other.topRatedBg),
      topRatedFg: l(topRatedFg, other.topRatedFg),
      proTag: l(proTag, other.proTag),
      badge: l(badge, other.badge),
      starGold: l(starGold, other.starGold),
      overlay: l(overlay, other.overlay),
    );
  }
}
