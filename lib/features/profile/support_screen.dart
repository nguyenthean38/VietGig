import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/session_controller.dart';
import 'widgets/settings_widgets.dart';

/// Trung tâm hỗ trợ: câu hỏi thường gặp + liên hệ.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static List<({String q, String a})> faqs(AppLocalizations l) => [
    (q: l.profileFaqOrderQ, a: l.profileFaqOrderA),
    (q: l.profileFaqSafeQ, a: l.profileFaqSafeA),
    (q: l.profileFaqCancelQ, a: l.profileFaqCancelA),
    (q: l.profileFaqSellerQ, a: l.profileFaqSellerA),
    (q: l.profileFaqPayoutQ, a: l.profileFaqPayoutA),
    (q: l.profileFaqPasswordQ, a: l.profileFaqPasswordA),
  ];

  Future<void> _copy(BuildContext context, String v, String msg) async {
    await Clipboard.setData(ClipboardData(text: v));
    if (context.mounted) showAppSnack(context, msg);
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = context.watch<SessionController>().isSignedIn;
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(title: l.profileSupportCenter),
      body: ListView(
        padding: const EdgeInsets.only(bottom: Space.xxxl),
        children: [
          GroupTitle(l.profileFaq, padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.sm)),
          for (final f in faqs(l))
            ExpansionTile(
              title: Text(f.q, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              childrenPadding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, 14),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              shape: const Border(),
              collapsedShape: Border(bottom: BorderSide(color: context.colors.outlineVariant)),
              children: [Text(f.a, style: const TextStyle(height: 1.45))],
            ),
          GroupTitle(l.profileContactUs),
          MenuTile(
            title: l.profileSupportEmail,
            subtitle: l.profileSupportEmailHint('hotro@vietgig.vn'),
            icon: Icons.email_outlined,
            trailing: const Icon(Icons.copy_rounded, size: 18),
            onTap: () => _copy(context, 'hotro@vietgig.vn', l.profileSupportEmailCopied),
          ),
          MenuTile(
            title: l.profileHotline,
            subtitle: l.profileHotlineHint('1900 6868'),
            icon: Icons.phone_outlined,
            trailing: const Icon(Icons.copy_rounded, size: 18),
            onTap: () => _copy(context, '19006868', l.profileHotlineCopied),
          ),
          MenuTile(
            title: l.profileSupportRequest,
            subtitle: signedIn ? l.profileSupportRequestHint : l.profileSupportRequestSignIn,
            icon: Icons.support_agent_rounded,
            onTap: () => context.push(signedIn ? '/feedback?kind=bug' : '/auth/signin'),
          ),
        ],
      ),
    );
  }
}
