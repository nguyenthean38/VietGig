import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/app_icons.dart';
import '../../core/widgets/widgets.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/account.dart';
import '../../state/session_controller.dart';

typedef _Purpose = ({String id, String label, String desc, IconData icon});
typedef _Experience = ({String id, String label, IconData icon});

/// Onboarding 3 bước trong một màn hình.
/// Hoàn tất / Bỏ qua -> router tự chuyển về /home (needsOnboarding = false).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static List<_Purpose> _purposes(AppLocalizations l) => [
    (id: 'work', label: l.authOnbPurposeWork, desc: l.authOnbPurposeWorkDesc, icon: Icons.work_outline_rounded),
    (id: 'side', label: l.authOnbPurposeSide, desc: l.authOnbPurposeSideDesc, icon: Icons.rocket_launch_outlined),
    (
      id: 'personal',
      label: l.authOnbPurposePersonal,
      desc: l.authOnbPurposePersonalDesc,
      icon: Icons.local_cafe_outlined,
    ),
  ];

  static List<_Experience> _experiences(AppLocalizations l) => [
    (id: 'new', label: l.authOnbExpNew, icon: Icons.card_giftcard_outlined),
    (id: 'online', label: l.authOnbExpOnline, icon: Icons.laptop_mac_outlined),
    (id: 'offline', label: l.authOnbExpOffline, icon: Icons.handshake_outlined),
    (id: 'both', label: l.authOnbExpBoth, icon: Icons.sync_alt_rounded),
  ];

  int _step = 0;
  final _purposeSel = <String>{};
  final _interestSel = <String>{};
  bool _other = false;
  final _lookingFor = TextEditingController();
  String? _experience;
  bool _saving = false;

  @override
  void dispose() {
    _lookingFor.dispose();
    super.dispose();
  }

  bool get _hasSelection => switch (_step) {
    0 => _purposeSel.isNotEmpty,
    1 => _interestSel.isNotEmpty || (_other && _lookingFor.text.trim().isNotEmpty),
    _ => _experience != null,
  };

  void _skip() => context.read<SessionController>().skipOnboarding();

  Future<void> _next() async {
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    setState(() => _saving = true);
    try {
      await context.read<SessionController>().completeOnboarding(
        OnboardingAnswers(
          purposes: {..._purposeSel},
          interests: {..._interestSel},
          experience: _experience,
          freelancerType: _experience,
          lookingFor: _other ? _lookingFor.text.trim() : '',
        ),
      );
    } catch (e) {
      if (mounted) showAppSnack(context, context.l10n.authOnbSaveError, success: false);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Nút chính: chưa chọn gì thì là "Bỏ qua" (bỏ qua bước này), đã chọn thì "Tiếp tục".
  void _primary() {
    if (_hasSelection) {
      _next();
    } else if (_step < 2) {
      setState(() => _step++);
    } else {
      _skip();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _step > 0) setState(() => _step--);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    SizedBox(
                      width: 96,
                      child: _step > 0
                          ? TextButton(
                              key: const ValueKey('onb_back'),
                              onPressed: () => setState(() => _step--),
                              child: Text(l.commonBack),
                            )
                          : null,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < 3; i++)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: i == _step ? 22 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: i <= _step ? context.tokens.brand : context.colors.outline,
                                borderRadius: const BorderRadius.all(Radius.circular(Radii.xs)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 96,
                      child: TextButton(key: const ValueKey('onb_skip_all'), onPressed: _skip, child: Text(l.authSkip)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: KeyedSubtree(key: ValueKey(_step), child: _body(l)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, Space.md),
                child: PrimaryButton(
                  key: const ValueKey('onb_next'),
                  label: _hasSelection ? (_step == 2 ? l.authFinish : l.authContinue) : l.authSkip,
                  loading: _saving,
                  onPressed: _primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String title, String sub) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        Gaps.v6,
        Text(sub, style: context.textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant)),
      ],
    ),
  );

  Widget _body(AppLocalizations l) => switch (_step) {
    0 => ListView(
      padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.lg),
      children: [
        _title(l.authOnbPurposeTitle, l.authOnbPurposeSub),
        for (final p in _purposes(l))
          Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: OptionTile(
              key: ValueKey('purpose_${p.id}'),
              label: p.label,
              description: p.desc,
              icon: p.icon,
              selected: _purposeSel.contains(p.id),
              onTap: () =>
                  setState(() => _purposeSel.contains(p.id) ? _purposeSel.remove(p.id) : _purposeSel.add(p.id)),
            ),
          ),
      ],
    ),
    1 => CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, 0),
          sliver: SliverToBoxAdapter(child: _title(l.authOnbInterestTitle, l.authOnbInterestSub)),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xl),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: Space.md,
              crossAxisSpacing: Space.md,
              mainAxisExtent: 160,
            ),
            delegate: SliverChildListDelegate([
              for (final o in MockData.interestOptions)
                OptionTile(
                  key: ValueKey('interest_${o.id}'),
                  label: o.label,
                  icon: AppIcons.of(o.icon),
                  selected: _interestSel.contains(o.id),
                  onTap: () =>
                      setState(() => _interestSel.contains(o.id) ? _interestSel.remove(o.id) : _interestSel.add(o.id)),
                ),
              OptionTile(
                key: const ValueKey('interest_other'),
                label: l.authOnbOther,
                icon: Icons.add_rounded,
                selected: _other,
                onTap: () => setState(() => _other = !_other),
              ),
            ]),
          ),
        ),
        if (_other)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Space.xl, Space.xl, Space.xl, Space.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.authOnbLookingForTitle, style: context.textTheme.titleMedium),
                  Gaps.v10,
                  TextField(
                    key: const ValueKey('onb_looking_for'),
                    controller: _lookingFor,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(hintText: l.authOnbLookingForHint),
                  ),
                ],
              ),
            ),
          ),
        const SliverToBoxAdapter(child: Gaps.v16),
      ],
    ),
    _ => ListView(
      padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.lg),
      children: [
        _title(l.authOnbExpTitle, l.authOnbExpSub),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: Space.md,
          crossAxisSpacing: Space.md,
          mainAxisExtent: 160,
          children: [
            for (final e in _experiences(l))
              OptionTile(
                key: ValueKey('exp_${e.id}'),
                label: e.label,
                icon: e.icon,
                selected: _experience == e.id,
                onTap: () => setState(() => _experience = _experience == e.id ? null : e.id),
              ),
          ],
        ),
      ],
    ),
  };
}
