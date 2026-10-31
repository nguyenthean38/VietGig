import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/widgets/badges.dart';
import '../state/app_controllers.dart';
import '../state/session_controller.dart';
import '../core/l10n/l10n.dart';

/// Chỉ số nhánh trong StatefulShellRoute.
class Tabs {
  static const home = 0;
  static const inbox = 1;
  static const search = 2;
  static const orders = 3;
  static const profile = 4;
}

/// Khung chính có thanh điều hướng dưới dạng viên nổi.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final seller = context.select<SessionController, bool>((s) => s.sellerMode);
    final unread = context.select<InboxController, int>((c) => c.unreadCount);
    final items = <({int branch, IconData icon, IconData active, String label, int badge})>[
      (branch: Tabs.home, icon: Icons.home_outlined, active: Icons.home_rounded, label: context.l10n.navHome, badge: 0),
      (
        branch: Tabs.inbox,
        icon: Icons.mail_outline_rounded,
        active: Icons.mail_rounded,
        label: context.l10n.navInbox,
        badge: unread,
      ),
      if (!seller)
        (
          branch: Tabs.search,
          icon: Icons.search_rounded,
          active: Icons.saved_search_rounded,
          label: context.l10n.navSearch,
          badge: 0,
        ),
      (
        branch: Tabs.orders,
        icon: Icons.assignment_outlined,
        active: Icons.assignment_rounded,
        label: context.l10n.navOrders,
        badge: 0,
      ),
      (
        branch: Tabs.profile,
        icon: Icons.account_circle_outlined,
        active: Icons.account_circle,
        label: context.l10n.navAccount,
        badge: 0,
      ),
    ];

    return Scaffold(
      body: shell,
      extendBody: true,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            elevation: 10,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(40),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  for (final it in items)
                    Expanded(
                      child: _NavItem(
                        key: ValueKey('nav_${it.branch}'),
                        icon: it.icon,
                        activeIcon: it.active,
                        label: it.label,
                        badge: it.badge,
                        selected: shell.currentIndex == it.branch,
                        onTap: () => shell.goBranch(it.branch, initialLocation: shell.currentIndex == it.branch),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: label,
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 52,
          decoration: BoxDecoration(
            color: selected ? cs.surfaceContainerHighest : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: CountBadge(
              count: badge,
              child: Icon(selected ? activeIcon : icon, size: 26, color: cs.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}
