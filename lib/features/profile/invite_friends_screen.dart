import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/session_controller.dart';

/// Mời bạn bè: mã giới thiệu, sao chép & chia sẻ.
class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  static String codeFor(String username) => 'VG-${username.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase()}';

  Future<void> _copy(BuildContext context, String text, String msg) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) showAppSnack(context, msg);
  }

  Future<void> _share(BuildContext context, String link) async {
    final l = context.l10n;
    final app = await showActionSheet<String>(
      context,
      title: l.profileShareVia,
      actions: [
        const SheetAction(label: 'Zalo', value: 'Zalo', icon: Icons.chat_rounded),
        const SheetAction(label: 'Messenger', value: 'Messenger', icon: Icons.messenger_outline_rounded),
        const SheetAction(label: 'Email', value: 'Email', icon: Icons.email_outlined),
        SheetAction(label: l.profileShareSms, value: 'SMS', icon: Icons.sms_outlined),
      ],
    );
    if (app == null || !context.mounted) return;
    // Bản mock: sao chép liên kết để người dùng dán vào ứng dụng đã chọn.
    await _copy(context, link, l.profileShareLinkCopied(app));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionController>().user;
    final code = codeFor(user?.username ?? 'ban');
    final link = 'https://vietgig.vn/moi/$code';
    final cs = context.colors;
    final l = context.l10n;
    final plum = context.tokens.plum;
    final muted = context.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.4);

    Widget step(int n, String title, String desc) => Padding(
      padding: const EdgeInsets.only(bottom: Space.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: plum.withValues(alpha: 0.14), shape: BoxShape.circle),
            child: Text(
              '$n',
              style: TextStyle(color: plum, fontWeight: FontWeight.w700),
            ),
          ),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                Gaps.v2,
                Text(desc, style: muted),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: SimpleAppBar(title: l.profileInviteFriends),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
        children: [
          Container(
            padding: const EdgeInsets.all(Space.xl),
            decoration: BoxDecoration(color: plum, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 34),
                Gaps.v12,
                Text(
                  l.profileInviteHeadline,
                  style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800),
                ),
                Gaps.v8,
                Text(l.profileInviteBody, style: const TextStyle(color: Colors.white, height: 1.4)),
              ],
            ),
          ),
          Gaps.v24,
          Text(l.profileReferralCode, style: context.textTheme.titleMedium),
          Gaps.v10,
          Container(
            padding: const EdgeInsets.fromLTRB(Space.lg, 6, 6, 6),
            decoration: BoxDecoration(
              borderRadius: Radii.lgAll,
              border: Border.all(color: cs.outline),
              color: cs.surfaceContainerHighest,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    code,
                    key: const ValueKey('referral_code'),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                  ),
                ),
                TextButton.icon(
                  key: const ValueKey('copy_code'),
                  onPressed: () => _copy(context, code, l.profileCodeCopied),
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: Text(l.profileCopy),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copy(context, link, l.profileInviteLinkCopied),
                  icon: const Icon(Icons.link_rounded, size: 20),
                  label: Text(l.profileCopyLink),
                ),
              ),
              Gaps.h10,
              Expanded(
                child: FilledButton.icon(
                  key: const ValueKey('share_invite'),
                  onPressed: () => _share(context, link),
                  icon: const Icon(Icons.ios_share_rounded, size: 20),
                  label: Text(l.profileShare),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(l.profileHowItWorks, style: context.textTheme.titleMedium),
          const SizedBox(height: 14),
          step(1, l.profileInviteStep1Title, l.profileInviteStep1),
          step(2, l.profileInviteStep2Title, l.profileInviteStep2),
          step(3, l.profileInviteStep3Title, l.profileInviteStep3),
        ],
      ),
    );
  }
}
