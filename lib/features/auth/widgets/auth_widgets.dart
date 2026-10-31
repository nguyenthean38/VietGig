import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/repositories/repositories.dart';
import '../../../state/session_controller.dart';

/// Quy tắc mật khẩu dùng chung cho đăng ký.
class PasswordRules {
  PasswordRules._();
  static final rules = <({String Function(AppLocalizations) label, bool Function(String) test})>[
    (label: (l) => l.authPwRuleLength, test: (s) => s.length >= 8),
    (label: (l) => l.authPwRuleUpper, test: (s) => s.contains(RegExp(r'[A-Z]'))),
    (label: (l) => l.authPwRuleLower, test: (s) => s.contains(RegExp(r'[a-z]'))),
    (label: (l) => l.authPwRuleDigit, test: (s) => s.contains(RegExp(r'[0-9]'))),
  ];
  static bool valid(String s) => rules.every((r) => r.test(s));
}

final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Danh sách điều kiện mật khẩu, đổi màu theo thời gian thực.
class PasswordChecklist extends StatelessWidget {
  const PasswordChecklist({super.key, required this.password});
  final String password;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final r in PasswordRules.rules)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: r.test(password)
                      ? Icon(Icons.check_rounded, key: const ValueKey(1), size: 16, color: context.tokens.brand)
                      : Icon(Icons.remove_rounded, key: const ValueKey(0), size: 16, color: cs.onSurfaceVariant),
                ),
                Gaps.h8,
                Text(
                  r.label(l),
                  style: TextStyle(fontSize: 13, color: r.test(password) ? cs.onSurface : cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Hàng 3 nút đăng nhập bằng Apple / Google / Facebook.
class SocialButtons extends StatefulWidget {
  const SocialButtons({super.key});
  @override
  State<SocialButtons> createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  String? _busy;

  Future<void> _go(String provider) async {
    setState(() => _busy = provider);
    try {
      await context.read<SessionController>().signInWithProvider(provider);
    } on AuthException catch (e) {
      if (mounted) showAppSnack(context, authErrorText(context.l10n, e), success: false);
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    Widget btn(String id, Widget icon, String tip) => Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.xs),
        child: Tooltip(
          message: tip,
          child: OutlinedButton(
            key: ValueKey('social_$id'),
            onPressed: _busy == null ? () => _go(id) : null,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 48),
              padding: EdgeInsets.zero,
              side: BorderSide(color: cs.outline),
            ),
            child: _busy == id
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : icon,
          ),
        ),
      ),
    );
    // Màu logo của Google / Facebook là màu thương hiệu bên thứ ba, giữ nguyên.
    return Row(
      children: [
        btn('apple', Icon(Icons.apple, color: cs.onSurface, size: 24), l.authContinueWithApple),
        btn(
          'google',
          const Text(
            'G',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Color(0xFF4285F4)),
          ),
          l.authContinueWithGoogle,
        ),
        btn(
          'facebook',
          const Icon(Icons.facebook_rounded, color: Color(0xFF1877F2), size: 24),
          l.authContinueWithFacebook,
        ),
      ],
    );
  }
}

/// Dòng "Bằng việc tham gia, bạn đồng ý với Điều khoản dịch vụ".
class TermsNote extends StatelessWidget {
  const TermsNote({super.key});
  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodySmall;
    final l = context.l10n;
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(l.authTermsPrefix, style: style),
        InkWell(
          onTap: () => showTermsSheet(context),
          child: Text(
            l.authTermsLink,
            style: style?.copyWith(decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
          ),
        ),
        Text(l.authTermsSuffix, style: style),
      ],
    );
  }
}

Future<void> showTermsSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (ctx) => SafeArea(
    child: SizedBox(
      height: MediaQuery.of(ctx).size.height * 0.6,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xl),
        children: [
          Text(ctx.l10n.authTermsLink, style: ctx.textTheme.titleLarge),
          Gaps.v12,
          Text(ctx.l10n.authTermsBody, style: const TextStyle(height: 1.45)),
        ],
      ),
    ),
  ),
);

/// Thanh trên cùng "Quay lại" căn giữa (kiểu màn đăng ký / onboarding).
class GoBackHeader extends StatelessWidget {
  const GoBackHeader({super.key, this.onBack, this.trailing});
  final VoidCallback? onBack;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: Stack(
      alignment: Alignment.center,
      children: [
        TextButton(
          key: const ValueKey('go_back'),
          onPressed: onBack ?? () => context.canPop() ? context.pop() : context.go('/welcome'),
          style: TextButton.styleFrom(foregroundColor: context.colors.onSurfaceVariant),
          child: Text(context.l10n.commonBack, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        if (trailing != null) Positioned(right: Space.sm, child: trailing!),
      ],
    ),
  );
}

/// Minh hoạ điện thoại + email (màn xác nhận email / quên mật khẩu).
class PhoneMailIllustration extends StatelessWidget {
  const PhoneMailIllustration({super.key, this.size = 120});
  final double size;
  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final t = context.tokens;
    return SizedBox(
      width: size * 1.3,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(color: t.brandSoft, shape: BoxShape.circle),
          ),
          Container(
            width: size * 0.42,
            height: size * 0.72,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: Radii.mdAll,
              border: Border.all(color: cs.onSurface, width: 2),
            ),
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Container(height: 6, color: t.brand),
                Gaps.v4,
                Container(height: 4, color: cs.outline),
                const SizedBox(height: 3),
                Container(height: 4, color: cs.outline),
              ],
            ),
          ),
          Positioned(
            right: size * 0.12,
            bottom: size * 0.1,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: t.brand, shape: BoxShape.circle),
              child: const Icon(Icons.mark_email_read_outlined, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hộp báo lỗi đỏ nhạt (lỗi AuthException).
class AuthErrorBox extends StatelessWidget {
  const AuthErrorBox({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    final danger = context.tokens.danger;
    return Container(
      key: const ValueKey('auth_error'),
      padding: Insets.cardSm,
      decoration: BoxDecoration(color: danger.withValues(alpha: 0.1), borderRadius: Radii.mdAll),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: danger, size: 20),
          Gaps.h8,
          Expanded(
            child: Text(message, style: TextStyle(color: danger, fontSize: 13.5)),
          ),
        ],
      ),
    );
  }
}

/// Che email: "minhanh@gmail.com" -> "m•••••h@gmail.com".
String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 1) return email;
  final name = email.substring(0, at);
  final masked = name.length <= 2 ? '${name[0]}•' : '${name[0]}${'•' * (name.length - 2)}${name[name.length - 1]}';
  return masked + email.substring(at);
}
