# VietGig – Hướng dẫn phát triển (đọc trước khi code)

App Flutter chợ dịch vụ freelance, **toàn bộ giao diện tiếng Việt**, dữ liệu **mock** (sau này nối Firebase).
Thiết kế tham khảo: bộ ảnh `D:\CV\Fiverr ios Aug 2026\Fiverr ios Aug 2026 N.png` (N = 0..344, 1180x2676).
Thương hiệu riêng là **VietGig** (không dùng chữ "Fiverr" trong UI). Tiền tệ VND (`Fmt.money`).

## Môi trường
- Flutter 3.44 / Dart 3.12 tại `D:\flutter\bin\flutter`. Project: `D:\CV\viet_gig`.
- Gói: `provider`, `go_router` 17, `intl`. **Không thêm package mới.**
- Không dùng API deprecated: dùng `color.withValues(alpha: x)` thay `withOpacity`, `RadioGroup` hoặc tự vẽ radio nếu `Radio.groupValue` bị báo deprecated, v.v. `flutter analyze` phải sạch (0 issue) cho file của bạn.
- Shell là Git Bash trên Windows.

## Cấu trúc
```
lib/
  app.dart                     MultiProvider + MaterialApp.router (theme sáng/tối, locale vi)
  core/theme/app_colors.dart   AppColors (brand xanh #1DBF73, ink #222325, muted, border, ...)
  core/theme/app_theme.dart    Theme: FilledButton = nút đen, OutlinedButton viền, input nền xám
  core/utils/format.dart       Fmt.money / moneyShort / date / dateMedium / time / chatStamp / ago / countdown
  core/utils/app_icons.dart    AppIcons.of('design') – icon theo khoá chuỗi
  core/widgets/widgets.dart    export toàn bộ widget dùng chung (xem bên dưới)
  data/models/*.dart           AppUser, Category, Gig, GigPackage, GigExtra, Review, GigFilter,
                               Order, OrderStatus, OrderEvent, Delivery, OrderReview, CheckoutDraft,
                               Conversation, ChatMessage, CustomOffer, Milestone, QuickResponse,
                               SavedList, AppNotification, SellerStats, LevelRequirement,
                               Availability, Brief, FeedbackEntry, OnboardingAnswers
  data/repositories/repositories.dart  interface AuthRepository, CatalogRepository, OrderRepository,
                               ChatRepository, AccountRepository (+ AuthException)
  data/mock/mock_data.dart     dữ liệu mẫu (MockData.meId = 'u_me', người bán u_hoang, u_bao, ...)
  data/mock/mock_repositories.dart  MockDb + Mock*Repository
  data/services.dart           AppServices.mock()
  state/session_controller.dart  SessionController (user, sellerMode, isGuest, signIn/Up/Out, ...)
  state/app_controllers.dart   SettingsController, SavedController, OrdersController,
                               InboxController, NotificationsController
  router/app_router.dart       TẤT CẢ route (đã khai báo sẵn, đừng sửa)
  router/app_shell.dart        Thanh điều hướng dưới (5 tab; chế độ người bán ẩn tab Tìm kiếm)
  features/<nhóm>/*.dart       Màn hình – hiện là file khung "Đang xây dựng", bạn thay nội dung
test/helpers.dart              pumpApp(tester, location:'/x', signedIn:true) + settle(tester)
```

## Lấy dữ liệu trong màn hình
- Controller toàn app: `context.watch<OrdersController>()`, `context.read<SessionController>()`, ...
  (đã tự `load()` khi đăng nhập – xem `app.dart`).
- Repository trực tiếp (dữ liệu chỉ đọc): `context.read<CatalogRepository>().gigById(id)` …
  Gói trong `AsyncView(future: ..., builder: ...)` hoặc FutureBuilder. **Tạo Future trong `initState`/state, không tạo lại mỗi lần build.**
- Người dùng hiện tại: `context.watch<SessionController>().user` (có thể null nếu là khách).

## Widget dùng chung (import '../../core/widgets/widgets.dart')
`PlaceholderImage(seed,label,radius,width,height)` ảnh giả · `UserAvatar(user|name+seed,size,showOnline)` ·
`BrandLogo`, `BrandMark`, `Illustration(icon)` · `VettedProBadge`, `TopRatedBadge`, `LevelBadge(level)`, `ProTag`,
`ChoiceTag`, `OrderStatusPill(status)`, `RatingText(rating,count)`, `StarRating(value,onChanged,labels)`, `CountBadge` ·
`CircleIconButton`, `AppBackButton`, `SimpleAppBar(title, close:, actions:)`, `SectionHeader(title,onAction)`,
`MenuTile(title,icon,subtitle,onTap,trailing)`, `EmptyState(icon,title,message,actionLabel,onAction)`,
`PrimaryButton(label,onPressed,loading)`, `BottomActionBar(child,note)`, `AppCard`, `SelectChip(label,selected,onTap)`,
`OptionTile(label,icon,selected,onTap,description)`, `CountdownBox(days,hours,minutes)`, `AsyncView<T>`,
`CountedTextField(controller,hint,maxLength)`, `OrDivider`, `FloatingChatButton(seed,name,onPressed)` ·
`showAppSnack(context,msg,onUndo:)`, `confirmDialog(...)→bool`, `infoDialog`, `showActionSheet<T>(actions: [SheetAction])` ·
`SaveGigButton(gigId)`, `showSaveToListSheet(context,gigId:|sellerId:)`, `GigListTile(gig,seller)`, `GigCard(gig)`,
`GigCarousel(gigs)`, `GigThumbRow(seed,title,subtitle,trailing)`.
Nếu cần widget riêng → tạo trong thư mục feature của bạn (VD `features/orders/widgets/...`).

## Route (đã có trong app_router.dart)
Tab (shell): `/home` (người mua: HomeScreen; người bán: SellerDashboardScreen), `/inbox`, `/search`, `/orders`, `/profile`.
Khác: `/splash` `/welcome` `/auth/signin?from=` `/auth/signup` `/auth/forgot` `/onboarding` `/verify-email`
`/search/input?q=` `/search/results?q=&category=&sub=` `/category/:id` `/interests`
`/gig/:id` `/user/:id?tab=` (hồ sơ người bán; tab 0 Giới thiệu,1 Dịch vụ,2 Đánh giá,3 Portfolio,4 Khách hàng)
`/user/:id/reviews` `/user/:id/portfolio` `/portfolio/:userId/:itemId`
`/saved` `/saved/:id` `/history`
`/checkout/:gigId?pkg=` → `/checkout/:gigId/review` (extra: CheckoutDraft hoặc CustomOffer) · `/add-card`
`/orders/:id` `/orders/:id/requirements` `/orders/:id/rate` `/orders/:id/resolution` `/orders/:id/deliver`
`/chat/:id` `/chat/:id/offer/new` `/chat/:id/offer/:messageId` `/contact/:userId?gig=` (mở/ tạo hội thoại rồi vào chat)
`/notifications` `/settings/preferences|notifications|appearance|language|currency|account|email|balance|deactivate|edit-profile`
`/feedback?kind=idea|bug` `/invite` `/support`
`/seller/earnings|level|availability|briefs|gigs|offer-templates`
Điều hướng: `context.push('/gig/g_app')`, `context.go('/home')`, `context.pop()`.

## Quy ước UI
- Nền trắng, nút chính đen bo 10, chữ đậm vừa phải, đường kẻ mảnh; điểm nhấn xanh `AppColors.brand`.
- Dùng màu từ `Theme.of(context).colorScheme` (onSurface, onSurfaceVariant, outline, surfaceContainerHighest)
  để **dark mode** hoạt động; chỉ dùng AppColors cho điểm nhấn (brand, danger, badge…).
- Màn hình trong tab (home/inbox/search/orders/profile) có thanh điều hướng nổi → thêm padding đáy ~110.
- Mọi chuỗi hiển thị tiếng Việt có dấu, tự nhiên. Ngày: `Fmt.date`, tiền: `Fmt.money`.
- Mỗi màn hình phải có xử lý: loading, rỗng, lỗi (nếu có dữ liệu), validate form, phản hồi (snack/dialog).
- Gắn `ValueKey` cho phần tử quan trọng để test (nút submit, ô nhập…).
- Không để lỗi overflow ở chiều rộng 360–430px.

## Test
- Đặt test ở `test/<nhóm>_test.dart`. Dùng `pumpApp(tester, location: '/orders')` (đã đăng nhập sẵn, mock không độ trễ),
  `await settle(tester)` thay cho pumpAndSettle (vì có spinner).
- `VietGigApp` tự gọi `session.restore()` khi khởi động; router giữ đích đến qua `/splash?from=...`,
  nên `pumpApp(tester, location: '/orders/a8f21c')` sẽ mở đúng màn hình đó sau `settle`.
  SplashScreen chỉ là giao diện (logo), không cần tự điều hướng.
- Chạy: `flutter test test/<nhóm>_test.dart` và `flutter analyze lib/features/<nhóm> test/<nhóm>_test.dart`.


## Design system (đợt chuẩn hoá 2)
- **Màu:** `context.tokens` (`AppTokens` – ThemeExtension sáng/tối) cho màu ngữ nghĩa; `context.colors` (ColorScheme) cho màu nền/chữ.
  Không dùng `AppColors` trong `lib/features` (trừ `AppColors.fromSeed/palette` cho màu trang trí).
- **Khoảng cách:** `Space`, `Gaps`, `Insets`, `Radii` trong `lib/core/theme/spacing.dart`.
- **Widget chung:** `core/widgets/buttons.dart`, `layout.dart`, `inputs.dart`, `badges.dart`, `visuals.dart`,
  `gig_widgets.dart`, `save_list_sheet.dart`, `feedback.dart` (import gộp qua `widgets.dart`).
- **Giới hạn:** mỗi file ≤ 400 dòng.

## Đa ngôn ngữ (vi mặc định + en)
- Chuỗi giao diện nằm trong `lib/l10n/parts/<nhóm>_vi.arb` + `<nhóm>_en.arb`. Sau khi sửa chạy `python tool/l10n_merge.py`
  (gộp thành `lib/l10n/app_vi.arb`/`app_en.arb` rồi `flutter gen-l10n`). Kiểm tra: `python tool/l10n_merge.py --check`.
- Dùng: `context.l10n.key`; enum: `status.localized(context.l10n)`; lỗi đăng nhập: `authErrorText(l10n, e)`.
- Đổi ngôn ngữ: `SettingsController.setLocale(const Locale('en'))`. `Fmt` tự định dạng ngày/số theo ngôn ngữ.
- Dữ liệu (tên dịch vụ, tin nhắn, tên người…) không dịch.

## CI
`.github/workflows/ci.yml`: kiểm tra .arb → gen-l10n → `dart format --set-exit-if-changed -l 120` → `flutter analyze` → `flutter test` → build APK release (artifact).
