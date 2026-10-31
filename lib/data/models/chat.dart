/// Nhãn hội thoại có sẵn.
const kDefaultChatLabels = <String>[
  'Đơn đã hoàn thành',
  'Đơn đang thực hiện',
  'Đang trao đổi',
  'Đã nộp bản cuối',
  'Yêu cầu mới',
  'Chỉnh sửa',
  'Cần theo dõi',
  'Đơn đã huỷ',
  'Sắp đến hạn',
];

class Conversation {
  const Conversation({
    required this.id,
    required this.participantId,
    required this.lastMessage,
    required this.updatedAt,
    this.unread = 0,
    this.labels = const {},
    this.starred = false,
    this.archived = false,
    this.blocked = false,
    this.isSpam = false,
    this.hasCustomOffer = false,
  });

  final String id;
  final String participantId;
  final String lastMessage;
  final DateTime updatedAt;
  final int unread;
  final Set<String> labels;
  final bool starred;
  final bool archived;
  final bool blocked;
  final bool isSpam;
  final bool hasCustomOffer;

  Conversation copyWith({
    String? lastMessage,
    DateTime? updatedAt,
    int? unread,
    Set<String>? labels,
    bool? starred,
    bool? archived,
    bool? blocked,
    bool? isSpam,
    bool? hasCustomOffer,
  }) => Conversation(
    id: id,
    participantId: participantId,
    lastMessage: lastMessage ?? this.lastMessage,
    updatedAt: updatedAt ?? this.updatedAt,
    unread: unread ?? this.unread,
    labels: labels ?? this.labels,
    starred: starred ?? this.starred,
    archived: archived ?? this.archived,
    blocked: blocked ?? this.blocked,
    isSpam: isSpam ?? this.isSpam,
    hasCustomOffer: hasCustomOffer ?? this.hasCustomOffer,
  );
}

enum MessageType { text, file, offer, videoCall, system }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.sentAt,
    this.text = '',
    this.type = MessageType.text,
    this.fileName,
    this.fileSize,
    this.offer,
    this.replyTo,
    this.relatedGigId,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final DateTime sentAt;
  final String text;
  final MessageType type;
  final String? fileName;
  final String? fileSize;
  final CustomOffer? offer;

  /// Nội dung tin nhắn được trả lời (nếu có).
  final String? replyTo;

  /// Tin nhắn liên quan tới dịch vụ nào.
  final String? relatedGigId;
}

enum OfferStatus { pending, accepted, declined, withdrawn, expired }

extension OfferStatusX on OfferStatus {
  @Deprecated('Dùng status.localized(context.l10n)')
  String get label => switch (this) {
    OfferStatus.pending => 'Đang chờ',
    OfferStatus.accepted => 'Đã chấp nhận',
    OfferStatus.declined => 'Đã từ chối',
    OfferStatus.withdrawn => 'Đã rút lại',
    OfferStatus.expired => 'Hết hạn',
  };
}

class Milestone {
  const Milestone({
    required this.title,
    required this.description,
    required this.price,
    required this.deliveryDays,
    this.revisions = 1,
  });
  final String title;
  final String description;
  final int price;
  final int deliveryDays;
  final int revisions;
}

/// Báo giá riêng người bán gửi cho người mua.
class CustomOffer {
  const CustomOffer({
    required this.id,
    required this.sellerId,
    required this.buyerId,
    required this.gigId,
    required this.title,
    required this.description,
    required this.price,
    required this.deliveryDays,
    required this.createdAt,
    this.revisions = 1,
    this.milestones = const [],
    this.serviceOptions = const [],
    this.expiresAt,
    this.requestRequirements = true,
    this.status = OfferStatus.pending,
  });

  final String id;
  final String sellerId;
  final String buyerId;
  final String gigId;
  final String title;
  final String description;
  final int price;
  final int deliveryDays;
  final int revisions;
  final List<Milestone> milestones;
  final List<String> serviceOptions;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool requestRequirements;
  final OfferStatus status;

  bool get isMilestone => milestones.isNotEmpty;

  int get totalPrice => isMilestone ? milestones.fold(0, (s, m) => s + m.price) : price;

  int get totalDays => isMilestone ? milestones.fold(0, (s, m) => s + m.deliveryDays) : deliveryDays;

  CustomOffer copyWith({OfferStatus? status}) => CustomOffer(
    id: id,
    sellerId: sellerId,
    buyerId: buyerId,
    gigId: gigId,
    title: title,
    description: description,
    price: price,
    deliveryDays: deliveryDays,
    createdAt: createdAt,
    revisions: revisions,
    milestones: milestones,
    serviceOptions: serviceOptions,
    expiresAt: expiresAt,
    requestRequirements: requestRequirements,
    status: status ?? this.status,
  );
}

/// Mẫu trả lời nhanh.
class QuickResponse {
  const QuickResponse({required this.id, required this.title, required this.body});
  final String id;
  final String title;
  final String body;
}
