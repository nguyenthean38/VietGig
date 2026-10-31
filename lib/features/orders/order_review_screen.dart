import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/mock/mock_repositories.dart';
import '../../data/models/catalog.dart';
import '../../data/models/chat.dart';
import '../../data/models/order.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import 'widgets/order_widgets.dart';

/// Dòng chi tiết trong đơn.
class _Line {
  const _Line(this.title, this.price);
  final String title;
  final int price;
}

/// "Xem lại đơn hàng" + thanh toán.
class OrderReviewScreen extends StatefulWidget {
  const OrderReviewScreen({super.key, required this.gigId, this.draft, this.offer});
  final String gigId;
  final CheckoutDraft? draft;
  final CustomOffer? offer;

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  late final Future<Gig?> _gig;
  PaymentMethod _method = PaymentMethod.card;
  bool _cardAdded = false;
  String? _promo;
  bool _processing = false;

  CheckoutDraft get _draft => widget.draft ?? CheckoutDraft(gigId: widget.gigId, packageIndex: 0);

  @override
  void initState() {
    super.initState();
    _gig = context.read<CatalogRepository>().gigById(widget.offer?.gigId ?? widget.gigId);
  }

  // ------------------------------------------------ tính tiền
  ({String title, List<String> features, List<_Line> extras, int subtotal, int days}) _summary(Gig? gig) {
    final l = context.l10n;
    final offer = widget.offer;
    if (offer != null) {
      return (
        title: offer.title,
        features: [
          if (offer.isMilestone)
            ...offer.milestones.map((m) => '${m.title} – ${Fmt.money(m.price)}')
          else
            ...offer.serviceOptions,
          l.ordersCheckoutRevisions('${offer.revisions}'),
        ],
        extras: const [],
        subtotal: offer.isMilestone ? offer.milestones.first.price : offer.totalPrice,
        days: offer.totalDays,
      );
    }
    final g = gig!;
    final pkg = g.packages[_draft.packageIndex.clamp(0, g.packages.length - 1)];
    var subtotal = pkg.price;
    var days = pkg.deliveryDays;
    final extras = <_Line>[];
    for (final e in g.extras) {
      if (!_draft.extraIds.contains(e.id)) continue;
      final q = _draft.extraQuantities[e.id] ?? 1;
      subtotal += e.price * q;
      days += e.extraDays * q;
      extras.add(_Line(q > 1 ? '${e.title} x$q' : e.title, e.price * q));
    }
    return (
      title: '${pkg.tier} · ${pkg.title}',
      features: [
        for (final f in pkg.features.entries)
          if (f.value.isNotEmpty) f.value == '✓' ? f.key : '${f.key}: ${f.value}',
        l.ordersCheckoutRevisions(pkg.revisionsLocalized(l)),
        l.ordersCheckoutDeliveryIn(pkg.deliveryDays),
      ],
      extras: extras,
      subtotal: subtotal,
      days: days < 1 ? 1 : days,
    );
  }

  // ------------------------------------------------ hành động
  Future<void> _enterPromo() async {
    final l = context.l10n;
    final code = await showTextInputDialog(
      context,
      title: l.ordersReviewPromoTitle,
      hint: l.ordersReviewPromoHint,
      initial: _promo ?? '',
      textCapitalization: TextCapitalization.characters,
      fieldKey: const ValueKey('promo_field'),
      confirmKey: const ValueKey('promo_apply'),
      validate: (v) => v.isEmpty
          ? l.ordersReviewPromoEmpty
          : v.toUpperCase() == 'VIETGIG10'
          ? null
          : l.ordersReviewPromoInvalid,
    );
    if (code != null && mounted) {
      setState(() => _promo = code.toUpperCase());
      showAppSnack(context, context.l10n.ordersReviewPromoApplied(_promo!));
    }
  }

  Future<void> _addCard() async {
    final ok = await context.push<bool>('/add-card');
    if (ok == true && mounted) {
      setState(() => _cardAdded = true);
      showAppSnack(context, context.l10n.ordersReviewCardAdded);
    }
  }

  Future<void> _pay(Gig? gig) async {
    final orders = context.read<OrdersController>();
    setState(() => _processing = true);
    Order order;
    try {
      final results = await Future.wait<Object?>([
        widget.offer != null
            ? orders.placeOffer(widget.offer!)
            : orders.place(gig: gig!, draft: _draft, paymentMethod: _method.storedValue),
        Future<void>.delayed(const Duration(milliseconds: 900)),
      ]);
      order = results.first! as Order;
    } catch (e) {
      if (!mounted) return;
      setState(() => _processing = false);
      showAppSnack(context, context.l10n.ordersReviewPayFailed('$e'), success: false);
      return;
    }
    if (!mounted) return;
    setState(() => _processing = false);
    await showOrderPlacedDialog(context, order);
    if (!mounted) return;
    final router = GoRouter.of(context);
    router.go('/orders/${order.id}');
    if (order.status == OrderStatus.awaitingRequirements) {
      router.push('/orders/${order.id}/requirements');
    }
  }

  // ------------------------------------------------ giao diện
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final page = Scaffold(
      appBar: SimpleAppBar(title: l.ordersReviewTitle),
      body: AsyncView<Gig?>(
        future: _gig,
        builder: (context, gig) {
          if (widget.offer == null && (gig == null || gig.packages.isEmpty)) {
            return EmptyState(
              icon: Icons.search_off_rounded,
              title: l.ordersCheckoutGigNotFoundTitle,
              message: l.ordersCheckoutGigNotFoundMessage,
              actionLabel: l.commonBack,
              onAction: () => context.canPop() ? context.pop() : context.go('/home'),
            );
          }
          return _body(gig);
        },
      ),
    );
    return Stack(
      children: [
        page,
        if (_processing) const Positioned.fill(child: OrderProcessingView()),
      ],
    );
  }

  Widget _body(Gig? gig) {
    final l = context.l10n;
    final cs = context.colors;
    final s = _summary(gig);
    final fee = MockOrderRepository.serviceFeeFor(s.subtotal);
    final discount = _promo == null ? 0 : (s.subtotal * 0.1).round();
    final total = s.subtotal + fee - discount;
    final due = DateTime.now().add(Duration(days: s.days));
    final needCard = _method == PaymentMethod.card && !_cardAdded;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
            children: [
              GigThumbRow(
                seed: gig?.imageSeeds.first ?? 0,
                label: gig?.imageLabel ?? '',
                title: gig?.title ?? s.title,
                subtitle: widget.offer != null ? l.ordersReviewCustomOffer : null,
              ),
              BlockTitle(l.ordersReviewPaymentMethod),
              for (final m in PaymentMethod.values)
                RadioRow(
                  key: ValueKey('method_${m.index}'),
                  label: m.localized(l),
                  selected: _method == m,
                  onTap: () => setState(() => _method = m),
                  leading: PaymentMethodBadge(m),
                  subtitle: m == PaymentMethod.card && _cardAdded ? l.ordersReviewCardSaved : null,
                ),
              const Divider(height: Space.xxl),
              CollapsibleSection(
                title: l.ordersReviewOrderDetails,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Text(Fmt.money(s.subtotal - s.extras.fold(0, (a, e) => a + e.price))),
                      ],
                    ),
                    Gaps.v6,
                    for (final f in s.features) FeatureLine(f),
                    if (s.extras.isNotEmpty) ...[
                      Gaps.v10,
                      Text(l.ordersReviewExtras, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Gaps.v4,
                      for (final e in s.extras) FeatureLine(e.title, trailing: Fmt.money(e.price)),
                    ],
                    Gaps.v8,
                  ],
                ),
              ),
              const Divider(height: Space.md),
              CollapsibleSection(
                title: l.ordersReviewSummary,
                child: Column(
                  children: [
                    SummaryRow(l.ordersInfoSubtotal, Fmt.money(s.subtotal)),
                    SummaryRow(
                      l.ordersInfoServiceFee,
                      Fmt.money(fee),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(Fmt.money(fee)),
                          Gaps.h4,
                          Tooltip(
                            message: l.ordersReviewFeeTooltip,
                            triggerMode: TooltipTriggerMode.tap,
                            child: Icon(Icons.info_outline_rounded, size: 16, color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    SummaryRow(
                      l.ordersReviewPromoTitle,
                      '',
                      trailing: _promo == null
                          ? InkWell(
                              key: const ValueKey('promo_enter'),
                              onTap: _enterPromo,
                              child: Text(
                                l.ordersReviewEnterCode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$_promo  −${Fmt.money(discount)}',
                                  style: TextStyle(color: context.tokens.brand, fontWeight: FontWeight.w600),
                                ),
                                InkWell(
                                  onTap: () => setState(() => _promo = null),
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Icon(Icons.close_rounded, size: 16),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const Divider(height: 18),
                    SummaryRow(l.ordersReviewTotal, Fmt.money(total), bold: true),
                    SummaryRow(l.ordersReviewEstimatedDelivery, '${Fmt.weekday(due)}, ${Fmt.date(due)}'),
                  ],
                ),
              ),
              Gaps.v16,
              Text(l.ordersReviewTerms, textAlign: TextAlign.center, style: context.textTheme.bodySmall),
            ],
          ),
        ),
        BottomActionBar(
          note: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_outlined, size: 15, color: cs.onSurfaceVariant),
              Gaps.h6,
              Flexible(child: Text(l.ordersReviewSecure, style: context.textTheme.bodySmall)),
            ],
          ),
          child: needCard
              ? PrimaryButton(
                  key: const ValueKey('add_payment_method'),
                  icon: Icons.lock_rounded,
                  label: l.ordersReviewAddPayment,
                  onPressed: _addCard,
                )
              : PrimaryButton(
                  key: const ValueKey('pay_button'),
                  icon: Icons.lock_rounded,
                  label: l.ordersReviewPay(Fmt.money(total)),
                  onPressed: () => _pay(gig),
                ),
        ),
      ],
    );
  }
}
