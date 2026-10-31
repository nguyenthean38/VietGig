import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/account.dart';
import '../../data/repositories/repositories.dart';
import '../../state/session_controller.dart';
import 'widgets/availability_form.dart';

/// Lịch làm việc / ngày bận của người bán.
class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  late Future<Availability?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Availability?> _load() =>
      context.read<AccountRepository>().availability(context.read<SessionController>().userId);

  Future<void> _openForm(Availability? current) async {
    final result = await showModalBottomSheet<AvailabilityFormResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AvailabilityForm(initial: current),
    );
    if (result == null || !mounted) return;
    setState(() {
      _future = _load();
    });
    final l = context.l10n;
    showAppSnack(context, switch (result) {
      AvailabilityFormResult.saved => current == null ? l.sellerAvailConfirmed : l.sellerAvailChangesSaved,
      AvailabilityFormResult.deleted => l.sellerAvailDeleted,
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: SimpleAppBar(title: context.l10n.sellerAvailTitle),
    body: AsyncView<Availability?>(future: _future, builder: _body),
  );

  Widget _body(BuildContext context, Availability? a) {
    final l = context.l10n;
    final cs = context.colors;
    const underline = TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline);
    final desc = Text(l.sellerAvailDesc, style: context.textTheme.bodySmall?.copyWith(height: 1.45));
    return ListView(
      padding: Insets.pageAll,
      children: [
        if (a == null) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              key: const ValueKey('avail_set'),
              onTap: () => _openForm(null),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(l.sellerAvailSet, style: underline.copyWith(fontSize: 15)),
              ),
            ),
          ),
          Gaps.v8,
          desc,
        ] else ...[
          Row(
            children: [
              Expanded(
                child: Text(l.sellerAvailUpcoming, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
              ),
              InkWell(
                key: const ValueKey('avail_edit'),
                onTap: () => _openForm(a),
                child: Padding(
                  padding: const EdgeInsets.all(Space.xs),
                  child: Text(l.sellerAvailEdit, style: underline),
                ),
              ),
            ],
          ),
          Gaps.v4,
          Text(
            '${Fmt.date(a.firstDay)} – ${Fmt.date(a.lastDay)}',
            key: const ValueKey('avail_range'),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          Gaps.v4,
          Text(
            a.allowContact
                ? l.sellerAvailReasonLineContact(availabilityReasonLabel(l, a.reason))
                : l.sellerAvailReasonLine(availabilityReasonLabel(l, a.reason)),
            style: context.textTheme.bodySmall,
          ),
          if (a.note.isNotEmpty) ...[Gaps.v8, Text('“${a.note}”', style: const TextStyle(fontStyle: FontStyle.italic))],
          Gaps.v10,
          desc,
        ],
      ],
    );
  }
}
