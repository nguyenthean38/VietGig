import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import 'widgets/auth_widgets.dart';

/// Đăng nhập bằng email/tên người dùng + mật khẩu.
/// Thành công -> router tự chuyển về `from` hoặc /home.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static const _demoEmail = 'minhanh@gmail.com';
  static const _demoPassword = 'Matkhau1';

  final _id = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;
  bool _tried = false;

  @override
  void initState() {
    super.initState();
    _id.addListener(_changed);
    _password.addListener(_changed);
  }

  void _changed() => setState(() => _error = null);

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _tried = true);
    if (_id.text.trim().isEmpty || _password.text.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await context.read<SessionController>().signIn(_id.text.trim(), _password.text);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = authErrorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(context.read<SessionController>().isGuest ? '/home' : '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final small = context.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant);
    Widget? clear(TextEditingController c) => c.text.isEmpty
        ? null
        : IconButton(tooltip: l.authClear, icon: const Icon(Icons.cancel_rounded, size: 20), onPressed: c.clear);

    return Scaffold(
      appBar: SimpleAppBar(title: '', close: true, onBack: _close),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Space.xl, Space.xs, Space.xl, Space.xxl),
          children: [
            Text(l.authSignInTitle, style: context.textTheme.headlineSmall),
            Gaps.v6,
            Text(l.authSignInSubtitle, style: small),
            const SizedBox(height: 22),
            TextField(
              key: const ValueKey('signin_id'),
              controller: _id,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email, AutofillHints.username],
              decoration: InputDecoration(
                hintText: l.authIdHint,
                suffixIcon: clear(_id),
                errorText: _tried && _id.text.trim().isEmpty ? l.authIdRequired : null,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              key: const ValueKey('signin_password'),
              controller: _password,
              obscureText: _obscure,
              onSubmitted: (_) => _submit(),
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                hintText: l.authPasswordHint,
                errorText: _tried && _password.text.isEmpty ? l.authPasswordRequired : null,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ?clear(_password),
                    IconButton(
                      tooltip: _obscure ? l.authShowPassword : l.authHidePassword,
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const ValueKey('signin_forgot'),
                onPressed: () => context.push('/auth/forgot'),
                child: Text(l.authForgotLink, style: const TextStyle(decoration: TextDecoration.underline)),
              ),
            ),
            if (_error != null) ...[AuthErrorBox(message: _error!), const SizedBox(height: 14)],
            PrimaryButton(
              key: const ValueKey('signin_submit'),
              label: l.authContinue,
              loading: _loading,
              onPressed: _submit,
            ),
            const OrDivider(),
            const SocialButtons(),
            const SizedBox(height: 22),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(l.authNoAccount, style: small),
                InkWell(
                  key: const ValueKey('signin_join'),
                  onTap: () => context.pushReplacement('/auth/signup'),
                  child: Text(
                    l.authJoinNow,
                    style: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            Gaps.v24,
            Container(
              padding: const EdgeInsets.fromLTRB(Space.md, Space.xs, Space.xs, Space.xs),
              decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: Radii.mdAll),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, size: 18, color: cs.onSurfaceVariant),
                  Gaps.h8,
                  Expanded(child: Text(l.authDemoAccount(_demoEmail, _demoPassword), style: small)),
                  TextButton(
                    onPressed: () {
                      _id.text = _demoEmail;
                      _password.text = _demoPassword;
                    },
                    child: Text(l.authFill),
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
