import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/chat.dart';
import 'offer_form_widgets.dart';
import 'offer_sheets.dart';

/// Kết quả màn sửa cột mốc: cột mốc mới, hoặc [delete] = true để xoá.
typedef MilestoneResult = ({Milestone? milestone, bool delete});

/// Mở màn "Cột mốc n" toàn màn hình.
Future<MilestoneResult?> showMilestoneEditor(BuildContext context, {required int number, Milestone? initial}) =>
    Navigator.of(context).push<MilestoneResult>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => MilestoneEditor(number: number, initial: initial),
      ),
    );

/// Màn "Cột mốc n".
class MilestoneEditor extends StatefulWidget {
  const MilestoneEditor({super.key, required this.number, this.initial});
  final int number;
  final Milestone? initial;
  @override
  State<MilestoneEditor> createState() => _MilestoneEditorState();
}

class _MilestoneEditorState extends State<MilestoneEditor> {
  late final _title = TextEditingController(text: widget.initial?.title);
  late final _desc = TextEditingController(text: widget.initial?.description);
  late final _price = TextEditingController(text: widget.initial?.price.toString());
  late int? _days = widget.initial?.deliveryDays;
  late int _revisions = widget.initial?.revisions ?? 1;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_title, _desc, _price]) {
      c.addListener(() {
        if (_submitted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _price.dispose();
    super.dispose();
  }

  String? _titleError(AppLocalizations l) => _title.text.trim().isEmpty ? l.inboxErrMsTitle : null;
  String? _descError(AppLocalizations l) => _desc.text.trim().isEmpty ? l.inboxErrMsDesc : null;
  String? _daysError(AppLocalizations l) => _days == null ? l.inboxErrDays : null;
  String? _priceError(AppLocalizations l) {
    final p = parseMoney(_price.text);
    if (p == null || p < kMinOfferPrice) return l.inboxErrMinPrice(Fmt.money(kMinOfferPrice));
    return null;
  }

  void _save() {
    final l = context.l10n;
    setState(() => _submitted = true);
    if ([_titleError(l), _descError(l), _daysError(l), _priceError(l)].any((e) => e != null)) return;
    Navigator.pop<MilestoneResult>(context, (
      milestone: Milestone(
        title: _title.text.trim(),
        description: _desc.text.trim(),
        price: parseMoney(_price.text)!,
        deliveryDays: _days!,
        revisions: _revisions,
      ),
      delete: false,
    ));
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l.inboxDeleteMilestoneTitle,
      confirmLabel: l.commonDelete,
      destructive: true,
    );
    if (ok && mounted) Navigator.pop<MilestoneResult>(context, (milestone: null, delete: true));
  }

  @override
  Widget build(BuildContext context) {
    final err = _submitted;
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(
        title: l.inboxMilestoneN(widget.number),
        actions: [
          if (widget.initial != null)
            IconButton(
              tooltip: l.inboxDeleteMilestone,
              icon: Icon(Icons.delete_outline_rounded, color: context.tokens.danger),
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
        children: [
          OfferSectionHeader(l.inboxMsTitleHeader),
          TextField(
            key: const ValueKey('ms_title'),
            controller: _title,
            maxLength: 50,
            decoration: InputDecoration(hintText: l.inboxMsTitleHint),
          ),
          if (err) OfferErrorText(_titleError(l)),
          Gaps.v16,
          OfferSectionHeader(l.inboxDescHeader),
          CountedTextField(
            fieldKey: const ValueKey('ms_desc'),
            controller: _desc,
            hint: l.inboxMsDescHint,
            maxLength: 1200,
            minLines: 4,
            maxLines: 8,
          ),
          if (err) OfferErrorText(_descError(l)),
          Gaps.v8,
          OfferFieldRow(
            key: const ValueKey('ms_days'),
            label: l.inboxDeliveryTime,
            value: _days == null ? l.inboxPick : Fmt.days(_days!),
            onTap: () async {
              final d = await pickDeliveryDays(context, current: _days, keyPrefix: 'msdays');
              if (d != null) setState(() => _days = d);
            },
          ),
          if (err) OfferErrorText(_daysError(l)),
          OfferFieldRow(
            key: const ValueKey('ms_revisions'),
            label: l.inboxRevisionsOptional,
            value: l.inboxRevisionsCount(_revisions),
            onTap: () async {
              final r = await pickRevisions(context, current: _revisions, keyPrefix: 'msrev');
              if (r != null) setState(() => _revisions = r);
            },
          ),
          OfferFieldRow(
            label: l.inboxMsPriceLabel(Fmt.moneyShort(kMinOfferPrice)),
            trailing: MoneyField(fieldKey: const ValueKey('ms_price'), controller: _price),
          ),
          if (err) OfferErrorText(_priceError(l)),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(key: const ValueKey('ms_save'), label: l.commonSave, onPressed: _save),
      ),
    );
  }
}
