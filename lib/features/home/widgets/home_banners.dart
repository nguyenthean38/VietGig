import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/catalog.dart';

/// Banner màu đậm có tiêu đề, mô tả và liên kết gạch chân (xác nhận email, mời bạn bè).
class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({
    super.key,
    required this.color,
    required this.title,
    required this.message,
    required this.linkLabel,
    required this.onTap,
    this.titleSize = 16,
    this.padding = Space.lg,
    this.linkGap = Gaps.v10,
  });
  final Color color;
  final String title;
  final String message;
  final String linkLabel;
  final VoidCallback onTap;
  final double titleSize;
  final double padding;
  final Widget linkGap;

  @override
  Widget build(BuildContext context) => Material(
    color: color,
    borderRadius: Radii.lgAll,
    child: InkWell(
      borderRadius: Radii.lgAll,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: titleSize),
            ),
            Gaps.v6,
            Text(message, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
            linkGap,
            Text(
              linkLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Banner "Vui lòng xác nhận email".
class VerifyEmailBanner extends StatelessWidget {
  const VerifyEmailBanner({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
      child: HomePromoBanner(
        key: const ValueKey('verify_banner'),
        color: context.tokens.navy,
        title: l.homeVerifyTitle,
        message: l.homeVerifyMessage(email.isEmpty ? l.homeVerifyYourAddress : email),
        linkLabel: l.homeVerifyAction,
        onTap: () => context.push('/verify-email'),
      ),
    );
  }
}

/// Banner "Chia sẻ & nhận tới 2.500.000 ₫".
class InviteBanner extends StatelessWidget {
  const InviteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, 28, Space.lg, Space.sm),
      child: HomePromoBanner(
        key: const ValueKey('invite_banner'),
        color: context.tokens.plum,
        title: l.homeInviteTitle,
        message: l.homeInviteMessage,
        linkLabel: l.homeInviteAction,
        titleSize: 18,
        padding: 18,
        linkGap: Gaps.v12,
        onTap: () => context.push('/invite'),
      ),
    );
  }
}

/// Thẻ mời khách đăng nhập.
class GuestSignInCard extends StatelessWidget {
  const GuestSignInCard({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
    child: AppCard(
      child: Row(
        children: [
          const BrandMark(size: 44),
          Gaps.h12,
          Expanded(child: Text(context.l10n.homeGuestMessage, style: const TextStyle(fontSize: 14))),
          Gaps.h8,
          FilledButton(
            key: const ValueKey('home_signin'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            onPressed: () => context.push('/auth/signin'),
            child: Text(context.l10n.commonSignIn),
          ),
        ],
      ),
    ),
  );
}

/// Một hàng sở thích: icon + tên subcategory + nút "+ Thêm"/✓.
class InterestRow extends StatelessWidget {
  const InterestRow({super.key, required this.sub, required this.selected, required this.onToggle});
  final Subcategory sub;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: Space.sm),
      padding: const EdgeInsets.only(left: Space.md, right: 6),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: Radii.mdAll,
      ),
      child: Row(
        children: [
          Icon(AppIcons.of(sub.icon), size: 22, color: cs.onSurface),
          Gaps.h10,
          Expanded(
            child: Text(
              sub.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 34,
            child: OutlinedButton(
              key: ValueKey('interest_${sub.id}'),
              onPressed: onToggle,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 34),
                padding: const EdgeInsets.symmetric(horizontal: Space.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Space.xl)),
                backgroundColor: selected ? cs.onSurface : null,
                foregroundColor: selected ? cs.surface : cs.onSurface,
              ),
              child: selected
                  ? const Icon(Icons.check_rounded, size: 18)
                  : Text(context.l10n.homeInterestAdd, style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
