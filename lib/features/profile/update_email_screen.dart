import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import '../auth/widgets/auth_widgets.dart';

/// Đổi địa chỉ email: hiển thị email hiện tại (che), nhập email mới, gửi xác nhận.
class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({super.key});
  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final _email = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final session = context.read<SessionController>();
    final l = context.l10n;
    final v = _email.text.trim();
    String? err;
    if (v.isEmpty) {
      err = l.profileNewEmailRequired;
    } else if (!emailRegex.hasMatch(v)) {
      err = l.profileEmailInvalid;
    } else if (v.toLowerCase() == session.user?.email.toLowerCase()) {
      err = l.profileEmailMustDiffer;
    }
    setState(() => _error = err);
    if (err != null) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await session.updateEmail(v);
      if (!mounted) return;
      showAppSnack(context, l.profileEmailUpdated);
      context.canPop() ? context.pop() : context.go('/settings/account');
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = authErrorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final email = context.watch<SessionController>().user?.email ?? '';
    final small = context.textTheme.bodySmall;
    return Scaffold(
      appBar: const SimpleAppBar(title: ''),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, Space.xxl),
        children: [
          Text(l.profileUpdateEmailTitle, style: context.textTheme.headlineSmall),
          Gaps.v6,
          Text(l.profileUpdateEmailIntro, style: context.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 22),
          Text(l.profileCurrentEmail, style: small),
          Gaps.v4,
          Text(maskEmail(email), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          Gaps.v20,
          Text(l.profileNewEmail, style: small),
          Gaps.v6,
          TextField(
            key: const ValueKey('new_email'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            onChanged: (_) => _error == null ? null : setState(() => _error = null),
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(hintText: l.profileEmailHint, errorText: _error),
          ),
          Gaps.v20,
          PrimaryButton(
            key: const ValueKey('update_email_submit'),
            label: l.profileUpdateEmailSubmit,
            loading: _loading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
