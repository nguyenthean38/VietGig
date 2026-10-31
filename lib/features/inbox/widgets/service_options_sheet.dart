import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';

/// Tuỳ chọn dịch vụ cộng thêm trong báo giá.
enum OfferAddon { customAssets, responsive, wireframe, prototype, sourceFiles }

extension OfferAddonL10n on OfferAddon {
  String localized(AppLocalizations l) => switch (this) {
    OfferAddon.customAssets => l.inboxOptCustomAssets,
    OfferAddon.responsive => l.inboxOptResponsive,
    OfferAddon.wireframe => l.inboxOptWireframe,
    OfferAddon.prototype => l.inboxOptPrototype,
    OfferAddon.sourceFiles => l.inboxOptSourceFiles,
  };
}

typedef ServiceOptionsResult = ({int pages, Set<OfferAddon> options});

/// Mở sheet "Tuỳ chọn dịch vụ".
Future<ServiceOptionsResult?> showServiceOptionsSheet(
  BuildContext context, {
  required int pages,
  required Set<OfferAddon> options,
}) => showModalBottomSheet<ServiceOptionsResult>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _ServiceOptionsSheet(pages: pages, options: options),
);

class _ServiceOptionsSheet extends StatefulWidget {
  const _ServiceOptionsSheet({required this.pages, required this.options});
  final int pages;
  final Set<OfferAddon> options;
  @override
  State<_ServiceOptionsSheet> createState() => _ServiceOptionsSheetState();
}

class _ServiceOptionsSheetState extends State<_ServiceOptionsSheet> {
  late int _pages = widget.pages;
  late final Set<OfferAddon> _sel = {...widget.options};

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final l = context.l10n;
    Widget check(bool v) =>
        Icon(v ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: v ? cs.onSurface : cs.outline);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.sm, Space.sm),
            child: Row(
              children: [
                Expanded(child: Text(l.inboxServiceOptions, style: context.textTheme.titleLarge)),
                TextButton(
                  key: const ValueKey('options_apply'),
                  onPressed: () => Navigator.pop(context, (pages: _pages, options: _sel)),
                  child: Text(l.inboxApply, style: const TextStyle(decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs),
            child: Row(
              children: [
                InkWell(onTap: () => setState(() => _pages = _pages > 0 ? 0 : 1), child: check(_pages > 0)),
                Gaps.h12,
                Expanded(child: Text(l.inboxPagesLabel, style: const TextStyle(fontSize: 15))),
                IconButton(
                  key: const ValueKey('pages_minus'),
                  onPressed: _pages > 0 ? () => setState(() => _pages--) : null,
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                ),
                SizedBox(
                  width: 28,
                  child: Text(
                    '$_pages',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  key: const ValueKey('pages_plus'),
                  onPressed: _pages < 50 ? () => setState(() => _pages++) : null,
                  icon: const Icon(Icons.add_circle_outline_rounded),
                ),
              ],
            ),
          ),
          for (final a in OfferAddon.values)
            InkWell(
              key: ValueKey('opt_${a.name}'),
              onTap: () => setState(() => _sel.contains(a) ? _sel.remove(a) : _sel.add(a)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
                child: Row(
                  children: [
                    check(_sel.contains(a)),
                    Gaps.h12,
                    Expanded(child: Text(a.localized(l), style: const TextStyle(fontSize: 15))),
                  ],
                ),
              ),
            ),
          Gaps.v12,
        ],
      ),
    );
  }
}
