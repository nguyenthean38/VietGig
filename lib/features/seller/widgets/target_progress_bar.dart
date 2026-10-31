import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';

/// Thanh tiến độ có vạch mục tiêu (mục tiêu cấp kế tiếp).
class TargetProgressBar extends StatelessWidget {
  const TargetProgressBar({
    super.key,
    required this.value,
    required this.max,
    this.target,
    this.showScale = false,
    this.scaleLabels,
    this.height = 6,
  });
  final double value;
  final double max;
  final double? target;
  final bool showScale;

  /// Nhãn (đầu, mục tiêu, cuối) hiển thị dưới thanh.
  final (String, String, String)? scaleLabels;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final brand = context.tokens.brand;
    final frac = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    final tFrac = target == null || max <= 0 ? null : (target! / max).clamp(0.0, 1.0);
    final reached = target != null && value >= target!;
    final radius = BorderRadius.circular(height);
    // Không dùng LayoutBuilder để widget hỗ trợ IntrinsicHeight.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height + 10,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: radius),
              ),
              FractionallySizedBox(
                widthFactor: frac,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(color: reached ? brand : cs.onSurface, borderRadius: radius),
                ),
              ),
              if (tFrac != null)
                Align(
                  alignment: Alignment(tFrac * 2 - 1, 0),
                  child: Container(
                    width: 2,
                    height: height + 10,
                    decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(1)),
                  ),
                ),
            ],
          ),
        ),
        if (showScale && scaleLabels != null) ...[
          Gaps.v4,
          SizedBox(
            height: 14,
            child: Stack(
              children: [
                Align(alignment: Alignment.centerLeft, child: _scale(context, scaleLabels!.$1)),
                if (tFrac != null && tFrac > 0.12 && tFrac < 0.88)
                  Align(alignment: Alignment(tFrac * 2 - 1, 0), child: _scale(context, scaleLabels!.$2)),
                Align(alignment: Alignment.centerRight, child: _scale(context, scaleLabels!.$3)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _scale(BuildContext context, String t) =>
      Text(t, style: TextStyle(fontSize: 10.5, color: context.colors.onSurfaceVariant));
}
