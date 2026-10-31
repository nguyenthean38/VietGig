import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/account.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import '../../core/utils/app_images.dart';

/// Danh sách thông báo, nhóm HÔM NAY / TRƯỚC ĐÓ.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _showBanner = true;

  /// Chuẩn hoá link cũ (VD "/seller/u_bao" -> "/user/u_bao").
  String _normalize(String link) =>
      RegExp(r'^/seller/u_').hasMatch(link) ? link.replaceFirst('/seller/', '/user/') : link;

  void _open(AppNotification n) {
    final link = n.link;
    if (link == null || link.isEmpty) {
      infoDialog(context, title: n.title, message: n.body, ok: context.l10n.profileGotIt);
      return;
    }
    context.push(_normalize(link));
  }

  Future<void> _enablePush() async {
    final s = context.read<SettingsController>();
    for (final k in s.push.keys.toList()) {
      s.setPush(k, true);
    }
    showAppSnack(context, context.l10n.profilePushEnabled);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<NotificationsController>();
    final user = context.watch<SessionController>().user;
    final now = DateTime.now();
    bool isToday(DateTime d) => d.year == now.year && d.month == now.month && d.day == now.day;
    final items = [...ctrl.items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final today = items.where((n) => isToday(n.createdAt)).toList();
    final earlier = items.where((n) => !isToday(n.createdAt)).toList();
    final unverified = user != null && !user.emailVerified;
    final l = context.l10n;

    return Scaffold(
      appBar: SimpleAppBar(
        title: l.profileNotifications,
        actions: [
          if (ctrl.unreadCount > 0)
            TextButton(
              key: const ValueKey('mark_all_read'),
              onPressed: () async {
                await ctrl.markAllRead();
                if (context.mounted) showAppSnack(context, l.profileMarkedAllRead);
              },
              child: Text(l.profileMarkAllRead),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: Space.xxl),
        children: [
          if (_showBanner) _AccountBanner(unverified: unverified, onClose: () => setState(() => _showBanner = false)),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  EmptyState(
                    icon: Icons.notifications_active_outlined,
                    title: l.profileNotifEmptyTitle,
                    message: l.profileNotifEmptyMessage,
                  ),
                  FilledButton(
                    key: const ValueKey('enable_push'),
                    onPressed: _enablePush,
                    child: Text(l.profileEnablePush),
                  ),
                ],
              ),
            ),
          if (today.isNotEmpty) ...[_SectionLabel(l.profileNotifToday), for (final n in today) _tile(ctrl, n)],
          if (earlier.isNotEmpty) ...[_SectionLabel(l.profileNotifEarlier), for (final n in earlier) _tile(ctrl, n)],
        ],
      ),
    );
  }

  Widget _tile(NotificationsController ctrl, AppNotification n) => Dismissible(
    key: ValueKey('notif_${n.id}'),
    direction: DismissDirection.endToStart,
    background: Container(
      color: context.tokens.danger,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: Space.xl),
      child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
    ),
    onDismissed: (_) {
      ctrl.remove(n.id);
      showAppSnack(context, context.l10n.profileNotifDeleted);
    },
    child: _NotificationTile(n: n, onTap: () => _open(n)),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.lg, 18, Space.lg, 6),
    child: Text(
      text,
      style: context.textTheme.labelMedium?.copyWith(
        letterSpacing: 0.8,
        fontWeight: FontWeight.w700,
        color: context.colors.onSurfaceVariant,
      ),
    ),
  );
}

class _AccountBanner extends StatelessWidget {
  const _AccountBanner({required this.unverified, required this.onClose});
  final bool unverified;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      key: const ValueKey('account_banner'),
      margin: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xs),
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.xs, 14),
      decoration: BoxDecoration(color: context.tokens.navy, borderRadius: Radii.lgAll),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.profileAccountNotice,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                ),
                Gaps.v4,
                Text(
                  unverified ? l.profileAccountNoticeUnverified : l.profileAccountNoticeComplete,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13, height: 1.35),
                ),
                Gaps.v8,
                InkWell(
                  onTap: () => context.push(unverified ? '/verify-email' : '/settings/edit-profile'),
                  child: Text(
                    unverified ? l.profileActivateEmailLink : l.profileUpdateProfileLink,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            key: const ValueKey('banner_close'),
            tooltip: l.commonClose,
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.n, required this.onTap});
  final AppNotification n;
  final VoidCallback onTap;

  static (IconData, Color) _kindIcon(NotificationKind k, AppTokens t, ColorScheme cs) => switch (k) {
    NotificationKind.order => (Icons.assignment_outlined, t.brand),
    NotificationKind.message => (Icons.chat_bubble_outline_rounded, t.info),
    NotificationKind.account => (Icons.shield_outlined, t.warning),
    NotificationKind.promo => (Icons.local_offer_outlined, t.plum),
    NotificationKind.system => (Icons.campaign_outlined, cs.onSurfaceVariant),
  };

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final t = context.tokens;
    final (icon, color) = _kindIcon(n.kind, t, cs);
    final leading = SizedBox(
      width: 46,
      height: 46,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (n.actorSeed != null)
            UserAvatar(
              seed: n.actorSeed,
              name: n.title,
              size: 46,
              photo: AppImages.avatarMentionedIn(n.body),
              allowPhoto: AppImages.avatarMentionedIn(n.body) != null,
            )
          else
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 22),
            ),
          if (n.actorSeed != null)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.surface, width: 2),
                ),
                child: Icon(icon, color: Colors.white, size: 11),
              ),
            ),
        ],
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        color: n.read ? null : t.brand.withValues(alpha: 0.06),
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading,
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.title,
                    style: TextStyle(fontWeight: n.read ? FontWeight.w500 : FontWeight.w700, fontSize: 14.5),
                  ),
                  Gaps.v2,
                  Text(n.body, style: context.textTheme.bodyMedium?.copyWith(height: 1.35)),
                  Gaps.v4,
                  Text(Fmt.ago(n.createdAt), style: context.textTheme.bodySmall),
                ],
              ),
            ),
            Gaps.h8,
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: n.read
                  ? const SizedBox(width: 9)
                  : Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(color: t.brand, shape: BoxShape.circle),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
