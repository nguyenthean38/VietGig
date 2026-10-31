import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/user.dart';
import '../../../state/app_controllers.dart';
import 'settings_widgets.dart';

const appVersion = '1.0.0 (build 100)';

/// Header xanh đậm của trang Tài khoản: avatar, tên, chuông thông báo, nút kích hoạt.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final unread = context.select<NotificationsController, int>((c) => c.unreadCount);
    final l = context.l10n;
    return Container(
      color: context.tokens.brandStrong,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.sm, Space.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(Space.xxs),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: UserAvatar(user: user, size: 52, showOnline: true),
                  ),
                  Gaps.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
                        ),
                        Gaps.v2,
                        Text(
                          user.emailVerified ? user.displayName : l.profileNeedActivation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13.5),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('profile_bell'),
                    tooltip: l.profileNotifications,
                    onPressed: () => context.push('/notifications'),
                    icon: CountBadge(
                      count: unread,
                      child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 27),
                    ),
                  ),
                ],
              ),
              if (!user.emailVerified) ...[
                Gaps.v16,
                Padding(
                  padding: const EdgeInsets.only(right: Space.sm),
                  child: FilledButton(
                    key: const ValueKey('activate_account'),
                    onPressed: () => context.push('/verify-email'),
                    style: FilledButton.styleFrom(
                      backgroundColor: context.tokens.info,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 46),
                    ),
                    child: Text(l.profileActivateAccount),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Trang Tài khoản khi là khách: tham gia / đăng nhập, ngôn ngữ, giao diện, tiền tệ, hỗ trợ.
class GuestProfileView extends StatelessWidget {
  const GuestProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Container(
          color: context.colors.onSurfaceVariant,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.xl, Space.lg, Space.xxl),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.25),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 34),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.profileGuest,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Gaps.v2,
                        Text(l.profileGuestWelcome, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gaps.v8,
        MenuTile(
          key: const ValueKey('guest_join'),
          title: l.profileJoin,
          icon: Icons.add_circle_outline_rounded,
          onTap: () => context.push('/auth/signup'),
        ),
        MenuTile(
          key: const ValueKey('guest_signin'),
          title: l.commonSignIn,
          icon: Icons.login_rounded,
          onTap: () => context.push('/auth/signin'),
        ),
        GroupTitle(l.profileGeneral),
        MenuTile(
          key: const ValueKey('guest_language'),
          title: l.profileLanguage,
          icon: Icons.language_rounded,
          trailing: TrailingValue(settings.languageName),
          onTap: () => context.push('/settings/language'),
        ),
        MenuTile(
          title: l.profileAppearance,
          icon: Icons.dark_mode_outlined,
          trailing: TrailingValue(themeModeLabel(l, settings.themeMode)),
          onTap: () => context.push('/settings/appearance'),
        ),
        MenuTile(
          title: l.profileCurrency,
          icon: Icons.payments_outlined,
          trailing: TrailingValue(settings.currency),
          onTap: () => context.push('/settings/currency'),
        ),
        GroupTitle(l.profileSupport),
        MenuTile(
          title: l.profileSupportCenter,
          icon: Icons.help_outline_rounded,
          onTap: () => context.push('/support'),
        ),
        const AppVersionLine(),
      ],
    );
  }
}

/// Dòng "Phiên bản ..." cuối trang Tài khoản.
class AppVersionLine extends StatelessWidget {
  const AppVersionLine({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Space.xxl),
    child: Text(
      context.l10n.profileVersion(appVersion),
      textAlign: TextAlign.center,
      style: context.textTheme.bodySmall,
    ),
  );
}
