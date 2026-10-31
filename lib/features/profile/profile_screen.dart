import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/user.dart';
import '../../state/session_controller.dart';
import 'widgets/profile_sections.dart';
import 'widgets/settings_widgets.dart';

/// Tab "Tài khoản": hồ sơ, chế độ người bán, cài đặt, hỗ trợ (và giao diện khách).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final user = session.user;
    return Scaffold(
      body: user == null ? const GuestProfileView() : _UserProfile(user: user, sellerMode: session.sellerMode),
    );
  }
}

/// Mở sheet chọn loại góp ý.
Future<void> openFeedbackSheet(BuildContext context) async {
  final l = context.l10n;
  final kind = await showActionSheet<String>(
    context,
    title: l.profileSendFeedback,
    actions: [
      SheetAction(
        label: l.profileFeedbackIdea,
        subtitle: l.profileFeedbackIdeaHint,
        value: 'idea',
        icon: Icons.lightbulb_outline_rounded,
      ),
      SheetAction(
        label: l.profileFeedbackBug,
        subtitle: l.profileFeedbackBugHint,
        value: 'bug',
        icon: Icons.bug_report_outlined,
      ),
    ],
  );
  if (kind != null && context.mounted) context.push('/feedback?kind=$kind');
}

class _UserProfile extends StatelessWidget {
  const _UserProfile({required this.user, required this.sellerMode});
  final AppUser user;
  final bool sellerMode;

  Future<void> _toggleSeller(BuildContext context, bool v) async {
    final session = context.read<SessionController>();
    final l = context.l10n;
    try {
      await session.setSellerMode(v);
      if (context.mounted) {
        showAppSnack(context, v ? l.profileSwitchedToSeller : l.profileSwitchedToBuyer);
      }
    } catch (_) {
      if (context.mounted) showAppSnack(context, l.profileSwitchModeFailed, success: false);
    }
  }

  Future<void> _becomeSeller(BuildContext context) async {
    final l = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l.profileBecomeSellerTitle,
      message: l.profileBecomeSellerMessage,
      confirmLabel: l.profileBecomeSellerConfirm,
    );
    if (ok && context.mounted) await _toggleSeller(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        ProfileHeader(user: user),
        Container(
          margin: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
          decoration: BoxDecoration(
            borderRadius: Radii.lgAll,
            border: Border.all(color: cs.outline),
          ),
          child: SwitchListTile(
            key: const ValueKey('seller_mode_switch'),
            value: sellerMode,
            onChanged: (v) => _toggleSeller(context, v),
            activeTrackColor: context.tokens.brand,
            shape: const RoundedRectangleBorder(borderRadius: Radii.lgAll),
            secondary: Icon(Icons.storefront_outlined, color: cs.onSurface),
            title: Text(l.profileSellerMode, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(sellerMode ? l.profileSellerModeOn : l.profileSellerModeOff),
          ),
        ),
        GroupTitle(l.profileMyVietGig),
        if (sellerMode) ...[
          MenuTile(
            title: l.profileEarnings,
            icon: Icons.account_balance_wallet_outlined,
            onTap: () => context.push('/seller/earnings'),
          ),
          MenuTile(
            title: l.profileOfferTemplates,
            icon: Icons.description_outlined,
            onTap: () => context.push('/seller/offer-templates'),
          ),
          MenuTile(
            title: l.profileBuyerBriefs,
            icon: Icons.assignment_outlined,
            onTap: () => context.push('/seller/briefs'),
          ),
          MenuTile(title: l.profileShareGigs, icon: Icons.share_outlined, onTap: () => context.push('/seller/gigs')),
          MenuTile(
            title: l.profileMyProfile,
            icon: Icons.person_outline_rounded,
            onTap: () => context.push('/user/${user.id}'),
          ),
          MenuTile(
            title: l.profileAvailability,
            icon: Icons.event_available_outlined,
            onTap: () => context.push('/seller/availability'),
          ),
        ],
        MenuTile(
          key: const ValueKey('menu_saved'),
          title: l.profileSavedLists,
          icon: Icons.favorite_border_rounded,
          onTap: () => context.push('/saved'),
        ),
        MenuTile(title: l.profileMyInterests, icon: Icons.interests_outlined, onTap: () => context.push('/interests')),
        MenuTile(title: l.profileBrowsingHistory, icon: Icons.history_rounded, onTap: () => context.push('/history')),
        MenuTile(
          title: l.profileInviteFriends,
          icon: Icons.card_giftcard_outlined,
          onTap: () => context.push('/invite'),
        ),
        GroupTitle(l.profileSettings),
        MenuTile(
          key: const ValueKey('menu_preferences'),
          title: l.profilePreferences,
          icon: Icons.tune_rounded,
          onTap: () => context.push('/settings/preferences'),
        ),
        MenuTile(
          key: const ValueKey('menu_account'),
          title: l.profileAccount,
          icon: Icons.manage_accounts_outlined,
          onTap: () => context.push('/settings/account'),
        ),
        GroupTitle(l.profileSupport),
        MenuTile(
          title: l.profileSupportCenter,
          icon: Icons.help_outline_rounded,
          onTap: () => context.push('/support'),
        ),
        MenuTile(
          key: const ValueKey('menu_feedback'),
          title: l.profileSendFeedback,
          icon: Icons.rate_review_outlined,
          onTap: () => openFeedbackSheet(context),
        ),
        if (!user.isSeller)
          MenuTile(
            title: l.profileBecomeSeller,
            icon: Icons.rocket_launch_outlined,
            onTap: () => _becomeSeller(context),
          ),
        const AppVersionLine(),
      ],
    );
  }
}
