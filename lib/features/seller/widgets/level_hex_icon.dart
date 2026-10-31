import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../data/models/account.dart';
import '../../../data/models/user.dart';

/// Định dạng điểm đánh giá kiểu Việt Nam: 4.3 -> "4,3".
String fmtRating(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

/// Cấp độ ứng với phần tử thứ [index] của danh sách yêu cầu (Cấp 1, Cấp 2, Top Rated).
SellerLevel requirementLevel(int index) => switch (index) {
  0 => SellerLevel.level1,
  1 => SellerLevel.level2,
  _ => SellerLevel.topRated,
};

/// Cấp độ kế tiếp cần đạt (null nếu đã là Top Rated).
LevelRequirement? nextRequirement(SellerLevel level, List<LevelRequirement> reqs) {
  if (reqs.isEmpty) return null;
  final i = switch (level) {
    SellerLevel.newSeller => 0,
    SellerLevel.level1 => 1,
    SellerLevel.level2 => 2,
    SellerLevel.topRated => -1,
  };
  if (i < 0 || i >= reqs.length) return null;
  return reqs[i];
}

/// Màu đặc trưng (trang trí) của từng cấp độ.
Color levelColor(SellerLevel level) => switch (level) {
  SellerLevel.newSeller => const Color(0xFFC5C6C9),
  SellerLevel.level1 => const Color(0xFFE5508A),
  SellerLevel.level2 => const Color(0xFF8BC34A),
  SellerLevel.topRated => const Color(0xFFF07C3A),
};

/// Biểu tượng cấp độ dạng lục giác.
class LevelHexIcon extends StatelessWidget {
  const LevelHexIcon({super.key, required this.level, this.size = 40});
  final SellerLevel level;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _HexPainter(levelColor(level))),
  );
}

class _HexPainter extends CustomPainter {
  _HexPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    Path hex(double radius) {
      final p = Path();
      for (var i = 0; i < 6; i++) {
        final a = math.pi / 6 + i * math.pi / 3;
        final pt = c + Offset(math.cos(a) * radius, math.sin(a) * radius);
        i == 0 ? p.moveTo(pt.dx, pt.dy) : p.lineTo(pt.dx, pt.dy);
      }
      return p..close();
    }

    final light = Color.lerp(color, Colors.white, 0.35)!;
    canvas.drawPath(
      hex(r),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [light, color],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      hex(r * 0.82),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.06
        ..color = Colors.white.withValues(alpha: 0.45),
    );
    canvas.drawCircle(c, r * 0.16, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_HexPainter old) => old.color != color;
}
