import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';

/// Một nút hành động hiện ra khi vuốt trái.
class SwipeAction {
  const SwipeAction({required this.label, required this.icon, required this.color, required this.onTap, this.key});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Key? key;
}

/// Dòng có thể vuốt trái để lộ các nút tròn (Lưu trữ / Gắn sao / Thêm).
/// [openNotifier] đảm bảo chỉ một dòng mở tại một thời điểm.
class SwipeActionTile extends StatefulWidget {
  const SwipeActionTile({
    super.key,
    required this.id,
    required this.child,
    required this.actions,
    required this.openNotifier,
    this.enabled = true,
  });

  final String id;
  final Widget child;
  final List<SwipeAction> actions;
  final ValueNotifier<String?> openNotifier;
  final bool enabled;

  @override
  State<SwipeActionTile> createState() => _SwipeActionTileState();
}

class _SwipeActionTileState extends State<SwipeActionTile> with SingleTickerProviderStateMixin {
  static const _actionWidth = 70.0;
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

  double get _width => widget.actions.length * _actionWidth + Space.sm;

  @override
  void initState() {
    super.initState();
    widget.openNotifier.addListener(_onOther);
  }

  @override
  void didUpdateWidget(covariant SwipeActionTile old) {
    super.didUpdateWidget(old);
    if (old.openNotifier != widget.openNotifier) {
      old.openNotifier.removeListener(_onOther);
      widget.openNotifier.addListener(_onOther);
    }
    if (!widget.enabled && _c.value > 0) _c.value = 0;
  }

  @override
  void dispose() {
    widget.openNotifier.removeListener(_onOther);
    _c.dispose();
    super.dispose();
  }

  void _onOther() {
    if (widget.openNotifier.value != widget.id && _c.value > 0) _c.animateTo(0);
  }

  void _open() {
    _c.animateTo(1);
    widget.openNotifier.value = widget.id;
  }

  void _close() {
    _c.animateTo(0);
    if (widget.openNotifier.value == widget.id) widget.openNotifier.value = null;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    final cs = context.colors;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (d) {
        _c.value = (_c.value - (d.primaryDelta ?? 0) / _width).clamp(0.0, 1.0);
      },
      onHorizontalDragEnd: (d) {
        final v = d.primaryVelocity ?? 0;
        if (v < -300 || (v <= 300 && _c.value > 0.4)) {
          _open();
        } else {
          _close();
        }
      },
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) => Stack(
          children: [
            if (_c.value > 0)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Opacity(
                    opacity: _c.value.clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.only(right: Space.sm),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final a in widget.actions)
                            SizedBox(
                              width: _actionWidth,
                              child: InkWell(
                                key: a.key,
                                borderRadius: Radii.lgAll,
                                onTap: () {
                                  _close();
                                  a.onTap();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(color: a.color, shape: BoxShape.circle),
                                        child: Icon(a.icon, color: Colors.white, size: 22),
                                      ),
                                      Gaps.v4,
                                      Text(
                                        a.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 11.5, color: cs.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Transform.translate(
              offset: Offset(-_c.value * _width, 0),
              child: _c.value > 0
                  ? GestureDetector(
                      onTap: _close,
                      behavior: HitTestBehavior.opaque,
                      child: AbsorbPointer(child: child),
                    )
                  : child,
            ),
          ],
        ),
        child: ColoredBox(color: Theme.of(context).scaffoldBackgroundColor, child: widget.child),
      ),
    );
  }
}
