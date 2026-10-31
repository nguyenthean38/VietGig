import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/chat.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import 'resolution/resolution_menu.dart';
import 'widgets/order_widgets.dart';

/// Lý do huỷ (theo thứ tự hiển thị).
List<String> _cancelReasons(AppLocalizations l) => [
  l.ordersResolutionReasonNoResponse,
  l.ordersResolutionReasonQuality,
  l.ordersResolutionReasonWrongItem,
  l.ordersResolutionReasonTooMuchGuidance,
  l.ordersResolutionReasonLanguage,
  l.ordersResolutionReasonOther,
];

/// Trung tâm giải quyết: cập nhật tiến độ, gia hạn, huỷ đơn.
class ResolutionCenterScreen extends StatefulWidget {
  const ResolutionCenterScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<ResolutionCenterScreen> createState() => _ResolutionCenterScreenState();
}

class _ResolutionCenterScreenState extends State<ResolutionCenterScreen> {
  late final Future<OrderBundle?> _future;
  ResolutionView _view = ResolutionView.menu;
  final _update = TextEditingController();
  final _extendMsg = TextEditingController();
  final _cancelMsg = TextEditingController();
  int _days = 1;
  int? _reason;
  int _sellerRating = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _future = fetchOrderBundle(context, widget.orderId);
  }

  @override
  void dispose() {
    _update.dispose();
    _extendMsg.dispose();
    _cancelMsg.dispose();
    super.dispose();
  }

  Future<void> _do(Future<void> Function() f, String success) async {
    setState(() => _busy = true);
    try {
      await f();
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showAppSnack(context, context.l10n.ordersResolutionError('$e'), success: false);
      }
      return;
    }
    if (!mounted) return;
    showAppSnack(context, success);
    context.pop();
  }

  Future<void> _sendUpdate(OrderBundle b, String otherId) {
    final l = context.l10n;
    final inbox = context.read<InboxController>();
    final me = context.read<SessionController>().userId;
    final text = _update.text.trim();
    return _do(() async {
      final c = await inbox.open(otherId);
      await inbox.send(
        ChatMessage(
          id: 'm_${DateTime.now().microsecondsSinceEpoch}',
          conversationId: c.id,
          senderId: me,
          sentAt: DateTime.now(),
          text: l.ordersResolutionUpdateChat(b.order.code, text),
          relatedGigId: b.order.gigId,
        ),
      );
    }, l.ordersResolutionUpdateSent(otherName(l, b)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(
        title: switch (_view) {
          ResolutionView.menu => l.ordersResolutionTitle,
          ResolutionView.update => l.ordersResolutionUpdateTitle,
          ResolutionView.extend => l.ordersResolutionExtendTitle,
          ResolutionView.cancel => l.ordersResolutionCancelTitle,
        },
        close: _view == ResolutionView.menu,
        onBack: _view == ResolutionView.menu ? null : () => setState(() => _view = ResolutionView.menu),
      ),
      body: OrderBundleView(
        orderId: widget.orderId,
        future: _future,
        builder: (context, b) {
          final me = context.read<SessionController>().userId;
          final seller = b.order.sellerId == me;
          return switch (_view) {
            ResolutionView.menu => ResolutionMenu(bundle: b, seller: seller, onOpen: (v) => setState(() => _view = v)),
            ResolutionView.update => _updateView(b, seller),
            ResolutionView.extend => _extendView(b, seller),
            ResolutionView.cancel => _cancelView(b),
          };
        },
      ),
    );
  }

  Widget _formPage({required List<Widget> children, required Widget button}) => Column(
    children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
          children: children,
        ),
      ),
      BottomActionBar(child: button),
    ],
  );

  Widget _updateView(OrderBundle b, bool seller) {
    final l = context.l10n;
    return _formPage(
      children: [
        OrderHeaderCard(order: b.order),
        BlockTitle(l.ordersResolutionUpdateHeading),
        Text(l.ordersResolutionUpdateBody(otherName(l, b)), style: context.textTheme.bodySmall),
        Gaps.v12,
        CountedTextField(
          fieldKey: const ValueKey('update_field'),
          controller: _update,
          maxLength: 1000,
          hint: l.ordersResolutionUpdateHint,
          onChanged: (_) => setState(() {}),
        ),
      ],
      button: PrimaryButton(
        key: const ValueKey('update_send'),
        label: l.ordersResolutionSendRequest,
        loading: _busy,
        onPressed: _update.text.trim().length >= 5
            ? () => _sendUpdate(b, seller ? b.order.buyerId : b.order.sellerId)
            : null,
      ),
    );
  }

  Widget _extendView(OrderBundle b, bool seller) {
    final l = context.l10n;
    final o = b.order;
    final newDue = o.dueDate.add(Duration(days: _days));
    return _formPage(
      children: [
        OrderHeaderCard(order: o),
        BlockTitle(l.ordersResolutionExtendHeading),
        AppCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l.ordersResolutionExtendDays, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  QtyStepper(keyPrefix: 'extend', value: _days, max: 30, onChanged: (v) => setState(() => _days = v)),
                ],
              ),
              const Divider(height: Space.xxl),
              SummaryRow(l.ordersResolutionCurrentDue, Fmt.date(o.dueDate)),
              SummaryRow(l.ordersResolutionNewDue, '${Fmt.weekday(newDue)}, ${Fmt.date(newDue)}', bold: true),
            ],
          ),
        ),
        BlockTitle(l.ordersResolutionMessage),
        CountedTextField(
          fieldKey: const ValueKey('extend_message'),
          controller: _extendMsg,
          maxLength: 1000,
          minLines: 4,
          hint: seller ? l.ordersResolutionExtendHintSeller : l.ordersResolutionExtendHintBuyer,
          onChanged: (_) => setState(() {}),
        ),
        Text(
          seller ? l.ordersResolutionExtendNoteSeller : l.ordersResolutionExtendNoteBuyer,
          style: context.textTheme.bodySmall,
        ),
      ],
      button: PrimaryButton(
        key: const ValueKey('extend_submit'),
        label: l.ordersResolutionExtendSubmit,
        loading: _busy,
        onPressed: _extendMsg.text.trim().length >= 5
            ? () {
                final orders = context.read<OrdersController>();
                _do(
                  () => orders.requestExtension(o.id, days: _days, message: _extendMsg.text.trim(), fromSeller: seller),
                  l.ordersResolutionExtendSent(_days),
                );
              }
            : null,
      ),
    );
  }

  Widget _cancelView(OrderBundle b) {
    final l = context.l10n;
    final o = b.order;
    final reasons = _cancelReasons(l);
    return _formPage(
      children: [
        OrderHeaderCard(order: o),
        Gaps.v16,
        AppCard(
          color: context.colors.surfaceContainerHighest,
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined),
              Gaps.h12,
              Expanded(
                child: Text(l.ordersResolutionRefundNote(Fmt.money(o.total)), style: const TextStyle(fontSize: 13.5)),
              ),
            ],
          ),
        ),
        BlockTitle(l.ordersResolutionFeedbackHeading),
        CountedTextField(
          fieldKey: const ValueKey('cancel_message'),
          controller: _cancelMsg,
          maxLength: 1000,
          minLines: 3,
          hint: l.ordersResolutionCancelHint,
          onChanged: (_) => setState(() {}),
        ),
        BlockTitle(
          l.ordersResolutionReasonHeading,
          padding: const EdgeInsets.only(top: Space.sm, bottom: Space.xxs),
        ),
        Text(l.ordersResolutionReasonNote, style: context.textTheme.bodySmall),
        for (var i = 0; i < reasons.length; i++)
          RadioRow(
            key: ValueKey('cancel_reason_$i'),
            label: reasons[i],
            selected: _reason == i,
            onTap: () => setState(() => _reason = i),
          ),
        BlockTitle(l.ordersResolutionRateSeller),
        Align(
          alignment: Alignment.centerLeft,
          child: StarRating(
            value: _sellerRating.toDouble(),
            size: 34,
            onChanged: (v) => setState(() => _sellerRating = v),
          ),
        ),
      ],
      button: PrimaryButton(
        key: const ValueKey('cancel_submit'),
        label: l.ordersResolutionCancelSubmit,
        loading: _busy,
        color: context.tokens.danger,
        onPressed: _reason == null
            ? null
            : () {
                final orders = context.read<OrdersController>();
                final msg = _cancelMsg.text.trim();
                _do(
                  () => orders.requestCancel(
                    o.id,
                    reason: reasons[_reason!],
                    message: _sellerRating > 0
                        ? '$msg\n${l.ordersResolutionSellerRatingNote(_sellerRating)}'.trim()
                        : msg,
                  ),
                  l.ordersResolutionCancelSent,
                );
              },
      ),
    );
  }
}
