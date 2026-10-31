import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/chat.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import 'widgets/milestone_editor.dart';
import 'widgets/offer_form_widgets.dart';
import 'widgets/offer_settings_section.dart';
import 'widgets/offer_sheets.dart';
import 'widgets/service_options_sheet.dart';

/// Người bán tạo báo giá riêng (thanh toán một lần hoặc theo cột mốc).
class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({super.key, required this.conversationId});
  final String conversationId;

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  late Future<List<Gig>> _gigsFuture;
  Gig? _gig;

  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _templateName = TextEditingController();

  bool _milestoneMode = false;
  int? _days;
  int _revisions = 1;
  final List<Milestone> _milestones = [];

  int _pages = 0;
  final Set<OfferAddon> _options = {};

  int _expiryDays = 3;
  bool _requireReq = true;
  bool _saveTemplate = false;

  bool _submitted = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _gigsFuture = _loadGigs();
    for (final c in [_desc, _price, _templateName]) {
      c.addListener(_refresh);
    }
  }

  void _refresh() {
    if (_submitted) setState(() {});
  }

  @override
  void dispose() {
    _desc.dispose();
    _price.dispose();
    _templateName.dispose();
    super.dispose();
  }

  Future<List<Gig>> _loadGigs() async {
    final catalog = context.read<CatalogRepository>();
    final me = context.read<SessionController>().userId;
    var gigs = await catalog.gigsBySeller(me);
    // Tài khoản mẫu chưa có dịch vụ: dùng dịch vụ của người bán mẫu để thử tính năng.
    if (gigs.isEmpty) gigs = await catalog.gigsBySeller('u_hoang');
    if (mounted && gigs.isNotEmpty) setState(() => _gig ??= gigs.first);
    return gigs;
  }

  // ------------------------------------------------------------ dữ liệu suy ra
  List<String> _serviceOptions(AppLocalizations l) => [
    if (_pages > 0) l.inboxOptPages(_pages),
    for (final o in OfferAddon.values)
      if (_options.contains(o)) o.localized(l),
  ];

  int get _optionCount => (_pages > 0 ? 1 : 0) + _options.length;

  int get _msTotal => _milestones.fold(0, (s, m) => s + m.price);
  int get _msDays => _milestones.fold(0, (s, m) => s + m.deliveryDays);
  int get _msRevisions => _milestones.fold(0, (s, m) => s + m.revisions);

  String? _gigError(AppLocalizations l) => _gig == null ? l.inboxErrGig : null;
  String? _descError(AppLocalizations l) {
    final t = _desc.text.trim();
    if (t.isEmpty) return l.inboxErrDescEmpty;
    if (t.length < 20) return l.inboxErrDescShort;
    return null;
  }

  String? _priceError(AppLocalizations l) {
    if (_milestoneMode) return null;
    final p = parseMoney(_price.text);
    if (p == null) return l.inboxErrPriceEmpty;
    if (p < kMinOfferPrice) return l.inboxErrMinPrice(Fmt.money(kMinOfferPrice));
    return null;
  }

  String? _daysError(AppLocalizations l) => !_milestoneMode && _days == null ? l.inboxErrDays : null;
  String? _milestoneError(AppLocalizations l) => _milestoneMode && _milestones.length < 2 ? l.inboxErrMilestones : null;
  String? _templateError(AppLocalizations l) =>
      _saveTemplate && _templateName.text.trim().isEmpty ? l.inboxErrTemplate : null;

  bool _valid(AppLocalizations l) => [
    _gigError(l),
    _descError(l),
    _priceError(l),
    _daysError(l),
    _milestoneError(l),
    _templateError(l),
  ].every((e) => e == null);

  // ------------------------------------------------------------ chọn
  Future<void> _pickGig(List<Gig> gigs) async {
    final g = await showGigPicker(context, gigs: gigs, current: _gig);
    if (g != null) setState(() => _gig = g);
  }

  Future<void> _pickPaymentType() async {
    final r = await showPaymentTypeSheet(context, milestone: _milestoneMode);
    if (r != null) setState(() => _milestoneMode = r);
  }

  Future<void> _pickDays() async {
    final d = await pickDeliveryDays(context, current: _days);
    if (d != null) setState(() => _days = d);
  }

  Future<void> _pickRevisions() async {
    final r = await pickRevisions(context, current: _revisions);
    if (r != null) setState(() => _revisions = r);
  }

  Future<void> _pickExpiry() async {
    final r = await pickOfferExpiry(context, current: _expiryDays);
    if (r != null) setState(() => _expiryDays = r);
  }

  Future<void> _pickOptions() async {
    final r = await showServiceOptionsSheet(context, pages: _pages, options: _options);
    if (r == null) return;
    setState(() {
      _pages = r.pages;
      _options
        ..clear()
        ..addAll(r.options);
    });
  }

  Future<void> _editMilestone([int? index]) async {
    final r = await showMilestoneEditor(
      context,
      number: (index ?? _milestones.length) + 1,
      initial: index == null ? null : _milestones[index],
    );
    if (r == null || !mounted) return;
    setState(() {
      if (r.delete) {
        if (index != null) _milestones.removeAt(index);
      } else if (index == null) {
        _milestones.add(r.milestone!);
      } else {
        _milestones[index] = r.milestone!;
      }
    });
  }

  // ------------------------------------------------------------ gửi
  Future<void> _send() async {
    final l = context.l10n;
    setState(() => _submitted = true);
    if (!_valid(l)) {
      showAppSnack(context, l.inboxCheckOffer, success: false);
      return;
    }
    final inbox = context.read<InboxController>();
    final me = context.read<SessionController>().userId;
    final conv = inbox.byId(widget.conversationId);
    final gig = _gig!;
    final now = DateTime.now();
    final offer = CustomOffer(
      id: 'o_${now.microsecondsSinceEpoch}',
      sellerId: me,
      buyerId: conv?.participantId ?? '',
      gigId: gig.id,
      title: gig.title,
      description: _desc.text.trim(),
      price: _milestoneMode ? _msTotal : parseMoney(_price.text)!,
      deliveryDays: _milestoneMode ? _msDays : _days!,
      revisions: _milestoneMode ? _msRevisions : _revisions,
      milestones: _milestoneMode ? List.of(_milestones) : const [],
      serviceOptions: _serviceOptions(l),
      createdAt: now,
      expiresAt: now.add(Duration(days: _expiryDays)),
      requestRequirements: _requireReq,
    );
    setState(() => _sending = true);
    try {
      await inbox.send(
        ChatMessage(
          id: '',
          conversationId: widget.conversationId,
          senderId: me,
          sentAt: now,
          type: MessageType.offer,
          offer: offer,
          relatedGigId: gig.id,
        ),
      );
      if (!mounted) return;
      showAppSnack(context, _saveTemplate ? l.inboxOfferSentTemplate(_templateName.text.trim()) : l.inboxOfferSent);
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      showAppSnack(context, l.inboxOfferSendFailed, success: false);
    }
  }

  // ------------------------------------------------------------ build
  List<Widget> _singlePaymentFields(AppLocalizations l, bool err) {
    final price = parseMoney(_price.text);
    return [
      OfferFieldRow(
        label: l.inboxTotalPrice,
        trailing: MoneyField(fieldKey: const ValueKey('offer_price'), controller: _price),
      ),
      if (price != null && _priceError(l) == null)
        Padding(
          padding: const EdgeInsets.only(bottom: Space.xs),
          child: Text(Fmt.money(price), textAlign: TextAlign.right, style: context.textTheme.bodySmall),
        ),
      if (err) OfferErrorText(_priceError(l)),
      OfferFieldRow(
        key: const ValueKey('offer_days'),
        label: l.inboxDeliveryTime,
        value: _days == null ? l.inboxPick : Fmt.days(_days!),
        onTap: _pickDays,
      ),
      if (err) OfferErrorText(_daysError(l)),
      OfferFieldRow(
        key: const ValueKey('offer_revisions'),
        label: l.inboxRevisionsOptional,
        value: l.inboxRevisionsCount(_revisions),
        onTap: _pickRevisions,
      ),
    ];
  }

  List<Widget> _milestoneFields(AppLocalizations l, bool err) {
    final full = _milestones.length >= kMaxMilestones;
    return [
      for (var i = 0; i < _milestones.length; i++)
        OfferFieldRow(
          key: ValueKey('milestone_row_$i'),
          label: _milestones[i].title,
          subtitle: l.inboxMilestoneRowSummary(
            Fmt.money(_milestones[i].price),
            _milestones[i].deliveryDays,
            _milestones[i].revisions,
          ),
          value: '',
          onTap: () => _editMilestone(i),
        ),
      TextButton.icon(
        key: const ValueKey('milestone_add'),
        onPressed: full ? null : () => _editMilestone(),
        style: TextButton.styleFrom(alignment: Alignment.centerLeft, padding: EdgeInsets.zero),
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: Text(full ? l.inboxMaxMilestones(kMaxMilestones) : l.inboxAddMilestone),
      ),
      if (_milestones.isNotEmpty)
        Text(
          l.inboxMilestoneTotal(Fmt.money(_msTotal), _msDays, _msRevisions),
          style: TextStyle(fontSize: 13, color: context.colors.onSurfaceVariant, fontWeight: FontWeight.w500),
        ),
      if (err) OfferErrorText(_milestoneError(l)),
    ];
  }

  List<Widget> _settingsFields(AppLocalizations l, bool err) => [
    OfferSectionHeader(l.inboxAddOptions),
    OfferFieldRow(
      key: const ValueKey('offer_options'),
      label: l.inboxServiceOptions,
      value: _optionCount == 0 ? l.inboxPick : l.inboxSelectedN(_optionCount),
      onTap: _pickOptions,
    ),
    const OfferGap(),
    OfferSettingsSection(
      expiryDays: _expiryDays,
      onPickExpiry: _pickExpiry,
      requireRequirements: _requireReq,
      onRequireChanged: (v) => setState(() => _requireReq = v),
      saveTemplate: _saveTemplate,
      onSaveTemplateChanged: (v) => setState(() => _saveTemplate = v),
      templateName: _templateName,
      templateError: err ? _templateError(l) : null,
    ),
  ];

  Widget _buildForm(List<Gig> gigs) {
    final l = context.l10n;
    final err = _submitted;
    final gig = _gig;
    return ListView(
      key: const ValueKey('offer_form'),
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxxl),
      children: [
        OfferSectionHeader(
          l.inboxLinkOfferToGig,
          action: l.inboxChange,
          onAction: gigs.isEmpty ? null : () => _pickGig(gigs),
        ),
        if (gig != null)
          AppCard(
            padding: const EdgeInsets.all(10),
            onTap: () => _pickGig(gigs),
            child: GigThumbRow(
              seed: gig.imageSeeds.isEmpty ? 0 : gig.imageSeeds.first,
              label: gig.imageLabel,
              title: gig.title,
            ),
          )
        else
          Text(l.inboxNoGigs),
        if (err) OfferErrorText(_gigError(l)),
        const OfferGap(),
        OfferSectionHeader(l.inboxOfferDescHeader),
        CountedTextField(
          fieldKey: const ValueKey('offer_desc'),
          controller: _desc,
          hint: l.inboxOfferDescHint,
          maxLength: 1200,
          minLines: 5,
          maxLines: 10,
        ),
        if (err) OfferErrorText(_descError(l)),
        const OfferGap(),
        OfferSectionHeader(
          _milestoneMode ? l.inboxPayMilestone : l.inboxPaySingle,
          action: l.inboxChange,
          actionKey: const ValueKey('offer_pay_type'),
          onAction: _pickPaymentType,
        ),
        if (_milestoneMode) ..._milestoneFields(l, err) else ..._singlePaymentFields(l, err),
        const OfferGap(),
        ..._settingsFields(l, err),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(title: l.inboxCreateOfferTitle, close: true),
      body: FutureBuilder<List<Gig>>(
        future: _gigsFuture,
        builder: (context, snap) {
          if (snap.hasError) {
            return EmptyState(
              icon: Icons.error_outline_rounded,
              title: l.inboxGigsLoadFailed,
              message: '${snap.error}',
              actionLabel: l.commonRetry,
              onAction: () => setState(() => _gigsFuture = _loadGigs()),
            );
          }
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildForm(snap.data ?? const <Gig>[]);
        },
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          key: const ValueKey('offer_send'),
          label: _milestoneMode ? l.inboxSendMilestoneOffer : l.inboxSendOffer,
          loading: _sending,
          onPressed: _send,
        ),
      ),
    );
  }
}
