import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/chat.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';

/// Chi tiết báo giá riêng (một lần hoặc theo cột mốc).
class OfferDetailScreen extends StatefulWidget {
  const OfferDetailScreen({super.key, required this.conversationId, required this.messageId});
  final String conversationId;
  final String messageId;

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

typedef _OfferData = ({CustomOffer? offer, Gig? gig});

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  late Future<_OfferData> _future;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_OfferData> _load() async {
    final inbox = context.read<InboxController>();
    final catalog = context.read<CatalogRepository>();
    final msgs = await inbox.messages(widget.conversationId);
    CustomOffer? offer;
    for (final m in msgs) {
      if (m.id == widget.messageId) offer = m.offer;
    }
    final gig = offer == null ? null : await catalog.gigById(offer.gigId);
    return (offer: offer, gig: gig);
  }

  Future<void> _withdraw() async {
    final l = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l.inboxWithdrawOfferTitle,
      message: l.inboxWithdrawOfferMessage,
      confirmLabel: l.inboxWithdraw,
      destructive: true,
    );
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    await context.read<InboxController>().updateOffer(widget.messageId, OfferStatus.withdrawn);
    if (!mounted) return;
    showAppSnack(context, l.inboxOfferWithdrawn);
    setState(() {
      _busy = false;
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final me = context.watch<SessionController>().userId;
    final l = context.l10n;
    return FutureBuilder<_OfferData>(
      future: _future,
      builder: (context, snap) {
        final offer = snap.data?.offer;
        final title = offer != null && offer.isMilestone ? l.inboxViewMilestoneOffer : l.inboxViewOffer;
        Widget body;
        Widget? bottom;
        if (snap.hasError) {
          body = EmptyState(
            icon: Icons.error_outline_rounded,
            title: l.commonErrorTitle,
            message: '${snap.error}',
            actionLabel: l.commonRetry,
            onAction: () => setState(() => _future = _load()),
          );
        } else if (snap.connectionState != ConnectionState.done) {
          body = const Center(child: CircularProgressIndicator());
        } else if (offer == null) {
          body = EmptyState(
            icon: Icons.request_quote_outlined,
            title: l.inboxOfferNotFound,
            message: l.inboxOfferNotFoundMessage,
          );
        } else {
          final expired =
              offer.status == OfferStatus.pending &&
              offer.expiresAt != null &&
              offer.expiresAt!.isBefore(DateTime.now());
          final status = expired ? OfferStatus.expired : offer.status;
          final isSeller = offer.sellerId == me;
          body = _OfferBody(offer: offer, gig: snap.data?.gig, status: status);
          if (status == OfferStatus.pending) {
            bottom = isSeller
                ? BottomActionBar(
                    child: OutlinedButton(
                      key: const ValueKey('offer_detail_withdraw'),
                      onPressed: _busy ? null : _withdraw,
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      child: Text(l.inboxWithdrawOffer),
                    ),
                  )
                : BottomActionBar(
                    note: offer.isMilestone
                        ? Text(
                            l.inboxFirstMilestoneCharge(Fmt.money(offer.milestones.first.price)),
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodySmall,
                          )
                        : null,
                    child: PrimaryButton(
                      key: const ValueKey('offer_checkout'),
                      label: l.inboxContinueCheckout,
                      onPressed: () => context.push('/checkout/${offer.gigId}/review', extra: offer),
                    ),
                  );
          }
        }
        return Scaffold(
          appBar: SimpleAppBar(title: title),
          body: body,
          bottomNavigationBar: bottom,
        );
      },
    );
  }
}

class _OfferBody extends StatelessWidget {
  const _OfferBody({required this.offer, required this.gig, required this.status});
  final CustomOffer offer;
  final Gig? gig;
  final OfferStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;
    final t = context.tokens;
    final l = context.l10n;

    Widget detail(IconData icon, String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 19, color: cs.onSurfaceVariant),
          Gaps.h10,
          Text('$label: ', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14)),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ],
      ),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
      children: [
        if (status != OfferStatus.pending)
          Container(
            margin: const EdgeInsets.only(bottom: Space.lg),
            padding: Insets.cardSm,
            decoration: BoxDecoration(
              color: status == OfferStatus.accepted ? t.brandSoft : t.dangerSoft,
              borderRadius: Radii.mdAll,
            ),
            child: Row(
              children: [
                Icon(
                  status == OfferStatus.accepted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                  color: status == OfferStatus.accepted ? t.brandStrong : t.danger,
                  size: 20,
                ),
                Gaps.h8,
                Expanded(
                  child: Text(
                    l.inboxOfferStatusBanner(status.localized(l).toLowerCase()),
                    style: TextStyle(color: context.colors.onSurface, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer.title, style: tt.titleLarge),
                  if (gig != null) ...[
                    Gaps.v4,
                    Text(gig!.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: tt.bodySmall),
                  ],
                ],
              ),
            ),
            Gaps.h12,
            PlaceholderImage(
              seed: gig == null || gig!.imageSeeds.isEmpty ? offer.gigId.hashCode : gig!.imageSeeds.first,
              label: gig?.imageLabel ?? '',
              width: 72,
              height: 54,
              radius: Space.sm,
            ),
          ],
        ),
        Gaps.v12,
        Text(offer.description, style: const TextStyle(fontSize: 14.5, height: 1.45)),
        Gaps.v24,
        Text(l.inboxOfferDetails, style: tt.titleMedium),
        Gaps.v12,
        detail(Icons.payments_outlined, l.inboxDetailPrice, Fmt.money(offer.totalPrice)),
        detail(Icons.schedule_rounded, l.inboxDetailTime, Fmt.days(offer.totalDays)),
        if (!offer.isMilestone) detail(Icons.autorenew_rounded, l.inboxDetailRevisions, '${offer.revisions}'),
        if (offer.expiresAt != null) detail(Icons.timer_outlined, l.inboxDetailExpires, Fmt.dateTime(offer.expiresAt!)),
        if (offer.requestRequirements)
          detail(Icons.assignment_outlined, l.inboxDetailRequirements, l.inboxDetailRequirementsValue),
        if (offer.serviceOptions.isNotEmpty) ...[
          Gaps.v12,
          Text(l.inboxIncludes, style: tt.titleMedium),
          Gaps.v8,
          for (final s in offer.serviceOptions)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, size: 18, color: t.brand),
                  Gaps.h8,
                  Expanded(child: Text(s)),
                ],
              ),
            ),
        ],
        if (offer.isMilestone) ...[
          Gaps.v16,
          Row(
            children: [
              Text(l.inboxMilestoneDetails, style: tt.titleMedium),
              Gaps.h6,
              Tooltip(
                message: l.inboxMilestoneTooltip,
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.help_outline_rounded, size: 18, color: cs.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < offer.milestones.length; i++)
            _MilestoneItem(index: i, milestone: offer.milestones[i], last: i == offer.milestones.length - 1),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(child: Text(l.inboxTotal, style: tt.titleMedium)),
              Text(
                Fmt.money(offer.totalPrice),
                key: const ValueKey('offer_total'),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _MilestoneItem extends StatelessWidget {
  const _MilestoneItem({required this.index, required this.milestone, required this.last});
  final int index;
  final Milestone milestone;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.onSurface, width: 1.5),
                ),
                child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              ),
              if (!last) Expanded(child: Container(width: 1.5, color: cs.outline)),
            ],
          ),
          Gaps.h12,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : Space.xl, top: Space.xxs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(milestone.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                  Gaps.v4,
                  Text(milestone.description, style: const TextStyle(fontSize: 13.5, height: 1.4)),
                  Gaps.v6,
                  Text(
                    context.l10n.inboxMilestoneLine(
                      milestone.deliveryDays,
                      Fmt.money(milestone.price),
                      milestone.revisions,
                    ),
                    style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
