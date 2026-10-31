import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/session_controller.dart';
import 'widgets/settings_widgets.dart';

/// Tài khoản: thông tin, số dư, huỷ kích hoạt/xoá, quyền riêng tư, đăng xuất.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _signingOut = false;

  Future<void> _signOut() async {
    final l = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l.profileSignOutTitle,
      message: l.profileSignOutMessage,
      confirmLabel: l.profileSignOut,
      destructive: true,
    );
    if (!ok || !mounted) return;
    setState(() => _signingOut = true);
    try {
      // Router tự chuyển về /welcome khi phiên kết thúc.
      await context.read<SessionController>().signOut();
    } catch (_) {
      if (mounted) {
        setState(() => _signingOut = false);
        showAppSnack(context, l.profileSignOutFailed, success: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionController>().user;
    final l = context.l10n;
    final t = context.tokens;
    if (user == null) {
      return Scaffold(
        appBar: SimpleAppBar(title: l.profileAccount),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: SimpleAppBar(title: l.profileAccount),
      body: ListView(
        padding: const EdgeInsets.only(bottom: Space.xxxl),
        children: [
          GroupTitle(l.profileAccountInfo, padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 6)),
          _InfoRow(label: l.profileUsername, value: user.username),
          _InfoRow(
            label: l.profileFullName,
            value: user.displayName,
            onTap: () => context.push('/settings/edit-profile'),
          ),
          _InfoRow(
            label: l.profileEmail,
            value: user.email,
            onTap: () => context.push('/settings/email'),
            badge: user.emailVerified ? _Pill(l.profileVerified, t.brand) : _Pill(l.profileUnverified, t.warning),
          ),
          MenuTile(
            title: l.profileEditProfile,
            icon: Icons.edit_outlined,
            onTap: () => context.push('/settings/edit-profile'),
          ),
          MenuTile(
            title: l.profilePersonalBalance,
            icon: Icons.account_balance_wallet_outlined,
            onTap: () => context.push('/settings/balance'),
          ),
          GroupTitle(l.profileManageAccount),
          MenuTile(
            key: const ValueKey('menu_deactivate'),
            title: l.profileDeactivateAndDelete,
            icon: Icons.person_off_outlined,
            onTap: () => context.push('/settings/deactivate'),
          ),
          MenuTile(
            title: l.profilePrivacy,
            icon: Icons.privacy_tip_outlined,
            onTap: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (_) => const _PrivacySheet(),
            ),
          ),
          Gaps.v16,
          MenuTile(
            key: const ValueKey('menu_logout'),
            title: l.profileSignOut,
            icon: Icons.logout_rounded,
            destructive: true,
            showChevron: false,
            trailing: _signingOut
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : null,
            onTap: _signingOut ? null : _signOut,
          ),
        ],
      ),
    );
  }
}

/// Dòng thông tin: nhãn nhỏ + giá trị (+ nhãn trạng thái), có thể bấm để sửa.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.onTap, this.badge});
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.md, Space.md),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.textTheme.bodySmall),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          value.isEmpty ? '—' : value,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (badge != null) ...[Gaps.h8, badge!],
                    ],
                  ),
                ],
              ),
            ),
            if (onTap != null) Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xxs),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: Radii.pillAll),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w600),
    ),
  );
}

/// Cài đặt quyền riêng tư (lưu cục bộ – mô phỏng).
class _PrivacySheet extends StatefulWidget {
  const _PrivacySheet();
  @override
  State<_PrivacySheet> createState() => _PrivacySheetState();
}

class _PrivacySheetState extends State<_PrivacySheet> {
  final _values = {'searchVisible': true, 'personalized': true, 'shareUsage': false};

  String _label(AppLocalizations l, String key) => switch (key) {
    'searchVisible' => l.profilePrivacySearchVisible,
    'personalized' => l.profilePrivacyPersonalized,
    _ => l.profilePrivacyShareUsage,
  };

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
            child: Text(l.profilePrivacy, style: context.textTheme.titleLarge),
          ),
          for (final e in _values.entries)
            SwitchRow(
              switchKey: ValueKey('privacy_${e.key}'),
              title: _label(l, e.key),
              value: e.value,
              onChanged: (v) {
                setState(() => _values[e.key] = v);
                showAppSnack(context, l.profilePrivacySaved);
              },
            ),
          Gaps.v16,
        ],
      ),
    );
  }
}
