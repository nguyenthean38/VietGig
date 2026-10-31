import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/order_widgets.dart';

/// Nhãn dưới 5 sao.
List<String> rateStarLabels(AppLocalizations l) => [
  l.ordersRateStar1,
  l.ordersRateStar2,
  l.ordersRateStar3,
  l.ordersRateStar4,
  l.ordersRateStar5,
];

/// Chip điểm mạnh (khi đánh giá ≥ 4 sao).
List<String> ratePositiveChips(AppLocalizations l) => [
  l.ordersRatePositiveDetail,
  l.ordersRatePositiveCreative,
  l.ordersRatePositiveAesthetic,
  l.ordersRatePositiveProfessional,
  l.ordersRatePositiveExceeded,
  l.ordersRatePositiveOnBrand,
];

/// Chip điểm yếu (khi đánh giá < 4 sao).
List<String> rateNegativeChips(AppLocalizations l) => [
  l.ordersRateNegativeLate,
  l.ordersRateNegativeDetail,
  l.ordersRateNegativeOffBrief,
  l.ordersRateNegativeCommunication,
  l.ordersRateNegativeQuality,
  l.ordersRateNegativeRevisions,
];

/// Ảnh đại diện người bán ở giữa.
class RateAvatar extends StatelessWidget {
  const RateAvatar(this.bundle, {super.key});
  final OrderBundle bundle;
  @override
  Widget build(BuildContext context) => Center(
    child: UserAvatar(user: bundle.other, name: otherName(context.l10n, bundle), size: 88),
  );
}

/// Tiêu đề lớn căn giữa của mỗi bước.
class RateTitle extends StatelessWidget {
  const RateTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Space.lg),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, height: 1.3),
    ),
  );
}

/// Khung một bước: nội dung cuộn + thanh hành động đáy.
class RatePage extends StatelessWidget {
  const RatePage({super.key, required this.items, this.bottom});
  final List<Widget> items;
  final Widget? bottom;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: ListView(padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.xxl), children: items),
      ),
      if (bottom != null) BottomActionBar(child: bottom!),
    ],
  );
}
