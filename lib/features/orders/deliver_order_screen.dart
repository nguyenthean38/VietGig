import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/chat.dart';
import '../../data/models/order.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import 'widgets/order_widgets.dart';

/// Modal "Giao hàng" cho người bán.
class DeliverOrderScreen extends StatefulWidget {
  const DeliverOrderScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<DeliverOrderScreen> createState() => _DeliverOrderScreenState();
}

class _DeliverOrderScreenState extends State<DeliverOrderScreen> {
  late final Future<OrderBundle?> _future;
  final _message = TextEditingController();
  final List<FakeFile> _files = [];
  final List<Timer> _timers = [];
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _future = fetchOrderBundle(context, widget.orderId);
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _message.dispose();
    super.dispose();
  }

  bool get _uploading => _files.any((f) => f.uploading);

  Future<void> _attach() async {
    final src = await showAttachSheet(context);
    if (src == null || !mounted) return;
    final f = makeFakeFile(src, _files.length);
    setState(() => _files.add(f.withProgress(0)));
    late Timer t;
    t = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted) return t.cancel();
      final i = _files.indexWhere((e) => e.name == f.name);
      if (i < 0) return t.cancel();
      final p = (_files[i].progress + 0.15).clamp(0.0, 1.0);
      setState(() => _files[i] = _files[i].withProgress(p));
      if (p >= 1) t.cancel();
    });
    _timers.add(t);
  }

  Future<void> _quickResponse() async {
    final inbox = context.read<InboxController>();
    final list = await inbox.quickResponses();
    if (!mounted) return;
    if (list.isEmpty) {
      showAppSnack(context, context.l10n.ordersDeliverNoQuickResponses, success: false);
      return;
    }
    final picked = await showModalBottomSheet<QuickResponse>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.sm),
                child: Text(ctx.l10n.ordersDeliverQuickResponses, style: ctx.textTheme.titleMedium),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final q in list)
                      ListTile(
                        key: ValueKey('qr_${q.id}'),
                        leading: const Icon(Icons.bolt_rounded),
                        title: Text(q.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(q.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                        onTap: () => Navigator.pop(ctx, q),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked == null || !mounted) return;
    final cur = _message.text;
    _message.text = cur.trim().isEmpty ? picked.body : '$cur\n${picked.body}';
    setState(() {});
  }

  Future<void> _send(Order o) async {
    setState(() => _sending = true);
    try {
      await context.read<OrdersController>().deliver(
        o.id,
        Delivery(message: _message.text.trim(), files: _files.map((f) => f.name).toList(), at: DateTime.now()),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _sending = false);
        showAppSnack(context, context.l10n.ordersDeliverSendError('$e'), success: false);
      }
      return;
    }
    if (!mounted) return;
    showAppSnack(context, context.l10n.ordersDeliverSent);
    context.pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: SimpleAppBar(title: context.l10n.ordersDeliverTitle, close: true),
    body: OrderBundleView(
      orderId: widget.orderId,
      future: _future,
      builder: (context, b) {
        final o = b.order;
        final me = context.read<SessionController>().userId;
        if (o.sellerId != me) {
          return EmptyState(icon: Icons.lock_outline_rounded, title: context.l10n.ordersDeliverSellerOnly);
        }
        final ok = o.status == OrderStatus.inProgress || o.status == OrderStatus.revisionRequested;
        if (!ok && !_sending) {
          return EmptyState(
            icon: Icons.inventory_2_outlined,
            title: context.l10n.ordersDeliverUnavailable,
            message: context.l10n.ordersDeliverCurrentStatus(o.status.localized(context.l10n).toLowerCase()),
            actionLabel: context.l10n.ordersDeliverBackToOrder,
            onAction: () => context.canPop() ? context.pop() : context.go('/orders/${o.id}'),
          );
        }
        return _form(b);
      },
    ),
  );

  Widget _form(OrderBundle b) {
    final o = b.order;
    final l = context.l10n;
    final valid = _message.text.trim().length >= 10 && !_uploading;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
            children: [
              OrderHeaderCard(order: o),
              Padding(
                padding: const EdgeInsets.only(top: Space.xl, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.ordersDeliverMessageTo(otherName(l, b)),
                        style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('quick_response'),
                      tooltip: l.ordersDeliverInsertQuick,
                      onPressed: _quickResponse,
                      icon: const Icon(Icons.bolt_rounded),
                    ),
                  ],
                ),
              ),
              CountedTextField(
                fieldKey: const ValueKey('deliver_message'),
                controller: _message,
                maxLength: 2500,
                hint: l.ordersDeliverMessageHint,
                onChanged: (_) => setState(() {}),
              ),
              BlockTitle(l.ordersDeliverAttachments, padding: const EdgeInsets.only(top: Space.sm, bottom: 10)),
              for (var i = 0; i < _files.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: FileTile(
                    name: _files[i].name,
                    size: _files[i].size,
                    progress: _files[i].progress,
                    onRemove: () => setState(() => _files.removeAt(i)),
                  ),
                ),
              OutlinedButton.icon(
                key: const ValueKey('deliver_attach'),
                onPressed: _sending ? null : _attach,
                icon: const Icon(Icons.upload_file_rounded, size: 18),
                label: Text(_files.isEmpty ? l.ordersAttachTitle : l.ordersDeliverAttachMore),
              ),
              Gaps.v8,
              Text(l.ordersDeliverFileNote, style: context.textTheme.bodySmall),
            ],
          ),
        ),
        BottomActionBar(
          note: _uploading ? Text(l.ordersDeliverUploading, style: context.textTheme.bodySmall) : null,
          child: PrimaryButton(
            key: const ValueKey('deliver_submit'),
            label: l.ordersDeliverSubmit,
            loading: _sending,
            onPressed: valid ? () => _send(o) : null,
          ),
        ),
      ],
    );
  }
}
