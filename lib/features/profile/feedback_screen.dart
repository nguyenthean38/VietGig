import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/account.dart';
import '../../data/repositories/repositories.dart';
import 'widgets/settings_widgets.dart';

/// Gửi góp ý: chia sẻ ý tưởng (idea) hoặc báo lỗi (bug).
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key, this.kind = 'idea'});
  final String kind;
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  /// Mã khu vực (dùng cho ValueKey và lưu góp ý) – nhãn dịch ở [_areaLabel].
  static const _areas = <({String id, IconData icon})>[
    (id: 'notifications', icon: Icons.notifications_none_rounded),
    (id: 'inbox', icon: Icons.mail_outline_rounded),
    (id: 'search', icon: Icons.search_rounded),
    (id: 'payments', icon: Icons.payments_outlined),
    (id: 'orders', icon: Icons.assignment_outlined),
    (id: 'other', icon: Icons.more_horiz_rounded),
  ];

  static String _areaLabel(AppLocalizations l, String id) => switch (id) {
    'notifications' => l.profileAreaNotifications,
    'inbox' => l.profileAreaInbox,
    'search' => l.profileAreaSearch,
    'payments' => l.profileAreaPayments,
    'orders' => l.profileAreaOrders,
    _ => l.profileAreaOther,
  };
  static const _minChars = 10;

  final _text = TextEditingController();
  String? _area;
  String? _attachment;
  bool? _canContact;
  bool _submitted = false;
  bool _sending = false;

  bool get _isBug => widget.kind == 'bug';

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _valid => _area != null && _text.text.trim().length >= _minChars && _canContact != null;

  Future<void> _attach() async {
    final l = context.l10n;
    final file = await showActionSheet<String>(
      context,
      title: l.profileAttachFile,
      actions: [
        SheetAction(label: l.profileAttachScreenshot, value: 'anh_chup_man_hinh.png', icon: Icons.image_outlined),
        SheetAction(label: l.profileAttachDocument, value: 'mo_ta_chi_tiet.pdf', icon: Icons.description_outlined),
      ],
    );
    if (file != null) setState(() => _attachment = file);
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!_valid) return;
    FocusScope.of(context).unfocus();
    final l = context.l10n;
    setState(() => _sending = true);
    try {
      await context.read<AccountRepository>().sendFeedback(
        FeedbackEntry(
          kind: widget.kind,
          area: _area!,
          text: _text.text.trim(),
          canContact: _canContact!,
          attachment: _attachment,
        ),
      );
      if (!mounted) return;
      await infoDialog(
        context,
        title: _isBug ? l.profileFeedbackThanksBug : l.profileFeedbackThanksIdea,
        message: _isBug ? l.profileFeedbackThanksBugMessage : l.profileFeedbackThanksIdeaMessage,
        ok: l.commonClose,
      );
      if (mounted) context.canPop() ? context.pop() : context.go('/profile');
    } catch (_) {
      if (mounted) showAppSnack(context, l.profileFeedbackSendFailed, success: false);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    final q = context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    Widget err(String t) => Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(t, style: TextStyle(color: context.tokens.danger, fontSize: 12.5)),
    );

    return Scaffold(
      appBar: SimpleAppBar(title: _isBug ? l.profileFeedbackBug : l.profileFeedbackIdea, close: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
        children: [
          Text(_isBug ? l.profileFeedbackAreaBug : l.profileFeedbackAreaIdea, style: q),
          Gaps.v12,
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final a in _areas)
                SelectChip(
                  key: ValueKey('area_${a.id}'),
                  label: _areaLabel(l, a.id),
                  icon: a.icon,
                  selected: _area == a.id,
                  onTap: () => setState(() => _area = a.id),
                ),
            ],
          ),
          if (_submitted && _area == null) err(l.profileFeedbackAreaRequired),
          Gaps.v24,
          Text(_isBug ? l.profileFeedbackDescribeBug : l.profileFeedbackDescribeIdea, style: q),
          Gaps.v10,
          CountedTextField(
            fieldKey: const ValueKey('feedback_text'),
            controller: _text,
            onChanged: (_) => setState(() {}),
            hint: _isBug ? l.profileFeedbackBugHintText : l.profileFeedbackIdeaHintText,
          ),
          if (_submitted && _text.text.trim().length < _minChars) err(l.profileFeedbackMinChars(_minChars)),
          Gaps.v12,
          if (_attachment == null)
            OutlinedButton.icon(
              key: const ValueKey('attach_file'),
              onPressed: _attach,
              icon: const Icon(Icons.attach_file_rounded, size: 20),
              label: Text(l.profileAttachFile),
            )
          else
            Container(
              padding: const EdgeInsets.fromLTRB(Space.md, Space.xs, Space.xs, Space.xs),
              decoration: BoxDecoration(
                borderRadius: Radii.mdAll,
                border: Border.all(color: cs.outline),
              ),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file_outlined, color: cs.onSurfaceVariant),
                  Gaps.h10,
                  Expanded(child: Text(_attachment!, overflow: TextOverflow.ellipsis)),
                  IconButton(
                    tooltip: l.profileRemoveFile,
                    onPressed: () => setState(() => _attachment = null),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 26),
          Text(l.profileFeedbackCanContact, style: q),
          Gaps.v4,
          RadioRow(
            key: const ValueKey('contact_yes'),
            label: l.profileFeedbackContactYes,
            selected: _canContact == true,
            onTap: () => setState(() => _canContact = true),
          ),
          RadioRow(
            key: const ValueKey('contact_no'),
            label: l.profileFeedbackContactNo,
            selected: _canContact == false,
            onTap: () => setState(() => _canContact = false),
          ),
          if (_submitted && _canContact == null) err(l.profileFeedbackChoiceRequired),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          key: const ValueKey('feedback_submit'),
          label: l.profileFeedbackSubmit,
          loading: _sending,
          onPressed: _submit,
        ),
      ),
    );
  }
}
