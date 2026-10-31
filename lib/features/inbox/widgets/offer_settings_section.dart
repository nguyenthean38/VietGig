import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/format.dart';
import 'offer_form_widgets.dart';

/// Phần "Thiết lập báo giá" + "Lưu làm mẫu" của form tạo báo giá.
class OfferSettingsSection extends StatelessWidget {
  const OfferSettingsSection({
    super.key,
    required this.expiryDays,
    required this.onPickExpiry,
    required this.requireRequirements,
    required this.onRequireChanged,
    required this.saveTemplate,
    required this.onSaveTemplateChanged,
    required this.templateName,
    this.templateError,
  });

  final int expiryDays;
  final VoidCallback onPickExpiry;
  final bool requireRequirements;
  final ValueChanged<bool> onRequireChanged;
  final bool saveTemplate;
  final ValueChanged<bool> onSaveTemplateChanged;
  final TextEditingController templateName;

  /// Lỗi tên mẫu (chỉ truyền khi đã bấm gửi).
  final String? templateError;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.tokens.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OfferSectionHeader(l.inboxOfferSettings),
        OfferFieldRow(
          key: const ValueKey('offer_expiry'),
          label: l.inboxOfferExpiry,
          value: Fmt.days(expiryDays),
          onTap: onPickExpiry,
        ),
        OfferFieldRow(
          label: l.inboxRequireInfo,
          subtitle: l.inboxRequireInfoDesc,
          trailing: Switch(
            key: const ValueKey('offer_require'),
            value: requireRequirements,
            activeTrackColor: brand,
            onChanged: onRequireChanged,
          ),
        ),
        const OfferGap(),
        OfferSectionHeader(l.inboxSaveTemplate),
        OfferFieldRow(
          label: l.inboxReuseTemplate,
          trailing: Switch(
            key: const ValueKey('offer_template'),
            value: saveTemplate,
            activeTrackColor: brand,
            onChanged: onSaveTemplateChanged,
          ),
        ),
        if (saveTemplate) ...[
          Gaps.v8,
          TextField(
            key: const ValueKey('offer_template_name'),
            controller: templateName,
            maxLength: 40,
            decoration: InputDecoration(hintText: l.inboxTemplateNameHint),
          ),
          OfferErrorText(templateError),
        ],
      ],
    );
  }
}
