import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/order.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import 'order_detail/completed_block.dart';
import 'order_detail/delivery_block.dart';
import 'order_detail/extras_strip.dart';
import 'order_detail/order_detail_sheets.dart';
import 'order_detail/pending_request_block.dart';
import 'order_detail/status_banners.dart';
import 'order_detail/timeline_section.dart';
import 'widgets/order_widgets.dart';

/// Chi tiết đơn hàng: dòng thời gian, bản giao, yêu cầu gia hạn, đánh giá…
class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late final Future<OrderBundle?> _future;
  bool _hideExtras = false;
  bool _hideThanks = false;
  bool _remind = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _future = fetchOrderBundle(context, widget.orderId);
  }

  String get _me => context.read<SessionController>().userId;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) showAppSnack(context, context.l10n.ordersDetailError('$e'), success: false);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ------------------------------------------------------------ hành động
  Future<void> _menu(OrderBundle b) async {
    final l = context.l10n;
    final o = b.order;
    final seller = o.sellerId == _me;
    final v = await showActionSheet<String>(
      context,
      actions: [
        SheetAction(label: l.ordersDetailMenuUnread, value: 'unread', icon: Icons.mark_email_unread_outlined),
        if (!seller && o.status.isActive && (b.gig?.extras.isNotEmpty ?? false))
          SheetAction(label: l.ordersDetailMenuExtra, value: 'extra', icon: Icons.add_circle_outline_rounded),
        if (seller && _canDeliver(o))
          SheetAction(label: l.ordersDetailDeliver, value: 'deliver', icon: Icons.inventory_2_outlined),
        SheetAction(label: l.ordersResolutionCenter, value: 'resolution', icon: Icons.support_agent_rounded),
        SheetAction(label: l.ordersDetailMenuGig, value: 'gig', icon: Icons.storefront_outlined),
        SheetAction(label: l.ordersCopyCode, value: 'copy', icon: Icons.copy_rounded),
      ],
    );
    if (!mounted || v == null) return;
    switch (v) {
      case 'unread':
        showAppSnack(context, l.ordersDetailMarkedUnread);
      case 'extra':
        setState(() => _hideExtras = false);
        showAppSnack(context, l.ordersDetailPickExtra);
      case 'deliver':
        context.push('/orders/${o.id}/deliver');
      case 'resolution':
        context.push('/orders/${o.id}/resolution');
      case 'gig':
        context.push('/gig/${o.gigId}');
      case 'copy':
        await Clipboard.setData(ClipboardData(text: o.code));
        if (mounted) showAppSnack(context, l.ordersCodeCopied(o.code));
    }
  }

  bool _canDeliver(Order o) => o.status == OrderStatus.inProgress || o.status == OrderStatus.revisionRequested;

  Future<void> _addExtra(Order o, GigExtra e) async {
    final l = context.l10n;
    final price = Fmt.money(e.price);
    final ok = await confirmDialog(
      context,
      title: l.ordersDetailAddExtraTitle(e.title),
      message: e.extraDays > 0
          ? l.ordersDetailAddExtraMessageDays(price, e.extraDays)
          : l.ordersDetailAddExtraMessage(price),
      confirmLabel: l.ordersDetailAddExtraConfirm,
    );
    if (!ok || !mounted) return;
    final orders = context.read<OrdersController>();
    await _run(() async {
      await orders.addExtra(o.id, e);
      if (mounted) showAppSnack(context, l.ordersDetailExtraAdded(e.title));
    });
  }

  Future<void> _respond(Order o, bool accept) async {
    final l = context.l10n;
    final orders = context.read<OrdersController>();
    await _run(() async {
      await orders.respond(o.id, accept: accept);
      if (mounted) showAppSnack(context, accept ? l.ordersDetailRequestAccepted : l.ordersDetailRequestDeclined);
    });
  }

  Future<void> _approve(Order o) async {
    final l = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l.ordersDetailApproveTitle,
      message: l.ordersDetailApproveMessage,
      confirmLabel: l.commonAgree,
    );
    if (!ok || !mounted) return;
    final orders = context.read<OrdersController>();
    await _run(() async {
      await orders.approve(o.id);
      if (!mounted) return;
      showAppSnack(context, l.ordersDetailCompletedSnack);
      context.push('/orders/${o.id}/rate');
    });
  }

  Future<void> _notReady(Order o) async {
    final v = await showNotReadySheet(context);
    if (!mounted || v == null) return;
    if (v == 'revision') await _revision(o);
    if (v == 'time') await _moreTime(o);
    if (v == 'resolution' && mounted) context.push('/orders/${o.id}/resolution');
  }

  Future<void> _revision(Order o) async {
    final l = context.l10n;
    final msg = await showMessageSheet(
      context,
      title: l.ordersDetailRequestRevision,
      subtitle: l.ordersDetailRevisionSubtitle,
      hint: l.ordersDetailRevisionHint,
      submitLabel: l.ordersDetailSendRequest,
      fieldKey: const ValueKey('revision_field'),
      submitKey: const ValueKey('revision_submit'),
    );
    if (msg == null || !mounted) return;
    final orders = context.read<OrdersController>();
    await _run(() async {
      await orders.requestRevision(o.id, msg);
      if (mounted) showAppSnack(context, l.ordersDetailRevisionSent);
    });
  }

  Future<void> _moreTime(Order o) async {
    final l = context.l10n;
    final picked = await showMoreTimeSheet(context, base: o.reviewDeadline ?? DateTime.now());
    if (picked == null || !mounted) return;
    final orders = context.read<OrdersController>();
    await _run(() async {
      await orders.extendReview(o.id, picked);
      if (mounted) showAppSnack(context, l.ordersDetailReviewExtended(picked));
    });
  }

  // ------------------------------------------------------------ giao diện
  @override
  Widget build(BuildContext context) => FutureBuilder<OrderBundle?>(
    future: _future,
    builder: (context, snap) {
      final l = context.l10n;
      final title = snap.data == null ? l.navOrders : otherName(l, snap.data!);
      return Scaffold(
        appBar: SimpleAppBar(
          title: title,
          actions: [
            if (snap.data != null)
              IconButton(
                key: const ValueKey('order_more'),
                tooltip: l.ordersOptions,
                onPressed: () => _menu(snap.data!),
                icon: const Icon(Icons.more_horiz_rounded),
              ),
          ],
        ),
        body: OrderBundleView(orderId: widget.orderId, future: _future, builder: (context, b) => _body(b)),
      );
    },
  );

  Widget _body(OrderBundle b) {
    final l = context.l10n;
    final o = b.order;
    final me = context.watch<SessionController>().userId;
    final seller = o.sellerId == me;
    final justPlaced = !seller && DateTime.now().difference(o.createdAt).inMinutes < 3 && !_hideThanks;
    final gigExtras = b.gig?.extras ?? const <GigExtra>[];
    final showExtras =
        !seller &&
        !_hideExtras &&
        gigExtras.isNotEmpty &&
        (o.status == OrderStatus.inProgress || o.status == OrderStatus.awaitingRequirements);

    final children = <Widget>[
      if (justPlaced)
        OrderThanksBanner(key: const ValueKey('thanks_banner'), onClose: () => setState(() => _hideThanks = true)),
      Padding(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 0),
        child: OrderHeaderCard(order: o, onTap: () => context.push('/gig/${o.gigId}')),
      ),
      if (_busy) const LinearProgressIndicator(minHeight: 2),
      if (o.status == OrderStatus.awaitingRequirements)
        OrderRequirementsBanner(seller: seller, onSubmit: () => context.push('/orders/${o.id}/requirements')),
      if (seller && _canDeliver(o))
        OrderSellerActions(
          onDeliver: () => context.push('/orders/${o.id}/deliver'),
          onMessage: () => context.push('/contact/${o.buyerId}'),
          onExtend: () => context.push('/orders/${o.id}/resolution'),
        ),
      if (showExtras)
        OrderExtrasStrip(
          order: o,
          extras: gigExtras,
          busy: _busy,
          onAdd: (e) => _addExtra(o, e),
          onClose: () => setState(() => _hideExtras = true),
        ),
      if (o.pendingRequest != null)
        OrderPendingRequestBlock(bundle: b, seller: seller, busy: _busy, onRespond: (accept) => _respond(o, accept)),
      if (o.status == OrderStatus.delivered)
        OrderDeliveryBlock(
          order: o,
          seller: seller,
          busy: _busy,
          onApprove: () => _approve(o),
          onNotReady: () => _notReady(o),
        ),
      if (o.status == OrderStatus.completed)
        OrderCompletedBlock(bundle: b, seller: seller, onRate: () => context.push('/orders/${o.id}/rate')),
      if (o.status == OrderStatus.cancelled) const OrderCancelledBlock(),
      Gaps.v8,
      OrderTimeline(
        order: o,
        remind: _remind,
        onRemind: () {
          setState(() => _remind = !_remind);
          showAppSnack(context, _remind ? l.ordersDetailRemindOn : l.ordersDetailRemindOff);
        },
      ),
    ];

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => context.read<OrdersController>().fetch(o.id),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: Insets.tabBottom,
            children: children,
          ),
        ),
        Positioned(
          right: Space.lg,
          bottom: Space.lg + MediaQuery.paddingOf(context).bottom,
          child: FloatingChatButton(
            key: const ValueKey('order_chat'),
            seed: b.other?.avatarSeed ?? 0,
            name: otherName(l, b),
            onPressed: () => context.push('/contact/${seller ? o.buyerId : o.sellerId}'),
          ),
        ),
      ],
    );
  }
}
