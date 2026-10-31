import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/order.dart';
import '../widgets/order_widgets.dart';

/// Các mục có thể mở từ menu Trung tâm giải quyết.
enum ResolutionView { menu, update, extend, cancel }

/// Màn hình menu của Trung tâm giải quyết.
class ResolutionMenu extends StatelessWidget {
  const ResolutionMenu({super.key, required this.bundle, required this.seller, required this.onOpen});
  final OrderBundle bundle;
  final bool seller;
  final ValueChanged<ResolutionView> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final o = bundle.order;
    final disputed = o.pendingRequest != null || o.status == OrderStatus.disputed;
    final cs = context.colors;
    final t = context.tokens;
    const heading = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
    final children = <Widget>[OrderHeaderCard(order: o), Gaps.v20];
    if (disputed) {
      final r = o.pendingRequest;
      children.addAll([
        Text(l.ordersResolutionDisputeTitle, key: const ValueKey('dispute_in_progress'), style: heading),
        Gaps.v8,
        Text(l.ordersResolutionDisputeBody, style: TextStyle(color: cs.onSurfaceVariant, height: 1.4)),
        if (r != null) ...[
          Gaps.v12,
          AppCard(
            color: t.warningSoft,
            borderColor: t.warning.withValues(alpha: 0.4),
            child: Text(
              l.ordersResolutionPendingLine(
                r.kind == 'cancel' ? l.ordersResolutionPendingCancel : l.ordersResolutionPendingExtend(r.extraDays),
                Fmt.dateTime(r.at),
              ),
              style: TextStyle(color: cs.onSurface, fontSize: 13.5),
            ),
          ),
        ],
      ]);
    } else if (!o.status.isActive) {
      children.addAll([
        Text(
          o.status == OrderStatus.completed ? l.ordersResolutionCompleted : l.ordersResolutionCancelled,
          style: heading,
        ),
        Gaps.v8,
        Text(l.ordersResolutionEndedBody, style: TextStyle(color: cs.onSurfaceVariant, height: 1.4)),
      ]);
    } else {
      children.addAll([
        Text(l.ordersResolutionWelcome, style: heading),
        Gaps.v6,
        Text(l.ordersResolutionWelcomeBody, style: TextStyle(color: cs.onSurfaceVariant)),
        BlockTitle(l.ordersResolutionHowHelp),
        if (!seller)
          MenuTile(
            key: const ValueKey('res_update'),
            icon: Icons.update_rounded,
            title: l.ordersResolutionMenuUpdate,
            onTap: () => onOpen(ResolutionView.update),
          ),
        if (seller || o.status == OrderStatus.inProgress)
          MenuTile(
            key: const ValueKey('res_extend'),
            icon: Icons.more_time_rounded,
            title: l.ordersResolutionExtendTitle,
            onTap: () => onOpen(ResolutionView.extend),
          ),
        if (!seller)
          MenuTile(
            key: const ValueKey('res_cancel'),
            icon: Icons.cancel_outlined,
            title: l.ordersResolutionCancelTitle,
            onTap: () => onOpen(ResolutionView.cancel),
          ),
        if (seller)
          MenuTile(
            key: const ValueKey('res_message_buyer'),
            icon: Icons.chat_bubble_outline_rounded,
            title: l.ordersResolutionMenuMessageBuyer,
            onTap: () => context.push('/contact/${o.buyerId}'),
          ),
      ]);
    }
    children.addAll([
      const _SupportLink(),
      Gaps.v16,
      CollapsibleSection(
        title: l.ordersResolutionOrderInfo,
        icon: Icons.receipt_long_outlined,
        initiallyExpanded: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: Space.md),
          child: OrderInfoTable(order: o),
        ),
      ),
    ]);
    return ListView(padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxxl), children: children);
  }
}

class _SupportLink extends StatelessWidget {
  const _SupportLink();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Space.lg),
    child: InkWell(
      key: const ValueKey('contact_support'),
      onTap: () => context.push('/support'),
      child: Text.rich(
        TextSpan(
          text: context.l10n.ordersResolutionSupportPrompt,
          children: [
            TextSpan(
              text: context.l10n.ordersResolutionSupportLink,
              style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
            ),
          ],
          style: context.textTheme.bodyMedium,
        ),
      ),
    ),
  );
}
