import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import '../gig/widgets/discovery_widgets.dart';

/// Lịch sử xem dịch vụ.
class BrowsingHistoryScreen extends StatefulWidget {
  const BrowsingHistoryScreen({super.key});

  @override
  State<BrowsingHistoryScreen> createState() => _BrowsingHistoryScreenState();
}

class _BrowsingHistoryScreenState extends State<BrowsingHistoryScreen> {
  late final Future<Map<String, Gig>> _index;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _index = loadGigIndex(context.read<CatalogRepository>());
  }

  Future<void> _clearAll() async {
    final saved = context.read<SavedController>();
    final l = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l.savedHistoryClearTitle,
      message: l.savedHistoryClearMessage,
      confirmLabel: l.savedClearAll,
      destructive: true,
    );
    if (!ok || !mounted) return;
    await saved.clearHistory();
    if (!mounted) return;
    setState(() => _editing = false);
    showAppSnack(context, context.l10n.savedHistoryCleared);
  }

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<SavedController>();
    final history = saved.history;
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(
        title: l.savedHistoryTitle,
        actions: [
          if (history.isNotEmpty)
            TextButton(
              key: const ValueKey('history_edit'),
              onPressed: () => setState(() => _editing = !_editing),
              child: Text(
                _editing ? l.commonDone : l.savedEdit,
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
            ),
        ],
      ),
      body: !saved.loaded
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
          ? EmptyState(
              icon: Icons.history_rounded,
              title: l.savedHistoryEmptyTitle,
              message: l.savedHistoryEmptyMessage,
              actionLabel: l.savedExploreVietGig,
              onAction: () => context.go('/search'),
            )
          : AsyncView<Map<String, Gig>>(
              future: _index,
              builder: (context, index) {
                final gigs = [for (final id in history) ?index[id]];
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.sm, Space.sm),
                        child: Row(
                          children: [
                            Expanded(child: Text(l.savedHistoryRecent, style: context.textTheme.titleMedium)),
                            if (_editing)
                              TextButton(
                                key: const ValueKey('history_clear_all'),
                                onPressed: _clearAll,
                                child: Text(l.savedClearAll, style: TextStyle(color: context.tokens.danger)),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xxxl),
                      sliver: SliverGrid.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Space.md,
                          crossAxisSpacing: Space.md,
                          mainAxisExtent: 250,
                        ),
                        itemCount: gigs.length,
                        itemBuilder: (context, i) => Align(
                          alignment: Alignment.topCenter,
                          child: DiscoveryGigCard(
                            key: ValueKey('history_gig_${gigs[i].id}'),
                            gig: gigs[i],
                            onRemove: _editing
                                ? () async {
                                    final id = gigs[i].id;
                                    await saved.clearHistory(gigId: id);
                                    if (context.mounted) showAppSnack(context, context.l10n.savedHistoryRemoved);
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
