/// Danh sách lưu (yêu thích) của người dùng.
class SavedList {
  const SavedList({
    required this.id,
    required this.name,
    this.gigIds = const [],
    this.sellerIds = const [],
    this.isPublic = false,
  });
  final String id;
  final String name;
  final List<String> gigIds;
  final List<String> sellerIds;
  final bool isPublic;

  bool get isEmpty => gigIds.isEmpty && sellerIds.isEmpty;

  SavedList copyWith({String? name, List<String>? gigIds, List<String>? sellerIds, bool? isPublic}) => SavedList(
    id: id,
    name: name ?? this.name,
    gigIds: gigIds ?? this.gigIds,
    sellerIds: sellerIds ?? this.sellerIds,
    isPublic: isPublic ?? this.isPublic,
  );
}

enum NotificationKind { order, message, account, promo, system }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.kind = NotificationKind.system,
    this.read = false,
    this.link,
    this.actorSeed,
  });
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final NotificationKind kind;
  final bool read;

  /// Đường dẫn trong app để mở khi bấm vào (go_router location).
  final String? link;
  final int? actorSeed;

  AppNotification copyWith({bool? read}) => AppNotification(
    id: id,
    title: title,
    body: body,
    createdAt: createdAt,
    kind: kind,
    read: read ?? this.read,
    link: link,
    actorSeed: actorSeed,
  );
}

/// Thống kê dành cho người bán.
class SellerStats {
  const SellerStats({
    this.availableForWithdrawal = 0,
    this.earningsThisMonth = 0,
    this.avgSellingPrice = 0,
    this.activeOrders = 0,
    this.activeOrdersValue = 0,
    this.completedOrders = 0,
    this.completedOrdersValue = 0,
    this.cancelledOrders = 0,
    this.paymentsClearing = 0,
    this.earningsToDate = 0,
    this.expensesToDate = 0,
    this.withdrawnToDate = 0,
    this.responseRate = 0,
    this.successScore,
    this.rating = 0,
    this.ordersCount = 0,
    this.uniqueClients = 0,
    this.totalEarnings = 0,
    this.impressions = 0,
    this.clicks = 0,
    this.dailyEarnings = const [],
    this.unreadMessages = 0,
  });

  final int availableForWithdrawal;
  final int earningsThisMonth;
  final int avgSellingPrice;
  final int activeOrders;
  final int activeOrdersValue;
  final int completedOrders;
  final int completedOrdersValue;
  final int cancelledOrders;
  final int paymentsClearing;
  final int earningsToDate;
  final int expensesToDate;
  final int withdrawnToDate;

  /// 0..100
  final int responseRate;

  /// 1..10, null = chưa có
  final int? successScore;
  final double rating;
  final int ordersCount;
  final int uniqueClients;
  final int totalEarnings;
  final int impressions;
  final int clicks;

  /// Thu nhập theo ngày (30 ngày gần nhất), phần tử cuối = hôm nay.
  final List<int> dailyEarnings;
  final int unreadMessages;

  double get conversion => clicks == 0 || impressions == 0 ? 0 : clicks / impressions * 100;
}

/// Yêu cầu tối thiểu cho mỗi cấp độ người bán.
class LevelRequirement {
  const LevelRequirement({
    required this.level,
    required this.successScore,
    required this.rating,
    required this.responseRate,
    required this.orders,
    required this.uniqueClients,
    required this.earnings,
  });
  final String level;
  final int successScore;
  final double rating;
  final int responseRate;
  final int orders;
  final int uniqueClients;
  final int earnings;
}

/// Lịch nghỉ / không nhận việc của người bán.
class Availability {
  const Availability({
    required this.firstDay,
    required this.lastDay,
    this.reason = 'Khác',
    this.note = '',
    this.allowContact = false,
  });
  final DateTime firstDay;
  final DateTime lastDay;
  final String reason;
  final String note;
  final bool allowContact;
}

/// Brief – yêu cầu dự án người mua đăng lên.
class Brief {
  const Brief({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.deliveryDays,
    required this.createdAt,
    this.buyerName = '',
    this.categoryId = '',
  });
  final String id;
  final String title;
  final String description;
  final int budget;
  final int deliveryDays;
  final DateTime createdAt;
  final String buyerName;
  final String categoryId;
}

/// Phản hồi/ý tưởng gửi cho đội ngũ phát triển.
class FeedbackEntry {
  const FeedbackEntry({
    required this.kind,
    required this.area,
    required this.text,
    this.canContact = true,
    this.attachment,
  });

  /// 'idea' | 'bug'
  final String kind;
  final String area;
  final String text;
  final bool canContact;
  final String? attachment;
}

/// Thông tin onboarding người dùng chọn.
class OnboardingAnswers {
  const OnboardingAnswers({
    this.purposes = const {},
    this.interests = const {},
    this.experience,
    this.freelancerType,
    this.lookingFor = '',
  });
  final Set<String> purposes;
  final Set<String> interests;
  final String? experience;
  final String? freelancerType;
  final String lookingFor;
}
