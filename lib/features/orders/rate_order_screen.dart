import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/order.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import 'rate/rate_parts.dart';
import 'rate/rate_tip_step.dart';
import 'widgets/order_widgets.dart';

/// Luồng đánh giá nhiều bước + tip.
class RateOrderScreen extends StatefulWidget {
  const RateOrderScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<RateOrderScreen> createState() => _RateOrderScreenState();
}

class _RateOrderScreenState extends State<RateOrderScreen> {
  late final Future<OrderBundle?> _future;
  bool _inited = false;
  int _step = 0;
  int _quality = 0;
  int _value = 0;
  double _overall = 0;
  final Set<String> _highlights = {};
  final _text = TextEditingController();
  bool _share = true;
  int? _tip;
  bool _customTip = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _future = fetchOrderBundle(context, widget.orderId);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _go(int s) => setState(() {
    _step = s;
    if (s == 3 && _overall == 0) {
      final parts = [_quality, _value].where((v) => v > 0).toList();
      if (parts.isNotEmpty) _overall = parts.reduce((a, b) => a + b) / parts.length;
    }
  });

  void _back() {
    if (_step == 0 || _step == 4) {
      context.pop();
    } else {
      _go(_step - 1);
    }
  }

  void _skip(Order o) {
    if (_step < 3) {
      _go(_step + 1);
    } else if (_step == 3) {
      _go(4);
    } else {
      if (o.review != null) showAppSnack(context, context.l10n.ordersRateThanksReview);
      context.pop();
    }
  }

  Future<void> _submitReview(Order o) async {
    setState(() => _busy = true);
    try {
      await context.read<OrdersController>().review(
        o.id,
        OrderReview(
          overall: double.parse(_overall.toStringAsFixed(1)),
          quality: _quality,
          value: _value,
          communication: _quality,
          highlights: _highlights.toList(),
          text: _text.text.trim(),
          sharePublicly: _share,
        ),
      );
      if (mounted) setState(() => _step = 4);
    } catch (e) {
      if (mounted) showAppSnack(context, context.l10n.ordersRateSubmitError('$e'), success: false);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickCustom() async {
    final l = context.l10n;
    final v = await showTextInputDialog(
      context,
      title: l.ordersRateCustomTitle,
      initial: _customTip && _tip != null ? '$_tip' : '',
      hint: l.ordersRateCustomHint,
      suffix: '₫',
      helper: l.ordersRateCustomHelper,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
      fieldKey: const ValueKey('tip_custom_field'),
      confirmKey: const ValueKey('tip_custom_apply'),
      validate: (v) => (int.tryParse(v) ?? 0) < 25000 ? l.ordersRateCustomError : null,
    );
    if (v != null && mounted) {
      setState(() {
        _tip = int.parse(v);
        _customTip = true;
      });
    }
  }

  Future<void> _sendTip(Order o, String name) async {
    final amount = _tip;
    if (amount == null) return;
    setState(() => _busy = true);
    try {
      await context.read<OrdersController>().tip(o.id, amount);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showAppSnack(context, context.l10n.ordersRateTipError('$e'), success: false);
      }
      return;
    }
    if (!mounted) return;
    showAppSnack(context, context.l10n.ordersRateTipSent(Fmt.money(amount), name));
    context.pop();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<OrderBundle?>(
    future: _future,
    builder: (context, snap) => Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        leading: AppBackButton(key: const ValueKey('rate_back'), close: _step == 0 || _step == 4, onPressed: _back),
        actions: [
          if (snap.data != null)
            TextButton(
              key: const ValueKey('rate_skip'),
              onPressed: _busy
                  ? null
                  : () => _skip(context.read<OrdersController>().byId(widget.orderId) ?? snap.data!.order),
              child: Text(_step == 4 ? context.l10n.ordersRateLater : context.l10n.ordersRateSkip),
            ),
          Gaps.h8,
        ],
      ),
      body: OrderBundleView(orderId: widget.orderId, future: _future, builder: _content),
    ),
  );

  Widget _content(BuildContext context, OrderBundle b) {
    final l = context.l10n;
    final o = b.order;
    final me = context.read<SessionController>().userId;
    if (o.buyerId != me) {
      return EmptyState(icon: Icons.lock_outline_rounded, title: l.ordersRateBuyerOnly);
    }
    if (o.status != OrderStatus.completed) {
      return EmptyState(
        icon: Icons.hourglass_empty_rounded,
        title: l.ordersRateNotYet,
        message: l.ordersRateNotYetBody,
        actionLabel: l.ordersDeliverBackToOrder,
        onAction: () => context.canPop() ? context.pop() : context.go('/orders/${o.id}'),
      );
    }
    if (!_inited) {
      _inited = true;
      if (o.review != null) {
        _step = 4;
        _overall = o.review!.overall;
      }
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: KeyedSubtree(key: ValueKey('step_$_step'), child: _stepView(b)),
    );
  }

  Widget _next({required bool enabled, String? label, VoidCallback? onPressed, Key? key}) => PrimaryButton(
    key: key ?? const ValueKey('rate_next'),
    label: label ?? context.l10n.ordersRateContinue,
    loading: _busy,
    onPressed: enabled ? (onPressed ?? () => _go(_step + 1)) : null,
  );

  Widget _stars(int value, ValueChanged<int> onChanged) => Center(
    child: FittedBox(
      child: StarRating(value: value.toDouble(), size: 40, labels: rateStarLabels(context.l10n), onChanged: onChanged),
    ),
  );

  Widget _stepView(OrderBundle b) {
    final l = context.l10n;
    final o = b.order;
    final cs = context.colors;
    switch (_step) {
      case 0:
        return RatePage(
          items: [
            Gaps.v24,
            RateAvatar(b),
            RateTitle(l.ordersRateQualityTitle),
            _stars(_quality, (v) => setState(() => _quality = v)),
          ],
          bottom: _next(enabled: _quality > 0),
        );
      case 1:
        final good = _quality == 0 || _quality >= 4;
        final chips = good ? ratePositiveChips(l) : rateNegativeChips(l);
        return RatePage(
          items: [
            Gaps.v24,
            Center(child: StarRating(value: _quality.toDouble(), size: 30)),
            if (_quality > 0) ...[
              Gaps.v6,
              Text(rateStarLabels(l)[_quality - 1], textAlign: TextAlign.center, style: context.textTheme.bodySmall),
            ],
            RateTitle(good ? l.ordersRateGoodTitle : l.ordersRateBadTitle),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: Space.sm,
              runSpacing: 10,
              children: [
                for (final c in chips)
                  SelectChip(
                    key: ValueKey('chip_$c'),
                    label: c,
                    selected: _highlights.contains(c),
                    showCheck: true,
                    onTap: () => setState(() => _highlights.contains(c) ? _highlights.remove(c) : _highlights.add(c)),
                  ),
              ],
            ),
          ],
          bottom: _next(enabled: true),
        );
      case 2:
        final end =
            o.events.where((e) => e.type == OrderEventType.completed).map((e) => e.at).firstOrNull ?? DateTime.now();
        final days = end.difference(o.createdAt).inDays.clamp(1, 999);
        return RatePage(
          items: [
            Gaps.v24,
            RateAvatar(b),
            RateTitle(l.ordersRateValueTitle),
            Text(
              l.ordersRateValueBody(days, Fmt.money(o.subtotal)),
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
            Gaps.v20,
            _stars(_value, (v) => setState(() => _value = v)),
          ],
          bottom: _next(enabled: _value > 0),
        );
      case 3:
        return _writeStep(o);
      default:
        return RateTipStep(
          bundle: b,
          overall: _overall,
          tip: _tip,
          customTip: _customTip,
          busy: _busy,
          onPreset: (v) => setState(() {
            _tip = v;
            _customTip = false;
          }),
          onCustom: _pickCustom,
          onSend: () => _sendTip(o, otherName(l, b)),
          onDone: () => context.pop(),
        );
    }
  }

  Widget _writeStep(Order o) {
    final l = context.l10n;
    final topics = _highlights.isEmpty ? l.ordersRateTopicsDefault : _highlights.join(', ');
    final ok = _overall > 0 && _text.text.trim().length >= 10;
    return RatePage(
      items: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StarRating(value: _overall, size: 30, onChanged: (v) => setState(() => _overall = v.toDouble())),
            Gaps.h8,
            Text(
              _overall == 0 ? '–' : _overall.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        RateTitle(l.ordersRateWriteTitle),
        Text(
          l.ordersRateWriteBody(topics),
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.onSurfaceVariant, fontSize: 13.5),
        ),
        Gaps.v16,
        CountedTextField(
          fieldKey: const ValueKey('review_text'),
          controller: _text,
          maxLength: 700,
          hint: l.ordersRateTextHint,
          onChanged: (_) => setState(() {}),
        ),
        InkWell(
          key: const ValueKey('share_sample'),
          onTap: () => setState(() => _share = !_share),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckDot(selected: _share),
                Gaps.h10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.ordersRateShareTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Gaps.v2,
                      Text(l.ordersRateShareBody, style: context.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _next(
            key: const ValueKey('review_submit'),
            enabled: ok,
            label: l.ordersRateSubmit,
            onPressed: () => _submitReview(o),
          ),
          Gaps.v8,
          Text(l.ordersRatePublicNote, textAlign: TextAlign.center, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}
