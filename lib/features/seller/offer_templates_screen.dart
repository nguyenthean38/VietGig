import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';

/// Mẫu báo giá riêng (lưu cục bộ).
class _OfferTemplate {
  const _OfferTemplate({required this.id, required this.name, required this.price, required this.days});
  final String id;
  final String name;
  final int price;
  final int days;
}

/// "Mẫu báo giá" – quản lý mẫu báo giá riêng để dùng lại.
class OfferTemplatesScreen extends StatefulWidget {
  const OfferTemplatesScreen({super.key});

  @override
  State<OfferTemplatesScreen> createState() => _OfferTemplatesScreenState();
}

class _OfferTemplatesScreenState extends State<OfferTemplatesScreen> {
  final List<_OfferTemplate> _items = [];

  Future<void> _create() async {
    final t = await showModalBottomSheet<_OfferTemplate>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _TemplateSheet(),
    );
    if (t == null || !mounted) return;
    setState(() => _items.insert(0, t));
    showAppSnack(context, context.l10n.sellerTplSaved(t.name));
  }

  void _remove(_OfferTemplate t) {
    final i = _items.indexOf(t);
    setState(() => _items.remove(t));
    showAppSnack(
      context,
      context.l10n.sellerTplDeleted(t.name),
      onUndo: () {
        if (mounted) setState(() => _items.insert(i.clamp(0, _items.length), t));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(
        title: l.sellerTplTitle,
        actions: [
          CircleIconButton(
            key: const ValueKey('template_add'),
            icon: Icons.add_rounded,
            tooltip: l.sellerTplCreate,
            onPressed: _create,
          ),
        ],
      ),
      body: _items.isEmpty
          ? EmptyState(
              icon: Icons.request_quote_outlined,
              title: l.sellerTplEmptyTitle,
              message: l.sellerTplEmptyMessage,
              actionLabel: l.sellerTplCreate,
              onAction: _create,
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: Space.sm),
              itemCount: _items.length + 1,
              separatorBuilder: (_, _) => Divider(height: 1, color: context.colors.outlineVariant),
              itemBuilder: (context, i) {
                if (i == _items.length) {
                  return Padding(
                    padding: Insets.pageAll,
                    child: Text(l.sellerTplSwipeHint, textAlign: TextAlign.center, style: context.textTheme.bodySmall),
                  );
                }
                final t = _items[i];
                return _TemplateTile(template: t, onDismissed: () => _remove(t));
              },
            ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({required this.template, required this.onDismissed});
  final _OfferTemplate template;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final t = template;
    return Dismissible(
      key: ValueKey('tpl_${t.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        color: context.tokens.danger,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Space.xl),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
        child: Row(
          children: [
            PlaceholderImage(seed: t.name.hashCode, radius: Space.sm, width: 56, height: 56),
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Fmt.money(t.price), style: const TextStyle(fontWeight: FontWeight.w700)),
                  Gaps.v2,
                  Text(
                    t.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Gaps.v2,
                  Text(context.l10n.sellerTplSubtitle(Fmt.days(t.days)), style: context.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateSheet extends StatefulWidget {
  const _TemplateSheet();

  @override
  State<_TemplateSheet> createState() => _TemplateSheetState();
}

class _TemplateSheetState extends State<_TemplateSheet> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _days = TextEditingController(text: '7');

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _days.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Navigator.pop(
      context,
      _OfferTemplate(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: _name.text.trim(),
        price: int.parse(_price.text.trim()),
        days: int.parse(_days.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.md),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(l.sellerTplSheetTitle, style: context.textTheme.titleLarge)),
                    IconButton(
                      tooltip: l.commonClose,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Gaps.v12,
                TextFormField(
                  key: const ValueKey('tpl_name'),
                  controller: _name,
                  maxLength: 40,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: l.sellerTplName, hintText: l.sellerTplNameHint),
                  validator: (v) => (v ?? '').trim().isEmpty ? l.sellerTplNameRequired : null,
                ),
                Gaps.v8,
                TextFormField(
                  key: const ValueKey('tpl_price'),
                  controller: _price,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  decoration: InputDecoration(labelText: l.sellerTplPrice, suffixText: '₫'),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null) return l.sellerTplPriceRequired;
                    if (n < 10000) return l.sellerTplPriceMin(Fmt.money(10000));
                    return null;
                  },
                ),
                Gaps.v16,
                TextFormField(
                  key: const ValueKey('tpl_days'),
                  controller: _days,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                  decoration: InputDecoration(labelText: l.sellerTplDays, suffixText: l.sellerTplDaysSuffix),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n < 1 || n > 90) return l.sellerTplDaysInvalid;
                    return null;
                  },
                ),
                Gaps.v20,
                PrimaryButton(key: const ValueKey('tpl_save'), label: l.sellerTplSave, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
