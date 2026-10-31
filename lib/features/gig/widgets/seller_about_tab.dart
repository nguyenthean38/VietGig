import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../data/models/user.dart';
import 'discovery_widgets.dart';

/// Tab "Giới thiệu" của hồ sơ người bán (trả về một sliver).
class SellerAboutTab extends StatefulWidget {
  const SellerAboutTab({super.key, required this.user});
  final AppUser user;

  @override
  State<SellerAboutTab> createState() => _SellerAboutTabState();
}

class _SellerAboutTabState extends State<SellerAboutTab> {
  bool _bioExpanded = false;
  bool _skillsExpanded = false;

  Widget _more(String text) => Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
  );

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    final cs = context.colors;
    final t = context.tokens;
    final l = context.l10n;
    Widget title(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.xl, Space.lg, Space.sm),
      child: Text(text, style: context.textTheme.titleMedium),
    );
    Widget info(IconData icon, String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: cs.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(k, style: context.textTheme.bodySmall),
                Text(v, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
    final skills = _skillsExpanded ? u.skills : u.skills.take(4).toList();
    final place = u.city.isEmpty ? u.country : '${u.city}, ${u.country}';
    final since = u.memberSince;
    return SliverList.list(
      children: [
        if (u.isVettedPro) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
            child: Row(
              children: [
                Icon(Icons.verified_rounded, color: t.vettedFg, size: 22),
                Gaps.h8,
                Expanded(child: Text(l.gigVettedTitle, style: context.textTheme.titleMedium)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.xs, Space.lg, 0),
            child: Text(l.gigVettedMessage(u.displayName), style: context.textTheme.bodySmall),
          ),
        ],
        if (u.vettedFor.isNotEmpty) ...[
          title(l.gigVettedFor),
          Padding(
            padding: Insets.page,
            child: Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                for (final v in u.vettedFor)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded, size: 18, color: t.brand),
                      Gaps.h4,
                      Text(v),
                    ],
                  ),
              ],
            ),
          ),
        ],
        if (u.offersHourly)
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
            child: Row(
              children: [
                Icon(Icons.schedule_rounded, size: 20, color: cs.onSurfaceVariant),
                Gaps.h8,
                Expanded(
                  child: Text(l.gigOffersHourly, style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        title(l.gigInfo),
        if (u.bio.isNotEmpty)
          Padding(
            padding: Insets.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  u.bio,
                  maxLines: _bioExpanded ? null : 3,
                  overflow: _bioExpanded ? null : TextOverflow.ellipsis,
                  style: const TextStyle(height: 1.5),
                ),
                InkWell(
                  key: const ValueKey('bio_more'),
                  onTap: () => setState(() => _bioExpanded = !_bioExpanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _more(_bioExpanded ? l.gigShowLess : l.gigShowMore),
                  ),
                ),
              ],
            ),
          ),
        info(Icons.location_on_outlined, l.gigFrom, l.gigFromWithLocalTime(place, vietnamLocalTime())),
        info(
          Icons.person_outline_rounded,
          l.gigMemberSince,
          since == null ? '—' : l.gigMemberSinceLong('${since.month}', '${since.year}'),
        ),
        info(Icons.timer_outlined, l.gigAvgResponseLong, l.gigHours(u.responseHours)),
        info(Icons.translate_rounded, l.gigLanguages, u.languages.join(', ')),
        if (u.skills.isNotEmpty) ...[
          title(l.gigSkills),
          Padding(
            padding: Insets.page,
            child: Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [for (final s in skills) Chip(label: Text(s), visualDensity: VisualDensity.compact)],
            ),
          ),
          if (u.skills.length > 4)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                key: const ValueKey('skills_more'),
                onPressed: () => setState(() => _skillsExpanded = !_skillsExpanded),
                child: Text(
                  _skillsExpanded ? l.gigShowLess : l.gigShowMoreSkills(u.skills.length - 4),
                  style: const TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
        ],
        if (u.isVettedPro || u.level == SellerLevel.topRated) ...[
          title(l.gigCertEducation),
          // Nội dung chứng chỉ/học vấn là dữ liệu mẫu.
          info(Icons.workspace_premium_outlined, l.gigCertificates, 'VietGig Learn – Freelance chuyên nghiệp'),
          info(Icons.school_outlined, l.gigEducation, 'Cử nhân Thiết kế – ĐH Kiến trúc'),
        ],
      ],
    );
  }
}
