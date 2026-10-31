import 'package:flutter/material.dart';

/// Ánh xạ khoá icon (lưu dạng chuỗi trong dữ liệu / Firestore) sang IconData.
class AppIcons {
  AppIcons._();

  static const _map = <String, IconData>{
    'design': Icons.brush_outlined,
    'code': Icons.code_rounded,
    'ai': Icons.auto_awesome_outlined,
    'marketing': Icons.campaign_outlined,
    'video': Icons.movie_creation_outlined,
    'writing': Icons.edit_note_rounded,
    'music': Icons.music_note_outlined,
    'business': Icons.business_center_outlined,
    'photo': Icons.photo_camera_outlined,
    'social': Icons.thumb_up_alt_outlined,
    'brand': Icons.style_outlined,
    'print': Icons.print_outlined,
    'game': Icons.sports_esports_outlined,
    'data': Icons.storage_outlined,
    'growth': Icons.trending_up_rounded,
    'craft': Icons.palette_outlined,
    'analytics': Icons.insights_outlined,
    'logo': Icons.blur_circular_outlined,
    'animation': Icons.animation_outlined,
    'card': Icons.badge_outlined,
    'shirt': Icons.checkroom_outlined,
    'web': Icons.language_rounded,
    'mobile': Icons.phone_iphone_rounded,
    'translate': Icons.translate_rounded,
    'gift': Icons.card_giftcard_outlined,
  };

  static IconData of(String key) => _map[key] ?? Icons.category_outlined;
}
