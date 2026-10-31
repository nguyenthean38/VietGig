import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/order.dart';

/// Phương thức thanh toán ở màn "Xem lại đơn hàng".
enum PaymentMethod {
  card(Icons.credit_card_rounded),
  momo(Icons.account_balance_wallet_rounded),
  zaloPay(Icons.qr_code_2_rounded),
  bank(Icons.account_balance_rounded);

  const PaymentMethod(this.icon);
  final IconData icon;

  /// Giá trị lưu vào `Order.paymentMethod` (dữ liệu, không phụ thuộc ngôn ngữ).
  String get storedValue => switch (this) {
    PaymentMethod.card => 'Thẻ tín dụng/ghi nợ',
    PaymentMethod.momo => 'MoMo',
    PaymentMethod.zaloPay => 'ZaloPay',
    PaymentMethod.bank => 'Chuyển khoản ngân hàng',
  };

  /// Tìm phương thức theo giá trị đã lưu (null nếu là giá trị lạ, VD dữ liệu cũ).
  static PaymentMethod? fromStored(String value) {
    for (final m in values) {
      if (m.storedValue == value) return m;
    }
    return null;
  }

  /// Nhãn hiển thị đã dịch.
  String localized(AppLocalizations l) => switch (this) {
    PaymentMethod.card => l.ordersReviewMethodCard,
    PaymentMethod.momo => 'MoMo',
    PaymentMethod.zaloPay => 'ZaloPay',
    PaymentMethod.bank => l.ordersReviewMethodBank,
  };
}

/// Ô màu nhỏ có biểu tượng phương thức thanh toán.
class PaymentMethodBadge extends StatelessWidget {
  const PaymentMethodBadge(this.method, {super.key});
  final PaymentMethod method;

  // Màu nhận diện thương hiệu ví điện tử (bên thứ ba).
  static const _momo = Color(0xFFA50064);
  static const _zaloPay = Color(0xFF0068FF);

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final bg = switch (method) {
      PaymentMethod.card => cs.onSurface,
      PaymentMethod.momo => _momo,
      PaymentMethod.zaloPay => _zaloPay,
      PaymentMethod.bank => context.tokens.brandStrong,
    };
    return Container(
      width: 36,
      height: 26,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
      child: Icon(method.icon, size: 16, color: method == PaymentMethod.card ? cs.surface : Colors.white),
    );
  }
}

/// Hộp thoại "Đơn hàng đã được tạo".
Future<void> showOrderPlacedDialog(BuildContext context, Order order) {
  final needReq = order.status == OrderStatus.awaitingRequirements;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      final l = ctx.l10n;
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(Space.xxl, 28, Space.xxl, Space.sm),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Illustration(icon: Icons.celebration_rounded, size: 110),
            Gaps.v16,
            Text(l.ordersReviewSuccessTitle, textAlign: TextAlign.center, style: ctx.textTheme.titleMedium),
            Gaps.v8,
            Text(
              needReq ? l.ordersReviewSuccessNeedRequirements : l.ordersReviewSuccessStarted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const ValueKey('success_ok'),
              onPressed: () => Navigator.pop(ctx),
              child: Text(needReq ? l.ordersReqSubmit : l.ordersReviewViewOrder),
            ),
          ),
        ],
      );
    },
  );
}

/// Màn hình chờ khi đang xử lý thanh toán.
class OrderProcessingView extends StatelessWidget {
  const OrderProcessingView({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Space.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Illustration(icon: Icons.credit_score_rounded, size: 120),
              Gaps.v24,
              const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.6)),
              Gaps.v20,
              Text(
                l.ordersReviewProcessing,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Gaps.v8,
              Text(l.ordersReviewDontClose, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
