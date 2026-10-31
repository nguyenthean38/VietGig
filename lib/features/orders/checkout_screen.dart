import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/order.dart';
import '../../data/repositories/repositories.dart';
import 'widgets/order_widgets.dart';

/// Bước "Nâng cấp": chọn dịch vụ thêm trước khi xem lại đơn hàng.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.gigId, this.packageIndex = 0});
  final String gigId;
  final int packageIndex;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final Future<Gig?> _gig;
  late int _pkg = widget.packageIndex;
  final Set<String> _selected = {};
  final Map<String, int> _qty = {};

  @override
  void initState() {
    super.initState();
    _gig = context.read<CatalogRepository>().gigById(widget.gigId);
  }

  /// Dịch vụ giao nhanh (rút ngắn thời gian) không có số lượng.
  bool _hasQty(GigExtra e) => e.extraDays >= 0;

  int _subtotal(Gig g) {
    var t = g.packages[_pkg].price;
    for (final e in g.extras) {
      if (_selected.contains(e.id)) t += e.price * (_qty[e.id] ?? 1);
    }
    return t;
  }

  int _days(Gig g) {
    var d = g.packages[_pkg].deliveryDays;
    for (final e in g.extras) {
      if (_selected.contains(e.id)) d += e.extraDays * (_qty[e.id] ?? 1);
    }
    return d < 1 ? 1 : d;
  }

  void _toggle(GigExtra e) => setState(() {
    if (_selected.remove(e.id)) {
      _qty.remove(e.id);
    } else {
      _selected.add(e.id);
      _qty[e.id] = 1;
    }
  });

  void _continue(Gig g) {
    context.push(
      '/checkout/${g.id}/review',
      extra: CheckoutDraft(
        gigId: g.id,
        packageIndex: _pkg,
        extraIds: {..._selected},
        extraQuantities: {for (final id in _selected) id: _qty[id] ?? 1},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(title: l.ordersCheckoutTitle),
      body: AsyncView<Gig?>(
        future: _gig,
        builder: (context, gig) {
          if (gig == null || gig.packages.isEmpty) {
            return EmptyState(
              icon: Icons.search_off_rounded,
              title: l.ordersCheckoutGigNotFoundTitle,
              message: l.ordersCheckoutGigNotFoundMessage,
              actionLabel: l.ordersCheckoutExploreOther,
              onAction: () => context.go('/search'),
            );
          }
          _pkg = _pkg.clamp(0, gig.packages.length - 1);
          return _body(gig);
        },
      ),
    );
  }

  Widget _body(Gig gig) {
    final l = context.l10n;
    final cs = context.colors;
    final pkg = gig.packages[_pkg];
    final total = _subtotal(gig);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
            children: [
              GigThumbRow(seed: gig.imageSeeds.first, label: gig.imageLabel, title: gig.title),
              BlockTitle(l.ordersCheckoutSelectedPackage),
              if (gig.packages.length > 1) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < gig.packages.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: Space.sm),
                          child: SelectChip(
                            key: ValueKey('pkg_$i'),
                            label: gig.packages[i].tier,
                            selected: i == _pkg,
                            onTap: () => setState(() => _pkg = i),
                          ),
                        ),
                    ],
                  ),
                ),
                Gaps.v12,
              ],
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${pkg.tier} · ${pkg.title}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                        Gaps.h8,
                        Text(Fmt.money(pkg.price), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      ],
                    ),
                    Gaps.v6,
                    Text(pkg.description, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13.5)),
                    Gaps.v10,
                    Wrap(
                      spacing: Space.lg,
                      runSpacing: 6,
                      children: [
                        _meta(Icons.schedule_rounded, l.ordersCheckoutDeliveryIn(pkg.deliveryDays)),
                        _meta(Icons.replay_rounded, l.ordersCheckoutRevisions(pkg.revisionsLocalized(l))),
                      ],
                    ),
                  ],
                ),
              ),
              BlockTitle(l.ordersCheckoutAddExtras),
              if (gig.extras.isEmpty)
                Text(l.ordersCheckoutNoExtras, style: TextStyle(color: cs.onSurfaceVariant))
              else
                for (final e in gig.extras) _extraTile(e),
            ],
          ),
        ),
        BottomActionBar(
          note: Text(l.ordersCheckoutEstimatedDelivery(_days(gig)), style: context.textTheme.bodySmall),
          child: PrimaryButton(
            key: const ValueKey('checkout_continue'),
            label: l.ordersCheckoutContinue(Fmt.money(total)),
            onPressed: () => _continue(gig),
          ),
        ),
      ],
    );
  }

  Widget _meta(IconData i, String t) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(i, size: 16),
      Gaps.h6,
      Flexible(
        child: Text(
          t,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );

  Widget _extraTile(GigExtra e) {
    final l = context.l10n;
    final cs = context.colors;
    final on = _selected.contains(e.id);
    final days = e.extraDays == 0
        ? l.ordersCheckoutNoExtraTime
        : e.extraDays > 0
        ? l.ordersCheckoutExtraDays(e.extraDays)
        : l.ordersCheckoutFasterDays(-e.extraDays);
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: Column(
        children: [
          InkWell(
            key: ValueKey('extra_${e.id}'),
            onTap: () => _toggle(e),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  CheckDot(selected: on),
                  Gaps.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.title, style: const TextStyle(fontSize: 15)),
                        Gaps.v2,
                        Text(days, style: context.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Gaps.h8,
                  Text('+${Fmt.money(e.price)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          if (on && _hasQty(e))
            Padding(
              padding: const EdgeInsets.only(left: 34, bottom: Space.md),
              child: Row(
                children: [
                  Expanded(child: Text(l.ordersCheckoutQuantity, style: const TextStyle(fontSize: 14))),
                  QtyStepper(
                    keyPrefix: 'qty_${e.id}',
                    value: _qty[e.id] ?? 1,
                    onChanged: (v) => setState(() => _qty[e.id] = v),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
