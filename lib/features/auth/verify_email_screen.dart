import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/session_controller.dart';
import 'widgets/auth_widgets.dart';

/// Xác nhận email: gửi lại (có đếm ngược), đổi email, nút mô phỏng "Tôi đã xác nhận".
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  static const _cooldown = 60;
  int _left = 0;
  Timer? _timer;
  bool _sending = false;
  bool _verifying = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _left = _cooldown);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _left--);
      if (_left <= 0) t.cancel();
    });
  }

  Future<void> _resend() async {
    setState(() => _sending = true);
    try {
      await context.read<SessionController>().resendVerification();
      if (!mounted) return;
      showAppSnack(context, context.l10n.authVerifyResent);
      _startCountdown();
    } catch (_) {
      if (mounted) showAppSnack(context, context.l10n.authVerifySendFailed, success: false);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _verified() async {
    setState(() => _verifying = true);
    try {
      await context.read<SessionController>().verifyEmail();
      if (!mounted) return;
      showAppSnack(context, context.l10n.authVerifyActivated);
      context.canPop() ? context.pop() : context.go('/profile');
    } catch (_) {
      if (mounted) showAppSnack(context, context.l10n.authVerifyNotYet, success: false);
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final user = context.watch<SessionController>().user;
    final email = user?.email ?? '';
    final verified = user?.emailVerified ?? false;
    final muted = context.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.4);

    return Scaffold(
      appBar: const SimpleAppBar(title: '', close: true),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(Space.xxl),
                children: [
                  const Center(child: PhoneMailIllustration(size: 130)),
                  const SizedBox(height: 28),
                  Text(
                    verified ? l.authVerifyDoneTitle : l.authVerifyTitle,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleLarge,
                  ),
                  Gaps.v12,
                  Text(l.authVerifySentTo, textAlign: TextAlign.center, style: muted),
                  Gaps.v4,
                  Text(
                    maskEmail(email),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 14),
                  Text(l.authVerifyBody, textAlign: TextAlign.center, style: muted),
                  const SizedBox(height: 22),
                  Text(l.authVerifyWrongEmail, textAlign: TextAlign.center, style: muted),
                  Center(
                    child: TextButton(
                      key: const ValueKey('verify_change_email'),
                      onPressed: () => context.push('/settings/email'),
                      child: Text(
                        l.authVerifyChangeEmail,
                        style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  if (!verified) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: Insets.cardSm,
                      decoration: BoxDecoration(
                        color: context.tokens.info.withValues(alpha: 0.1),
                        borderRadius: Radii.mdAll,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.science_outlined, color: context.tokens.info, size: 20),
                          Gaps.h10,
                          Expanded(child: Text(l.authVerifyDemoNote, style: context.textTheme.bodySmall)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, Space.md),
              child: Column(
                children: [
                  if (!verified) ...[
                    PrimaryButton(
                      key: const ValueKey('verify_done'),
                      label: l.authVerifyConfirm,
                      loading: _verifying,
                      onPressed: _verified,
                    ),
                    Gaps.v10,
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        key: const ValueKey('verify_resend'),
                        onPressed: _left > 0 || _sending ? null : _resend,
                        child: _sending
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(_left > 0 ? l.authResendIn(_left) : l.authResendEmail),
                      ),
                    ),
                  ] else
                    PrimaryButton(
                      label: l.authContinue,
                      onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
