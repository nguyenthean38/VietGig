import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../data/models/chat.dart';
import '../../../state/app_controllers.dart';

enum InboxFilterKind { all, unread, starred, archived, spam, offers, label }

/// Bộ lọc danh sách hội thoại.
class InboxFilter {
  const InboxFilter(this.kind, [this.label]);
  static const all = InboxFilter(InboxFilterKind.all);

  final InboxFilterKind kind;
  final String? label;

  String title(AppLocalizations l) => switch (kind) {
    InboxFilterKind.all => l.inboxFilterInbox,
    InboxFilterKind.unread => l.inboxFilterUnread,
    InboxFilterKind.starred => l.inboxFilterStarred,
    InboxFilterKind.archived => l.inboxFilterArchived,
    InboxFilterKind.spam => l.inboxFilterSpam,
    InboxFilterKind.offers => l.inboxFilterOffers,
    InboxFilterKind.label => label ?? '',
  };

  String sheetLabel(AppLocalizations l) => kind == InboxFilterKind.all ? l.inboxFilterAll : title(l);

  IconData get icon => switch (kind) {
    InboxFilterKind.all => Icons.all_inbox_outlined,
    InboxFilterKind.unread => Icons.mark_email_unread_outlined,
    InboxFilterKind.starred => Icons.star_border_rounded,
    InboxFilterKind.archived => Icons.inventory_2_outlined,
    InboxFilterKind.spam => Icons.report_gmailerrorred_outlined,
    InboxFilterKind.offers => Icons.request_quote_outlined,
    InboxFilterKind.label => Icons.sell_outlined,
  };

  bool matches(Conversation c) {
    final hidden = c.isSpam || c.blocked;
    return switch (kind) {
      InboxFilterKind.all => !c.archived && !hidden,
      InboxFilterKind.unread => c.unread > 0 && !c.archived && !hidden,
      InboxFilterKind.starred => c.starred && !hidden,
      InboxFilterKind.archived => c.archived && !hidden,
      InboxFilterKind.spam => hidden,
      InboxFilterKind.offers => c.hasCustomOffer && !hidden,
      InboxFilterKind.label => c.labels.contains(label) && !hidden,
    };
  }

  @override
  bool operator ==(Object other) => other is InboxFilter && other.kind == kind && other.label == label;

  @override
  int get hashCode => Object.hash(kind, label);
}

/// Bottom sheet "Bộ lọc".
Future<InboxFilter?> showInboxFilterSheet(BuildContext context, {required InboxFilter current}) {
  final labels = context.read<InboxController>().labels;
  const basics = [
    InboxFilter.all,
    InboxFilter(InboxFilterKind.unread),
    InboxFilter(InboxFilterKind.starred),
    InboxFilter(InboxFilterKind.archived),
    InboxFilter(InboxFilterKind.spam),
    InboxFilter(InboxFilterKind.offers),
  ];
  return showModalBottomSheet<InboxFilter>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      final l = ctx.l10n;
      Widget tile(InboxFilter f, String text) {
        final selected = f == current;
        return ListTile(
          key: ValueKey('filter_$text'),
          dense: true,
          leading: Icon(f.icon, size: 22),
          title: Text(text, style: TextStyle(fontSize: 15, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
          trailing: selected ? Icon(Icons.check_rounded, color: ctx.tokens.brand) : null,
          onTap: () => Navigator.pop(ctx, f),
        );
      }

      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.85),
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: Space.md),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.sm),
                child: Text(l.inboxFilterTitle, style: ctx.textTheme.titleLarge),
              ),
              for (final f in basics) tile(f, f.sheetLabel(l)),
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.xs),
                child: Text(l.inboxLabelsHeader, style: ctx.textTheme.titleMedium),
              ),
              for (final lb in labels) tile(InboxFilter(InboxFilterKind.label, lb), lb),
            ],
          ),
        ),
      );
    },
  );
}
