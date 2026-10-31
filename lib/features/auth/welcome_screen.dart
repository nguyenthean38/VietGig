import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/app_images.dart';
import '../../core/widgets/widgets.dart';
import '../../state/session_controller.dart';

/// Màn chào mừng: ảnh nền lớn + 2 thẻ "Tìm dịch vụ" / "Bán dịch vụ".
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _guest(BuildContext context) {
    context.read<SessionController>().continueAsGuest();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const PlaceholderImage(seed: 7, image: AppImages.welcomeHero),
                // Lớp phủ tối để chữ dễ đọc.
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                      stops: const [0.35, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: Space.xxl,
                  right: Space.xxl,
                  bottom: 110,
                  child: Column(
                    children: [
                      const BrandLogo(size: 40, color: Colors.white),
                      const SizedBox(height: 14),
                      Text(
                        l.authWelcomeHeadline,
                        textAlign: TextAlign.center,
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: Insets.page,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _RoleCard(
                              key: const ValueKey('welcome_buy'),
                              icon: Icons.search_rounded,
                              title: l.authWelcomeBuyTitle,
                              subtitle: l.authWelcomeBuySubtitle,
                              onTap: () => context.push('/auth/signup'),
                            ),
                          ),
                          Gaps.h12,
                          Expanded(
                            child: _RoleCard(
                              key: const ValueKey('welcome_sell'),
                              icon: Icons.storefront_outlined,
                              title: l.authWelcomeSellTitle,
                              subtitle: l.authWelcomeSellSubtitle,
                              onTap: () => context.push('/auth/signup'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
                    child: Row(
                      children: [
                        TextButton(
                          key: const ValueKey('welcome_skip'),
                          onPressed: () => _guest(context),
                          child: Text(l.authSkip, style: const TextStyle(decoration: TextDecoration.underline)),
                        ),
                        const Spacer(),
                        TextButton(
                          key: const ValueKey('welcome_signin'),
                          onPressed: () => context.push('/auth/signin'),
                          child: Text(
                            l.commonSignIn,
                            style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final t = context.tokens;
    return Material(
      color: cs.surface,
      elevation: 4,
      shadowColor: Colors.black26,
      borderRadius: Radii.lgAll,
      child: InkWell(
        borderRadius: Radii.lgAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, Space.lg, 10, 14),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: t.brandSoft, borderRadius: Radii.lgAll),
                child: Icon(icon, color: t.brandStrong, size: 28),
              ),
              Gaps.v10,
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Gaps.v4,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: context.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
