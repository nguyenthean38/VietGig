// Các interface repository. Hiện tại dùng bản Mock (lib/data/mock),
// sau này thay bằng bản Firebase (Firestore / Auth / Storage) mà không phải sửa UI.

import '../models/account.dart';
import '../models/catalog.dart';
import '../models/chat.dart';
import '../models/order.dart';
import '../models/user.dart';

/// Mã lỗi xác thực – giao diện dịch sang ngôn ngữ đang dùng (xem `authErrorText`).
enum AuthError {
  missingCredentials,
  userNotFound,
  wrongPassword,
  usernameTaken,
  emailTaken,
  invalidEmail,
  activeOrders,
  unknown,
}

class AuthException implements Exception {
  AuthException(this.code, [this.message = '']);
  final AuthError code;

  /// Thông tin thêm cho log (không hiển thị cho người dùng).
  final String message;
  @override
  String toString() => 'AuthException(${code.name}${message.isEmpty ? '' : ': $message'})';
}

abstract class AuthRepository {
  AppUser? get currentUser;
  Future<AppUser?> restoreSession();
  Future<AppUser> signIn({required String emailOrUsername, required String password});
  Future<AppUser> signUp({required String username, required String email, required String password});

  /// provider: 'google' | 'apple' | 'facebook'
  Future<AppUser> signInWithProvider(String provider);
  Future<void> signOut();
  Future<void> sendPasswordReset(String email);
  Future<void> resendVerification();
  Future<AppUser> verifyEmail();
  Future<AppUser> updateEmail(String newEmail);
  Future<AppUser> updateProfile(AppUser user);
  Future<AppUser> becomeSeller();
  Future<void> deleteAccount({required String reason});
  Future<void> deactivateAccount();
  Future<void> saveOnboarding(OnboardingAnswers answers);
}

abstract class CatalogRepository {
  Future<List<Category>> categories();
  Future<List<Gig>> search(GigFilter filter);
  Future<Gig?> gigById(String id);
  Future<List<Gig>> gigsBySeller(String sellerId);
  Future<List<Gig>> popularGigs();
  Future<AppUser?> userById(String id);
  Future<List<AppUser>> usersByIds(List<String> ids);
  Future<List<Review>> reviewsForSeller(String sellerId);
  Future<List<String>> suggestions(String query);
  Future<List<String>> relatedSearches(String query);
}

abstract class OrderRepository {
  Future<List<Order>> buyerOrders(String userId);
  Future<List<Order>> sellerOrders(String userId);
  Future<Order?> orderById(String id);
  Future<Order> placeOrder({
    required String buyerId,
    required Gig gig,
    required CheckoutDraft draft,
    required String paymentMethod,
  });

  /// Tạo đơn từ báo giá riêng.
  Future<Order> placeOfferOrder({required String buyerId, required CustomOffer offer});
  Future<Order> submitRequirements(String orderId, Map<String, String> answers);
  Future<Order> deliver(String orderId, Delivery delivery);
  Future<Order> approveDelivery(String orderId);
  Future<Order> requestRevision(String orderId, String message);
  Future<Order> requestExtension(
    String orderId, {
    required int days,
    required String message,
    required bool fromSeller,
  });
  Future<Order> respondToRequest(String orderId, {required bool accept});
  Future<Order> extendReviewTime(String orderId, int days);
  Future<Order> requestCancel(String orderId, {required String reason, required String message});
  Future<Order> leaveReview(String orderId, OrderReview review);
  Future<Order> reviewBuyer(String orderId, String text, int rating);
  Future<Order> tip(String orderId, int amount);
  Future<Order> addExtra(String orderId, GigExtra extra);
}

abstract class ChatRepository {
  Future<List<Conversation>> conversations(String userId);
  Future<List<ChatMessage>> messages(String conversationId);
  Future<Conversation> conversationWith(String userId, String otherUserId);
  Future<ChatMessage> send(ChatMessage message);
  Future<void> updateConversation(Conversation conversation);
  Future<void> deleteConversation(String conversationId);
  Future<CustomOffer> updateOffer(String messageId, OfferStatus status);
  Future<List<QuickResponse>> quickResponses();
  Future<QuickResponse> saveQuickResponse(QuickResponse response);
  Future<List<String>> labels();
  Future<void> addLabel(String label);
}

abstract class AccountRepository {
  Future<List<SavedList>> savedLists(String userId);
  Future<SavedList> saveList(SavedList list);
  Future<void> deleteList(String listId);
  Future<List<AppNotification>> notifications(String userId);
  Future<void> markNotificationsRead(String userId);
  Future<List<String>> browsingHistory(String userId);
  Future<void> addToHistory(String userId, String gigId);
  Future<void> clearHistory(String userId, {String? gigId});
  Future<Set<String>> interests(String userId);
  Future<void> saveInterests(String userId, Set<String> subcategoryIds);
  Future<SellerStats> sellerStats(String userId);
  Future<List<LevelRequirement>> levelRequirements();
  Future<Availability?> availability(String userId);
  Future<void> saveAvailability(String userId, Availability? availability);
  Future<List<Brief>> briefs(String userId);
  Future<void> sendFeedback(FeedbackEntry entry);
  Future<int> balance(String userId);
}
