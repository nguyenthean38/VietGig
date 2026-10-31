import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/account.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import 'widgets/seller_widgets.dart';

/// Khoảng thời gian xem thống kê.
enum EarningsRange { last30, last3Months, thisYear, lastYear }

extension on EarningsRange {
  String localized(AppLocalizations l) => switch (this) {
    EarningsRange.last30 => l.sellerRangeLast30,
    EarningsRange.last3Months => l.sellerRangeLast3Months,
    EarningsRange.thisYear => l.sellerRangeThisYear,
    EarningsRange.lastYear => l.sellerRangeLastYear,
  };
}

enum _Method { bank, momo }

/// Thu nhập của người bán.
class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  late Future<SellerStats> _future;
  EarningsRange _range = EarningsRange.last30;
  int _tab = 0;

  /// Số tiền đã rút trong phiên (mock, chỉ lưu cục bộ).
  int _withdrawnNow = 0;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<SellerStats> _load() =>
      context.read<AccountRepository>().sellerStats(context.read<SessionController>().userId);

  // ---- Dữ liệu biểu đồ ----

  ({DateTime start, DateTime end}) _bounds(DateTime today) => switch (_range) {
    EarningsRange.last30 => (start: today.subtract(const Duration(days: 29)), end: today),
    EarningsRange.last3Months => (start: today.subtract(const Duration(days: 89)), end: today),
    EarningsRange.thisYear => (start: DateTime(today.year), end: today),
    EarningsRange.lastYear => (start: DateTime(today.year - 1), end: DateTime(today.year - 1, 12, 31)),
  };

  /// Chuỗi giá trị theo ngày trong khoảng đã chọn, gom nhóm nếu quá dài.
  ({List<int> values, List<String> labels, int total}) _series(
    SellerStats s,
    AppLocalizations l, {
    required bool orders,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final b = _bounds(today);
    final days = b.end.difference(b.start).inDays + 1;
    final daily = <int>[];
    for (var i = 0; i < days; i++) {
      final d = b.start.add(Duration(days: i));
      final back = today.difference(d).inDays; // 0 = hôm nay
      final idx = s.dailyEarnings.length - 1 - back;
      final v = idx >= 0 && idx < s.dailyEarnings.length ? s.dailyEarnings[idx] : 0;
      daily.add(orders ? (v > 0 ? 1 : 0) : v);
    }
    final chunk = (days / 30).ceil().clamp(1, 1000);
    final values = <int>[];
    for (var i = 0; i < daily.length; i += chunk) {
      values.add(daily.sublist(i, (i + chunk).clamp(0, daily.length)).fold<int>(0, (a, b) => a + b));
    }
    final mid = b.start.add(Duration(days: days ~/ 2));
    final fmt = DateFormat(l.sellerChartDateFormat, l.localeName);
    return (
      values: values,
      labels: [fmt.format(b.start), fmt.format(mid), fmt.format(b.end)],
      total: daily.fold<int>(0, (a, b) => a + b),
    );
  }

  // ---- Hành động ----

  Future<void> _pickRange() async {
    final r = await showActionSheet<EarningsRange>(
      context,
      title: context.l10n.sellerEarningsPickRange,
      actions: [
        for (final e in EarningsRange.values)
          SheetAction(
            label: e.localized(context.l10n),
            value: e,
            icon: e == _range ? Icons.check_rounded : Icons.calendar_today_outlined,
          ),
      ],
    );
    if (r != null && mounted) setState(() => _range = r);
  }

  Future<void> _withdraw(int amount) async {
    final l = context.l10n;
    final method = await showActionSheet<_Method>(
      context,
      title: l.sellerEarningsWithdrawTo(Fmt.money(amount)),
      actions: [
        SheetAction(
          label: l.sellerEarningsBank,
          value: _Method.bank,
          icon: Icons.account_balance_outlined,
          subtitle: l.sellerEarningsBankSubtitle,
        ),
        SheetAction(
          label: l.sellerEarningsMomo,
          value: _Method.momo,
          icon: Icons.account_balance_wallet_outlined,
          subtitle: l.sellerEarningsMomoSubtitle,
        ),
      ],
    );
    if (method == null || !mounted) return;
    setState(() => _withdrawnNow += amount);
    final money = Fmt.money(amount);
    showAppSnack(context, switch (method) {
      _Method.bank => context.l10n.sellerEarningsSentBank(money),
      _Method.momo => context.l10n.sellerEarningsSentMomo(money),
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: SimpleAppBar(title: context.l10n.sellerEarnings),
    body: AsyncView<SellerStats>(
      future: _future,
      builder: (context, s) => RefreshIndicator(
        color: context.tokens.brand,
        onRefresh: () async {
          final f = _load();
          setState(() {
            _future = f;
          });
          await f;
        },
        child: _body(context, s),
      ),
    ),
  );

  Widget _section(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.lg, 28, Space.lg, Space.xs),
    child: Text(title, style: context.textTheme.titleLarge),
  );

  Widget _body(BuildContext context, SellerStats s) {
    final l = context.l10n;
    final cs = context.colors;
    final available = (s.availableForWithdrawal - _withdrawnNow).clamp(0, 1 << 40);
    final series = _series(s, l, orders: _tab == 1);
    final monthLabel = DateFormat(l.sellerMonthFormat, l.localeName).format(DateTime.now());

    void explain(String title, String body) => showExplainSheet(context, title: title, body: body);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: Space.xxxl),
      children: [
        Gaps.v12,
        Center(
          child: Text(
            Fmt.money(available),
            key: const ValueKey('earnings_available'),
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: context.tokens.brand),
          ),
        ),
        Gaps.v4,
        Center(
          child: Text(l.sellerAvailable, style: TextStyle(color: cs.onSurfaceVariant)),
        ),
        const SizedBox(height: 14),
        Center(
          child: SizedBox(
            width: 200,
            child: FilledButton.icon(
              key: const ValueKey('earnings_withdraw'),
              onPressed: available > 0 ? () => _withdraw(available) : null,
              icon: const Icon(Icons.north_east_rounded, size: 18),
              label: Text(l.sellerEarningsWithdraw),
            ),
          ),
        ),
        if (available == 0)
          Padding(
            padding: const EdgeInsets.only(top: Space.sm),
            child: Center(child: Text(l.sellerEarningsNothing, style: context.textTheme.bodySmall)),
          ),
        // ---- Tổng quan ----
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, 28, Space.sm, Space.sm),
          child: Row(
            children: [
              Expanded(child: Text(l.sellerEarningsOverview, style: context.textTheme.titleLarge)),
              TextButton.icon(
                key: const ValueKey('earnings_range'),
                onPressed: _pickRange,
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                label: Text(_range.localized(l), style: const TextStyle(decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
        Padding(
          padding: Insets.page,
          child: Row(
            children: [
              for (final (i, t) in [l.sellerEarnings, l.sellerEarningsCompleted].indexed)
                Expanded(
                  child: _TabButton(index: i, label: t, selected: _tab == i, onTap: () => setState(() => _tab = i)),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.xs),
          child: Text(
            _tab == 0 ? l.sellerEarningsTotal(Fmt.money(series.total)) : l.sellerEarningsTotalOrders(series.total),
            key: const ValueKey('earnings_range_total'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.md, Space.sm, Space.lg, 0),
          child: LineChart(
            key: ValueKey('chart_${_range.name}_$_tab'),
            values: series.values,
            xLabels: series.labels,
            formatY: _tab == 0 ? (v) => Fmt.moneyShort(v) : (v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 1),
          ),
        ),
        // ---- Phân tích ----
        _section(context, l.sellerEarningsAnalytics),
        _ValueRow(label: l.sellerEarningsMonth(monthLabel), value: Fmt.money(s.earningsThisMonth)),
        _ValueRow(label: l.sellerEarningsAvgPrice, value: Fmt.money(s.avgSellingPrice)),
        _ValueRow(label: l.sellerActiveOrders, value: '${s.activeOrders} (${Fmt.money(s.activeOrdersValue)})'),
        _ValueRow(label: l.sellerAvailable, value: Fmt.money(available)),
        _ValueRow(
          label: l.sellerEarningsCompleted,
          value: '${s.completedOrders} (${Fmt.money(s.completedOrdersValue)})',
        ),
        // ---- Doanh thu ----
        _section(context, l.sellerEarningsRevenue),
        _ValueRow(
          label: l.sellerPaymentsClearing,
          value: Fmt.money(s.paymentsClearing),
          highlight: s.paymentsClearing > 0,
          onTap: () => explain(l.sellerPaymentsClearing, l.sellerEarningsClearingInfo),
        ),
        _ValueRow(
          label: l.sellerEarningsToDate,
          value: Fmt.money(s.earningsToDate),
          onTap: () => explain(l.sellerEarningsToDate, l.sellerEarningsToDateInfo),
        ),
        _ValueRow(
          label: l.sellerEarningsExpenses,
          value: Fmt.money(s.expensesToDate),
          onTap: () => explain(l.sellerEarningsExpenses, l.sellerEarningsExpensesInfo),
        ),
        _ValueRow(
          label: l.sellerEarningsWithdrawn,
          value: Fmt.money(s.withdrawnToDate + _withdrawnNow),
          onTap: () => explain(l.sellerEarningsWithdrawn, l.sellerEarningsWithdrawnInfo),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.index, required this.label, required this.selected, required this.onTap});
  final int index;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      key: ValueKey('earnings_tab_$index'),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Space.md),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: selected ? cs.onSurface : cs.outlineVariant, width: selected ? 2 : 1),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? cs.onSurface : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value, this.onTap, this.highlight = false});
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
            Gaps.h12,
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.w600, color: highlight ? context.tokens.brand : null),
              ),
            ),
            if (onTap != null) Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
