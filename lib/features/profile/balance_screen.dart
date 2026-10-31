import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';

/// Số dư cá nhân: tiền từ đơn đã huỷ + credits.
class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});
  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  late Future<int> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<int> _load() => context.read<AccountRepository>().balance(context.read<SessionController>().userId);

  void _help() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) {
      final l = ctx.l10n;
      Widget item(String t, String d) => Padding(
        padding: const EdgeInsets.only(bottom: Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
            Gaps.v4,
            Text(d, style: ctx.textTheme.bodyMedium?.copyWith(height: 1.4)),
          ],
        ),
      );
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item(l.profileBalanceHelpEarningsTitle, l.profileBalanceHelpEarnings),
              item(l.profileBalanceHelpRefundTitle, l.profileBalanceHelpRefund),
              item(l.profileBalanceHelpCreditsTitle, l.profileBalanceHelpCredits),
              item(l.profileBalanceHelpPayTitle, l.profileBalanceHelpPay),
            ],
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget card(String label, int value) => AppCard(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.textTheme.bodySmall),
          Gaps.v6,
          Text(Fmt.money(value), style: context.textTheme.headlineSmall),
        ],
      ),
    );
    return Scaffold(
      appBar: SimpleAppBar(
        title: l.profilePersonalBalance,
        actions: [
          IconButton(
            key: const ValueKey('balance_help'),
            tooltip: l.profileBalanceExplain,
            onPressed: _help,
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
      body: AsyncView<int>(
        future: _future,
        builder: (context, balance) => RefreshIndicator(
          onRefresh: () async {
            final f = _load();
            setState(() => _future = f);
            await f;
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.xxl),
            children: [
              Text(l.profileBalanceVietGig, style: context.textTheme.titleLarge),
              card(l.profileBalanceFromCancelled, balance),
              Gaps.v24,
              Text(l.profileBalanceCreditsVietGig, style: context.textTheme.titleLarge),
              card(l.profileBalanceCredits, 0),
              const SizedBox(height: 18),
              Text(l.profileBalanceMoreCredits, style: context.textTheme.bodyMedium),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () => context.push('/invite'),
                  child: Text(l.profileBalanceGetCredits, style: const TextStyle(decoration: TextDecoration.underline)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
