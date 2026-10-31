import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import 'widgets/discovery_widgets.dart';

/// Portfolio của người bán (lưới 2 cột).
class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key, required this.userId});
  final String userId;

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late final Future<AppUser?> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<CatalogRepository>().userById(widget.userId);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<AppUser?>(
    future: _future,
    builder: (context, snap) {
      final u = snap.data;
      final l = context.l10n;
      return Scaffold(
        appBar: SimpleAppBar(
          title: u == null ? l.gigPortfolio : l.gigPortfolioOf(u.displayName),
          actions: [
            if (u != null)
              IconButton(
                tooltip: l.gigShare,
                onPressed: () => copyLink(context, '/user/${u.id}/portfolio'),
                icon: const Icon(Icons.ios_share_rounded),
              ),
          ],
        ),
        body: Builder(
          builder: (context) {
            if (snap.hasError) {
              return EmptyState(icon: Icons.error_outline_rounded, title: l.commonErrorTitle, message: '${snap.error}');
            }
            if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
            if (u == null) return EmptyState(icon: Icons.person_off_outlined, title: l.gigSellerNotFound);
            if (u.portfolio.isEmpty) {
              return EmptyState(
                icon: Icons.collections_outlined,
                title: l.gigNoProjectsTitle,
                message: l.gigNoProjectsMessage,
              );
            }
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(Space.lg, Space.xs, Space.lg, Space.md),
                  sliver: SliverToBoxAdapter(
                    child: Text(l.gigPortfolioScreenIntro(u.displayName), style: context.textTheme.bodySmall),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xxxl),
                  sliver: SliverGrid.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: Space.lg,
                      crossAxisSpacing: Space.md,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: u.portfolio.length,
                    itemBuilder: (context, i) => PortfolioThumb(
                      item: u.portfolio[i],
                      onTap: () => context.push('/portfolio/${u.id}/${u.portfolio[i].id}'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
