/// Danh mục dịch vụ.
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    this.subcategories = const [],
    this.seed = 0,
  });
  final String id;
  final String name;
  final String subtitle;

  /// Khoá icon – xem [AppIcons].
  final String icon;
  final List<Subcategory> subcategories;
  final int seed;
}

class Subcategory {
  const Subcategory({required this.id, required this.name, this.gigCount = 0, this.icon = 'design'});
  final String id;
  final String name;
  final int gigCount;
  final String icon;
}

/// Gói dịch vụ (Cơ bản / Tiêu chuẩn / Cao cấp).
class GigPackage {
  const GigPackage({
    required this.tier,
    required this.title,
    required this.description,
    required this.price,
    required this.deliveryDays,
    this.revisions = 1,
    this.features = const {},
  });

  /// 'Cơ bản' | 'Tiêu chuẩn' | 'Cao cấp'
  final String tier;
  final String title;
  final String description;
  final int price;
  final int deliveryDays;

  /// -1 = không giới hạn
  final int revisions;

  /// Tính năng -> giá trị hiển thị ("✓", "2", ...). Giá trị rỗng = không có.
  final Map<String, String> features;

  @Deprecated('Dùng package.revisionsLocalized(context.l10n)')
  String get revisionsLabel => revisions < 0 ? 'Không giới hạn' : '$revisions';
}

/// Dịch vụ bổ sung khi đặt hàng.
class GigExtra {
  const GigExtra({required this.id, required this.title, required this.price, this.extraDays = 0});
  final String id;
  final String title;
  final int price;
  final int extraDays;
}

class Faq {
  const Faq(this.question, this.answer);
  final String question;
  final String answer;
}

/// Một dịch vụ (gig) do người bán đăng.
class Gig {
  const Gig({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.subcategoryId,
    required this.packages,
    this.imageSeeds = const [0, 1, 2],
    this.imageLabel = '',
    this.rating = 0,
    this.reviewCount = 0,
    this.extras = const [],
    this.faqs = const [],
    this.tags = const [],
    this.isPro = false,
    this.isChoice = false,
    this.style = '',
    this.requirements = const [],
  });

  final String id;
  final String sellerId;
  final String title;
  final String description;
  final String categoryId;
  final String subcategoryId;
  final List<GigPackage> packages;

  /// Ảnh giả: mỗi seed sinh 1 ảnh màu.
  final List<int> imageSeeds;

  /// Chữ lớn hiển thị trên ảnh giả (VD: "LOGO", "UI/UX").
  final String imageLabel;
  final double rating;
  final int reviewCount;
  final List<GigExtra> extras;
  final List<Faq> faqs;
  final List<String> tags;
  final bool isPro;
  final bool isChoice;
  final String style;

  /// Câu hỏi người bán yêu cầu người mua trả lời sau khi đặt hàng.
  final List<RequirementQuestion> requirements;

  int get priceFrom => packages.map((p) => p.price).reduce((a, b) => a < b ? a : b);

  int get fastestDelivery => packages.map((p) => p.deliveryDays).reduce((a, b) => a < b ? a : b);
}

enum RequirementType { text, choice, file }

class RequirementQuestion {
  const RequirementQuestion({
    required this.question,
    this.type = RequirementType.text,
    this.options = const [],
    this.required = true,
  });
  final String question;
  final RequirementType type;
  final List<String> options;
  final bool required;
}

/// Đánh giá của người mua.
class Review {
  const Review({
    required this.id,
    required this.sellerId,
    required this.authorName,
    required this.rating,
    required this.text,
    required this.createdAt,
    this.gigId,
    this.authorCountry = 'Việt Nam',
    this.authorSeed = 0,
    this.sellerResponse,
    this.price,
    this.durationDays,
  });

  final String id;
  final String sellerId;
  final String? gigId;
  final String authorName;
  final String authorCountry;
  final int authorSeed;
  final double rating;
  final String text;
  final DateTime createdAt;
  final String? sellerResponse;
  final int? price;
  final int? durationDays;
}

/// Bộ lọc tìm kiếm dịch vụ.
class GigFilter {
  const GigFilter({
    this.query = '',
    this.categoryId,
    this.subcategoryId,
    this.minPrice,
    this.maxPrice,
    this.maxDeliveryDays,
    this.sellerLevels = const {},
    this.proOnly = false,
    this.sort = GigSort.relevance,
  });

  final String query;
  final String? categoryId;
  final String? subcategoryId;
  final int? minPrice;
  final int? maxPrice;
  final int? maxDeliveryDays;
  final Set<String> sellerLevels; // tên SellerLevel
  final bool proOnly;
  final GigSort sort;

  int get activeCount =>
      (minPrice != null || maxPrice != null ? 1 : 0) +
      (maxDeliveryDays != null ? 1 : 0) +
      (sellerLevels.isNotEmpty ? 1 : 0) +
      (proOnly ? 1 : 0) +
      (subcategoryId != null ? 1 : 0);

  GigFilter copyWith({
    String? query,
    String? categoryId,
    String? subcategoryId,
    int? minPrice,
    int? maxPrice,
    int? maxDeliveryDays,
    Set<String>? sellerLevels,
    bool? proOnly,
    GigSort? sort,
    bool clearPrice = false,
    bool clearDelivery = false,
    bool clearSubcategory = false,
    bool clearCategory = false,
  }) => GigFilter(
    query: query ?? this.query,
    categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
    subcategoryId: clearSubcategory ? null : (subcategoryId ?? this.subcategoryId),
    minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
    maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
    maxDeliveryDays: clearDelivery ? null : (maxDeliveryDays ?? this.maxDeliveryDays),
    sellerLevels: sellerLevels ?? this.sellerLevels,
    proOnly: proOnly ?? this.proOnly,
    sort: sort ?? this.sort,
  );

  /// Xoá mọi bộ lọc, giữ từ khoá và danh mục.
  GigFilter cleared() => GigFilter(query: query, categoryId: categoryId, sort: sort);
}

enum GigSort { relevance, bestSelling, newest, priceLow, priceHigh, rating }

extension GigSortX on GigSort {
  @Deprecated('Dùng sort.localized(context.l10n)')
  String get label => switch (this) {
    GigSort.relevance => 'Phù hợp nhất',
    GigSort.bestSelling => 'Bán chạy',
    GigSort.newest => 'Mới nhất',
    GigSort.priceLow => 'Giá thấp đến cao',
    GigSort.priceHigh => 'Giá cao đến thấp',
    GigSort.rating => 'Đánh giá cao',
  };
}
