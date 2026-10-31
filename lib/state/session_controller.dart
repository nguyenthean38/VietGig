import 'package:flutter/foundation.dart';

import '../data/models/account.dart';
import '../data/models/user.dart';
import '../data/repositories/repositories.dart';

enum SessionStatus { unknown, signedOut, signedIn }

/// Quản lý phiên đăng nhập và chế độ Người mua / Người bán.
class SessionController extends ChangeNotifier {
  SessionController(this._auth);
  final AuthRepository _auth;

  SessionStatus _status = SessionStatus.unknown;
  AppUser? _user;
  bool _sellerMode = false;
  bool _needsOnboarding = false;
  bool _guest = false;

  SessionStatus get status => _status;
  AppUser? get user => _user;
  bool get isSignedIn => _status == SessionStatus.signedIn;

  /// Đang xem app ở chế độ khách (chưa đăng nhập, bấm "Bỏ qua").
  bool get isGuest => _guest;
  bool get sellerMode => _sellerMode;
  bool get needsOnboarding => _needsOnboarding;
  String get userId => _user?.id ?? '';

  Future<void> restore() async {
    _user = await _auth.restoreSession();
    _status = _user == null ? SessionStatus.signedOut : SessionStatus.signedIn;
    notifyListeners();
  }

  Future<void> signIn(String emailOrUsername, String password) async {
    _user = await _auth.signIn(emailOrUsername: emailOrUsername, password: password);
    _afterSignIn(onboarding: false);
  }

  Future<void> signUp(String username, String email, String password) async {
    _user = await _auth.signUp(username: username, email: email, password: password);
    _afterSignIn(onboarding: true);
  }

  Future<void> signInWithProvider(String provider) async {
    _user = await _auth.signInWithProvider(provider);
    _afterSignIn(onboarding: false);
  }

  void _afterSignIn({required bool onboarding}) {
    _status = SessionStatus.signedIn;
    _guest = false;
    _needsOnboarding = onboarding;
    notifyListeners();
  }

  /// Vào app không cần tài khoản.
  void continueAsGuest() {
    _guest = true;
    notifyListeners();
  }

  Future<void> completeOnboarding(OnboardingAnswers answers) async {
    await _auth.saveOnboarding(answers);
    _needsOnboarding = false;
    notifyListeners();
  }

  void skipOnboarding() {
    _needsOnboarding = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _sellerMode = false;
    _guest = false;
    _status = SessionStatus.signedOut;
    notifyListeners();
  }

  Future<void> sendPasswordReset(String email) => _auth.sendPasswordReset(email);
  Future<void> resendVerification() => _auth.resendVerification();

  Future<void> verifyEmail() async {
    _user = await _auth.verifyEmail();
    notifyListeners();
  }

  Future<void> updateEmail(String email) async {
    _user = await _auth.updateEmail(email);
    notifyListeners();
  }

  Future<void> updateProfile(AppUser user) async {
    _user = await _auth.updateProfile(user);
    notifyListeners();
  }

  Future<void> setSellerMode(bool value) async {
    if (value && !(_user?.isSeller ?? false)) {
      _user = await _auth.becomeSeller();
    }
    _sellerMode = value;
    notifyListeners();
  }

  Future<void> deleteAccount(String reason) async {
    await _auth.deleteAccount(reason: reason);
    _user = null;
    _sellerMode = false;
    _status = SessionStatus.signedOut;
    notifyListeners();
  }

  Future<void> deactivateAccount() async {
    await _auth.deactivateAccount();
    _user = null;
    _sellerMode = false;
    _status = SessionStatus.signedOut;
    notifyListeners();
  }
}
