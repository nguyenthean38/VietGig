import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum OrderStatus { awaitingRequirements, inProgress, delivered, revisionRequested, completed, cancelled, disputed }

extension OrderStatusX on OrderStatus {
  @Deprecated('Dùng status.localized(context.l10n)')
  String get label => switch (this) {
    OrderStatus.awaitingRequirements => 'CHỜ YÊU CẦU',
    OrderStatus.inProgress => 'ĐANG THỰC HIỆN',
    OrderStatus.delivered => 'ĐÃ GIAO',
    OrderStatus.revisionRequested => 'YÊU CẦU SỬA',
    OrderStatus.completed => 'HOÀN THÀNH',
    OrderStatus.cancelled => 'ĐÃ HUỶ',
    OrderStatus.disputed => 'ĐANG GIẢI QUYẾT',
  };

  @Deprecated('Dùng status.fg(context.tokens, context.colors)')
  Color get color => switch (this) {
    OrderStatus.awaitingRequirements => AppColors.warning,
    OrderStatus.inProgress => AppColors.blue,
    OrderStatus.delivered => AppColors.vettedFg,
    OrderStatus.revisionRequested => AppColors.warning,
    OrderStatus.completed => AppColors.brand,
    OrderStatus.cancelled => AppColors.muted,
    OrderStatus.disputed => AppColors.warning,
  };

  @Deprecated('Dùng status.bg(context.tokens, context.colors)')
  Color get background => switch (this) {
    OrderStatus.awaitingRequirements => AppColors.warningSoft,
    OrderStatus.inProgress => AppColors.blueSoft,
    OrderStatus.delivered => AppColors.vettedBg,
    OrderStatus.revisionRequested => AppColors.warningSoft,
    OrderStatus.completed => AppColors.brandSoft,
    OrderStatus.cancelled => AppColors.fill,
    OrderStatus.disputed => AppColors.warningSoft,
  };

  bool get isActive => this != OrderStatus.completed && this != OrderStatus.cancelled;
}

enum OrderEventType {
  created,
  requirementsSubmitted,
  started,
  deliveryDateUpdated,
  extensionRequested,
  resolutionAccepted,
  resolutionDeclined,
  delivered,
  revisionRequested,
  completed,
  cancelled,
  reviewed,
  tipped,
  extraAdded,
}

extension OrderEventTypeX on OrderEventType {
  IconData get icon => switch (this) {
    OrderEventType.created => Icons.receipt_long_outlined,
    OrderEventType.requirementsSubmitted => Icons.edit_note_outlined,
    OrderEventType.started => Icons.play_circle_outline,
    OrderEventType.deliveryDateUpdated => Icons.event_outlined,
    OrderEventType.extensionRequested => Icons.more_time_outlined,
    OrderEventType.resolutionAccepted => Icons.check_circle_outline,
    OrderEventType.resolutionDeclined => Icons.cancel_outlined,
    OrderEventType.delivered => Icons.inventory_2_outlined,
    OrderEventType.revisionRequested => Icons.replay_outlined,
    OrderEventType.completed => Icons.verified_outlined,
    OrderEventType.cancelled => Icons.block_outlined,
    OrderEventType.reviewed => Icons.star_outline_rounded,
    OrderEventType.tipped => Icons.volunteer_activism_outlined,
    OrderEventType.extraAdded => Icons.add_box_outlined,
  };
}

class OrderEvent {
  const OrderEvent({
    required this.type,
    required this.title,
    required this.at,
    this.body = '',
    this.attachments = const [],
  });
  final OrderEventType type;
  final String title;
  final String body;
  final DateTime at;
  final List<String> attachments;
}

/// Một lần giao hàng từ người bán.
class Delivery {
  const Delivery({required this.message, required this.files, required this.at});
  final String message;
  final List<String> files;
  final DateTime at;
}

class OrderReview {
  const OrderReview({
    required this.overall,
    this.quality = 0,
    this.value = 0,
    this.communication = 0,
    this.highlights = const [],
    this.text = '',
    this.sharePublicly = true,
  });
  final double overall;
  final int quality;
  final int value;
  final int communication;
  final List<String> highlights;
  final String text;
  final bool sharePublicly;
}

/// Yêu cầu gia hạn / huỷ đang chờ phản hồi.
class PendingRequest {
  const PendingRequest({
    required this.kind,
    required this.fromSeller,
    required this.message,
    this.extraDays = 0,
    required this.at,
    this.previousStatus,
  });

  /// Trạng thái đơn trước khi có yêu cầu – khôi phục lại khi bị từ chối.
  final OrderStatus? previousStatus;

  /// 'extend' | 'cancel'
  final String kind;
  final bool fromSeller;
  final String message;
  final int extraDays;
  final DateTime at;
}

class Order {
  const Order({
    required this.id,
    required this.gigId,
    required this.gigTitle,
    required this.gigImageSeed,
    required this.buyerId,
    required this.sellerId,
    required this.packageTier,
    required this.packageTitle,
    required this.packageFeatures,
    required this.subtotal,
    required this.serviceFee,
    required this.status,
    required this.createdAt,
    required this.dueDate,
    this.extras = const [],
    this.requirementAnswers = const {},
    this.events = const [],
    this.deliveries = const [],
    this.review,
    this.sellerReviewOfBuyer,
    this.tip = 0,
    this.pendingRequest,
    this.reviewDeadline,
    this.paymentMethod = 'Thẻ tín dụng/ghi nợ',
  });

  final String id;
  final String gigId;
  final String gigTitle;
  final int gigImageSeed;
  final String buyerId;
  final String sellerId;
  final String packageTier;
  final String packageTitle;
  final List<String> packageFeatures;
  final List<String> extras;
  final int subtotal;
  final int serviceFee;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime dueDate;
  final Map<String, String> requirementAnswers;
  final List<OrderEvent> events;
  final List<Delivery> deliveries;
  final OrderReview? review;
  final String? sellerReviewOfBuyer;
  final int tip;
  final PendingRequest? pendingRequest;
  final DateTime? reviewDeadline;
  final String paymentMethod;

  int get total => subtotal + serviceFee;

  /// Mã đơn hiển thị, VD: "#VG8F21A".
  String get code => '#VG${id.toUpperCase().padLeft(6, '0').substring(0, 6)}';

  Order copyWith({
    OrderStatus? status,
    DateTime? dueDate,
    Map<String, String>? requirementAnswers,
    List<OrderEvent>? events,
    List<Delivery>? deliveries,
    OrderReview? review,
    String? sellerReviewOfBuyer,
    int? tip,
    PendingRequest? pendingRequest,
    bool clearPending = false,
    DateTime? reviewDeadline,
    List<String>? extras,
    int? subtotal,
    int? serviceFee,
  }) => Order(
    id: id,
    gigId: gigId,
    gigTitle: gigTitle,
    gigImageSeed: gigImageSeed,
    buyerId: buyerId,
    sellerId: sellerId,
    packageTier: packageTier,
    packageTitle: packageTitle,
    packageFeatures: packageFeatures,
    extras: extras ?? this.extras,
    subtotal: subtotal ?? this.subtotal,
    serviceFee: serviceFee ?? this.serviceFee,
    status: status ?? this.status,
    createdAt: createdAt,
    dueDate: dueDate ?? this.dueDate,
    requirementAnswers: requirementAnswers ?? this.requirementAnswers,
    events: events ?? this.events,
    deliveries: deliveries ?? this.deliveries,
    review: review ?? this.review,
    sellerReviewOfBuyer: sellerReviewOfBuyer ?? this.sellerReviewOfBuyer,
    tip: tip ?? this.tip,
    pendingRequest: clearPending ? null : (pendingRequest ?? this.pendingRequest),
    reviewDeadline: reviewDeadline ?? this.reviewDeadline,
    paymentMethod: paymentMethod,
  );
}

/// Bản nháp đơn hàng trong quá trình thanh toán.
class CheckoutDraft {
  const CheckoutDraft({
    required this.gigId,
    required this.packageIndex,
    this.extraIds = const {},
    this.extraQuantities = const {},
  });
  final String gigId;
  final int packageIndex;
  final Set<String> extraIds;
  final Map<String, int> extraQuantities;

  CheckoutDraft copyWith({int? packageIndex, Set<String>? extraIds, Map<String, int>? extraQuantities}) =>
      CheckoutDraft(
        gigId: gigId,
        packageIndex: packageIndex ?? this.packageIndex,
        extraIds: extraIds ?? this.extraIds,
        extraQuantities: extraQuantities ?? this.extraQuantities,
      );
}
