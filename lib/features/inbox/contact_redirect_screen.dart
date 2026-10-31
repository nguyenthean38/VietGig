import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/app_controllers.dart';

/// Mở (hoặc tạo) hội thoại với [userId] rồi chuyển thẳng vào màn chat.
class ContactRedirectScreen extends StatefulWidget {
  const ContactRedirectScreen({super.key, required this.userId, this.gigId});
  final String userId;
  final String? gigId;

  @override
  State<ContactRedirectScreen> createState() => _ContactRedirectScreenState();
}

class _ContactRedirectScreenState extends State<ContactRedirectScreen> {
  Object? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    if (!mounted) return;
    setState(() => _error = null);
    try {
      final c = await context.read<InboxController>().open(widget.userId);
      if (!mounted) return;
      final gig = widget.gigId;
      final query = gig == null || gig.isEmpty ? '' : '?gig=${Uri.encodeQueryComponent(gig)}';
      context.pushReplacement('/chat/${c.id}$query');
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: SimpleAppBar(title: context.l10n.commonMessage),
    body: _error == null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [const CircularProgressIndicator(), Gaps.v16, Text(context.l10n.inboxOpening)],
            ),
          )
        : EmptyState(
            icon: Icons.error_outline_rounded,
            title: context.l10n.inboxOpenFailed,
            message: '$_error',
            actionLabel: context.l10n.commonRetry,
            onAction: _open,
          ),
  );
}
