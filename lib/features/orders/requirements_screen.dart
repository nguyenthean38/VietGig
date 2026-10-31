import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/order.dart';
import '../../state/app_controllers.dart';
import 'widgets/order_widgets.dart';

/// Câu hỏi mặc định khi dịch vụ không khai báo yêu cầu riêng.
List<RequirementQuestion> _fallback(AppLocalizations l) => [RequirementQuestion(question: l.ordersReqFallbackQuestion)];

/// Modal "Yêu cầu" – người mua trả lời câu hỏi của người bán.
class RequirementsScreen extends StatefulWidget {
  const RequirementsScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<RequirementsScreen> createState() => _RequirementsScreenState();
}

class _RequirementsScreenState extends State<RequirementsScreen> {
  late final Future<OrderBundle?> _future;
  final Map<int, TextEditingController> _text = {};
  final Map<int, String> _choice = {};
  final Map<int, List<FakeFile>> _files = {};
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _future = fetchOrderBundle(context, widget.orderId);
  }

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _ctrl(int i) => _text.putIfAbsent(i, TextEditingController.new);

  bool _answered(int i, RequirementQuestion q) => switch (q.type) {
    RequirementType.text => _ctrl(i).text.trim().isNotEmpty,
    RequirementType.choice => _choice[i] != null,
    RequirementType.file => (_files[i] ?? const []).isNotEmpty,
  };

  bool _complete(List<RequirementQuestion> qs) {
    for (var i = 0; i < qs.length; i++) {
      if (qs[i].required && !_answered(i, qs[i])) return false;
    }
    return true;
  }

  Future<void> _attach(int i) async {
    final src = await showAttachSheet(context);
    if (src == null || !mounted) return;
    setState(() {
      final l = _files.putIfAbsent(i, () => []);
      l.add(makeFakeFile(src, l.length));
    });
  }

  Future<void> _submit(Order o, List<RequirementQuestion> qs) async {
    final answers = <String, String>{};
    for (var i = 0; i < qs.length; i++) {
      final q = qs[i];
      final v = switch (q.type) {
        RequirementType.text => _ctrl(i).text.trim(),
        RequirementType.choice => _choice[i] ?? '',
        RequirementType.file => (_files[i] ?? const []).map((f) => f.name).join(', '),
      };
      if (v.isNotEmpty) answers[q.question] = v;
    }
    setState(() => _sending = true);
    try {
      await context.read<OrdersController>().submitRequirements(o.id, answers);
    } catch (e) {
      if (mounted) {
        setState(() => _sending = false);
        showAppSnack(context, context.l10n.ordersReqSendFailed('$e'), success: false);
      }
      return;
    }
    if (!mounted) return;
    showAppSnack(context, context.l10n.ordersReqSent);
    context.pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: SimpleAppBar(title: context.l10n.ordersReqTitle, close: true),
    body: OrderBundleView(
      orderId: widget.orderId,
      future: _future,
      builder: (context, b) {
        final o = b.order;
        if (o.status != OrderStatus.awaitingRequirements && !_sending) {
          return EmptyState(
            icon: Icons.task_alt_rounded,
            title: context.l10n.ordersReqAlreadyTitle,
            message: context.l10n.ordersReqAlreadyMessage,
            actionLabel: context.l10n.ordersReqBackToOrder,
            onAction: () => context.canPop() ? context.pop() : context.go('/orders/${o.id}'),
          );
        }
        final qs = (b.gig?.requirements.isNotEmpty ?? false) ? b.gig!.requirements : _fallback(context.l10n);
        return _form(o, qs);
      },
    ),
  );

  Widget _form(Order o, List<RequirementQuestion> qs) {
    final cs = context.colors;
    final l = context.l10n;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
            children: [
              OrderHeaderCard(order: o),
              Gaps.v8,
              for (var i = 0; i < qs.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 10),
                  child: Text.rich(
                    TextSpan(
                      text: '${i + 1}. ${qs[i].question}',
                      children: [
                        if (qs[i].required)
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: context.tokens.danger),
                          )
                        else
                          TextSpan(
                            text: '  ${l.ordersReqOptional}',
                            style: TextStyle(fontWeight: FontWeight.w400, color: cs.onSurfaceVariant, fontSize: 13),
                          ),
                      ],
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, height: 1.35),
                  ),
                ),
                _input(i, qs[i]),
              ],
            ],
          ),
        ),
        BottomActionBar(
          note: Text(l.ordersReqConfirm, textAlign: TextAlign.center, style: context.textTheme.bodySmall),
          child: PrimaryButton(
            key: const ValueKey('submit_requirements'),
            label: l.ordersReqSubmit,
            loading: _sending,
            onPressed: _complete(qs) ? () => _submit(o, qs) : null,
          ),
        ),
      ],
    );
  }

  Widget _input(int i, RequirementQuestion q) {
    switch (q.type) {
      case RequirementType.text:
        return CountedTextField(
          fieldKey: ValueKey('req_text_$i'),
          controller: _ctrl(i),
          hint: context.l10n.ordersReqHint,
          minLines: 4,
          onChanged: (_) => setState(() {}),
        );
      case RequirementType.choice:
        return Column(
          children: [
            for (var j = 0; j < q.options.length; j++)
              RadioRow(
                key: ValueKey('req_choice_${i}_$j'),
                label: q.options[j],
                selected: _choice[i] == q.options[j],
                onTap: () => setState(() => _choice[i] = q.options[j]),
              ),
          ],
        );
      case RequirementType.file:
        final files = _files[i] ?? const <FakeFile>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var k = 0; k < files.length; k++)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: FileTile(
                  name: files[k].name,
                  size: files[k].size,
                  onRemove: () => setState(() => _files[i]!.removeAt(k)),
                ),
              ),
            OutlinedButton.icon(
              key: ValueKey('req_attach_$i'),
              onPressed: () => _attach(i),
              icon: const Icon(Icons.attach_file_rounded, size: 18),
              label: Text(files.isEmpty ? context.l10n.ordersAttachTitle : context.l10n.ordersReqAttachMore),
            ),
          ],
        );
    }
  }
}
