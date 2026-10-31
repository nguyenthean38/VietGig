/// Cấp độ người bán.
enum SellerLevel { newSeller, level1, level2, topRated }

extension SellerLevelX on SellerLevel {
  @Deprecated('Dùng level.localized(context.l10n)')
  String get label => switch (this) {
    SellerLevel.newSeller => 'Mới',
    SellerLevel.level1 => 'Cấp 1',
    SellerLevel.level2 => 'Cấp 2',
    SellerLevel.topRated => 'Top Rated',
  };
}

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
    this.email = '',
    this.avatarSeed = 0,
    this.headline = '',
    this.bio = '',
    this.country = 'Việt Nam',
    this.city = '',
    this.languages = const ['Tiếng Việt'],
    this.skills = const [],
    this.level = SellerLevel.newSeller,
    this.isVettedPro = false,
    this.vettedFor = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.memberSince,
    this.responseHours = 1,
    this.online = false,
    this.emailVerified = true,
    this.isSeller = false,
    this.offersHourly = false,
    this.clients = const [],
    this.portfolio = const [],
  });

  final String id;
  final String username;
  final String displayName;
  final String email;

  /// Seed dùng để sinh màu avatar khi chưa có ảnh.
  final int avatarSeed;
  final String headline;
  final String bio;
  final String country;
  final String city;
  final List<String> languages;
  final List<String> skills;
  final SellerLevel level;
  final bool isVettedPro;
  final List<String> vettedFor;
  final double rating;
  final int reviewCount;
  final DateTime? memberSince;
  final int responseHours;
  final bool online;
  final bool emailVerified;
  final bool isSeller;
  final bool offersHourly;
  final List<ClientWork> clients;
  final List<PortfolioItem> portfolio;

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  AppUser copyWith({
    String? username,
    String? displayName,
    String? email,
    String? headline,
    String? bio,
    bool? emailVerified,
    bool? isSeller,
    bool? online,
    List<String>? skills,
    List<String>? languages,
  }) => AppUser(
    id: id,
    username: username ?? this.username,
    displayName: displayName ?? this.displayName,
    email: email ?? this.email,
    avatarSeed: avatarSeed,
    headline: headline ?? this.headline,
    bio: bio ?? this.bio,
    country: country,
    city: city,
    languages: languages ?? this.languages,
    skills: skills ?? this.skills,
    level: level,
    isVettedPro: isVettedPro,
    vettedFor: vettedFor,
    rating: rating,
    reviewCount: reviewCount,
    memberSince: memberSince,
    responseHours: responseHours,
    online: online ?? this.online,
    emailVerified: emailVerified ?? this.emailVerified,
    isSeller: isSeller ?? this.isSeller,
    offersHourly: offersHourly,
    clients: clients,
    portfolio: portfolio,
  );

  Map<String, dynamic> toMap() => {
    'username': username,
    'displayName': displayName,
    'email': email,
    'avatarSeed': avatarSeed,
    'headline': headline,
    'bio': bio,
    'country': country,
    'city': city,
    'languages': languages,
    'skills': skills,
    'level': level.name,
    'isVettedPro': isVettedPro,
    'vettedFor': vettedFor,
    'rating': rating,
    'reviewCount': reviewCount,
    'memberSince': memberSince?.toIso8601String(),
    'responseHours': responseHours,
    'emailVerified': emailVerified,
    'isSeller': isSeller,
    'offersHourly': offersHourly,
  };

  factory AppUser.fromMap(String id, Map<String, dynamic> m) => AppUser(
    id: id,
    username: m['username'] as String? ?? '',
    displayName: m['displayName'] as String? ?? '',
    email: m['email'] as String? ?? '',
    avatarSeed: (m['avatarSeed'] as num?)?.toInt() ?? 0,
    headline: m['headline'] as String? ?? '',
    bio: m['bio'] as String? ?? '',
    country: m['country'] as String? ?? 'Việt Nam',
    city: m['city'] as String? ?? '',
    languages: List<String>.from(m['languages'] as List? ?? const []),
    skills: List<String>.from(m['skills'] as List? ?? const []),
    level: SellerLevel.values.asNameMap()[m['level']] ?? SellerLevel.newSeller,
    isVettedPro: m['isVettedPro'] as bool? ?? false,
    vettedFor: List<String>.from(m['vettedFor'] as List? ?? const []),
    rating: (m['rating'] as num?)?.toDouble() ?? 0,
    reviewCount: (m['reviewCount'] as num?)?.toInt() ?? 0,
    memberSince: DateTime.tryParse(m['memberSince'] as String? ?? ''),
    responseHours: (m['responseHours'] as num?)?.toInt() ?? 1,
    emailVerified: m['emailVerified'] as bool? ?? false,
    isSeller: m['isSeller'] as bool? ?? false,
    offersHourly: m['offersHourly'] as bool? ?? false,
  );
}

/// Một dự án đã làm với khách hàng doanh nghiệp (tab "Khách hàng").
class ClientWork {
  const ClientWork({
    required this.company,
    required this.period,
    required this.description,
    this.industry = '',
    this.seed = 0,
  });
  final String company;
  final String period;
  final String description;
  final String industry;
  final int seed;
}

/// Một mục trong portfolio.
class PortfolioItem {
  const PortfolioItem({
    required this.id,
    required this.title,
    this.description = '',
    this.seed = 0,
    this.imageCount = 3,
  });
  final String id;
  final String title;
  final String description;
  final int seed;
  final int imageCount;
}
