import 'package:flutter/material.dart';

import '../../data/models/catalog.dart';
import '../../data/models/chat.dart';
import '../../data/models/order.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_tokens.dart';

export '../../l10n/app_localizations.dart';

/// Truy cập nhanh chuỗi ngôn ngữ và theme: `context.l10n.navHome`,
/// `context.tokens.success`, `context.colors.onSurface`, `context.textTheme.titleLarge`.
extension AppContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  AppTokens get tokens => Theme.of(this).extension<AppTokens>() ?? AppTokens.light;
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

/// Nhãn đã dịch cho các enum của model.
extension OrderStatusL10n on OrderStatus {
  String localized(AppLocalizations l) => switch (this) {
    OrderStatus.awaitingRequirements => l.orderStatusAwaitingRequirements,
    OrderStatus.inProgress => l.orderStatusInProgress,
    OrderStatus.delivered => l.orderStatusDelivered,
    OrderStatus.revisionRequested => l.orderStatusRevisionRequested,
    OrderStatus.completed => l.orderStatusCompleted,
    OrderStatus.cancelled => l.orderStatusCancelled,
    OrderStatus.disputed => l.orderStatusDisputed,
  };

  /// Màu chữ nhãn trạng thái theo token.
  Color fg(AppTokens t, ColorScheme cs) => switch (this) {
    OrderStatus.awaitingRequirements || OrderStatus.revisionRequested || OrderStatus.disputed => t.warning,
    OrderStatus.inProgress => t.info,
    OrderStatus.delivered => t.vettedFg,
    OrderStatus.completed => t.success,
    OrderStatus.cancelled => cs.onSurfaceVariant,
  };

  /// Màu nền nhãn trạng thái theo token.
  Color bg(AppTokens t, ColorScheme cs) => switch (this) {
    OrderStatus.awaitingRequirements || OrderStatus.revisionRequested || OrderStatus.disputed => t.warningSoft,
    OrderStatus.inProgress => t.infoSoft,
    OrderStatus.delivered => t.vettedBg,
    OrderStatus.completed => t.successSoft,
    OrderStatus.cancelled => cs.surfaceContainerHighest,
  };
}

extension SellerLevelL10n on SellerLevel {
  String localized(AppLocalizations l) => switch (this) {
    SellerLevel.newSeller => l.levelNew,
    SellerLevel.level1 => l.levelOne,
    SellerLevel.level2 => l.levelTwo,
    SellerLevel.topRated => l.levelTopRated,
  };
}

extension GigSortL10n on GigSort {
  String localized(AppLocalizations l) => switch (this) {
    GigSort.relevance => l.sortRelevance,
    GigSort.bestSelling => l.sortBestSelling,
    GigSort.newest => l.sortNewest,
    GigSort.priceLow => l.sortPriceLow,
    GigSort.priceHigh => l.sortPriceHigh,
    GigSort.rating => l.sortRating,
  };
}

extension OfferStatusL10n on OfferStatus {
  String localized(AppLocalizations l) => switch (this) {
    OfferStatus.pending => l.offerStatusPending,
    OfferStatus.accepted => l.offerStatusAccepted,
    OfferStatus.declined => l.offerStatusDeclined,
    OfferStatus.withdrawn => l.offerStatusWithdrawn,
    OfferStatus.expired => l.offerStatusExpired,
  };
}

extension GigPackageL10n on GigPackage {
  String revisionsLocalized(AppLocalizations l) => revisions < 0 ? l.revisionsUnlimited : '$revisions';
}

/// Khoá cài đặt thông báo -> nhãn hiển thị.
String notificationKeyLabel(AppLocalizations l, String key) => switch (key) {
  'inbox' => l.notifKeyInbox,
  'orderMessages' => l.notifKeyOrderMessages,
  'orderUpdates' => l.notifKeyOrderUpdates,
  'ratingReminders' => l.notifKeyRatingReminders,
  'buyerBriefs' => l.notifKeyBuyerBriefs,
  'myGigs' => l.notifKeyMyGigs,
  'myAccount' => l.notifKeyMyAccount,
  'promotions' => l.notifKeyPromotions,
  _ => key,
};

/// Thông báo lỗi xác thực đã dịch.
String authErrorText(AppLocalizations l, AuthException e) => switch (e.code) {
  AuthError.missingCredentials => l.authErrorMissingCredentials,
  AuthError.userNotFound => l.authErrorUserNotFound,
  AuthError.wrongPassword => l.authErrorWrongPassword,
  AuthError.usernameTaken => l.authErrorUsernameTaken,
  AuthError.emailTaken => l.authErrorEmailTaken,
  AuthError.invalidEmail => l.authErrorInvalidEmail,
  AuthError.activeOrders => l.authErrorActiveOrders,
  AuthError.unknown => l.authErrorUnknown,
};
