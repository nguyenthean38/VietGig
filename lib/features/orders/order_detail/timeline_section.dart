import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/order.dart';
import '../widgets/order_widgets.dart';

/// Dòng thời gian hoạt động của đơn (mục có thể mở rộng).
class OrderTimeline extends StatefulWidget {
  const OrderTimeline({super.key, required this.order, required this.remind, required this.onRemind});
  final Order order;
  final bool remind;
  final VoidCallback onRemind;

  @override
  State<OrderTimeline> createState() => _OrderTimelineState();
}

class _OrderTimelineState extends State<OrderTimeline> {
  /// Khoá mục đang mở rộng.
  final Set<String> _open = {'due'};
  final Set<String> _closed = {};

  bool _isOpen(String k, bool byDefault) => _open.contains(k) || (byDefault && !_closed.contains(k));

  void _toggle(String k, bool byDefault) => setState(() {
    if (_isOpen(k, byDefault)) {
      _open.remove(k);
      _closed.add(k);
    } else {
      _open.add(k);
      _closed.remove(k);
    }
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    final o = widget.order;
    final events = o.events.reversed.toList();
    final showDue =
        o.status == OrderStatus.inProgress ||
        o.status == OrderStatus.revisionRequested ||
        o.status == OrderStatus.disputed;
    final items = <Widget>[];
    if (showDue) {
      final c = Fmt.countdown(o.dueDate);
      items.add(
        _item(
          key: 'due',
          icon: Icons.event_available_outlined,
          title: l.ordersDetailExpectedDelivery,
          trailingTitle: Fmt.date(o.dueDate),
          byDefault: true,
          child: Column(
            children: [
              CountdownBox(days: c.days, hours: c.hours, minutes: c.minutes),
              Gaps.v6,
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    key: const ValueKey('remind_me'),
                    onPressed: widget.onRemind,
                    icon: Icon(
                      widget.remind ? Icons.notifications_off_outlined : Icons.notifications_none_rounded,
                      size: 18,
                    ),
                    label: Text(widget.remind ? l.ordersDetailRemindOffAction : l.ordersDetailRemindMe),
                  ),
                  TextButton.icon(
                    key: const ValueKey('add_calendar'),
                    onPressed: () => showAppSnack(context, l.ordersDetailAddedToCalendar(Fmt.date(o.dueDate))),
                    icon: const Icon(Icons.calendar_month_outlined, size: 18),
                    label: Text(l.ordersDetailAddToCalendar),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    for (var i = 0; i < events.length; i++) {
      final e = events[i];
      final k = 'ev_${o.events.length - 1 - i}';
      items.add(
        _item(
          key: k,
          icon: e.type.icon,
          title: e.title,
          subtitle: Fmt.dateTime(e.at),
          byDefault: i == 0 && !showDue,
          color: switch (e.type) {
            OrderEventType.resolutionAccepted || OrderEventType.completed => t.brand,
            OrderEventType.resolutionDeclined || OrderEventType.cancelled => t.danger,
            OrderEventType.extensionRequested => t.warning,
            _ => null,
          },
          child: _eventBody(e),
          eventType: e.type,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.xs),
          child: Text(l.ordersDetailActivity, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        ),
        ...items,
      ],
    );
  }

  Widget? _eventBody(OrderEvent e) {
    final o = widget.order;
    final small = context.textTheme.bodySmall;
    const bodyStyle = TextStyle(fontSize: 13.5, height: 1.4);
    switch (e.type) {
      case OrderEventType.requirementsSubmitted:
        if (o.requirementAnswers.isEmpty && e.attachments.isEmpty) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final qa in o.requirementAnswers.entries) ...[
              Text(qa.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, height: 1.35)),
              Gaps.v4,
              Text(qa.value, style: bodyStyle),
              Gaps.v12,
            ],
            for (final f in e.attachments)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: FileTile(name: f, size: '14 KB'),
              ),
          ],
        );
      case OrderEventType.created:
        return OrderInfoTable(order: o);
      case OrderEventType.delivered:
        final d =
            o.deliveries.where((d) => d.at == e.at).firstOrNull ?? (o.deliveries.isEmpty ? null : o.deliveries.last);
        if (d == null) return e.body.isEmpty ? null : Text(e.body, style: small);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(d.message, style: bodyStyle),
            for (final f in d.files)
              Padding(
                padding: const EdgeInsets.only(top: Space.sm),
                child: FileTile(name: f),
              ),
          ],
        );
      default:
        if (e.body.isEmpty && e.attachments.isEmpty) return null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (e.body.isNotEmpty) Text(e.body, style: bodyStyle),
            for (final f in e.attachments)
              Padding(
                padding: const EdgeInsets.only(top: Space.sm),
                child: FileTile(name: f),
              ),
          ],
        );
    }
  }

  Widget _item({
    required String key,
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingTitle,
    required bool byDefault,
    Widget? child,
    Color? color,
    OrderEventType? eventType,
  }) {
    final cs = context.colors;
    final open = child != null && _isOpen(key, byDefault);
    return Container(
      key: ValueKey(eventType == null ? 'timeline_$key' : 'event_${eventType.name}_$key'),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: child == null ? null : () => _toggle(key, byDefault),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, 14, Space.md, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 22, color: color ?? cs.onSurfaceVariant),
                  Gaps.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: title,
                            children: [
                              if (trailingTitle != null)
                                TextSpan(
                                  text: '  $trailingTitle',
                                  style: const TextStyle(fontWeight: FontWeight.w400),
                                ),
                            ],
                          ),
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5, color: color),
                        ),
                        if (subtitle != null) ...[Gaps.v2, Text(subtitle, style: context.textTheme.bodySmall)],
                      ],
                    ),
                  ),
                  if (child != null)
                    AnimatedRotation(
                      turns: open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                ],
              ),
            ),
          ),
          if (open) Padding(padding: const EdgeInsets.fromLTRB(50, 0, Space.lg, Space.lg), child: child),
        ],
      ),
    );
  }
}
