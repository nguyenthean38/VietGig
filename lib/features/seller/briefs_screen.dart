import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/account.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import 'widgets/brief_prefs_sheet.dart';

/// Danh sách brief phù hợp + phản hồi đã gửi.
class BriefsScreen extends StatefulWidget {
  const BriefsScreen({super.key});

  @override
  State<BriefsScreen> createState() => _BriefsScreenState();
}

class _BriefsScreenState extends State<BriefsScreen> {
  late Future<List<Brief>> _future;
  BriefPrefs _prefs = const BriefPrefs();
  bool _introDismissed = false;
  final List<Brief> _sent = [];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Brief>> _load() => context.read<AccountRepository>().briefs(context.read<SessionController>().userId);

  Future<void> _openPrefs() async {
    final r = await showModalBottomSheet<BriefPrefs>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BriefPrefsSheet(initial: _prefs),
    );
    if (r == null || !mounted) return;
    setState(() => _prefs = r);
    showAppSnack(context, context.l10n.sellerBriefsPrefsUpdated);
  }

  Future<void> _more() async {
    final v = await showActionSheet<String>(
      context,
      actions: [SheetAction(label: context.l10n.sellerBriefsPrefs, value: 'prefs', icon: Icons.tune_rounded)],
    );
    if (v == 'prefs') await _openPrefs();
  }

  void _respond(Brief b) {
    setState(() => _sent.insert(0, b));
    showAppSnack(context, context.l10n.sellerBriefsResponded(b.title));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: SimpleAppBar(
          title: l.sellerBriefsTitle,
          actions: [
            CircleIconButton(
              key: const ValueKey('briefs_help'),
              icon: Icons.help_outline_rounded,
              tooltip: l.sellerBriefsWhat,
              onPressed: () =>
                  infoDialog(context, title: l.sellerBriefsWhat, message: l.sellerBriefsWhatBody, ok: l.sellerGotIt),
            ),
            Gaps.h8,
            CircleIconButton(
              key: const ValueKey('briefs_more'),
              icon: Icons.more_horiz_rounded,
              tooltip: l.sellerOptions,
              onPressed: _more,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l.sellerBriefsTabMatches),
              Tab(text: l.sellerBriefsTabSent),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AsyncView<List<Brief>>(future: _future, builder: _matches),
            _sent.isEmpty
                ? EmptyState(
                    icon: Icons.send_outlined,
                    title: l.sellerBriefsSentEmptyTitle,
                    message: l.sellerBriefsSentEmptyMessage,
                  )
                : ListView(
                    padding: Insets.pageAll,
                    children: [for (final b in _sent) _BriefCard(brief: b, sent: true)],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _matches(BuildContext context, List<Brief> briefs) {
    final l = context.l10n;
    final visible = !_prefs.receive
        ? <Brief>[]
        : briefs
              .where((b) => _prefs.minPrice == null || b.budget >= _prefs.minPrice!)
              .where((b) => !_sent.contains(b))
              .toList();
    return RefreshIndicator(
      color: context.tokens.brand,
      onRefresh: () async {
        final f = _load();
        setState(() {
          _future = f;
        });
        await f;
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: Insets.pageAll,
        children: [
          if (!_introDismissed) _IntroCard(onNext: () => setState(() => _introDismissed = true)),
          if (!_prefs.receive)
            EmptyState(
              icon: Icons.notifications_off_outlined,
              title: l.sellerBriefsOffTitle,
              message: l.sellerBriefsOffMessage,
              actionLabel: l.sellerBriefsOffAction,
              onAction: _openPrefs,
            )
          else if (visible.isEmpty)
            EmptyState(
              icon: Icons.description_outlined,
              title: l.sellerBriefsEmptyTitle,
              message: l.sellerBriefsEmptyMessage,
            )
          else
            for (final b in visible) _BriefCard(brief: b, onRespond: () => _respond(b)),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      margin: const EdgeInsets.only(bottom: Space.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.sellerBriefsIntroTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xxs),
                decoration: BoxDecoration(color: context.tokens.badge, borderRadius: Radii.mdAll),
                child: Text(
                  l.sellerBriefsNewBadge,
                  style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          Gaps.v6,
          Text(l.sellerBriefsIntroBody, style: context.textTheme.bodySmall?.copyWith(height: 1.4)),
          Gaps.v8,
          InkWell(
            key: const ValueKey('briefs_intro_next'),
            onTap: onNext,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Text(
                l.sellerBriefsNext,
                style: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BriefCard extends StatelessWidget {
  const _BriefCard({required this.brief, this.onRespond, this.sent = false});
  final Brief brief;
  final VoidCallback? onRespond;
  final bool sent;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final buyer = brief.buyerName.isEmpty ? l.sellerBriefsBuyer : brief.buyerName;
    return AppCard(
      margin: const EdgeInsets.only(bottom: Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(brief.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          Gaps.v4,
          Text('$buyer · ${Fmt.ago(brief.createdAt)}', style: context.textTheme.bodySmall),
          Gaps.v8,
          Text(brief.description, maxLines: 3, overflow: TextOverflow.ellipsis),
          Gaps.v10,
          Row(
            children: [
              Expanded(
                child: Text(
                  l.sellerBriefsBudget(Fmt.money(brief.budget), Fmt.days(brief.deliveryDays)),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              if (sent)
                Text(
                  l.sellerBriefsSent,
                  style: TextStyle(color: context.tokens.brand, fontWeight: FontWeight.w700),
                )
              else
                FilledButton(
                  onPressed: onRespond,
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
                  child: Text(l.sellerBriefsSendOffer),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
