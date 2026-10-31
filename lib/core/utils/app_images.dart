/// Ảnh mẫu đóng gói trong app (assets/images). Ảnh minh hoạ lấy từ Picsum/Unsplash,
/// ảnh đại diện từ randomuser.me – chỉ dùng cho dữ liệu mẫu, khi nối Firebase sẽ
/// thay bằng URL ảnh thật trong Storage.
class AppImages {
  AppImages._();

  /// Các ảnh minh hoạ có sẵn: `assets/images/photos/{id}.jpg`
  static const _photoIds = <int>{
    0, 1, 2, 3, 4, 5, 6, 7, 9, 18, 20, 21, 24, 26, 36, 39, 48, 56, 60, 63, 64, 82, //
    119, 145, 158, 160, 164, 180, 201, 225, 250, 252, 274, 292, 304, 312, 319, 341, 342, 348, 355,
  };

  /// Đường dẫn ảnh minh hoạ cho [id], hoặc null nếu không có.
  static String? photo(int id) => _photoIds.contains(id) ? 'assets/images/photos/$id.jpg' : null;

  /// Ảnh nền màn hình chào mừng.
  static const welcomeHero = 'assets/images/photos/5.jpg';

  static const _categoryPhoto = <String, int>{
    'graphics': 20,
    'tech': 0,
    'ai': 60,
    'marketing': 274,
    'video': 158,
    'writing': 24,
    'music': 145,
    'photo': 250,
    'business': 9,
  };

  static const _subcategoryPhoto = <String, int>{
    'logo': 252,
    'brand': 36,
    'uiux': 160,
    'print': 26,
    'shirt': 21,
    'card': 9,
    'illustration': 82,
    'website': 48,
    'mobileapp': 3,
    'wordpress': 6,
    'chatbot': 1,
    'aiart': 56,
    'data': 180,
    'social': 348,
    'seo': 7,
    'ads': 342,
    'editing': 304,
    'logoanim': 158,
    'explainer': 341,
    'article': 4,
    'translate': 24,
    'voiceover': 39,
    'photoedit': 319,
    'plan': 201,
    // sở thích gợi ý
    'productphoto': 250,
    'game': 119,
    'growth': 2,
    'craft': 82,
    'analytics': 180,
  };

  static String? category(String id) => _photoIdOrNull(_categoryPhoto[id]);
  static String? subcategory(String id) => _photoIdOrNull(_subcategoryPhoto[id]);

  /// Ảnh bìa gig theo id (đăng ký khi nạp dữ liệu).
  static final Map<String, int> _gigCover = {};
  static void registerGig(String gigId, int coverSeed) => _gigCover[gigId] = coverSeed;
  static String? gigCover(String gigId) => _photoIdOrNull(_gigCover[gigId]);

  /// Ảnh portfolio: mỗi mục có nhiều ảnh.
  static const _portfolio = <String, List<int>>{
    'p1': [292, 160, 3, 341, 63],
    'p2': [60, 180, 48],
    'p3': [24, 341, 160, 4],
    'p4': [164, 0, 6],
    'p5': [225, 312, 26],
    'p6': [63, 7, 20, 26],
    'p7': [18, 252],
    'p8': [225, 312, 36],
  };

  static List<String> portfolio(String itemId) => [for (final id in _portfolio[itemId] ?? const <int>[]) ?photo(id)];

  // ------------------------------------------------------------ Ảnh đại diện
  static const _avatarByUser = <String, String>{
    'u_me': 'women_90',
    'u_hoang': 'men_45',
    'u_bao': 'men_12',
    'u_linh': 'women_44',
    'u_tuan': 'men_22',
    'u_mai': 'women_12',
    'u_khoa': 'men_36',
    'u_an': 'men_52',
    'u_quynh': 'women_26',
    'u_buyer1': 'women_21',
  };

  /// Tên hiển thị/username -> userId (để tìm ảnh khi chỉ có tên).
  static final Map<String, String> _userByName = {};
  static void registerUser(String id, {required String displayName, required String username}) {
    _userByName[displayName.toLowerCase()] = id;
    _userByName[username.toLowerCase()] = id;
  }

  /// Ảnh dành cho người đánh giá / người lạ (chọn theo tên).
  static const _pool = [
    'men_15', 'women_33', 'men_28', 'women_47', 'men_3', 'women_5', 'men_32', //
    'women_57', 'men_5', 'women_65', 'men_75', 'women_68', 'men_8', 'women_72',
  ];

  /// Không gán ảnh người cho tài khoản tổ chức.
  static const _noPhotoNames = {'portfolio forge', 'dynamic website'};

  static String? avatarForUser(String userId) {
    final f = _avatarByUser[userId];
    return f == null ? null : 'assets/images/avatars/$f.jpg';
  }

  static String? avatarForName(String name) {
    final key = name.trim().toLowerCase();
    if (key.isEmpty || key == '?' || _noPhotoNames.contains(key)) return null;
    final id = _userByName[key];
    if (id != null) return avatarForUser(id);
    var h = 0;
    for (final c in key.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return 'assets/images/avatars/${_pool[h % _pool.length]}.jpg';
  }

  /// Tìm ảnh của người dùng được nhắc tới trong đoạn văn (VD nội dung thông báo).
  static String? avatarMentionedIn(String text) {
    final t = text.toLowerCase();
    for (final e in _userByName.entries) {
      if (e.key.length > 3 && t.contains(e.key)) return avatarForUser(e.value);
    }
    return null;
  }

  static String? _photoIdOrNull(int? id) => id == null ? null : photo(id);
}
