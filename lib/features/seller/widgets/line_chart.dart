import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/format.dart';

/// Biểu đồ đường vẽ bằng CustomPainter (màu lấy từ token theme).
class LineChart extends StatelessWidget {
  const LineChart({super.key, required this.values, required this.xLabels, this.formatY, this.height = 220});

  final List<num> values;

  /// Nhãn trục X (phân bố đều từ trái sang phải).
  final List<String> xLabels;
  final String Function(num v)? formatY;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: LineChartPainter(
          values: values,
          xLabels: xLabels,
          formatY: formatY ?? (v) => Fmt.moneyShort(v),
          accent: context.tokens.brand,
          grid: cs.outlineVariant,
          label: cs.onSurfaceVariant,
          surface: cs.surface,
        ),
      ),
    );
  }
}

/// Vẽ biểu đồ đường; mọi màu được truyền vào qua tham số.
class LineChartPainter extends CustomPainter {
  LineChartPainter({
    required this.values,
    required this.xLabels,
    required this.formatY,
    required this.accent,
    required this.grid,
    required this.label,
    required this.surface,
  });

  final List<num> values;
  final List<String> xLabels;
  final String Function(num v) formatY;

  /// Màu đường và vùng tô.
  final Color accent;
  final Color grid;
  final Color label;
  final Color surface;

  static const _rows = 4;

  TextPainter _tp(String s) => TextPainter(
    text: TextSpan(
      text: s,
      style: TextStyle(color: label, fontSize: 10.5),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  double _niceMax(num raw) {
    if (raw <= 0) return _rows.toDouble();
    final exp = math.pow(10, (math.log(raw.toDouble()) / math.ln10).floor()).toDouble();
    for (final m in [1, 2, 2.5, 5, 10]) {
      final step = exp * m / _rows;
      final top = step * _rows;
      if (top >= raw) return top;
    }
    return exp * 10;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final maxV = _niceMax(values.isEmpty ? 0 : values.fold<num>(0, (a, b) => math.max(a, b)));
    final yLabels = [for (var i = 0; i <= _rows; i++) formatY(maxV * i / _rows)];
    final labelW = yLabels.map((s) => _tp(s).width).reduce(math.max) + 8;
    const bottomH = 22.0;
    const topPad = 8.0;
    final chart = Rect.fromLTRB(labelW, topPad, size.width - 4, size.height - bottomH);

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 0; i <= _rows; i++) {
      final y = chart.bottom - chart.height * i / _rows;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final tp = _tp(yLabels[i]);
      tp.paint(canvas, Offset(chart.left - tp.width - 6, y - tp.height / 2));
    }

    for (var i = 0; i < xLabels.length; i++) {
      final tp = _tp(xLabels[i]);
      final t = xLabels.length == 1 ? 0.5 : i / (xLabels.length - 1);
      final x = (chart.left + chart.width * t - tp.width * t).clamp(chart.left - 4, size.width - tp.width);
      tp.paint(canvas, Offset(x, chart.bottom + 6));
    }

    if (values.isEmpty) return;
    final pts = <Offset>[
      for (var i = 0; i < values.length; i++)
        Offset(
          chart.left + (values.length == 1 ? chart.width / 2 : chart.width * i / (values.length - 1)),
          chart.bottom - chart.height * (values[i] / maxV).clamp(0.0, 1.0),
        ),
    ];

    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final p0 = pts[i - 1];
      final p1 = pts[i];
      final mx = (p0.dx + p1.dx) / 2;
      line.cubicTo(mx, p0.dy, mx, p1.dy, p1.dx, p1.dy);
    }
    final area = Path.from(line)
      ..lineTo(pts.last.dx, chart.bottom)
      ..lineTo(pts.first.dx, chart.bottom)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [accent.withValues(alpha: 0.28), accent.withValues(alpha: 0.0)],
        ).createShader(chart),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(pts.last, 4.5, Paint()..color = surface);
    canvas.drawCircle(
      pts.last,
      4.5,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );
  }

  @override
  bool shouldRepaint(LineChartPainter old) =>
      old.values != values ||
      old.xLabels != xLabels ||
      old.accent != accent ||
      old.grid != grid ||
      old.label != label ||
      old.surface != surface;
}
