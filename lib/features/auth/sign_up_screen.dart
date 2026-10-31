import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import 'widgets/auth_widgets.dart';

/// Đăng ký tài khoản: tên người dùng, email, mật khẩu (checklist realtime).
/// Đăng ký thành công -> router tự chuyển sang /onboarding.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  static final _userRx = RegExp(r'^[a-zA-Z0-9_.]{4,20}$');

  @override
  void initState() {
    super.initState();
    for (final c in [_username, _email, _password]) {
      c.addListener(() => setState(() => _error = null));
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _userOk => _userRx.hasMatch(_username.text.trim());
  bool get _emailOk => emailRegex.hasMatch(_email.text.trim());
  bool get _pwOk => PasswordRules.valid(_password.text);
  bool get _canSubmit => _userOk && _emailOk && _pwOk && !_loading;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await context.read<SessionController>().signUp(_username.text.trim(), _email.text.trim(), _password.text);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = authErrorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final t = context.tokens;
    final l = context.l10n;
    final small = context.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant);
    Widget? okIcon(bool ok, String text) => text.isEmpty
        ? null
        : Icon(ok ? Icons.check_rounded : Icons.error_outline_rounded, color: ok ? t.brand : t.danger, size: 20);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const GoBackHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, Space.xxl),
                children: [
                  Text(l.authSignUpTitle, style: context.textTheme.headlineSmall),
                  Gaps.v6,
                  Text(l.authSignUpSubtitle, style: small),
                  Gaps.v20,
                  TextField(
                    key: const ValueKey('signup_username'),
                    controller: _username,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: l.authUsernameHint,
                      suffixIcon: okIcon(_userOk, _username.text),
                      errorText: _username.text.isNotEmpty && !_userOk ? l.authUsernameInvalid : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: Space.xxs),
                    child: Text(l.authUsernameNote, style: small),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    key: const ValueKey('signup_email'),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: l.authEmailHint,
                      suffixIcon: okIcon(_emailOk, _email.text),
                      errorText: _email.text.isNotEmpty && !_emailOk ? l.authEmailInvalid : null,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    key: const ValueKey('signup_password'),
                    controller: _password,
                    obscureText: _obscure,
                    onSubmitted: (_) => _canSubmit ? _submit() : null,
                    decoration: InputDecoration(
                      hintText: l.authPasswordHint,
                      suffixIcon: IconButton(
                        tooltip: _obscure ? l.authShowPassword : l.authHidePassword,
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  Gaps.v6,
                  PasswordChecklist(password: _password.text),
                  if (_error != null) ...[const SizedBox(height: 14), AuthErrorBox(message: _error!)],
                  const SizedBox(height: 22),
                  PrimaryButton(
                    key: const ValueKey('signup_submit'),
                    label: l.authSignUpSubmit,
                    loading: _loading,
                    onPressed: _canSubmit ? _submit : null,
                  ),
                  const OrDivider(),
                  const SocialButtons(),
                  Gaps.v20,
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(l.authHaveAccount, style: small),
                      InkWell(
                        onTap: () => context.pushReplacement('/auth/signin'),
                        child: Text(
                          l.commonSignIn,
                          style: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(Space.xl, Space.xs, Space.xl, Space.md), child: TermsNote()),
          ],
        ),
      ),
    );
  }
}
