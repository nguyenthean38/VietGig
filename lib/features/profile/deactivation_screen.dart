import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import 'widgets/settings_widgets.dart';

enum _Choice { deactivate, delete }

/// Huỷ kích hoạt / xoá tài khoản – 3 bước: chọn → điều gì xảy ra → lý do.
class DeactivationScreen extends StatefulWidget {
  const DeactivationScreen({super.key});
  @override
  State<DeactivationScreen> createState() => _DeactivationScreenState();
}

class _DeactivationScreenState extends State<DeactivationScreen> {
  /// Mã lý do (dùng cho ValueKey) – nhãn dịch ở [_reasonLabel].
  static const _reasons = ['emails', 'username', 'otherAccount', 'notFound', 'complex', 'badSeller', 'policy', 'other'];

  static String _reasonLabel(AppLocalizations l, String id) => switch (id) {
    'emails' => l.profileReasonEmails,
    'username' => l.profileReasonUsername,
    'otherAccount' => l.profileReasonOtherAccount,
    'notFound' => l.profileReasonNotFound,
    'complex' => l.profileReasonComplex,
    'badSeller' => l.profileReasonBadSeller,
    'policy' => l.profileReasonPolicy,
    _ => l.profileReasonOther,
  };

  int _step = 0;
  _Choice? _choice;
  String? _reason;
  final _more = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _more.dispose();
    super.dispose();
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.canPop() ? context.pop() : context.go('/settings/account');
    }
  }

  Future<void> _continue() async {
    final l = context.l10n;
    if (_step == 0) {
      if (_choice == _Choice.delete) {
        setState(() => _step = 1);
        return;
      }
      final ok = await confirmDialog(
        context,
        title: l.profileDeactivateConfirmTitle,
        message: l.profileDeactivateConfirmMessage,
        confirmLabel: l.profileDeactivateConfirm,
        destructive: true,
      );
      if (ok && mounted) await _run(() => context.read<SessionController>().deactivateAccount());
    } else if (_step == 1) {
      setState(() => _step = 2);
    } else {
      final ok = await confirmDialog(
        context,
        title: l.profileDeleteConfirmTitle,
        message: l.profileDeleteConfirmMessage,
        confirmLabel: l.profileDeleteAccount,
        destructive: true,
      );
      if (!ok || !mounted) return;
      final reason = [_reasonLabel(l, _reason!), if (_more.text.trim().isNotEmpty) _more.text.trim()].join(' – ');
      await _run(() => context.read<SessionController>().deleteAccount(reason));
    }
  }

  /// Gọi thao tác; thành công thì router tự về /welcome, lỗi thì hiện dialog.
  Future<void> _run(Future<void> Function() action) async {
    final l = context.l10n;
    setState(() => _loading = true);
    try {
      await action();
    } on AuthException catch (e) {
      if (mounted) {
        await infoDialog(context, title: l.profileActionNotAllowed, message: authErrorText(l, e));
      }
    } catch (_) {
      if (mounted) showAppSnack(context, l.profileGenericError, success: false);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _canContinue => switch (_step) {
    0 => _choice != null,
    1 => true,
    _ => _reason != null,
  };

  String _buttonLabel(AppLocalizations l) => switch (_step) {
    0 => _choice == _Choice.deactivate ? l.profileDeactivateAccount : l.profileContinue,
    1 => l.profileContinueDelete,
    _ => l.profileDeleteAccount,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: SimpleAppBar(title: _step == 0 ? l.profileDeactivateTitle : l.profileDeleteAccount, onBack: _back),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(key: ValueKey(_step), child: _body(l)),
        ),
        bottomNavigationBar: BottomActionBar(
          child: PrimaryButton(
            key: const ValueKey('deactivate_continue'),
            label: _buttonLabel(l),
            color: context.tokens.danger,
            loading: _loading,
            onPressed: _canContinue ? _continue : null,
          ),
        ),
      ),
    );
  }

  Widget _body(AppLocalizations l) {
    final muted = context.textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant, height: 1.45);
    final h = context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700);
    const pagePadding = EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.xxl);
    switch (_step) {
      case 0:
        return ListView(
          padding: pagePadding,
          children: [
            Text(l.profileDeactivateHeading, style: h),
            Gaps.v8,
            Text(l.profileDeactivateIntro, style: muted),
            Gaps.v20,
            RadioCard(
              key: const ValueKey('choice_deactivate'),
              title: l.profileDeactivateAccount,
              description: l.profileDeactivateDescription,
              selected: _choice == _Choice.deactivate,
              onTap: () => setState(() => _choice = _Choice.deactivate),
            ),
            Gaps.v12,
            RadioCard(
              key: const ValueKey('choice_delete'),
              title: l.profileDeleteAccount,
              description: l.profileDeleteDescription,
              selected: _choice == _Choice.delete,
              onTap: () => setState(() => _choice = _Choice.delete),
            ),
          ],
        );
      case 1:
        Widget bullet(String t) => Padding(
          padding: const EdgeInsets.only(bottom: Space.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 7), child: Icon(Icons.circle, size: 6)),
              Gaps.h10,
              Expanded(child: Text(t, style: muted)),
            ],
          ),
        );
        return ListView(
          padding: pagePadding,
          children: [
            Text(l.profileDeleteWhatHappens, style: h),
            Gaps.v8,
            Text(l.profileDeletePermanentNote, style: muted),
            Gaps.v16,
            bullet(l.profileDeleteBulletUsername),
            bullet(l.profileDeleteBulletData),
            bullet(l.profileDeleteBulletBalance),
            bullet(l.profileDeleteBulletReview),
          ],
        );
      default:
        return ListView(
          padding: const EdgeInsets.only(top: Space.sm, bottom: Space.xxl),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.xs, Space.lg, Space.sm),
              child: Text(l.profileLeavingBecause, style: h),
            ),
            for (final r in _reasons)
              InkWell(
                key: ValueKey('reason_$r'),
                onTap: () => setState(() => _reason = r),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 13),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: context.colors.outlineVariant)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(_reasonLabel(l, r), style: const TextStyle(fontSize: 15))),
                      if (_reason == r) Icon(Icons.check_rounded, color: context.tokens.brand),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.xl, Space.lg, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.profileTellUsMore, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Gaps.v8,
                  CountedTextField(
                    fieldKey: const ValueKey('delete_more'),
                    controller: _more,
                    hint: l.profileTellUsMoreHint,
                    maxLength: 500,
                    minLines: 3,
                    maxLines: 6,
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }
}
