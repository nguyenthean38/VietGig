import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/models/chat.dart';
import '../data/models/order.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/onboarding_screen.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/verify_email_screen.dart';
import '../features/auth/welcome_screen.dart';
import '../features/gig/gig_detail_screen.dart';
import '../features/gig/portfolio_item_screen.dart';
import '../features/gig/portfolio_screen.dart';
import '../features/gig/reviews_screen.dart';
import '../features/gig/seller_profile_screen.dart';
import '../features/home/home_screen.dart';
import '../features/inbox/chat_screen.dart';
import '../features/inbox/contact_redirect_screen.dart';
import '../features/inbox/create_offer_screen.dart';
import '../features/inbox/inbox_screen.dart';
import '../features/inbox/offer_detail_screen.dart';
import '../features/orders/add_card_screen.dart';
import '../features/orders/checkout_screen.dart';
import '../features/orders/deliver_order_screen.dart';
import '../features/orders/manage_orders_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/orders/order_review_screen.dart';
import '../features/orders/rate_order_screen.dart';
import '../features/orders/requirements_screen.dart';
import '../features/orders/resolution_center_screen.dart';
import '../features/profile/account_screen.dart';
import '../features/profile/appearance_screen.dart';
import '../features/profile/balance_screen.dart';
import '../features/profile/currency_screen.dart';
import '../features/profile/deactivation_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/profile/feedback_screen.dart';
import '../features/profile/invite_friends_screen.dart';
import '../features/profile/language_screen.dart';
import '../features/profile/notification_settings_screen.dart';
import '../features/profile/notifications_screen.dart';
import '../features/profile/preferences_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/support_screen.dart';
import '../features/profile/update_email_screen.dart';
import '../features/saved/browsing_history_screen.dart';
import '../features/saved/saved_list_detail_screen.dart';
import '../features/saved/saved_lists_screen.dart';
import '../features/search/category_screen.dart';
import '../features/search/explore_screen.dart';
import '../features/search/interests_screen.dart';
import '../features/search/search_input_screen.dart';
import '../features/search/search_results_screen.dart';
import '../features/seller/availability_screen.dart';
import '../features/seller/briefs_screen.dart';
import '../features/seller/earnings_screen.dart';
import '../features/seller/level_overview_screen.dart';
import '../features/seller/my_gigs_screen.dart';
import '../features/seller/offer_templates_screen.dart';
import '../features/seller/seller_dashboard_screen.dart';
import '../state/session_controller.dart';
import 'app_shell.dart';

/// Các đường dẫn khách (chưa đăng nhập) vẫn xem được.
const _publicPrefixes = [
  '/splash',
  '/welcome',
  '/auth',
  '/home',
  '/search',
  '/category',
  '/gig',
  '/user',
  '/portfolio',
  '/profile',
  '/support',
  '/settings/appearance',
  '/settings/language',
  '/settings/currency',
];

bool _isPublic(String loc) => _publicPrefixes.any((p) => loc == p || loc.startsWith('$p/') || loc.startsWith('$p?'));

/// Trang trượt từ dưới lên (dùng cho màn hình dạng modal: bộ lọc, báo giá, ...).
Page<void> modalPage(GoRouterState state, Widget child) => CustomTransitionPage<void>(
  key: state.pageKey,
  fullscreenDialog: true,
  child: child,
  transitionsBuilder: (context, anim, _, child) => SlideTransition(
    position: Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
    child: child,
  ),
);

GoRouter buildRouter(SessionController session, {String initialLocation = '/splash'}) {
  final rootKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    refreshListenable: session,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final uri = state.uri.toString();
      switch (session.status) {
        case SessionStatus.unknown:
          // Đang khôi phục phiên: chờ ở splash, nhớ lại nơi định tới.
          return loc == '/splash' ? null : '/splash?from=${Uri.encodeComponent(uri)}';
        case SessionStatus.signedOut:
          if (loc == '/splash') {
            final from = state.uri.queryParameters['from'] ?? '';
            if (from.startsWith('/auth')) return from;
            return session.isGuest ? (from.isEmpty ? '/home' : from) : '/welcome';
          }
          if (loc == '/welcome' && session.isGuest) return '/home';
          if (!session.isGuest && !(loc.startsWith('/auth') || loc == '/welcome')) return '/welcome';
          if (session.isGuest && !_isPublic(loc)) {
            return '/auth/signin?from=${Uri.encodeComponent(uri)}';
          }
          return null;
        case SessionStatus.signedIn:
          if (session.needsOnboarding && loc != '/onboarding') return '/onboarding';
          if (!session.needsOnboarding && loc == '/onboarding') return '/home';
          if (loc == '/splash' || loc == '/welcome' || loc.startsWith('/auth')) {
            final from = state.uri.queryParameters['from'];
            return (from != null && from.isNotEmpty) ? from : '/home';
          }
          return null;
      }
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/auth/signin', pageBuilder: (_, s) => modalPage(s, const SignInScreen())),
      GoRoute(path: '/auth/signup', builder: (_, _) => const SignUpScreen()),
      GoRoute(path: '/auth/forgot', builder: (_, _) => const ForgotPasswordScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/verify-email', pageBuilder: (_, s) => modalPage(s, const VerifyEmailScreen())),

      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, _) =>
                    context.watch<SessionController>().sellerMode ? const SellerDashboardScreen() : const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/inbox', builder: (_, _) => const InboxScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/search', builder: (_, _) => const ExploreScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/orders', builder: (_, _) => const ManageOrdersScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen())],
          ),
        ],
      ),

      // ---------------- Tìm kiếm & khám phá
      GoRoute(
        path: '/search/input',
        pageBuilder: (_, s) => NoTransitionPage(
          key: s.pageKey,
          child: SearchInputScreen(initialQuery: s.uri.queryParameters['q'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/search/results',
        builder: (_, s) => SearchResultsScreen(
          query: s.uri.queryParameters['q'] ?? '',
          categoryId: s.uri.queryParameters['category'],
          subcategoryId: s.uri.queryParameters['sub'],
        ),
      ),
      GoRoute(
        path: '/category/:id',
        builder: (_, s) => CategoryScreen(categoryId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/interests', builder: (_, _) => const InterestsScreen()),

      // ---------------- Gig & người bán
      GoRoute(
        path: '/gig/:id',
        builder: (_, s) => GigDetailScreen(gigId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/user/:id',
        builder: (_, s) => SellerProfileScreen(
          userId: s.pathParameters['id']!,
          initialTab: int.tryParse(s.uri.queryParameters['tab'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/user/:id/reviews',
        builder: (_, s) => ReviewsScreen(userId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/user/:id/portfolio',
        builder: (_, s) => PortfolioScreen(userId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/portfolio/:userId/:itemId',
        pageBuilder: (_, s) =>
            modalPage(s, PortfolioItemScreen(userId: s.pathParameters['userId']!, itemId: s.pathParameters['itemId']!)),
      ),

      // ---------------- Đã lưu
      GoRoute(path: '/saved', builder: (_, _) => const SavedListsScreen()),
      GoRoute(
        path: '/saved/:id',
        builder: (_, s) => SavedListDetailScreen(listId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/history', builder: (_, _) => const BrowsingHistoryScreen()),

      // ---------------- Đặt hàng
      GoRoute(
        path: '/checkout/:gigId',
        builder: (_, s) => CheckoutScreen(
          gigId: s.pathParameters['gigId']!,
          packageIndex: int.tryParse(s.uri.queryParameters['pkg'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/checkout/:gigId/review',
        builder: (_, s) {
          final extra = s.extra;
          return OrderReviewScreen(
            gigId: s.pathParameters['gigId']!,
            draft: extra is CheckoutDraft ? extra : null,
            offer: extra is CustomOffer ? extra : null,
          );
        },
      ),
      GoRoute(path: '/add-card', pageBuilder: (_, s) => modalPage(s, const AddCardScreen())),
      GoRoute(
        path: '/orders/:id',
        builder: (_, s) => OrderDetailScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/orders/:id/requirements',
        pageBuilder: (_, s) => modalPage(s, RequirementsScreen(orderId: s.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/orders/:id/rate',
        pageBuilder: (_, s) => modalPage(s, RateOrderScreen(orderId: s.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/orders/:id/resolution',
        pageBuilder: (_, s) => modalPage(s, ResolutionCenterScreen(orderId: s.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/orders/:id/deliver',
        pageBuilder: (_, s) => modalPage(s, DeliverOrderScreen(orderId: s.pathParameters['id']!)),
      ),

      // ---------------- Tin nhắn
      GoRoute(
        path: '/chat/:id',
        builder: (_, s) => ChatScreen(conversationId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/chat/:id/offer/new',
        pageBuilder: (_, s) => modalPage(s, CreateOfferScreen(conversationId: s.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/chat/:id/offer/:messageId',
        builder: (_, s) =>
            OfferDetailScreen(conversationId: s.pathParameters['id']!, messageId: s.pathParameters['messageId']!),
      ),
      GoRoute(
        path: '/contact/:userId',
        builder: (_, s) =>
            ContactRedirectScreen(userId: s.pathParameters['userId']!, gigId: s.uri.queryParameters['gig']),
      ),

      // ---------------- Tài khoản & cài đặt
      GoRoute(path: '/notifications', builder: (_, _) => const NotificationsScreen()),
      GoRoute(path: '/settings/preferences', builder: (_, _) => const PreferencesScreen()),
      GoRoute(path: '/settings/notifications', builder: (_, _) => const NotificationSettingsScreen()),
      GoRoute(path: '/settings/appearance', builder: (_, _) => const AppearanceScreen()),
      GoRoute(path: '/settings/language', builder: (_, _) => const LanguageScreen()),
      GoRoute(path: '/settings/currency', builder: (_, _) => const CurrencyScreen()),
      GoRoute(path: '/settings/account', builder: (_, _) => const AccountScreen()),
      GoRoute(path: '/settings/email', builder: (_, _) => const UpdateEmailScreen()),
      GoRoute(path: '/settings/balance', builder: (_, _) => const BalanceScreen()),
      GoRoute(path: '/settings/deactivate', builder: (_, _) => const DeactivationScreen()),
      GoRoute(path: '/settings/edit-profile', builder: (_, _) => const EditProfileScreen()),
      GoRoute(
        path: '/feedback',
        pageBuilder: (_, s) => modalPage(s, FeedbackScreen(kind: s.uri.queryParameters['kind'] ?? 'idea')),
      ),
      GoRoute(path: '/invite', builder: (_, _) => const InviteFriendsScreen()),
      GoRoute(path: '/support', builder: (_, _) => const SupportScreen()),

      // ---------------- Người bán
      GoRoute(path: '/seller/earnings', builder: (_, _) => const EarningsScreen()),
      GoRoute(path: '/seller/level', builder: (_, _) => const LevelOverviewScreen()),
      GoRoute(path: '/seller/availability', builder: (_, _) => const AvailabilityScreen()),
      GoRoute(path: '/seller/briefs', builder: (_, _) => const BriefsScreen()),
      GoRoute(path: '/seller/gigs', builder: (_, _) => const MyGigsScreen()),
      GoRoute(path: '/seller/offer-templates', builder: (_, _) => const OfferTemplatesScreen()),
    ],
  );
}
