import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/l10n/l10n.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/format.dart';
import 'data/repositories/repositories.dart';
import 'data/services.dart';
import 'router/app_router.dart';
import 'state/app_controllers.dart';
import 'state/session_controller.dart';

/// Gốc ứng dụng: cung cấp repository + controller cho toàn app.
class VietGigApp extends StatefulWidget {
  const VietGigApp({super.key, required this.services, this.initialLocation = '/splash'});
  final AppServices services;
  final String initialLocation;

  @override
  State<VietGigApp> createState() => _VietGigAppState();
}

class _VietGigAppState extends State<VietGigApp> {
  late final SessionController session;
  late final SettingsController settings;
  late final SavedController saved;
  late final OrdersController orders;
  late final InboxController inbox;
  late final NotificationsController notifications;
  late final GoRouter router;
  String? _loadedFor;

  @override
  void initState() {
    super.initState();
    final s = widget.services;
    session = SessionController(s.auth);
    settings = SettingsController();
    saved = SavedController(s.account);
    orders = OrdersController(s.orders);
    inbox = InboxController(s.chat);
    notifications = NotificationsController(s.account);
    router = buildRouter(session, initialLocation: widget.initialLocation);
    session.addListener(_onSession);
    session.restore();
  }

  /// Khi đăng nhập xong thì tải dữ liệu người dùng.
  void _onSession() {
    final id = session.user?.id;
    if (session.isSignedIn && id != null && _loadedFor != id) {
      _loadedFor = id;
      saved.load(id);
      orders.load(id);
      inbox.load(id);
      notifications.load(id);
    }
    if (!session.isSignedIn) _loadedFor = null;
  }

  @override
  void dispose() {
    session.removeListener(_onSession);
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.services;
    return MultiProvider(
      providers: [
        Provider<AppServices>.value(value: s),
        Provider<AuthRepository>.value(value: s.auth),
        Provider<CatalogRepository>.value(value: s.catalog),
        Provider<OrderRepository>.value(value: s.orders),
        Provider<ChatRepository>.value(value: s.chat),
        Provider<AccountRepository>.value(value: s.account),
        ChangeNotifierProvider.value(value: session),
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider.value(value: saved),
        ChangeNotifierProvider.value(value: orders),
        ChangeNotifierProvider.value(value: inbox),
        ChangeNotifierProvider.value(value: notifications),
      ],
      child: Consumer<SettingsController>(
        builder: (context, st, _) => MaterialApp.router(
          title: 'VietGig',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: st.themeMode,
          routerConfig: router,
          locale: st.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) {
            // Cho các hàm định dạng (Fmt) dùng đúng ngôn ngữ hiện tại.
            Fmt.use(AppLocalizations.of(context));
            return child!;
          },
        ),
      ),
    );
  }
}
