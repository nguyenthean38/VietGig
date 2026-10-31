import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import 'widgets/auth_widgets.dart';

/// Quên mật khẩu: nhập email -> gửi liên kết đặt lại.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final email = _email.text.trim();
    if (!emailRegex.hasMatch(email)) {
      setState(() => _error = context.l10n.authForgotInvalidEmail);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await context.read<SessionController>().sendPasswordReset(email);
      if (!mounted) return;
      setState(() => _sent = true);
      showAppSnack(context, context.l10n.authForgotSent);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = authErrorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final muted = context.textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant);
    return Scaffold(
      appBar: SimpleAppBar(title: l.authForgotTitle),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Space.xl, Space.md, Space.xl, Space.xxl),
          children: [
            const Center(child: PhoneMailIllustration()),
            Gaps.v20,
            if (!_sent) ...[
              Text(l.authForgotHeading, style: context.textTheme.titleLarge),
              Gaps.v6,
              Text(l.authForgotBody, style: muted),
              const SizedBox(height: 18),
              TextField(
                key: const ValueKey('forgot_email'),
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() => _error = null),
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(hintText: l.authEmailHint, errorText: _error),
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                key: const ValueKey('forgot_submit'),
                label: l.authForgotSubmit,
                loading: _loading,
                onPressed: _send,
              ),
            ] else ...[
              Text(l.authForgotCheckInbox, textAlign: TextAlign.center, style: context.textTheme.titleLarge),
              Gaps.v8,
              Text(l.authForgotSentTo(_email.text.trim()), textAlign: TextAlign.center, style: muted),
              Gaps.v24,
              PrimaryButton(
                label: l.authBackToSignIn,
                onPressed: () => context.canPop() ? context.pop() : context.go('/auth/signin'),
              ),
              Gaps.v8,
              TextButton(onPressed: _loading ? null : _send, child: Text(l.authResendEmail)),
            ],
          ],
        ),
      ),
    );
  }
}
