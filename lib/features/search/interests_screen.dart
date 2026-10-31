import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/app_icons.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import '../gig/widgets/discovery_widgets.dart';

/// Chọn sở thích (danh mục con) theo nhóm danh mục.
class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  late final Future<List<Category>> _future;
  Set<String>? _selected;
  Set<String> _initial = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = context.read<SessionController>();
    final repo = context.read<AccountRepository>();
    _future = context.read<CatalogRepository>().categories().then((cats) async {
      final mine = await repo.interests(s.userId);
      if (mounted) {
        setState(() {
          _initial = {...mine};
          _selected = {...mine};
        });
      }
      return cats;
    });
  }

  bool get _dirty => _selected != null && (_selected!.length != _initial.length || !_selected!.containsAll(_initial));

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final s = context.read<SessionController>();
      await context.read<AccountRepository>().saveInterests(s.userId, _selected!);
      InterestsSync.bump();
      if (!mounted) return;
      showAppSnack(context, context.l10n.searchInterestsSaved);
      context.canPop() ? context.pop() : context.go('/search');
    } catch (e) {
      if (mounted) showAppSnack(context, context.l10n.searchSaveFailed('$e'), success: false);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(
        title: l.searchYourInterests,
        actions: [
          if (_selected?.isNotEmpty ?? false)
            TextButton(
              onPressed: () => setState(() => _selected!.clear()),
              child: Text(l.searchDeselectAll, style: const TextStyle(decoration: TextDecoration.underline)),
            ),
        ],
      ),
      body: AsyncView<List<Category>>(
        future: _future,
        builder: (context, cats) => ListView(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
          children: [
            Text(
              l.searchInterestsIntro,
              style: context.textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
            ),
            for (final c in cats) ...[
              Gaps.v20,
              Row(
                children: [
                  Icon(AppIcons.of(c.icon), size: 20),
                  Gaps.h8,
                  Expanded(child: Text(c.name, style: context.textTheme.titleMedium)),
                ],
              ),
              Gaps.v10,
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  for (final s in c.subcategories)
                    FlexChip(
                      key: ValueKey('pick_${s.id}'),
                      label: s.name,
                      showCheck: true,
                      selected: _selected?.contains(s.id) ?? false,
                      onTap: () => setState(() {
                        final sel = _selected ??= {};
                        sel.contains(s.id) ? sel.remove(s.id) : sel.add(s.id);
                      }),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        note: Text(l.searchInterestsSelected(_selected?.length ?? 0), style: context.textTheme.bodySmall),
        child: PrimaryButton(
          key: const ValueKey('save_interests'),
          label: l.commonSave,
          loading: _saving,
          onPressed: _selected == null || !_dirty ? null : _save,
        ),
      ),
    );
  }
}
