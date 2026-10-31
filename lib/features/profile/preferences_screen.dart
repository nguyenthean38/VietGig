import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import 'widgets/settings_widgets.dart';

/// Tuỳ chọn: Thông báo, Bảo mật, Ngôn ngữ, Giao diện, Tiền tệ, Trạng thái online.
class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsController>();
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(title: l.profilePreferences),
      body: ListView(
        padding: const EdgeInsets.only(top: Space.sm, bottom: Space.xxl),
        children: [
          MenuTile(
            title: l.profileNotifications,
            icon: Icons.notifications_none_rounded,
            onTap: () => context.push('/settings/notifications'),
          ),
          MenuTile(
            title: l.profileSecurity,
            icon: Icons.lock_outline_rounded,
            onTap: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (_) => const _SecuritySheet(),
            ),
          ),
          MenuTile(
            key: const ValueKey('pref_language'),
            title: l.profileLanguage,
            icon: Icons.language_rounded,
            trailing: TrailingValue(s.languageName),
            onTap: () => context.push('/settings/language'),
          ),
          MenuTile(
            key: const ValueKey('pref_appearance'),
            title: l.profileAppearance,
            icon: Icons.dark_mode_outlined,
            trailing: TrailingValue(themeModeLabel(l, s.themeMode)),
            onTap: () => context.push('/settings/appearance'),
          ),
          MenuTile(
            title: l.profileCurrency,
            icon: Icons.payments_outlined,
            trailing: TrailingValue(s.currency),
            onTap: () => context.push('/settings/currency'),
          ),
          Gaps.v20,
          SwitchRow(
            switchKey: const ValueKey('online_switch'),
            title: l.profileOnlineStatus,
            subtitle: l.profileOnlineStatusHint,
            value: s.onlineStatus,
            onChanged: (v) {
              s.setOnline(v);
              showAppSnack(context, v ? l.profileOnlineShown : l.profileOnlineHidden);
            },
          ),
        ],
      ),
    );
  }
}

/// Sheet bảo mật: đổi mật khẩu (gửi email) + xác thực 2 lớp (mô phỏng).
class _SecuritySheet extends StatefulWidget {
  const _SecuritySheet();
  @override
  State<_SecuritySheet> createState() => _SecuritySheetState();
}

class _SecuritySheetState extends State<_SecuritySheet> {
  bool _twoFactor = false;
  bool _sending = false;

  Future<void> _resetPassword() async {
    final session = context.read<SessionController>();
    final l = context.l10n;
    setState(() => _sending = true);
    try {
      await session.sendPasswordReset(session.user?.email ?? '');
      if (!mounted) return;
      Navigator.pop(context);
      showAppSnack(context, l.profileResetLinkSent);
    } catch (e) {
      if (mounted) showAppSnack(context, '$e', success: false);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
            child: Text(l.profileSecurity, style: context.textTheme.titleLarge),
          ),
          MenuTile(
            title: l.profileChangePassword,
            subtitle: l.profileChangePasswordHint,
            icon: Icons.password_rounded,
            trailing: _sending
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : null,
            onTap: _sending ? null : _resetPassword,
          ),
          SwitchRow(
            title: l.profileTwoFactor,
            subtitle: l.profileTwoFactorHint,
            value: _twoFactor,
            onChanged: (v) {
              setState(() => _twoFactor = v);
              showAppSnack(context, v ? l.profileTwoFactorOn : l.profileTwoFactorOff);
            },
          ),
          Gaps.v16,
        ],
      ),
    );
  }
}
