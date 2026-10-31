import 'package:flutter/material.dart';

/// Bảng màu chung của app (lấy cảm hứng từ thiết kế mẫu).
class AppColors {
  AppColors._();

  static const brand = Color(0xFF1DBF73); // xanh lá thương hiệu
  static const brandDark = Color(0xFF2E6B45); // nền header hồ sơ
  static const brandSoft = Color(0xFFE8F8F0);

  static const ink = Color(0xFF222325); // chữ chính / nút đen
  static const inkSoft = Color(0xFF404145);
  static const muted = Color(0xFF74767E); // chữ phụ
  static const subtle = Color(0xFFB5B6BA);

  static const background = Color(0xFFF7F7F7);
  static const surface = Colors.white;
  static const border = Color(0xFFE4E5E7);
  static const divider = Color(0xFFEFEFF0);
  static const fill = Color(0xFFF2F2F3); // nền ô nhập

  static const navy = Color(0xFF2F3E8F); // banner xác nhận email
  static const blue = Color(0xFF4A6CF7); // nút kích hoạt / video call
  static const blueSoft = Color(0xFFE8EEFF);
  static const plum = Color(0xFFA3376A); // banner mời bạn bè
  static const danger = Color(0xFFE5484D);
  static const dangerSoft = Color(0xFFFDECEC);
  static const warning = Color(0xFFE8890C);
  static const warningSoft = Color(0xFFFFF1E0);
  static const star = Color(0xFF222325);
  static const starGold = Color(0xFFFFB33E);

  static const vettedBg = Color(0xFFE1E3FB);
  static const vettedFg = Color(0xFF4A4FCF);
  static const topRatedBg = Color(0xFFFFEDD9);
  static const topRatedFg = Color(0xFFC2601B);

  // Dark theme
  static const darkBackground = Color(0xFF0F0F10);
  static const darkSurface = Color(0xFF1B1B1D);
  static const darkBorder = Color(0xFF2C2C2F);
  static const darkFill = Color(0xFF242427);

  /// Bảng màu dùng để sinh ảnh minh hoạ / avatar giả.
  static const palette = <Color>[
    Color(0xFF3D5A1E),
    Color(0xFFF2D94E),
    Color(0xFF1E3A5F),
    Color(0xFFE9A6A6),
    Color(0xFF7B4FD6),
    Color(0xFF14A38B),
    Color(0xFFF07C3A),
    Color(0xFF2B2B2B),
    Color(0xFFD94F7C),
    Color(0xFF4F8EF7),
    Color(0xFF8A6D3B),
    Color(0xFF5BC0EB),
  ];

  static Color fromSeed(int seed) => palette[seed.abs() % palette.length];
}
