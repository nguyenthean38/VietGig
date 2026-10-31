import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../../core/utils/app_images.dart';

/// Chi tiết một dự án portfolio (mở dạng modal).
class PortfolioItemScreen extends StatefulWidget {
  const PortfolioItemScreen({super.key, required this.userId, required this.itemId});
  final String userId;
  final String itemId;

  @override
  State<PortfolioItemScreen> createState() => _PortfolioItemScreenState();
}

class _PortfolioItemScreenState extends State<PortfolioItemScreen> {
  late final Future<AppUser?> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<CatalogRepository>().userById(widget.userId);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SimpleAppBar(title: '', close: true),
    body: AsyncView<AppUser?>(
      future: _future,
      builder: (context, u) {
        final item = u?.portfolio.where((p) => p.id == widget.itemId).firstOrNull;
        if (u == null || item == null) {
          return EmptyState(
            icon: Icons.collections_outlined,
            title: context.l10n.gigProjectNotFoundTitle,
            message: context.l10n.gigProjectNotFoundMessage,
            actionLabel: context.l10n.commonClose,
            onAction: () => context.pop(),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xxxl),
          children: [
            Text(item.title, style: context.textTheme.headlineSmall),
            Gaps.v10,
            InkWell(
              onTap: () => context.push('/user/${u.id}'),
              child: Row(
                children: [
                  UserAvatar(user: u, size: 28),
                  Gaps.h8,
                  Text(context.l10n.gigBy(u.displayName), style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              item.description.isEmpty ? context.l10n.gigProjectDefaultDescription(u.displayName) : item.description,
              style: const TextStyle(height: 1.5),
            ),
            Gaps.v16,
            for (var i = 0; i < item.imageCount; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: AspectRatio(
                  aspectRatio: 1.1,
                  child: PlaceholderImage(
                    seed: item.seed + i,
                    image: i < AppImages.portfolio(item.id).length ? AppImages.portfolio(item.id)[i] : null,
                    radius: Radii.lg,
                    label: i == 0 ? item.title.split(' ').take(2).join(' ').toUpperCase() : '',
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );
}
