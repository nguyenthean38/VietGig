import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @authPwRuleLength.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất 8 ký tự'**
  String get authPwRuleLength;

  /// No description provided for @authPwRuleUpper.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất 1 chữ in hoa'**
  String get authPwRuleUpper;

  /// No description provided for @authPwRuleLower.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất 1 chữ thường'**
  String get authPwRuleLower;

  /// No description provided for @authPwRuleDigit.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất 1 chữ số'**
  String get authPwRuleDigit;

  /// No description provided for @authContinueWithApple.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Apple'**
  String get authContinueWithApple;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithFacebook.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Facebook'**
  String get authContinueWithFacebook;

  /// No description provided for @authTermsPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Bằng việc tham gia, bạn đồng ý với '**
  String get authTermsPrefix;

  /// No description provided for @authTermsLink.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản dịch vụ'**
  String get authTermsLink;

  /// No description provided for @authTermsSuffix.
  ///
  /// In vi, this message translates to:
  /// **' của VietGig.'**
  String get authTermsSuffix;

  /// No description provided for @authTermsBody.
  ///
  /// In vi, this message translates to:
  /// **'1. Bạn chịu trách nhiệm về thông tin tài khoản và bảo mật mật khẩu.\n\n2. Mọi giao dịch phải được thực hiện qua VietGig để được bảo vệ thanh toán.\n\n3. Nghiêm cấm đăng tải nội dung vi phạm pháp luật Việt Nam hoặc quyền sở hữu trí tuệ.\n\n4. VietGig có quyền tạm khoá tài khoản vi phạm chính sách cộng đồng.\n\n5. Dữ liệu cá nhân được xử lý theo Chính sách quyền riêng tư.'**
  String get authTermsBody;

  /// No description provided for @authSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get authSkip;

  /// No description provided for @authContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get authContinue;

  /// No description provided for @authFinish.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất'**
  String get authFinish;

  /// No description provided for @authClear.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get authClear;

  /// No description provided for @authShowPassword.
  ///
  /// In vi, this message translates to:
  /// **'Hiện mật khẩu'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn mật khẩu'**
  String get authHidePassword;

  /// No description provided for @authPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get authPasswordHint;

  /// No description provided for @authEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get authEmailHint;

  /// No description provided for @authResendEmail.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại email'**
  String get authResendEmail;

  /// No description provided for @authWelcomeHeadline.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ freelance.\nTheo yêu cầu.'**
  String get authWelcomeHeadline;

  /// No description provided for @authWelcomeBuyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm dịch vụ'**
  String get authWelcomeBuyTitle;

  /// No description provided for @authWelcomeBuySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đang tìm freelancer tài năng để hợp tác'**
  String get authWelcomeBuySubtitle;

  /// No description provided for @authWelcomeSellTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bán dịch vụ'**
  String get authWelcomeSellTitle;

  /// No description provided for @authWelcomeSellSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tôi muốn cung cấp dịch vụ của mình'**
  String get authWelcomeSellSubtitle;

  /// No description provided for @authSignInTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập vào tài khoản'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bạn quay lại VietGig!'**
  String get authSignInSubtitle;

  /// No description provided for @authIdHint.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc tên người dùng'**
  String get authIdHint;

  /// No description provided for @authIdRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email hoặc tên người dùng'**
  String get authIdRequired;

  /// No description provided for @authPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get authPasswordRequired;

  /// No description provided for @authForgotLink.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get authForgotLink;

  /// No description provided for @authNoAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản? '**
  String get authNoAccount;

  /// No description provided for @authJoinNow.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia ngay'**
  String get authJoinNow;

  /// No description provided for @authDemoAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản dùng thử: {email} / {password}'**
  String authDemoAccount(String email, String password);

  /// No description provided for @authFill.
  ///
  /// In vi, this message translates to:
  /// **'Điền'**
  String get authFill;

  /// No description provided for @authSignUpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia VietGig'**
  String get authSignUpTitle;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Có thể cần xác minh bổ sung ở bước sau.'**
  String get authSignUpSubtitle;

  /// No description provided for @authUsernameHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên người dùng công khai'**
  String get authUsernameHint;

  /// No description provided for @authUsernameInvalid.
  ///
  /// In vi, this message translates to:
  /// **'4–20 ký tự: chữ không dấu, số, \"_\" hoặc \".\"'**
  String get authUsernameInvalid;

  /// No description provided for @authUsernameNote.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể đổi tên người dùng sau này, hãy chọn thật kỹ.'**
  String get authUsernameNote;

  /// No description provided for @authEmailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get authEmailInvalid;

  /// No description provided for @authSignUpSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get authSignUpSubmit;

  /// No description provided for @authHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? '**
  String get authHaveAccount;

  /// No description provided for @authOnbPurposeWork.
  ///
  /// In vi, this message translates to:
  /// **'Công việc hoặc kinh doanh chính'**
  String get authOnbPurposeWork;

  /// No description provided for @authOnbPurposeWorkDesc.
  ///
  /// In vi, this message translates to:
  /// **'Dự án cho công ty bạn đang làm hoặc cho việc kinh doanh của riêng bạn.'**
  String get authOnbPurposeWorkDesc;

  /// No description provided for @authOnbPurposeSide.
  ///
  /// In vi, this message translates to:
  /// **'Dự án phụ hoặc kinh doanh nhỏ'**
  String get authOnbPurposeSide;

  /// No description provided for @authOnbPurposeSideDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bất cứ việc gì bạn làm ngoài công việc chính, như một dự án tay trái.'**
  String get authOnbPurposeSideDesc;

  /// No description provided for @authOnbPurposePersonal.
  ///
  /// In vi, this message translates to:
  /// **'Mục đích cá nhân'**
  String get authOnbPurposePersonal;

  /// No description provided for @authOnbPurposePersonalDesc.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ cho sự phát triển hoặc sở thích riêng, ngoài công việc.'**
  String get authOnbPurposePersonalDesc;

  /// No description provided for @authOnbExpNew.
  ///
  /// In vi, this message translates to:
  /// **'Mới bắt đầu'**
  String get authOnbExpNew;

  /// No description provided for @authOnbExpOnline.
  ///
  /// In vi, this message translates to:
  /// **'Freelance online'**
  String get authOnbExpOnline;

  /// No description provided for @authOnbExpOffline.
  ///
  /// In vi, this message translates to:
  /// **'Freelance offline'**
  String get authOnbExpOffline;

  /// No description provided for @authOnbExpBoth.
  ///
  /// In vi, this message translates to:
  /// **'Cả online và offline'**
  String get authOnbExpBoth;

  /// No description provided for @authOnbSaveError.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được lựa chọn, vui lòng thử lại.'**
  String get authOnbSaveError;

  /// No description provided for @authOnbPurposeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn dùng VietGig để làm gì?'**
  String get authOnbPurposeTitle;

  /// No description provided for @authOnbPurposeSub.
  ///
  /// In vi, this message translates to:
  /// **'Có thể chọn nhiều mục.'**
  String get authOnbPurposeSub;

  /// No description provided for @authOnbInterestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn dịch vụ phù hợp với nhu cầu của bạn'**
  String get authOnbInterestTitle;

  /// No description provided for @authOnbInterestSub.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ít nhất một mục.'**
  String get authOnbInterestSub;

  /// No description provided for @authOnbOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get authOnbOther;

  /// No description provided for @authOnbLookingForTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang tìm dịch vụ gì?'**
  String get authOnbLookingForTitle;

  /// No description provided for @authOnbLookingForHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Thiết kế menu nhà hàng'**
  String get authOnbLookingForHint;

  /// No description provided for @authOnbExpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kinh nghiệm freelance của bạn?'**
  String get authOnbExpTitle;

  /// No description provided for @authOnbExpSub.
  ///
  /// In vi, this message translates to:
  /// **'Dù bạn theo phong cách nào, chúng tôi đều hỗ trợ.'**
  String get authOnbExpSub;

  /// No description provided for @authVerifyResent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lại email xác nhận'**
  String get authVerifyResent;

  /// No description provided for @authVerifySendFailed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi email thất bại, vui lòng thử lại.'**
  String get authVerifySendFailed;

  /// No description provided for @authVerifyActivated.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã được kích hoạt!'**
  String get authVerifyActivated;

  /// No description provided for @authVerifyNotYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa xác nhận được, vui lòng thử lại.'**
  String get authVerifyNotYet;

  /// No description provided for @authVerifyDoneTitle.
  ///
  /// In vi, this message translates to:
  /// **'Email của bạn đã được xác nhận'**
  String get authVerifyDoneTitle;

  /// No description provided for @authVerifyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận email để tiếp tục'**
  String get authVerifyTitle;

  /// No description provided for @authVerifySentTo.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi email tới:'**
  String get authVerifySentTo;

  /// No description provided for @authVerifyBody.
  ///
  /// In vi, this message translates to:
  /// **'Bấm vào liên kết trong email để xác minh địa chỉ và kích hoạt tài khoản của bạn.'**
  String get authVerifyBody;

  /// No description provided for @authVerifyWrongEmail.
  ///
  /// In vi, this message translates to:
  /// **'Không phải email bạn muốn dùng?'**
  String get authVerifyWrongEmail;

  /// No description provided for @authVerifyChangeEmail.
  ///
  /// In vi, this message translates to:
  /// **'Đổi địa chỉ email'**
  String get authVerifyChangeEmail;

  /// No description provided for @authVerifyDemoNote.
  ///
  /// In vi, this message translates to:
  /// **'Bản demo: bấm \"Tôi đã xác nhận\" để mô phỏng việc mở liên kết.'**
  String get authVerifyDemoNote;

  /// No description provided for @authVerifyConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã xác nhận'**
  String get authVerifyConfirm;

  /// No description provided for @authResendIn.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại email sau {seconds}s'**
  String authResendIn(int seconds);

  /// No description provided for @authForgotInvalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email hợp lệ'**
  String get authForgotInvalidEmail;

  /// No description provided for @authForgotSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi liên kết đặt lại mật khẩu'**
  String get authForgotSent;

  /// No description provided for @authForgotTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get authForgotTitle;

  /// No description provided for @authForgotHeading.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get authForgotHeading;

  /// No description provided for @authForgotBody.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email bạn đã dùng để đăng ký, chúng tôi sẽ gửi liên kết đặt lại mật khẩu.'**
  String get authForgotBody;

  /// No description provided for @authForgotSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Gửi liên kết'**
  String get authForgotSubmit;

  /// No description provided for @authForgotCheckInbox.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra hộp thư của bạn'**
  String get authForgotCheckInbox;

  /// No description provided for @authForgotSentTo.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi liên kết đặt lại mật khẩu tới\n{email}'**
  String authForgotSentTo(String email);

  /// No description provided for @authBackToSignIn.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đăng nhập'**
  String get authBackToSignIn;

  /// No description provided for @commonSeeAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get commonSeeAll;

  /// No description provided for @commonCancel.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get commonCancel;

  /// No description provided for @commonOk.
  ///
  /// In vi, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonAgree.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý'**
  String get commonAgree;

  /// No description provided for @commonUndo.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tác'**
  String get commonUndo;

  /// No description provided for @commonBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get commonBack;

  /// No description provided for @commonClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get commonClose;

  /// No description provided for @commonSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get commonSave;

  /// No description provided for @commonSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu'**
  String get commonSaved;

  /// No description provided for @commonDone.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get commonDone;

  /// No description provided for @commonDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get commonDelete;

  /// No description provided for @commonCreate.
  ///
  /// In vi, this message translates to:
  /// **'Tạo'**
  String get commonCreate;

  /// No description provided for @commonOr.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc'**
  String get commonOr;

  /// No description provided for @commonSignIn.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get commonSignIn;

  /// No description provided for @commonMessage.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin'**
  String get commonMessage;

  /// No description provided for @commonErrorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get commonErrorTitle;

  /// No description provided for @commonRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get commonRetry;

  /// No description provided for @commonFrom.
  ///
  /// In vi, this message translates to:
  /// **'Từ'**
  String get commonFrom;

  /// No description provided for @commonUnderConstruction.
  ///
  /// In vi, this message translates to:
  /// **'Đang xây dựng'**
  String get commonUnderConstruction;

  /// No description provided for @timeDays.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get timeDays;

  /// No description provided for @timeHours.
  ///
  /// In vi, this message translates to:
  /// **'Giờ'**
  String get timeHours;

  /// No description provided for @timeMinutes.
  ///
  /// In vi, this message translates to:
  /// **'Phút'**
  String get timeMinutes;

  /// No description provided for @timeJustNow.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get timeJustNow;

  /// No description provided for @timeYesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get timeYesterday;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In vi, this message translates to:
  /// **'{n} phút trước'**
  String timeMinutesAgo(int n);

  /// No description provided for @timeHoursAgo.
  ///
  /// In vi, this message translates to:
  /// **'{n} giờ trước'**
  String timeHoursAgo(int n);

  /// No description provided for @timeDaysAgo.
  ///
  /// In vi, this message translates to:
  /// **'{n} ngày trước'**
  String timeDaysAgo(int n);

  /// No description provided for @timeMonthsAgo.
  ///
  /// In vi, this message translates to:
  /// **'{n} tháng trước'**
  String timeMonthsAgo(int n);

  /// No description provided for @timeYearsAgo.
  ///
  /// In vi, this message translates to:
  /// **'{n} năm trước'**
  String timeYearsAgo(int n);

  /// No description provided for @timeNDays.
  ///
  /// In vi, this message translates to:
  /// **'{n} ngày'**
  String timeNDays(int n);

  /// No description provided for @weekday1.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Hai'**
  String get weekday1;

  /// No description provided for @weekday2.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Ba'**
  String get weekday2;

  /// No description provided for @weekday3.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Tư'**
  String get weekday3;

  /// No description provided for @weekday4.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Năm'**
  String get weekday4;

  /// No description provided for @weekday5.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Sáu'**
  String get weekday5;

  /// No description provided for @weekday6.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Bảy'**
  String get weekday6;

  /// No description provided for @weekday7.
  ///
  /// In vi, this message translates to:
  /// **'Chủ Nhật'**
  String get weekday7;

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHome;

  /// No description provided for @navInbox.
  ///
  /// In vi, this message translates to:
  /// **'Hộp thư'**
  String get navInbox;

  /// No description provided for @navSearch.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get navSearch;

  /// No description provided for @navOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get navOrders;

  /// No description provided for @navAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get navAccount;

  /// No description provided for @badgeChoice.
  ///
  /// In vi, this message translates to:
  /// **'VIETGIG CHỌN'**
  String get badgeChoice;

  /// No description provided for @orderStatusAwaitingRequirements.
  ///
  /// In vi, this message translates to:
  /// **'CHỜ YÊU CẦU'**
  String get orderStatusAwaitingRequirements;

  /// No description provided for @orderStatusInProgress.
  ///
  /// In vi, this message translates to:
  /// **'ĐANG THỰC HIỆN'**
  String get orderStatusInProgress;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In vi, this message translates to:
  /// **'ĐÃ GIAO'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusRevisionRequested.
  ///
  /// In vi, this message translates to:
  /// **'YÊU CẦU SỬA'**
  String get orderStatusRevisionRequested;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In vi, this message translates to:
  /// **'HOÀN THÀNH'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In vi, this message translates to:
  /// **'ĐÃ HUỶ'**
  String get orderStatusCancelled;

  /// No description provided for @orderStatusDisputed.
  ///
  /// In vi, this message translates to:
  /// **'ĐANG GIẢI QUYẾT'**
  String get orderStatusDisputed;

  /// No description provided for @levelNew.
  ///
  /// In vi, this message translates to:
  /// **'Mới'**
  String get levelNew;

  /// No description provided for @levelOne.
  ///
  /// In vi, this message translates to:
  /// **'Cấp 1'**
  String get levelOne;

  /// No description provided for @levelTwo.
  ///
  /// In vi, this message translates to:
  /// **'Cấp 2'**
  String get levelTwo;

  /// No description provided for @levelTopRated.
  ///
  /// In vi, this message translates to:
  /// **'Top Rated'**
  String get levelTopRated;

  /// No description provided for @sortRelevance.
  ///
  /// In vi, this message translates to:
  /// **'Phù hợp nhất'**
  String get sortRelevance;

  /// No description provided for @sortBestSelling.
  ///
  /// In vi, this message translates to:
  /// **'Bán chạy'**
  String get sortBestSelling;

  /// No description provided for @sortNewest.
  ///
  /// In vi, this message translates to:
  /// **'Mới nhất'**
  String get sortNewest;

  /// No description provided for @sortPriceLow.
  ///
  /// In vi, this message translates to:
  /// **'Giá thấp đến cao'**
  String get sortPriceLow;

  /// No description provided for @sortPriceHigh.
  ///
  /// In vi, this message translates to:
  /// **'Giá cao đến thấp'**
  String get sortPriceHigh;

  /// No description provided for @sortRating.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá cao'**
  String get sortRating;

  /// No description provided for @offerStatusPending.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ'**
  String get offerStatusPending;

  /// No description provided for @offerStatusAccepted.
  ///
  /// In vi, this message translates to:
  /// **'Đã chấp nhận'**
  String get offerStatusAccepted;

  /// No description provided for @offerStatusDeclined.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối'**
  String get offerStatusDeclined;

  /// No description provided for @offerStatusWithdrawn.
  ///
  /// In vi, this message translates to:
  /// **'Đã rút lại'**
  String get offerStatusWithdrawn;

  /// No description provided for @offerStatusExpired.
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn'**
  String get offerStatusExpired;

  /// No description provided for @revisionsUnlimited.
  ///
  /// In vi, this message translates to:
  /// **'Không giới hạn'**
  String get revisionsUnlimited;

  /// No description provided for @saveSignInTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để lưu'**
  String get saveSignInTitle;

  /// No description provided for @saveSignInMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần đăng nhập để lưu dịch vụ vào danh sách yêu thích.'**
  String get saveSignInMessage;

  /// No description provided for @saveSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách đã lưu'**
  String get saveSheetTitle;

  /// No description provided for @saveCreateNewLink.
  ///
  /// In vi, this message translates to:
  /// **'+ Tạo danh sách mới'**
  String get saveCreateNewLink;

  /// No description provided for @saveCreateNewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo danh sách mới'**
  String get saveCreateNewTitle;

  /// No description provided for @saveListNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên danh sách'**
  String get saveListNameHint;

  /// No description provided for @saveListEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách trống'**
  String get saveListEmpty;

  /// No description provided for @saveListCount.
  ///
  /// In vi, this message translates to:
  /// **'{gigs} dịch vụ • {sellers} người bán'**
  String saveListCount(int gigs, int sellers);

  /// No description provided for @notifKeyInbox.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn hộp thư'**
  String get notifKeyInbox;

  /// No description provided for @notifKeyOrderMessages.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn đơn hàng'**
  String get notifKeyOrderMessages;

  /// No description provided for @notifKeyOrderUpdates.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật đơn hàng'**
  String get notifKeyOrderUpdates;

  /// No description provided for @notifKeyRatingReminders.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc đánh giá'**
  String get notifKeyRatingReminders;

  /// No description provided for @notifKeyBuyerBriefs.
  ///
  /// In vi, this message translates to:
  /// **'Brief từ người mua'**
  String get notifKeyBuyerBriefs;

  /// No description provided for @notifKeyMyGigs.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ của tôi'**
  String get notifKeyMyGigs;

  /// No description provided for @notifKeyMyAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của tôi'**
  String get notifKeyMyAccount;

  /// No description provided for @notifKeyPromotions.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo khuyến mãi'**
  String get notifKeyPromotions;

  /// No description provided for @languageVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @authErrorMissingCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email/tên đăng nhập và mật khẩu.'**
  String get authErrorMissingCredentials;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tài khoản này.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không đúng. Vui lòng thử lại.'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorUsernameTaken.
  ///
  /// In vi, this message translates to:
  /// **'Tên người dùng đã tồn tại.'**
  String get authErrorUsernameTaken;

  /// No description provided for @authErrorEmailTaken.
  ///
  /// In vi, this message translates to:
  /// **'Email này đã được đăng ký.'**
  String get authErrorEmailTaken;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorActiveOrders.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể xoá tài khoản khi còn đơn hàng đang thực hiện. Vui lòng liên hệ bộ phận hỗ trợ.'**
  String get authErrorActiveOrders;

  /// No description provided for @authErrorUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra. Vui lòng thử lại.'**
  String get authErrorUnknown;

  /// No description provided for @gigLinkCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép liên kết'**
  String get gigLinkCopied;

  /// No description provided for @gigSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm dịch vụ'**
  String get gigSearchHint;

  /// No description provided for @gigCriteriaCommunication.
  ///
  /// In vi, this message translates to:
  /// **'Mức độ giao tiếp'**
  String get gigCriteriaCommunication;

  /// No description provided for @gigCriteriaQuality.
  ///
  /// In vi, this message translates to:
  /// **'Chất lượng sản phẩm'**
  String get gigCriteriaQuality;

  /// No description provided for @gigCriteriaValue.
  ///
  /// In vi, this message translates to:
  /// **'Đáng giá tiền'**
  String get gigCriteriaValue;

  /// No description provided for @gigRatingOverall.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá tổng quan'**
  String get gigRatingOverall;

  /// No description provided for @gigReviewCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} đánh giá'**
  String gigReviewCount(String count);

  /// No description provided for @gigReviewSortPositive.
  ///
  /// In vi, this message translates to:
  /// **'Tích cực nhất'**
  String get gigReviewSortPositive;

  /// No description provided for @gigReviewSortNegative.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu cực nhất'**
  String get gigReviewSortNegative;

  /// No description provided for @gigSortBy.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp theo'**
  String get gigSortBy;

  /// No description provided for @gigSortTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp'**
  String get gigSortTooltip;

  /// No description provided for @gigReviewPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá'**
  String get gigReviewPrice;

  /// No description provided for @gigReviewDuration.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get gigReviewDuration;

  /// No description provided for @gigSellerResponse.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi của người bán'**
  String get gigSellerResponse;

  /// No description provided for @gigResponseHide.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn'**
  String get gigResponseHide;

  /// No description provided for @gigResponseRead.
  ///
  /// In vi, this message translates to:
  /// **'Đọc'**
  String get gigResponseRead;

  /// No description provided for @gigNewSeller.
  ///
  /// In vi, this message translates to:
  /// **'Người bán mới'**
  String get gigNewSeller;

  /// No description provided for @gigShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get gigShare;

  /// No description provided for @gigReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo dịch vụ'**
  String get gigReport;

  /// No description provided for @gigReportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vì sao bạn báo cáo dịch vụ này?'**
  String get gigReportTitle;

  /// No description provided for @gigReportCopyright.
  ///
  /// In vi, this message translates to:
  /// **'Vi phạm bản quyền'**
  String get gigReportCopyright;

  /// No description provided for @gigReportContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung không phù hợp'**
  String get gigReportContent;

  /// No description provided for @gigReportSpam.
  ///
  /// In vi, this message translates to:
  /// **'Lừa đảo / spam'**
  String get gigReportSpam;

  /// No description provided for @gigReportOther.
  ///
  /// In vi, this message translates to:
  /// **'Lý do khác'**
  String get gigReportOther;

  /// No description provided for @gigReportThanks.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn! Chúng tôi sẽ xem xét báo cáo trong 24 giờ.'**
  String get gigReportThanks;

  /// No description provided for @gigNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ không tồn tại'**
  String get gigNotFoundTitle;

  /// No description provided for @gigNotFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ này có thể đã bị gỡ hoặc tạm ẩn.'**
  String get gigNotFoundMessage;

  /// No description provided for @gigNotFoundAction.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá dịch vụ khác'**
  String get gigNotFoundAction;

  /// No description provided for @gigMore.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get gigMore;

  /// No description provided for @gigFaqTitle.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp'**
  String get gigFaqTitle;

  /// No description provided for @gigPortfolio.
  ///
  /// In vi, this message translates to:
  /// **'Portfolio'**
  String get gigPortfolio;

  /// No description provided for @gigMoreFromSeller.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ khác của {name}'**
  String gigMoreFromSeller(String name);

  /// No description provided for @gigSellerFallback.
  ///
  /// In vi, this message translates to:
  /// **'người bán'**
  String get gigSellerFallback;

  /// No description provided for @gigRecentlyViewed.
  ///
  /// In vi, this message translates to:
  /// **'Đã xem gần đây'**
  String get gigRecentlyViewed;

  /// No description provided for @gigShowLess.
  ///
  /// In vi, this message translates to:
  /// **'Thu gọn'**
  String get gigShowLess;

  /// No description provided for @gigShowMore.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm'**
  String get gigShowMore;

  /// No description provided for @gigShowMoreSkills.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm {n} kỹ năng'**
  String gigShowMoreSkills(int n);

  /// No description provided for @gigDeliveryTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian giao'**
  String get gigDeliveryTime;

  /// No description provided for @gigRevisions.
  ///
  /// In vi, this message translates to:
  /// **'Số lần sửa'**
  String get gigRevisions;

  /// No description provided for @gigContinueWithPrice.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục ({price})'**
  String gigContinueWithPrice(String price);

  /// No description provided for @gigComparePackages.
  ///
  /// In vi, this message translates to:
  /// **'So sánh gói'**
  String get gigComparePackages;

  /// No description provided for @gigPackage.
  ///
  /// In vi, this message translates to:
  /// **'Gói'**
  String get gigPackage;

  /// No description provided for @gigSelectPackage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn {tier}'**
  String gigSelectPackage(String tier);

  /// No description provided for @gigAboutSeller.
  ///
  /// In vi, this message translates to:
  /// **'Về người bán'**
  String get gigAboutSeller;

  /// No description provided for @gigFrom.
  ///
  /// In vi, this message translates to:
  /// **'Đến từ'**
  String get gigFrom;

  /// No description provided for @gigMemberSince.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên từ'**
  String get gigMemberSince;

  /// No description provided for @gigMemberSinceValue.
  ///
  /// In vi, this message translates to:
  /// **'Th{month}/{year}'**
  String gigMemberSinceValue(String month, String year);

  /// No description provided for @gigMemberSinceLong.
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}/{year}'**
  String gigMemberSinceLong(String month, String year);

  /// No description provided for @gigAvgResponse.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi TB'**
  String get gigAvgResponse;

  /// No description provided for @gigAvgResponseLong.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian phản hồi TB'**
  String get gigAvgResponseLong;

  /// No description provided for @gigHours.
  ///
  /// In vi, this message translates to:
  /// **'{n} giờ'**
  String gigHours(int n);

  /// No description provided for @gigLanguages.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get gigLanguages;

  /// No description provided for @gigContact.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ'**
  String get gigContact;

  /// No description provided for @gigNoReviews.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đánh giá nào.'**
  String get gigNoReviews;

  /// No description provided for @gigSeeAllReviews.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả {count} đánh giá'**
  String gigSeeAllReviews(String count);

  /// No description provided for @gigSeeAllReviewsPlain.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả đánh giá'**
  String get gigSeeAllReviewsPlain;

  /// No description provided for @gigTabAbout.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get gigTabAbout;

  /// No description provided for @gigTabGigs.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ'**
  String get gigTabGigs;

  /// No description provided for @gigTabReviews.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá'**
  String get gigTabReviews;

  /// No description provided for @gigTabClients.
  ///
  /// In vi, this message translates to:
  /// **'Khách hàng'**
  String get gigTabClients;

  /// No description provided for @gigUserNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy người dùng'**
  String get gigUserNotFoundTitle;

  /// No description provided for @gigUserNotFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản này không tồn tại hoặc đã bị vô hiệu hoá.'**
  String get gigUserNotFoundMessage;

  /// No description provided for @gigVettedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Được VietGig Pro thẩm định'**
  String get gigVettedTitle;

  /// No description provided for @gigVettedMessage.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã được đội ngũ VietGig Pro lựa chọn nhờ chuyên môn đã được kiểm chứng.'**
  String gigVettedMessage(String name);

  /// No description provided for @gigVettedFor.
  ///
  /// In vi, this message translates to:
  /// **'Được thẩm định cho'**
  String get gigVettedFor;

  /// No description provided for @gigOffersHourly.
  ///
  /// In vi, this message translates to:
  /// **'Nhận việc theo giờ'**
  String get gigOffersHourly;

  /// No description provided for @gigInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin'**
  String get gigInfo;

  /// No description provided for @gigFromWithLocalTime.
  ///
  /// In vi, this message translates to:
  /// **'{place} ({time} giờ địa phương)'**
  String gigFromWithLocalTime(String place, String time);

  /// No description provided for @gigSkills.
  ///
  /// In vi, this message translates to:
  /// **'Kỹ năng'**
  String get gigSkills;

  /// No description provided for @gigCertEducation.
  ///
  /// In vi, this message translates to:
  /// **'Chứng chỉ & Học vấn'**
  String get gigCertEducation;

  /// No description provided for @gigCertificates.
  ///
  /// In vi, this message translates to:
  /// **'Chứng chỉ'**
  String get gigCertificates;

  /// No description provided for @gigEducation.
  ///
  /// In vi, this message translates to:
  /// **'Học vấn'**
  String get gigEducation;

  /// No description provided for @gigNoGigsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dịch vụ'**
  String get gigNoGigsTitle;

  /// No description provided for @gigNoGigsMessage.
  ///
  /// In vi, this message translates to:
  /// **'{name} chưa đăng dịch vụ nào.'**
  String gigNoGigsMessage(String name);

  /// No description provided for @gigNoReviewsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đánh giá'**
  String get gigNoReviewsTitle;

  /// No description provided for @gigNoReviewsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hãy là người đầu tiên làm việc và đánh giá người bán này.'**
  String get gigNoReviewsMessage;

  /// No description provided for @gigNoPortfolio.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có portfolio'**
  String get gigNoPortfolio;

  /// No description provided for @gigPortfolioIntro.
  ///
  /// In vi, this message translates to:
  /// **'Một số dự án {name} đã thực hiện, giúp bạn hiểu rõ hơn về chuyên môn.'**
  String gigPortfolioIntro(String name);

  /// No description provided for @gigNoClients.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có khách hàng doanh nghiệp'**
  String get gigNoClients;

  /// No description provided for @gigClientProject.
  ///
  /// In vi, this message translates to:
  /// **'Dự án với {company}'**
  String gigClientProject(String company);

  /// No description provided for @gigClientIndustry.
  ///
  /// In vi, this message translates to:
  /// **'Ngành: {industry}'**
  String gigClientIndustry(String industry);

  /// No description provided for @gigFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get gigFilterAll;

  /// No description provided for @gigFilterFive.
  ///
  /// In vi, this message translates to:
  /// **'5 sao'**
  String get gigFilterFive;

  /// No description provided for @gigFilterFour.
  ///
  /// In vi, this message translates to:
  /// **'4 sao'**
  String get gigFilterFour;

  /// No description provided for @gigFilterLow.
  ///
  /// In vi, this message translates to:
  /// **'3 sao trở xuống'**
  String get gigFilterLow;

  /// No description provided for @gigFilterResponded.
  ///
  /// In vi, this message translates to:
  /// **'Có phản hồi'**
  String get gigFilterResponded;

  /// No description provided for @gigSellerNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy người bán'**
  String get gigSellerNotFound;

  /// No description provided for @gigReviewsShown.
  ///
  /// In vi, this message translates to:
  /// **'{n} đánh giá hiển thị'**
  String gigReviewsShown(int n);

  /// No description provided for @gigNoMatchingReviews.
  ///
  /// In vi, this message translates to:
  /// **'Không có đánh giá phù hợp'**
  String get gigNoMatchingReviews;

  /// No description provided for @gigPortfolioOf.
  ///
  /// In vi, this message translates to:
  /// **'Portfolio của {name}'**
  String gigPortfolioOf(String name);

  /// No description provided for @gigNoProjectsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dự án nào'**
  String get gigNoProjectsTitle;

  /// No description provided for @gigNoProjectsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Người bán chưa thêm dự án vào portfolio.'**
  String get gigNoProjectsMessage;

  /// No description provided for @gigPortfolioScreenIntro.
  ///
  /// In vi, this message translates to:
  /// **'Một số dự án {name} đã thực hiện để bạn hiểu rõ hơn về chuyên môn.'**
  String gigPortfolioScreenIntro(String name);

  /// No description provided for @gigProjectNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy dự án'**
  String get gigProjectNotFoundTitle;

  /// No description provided for @gigProjectNotFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Dự án này có thể đã bị xoá khỏi portfolio.'**
  String get gigProjectNotFoundMessage;

  /// No description provided for @gigBy.
  ///
  /// In vi, this message translates to:
  /// **'Bởi {name}'**
  String gigBy(String name);

  /// No description provided for @gigProjectDefaultDescription.
  ///
  /// In vi, this message translates to:
  /// **'Dự án do {name} thực hiện cho khách hàng trên VietGig.'**
  String gigProjectDefaultDescription(String name);

  /// No description provided for @homeCategoriesTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get homeCategoriesTooltip;

  /// No description provided for @homeVerifyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng xác nhận email'**
  String get homeVerifyTitle;

  /// No description provided for @homeVerifyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi email xác nhận tới {email}. Hãy kiểm tra hộp thư và kích hoạt tài khoản.'**
  String homeVerifyMessage(String email);

  /// No description provided for @homeVerifyYourAddress.
  ///
  /// In vi, this message translates to:
  /// **'địa chỉ của bạn'**
  String get homeVerifyYourAddress;

  /// No description provided for @homeVerifyAction.
  ///
  /// In vi, this message translates to:
  /// **'Kích hoạt email →'**
  String get homeVerifyAction;

  /// No description provided for @homeGuestMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để lưu dịch vụ, nhắn tin và đặt hàng.'**
  String get homeGuestMessage;

  /// No description provided for @homePopularServices.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ phổ biến'**
  String get homePopularServices;

  /// No description provided for @homeCategoriesError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh mục'**
  String get homeCategoriesError;

  /// No description provided for @homeCustomOffers.
  ///
  /// In vi, this message translates to:
  /// **'Báo giá riêng dành cho bạn'**
  String get homeCustomOffers;

  /// No description provided for @homeActiveOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đang thực hiện'**
  String get homeActiveOrders;

  /// No description provided for @homeOrderDue.
  ///
  /// In vi, this message translates to:
  /// **'Hạn giao: {date}'**
  String homeOrderDue(String date);

  /// No description provided for @homeInterestsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn quan tâm gì?'**
  String get homeInterestsTitle;

  /// No description provided for @homeInterestAdd.
  ///
  /// In vi, this message translates to:
  /// **'+ Thêm'**
  String get homeInterestAdd;

  /// No description provided for @homeInterestAdded.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm vào sở thích'**
  String get homeInterestAdded;

  /// No description provided for @homeInterestRemoved.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ khỏi sở thích'**
  String get homeInterestRemoved;

  /// No description provided for @homeRecentlyViewed.
  ///
  /// In vi, this message translates to:
  /// **'Đã xem gần đây'**
  String get homeRecentlyViewed;

  /// No description provided for @homeMostLoved.
  ///
  /// In vi, this message translates to:
  /// **'Được yêu thích nhất'**
  String get homeMostLoved;

  /// No description provided for @homeInviteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ & nhận tới 2.500.000 ₫'**
  String get homeInviteTitle;

  /// No description provided for @homeInviteMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tặng bạn bè giảm 10% cho đơn đầu tiên và nhận tới 2.500.000 ₫ khi họ đặt hàng trên VietGig.'**
  String get homeInviteMessage;

  /// No description provided for @homeInviteAction.
  ///
  /// In vi, this message translates to:
  /// **'Mời bạn bè →'**
  String get homeInviteAction;

  /// No description provided for @homeOfferSummary.
  ///
  /// In vi, this message translates to:
  /// **'{price} • {days} giao hàng'**
  String homeOfferSummary(String price, String days);

  /// No description provided for @homeOfferExpires.
  ///
  /// In vi, this message translates to:
  /// **'Báo giá hết hạn lúc {time}'**
  String homeOfferExpires(String time);

  /// No description provided for @homeOfferOpenChat.
  ///
  /// In vi, this message translates to:
  /// **'Mở chat'**
  String get homeOfferOpenChat;

  /// No description provided for @homeOfferView.
  ///
  /// In vi, this message translates to:
  /// **'Xem'**
  String get homeOfferView;

  /// No description provided for @inboxEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get inboxEdit;

  /// No description provided for @inboxFilterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bộ lọc'**
  String get inboxFilterTitle;

  /// No description provided for @inboxSelectTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn cuộc trò chuyện'**
  String get inboxSelectTitle;

  /// No description provided for @inboxSelectedCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} đã chọn'**
  String inboxSelectedCount(int n);

  /// No description provided for @inboxEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tin nhắn nào'**
  String get inboxEmptyTitle;

  /// No description provided for @inboxEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tin nhắn đầu tiên cho người bán để trao đổi về dự án của bạn. Mọi cuộc trò chuyện sẽ xuất hiện tại đây.'**
  String get inboxEmptyMessage;

  /// No description provided for @inboxFilterEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thử điều chỉnh bộ lọc'**
  String get inboxFilterEmptyTitle;

  /// No description provided for @inboxFilterEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết quả cho {filter}.'**
  String inboxFilterEmptyMessage(String filter);

  /// No description provided for @inboxClearFilter.
  ///
  /// In vi, this message translates to:
  /// **'Xoá bộ lọc'**
  String get inboxClearFilter;

  /// No description provided for @inboxArchive.
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ'**
  String get inboxArchive;

  /// No description provided for @inboxUnarchive.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ lưu trữ'**
  String get inboxUnarchive;

  /// No description provided for @inboxStar.
  ///
  /// In vi, this message translates to:
  /// **'Gắn sao'**
  String get inboxStar;

  /// No description provided for @inboxUnstar.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ gắn sao'**
  String get inboxUnstar;

  /// No description provided for @inboxUnstarShort.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ sao'**
  String get inboxUnstarShort;

  /// No description provided for @inboxMore.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get inboxMore;

  /// No description provided for @inboxChangeLabels.
  ///
  /// In vi, this message translates to:
  /// **'Đổi nhãn'**
  String get inboxChangeLabels;

  /// No description provided for @inboxBlock.
  ///
  /// In vi, this message translates to:
  /// **'Chặn'**
  String get inboxBlock;

  /// No description provided for @inboxUnblock.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ chặn'**
  String get inboxUnblock;

  /// No description provided for @inboxReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get inboxReport;

  /// No description provided for @inboxMarkRead.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu đã đọc'**
  String get inboxMarkRead;

  /// No description provided for @inboxMarkUnread.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu chưa đọc'**
  String get inboxMarkUnread;

  /// No description provided for @inboxMarkedRead.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu đã đọc'**
  String get inboxMarkedRead;

  /// No description provided for @inboxMarkedUnread.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu chưa đọc'**
  String get inboxMarkedUnread;

  /// No description provided for @inboxConversationCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} cuộc trò chuyện'**
  String inboxConversationCount(int n);

  /// No description provided for @inboxBulkArchived.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu trữ {n} cuộc trò chuyện'**
  String inboxBulkArchived(int n);

  /// No description provided for @inboxBulkUnarchived.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển {n} cuộc trò chuyện về Hộp thư'**
  String inboxBulkUnarchived(int n);

  /// No description provided for @inboxBulkStarred.
  ///
  /// In vi, this message translates to:
  /// **'Đã gắn sao {n} cuộc trò chuyện'**
  String inboxBulkStarred(int n);

  /// No description provided for @inboxUnstarred.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ gắn sao'**
  String get inboxUnstarred;

  /// No description provided for @inboxLabelsUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật nhãn'**
  String get inboxLabelsUpdated;

  /// No description provided for @inboxBlockManyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chặn {n} người dùng?'**
  String inboxBlockManyTitle(int n);

  /// No description provided for @inboxBlockManyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ không nhận được tin nhắn từ những người này nữa.'**
  String get inboxBlockManyMessage;

  /// No description provided for @inboxUserBlocked.
  ///
  /// In vi, this message translates to:
  /// **'Đã chặn người dùng'**
  String get inboxUserBlocked;

  /// No description provided for @inboxUserUnblocked.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ chặn người dùng'**
  String get inboxUserUnblocked;

  /// No description provided for @inboxDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá cuộc trò chuyện?'**
  String get inboxDeleteTitle;

  /// No description provided for @inboxDeleteManyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Xoá {n} cuộc trò chuyện đã chọn? Thao tác này không thể hoàn tác.'**
  String inboxDeleteManyMessage(int n);

  /// No description provided for @inboxBulkDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá {n} cuộc trò chuyện'**
  String inboxBulkDeleted(int n);

  /// No description provided for @inboxUnknownUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng VietGig'**
  String get inboxUnknownUser;

  /// No description provided for @inboxUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get inboxUser;

  /// No description provided for @inboxStartConversation.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu cuộc trò chuyện'**
  String get inboxStartConversation;

  /// No description provided for @inboxFilterInbox.
  ///
  /// In vi, this message translates to:
  /// **'Hộp thư'**
  String get inboxFilterInbox;

  /// No description provided for @inboxFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get inboxFilterAll;

  /// No description provided for @inboxFilterUnread.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đọc'**
  String get inboxFilterUnread;

  /// No description provided for @inboxFilterStarred.
  ///
  /// In vi, this message translates to:
  /// **'Gắn sao'**
  String get inboxFilterStarred;

  /// No description provided for @inboxFilterArchived.
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ'**
  String get inboxFilterArchived;

  /// No description provided for @inboxFilterSpam.
  ///
  /// In vi, this message translates to:
  /// **'Spam'**
  String get inboxFilterSpam;

  /// No description provided for @inboxFilterOffers.
  ///
  /// In vi, this message translates to:
  /// **'Báo giá riêng'**
  String get inboxFilterOffers;

  /// No description provided for @inboxLabelsHeader.
  ///
  /// In vi, this message translates to:
  /// **'Nhãn'**
  String get inboxLabelsHeader;

  /// No description provided for @inboxLabelPickerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn nhãn'**
  String get inboxLabelPickerTitle;

  /// No description provided for @inboxApply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get inboxApply;

  /// No description provided for @inboxNewLabelHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên nhãn mới'**
  String get inboxNewLabelHint;

  /// No description provided for @inboxAddLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thêm nhãn mới'**
  String get inboxAddLabel;

  /// No description provided for @inboxArchivedOne.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu trữ cuộc trò chuyện'**
  String get inboxArchivedOne;

  /// No description provided for @inboxUnarchivedOne.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển cuộc trò chuyện về Hộp thư'**
  String get inboxUnarchivedOne;

  /// No description provided for @inboxStarredOne.
  ///
  /// In vi, this message translates to:
  /// **'Đã gắn sao cuộc trò chuyện'**
  String get inboxStarredOne;

  /// No description provided for @inboxBlockTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chặn người dùng này?'**
  String get inboxBlockTitle;

  /// No description provided for @inboxBlockMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ không nhận được tin nhắn từ người này nữa. Bạn có thể bỏ chặn trong mục Spam.'**
  String get inboxBlockMessage;

  /// No description provided for @inboxDeleteMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xoá cuộc trò chuyện này? Thao tác này không thể hoàn tác.'**
  String get inboxDeleteMessage;

  /// No description provided for @inboxDeletedOne.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá cuộc trò chuyện'**
  String get inboxDeletedOne;

  /// No description provided for @inboxReportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo người dùng'**
  String get inboxReportTitle;

  /// No description provided for @inboxReportFraud.
  ///
  /// In vi, this message translates to:
  /// **'Lừa đảo hoặc gian lận'**
  String get inboxReportFraud;

  /// No description provided for @inboxReportOffsite.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu thanh toán ngoài VietGig'**
  String get inboxReportOffsite;

  /// No description provided for @inboxReportAbuse.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn từ xúc phạm'**
  String get inboxReportAbuse;

  /// No description provided for @inboxReportSpam.
  ///
  /// In vi, this message translates to:
  /// **'Spam'**
  String get inboxReportSpam;

  /// No description provided for @inboxReportThanks.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn! Chúng tôi sẽ xem xét báo cáo trong 24 giờ.'**
  String get inboxReportThanks;

  /// No description provided for @inboxAutoReply.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn! Mình sẽ phản hồi chi tiết sớm nhé.'**
  String get inboxAutoReply;

  /// No description provided for @inboxSendFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không gửi được tin nhắn. Vui lòng thử lại.'**
  String get inboxSendFailed;

  /// No description provided for @inboxYou.
  ///
  /// In vi, this message translates to:
  /// **'Bạn'**
  String get inboxYou;

  /// No description provided for @inboxPlainFile.
  ///
  /// In vi, this message translates to:
  /// **'Tệp: {name}'**
  String inboxPlainFile(String name);

  /// No description provided for @inboxPlainOffer.
  ///
  /// In vi, this message translates to:
  /// **'Báo giá: {title} – {price}'**
  String inboxPlainOffer(String title, String price);

  /// No description provided for @inboxVideoInvite.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời gọi video'**
  String get inboxVideoInvite;

  /// No description provided for @inboxVideoInviteText.
  ///
  /// In vi, this message translates to:
  /// **'Mình mời bạn tham gia cuộc gọi video nhé'**
  String get inboxVideoInviteText;

  /// No description provided for @inboxAttachAlbum.
  ///
  /// In vi, this message translates to:
  /// **'Album ảnh'**
  String get inboxAttachAlbum;

  /// No description provided for @inboxAttachCamera.
  ///
  /// In vi, this message translates to:
  /// **'Máy ảnh'**
  String get inboxAttachCamera;

  /// No description provided for @inboxAttachFile.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tệp'**
  String get inboxAttachFile;

  /// No description provided for @inboxAttachOffer.
  ///
  /// In vi, this message translates to:
  /// **'Tạo báo giá'**
  String get inboxAttachOffer;

  /// No description provided for @inboxAttachVideo.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu gọi video'**
  String get inboxAttachVideo;

  /// No description provided for @inboxQuickReplies.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời nhanh'**
  String get inboxQuickReplies;

  /// No description provided for @inboxQuickFallbackName.
  ///
  /// In vi, this message translates to:
  /// **'bạn'**
  String get inboxQuickFallbackName;

  /// No description provided for @inboxReply.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời'**
  String get inboxReply;

  /// No description provided for @inboxForward.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển tiếp'**
  String get inboxForward;

  /// No description provided for @inboxCopy.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép'**
  String get inboxCopy;

  /// No description provided for @inboxCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép tin nhắn'**
  String get inboxCopied;

  /// No description provided for @inboxForwarded.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển tiếp tới {n} cuộc trò chuyện'**
  String inboxForwarded(int n);

  /// No description provided for @inboxWithdrawOfferTitle.
  ///
  /// In vi, this message translates to:
  /// **'Rút lại báo giá?'**
  String get inboxWithdrawOfferTitle;

  /// No description provided for @inboxWithdrawOfferMessage.
  ///
  /// In vi, this message translates to:
  /// **'Khách hàng sẽ không thể chấp nhận báo giá này nữa.'**
  String get inboxWithdrawOfferMessage;

  /// No description provided for @inboxDeclineOfferTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối báo giá?'**
  String get inboxDeclineOfferTitle;

  /// No description provided for @inboxDeclineOfferMessage.
  ///
  /// In vi, this message translates to:
  /// **'Người bán sẽ được thông báo rằng bạn đã từ chối báo giá này.'**
  String get inboxDeclineOfferMessage;

  /// No description provided for @inboxWithdraw.
  ///
  /// In vi, this message translates to:
  /// **'Rút lại'**
  String get inboxWithdraw;

  /// No description provided for @inboxDecline.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get inboxDecline;

  /// No description provided for @inboxOfferWithdrawn.
  ///
  /// In vi, this message translates to:
  /// **'Đã rút lại báo giá'**
  String get inboxOfferWithdrawn;

  /// No description provided for @inboxOfferDeclined.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối báo giá'**
  String get inboxOfferDeclined;

  /// No description provided for @inboxSafetyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi luôn bảo vệ bạn'**
  String get inboxSafetyTitle;

  /// No description provided for @inboxCallDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'VietGig ghi lại các cuộc gọi video để giữ an toàn cho cả hai bên và hỗ trợ giải quyết khi có tranh chấp. Vui lòng không chia sẻ thông tin thanh toán trong cuộc gọi.'**
  String get inboxCallDialogMessage;

  /// No description provided for @inboxOpenCall.
  ///
  /// In vi, this message translates to:
  /// **'Mở cuộc gọi'**
  String get inboxOpenCall;

  /// No description provided for @inboxCallConnecting.
  ///
  /// In vi, this message translates to:
  /// **'Đang kết nối cuộc gọi video… (mô phỏng)'**
  String get inboxCallConnecting;

  /// No description provided for @inboxCallGuidelinesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hướng dẫn gọi video'**
  String get inboxCallGuidelinesTitle;

  /// No description provided for @inboxCallGuidelinesMessage.
  ///
  /// In vi, this message translates to:
  /// **'• Chỉ trao đổi nội dung liên quan tới dự án.\n• Không chia sẻ thông tin thanh toán hoặc liên hệ ngoài VietGig.\n• Cuộc gọi được ghi lại và lưu trong 30 ngày.\n• Bạn có thể báo cáo hành vi không phù hợp sau cuộc gọi.'**
  String get inboxCallGuidelinesMessage;

  /// No description provided for @inboxGotIt.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiểu'**
  String get inboxGotIt;

  /// No description provided for @inboxActiveOrdersTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đang thực hiện'**
  String get inboxActiveOrdersTitle;

  /// No description provided for @inboxNoOrdersTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đơn hàng nào'**
  String get inboxNoOrdersTitle;

  /// No description provided for @inboxNoOrdersMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có đơn hàng đang thực hiện với {name}.'**
  String inboxNoOrdersMessage(String name);

  /// No description provided for @inboxThisPartner.
  ///
  /// In vi, this message translates to:
  /// **'đối tác này'**
  String get inboxThisPartner;

  /// No description provided for @inboxOrderDue.
  ///
  /// In vi, this message translates to:
  /// **'Hạn giao: {date} · {price}'**
  String inboxOrderDue(String date, String price);

  /// No description provided for @inboxMessagesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get inboxMessagesTitle;

  /// No description provided for @inboxOnline.
  ///
  /// In vi, this message translates to:
  /// **'Online'**
  String get inboxOnline;

  /// No description provided for @inboxLocalTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ địa phương {time}'**
  String inboxLocalTime(String time);

  /// No description provided for @inboxOptionsTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn'**
  String get inboxOptionsTooltip;

  /// No description provided for @inboxLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được tin nhắn'**
  String get inboxLoadFailed;

  /// No description provided for @inboxNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy cuộc trò chuyện'**
  String get inboxNotFoundTitle;

  /// No description provided for @inboxNotFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc trò chuyện có thể đã bị xoá.'**
  String get inboxNotFoundMessage;

  /// No description provided for @inboxScrollDown.
  ///
  /// In vi, this message translates to:
  /// **'Cuộn xuống cuối'**
  String get inboxScrollDown;

  /// No description provided for @inboxBlockedNotice.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã chặn người dùng này.'**
  String get inboxBlockedNotice;

  /// No description provided for @inboxSafetyDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giữ an toàn trên VietGig'**
  String get inboxSafetyDialogTitle;

  /// No description provided for @inboxSafetyDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Khi thanh toán và trao đổi qua VietGig, bạn được bảo vệ bởi chính sách hoàn tiền và đội ngũ hỗ trợ. Đừng bao giờ chuyển khoản trực tiếp hoặc chia sẻ thông tin đăng nhập cho người khác.'**
  String get inboxSafetyDialogMessage;

  /// No description provided for @inboxStartChatHint.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tin nhắn cho {name} để bắt đầu trò chuyện.'**
  String inboxStartChatHint(String name);

  /// No description provided for @inboxPartner.
  ///
  /// In vi, this message translates to:
  /// **'đối tác'**
  String get inboxPartner;

  /// No description provided for @inboxTyping.
  ///
  /// In vi, this message translates to:
  /// **'{name} đang soạn tin…'**
  String inboxTyping(String name);

  /// No description provided for @inboxPartnerCap.
  ///
  /// In vi, this message translates to:
  /// **'Đối tác'**
  String get inboxPartnerCap;

  /// No description provided for @inboxAttachment.
  ///
  /// In vi, this message translates to:
  /// **'Tệp đính kèm'**
  String get inboxAttachment;

  /// No description provided for @inboxDownloading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải xuống {name}…'**
  String inboxDownloading(String name);

  /// No description provided for @inboxFileFallback.
  ///
  /// In vi, this message translates to:
  /// **'tệp'**
  String get inboxFileFallback;

  /// No description provided for @inboxCallCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã huỷ lời mời gọi video'**
  String get inboxCallCancelled;

  /// No description provided for @inboxCallDeclined.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối lời mời gọi video'**
  String get inboxCallDeclined;

  /// No description provided for @inboxReplyingTo.
  ///
  /// In vi, this message translates to:
  /// **'Đang trả lời {name}…'**
  String inboxReplyingTo(String name);

  /// No description provided for @inboxAttachTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Đính kèm'**
  String get inboxAttachTooltip;

  /// No description provided for @inboxInputHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tin nhắn…'**
  String get inboxInputHint;

  /// No description provided for @inboxSend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get inboxSend;

  /// No description provided for @inboxToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get inboxToday;

  /// No description provided for @inboxSafetyBanner.
  ///
  /// In vi, this message translates to:
  /// **'Vì sự an toàn của bạn, hãy giữ mọi thanh toán và trao đổi trên VietGig. '**
  String get inboxSafetyBanner;

  /// No description provided for @inboxLearnMore.
  ///
  /// In vi, this message translates to:
  /// **'Tìm hiểu thêm'**
  String get inboxLearnMore;

  /// No description provided for @inboxRelatedTo.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn này liên quan tới:'**
  String get inboxRelatedTo;

  /// No description provided for @inboxMilestoneCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} cột mốc'**
  String inboxMilestoneCount(int n);

  /// No description provided for @inboxDeliverIn.
  ///
  /// In vi, this message translates to:
  /// **'Giao trong {n} ngày'**
  String inboxDeliverIn(int n);

  /// No description provided for @inboxOptionsSummary.
  ///
  /// In vi, this message translates to:
  /// **'{n} tuỳ chọn: {list}'**
  String inboxOptionsSummary(int n, String list);

  /// No description provided for @inboxOfferPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá báo: {price}'**
  String inboxOfferPrice(String price);

  /// No description provided for @inboxOfferExpiresAt.
  ///
  /// In vi, this message translates to:
  /// **'Báo giá hết hạn lúc {time}'**
  String inboxOfferExpiresAt(String time);

  /// No description provided for @inboxViewFullOffer.
  ///
  /// In vi, this message translates to:
  /// **'Xem toàn bộ báo giá'**
  String get inboxViewFullOffer;

  /// No description provided for @inboxWithdrawOffer.
  ///
  /// In vi, this message translates to:
  /// **'Rút lại báo giá'**
  String get inboxWithdrawOffer;

  /// No description provided for @inboxVideoSent.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã gửi lời mời gọi video'**
  String get inboxVideoSent;

  /// No description provided for @inboxVideoJoinPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Đang tham gia?'**
  String get inboxVideoJoinPrompt;

  /// No description provided for @inboxVideoGuidelinesLink.
  ///
  /// In vi, this message translates to:
  /// **'Xem hướng dẫn gọi video'**
  String get inboxVideoGuidelinesLink;

  /// No description provided for @inboxVideoRecorded.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc gọi video sẽ được ghi lại và lưu trữ để mọi người tham gia có thể tải về.'**
  String get inboxVideoRecorded;

  /// No description provided for @inboxVideoDeclinedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối lời mời'**
  String get inboxVideoDeclinedLabel;

  /// No description provided for @inboxJoin.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia'**
  String get inboxJoin;

  /// No description provided for @inboxCancelInvite.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ lời mời'**
  String get inboxCancelInvite;

  /// No description provided for @inboxOptCustomAssets.
  ///
  /// In vi, this message translates to:
  /// **'Tài nguyên tuỳ chỉnh'**
  String get inboxOptCustomAssets;

  /// No description provided for @inboxOptResponsive.
  ///
  /// In vi, this message translates to:
  /// **'Thiết kế responsive'**
  String get inboxOptResponsive;

  /// No description provided for @inboxOptWireframe.
  ///
  /// In vi, this message translates to:
  /// **'Wireframe'**
  String get inboxOptWireframe;

  /// No description provided for @inboxOptPrototype.
  ///
  /// In vi, this message translates to:
  /// **'Prototype'**
  String get inboxOptPrototype;

  /// No description provided for @inboxOptSourceFiles.
  ///
  /// In vi, this message translates to:
  /// **'File nguồn'**
  String get inboxOptSourceFiles;

  /// No description provided for @inboxOptPages.
  ///
  /// In vi, this message translates to:
  /// **'{n} trang/màn hình'**
  String inboxOptPages(int n);

  /// No description provided for @inboxPagesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số trang/màn hình'**
  String get inboxPagesLabel;

  /// No description provided for @inboxErrGig.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn dịch vụ'**
  String get inboxErrGig;

  /// No description provided for @inboxErrDescEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mô tả báo giá'**
  String get inboxErrDescEmpty;

  /// No description provided for @inboxErrDescShort.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả cần ít nhất 20 ký tự'**
  String get inboxErrDescShort;

  /// No description provided for @inboxErrPriceEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tổng giá'**
  String get inboxErrPriceEmpty;

  /// No description provided for @inboxErrMinPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá tối thiểu {price}'**
  String inboxErrMinPrice(String price);

  /// No description provided for @inboxErrDays.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn thời gian giao'**
  String get inboxErrDays;

  /// No description provided for @inboxErrMilestones.
  ///
  /// In vi, this message translates to:
  /// **'Cần ít nhất 2 cột mốc'**
  String get inboxErrMilestones;

  /// No description provided for @inboxErrTemplate.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đặt tên cho mẫu'**
  String get inboxErrTemplate;

  /// No description provided for @inboxErrMsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên cột mốc'**
  String get inboxErrMsTitle;

  /// No description provided for @inboxErrMsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mô tả'**
  String get inboxErrMsDesc;

  /// No description provided for @inboxLinkGigTitle.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết với dịch vụ'**
  String get inboxLinkGigTitle;

  /// No description provided for @inboxPayTypeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn nhận thanh toán thế nào?'**
  String get inboxPayTypeTitle;

  /// No description provided for @inboxPayTypeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn hình thức phù hợp nhất với dự án.'**
  String get inboxPayTypeSubtitle;

  /// No description provided for @inboxPaySingle.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán một lần'**
  String get inboxPaySingle;

  /// No description provided for @inboxPaySingleDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhận toàn bộ thanh toán khi hoàn thành dự án.'**
  String get inboxPaySingleDesc;

  /// No description provided for @inboxPayMilestone.
  ///
  /// In vi, this message translates to:
  /// **'Theo cột mốc'**
  String get inboxPayMilestone;

  /// No description provided for @inboxPayMilestoneDesc.
  ///
  /// In vi, this message translates to:
  /// **'Làm từng bước và nhận thanh toán sau mỗi cột mốc hoàn thành.'**
  String get inboxPayMilestoneDesc;

  /// No description provided for @inboxDeliveryTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian giao'**
  String get inboxDeliveryTime;

  /// No description provided for @inboxRevisionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Số lượt sửa'**
  String get inboxRevisionsTitle;

  /// No description provided for @inboxNoRevisions.
  ///
  /// In vi, this message translates to:
  /// **'Không sửa'**
  String get inboxNoRevisions;

  /// No description provided for @inboxRevisionsCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} lượt sửa'**
  String inboxRevisionsCount(int n);

  /// No description provided for @inboxOfferExpiry.
  ///
  /// In vi, this message translates to:
  /// **'Thời hạn báo giá'**
  String get inboxOfferExpiry;

  /// No description provided for @inboxCheckOffer.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra lại thông tin báo giá'**
  String get inboxCheckOffer;

  /// No description provided for @inboxOfferSentTemplate.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi báo giá và lưu mẫu “{name}”'**
  String inboxOfferSentTemplate(String name);

  /// No description provided for @inboxOfferSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi báo giá'**
  String get inboxOfferSent;

  /// No description provided for @inboxOfferSendFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không gửi được báo giá. Vui lòng thử lại.'**
  String get inboxOfferSendFailed;

  /// No description provided for @inboxCreateOfferTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo báo giá'**
  String get inboxCreateOfferTitle;

  /// No description provided for @inboxGigsLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được dịch vụ'**
  String get inboxGigsLoadFailed;

  /// No description provided for @inboxLinkOfferToGig.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết báo giá với dịch vụ'**
  String get inboxLinkOfferToGig;

  /// No description provided for @inboxChange.
  ///
  /// In vi, this message translates to:
  /// **'Đổi'**
  String get inboxChange;

  /// No description provided for @inboxNoGigs.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có dịch vụ nào để liên kết.'**
  String get inboxNoGigs;

  /// No description provided for @inboxOfferDescHeader.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả báo giá'**
  String get inboxOfferDescHeader;

  /// No description provided for @inboxOfferDescHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: sản phẩm bàn giao, tiến độ, số lượng…'**
  String get inboxOfferDescHint;

  /// No description provided for @inboxTotalPrice.
  ///
  /// In vi, this message translates to:
  /// **'Tổng giá'**
  String get inboxTotalPrice;

  /// No description provided for @inboxPick.
  ///
  /// In vi, this message translates to:
  /// **'Chọn'**
  String get inboxPick;

  /// No description provided for @inboxRevisionsOptional.
  ///
  /// In vi, this message translates to:
  /// **'Số lượt sửa (tuỳ chọn)'**
  String get inboxRevisionsOptional;

  /// No description provided for @inboxMilestoneRowSummary.
  ///
  /// In vi, this message translates to:
  /// **'{price} | {days} ngày | {revisions} lượt sửa'**
  String inboxMilestoneRowSummary(String price, int days, int revisions);

  /// No description provided for @inboxMaxMilestones.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa {n} cột mốc'**
  String inboxMaxMilestones(int n);

  /// No description provided for @inboxAddMilestone.
  ///
  /// In vi, this message translates to:
  /// **'Thêm cột mốc'**
  String get inboxAddMilestone;

  /// No description provided for @inboxMilestoneTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng: {price} | {days} ngày | {revisions} lượt sửa'**
  String inboxMilestoneTotal(String price, int days, int revisions);

  /// No description provided for @inboxAddOptions.
  ///
  /// In vi, this message translates to:
  /// **'Thêm tuỳ chọn'**
  String get inboxAddOptions;

  /// No description provided for @inboxServiceOptions.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn dịch vụ'**
  String get inboxServiceOptions;

  /// No description provided for @inboxSelectedN.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn {n}'**
  String inboxSelectedN(int n);

  /// No description provided for @inboxOfferSettings.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập báo giá'**
  String get inboxOfferSettings;

  /// No description provided for @inboxRequireInfo.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu khách gửi thông tin'**
  String get inboxRequireInfo;

  /// No description provided for @inboxRequireInfoDesc.
  ///
  /// In vi, this message translates to:
  /// **'Khách cần trả lời câu hỏi yêu cầu trước khi bắt đầu'**
  String get inboxRequireInfoDesc;

  /// No description provided for @inboxSaveTemplate.
  ///
  /// In vi, this message translates to:
  /// **'Lưu làm mẫu'**
  String get inboxSaveTemplate;

  /// No description provided for @inboxReuseTemplate.
  ///
  /// In vi, this message translates to:
  /// **'Dùng lại cho các báo giá sau'**
  String get inboxReuseTemplate;

  /// No description provided for @inboxTemplateNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Đặt tên cho mẫu'**
  String get inboxTemplateNameHint;

  /// No description provided for @inboxSendMilestoneOffer.
  ///
  /// In vi, this message translates to:
  /// **'Gửi báo giá cột mốc'**
  String get inboxSendMilestoneOffer;

  /// No description provided for @inboxSendOffer.
  ///
  /// In vi, this message translates to:
  /// **'Gửi báo giá'**
  String get inboxSendOffer;

  /// No description provided for @inboxMilestoneN.
  ///
  /// In vi, this message translates to:
  /// **'Cột mốc {n}'**
  String inboxMilestoneN(int n);

  /// No description provided for @inboxDeleteMilestone.
  ///
  /// In vi, this message translates to:
  /// **'Xoá cột mốc'**
  String get inboxDeleteMilestone;

  /// No description provided for @inboxDeleteMilestoneTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá cột mốc này?'**
  String get inboxDeleteMilestoneTitle;

  /// No description provided for @inboxMsTitleHeader.
  ///
  /// In vi, this message translates to:
  /// **'Tên cột mốc'**
  String get inboxMsTitleHeader;

  /// No description provided for @inboxMsTitleHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Wireframe & concept'**
  String get inboxMsTitleHint;

  /// No description provided for @inboxDescHeader.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get inboxDescHeader;

  /// No description provided for @inboxMsDescHint.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm bàn giao, phạm vi công việc…'**
  String get inboxMsDescHint;

  /// No description provided for @inboxMsPriceLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giá (tối thiểu {price})'**
  String inboxMsPriceLabel(String price);

  /// No description provided for @inboxViewOffer.
  ///
  /// In vi, this message translates to:
  /// **'Xem báo giá'**
  String get inboxViewOffer;

  /// No description provided for @inboxViewMilestoneOffer.
  ///
  /// In vi, this message translates to:
  /// **'Xem báo giá theo cột mốc'**
  String get inboxViewMilestoneOffer;

  /// No description provided for @inboxOfferNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy báo giá'**
  String get inboxOfferNotFound;

  /// No description provided for @inboxOfferNotFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Báo giá này có thể đã bị xoá.'**
  String get inboxOfferNotFoundMessage;

  /// No description provided for @inboxFirstMilestoneCharge.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chỉ bị tính phí cho cột mốc đầu tiên ({price}).'**
  String inboxFirstMilestoneCharge(String price);

  /// No description provided for @inboxContinueCheckout.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục thanh toán'**
  String get inboxContinueCheckout;

  /// No description provided for @inboxOfferStatusBanner.
  ///
  /// In vi, this message translates to:
  /// **'Báo giá này {status}.'**
  String inboxOfferStatusBanner(String status);

  /// No description provided for @inboxOfferDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết báo giá'**
  String get inboxOfferDetails;

  /// No description provided for @inboxDetailPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá'**
  String get inboxDetailPrice;

  /// No description provided for @inboxDetailTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get inboxDetailTime;

  /// No description provided for @inboxDetailRevisions.
  ///
  /// In vi, this message translates to:
  /// **'Lượt sửa'**
  String get inboxDetailRevisions;

  /// No description provided for @inboxDetailExpires.
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn'**
  String get inboxDetailExpires;

  /// No description provided for @inboxDetailRequirements.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu'**
  String get inboxDetailRequirements;

  /// No description provided for @inboxDetailRequirementsValue.
  ///
  /// In vi, this message translates to:
  /// **'Cần gửi thông tin trước khi bắt đầu'**
  String get inboxDetailRequirementsValue;

  /// No description provided for @inboxIncludes.
  ///
  /// In vi, this message translates to:
  /// **'Bao gồm'**
  String get inboxIncludes;

  /// No description provided for @inboxMilestoneDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết cột mốc'**
  String get inboxMilestoneDetails;

  /// No description provided for @inboxMilestoneTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Người bán sẽ giao từng cột mốc. Bạn thanh toán cho từng cột mốc trước khi bắt đầu.'**
  String get inboxMilestoneTooltip;

  /// No description provided for @inboxTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng cộng'**
  String get inboxTotal;

  /// No description provided for @inboxMilestoneLine.
  ///
  /// In vi, this message translates to:
  /// **'{days} ngày | {price} | {revisions} lượt sửa'**
  String inboxMilestoneLine(int days, String price, int revisions);

  /// No description provided for @inboxOpening.
  ///
  /// In vi, this message translates to:
  /// **'Đang mở cuộc trò chuyện…'**
  String get inboxOpening;

  /// No description provided for @inboxOpenFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không mở được cuộc trò chuyện'**
  String get inboxOpenFailed;

  /// No description provided for @inboxForwardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển tiếp tin nhắn'**
  String get inboxForwardTitle;

  /// No description provided for @inboxRecentConversations.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc trò chuyện gần đây'**
  String get inboxRecentConversations;

  /// No description provided for @inboxNoOtherConversations.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cuộc trò chuyện khác'**
  String get inboxNoOtherConversations;

  /// No description provided for @inboxForwardCount.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển tiếp ({n})'**
  String inboxForwardCount(int n);

  /// No description provided for @inboxAddNew.
  ///
  /// In vi, this message translates to:
  /// **'Thêm mới'**
  String get inboxAddNew;

  /// No description provided for @inboxQuickEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có mẫu trả lời nhanh'**
  String get inboxQuickEmptyTitle;

  /// No description provided for @inboxQuickEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mẫu để trả lời khách hàng chỉ với một chạm.'**
  String get inboxQuickEmptyMessage;

  /// No description provided for @inboxQuickSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu mẫu trả lời nhanh'**
  String get inboxQuickSaved;

  /// No description provided for @inboxQuickNewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời nhanh mới'**
  String get inboxQuickNewTitle;

  /// No description provided for @inboxQuickName.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get inboxQuickName;

  /// No description provided for @inboxQuickNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Đặt tên cho mẫu trả lời'**
  String get inboxQuickNameHint;

  /// No description provided for @inboxQuickBody.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung tin nhắn'**
  String get inboxQuickBody;

  /// No description provided for @inboxQuickBodyHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập nội dung…'**
  String get inboxQuickBodyHint;

  /// No description provided for @inboxQuickTip.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo: gõ {token} để tự động chèn tên người nhận.'**
  String inboxQuickTip(String token);

  /// No description provided for @ordersNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy đơn hàng'**
  String get ordersNotFoundTitle;

  /// No description provided for @ordersNotFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng có thể đã bị xoá hoặc bạn không có quyền xem.'**
  String get ordersNotFoundMessage;

  /// No description provided for @ordersNotFoundAction.
  ///
  /// In vi, this message translates to:
  /// **'Về danh sách đơn hàng'**
  String get ordersNotFoundAction;

  /// No description provided for @ordersUnknownUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng VietGig'**
  String get ordersUnknownUser;

  /// No description provided for @ordersAttachTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đính kèm tệp'**
  String get ordersAttachTitle;

  /// No description provided for @ordersAttachCamera.
  ///
  /// In vi, this message translates to:
  /// **'Mở máy ảnh'**
  String get ordersAttachCamera;

  /// No description provided for @ordersAttachGallery.
  ///
  /// In vi, this message translates to:
  /// **'Mở thư viện ảnh'**
  String get ordersAttachGallery;

  /// No description provided for @ordersAttachFile.
  ///
  /// In vi, this message translates to:
  /// **'Tệp'**
  String get ordersAttachFile;

  /// No description provided for @ordersRemoveFile.
  ///
  /// In vi, this message translates to:
  /// **'Xoá tệp'**
  String get ordersRemoveFile;

  /// No description provided for @ordersApply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get ordersApply;

  /// No description provided for @ordersSend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get ordersSend;

  /// No description provided for @ordersInfoDateCode.
  ///
  /// In vi, this message translates to:
  /// **'{date} · Mã đơn {code}'**
  String ordersInfoDateCode(String date, String code);

  /// No description provided for @ordersInfoExtra.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ thêm: {name}'**
  String ordersInfoExtra(String name);

  /// No description provided for @ordersInfoSubtotal.
  ///
  /// In vi, this message translates to:
  /// **'Tạm tính'**
  String get ordersInfoSubtotal;

  /// No description provided for @ordersInfoServiceFee.
  ///
  /// In vi, this message translates to:
  /// **'Phí dịch vụ'**
  String get ordersInfoServiceFee;

  /// No description provided for @ordersInfoTip.
  ///
  /// In vi, this message translates to:
  /// **'Tiền tip'**
  String get ordersInfoTip;

  /// No description provided for @ordersInfoTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thanh toán'**
  String get ordersInfoTotal;

  /// No description provided for @ordersInfoDueDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giao'**
  String get ordersInfoDueDate;

  /// No description provided for @ordersInfoPaidWith.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán qua'**
  String get ordersInfoPaidWith;

  /// No description provided for @ordersManageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý đơn hàng'**
  String get ordersManageTitle;

  /// No description provided for @ordersNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get ordersNotifications;

  /// No description provided for @ordersOptions.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn'**
  String get ordersOptions;

  /// No description provided for @ordersSortDue.
  ///
  /// In vi, this message translates to:
  /// **'Hạn giao gần nhất'**
  String get ordersSortDue;

  /// No description provided for @ordersSortNewest.
  ///
  /// In vi, this message translates to:
  /// **'Mới đặt gần đây'**
  String get ordersSortNewest;

  /// No description provided for @ordersTabNeedsAction.
  ///
  /// In vi, this message translates to:
  /// **'Cần xử lý'**
  String get ordersTabNeedsAction;

  /// No description provided for @ordersTabInProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đang thực hiện'**
  String get ordersTabInProgress;

  /// No description provided for @ordersTabNew.
  ///
  /// In vi, this message translates to:
  /// **'Mới'**
  String get ordersTabNew;

  /// No description provided for @ordersTabDelivered.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao'**
  String get ordersTabDelivered;

  /// No description provided for @ordersTabCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get ordersTabCompleted;

  /// No description provided for @ordersTabCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã huỷ'**
  String get ordersTabCancelled;

  /// No description provided for @ordersTabWithCount.
  ///
  /// In vi, this message translates to:
  /// **'{label} ({count})'**
  String ordersTabWithCount(String label, int count);

  /// No description provided for @ordersFilterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp & lọc'**
  String get ordersFilterTitle;

  /// No description provided for @ordersFilterReset.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại'**
  String get ordersFilterReset;

  /// No description provided for @ordersFilterSortBy.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp theo'**
  String get ordersFilterSortBy;

  /// No description provided for @ordersFilterStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get ordersFilterStatus;

  /// No description provided for @ordersFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get ordersFilterAll;

  /// No description provided for @ordersGroupOverdue.
  ///
  /// In vi, this message translates to:
  /// **'Đã quá hạn'**
  String get ordersGroupOverdue;

  /// No description provided for @ordersGroupDue2Days.
  ///
  /// In vi, this message translates to:
  /// **'Đến hạn trong 2 ngày'**
  String get ordersGroupDue2Days;

  /// No description provided for @ordersGroupDue2To5Days.
  ///
  /// In vi, this message translates to:
  /// **'Đến hạn trong 2–5 ngày'**
  String get ordersGroupDue2To5Days;

  /// No description provided for @ordersGroupDueLater.
  ///
  /// In vi, this message translates to:
  /// **'Đến hạn sau 5 ngày'**
  String get ordersGroupDueLater;

  /// No description provided for @ordersEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả đơn hàng của bạn ở đây'**
  String get ordersEmptyTitle;

  /// No description provided for @ordersEmptySellerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Khi khách đặt dịch vụ của bạn, đơn hàng sẽ xuất hiện tại đây.'**
  String get ordersEmptySellerMessage;

  /// No description provided for @ordersEmptyBuyerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Khi bạn đặt một dịch vụ, bạn có thể theo dõi tiến độ đơn hàng tại đây.'**
  String get ordersEmptyBuyerMessage;

  /// No description provided for @ordersEmptySellerAction.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý dịch vụ của tôi'**
  String get ordersEmptySellerAction;

  /// No description provided for @ordersEmptyBuyerAction.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá dịch vụ'**
  String get ordersEmptyBuyerAction;

  /// No description provided for @ordersCardMenuTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng {code}'**
  String ordersCardMenuTitle(String code);

  /// No description provided for @ordersCardMenuOpen.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết đơn hàng'**
  String get ordersCardMenuOpen;

  /// No description provided for @ordersCardMenuChatBuyer.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin cho khách'**
  String get ordersCardMenuChatBuyer;

  /// No description provided for @ordersCardMenuChatSeller.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin cho người bán'**
  String get ordersCardMenuChatSeller;

  /// No description provided for @ordersResolutionCenter.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm giải quyết'**
  String get ordersResolutionCenter;

  /// No description provided for @ordersCopyCode.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép mã đơn'**
  String get ordersCopyCode;

  /// No description provided for @ordersCodeCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép mã đơn {code}'**
  String ordersCodeCopied(String code);

  /// No description provided for @ordersCardUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get ordersCardUser;

  /// No description provided for @ordersCardLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải…'**
  String get ordersCardLoading;

  /// No description provided for @ordersCardDue.
  ///
  /// In vi, this message translates to:
  /// **'Hạn giao {date}'**
  String ordersCardDue(String date);

  /// No description provided for @ordersCardPlaced.
  ///
  /// In vi, this message translates to:
  /// **'Đặt ngày {date}'**
  String ordersCardPlaced(String date);

  /// No description provided for @ordersDetailError.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra: {error}'**
  String ordersDetailError(String error);

  /// No description provided for @ordersDetailMenuUnread.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu chưa đọc'**
  String get ordersDetailMenuUnread;

  /// No description provided for @ordersDetailMenuExtra.
  ///
  /// In vi, this message translates to:
  /// **'Thêm dịch vụ'**
  String get ordersDetailMenuExtra;

  /// No description provided for @ordersDetailDeliver.
  ///
  /// In vi, this message translates to:
  /// **'Giao đơn hàng'**
  String get ordersDetailDeliver;

  /// No description provided for @ordersDetailMenuGig.
  ///
  /// In vi, this message translates to:
  /// **'Xem dịch vụ'**
  String get ordersDetailMenuGig;

  /// No description provided for @ordersDetailMarkedUnread.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu đơn hàng là chưa đọc'**
  String get ordersDetailMarkedUnread;

  /// No description provided for @ordersDetailPickExtra.
  ///
  /// In vi, this message translates to:
  /// **'Chọn dịch vụ bạn muốn thêm ở phía trên'**
  String get ordersDetailPickExtra;

  /// No description provided for @ordersDetailAddExtraTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm \"{title}\"?'**
  String ordersDetailAddExtraTitle(String title);

  /// No description provided for @ordersDetailAddExtraMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ thanh toán thêm {price}.'**
  String ordersDetailAddExtraMessage(String price);

  /// No description provided for @ordersDetailAddExtraMessageDays.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ thanh toán thêm {price} và thời gian giao kéo dài thêm {days} ngày.'**
  String ordersDetailAddExtraMessageDays(String price, int days);

  /// No description provided for @ordersDetailAddExtraConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get ordersDetailAddExtraConfirm;

  /// No description provided for @ordersDetailExtraAdded.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm \"{title}\" vào đơn hàng'**
  String ordersDetailExtraAdded(String title);

  /// No description provided for @ordersDetailRequestAccepted.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã chấp nhận yêu cầu'**
  String get ordersDetailRequestAccepted;

  /// No description provided for @ordersDetailRequestDeclined.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã từ chối yêu cầu'**
  String get ordersDetailRequestDeclined;

  /// No description provided for @ordersDetailApproveTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sẵn sàng nhận bản cuối?'**
  String get ordersDetailApproveTitle;

  /// No description provided for @ordersDetailApproveMessage.
  ///
  /// In vi, this message translates to:
  /// **'Sau bước này bạn sẽ không thể yêu cầu chỉnh sửa cho đơn hàng nữa.'**
  String get ordersDetailApproveMessage;

  /// No description provided for @ordersDetailCompletedSnack.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đã hoàn thành!'**
  String get ordersDetailCompletedSnack;

  /// No description provided for @ordersDetailRequestRevision.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu chỉnh sửa'**
  String get ordersDetailRequestRevision;

  /// No description provided for @ordersDetailNeedMoreTime.
  ///
  /// In vi, this message translates to:
  /// **'Tôi cần thêm thời gian để xem'**
  String get ordersDetailNeedMoreTime;

  /// No description provided for @ordersDetailNewTag.
  ///
  /// In vi, this message translates to:
  /// **'MỚI'**
  String get ordersDetailNewTag;

  /// No description provided for @ordersDetailResolutionPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Nếu gặp vấn đề với đơn hàng, hãy vào '**
  String get ordersDetailResolutionPrefix;

  /// No description provided for @ordersDetailRevisionSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả rõ những điểm bạn muốn người bán thay đổi.'**
  String get ordersDetailRevisionSubtitle;

  /// No description provided for @ordersDetailRevisionHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Bạn có thể đổi màu chủ đạo sang xanh đậm hơn không?'**
  String get ordersDetailRevisionHint;

  /// No description provided for @ordersDetailSendRequest.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu'**
  String get ordersDetailSendRequest;

  /// No description provided for @ordersDetailRevisionSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu chỉnh sửa cho người bán'**
  String get ordersDetailRevisionSent;

  /// No description provided for @ordersDetailMoreTimeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thời gian xem bản giao'**
  String get ordersDetailMoreTimeTitle;

  /// No description provided for @ordersDetailMoreTimeMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần thêm bao nhiêu ngày? Bạn có thể quay lại thêm nếu cần – tối đa 5 ngày.'**
  String get ordersDetailMoreTimeMessage;

  /// No description provided for @ordersDetailNewReviewDeadline.
  ///
  /// In vi, this message translates to:
  /// **'Hạn duyệt mới: {date}'**
  String ordersDetailNewReviewDeadline(String date);

  /// No description provided for @ordersDetailExtendReview.
  ///
  /// In vi, this message translates to:
  /// **'Gia hạn thời gian xem'**
  String get ordersDetailExtendReview;

  /// No description provided for @ordersDetailReviewExtended.
  ///
  /// In vi, this message translates to:
  /// **'Xong! Bạn có thêm {days} ngày để xem bản giao.'**
  String ordersDetailReviewExtended(int days);

  /// No description provided for @ordersDetailRemindOn.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ nhắc bạn 1 ngày trước hạn giao'**
  String get ordersDetailRemindOn;

  /// No description provided for @ordersDetailRemindOff.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt nhắc nhở'**
  String get ordersDetailRemindOff;

  /// No description provided for @ordersDetailThanksTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã đặt hàng!'**
  String get ordersDetailThanksTitle;

  /// No description provided for @ordersDetailThanksMessage.
  ///
  /// In vi, this message translates to:
  /// **'Người bán sẽ bắt tay vào làm ngay.'**
  String get ordersDetailThanksMessage;

  /// No description provided for @ordersDetailWaitingRequirements.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ khách gửi yêu cầu'**
  String get ordersDetailWaitingRequirements;

  /// No description provided for @ordersDetailSubmitRequirements.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu để bắt đầu đơn hàng'**
  String get ordersDetailSubmitRequirements;

  /// No description provided for @ordersDetailWaitingRequirementsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng sẽ bắt đầu khi khách gửi đầy đủ thông tin bạn yêu cầu.'**
  String get ordersDetailWaitingRequirementsMessage;

  /// No description provided for @ordersDetailSubmitRequirementsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Người bán cần thông tin từ bạn. Thời gian giao chỉ bắt đầu tính sau khi bạn gửi yêu cầu.'**
  String get ordersDetailSubmitRequirementsMessage;

  /// No description provided for @ordersDetailLetterToBuyer.
  ///
  /// In vi, this message translates to:
  /// **'Thư gửi khách'**
  String get ordersDetailLetterToBuyer;

  /// No description provided for @ordersDetailExtend.
  ///
  /// In vi, this message translates to:
  /// **'Gia hạn'**
  String get ordersDetailExtend;

  /// No description provided for @ordersDetailExtrasTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm dịch vụ cho đơn hàng'**
  String get ordersDetailExtrasTitle;

  /// No description provided for @ordersDetailHide.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn'**
  String get ordersDetailHide;

  /// No description provided for @ordersDetailAddMore.
  ///
  /// In vi, this message translates to:
  /// **'+ Thêm nữa'**
  String get ordersDetailAddMore;

  /// No description provided for @ordersDetailAdd.
  ///
  /// In vi, this message translates to:
  /// **'+ Thêm'**
  String get ordersDetailAdd;

  /// No description provided for @ordersDetailCancelRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu huỷ đơn hàng'**
  String get ordersDetailCancelRequestTitle;

  /// No description provided for @ordersDetailExtensionRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu gia hạn'**
  String get ordersDetailExtensionRequestTitle;

  /// No description provided for @ordersDetailCancelRequestedByYou.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã yêu cầu huỷ đơn hàng này.'**
  String get ordersDetailCancelRequestedByYou;

  /// No description provided for @ordersDetailCancelRequestedBy.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã yêu cầu huỷ đơn hàng này.'**
  String ordersDetailCancelRequestedBy(String name);

  /// No description provided for @ordersDetailExtensionRequestedByYou.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã yêu cầu gia hạn ngày giao thêm {days} ngày.'**
  String ordersDetailExtensionRequestedByYou(int days);

  /// No description provided for @ordersDetailExtensionRequestedBy.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã yêu cầu gia hạn ngày giao thêm {days} ngày.'**
  String ordersDetailExtensionRequestedBy(String name, int days);

  /// No description provided for @ordersDetailExtensionLength.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng gia hạn'**
  String get ordersDetailExtensionLength;

  /// No description provided for @ordersDetailNewDueDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giao mới'**
  String get ordersDetailNewDueDate;

  /// No description provided for @ordersDetailAwaitingResponse.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ phản hồi từ {name} (tới {date})'**
  String ordersDetailAwaitingResponse(String name, String date);

  /// No description provided for @ordersDetailRespondBefore.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần phản hồi trước {date}, nếu không yêu cầu sẽ tự động được chấp nhận.'**
  String ordersDetailRespondBefore(String date);

  /// No description provided for @ordersDetailAccept.
  ///
  /// In vi, this message translates to:
  /// **'Chấp nhận'**
  String get ordersDetailAccept;

  /// No description provided for @ordersDetailDecline.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get ordersDetailDecline;

  /// No description provided for @ordersDetailYouDelivered.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã giao đơn hàng'**
  String get ordersDetailYouDelivered;

  /// No description provided for @ordersDetailYourDelivery.
  ///
  /// In vi, this message translates to:
  /// **'Đây là bản giao của bạn'**
  String get ordersDetailYourDelivery;

  /// No description provided for @ordersDetailFileCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} tệp'**
  String ordersDetailFileCount(int n);

  /// No description provided for @ordersDetailDownloadingAll.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải {n} tệp về máy…'**
  String ordersDetailDownloadingAll(int n);

  /// No description provided for @ordersDetailDownloadAll.
  ///
  /// In vi, this message translates to:
  /// **'Tải tất cả'**
  String get ordersDetailDownloadAll;

  /// No description provided for @ordersDetailVirusScanned.
  ///
  /// In vi, this message translates to:
  /// **'Đã quét virus'**
  String get ordersDetailVirusScanned;

  /// No description provided for @ordersDetailDownloadingFile.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải \"{name}\"…'**
  String ordersDetailDownloadingFile(String name);

  /// No description provided for @ordersDetailAwaitingBuyerReview.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ khách duyệt bản giao.'**
  String get ordersDetailAwaitingBuyerReview;

  /// No description provided for @ordersDetailBuyerReviewUntil.
  ///
  /// In vi, this message translates to:
  /// **'Khách có tới {date} để duyệt. Sau thời điểm này đơn sẽ tự động hoàn thành.'**
  String ordersDetailBuyerReviewUntil(String date);

  /// No description provided for @ordersDetailApproveDelivery.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt bản giao'**
  String get ordersDetailApproveDelivery;

  /// No description provided for @ordersDetailNotReady.
  ///
  /// In vi, this message translates to:
  /// **'Chưa sẵn sàng'**
  String get ordersDetailNotReady;

  /// No description provided for @ordersDetailReviewHint.
  ///
  /// In vi, this message translates to:
  /// **'Hãy duyệt bản giao, yêu cầu chỉnh sửa hoặc xin thêm thời gian để xem.'**
  String get ordersDetailReviewHint;

  /// No description provided for @ordersDetailReviewUntil.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có tới {date} để duyệt bản giao, yêu cầu chỉnh sửa hoặc thêm thời gian xem. Sau thời điểm này, đơn hàng sẽ được tự động đánh dấu hoàn thành.'**
  String ordersDetailReviewUntil(String date);

  /// No description provided for @ordersDetailCompletedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đã hoàn thành'**
  String get ordersDetailCompletedTitle;

  /// No description provided for @ordersDetailCompletedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã sử dụng VietGig.'**
  String get ordersDetailCompletedMessage;

  /// No description provided for @ordersDetailBuyerReview.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá của khách'**
  String get ordersDetailBuyerReview;

  /// No description provided for @ordersDetailMyReview.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá của tôi'**
  String get ordersDetailMyReview;

  /// No description provided for @ordersDetailNoBuyerReview.
  ///
  /// In vi, this message translates to:
  /// **'Khách chưa để lại đánh giá.'**
  String get ordersDetailNoBuyerReview;

  /// No description provided for @ordersDetailShareExperience.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ trải nghiệm của bạn để giúp người mua khác lựa chọn.'**
  String get ordersDetailShareExperience;

  /// No description provided for @ordersDetailWriteReview.
  ///
  /// In vi, this message translates to:
  /// **'Viết đánh giá'**
  String get ordersDetailWriteReview;

  /// No description provided for @ordersDetailTipped.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã tip {amount} cho {name}. Cảm ơn bạn!'**
  String ordersDetailTipped(String amount, String name);

  /// No description provided for @ordersDetailTipTitle.
  ///
  /// In vi, this message translates to:
  /// **'Người bán xuất sắc xứng đáng được tip'**
  String get ordersDetailTipTitle;

  /// No description provided for @ordersDetailTipMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tip được chuyển 100% cho người bán.'**
  String get ordersDetailTipMessage;

  /// No description provided for @ordersDetailSendTip.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tip'**
  String get ordersDetailSendTip;

  /// No description provided for @ordersDetailCancelledTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đã bị huỷ'**
  String get ordersDetailCancelledTitle;

  /// No description provided for @ordersDetailCancelledMessage.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền đã được hoàn vào số dư VietGig của bạn.'**
  String get ordersDetailCancelledMessage;

  /// No description provided for @ordersDetailExpectedDelivery.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giao dự kiến'**
  String get ordersDetailExpectedDelivery;

  /// No description provided for @ordersDetailRemindOffAction.
  ///
  /// In vi, this message translates to:
  /// **'Tắt nhắc'**
  String get ordersDetailRemindOffAction;

  /// No description provided for @ordersDetailRemindMe.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc tôi'**
  String get ordersDetailRemindMe;

  /// No description provided for @ordersDetailAddedToCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm hạn giao {date} vào lịch'**
  String ordersDetailAddedToCalendar(String date);

  /// No description provided for @ordersDetailAddToCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào lịch'**
  String get ordersDetailAddToCalendar;

  /// No description provided for @ordersDetailActivity.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động'**
  String get ordersDetailActivity;

  /// No description provided for @ordersCheckoutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp'**
  String get ordersCheckoutTitle;

  /// No description provided for @ordersCheckoutGigNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy dịch vụ'**
  String get ordersCheckoutGigNotFoundTitle;

  /// No description provided for @ordersCheckoutGigNotFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ này có thể đã ngừng bán.'**
  String get ordersCheckoutGigNotFoundMessage;

  /// No description provided for @ordersCheckoutExploreOther.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá dịch vụ khác'**
  String get ordersCheckoutExploreOther;

  /// No description provided for @ordersCheckoutSelectedPackage.
  ///
  /// In vi, this message translates to:
  /// **'Gói đã chọn'**
  String get ordersCheckoutSelectedPackage;

  /// No description provided for @ordersCheckoutDeliveryIn.
  ///
  /// In vi, this message translates to:
  /// **'Giao trong {days} ngày'**
  String ordersCheckoutDeliveryIn(int days);

  /// No description provided for @ordersCheckoutRevisions.
  ///
  /// In vi, this message translates to:
  /// **'{revisions} lượt chỉnh sửa'**
  String ordersCheckoutRevisions(String revisions);

  /// No description provided for @ordersCheckoutAddExtras.
  ///
  /// In vi, this message translates to:
  /// **'Thêm dịch vụ cho đơn hàng'**
  String get ordersCheckoutAddExtras;

  /// No description provided for @ordersCheckoutNoExtras.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ này không có tuỳ chọn bổ sung.'**
  String get ordersCheckoutNoExtras;

  /// No description provided for @ordersCheckoutEstimatedDelivery.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian giao dự kiến: {days} ngày'**
  String ordersCheckoutEstimatedDelivery(int days);

  /// No description provided for @ordersCheckoutContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục ({amount})'**
  String ordersCheckoutContinue(String amount);

  /// No description provided for @ordersCheckoutNoExtraTime.
  ///
  /// In vi, this message translates to:
  /// **'Không thêm thời gian'**
  String get ordersCheckoutNoExtraTime;

  /// No description provided for @ordersCheckoutExtraDays.
  ///
  /// In vi, this message translates to:
  /// **'+{days} ngày'**
  String ordersCheckoutExtraDays(int days);

  /// No description provided for @ordersCheckoutFasterDays.
  ///
  /// In vi, this message translates to:
  /// **'Giao nhanh hơn {days} ngày'**
  String ordersCheckoutFasterDays(int days);

  /// No description provided for @ordersCheckoutQuantity.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng'**
  String get ordersCheckoutQuantity;

  /// No description provided for @ordersAddCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thẻ mới'**
  String get ordersAddCardTitle;

  /// No description provided for @ordersAddCardInvalidNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số thẻ không hợp lệ'**
  String get ordersAddCardInvalidNumber;

  /// No description provided for @ordersAddCardInvalidMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng không hợp lệ'**
  String get ordersAddCardInvalidMonth;

  /// No description provided for @ordersAddCardExpired.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ đã hết hạn'**
  String get ordersAddCardExpired;

  /// No description provided for @ordersAddCardHolderPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'HỌ TÊN CHỦ THẺ'**
  String get ordersAddCardHolderPlaceholder;

  /// No description provided for @ordersAddCardNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số thẻ'**
  String get ordersAddCardNumber;

  /// No description provided for @ordersAddCardNumberRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số thẻ hợp lệ'**
  String get ordersAddCardNumberRequired;

  /// No description provided for @ordersAddCardLastName.
  ///
  /// In vi, this message translates to:
  /// **'Họ'**
  String get ordersAddCardLastName;

  /// No description provided for @ordersAddCardFirstName.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get ordersAddCardFirstName;

  /// No description provided for @ordersAddCardRequired.
  ///
  /// In vi, this message translates to:
  /// **'Bắt buộc'**
  String get ordersAddCardRequired;

  /// No description provided for @ordersAddCardCvvHelp.
  ///
  /// In vi, this message translates to:
  /// **'3–4 chữ số ở mặt sau thẻ'**
  String get ordersAddCardCvvHelp;

  /// No description provided for @ordersAddCardSecure.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin thẻ được mã hoá và lưu trữ an toàn.'**
  String get ordersAddCardSecure;

  /// No description provided for @ordersAddCardPay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get ordersAddCardPay;

  /// No description provided for @ordersReviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại đơn hàng'**
  String get ordersReviewTitle;

  /// No description provided for @ordersReviewMethodCard.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ tín dụng/ghi nợ'**
  String get ordersReviewMethodCard;

  /// No description provided for @ordersReviewMethodBank.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển khoản ngân hàng'**
  String get ordersReviewMethodBank;

  /// No description provided for @ordersReviewPromoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mã khuyến mãi'**
  String get ordersReviewPromoTitle;

  /// No description provided for @ordersReviewPromoHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã, VD: VIETGIG10'**
  String get ordersReviewPromoHint;

  /// No description provided for @ordersReviewPromoEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mã'**
  String get ordersReviewPromoEmpty;

  /// No description provided for @ordersReviewPromoInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Mã không hợp lệ hoặc đã hết hạn'**
  String get ordersReviewPromoInvalid;

  /// No description provided for @ordersReviewPromoApplied.
  ///
  /// In vi, this message translates to:
  /// **'Đã áp dụng mã {code} – giảm 10%'**
  String ordersReviewPromoApplied(String code);

  /// No description provided for @ordersReviewCardAdded.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm thẻ thanh toán'**
  String get ordersReviewCardAdded;

  /// No description provided for @ordersReviewPayFailed.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán thất bại: {error}'**
  String ordersReviewPayFailed(String error);

  /// No description provided for @ordersReviewSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tuyệt vời! Đơn hàng đã được tạo'**
  String get ordersReviewSuccessTitle;

  /// No description provided for @ordersReviewSuccessNeedRequirements.
  ///
  /// In vi, this message translates to:
  /// **'Hãy gửi yêu cầu để người bán bắt đầu thực hiện đơn hàng của bạn.'**
  String get ordersReviewSuccessNeedRequirements;

  /// No description provided for @ordersReviewSuccessStarted.
  ///
  /// In vi, this message translates to:
  /// **'Người bán sẽ bắt đầu thực hiện ngay. Chúc mừng bước đầu tiên của bạn!'**
  String get ordersReviewSuccessStarted;

  /// No description provided for @ordersReviewViewOrder.
  ///
  /// In vi, this message translates to:
  /// **'Xem đơn hàng'**
  String get ordersReviewViewOrder;

  /// No description provided for @ordersReviewCustomOffer.
  ///
  /// In vi, this message translates to:
  /// **'Báo giá riêng'**
  String get ordersReviewCustomOffer;

  /// No description provided for @ordersReviewPaymentMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get ordersReviewPaymentMethod;

  /// No description provided for @ordersReviewCardSaved.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ đã lưu – sẵn sàng thanh toán'**
  String get ordersReviewCardSaved;

  /// No description provided for @ordersReviewOrderDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết đơn hàng'**
  String get ordersReviewOrderDetails;

  /// No description provided for @ordersReviewExtras.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ thêm'**
  String get ordersReviewExtras;

  /// No description provided for @ordersReviewSummary.
  ///
  /// In vi, this message translates to:
  /// **'Tóm tắt'**
  String get ordersReviewSummary;

  /// No description provided for @ordersReviewFeeTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Phí giúp VietGig vận hành nền tảng và hỗ trợ khách hàng 24/7.'**
  String get ordersReviewFeeTooltip;

  /// No description provided for @ordersReviewEnterCode.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã'**
  String get ordersReviewEnterCode;

  /// No description provided for @ordersReviewTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng'**
  String get ordersReviewTotal;

  /// No description provided for @ordersReviewEstimatedDelivery.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giao dự kiến'**
  String get ordersReviewEstimatedDelivery;

  /// No description provided for @ordersReviewTerms.
  ///
  /// In vi, this message translates to:
  /// **'Khi nhấn nút bên dưới, bạn đồng ý với Điều khoản dịch vụ và Chính sách thanh toán của VietGig. Số tiền chỉ được chuyển cho người bán khi bạn duyệt bản giao.'**
  String get ordersReviewTerms;

  /// No description provided for @ordersReviewSecure.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin thanh toán của bạn được bảo mật'**
  String get ordersReviewSecure;

  /// No description provided for @ordersReviewAddPayment.
  ///
  /// In vi, this message translates to:
  /// **'Thêm phương thức thanh toán'**
  String get ordersReviewAddPayment;

  /// No description provided for @ordersReviewPay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán ({amount})'**
  String ordersReviewPay(String amount);

  /// No description provided for @ordersReviewProcessing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý đơn hàng của bạn…'**
  String get ordersReviewProcessing;

  /// No description provided for @ordersReviewDontClose.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng không đóng ứng dụng.'**
  String get ordersReviewDontClose;

  /// No description provided for @ordersReqTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu'**
  String get ordersReqTitle;

  /// No description provided for @ordersReqFallbackQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Hãy mô tả chi tiết yêu cầu của bạn cho đơn hàng này.'**
  String get ordersReqFallbackQuestion;

  /// No description provided for @ordersReqSendFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không gửi được yêu cầu: {error}'**
  String ordersReqSendFailed(String error);

  /// No description provided for @ordersReqSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu. Đơn hàng của bạn đã bắt đầu!'**
  String get ordersReqSent;

  /// No description provided for @ordersReqAlreadyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu đã được gửi'**
  String get ordersReqAlreadyTitle;

  /// No description provided for @ordersReqAlreadyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng này không cần thêm thông tin. Bạn có thể nhắn tin cho người bán nếu muốn bổ sung.'**
  String get ordersReqAlreadyMessage;

  /// No description provided for @ordersReqBackToOrder.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đơn hàng'**
  String get ordersReqBackToOrder;

  /// No description provided for @ordersReqOptional.
  ///
  /// In vi, this message translates to:
  /// **'(không bắt buộc)'**
  String get ordersReqOptional;

  /// No description provided for @ordersReqConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Tôi xác nhận thông tin cung cấp là chính xác và đầy đủ. Mọi thay đổi sau này cần người bán đồng ý và có thể phát sinh chi phí.'**
  String get ordersReqConfirm;

  /// No description provided for @ordersReqSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu'**
  String get ordersReqSubmit;

  /// No description provided for @ordersReqHint.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng điền thông tin cần thiết'**
  String get ordersReqHint;

  /// No description provided for @ordersReqAttachMore.
  ///
  /// In vi, this message translates to:
  /// **'Đính kèm tệp khác'**
  String get ordersReqAttachMore;

  /// No description provided for @ordersDeliverTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng'**
  String get ordersDeliverTitle;

  /// No description provided for @ordersDeliverNoQuickResponses.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có mẫu trả lời nhanh nào'**
  String get ordersDeliverNoQuickResponses;

  /// No description provided for @ordersDeliverQuickResponses.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời nhanh'**
  String get ordersDeliverQuickResponses;

  /// No description provided for @ordersDeliverSendError.
  ///
  /// In vi, this message translates to:
  /// **'Không gửi được bản giao: {error}'**
  String ordersDeliverSendError(String error);

  /// No description provided for @ordersDeliverSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi bản giao cho khách. Khách có 3 ngày để duyệt.'**
  String get ordersDeliverSent;

  /// No description provided for @ordersDeliverSellerOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ người bán mới có thể giao đơn hàng'**
  String get ordersDeliverSellerOnly;

  /// No description provided for @ordersDeliverUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Không thể giao đơn hàng lúc này'**
  String get ordersDeliverUnavailable;

  /// No description provided for @ordersDeliverCurrentStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái hiện tại: {status}.'**
  String ordersDeliverCurrentStatus(String status);

  /// No description provided for @ordersDeliverBackToOrder.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đơn hàng'**
  String get ordersDeliverBackToOrder;

  /// No description provided for @ordersDeliverMessageTo.
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắn gửi {name}'**
  String ordersDeliverMessageTo(String name);

  /// No description provided for @ordersDeliverInsertQuick.
  ///
  /// In vi, this message translates to:
  /// **'Chèn mẫu trả lời nhanh'**
  String get ordersDeliverInsertQuick;

  /// No description provided for @ordersDeliverMessageHint.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả những gì bạn giao, hướng dẫn sử dụng tệp và lời cảm ơn tới khách (ít nhất 10 ký tự).'**
  String get ordersDeliverMessageHint;

  /// No description provided for @ordersDeliverAttachments.
  ///
  /// In vi, this message translates to:
  /// **'Tệp đính kèm'**
  String get ordersDeliverAttachments;

  /// No description provided for @ordersDeliverAttachMore.
  ///
  /// In vi, this message translates to:
  /// **'Đính kèm thêm tệp'**
  String get ordersDeliverAttachMore;

  /// No description provided for @ordersDeliverFileNote.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa 5 GB mỗi tệp. Khách sẽ nhận được thông báo ngay khi bạn gửi bản giao.'**
  String get ordersDeliverFileNote;

  /// No description provided for @ordersDeliverUploading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải tệp lên…'**
  String get ordersDeliverUploading;

  /// No description provided for @ordersDeliverSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Gửi bản giao'**
  String get ordersDeliverSubmit;

  /// No description provided for @ordersResolutionError.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra: {error}'**
  String ordersResolutionError(String error);

  /// No description provided for @ordersResolutionUpdateChat.
  ///
  /// In vi, this message translates to:
  /// **'[Yêu cầu cập nhật đơn {code}] {text}'**
  String ordersResolutionUpdateChat(String code, String text);

  /// No description provided for @ordersResolutionUpdateSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu cập nhật tới {name}'**
  String ordersResolutionUpdateSent(String name);

  /// No description provided for @ordersResolutionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm giải quyết'**
  String get ordersResolutionTitle;

  /// No description provided for @ordersResolutionUpdateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu cập nhật'**
  String get ordersResolutionUpdateTitle;

  /// No description provided for @ordersResolutionExtendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gia hạn thời gian giao'**
  String get ordersResolutionExtendTitle;

  /// No description provided for @ordersResolutionCancelTitle.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ đơn hàng'**
  String get ordersResolutionCancelTitle;

  /// No description provided for @ordersResolutionSupportPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy điều bạn cần? '**
  String get ordersResolutionSupportPrompt;

  /// No description provided for @ordersResolutionSupportLink.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ Bộ phận hỗ trợ'**
  String get ordersResolutionSupportLink;

  /// No description provided for @ordersResolutionOrderInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin đơn hàng'**
  String get ordersResolutionOrderInfo;

  /// No description provided for @ordersResolutionDisputeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang giải quyết tranh chấp'**
  String get ordersResolutionDisputeTitle;

  /// No description provided for @ordersResolutionDisputeBody.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng này đang có một yêu cầu chờ phản hồi. Vui lòng đợi bên kia phản hồi trước khi mở yêu cầu mới. Nếu gặp vấn đề, Bộ phận hỗ trợ của VietGig luôn sẵn sàng giúp bạn.'**
  String get ordersResolutionDisputeBody;

  /// No description provided for @ordersResolutionPendingCancel.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu huỷ đơn'**
  String get ordersResolutionPendingCancel;

  /// No description provided for @ordersResolutionPendingExtend.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu gia hạn {days} ngày'**
  String ordersResolutionPendingExtend(int days);

  /// No description provided for @ordersResolutionPendingLine.
  ///
  /// In vi, this message translates to:
  /// **'{request} · gửi lúc {time}'**
  String ordersResolutionPendingLine(String request, String time);

  /// No description provided for @ordersResolutionCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đã hoàn thành'**
  String get ordersResolutionCompleted;

  /// No description provided for @ordersResolutionCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đã bị huỷ'**
  String get ordersResolutionCancelled;

  /// No description provided for @ordersResolutionEndedBody.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đã kết thúc nên không thể mở yêu cầu mới. Nếu cần hỗ trợ, hãy liên hệ với chúng tôi.'**
  String get ordersResolutionEndedBody;

  /// No description provided for @ordersResolutionWelcome.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng!'**
  String get ordersResolutionWelcome;

  /// No description provided for @ordersResolutionWelcomeBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể giải quyết vấn đề với đơn hàng tại đây.'**
  String get ordersResolutionWelcomeBody;

  /// No description provided for @ordersResolutionHowHelp.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi giúp gì được cho bạn?'**
  String get ordersResolutionHowHelp;

  /// No description provided for @ordersResolutionMenuUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu cập nhật tiến độ'**
  String get ordersResolutionMenuUpdate;

  /// No description provided for @ordersResolutionMenuMessageBuyer.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin cho khách'**
  String get ordersResolutionMenuMessageBuyer;

  /// No description provided for @ordersResolutionUpdateHeading.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời nhắn tới người bán'**
  String get ordersResolutionUpdateHeading;

  /// No description provided for @ordersResolutionUpdateBody.
  ///
  /// In vi, this message translates to:
  /// **'Hỏi {name} về tiến độ đơn hàng. Tin nhắn sẽ được gửi vào hộp thư của bạn.'**
  String ordersResolutionUpdateBody(String name);

  /// No description provided for @ordersResolutionUpdateHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Chào bạn, mình muốn hỏi đơn hàng đang tiến triển thế nào rồi?'**
  String get ordersResolutionUpdateHint;

  /// No description provided for @ordersResolutionSendRequest.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu'**
  String get ordersResolutionSendRequest;

  /// No description provided for @ordersResolutionExtendHeading.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần thêm bao nhiêu ngày?'**
  String get ordersResolutionExtendHeading;

  /// No description provided for @ordersResolutionExtendDays.
  ///
  /// In vi, this message translates to:
  /// **'Số ngày gia hạn'**
  String get ordersResolutionExtendDays;

  /// No description provided for @ordersResolutionCurrentDue.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giao hiện tại'**
  String get ordersResolutionCurrentDue;

  /// No description provided for @ordersResolutionNewDue.
  ///
  /// In vi, this message translates to:
  /// **'Dự kiến giao ngày'**
  String get ordersResolutionNewDue;

  /// No description provided for @ordersResolutionMessage.
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắn'**
  String get ordersResolutionMessage;

  /// No description provided for @ordersResolutionExtendHintSeller.
  ///
  /// In vi, this message translates to:
  /// **'VD: Mình cần thêm thời gian để hoàn thiện chi tiết cho bạn. Mong bạn thông cảm!'**
  String get ordersResolutionExtendHintSeller;

  /// No description provided for @ordersResolutionExtendHintBuyer.
  ///
  /// In vi, this message translates to:
  /// **'VD: Mình cần thêm thời gian để chuẩn bị tài liệu cho bạn.'**
  String get ordersResolutionExtendHintBuyer;

  /// No description provided for @ordersResolutionExtendNoteSeller.
  ///
  /// In vi, this message translates to:
  /// **'Khách có 2 ngày để phản hồi. Nếu không phản hồi, yêu cầu sẽ tự động được chấp nhận.'**
  String get ordersResolutionExtendNoteSeller;

  /// No description provided for @ordersResolutionExtendNoteBuyer.
  ///
  /// In vi, this message translates to:
  /// **'Người bán có 2 ngày để phản hồi. Nếu không phản hồi, yêu cầu sẽ tự động được chấp nhận.'**
  String get ordersResolutionExtendNoteBuyer;

  /// No description provided for @ordersResolutionExtendSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu gia hạn'**
  String get ordersResolutionExtendSubmit;

  /// No description provided for @ordersResolutionExtendSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu gia hạn {days} ngày'**
  String ordersResolutionExtendSent(int days);

  /// No description provided for @ordersResolutionRefundNote.
  ///
  /// In vi, this message translates to:
  /// **'Nếu người bán đồng ý, {amount} sẽ được hoàn vào số dư VietGig của bạn.'**
  String ordersResolutionRefundNote(String amount);

  /// No description provided for @ordersResolutionFeedbackHeading.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi cho người bán'**
  String get ordersResolutionFeedbackHeading;

  /// No description provided for @ordersResolutionCancelHint.
  ///
  /// In vi, this message translates to:
  /// **'Cho người bán biết lý do bạn muốn huỷ đơn (không bắt buộc)'**
  String get ordersResolutionCancelHint;

  /// No description provided for @ordersResolutionReasonHeading.
  ///
  /// In vi, this message translates to:
  /// **'Lý do huỷ'**
  String get ordersResolutionReasonHeading;

  /// No description provided for @ordersResolutionReasonNote.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ VietGig thấy lý do này.'**
  String get ordersResolutionReasonNote;

  /// No description provided for @ordersResolutionReasonNoResponse.
  ///
  /// In vi, this message translates to:
  /// **'Người bán không phản hồi'**
  String get ordersResolutionReasonNoResponse;

  /// No description provided for @ordersResolutionReasonQuality.
  ///
  /// In vi, this message translates to:
  /// **'Chất lượng kém'**
  String get ordersResolutionReasonQuality;

  /// No description provided for @ordersResolutionReasonWrongItem.
  ///
  /// In vi, this message translates to:
  /// **'Không nhận được đúng thứ đã đặt'**
  String get ordersResolutionReasonWrongItem;

  /// No description provided for @ordersResolutionReasonTooMuchGuidance.
  ///
  /// In vi, this message translates to:
  /// **'Người bán cần quá nhiều hướng dẫn'**
  String get ordersResolutionReasonTooMuchGuidance;

  /// No description provided for @ordersResolutionReasonLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Rào cản ngôn ngữ'**
  String get ordersResolutionReasonLanguage;

  /// No description provided for @ordersResolutionReasonOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get ordersResolutionReasonOther;

  /// No description provided for @ordersResolutionRateSeller.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá trải nghiệm với người bán'**
  String get ordersResolutionRateSeller;

  /// No description provided for @ordersResolutionCancelSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu huỷ'**
  String get ordersResolutionCancelSubmit;

  /// No description provided for @ordersResolutionSellerRatingNote.
  ///
  /// In vi, this message translates to:
  /// **'(Đánh giá người bán: {rating}/5)'**
  String ordersResolutionSellerRatingNote(int rating);

  /// No description provided for @ordersResolutionCancelSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu huỷ. Người bán có tối đa 2 ngày để phản hồi.'**
  String get ordersResolutionCancelSent;

  /// No description provided for @ordersRateThanksReview.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã đánh giá!'**
  String get ordersRateThanksReview;

  /// No description provided for @ordersRateSubmitError.
  ///
  /// In vi, this message translates to:
  /// **'Không gửi được đánh giá: {error}'**
  String ordersRateSubmitError(String error);

  /// No description provided for @ordersRateCustomTitle.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền tuỳ chỉnh (VND)'**
  String get ordersRateCustomTitle;

  /// No description provided for @ordersRateCustomHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: 70000'**
  String get ordersRateCustomHint;

  /// No description provided for @ordersRateCustomHelper.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu 25.000 ₫'**
  String get ordersRateCustomHelper;

  /// No description provided for @ordersRateCustomError.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền tối thiểu là 25.000 ₫'**
  String get ordersRateCustomError;

  /// No description provided for @ordersRateTipError.
  ///
  /// In vi, this message translates to:
  /// **'Không gửi được tip: {error}'**
  String ordersRateTipError(String error);

  /// No description provided for @ordersRateTipSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi tip {amount} cho {name}. Cảm ơn bạn!'**
  String ordersRateTipSent(String amount, String name);

  /// No description provided for @ordersRateLater.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get ordersRateLater;

  /// No description provided for @ordersRateSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get ordersRateSkip;

  /// No description provided for @ordersRateBuyerOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ người mua mới có thể đánh giá đơn hàng này'**
  String get ordersRateBuyerOnly;

  /// No description provided for @ordersRateNotYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thể đánh giá'**
  String get ordersRateNotYet;

  /// No description provided for @ordersRateNotYetBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể đánh giá sau khi duyệt bản giao và đơn hàng hoàn thành.'**
  String get ordersRateNotYetBody;

  /// No description provided for @ordersRateContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get ordersRateContinue;

  /// No description provided for @ordersRateStar1.
  ///
  /// In vi, this message translates to:
  /// **'Kém'**
  String get ordersRateStar1;

  /// No description provided for @ordersRateStar2.
  ///
  /// In vi, this message translates to:
  /// **'Tạm'**
  String get ordersRateStar2;

  /// No description provided for @ordersRateStar3.
  ///
  /// In vi, this message translates to:
  /// **'Tốt'**
  String get ordersRateStar3;

  /// No description provided for @ordersRateStar4.
  ///
  /// In vi, this message translates to:
  /// **'Rất tốt'**
  String get ordersRateStar4;

  /// No description provided for @ordersRateStar5.
  ///
  /// In vi, this message translates to:
  /// **'Xuất sắc'**
  String get ordersRateStar5;

  /// No description provided for @ordersRatePositiveDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chú ý chi tiết'**
  String get ordersRatePositiveDetail;

  /// No description provided for @ordersRatePositiveCreative.
  ///
  /// In vi, this message translates to:
  /// **'Sáng tạo'**
  String get ordersRatePositiveCreative;

  /// No description provided for @ordersRatePositiveAesthetic.
  ///
  /// In vi, this message translates to:
  /// **'Thẩm mỹ'**
  String get ordersRatePositiveAesthetic;

  /// No description provided for @ordersRatePositiveProfessional.
  ///
  /// In vi, this message translates to:
  /// **'Chuyên nghiệp'**
  String get ordersRatePositiveProfessional;

  /// No description provided for @ordersRatePositiveExceeded.
  ///
  /// In vi, this message translates to:
  /// **'Vượt kỳ vọng'**
  String get ordersRatePositiveExceeded;

  /// No description provided for @ordersRatePositiveOnBrand.
  ///
  /// In vi, this message translates to:
  /// **'Đúng thương hiệu'**
  String get ordersRatePositiveOnBrand;

  /// No description provided for @ordersRateNegativeLate.
  ///
  /// In vi, this message translates to:
  /// **'Chậm tiến độ'**
  String get ordersRateNegativeLate;

  /// No description provided for @ordersRateNegativeDetail.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu chi tiết'**
  String get ordersRateNegativeDetail;

  /// No description provided for @ordersRateNegativeOffBrief.
  ///
  /// In vi, this message translates to:
  /// **'Không đúng yêu cầu'**
  String get ordersRateNegativeOffBrief;

  /// No description provided for @ordersRateNegativeCommunication.
  ///
  /// In vi, this message translates to:
  /// **'Giao tiếp chưa tốt'**
  String get ordersRateNegativeCommunication;

  /// No description provided for @ordersRateNegativeQuality.
  ///
  /// In vi, this message translates to:
  /// **'Chất lượng chưa đạt'**
  String get ordersRateNegativeQuality;

  /// No description provided for @ordersRateNegativeRevisions.
  ///
  /// In vi, this message translates to:
  /// **'Cần nhiều chỉnh sửa'**
  String get ordersRateNegativeRevisions;

  /// No description provided for @ordersRateQualityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đánh giá chất lượng bản giao thế nào?'**
  String get ordersRateQualityTitle;

  /// No description provided for @ordersRateGoodTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thật tuyệt! Điều gì khiến nó xuất sắc?'**
  String get ordersRateGoodTitle;

  /// No description provided for @ordersRateBadTitle.
  ///
  /// In vi, this message translates to:
  /// **'Rất tiếc! Điều gì chưa ổn?'**
  String get ordersRateBadTitle;

  /// No description provided for @ordersRateValueTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đánh giá giá trị của bản giao?'**
  String get ordersRateValueTitle;

  /// No description provided for @ordersRateValueBody.
  ///
  /// In vi, this message translates to:
  /// **'Dự án mất {days} ngày với chi phí {amount}.'**
  String ordersRateValueBody(int days, String amount);

  /// No description provided for @ordersRateTopicsDefault.
  ///
  /// In vi, this message translates to:
  /// **'chất lượng, giao tiếp và thời gian phản hồi'**
  String get ordersRateTopicsDefault;

  /// No description provided for @ordersRateWriteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Viết đánh giá công khai'**
  String get ordersRateWriteTitle;

  /// No description provided for @ordersRateWriteBody.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ chi tiết về trải nghiệm làm việc với người bán và kết quả cuối cùng, cùng các chủ đề như: {topics}.'**
  String ordersRateWriteBody(String topics);

  /// No description provided for @ordersRateTextHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết ít nhất 10 ký tự. Hãy cho người mua khác biết cảm nhận trung thực của bạn.'**
  String get ordersRateTextHint;

  /// No description provided for @ordersRateShareTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ mẫu công việc công khai'**
  String get ordersRateShareTitle;

  /// No description provided for @ordersRateShareBody.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu công việc có thể hiển thị cùng đánh giá trên trang người bán. Tôi xác nhận mẫu không chứa thông tin cá nhân hay nhạy cảm.'**
  String get ordersRateShareBody;

  /// No description provided for @ordersRateSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Gửi đánh giá'**
  String get ordersRateSubmit;

  /// No description provided for @ordersRatePublicNote.
  ///
  /// In vi, this message translates to:
  /// **'Giá đơn hàng và thông tin hồ sơ của bạn sẽ hiển thị công khai cùng đánh giá.'**
  String get ordersRatePublicNote;

  /// No description provided for @ordersRateThanks.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn!'**
  String get ordersRateThanks;

  /// No description provided for @ordersRateTipped.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã gửi tip {amount} cho {name}.'**
  String ordersRateTipped(String amount, String name);

  /// No description provided for @ordersRateTipPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể gửi tip để cảm ơn {name}. Tip được chuyển 100% cho người bán.'**
  String ordersRateTipPrompt(String name);

  /// No description provided for @ordersRateCustom.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chỉnh'**
  String get ordersRateCustom;

  /// No description provided for @ordersRateSendTip.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tip'**
  String get ordersRateSendTip;

  /// No description provided for @ordersRateSendTipAmount.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tip {amount}'**
  String ordersRateSendTipAmount(String amount);

  /// No description provided for @ordersRateNoFee.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ không bị tính phí dịch vụ cho tiền tip.'**
  String get ordersRateNoFee;

  /// No description provided for @profileAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get profileAccount;

  /// No description provided for @profileLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get profileLanguage;

  /// No description provided for @profileAppearance.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get profileAppearance;

  /// No description provided for @profileCurrency.
  ///
  /// In vi, this message translates to:
  /// **'Tiền tệ'**
  String get profileCurrency;

  /// No description provided for @profileNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get profileNotifications;

  /// No description provided for @profileSecurity.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật'**
  String get profileSecurity;

  /// No description provided for @profilePreferences.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn'**
  String get profilePreferences;

  /// No description provided for @profileSupportCenter.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm hỗ trợ'**
  String get profileSupportCenter;

  /// No description provided for @profileSendFeedback.
  ///
  /// In vi, this message translates to:
  /// **'Gửi góp ý'**
  String get profileSendFeedback;

  /// No description provided for @profileThemeLight.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get profileThemeDark;

  /// No description provided for @profileThemeSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get profileThemeSystem;

  /// No description provided for @profileThemeSystemShort.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống'**
  String get profileThemeSystemShort;

  /// No description provided for @profileFeedbackIdea.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ ý tưởng'**
  String get profileFeedbackIdea;

  /// No description provided for @profileFeedbackIdeaHint.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý tính năng mới hoặc cải tiến'**
  String get profileFeedbackIdeaHint;

  /// No description provided for @profileFeedbackBug.
  ///
  /// In vi, this message translates to:
  /// **'Báo lỗi'**
  String get profileFeedbackBug;

  /// No description provided for @profileFeedbackBugHint.
  ///
  /// In vi, this message translates to:
  /// **'Có gì đó không hoạt động như mong đợi'**
  String get profileFeedbackBugHint;

  /// No description provided for @profileSwitchedToSeller.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển sang chế độ người bán'**
  String get profileSwitchedToSeller;

  /// No description provided for @profileSwitchedToBuyer.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển sang chế độ người mua'**
  String get profileSwitchedToBuyer;

  /// No description provided for @profileSwitchModeFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể chuyển chế độ, vui lòng thử lại.'**
  String get profileSwitchModeFailed;

  /// No description provided for @profileBecomeSellerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trở thành người bán?'**
  String get profileBecomeSellerTitle;

  /// No description provided for @profileBecomeSellerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể đăng dịch vụ, nhận đơn và kiếm thu nhập trên VietGig. Bạn luôn có thể chuyển lại chế độ người mua.'**
  String get profileBecomeSellerMessage;

  /// No description provided for @profileBecomeSellerConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu bán'**
  String get profileBecomeSellerConfirm;

  /// No description provided for @profileSellerMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ người bán'**
  String get profileSellerMode;

  /// No description provided for @profileSellerModeOn.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý dịch vụ và đơn bán'**
  String get profileSellerModeOn;

  /// No description provided for @profileSellerModeOff.
  ///
  /// In vi, this message translates to:
  /// **'Bật để bắt đầu bán dịch vụ'**
  String get profileSellerModeOff;

  /// No description provided for @profileMyVietGig.
  ///
  /// In vi, this message translates to:
  /// **'VietGig của tôi'**
  String get profileMyVietGig;

  /// No description provided for @profileEarnings.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get profileEarnings;

  /// No description provided for @profileOfferTemplates.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu báo giá'**
  String get profileOfferTemplates;

  /// No description provided for @profileBuyerBriefs.
  ///
  /// In vi, this message translates to:
  /// **'Brief từ người mua'**
  String get profileBuyerBriefs;

  /// No description provided for @profileShareGigs.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ dịch vụ'**
  String get profileShareGigs;

  /// No description provided for @profileMyProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ của tôi'**
  String get profileMyProfile;

  /// No description provided for @profileAvailability.
  ///
  /// In vi, this message translates to:
  /// **'Lịch làm việc'**
  String get profileAvailability;

  /// No description provided for @profileSavedLists.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách đã lưu'**
  String get profileSavedLists;

  /// No description provided for @profileMyInterests.
  ///
  /// In vi, this message translates to:
  /// **'Sở thích của tôi'**
  String get profileMyInterests;

  /// No description provided for @profileBrowsingHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử xem'**
  String get profileBrowsingHistory;

  /// No description provided for @profileInviteFriends.
  ///
  /// In vi, this message translates to:
  /// **'Mời bạn bè'**
  String get profileInviteFriends;

  /// No description provided for @profileSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get profileSettings;

  /// No description provided for @profileSupport.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ'**
  String get profileSupport;

  /// No description provided for @profileBecomeSeller.
  ///
  /// In vi, this message translates to:
  /// **'Trở thành người bán'**
  String get profileBecomeSeller;

  /// No description provided for @profileNeedActivation.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần kích hoạt tài khoản'**
  String get profileNeedActivation;

  /// No description provided for @profileActivateAccount.
  ///
  /// In vi, this message translates to:
  /// **'Kích hoạt tài khoản'**
  String get profileActivateAccount;

  /// No description provided for @profileGuest.
  ///
  /// In vi, this message translates to:
  /// **'Khách'**
  String get profileGuest;

  /// No description provided for @profileGuestWelcome.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng đến VietGig!'**
  String get profileGuestWelcome;

  /// No description provided for @profileJoin.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia VietGig'**
  String get profileJoin;

  /// No description provided for @profileGeneral.
  ///
  /// In vi, this message translates to:
  /// **'Chung'**
  String get profileGeneral;

  /// No description provided for @profileVersion.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản {version}'**
  String profileVersion(String version);

  /// No description provided for @profileSignOutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất?'**
  String get profileSignOutTitle;

  /// No description provided for @profileSignOutMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ cần đăng nhập lại để tiếp tục mua và bán dịch vụ.'**
  String get profileSignOutMessage;

  /// No description provided for @profileSignOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get profileSignOut;

  /// No description provided for @profileSignOutFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất thất bại, vui lòng thử lại.'**
  String get profileSignOutFailed;

  /// No description provided for @profileAccountInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin tài khoản'**
  String get profileAccountInfo;

  /// No description provided for @profileUsername.
  ///
  /// In vi, this message translates to:
  /// **'Tên người dùng'**
  String get profileUsername;

  /// No description provided for @profileFullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get profileFullName;

  /// No description provided for @profileEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileVerified.
  ///
  /// In vi, this message translates to:
  /// **'Đã xác minh'**
  String get profileVerified;

  /// No description provided for @profileUnverified.
  ///
  /// In vi, this message translates to:
  /// **'Chưa xác minh'**
  String get profileUnverified;

  /// No description provided for @profileEditProfile.
  ///
  /// In vi, this message translates to:
  /// **'Sửa hồ sơ'**
  String get profileEditProfile;

  /// No description provided for @profilePersonalBalance.
  ///
  /// In vi, this message translates to:
  /// **'Số dư cá nhân'**
  String get profilePersonalBalance;

  /// No description provided for @profileManageAccount.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý tài khoản'**
  String get profileManageAccount;

  /// No description provided for @profileDeactivateAndDelete.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ kích hoạt & xoá tài khoản'**
  String get profileDeactivateAndDelete;

  /// No description provided for @profilePrivacy.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư'**
  String get profilePrivacy;

  /// No description provided for @profilePrivacySearchVisible.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị hồ sơ trên công cụ tìm kiếm'**
  String get profilePrivacySearchVisible;

  /// No description provided for @profilePrivacyPersonalized.
  ///
  /// In vi, this message translates to:
  /// **'Cho phép cá nhân hoá gợi ý dịch vụ'**
  String get profilePrivacyPersonalized;

  /// No description provided for @profilePrivacyShareUsage.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ dữ liệu sử dụng ẩn danh'**
  String get profilePrivacyShareUsage;

  /// No description provided for @profilePrivacySaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu cài đặt quyền riêng tư'**
  String get profilePrivacySaved;

  /// No description provided for @profileOnlineStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái online'**
  String get profileOnlineStatus;

  /// No description provided for @profileOnlineStatusHint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ hiển thị online khi đang mở ứng dụng.'**
  String get profileOnlineStatusHint;

  /// No description provided for @profileOnlineShown.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang hiển thị online'**
  String get profileOnlineShown;

  /// No description provided for @profileOnlineHidden.
  ///
  /// In vi, this message translates to:
  /// **'Đã ẩn trạng thái online'**
  String get profileOnlineHidden;

  /// No description provided for @profileResetLinkSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi liên kết đổi mật khẩu tới email của bạn'**
  String get profileResetLinkSent;

  /// No description provided for @profileChangePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get profileChangePassword;

  /// No description provided for @profileChangePasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhận liên kết đặt lại mật khẩu qua email'**
  String get profileChangePasswordHint;

  /// No description provided for @profileTwoFactor.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực 2 lớp'**
  String get profileTwoFactor;

  /// No description provided for @profileTwoFactorHint.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu mã xác minh khi đăng nhập trên thiết bị mới'**
  String get profileTwoFactorHint;

  /// No description provided for @profileTwoFactorOn.
  ///
  /// In vi, this message translates to:
  /// **'Đã bật xác thực 2 lớp'**
  String get profileTwoFactorOn;

  /// No description provided for @profileTwoFactorOff.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt xác thực 2 lớp'**
  String get profileTwoFactorOff;

  /// No description provided for @profileLanguageChanged.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển ngôn ngữ sang {language}'**
  String profileLanguageChanged(String language);

  /// No description provided for @profilePushTab.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đẩy'**
  String get profilePushTab;

  /// No description provided for @profileEmailTab.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get profileEmailTab;

  /// No description provided for @profileSendTestPush.
  ///
  /// In vi, this message translates to:
  /// **'Gửi thông báo thử'**
  String get profileSendTestPush;

  /// No description provided for @profileTestPushSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi thông báo thử tới thiết bị của bạn'**
  String get profileTestPushSent;

  /// No description provided for @profileSendTestEmail.
  ///
  /// In vi, this message translates to:
  /// **'Gửi email thử'**
  String get profileSendTestEmail;

  /// No description provided for @profileTestEmailSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi email thử tới hộp thư của bạn'**
  String get profileTestEmailSent;

  /// No description provided for @profileCurrencyVnd.
  ///
  /// In vi, this message translates to:
  /// **'Đồng Việt Nam'**
  String get profileCurrencyVnd;

  /// No description provided for @profileCurrencyUsd.
  ///
  /// In vi, this message translates to:
  /// **'Đô la Mỹ'**
  String get profileCurrencyUsd;

  /// No description provided for @profileCurrencyEur.
  ///
  /// In vi, this message translates to:
  /// **'Euro'**
  String get profileCurrencyEur;

  /// No description provided for @profileCurrencyGbp.
  ///
  /// In vi, this message translates to:
  /// **'Bảng Anh'**
  String get profileCurrencyGbp;

  /// No description provided for @profileCurrencyJpy.
  ///
  /// In vi, this message translates to:
  /// **'Yên Nhật'**
  String get profileCurrencyJpy;

  /// No description provided for @profileCurrencyKrw.
  ///
  /// In vi, this message translates to:
  /// **'Won Hàn Quốc'**
  String get profileCurrencyKrw;

  /// No description provided for @profileCurrencyCny.
  ///
  /// In vi, this message translates to:
  /// **'Nhân dân tệ'**
  String get profileCurrencyCny;

  /// No description provided for @profileCurrencySgd.
  ///
  /// In vi, this message translates to:
  /// **'Đô la Singapore'**
  String get profileCurrencySgd;

  /// No description provided for @profileCurrencyThb.
  ///
  /// In vi, this message translates to:
  /// **'Baht Thái'**
  String get profileCurrencyThb;

  /// No description provided for @profileCurrencyAud.
  ///
  /// In vi, this message translates to:
  /// **'Đô la Úc'**
  String get profileCurrencyAud;

  /// No description provided for @profileCurrencyCad.
  ///
  /// In vi, this message translates to:
  /// **'Đô la Canada'**
  String get profileCurrencyCad;

  /// No description provided for @profileCurrencyChanged.
  ///
  /// In vi, this message translates to:
  /// **'Đã đổi tiền tệ hiển thị sang {currency}'**
  String profileCurrencyChanged(String currency);

  /// No description provided for @profileAppearanceSystemNote.
  ///
  /// In vi, this message translates to:
  /// **'Nếu chọn \"Hệ thống\", VietGig sẽ tự động điều chỉnh giao diện theo cài đặt của thiết bị.'**
  String get profileAppearanceSystemNote;

  /// No description provided for @profileBalanceHelpEarningsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get profileBalanceHelpEarningsTitle;

  /// No description provided for @profileBalanceHelpEarnings.
  ///
  /// In vi, this message translates to:
  /// **'Tiền bạn kiếm được từ dịch vụ của mình. Có thể rút về ngân hàng hoặc dùng để mua dịch vụ.'**
  String get profileBalanceHelpEarnings;

  /// No description provided for @profileBalanceHelpRefundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Số dư từ đơn đã huỷ'**
  String get profileBalanceHelpRefundTitle;

  /// No description provided for @profileBalanceHelpRefund.
  ///
  /// In vi, this message translates to:
  /// **'Khoản tiền được hoàn từ các đơn hàng đã huỷ, có thể dùng cho lần mua tiếp theo.'**
  String get profileBalanceHelpRefund;

  /// No description provided for @profileBalanceHelpCreditsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Credits'**
  String get profileBalanceHelpCreditsTitle;

  /// No description provided for @profileBalanceHelpCredits.
  ///
  /// In vi, this message translates to:
  /// **'Credits được dùng khi thanh toán đơn hàng. Hãy kiểm tra hạn sử dụng để không bị mất.'**
  String get profileBalanceHelpCredits;

  /// No description provided for @profileBalanceHelpPayTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán bằng số dư'**
  String get profileBalanceHelpPayTitle;

  /// No description provided for @profileBalanceHelpPay.
  ///
  /// In vi, this message translates to:
  /// **'Khi có số dư, bạn có thể dùng tiền và credits làm phương thức thanh toán chính cho đơn mới.'**
  String get profileBalanceHelpPay;

  /// No description provided for @profileBalanceExplain.
  ///
  /// In vi, this message translates to:
  /// **'Giải thích'**
  String get profileBalanceExplain;

  /// No description provided for @profileBalanceVietGig.
  ///
  /// In vi, this message translates to:
  /// **'Số dư VietGig'**
  String get profileBalanceVietGig;

  /// No description provided for @profileBalanceFromCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Từ đơn đã huỷ'**
  String get profileBalanceFromCancelled;

  /// No description provided for @profileBalanceCreditsVietGig.
  ///
  /// In vi, this message translates to:
  /// **'Credits VietGig'**
  String get profileBalanceCreditsVietGig;

  /// No description provided for @profileBalanceCredits.
  ///
  /// In vi, this message translates to:
  /// **'Credits'**
  String get profileBalanceCredits;

  /// No description provided for @profileBalanceMoreCredits.
  ///
  /// In vi, this message translates to:
  /// **'Muốn có thêm credits? Giới thiệu bạn bè và nhận ưu đãi hấp dẫn!'**
  String get profileBalanceMoreCredits;

  /// No description provided for @profileBalanceGetCredits.
  ///
  /// In vi, this message translates to:
  /// **'Nhận credits VietGig'**
  String get profileBalanceGetCredits;

  /// No description provided for @profileReasonEmails.
  ///
  /// In vi, this message translates to:
  /// **'Tôi muốn huỷ đăng ký nhận email từ VietGig'**
  String get profileReasonEmails;

  /// No description provided for @profileReasonUsername.
  ///
  /// In vi, this message translates to:
  /// **'Tôi muốn đổi tên người dùng'**
  String get profileReasonUsername;

  /// No description provided for @profileReasonOtherAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tôi có một tài khoản VietGig khác'**
  String get profileReasonOtherAccount;

  /// No description provided for @profileReasonNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Tôi không tìm được thứ mình cần'**
  String get profileReasonNotFound;

  /// No description provided for @profileReasonComplex.
  ///
  /// In vi, this message translates to:
  /// **'VietGig phức tạp hoặc khó sử dụng'**
  String get profileReasonComplex;

  /// No description provided for @profileReasonBadSeller.
  ///
  /// In vi, this message translates to:
  /// **'Trải nghiệm không tốt với người bán'**
  String get profileReasonBadSeller;

  /// No description provided for @profileReasonPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Tôi không hài lòng với chính sách của VietGig'**
  String get profileReasonPolicy;

  /// No description provided for @profileReasonOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get profileReasonOther;

  /// No description provided for @profileDeactivateConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ kích hoạt tài khoản?'**
  String get profileDeactivateConfirmTitle;

  /// No description provided for @profileDeactivateConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ của bạn sẽ bị ẩn và các đơn đang thực hiện sẽ bị huỷ. Bạn có thể kích hoạt lại bằng cách đăng nhập.'**
  String get profileDeactivateConfirmMessage;

  /// No description provided for @profileDeactivateConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ kích hoạt'**
  String get profileDeactivateConfirm;

  /// No description provided for @profileDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá vĩnh viễn tài khoản?'**
  String get profileDeleteConfirmTitle;

  /// No description provided for @profileDeleteConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Thao tác này không thể hoàn tác.'**
  String get profileDeleteConfirmMessage;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In vi, this message translates to:
  /// **'Xoá tài khoản'**
  String get profileDeleteAccount;

  /// No description provided for @profileActionNotAllowed.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể thực hiện thao tác này'**
  String get profileActionNotAllowed;

  /// No description provided for @profileGenericError.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra, vui lòng thử lại.'**
  String get profileGenericError;

  /// No description provided for @profileDeactivateAccount.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ kích hoạt tài khoản'**
  String get profileDeactivateAccount;

  /// No description provided for @profileContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get profileContinue;

  /// No description provided for @profileContinueDelete.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục xoá tài khoản'**
  String get profileContinueDelete;

  /// No description provided for @profileDeactivateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ kích hoạt & xoá'**
  String get profileDeactivateTitle;

  /// No description provided for @profileDeactivateHeading.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ kích hoạt hoặc xoá tài khoản VietGig'**
  String get profileDeactivateHeading;

  /// No description provided for @profileDeactivateIntro.
  ///
  /// In vi, this message translates to:
  /// **'Nếu bạn muốn tạm ngưng sử dụng, hãy huỷ kích hoạt tài khoản. Nếu muốn xoá vĩnh viễn toàn bộ dữ liệu khỏi VietGig, hãy chọn xoá tài khoản.'**
  String get profileDeactivateIntro;

  /// No description provided for @profileDeactivateDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ của bạn sẽ không hiển thị trên VietGig. Các đơn đang thực hiện sẽ bị huỷ.'**
  String get profileDeactivateDescription;

  /// No description provided for @profileDeleteDescription.
  ///
  /// In vi, this message translates to:
  /// **'Xoá tài khoản là vĩnh viễn và không thể khôi phục. Bạn sẽ không thể lấy lại tệp hoặc thông tin từ các đơn hàng trên VietGig.'**
  String get profileDeleteDescription;

  /// No description provided for @profileDeleteWhatHappens.
  ///
  /// In vi, this message translates to:
  /// **'Điều gì xảy ra khi bạn xoá tài khoản?'**
  String get profileDeleteWhatHappens;

  /// No description provided for @profileDeletePermanentNote.
  ///
  /// In vi, this message translates to:
  /// **'Quá trình xoá là vĩnh viễn và không thể hoàn tác. Có thể mất tới 30 ngày để hoàn tất.'**
  String get profileDeletePermanentNote;

  /// No description provided for @profileDeleteBulletUsername.
  ///
  /// In vi, this message translates to:
  /// **'Tên người dùng gắn với tài khoản này sẽ không thể dùng lại cho tài khoản mới.'**
  String get profileDeleteBulletUsername;

  /// No description provided for @profileDeleteBulletData.
  ///
  /// In vi, this message translates to:
  /// **'Toàn bộ tin nhắn, đơn hàng, đánh giá và danh sách đã lưu sẽ bị xoá.'**
  String get profileDeleteBulletData;

  /// No description provided for @profileDeleteBulletBalance.
  ///
  /// In vi, this message translates to:
  /// **'Số dư và credits chưa sử dụng sẽ bị huỷ.'**
  String get profileDeleteBulletBalance;

  /// No description provided for @profileDeleteBulletReview.
  ///
  /// In vi, this message translates to:
  /// **'Bạn nên xem lại các đơn hàng và tải về tệp cần thiết trước khi xoá.'**
  String get profileDeleteBulletReview;

  /// No description provided for @profileLeavingBecause.
  ///
  /// In vi, this message translates to:
  /// **'Tôi rời đi vì'**
  String get profileLeavingBecause;

  /// No description provided for @profileTellUsMore.
  ///
  /// In vi, this message translates to:
  /// **'Hãy cho chúng tôi biết thêm (không bắt buộc)'**
  String get profileTellUsMore;

  /// No description provided for @profileTellUsMoreHint.
  ///
  /// In vi, this message translates to:
  /// **'Giúp chúng tôi làm tốt hơn...'**
  String get profileTellUsMoreHint;

  /// No description provided for @profileSpokenVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get profileSpokenVietnamese;

  /// No description provided for @profileSpokenEnglish.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get profileSpokenEnglish;

  /// No description provided for @profileSpokenChinese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Trung'**
  String get profileSpokenChinese;

  /// No description provided for @profileSpokenJapanese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Nhật'**
  String get profileSpokenJapanese;

  /// No description provided for @profileSpokenKorean.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Hàn'**
  String get profileSpokenKorean;

  /// No description provided for @profileSpokenFrench.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Pháp'**
  String get profileSpokenFrench;

  /// No description provided for @profileSkillEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên kỹ năng'**
  String get profileSkillEmpty;

  /// No description provided for @profileSkillDuplicate.
  ///
  /// In vi, this message translates to:
  /// **'Kỹ năng này đã có'**
  String get profileSkillDuplicate;

  /// No description provided for @profileSkillMax.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa {max} kỹ năng'**
  String profileSkillMax(int max);

  /// No description provided for @profileNameTooShort.
  ///
  /// In vi, this message translates to:
  /// **'Họ tên phải có ít nhất 2 ký tự'**
  String get profileNameTooShort;

  /// No description provided for @profileLanguageRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ít nhất một ngôn ngữ'**
  String get profileLanguageRequired;

  /// No description provided for @profileSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu hồ sơ'**
  String get profileSaved;

  /// No description provided for @profileSaveFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được hồ sơ, vui lòng thử lại.'**
  String get profileSaveFailed;

  /// No description provided for @profileChangeAvatar.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh đại diện'**
  String get profileChangeAvatar;

  /// No description provided for @profileAvatarUploadSoon.
  ///
  /// In vi, this message translates to:
  /// **'Tải ảnh đại diện sẽ có khi kết nối máy chủ'**
  String get profileAvatarUploadSoon;

  /// No description provided for @profileNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Nguyễn Minh Anh'**
  String get profileNameHint;

  /// No description provided for @profileHeadline.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu ngắn'**
  String get profileHeadline;

  /// No description provided for @profileHeadlineHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Chủ cửa hàng thời trang online'**
  String get profileHeadlineHint;

  /// No description provided for @profileBio.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả về bạn'**
  String get profileBio;

  /// No description provided for @profileBioHint.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ đôi chút về bạn, công việc và điều bạn đang tìm kiếm...'**
  String get profileBioHint;

  /// No description provided for @profileSkills.
  ///
  /// In vi, this message translates to:
  /// **'Kỹ năng'**
  String get profileSkills;

  /// No description provided for @profileSkillHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Figma, Copywriting'**
  String get profileSkillHint;

  /// No description provided for @profileAddSkill.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get profileAddSkill;

  /// No description provided for @profileNoSkills.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có kỹ năng nào.'**
  String get profileNoSkills;

  /// No description provided for @profileSaveChanges.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get profileSaveChanges;

  /// No description provided for @profileAreaNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get profileAreaNotifications;

  /// No description provided for @profileAreaInbox.
  ///
  /// In vi, this message translates to:
  /// **'Hộp thư'**
  String get profileAreaInbox;

  /// No description provided for @profileAreaSearch.
  ///
  /// In vi, this message translates to:
  /// **'Tìm dịch vụ'**
  String get profileAreaSearch;

  /// No description provided for @profileAreaPayments.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get profileAreaPayments;

  /// No description provided for @profileAreaOrders.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý đơn'**
  String get profileAreaOrders;

  /// No description provided for @profileAreaOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get profileAreaOther;

  /// No description provided for @profileAttachFile.
  ///
  /// In vi, this message translates to:
  /// **'Đính kèm tệp'**
  String get profileAttachFile;

  /// No description provided for @profileAttachScreenshot.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh chụp màn hình'**
  String get profileAttachScreenshot;

  /// No description provided for @profileAttachDocument.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu'**
  String get profileAttachDocument;

  /// No description provided for @profileFeedbackThanksBug.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã báo lỗi'**
  String get profileFeedbackThanksBug;

  /// No description provided for @profileFeedbackThanksIdea.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã chia sẻ ý tưởng'**
  String get profileFeedbackThanksIdea;

  /// No description provided for @profileFeedbackThanksBugMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đội ngũ kỹ thuật sẽ kiểm tra và khắc phục sớm nhất có thể.'**
  String get profileFeedbackThanksBugMessage;

  /// No description provided for @profileFeedbackThanksIdeaMessage.
  ///
  /// In vi, this message translates to:
  /// **'Góp ý của bạn giúp VietGig ngày càng tốt hơn cho cộng đồng.'**
  String get profileFeedbackThanksIdeaMessage;

  /// No description provided for @profileFeedbackSendFailed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi thất bại, vui lòng thử lại.'**
  String get profileFeedbackSendFailed;

  /// No description provided for @profileFeedbackAreaBug.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xảy ra ở khu vực nào?'**
  String get profileFeedbackAreaBug;

  /// No description provided for @profileFeedbackAreaIdea.
  ///
  /// In vi, this message translates to:
  /// **'Ý tưởng liên quan khu vực nào?'**
  String get profileFeedbackAreaIdea;

  /// No description provided for @profileFeedbackAreaRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn một khu vực'**
  String get profileFeedbackAreaRequired;

  /// No description provided for @profileFeedbackDescribeBug.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả lỗi bạn gặp phải'**
  String get profileFeedbackDescribeBug;

  /// No description provided for @profileFeedbackDescribeIdea.
  ///
  /// In vi, this message translates to:
  /// **'Kể cho chúng tôi về ý tưởng của bạn'**
  String get profileFeedbackDescribeIdea;

  /// No description provided for @profileFeedbackBugHintText.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã làm gì, điều gì xảy ra và bạn mong đợi điều gì?'**
  String get profileFeedbackBugHintText;

  /// No description provided for @profileFeedbackIdeaHintText.
  ///
  /// In vi, this message translates to:
  /// **'Ý tưởng của bạn là tính năng mới hay thay đổi tính năng hiện có? Nó sẽ giúp trải nghiệm tốt hơn thế nào?'**
  String get profileFeedbackIdeaHintText;

  /// No description provided for @profileFeedbackMinChars.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập ít nhất {n} ký tự'**
  String profileFeedbackMinChars(int n);

  /// No description provided for @profileRemoveFile.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ tệp'**
  String get profileRemoveFile;

  /// No description provided for @profileFeedbackCanContact.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi có thể liên hệ bạn nếu có câu hỏi không?'**
  String get profileFeedbackCanContact;

  /// No description provided for @profileFeedbackContactYes.
  ///
  /// In vi, this message translates to:
  /// **'Có, sẵn lòng trao đổi'**
  String get profileFeedbackContactYes;

  /// No description provided for @profileFeedbackContactNo.
  ///
  /// In vi, this message translates to:
  /// **'Không, lúc này thì không'**
  String get profileFeedbackContactNo;

  /// No description provided for @profileFeedbackChoiceRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn một lựa chọn'**
  String get profileFeedbackChoiceRequired;

  /// No description provided for @profileFeedbackSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get profileFeedbackSubmit;

  /// No description provided for @profileShareVia.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ qua'**
  String get profileShareVia;

  /// No description provided for @profileShareSms.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn SMS'**
  String get profileShareSms;

  /// No description provided for @profileShareLinkCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép liên kết – dán vào {app} để gửi cho bạn bè'**
  String profileShareLinkCopied(String app);

  /// No description provided for @profileInviteHeadline.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ & nhận tới 2.500.000 ₫'**
  String get profileInviteHeadline;

  /// No description provided for @profileInviteBody.
  ///
  /// In vi, this message translates to:
  /// **'Tặng bạn bè giảm 10% cho đơn đầu tiên, bạn nhận 10% giá trị đơn của họ dưới dạng credits.'**
  String get profileInviteBody;

  /// No description provided for @profileReferralCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã giới thiệu của bạn'**
  String get profileReferralCode;

  /// No description provided for @profileCodeCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép mã giới thiệu'**
  String get profileCodeCopied;

  /// No description provided for @profileCopy.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép'**
  String get profileCopy;

  /// No description provided for @profileInviteLinkCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép liên kết mời'**
  String get profileInviteLinkCopied;

  /// No description provided for @profileCopyLink.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép link'**
  String get profileCopyLink;

  /// No description provided for @profileShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get profileShare;

  /// No description provided for @profileHowItWorks.
  ///
  /// In vi, this message translates to:
  /// **'Cách hoạt động'**
  String get profileHowItWorks;

  /// No description provided for @profileInviteStep1Title.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời mời'**
  String get profileInviteStep1Title;

  /// No description provided for @profileInviteStep1.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ mã hoặc liên kết giới thiệu cho bạn bè.'**
  String get profileInviteStep1;

  /// No description provided for @profileInviteStep2Title.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè đặt đơn đầu tiên'**
  String get profileInviteStep2Title;

  /// No description provided for @profileInviteStep2.
  ///
  /// In vi, this message translates to:
  /// **'Họ được giảm 10% cho đơn hàng đầu tiên trên VietGig.'**
  String get profileInviteStep2;

  /// No description provided for @profileInviteStep3Title.
  ///
  /// In vi, this message translates to:
  /// **'Bạn nhận credits'**
  String get profileInviteStep3Title;

  /// No description provided for @profileInviteStep3.
  ///
  /// In vi, this message translates to:
  /// **'Nhận 10% giá trị đơn, tối đa 2.500.000 ₫ trong 12 tháng.'**
  String get profileInviteStep3;

  /// No description provided for @profileGotIt.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiểu'**
  String get profileGotIt;

  /// No description provided for @profilePushEnabled.
  ///
  /// In vi, this message translates to:
  /// **'Đã bật thông báo đẩy'**
  String get profilePushEnabled;

  /// No description provided for @profileMarkedAllRead.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu tất cả là đã đọc'**
  String get profileMarkedAllRead;

  /// No description provided for @profileMarkAllRead.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu đã đọc'**
  String get profileMarkAllRead;

  /// No description provided for @profileNotifEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luôn cập nhật'**
  String get profileNotifEmptyTitle;

  /// No description provided for @profileNotifEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bật thông báo đẩy để không bỏ lỡ tin nhắn, cập nhật đơn hàng và ưu đãi.'**
  String get profileNotifEmptyMessage;

  /// No description provided for @profileEnablePush.
  ///
  /// In vi, this message translates to:
  /// **'Bật thông báo đẩy'**
  String get profileEnablePush;

  /// No description provided for @profileNotifToday.
  ///
  /// In vi, this message translates to:
  /// **'HÔM NAY'**
  String get profileNotifToday;

  /// No description provided for @profileNotifEarlier.
  ///
  /// In vi, this message translates to:
  /// **'TRƯỚC ĐÓ'**
  String get profileNotifEarlier;

  /// No description provided for @profileNotifDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá thông báo'**
  String get profileNotifDeleted;

  /// No description provided for @profileAccountNotice.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo tài khoản'**
  String get profileAccountNotice;

  /// No description provided for @profileAccountNoticeUnverified.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi email xác nhận. Hãy kiểm tra hộp thư và kích hoạt tài khoản để dùng đầy đủ tính năng.'**
  String get profileAccountNoticeUnverified;

  /// No description provided for @profileAccountNoticeComplete.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thiện hồ sơ giúp người bán hiểu rõ bạn hơn và phản hồi nhanh hơn.'**
  String get profileAccountNoticeComplete;

  /// No description provided for @profileActivateEmailLink.
  ///
  /// In vi, this message translates to:
  /// **'Kích hoạt email →'**
  String get profileActivateEmailLink;

  /// No description provided for @profileUpdateProfileLink.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật hồ sơ →'**
  String get profileUpdateProfileLink;

  /// No description provided for @profileFaq.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp'**
  String get profileFaq;

  /// No description provided for @profileFaqOrderQ.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để đặt một dịch vụ?'**
  String get profileFaqOrderQ;

  /// No description provided for @profileFaqOrderA.
  ///
  /// In vi, this message translates to:
  /// **'Tìm dịch vụ phù hợp, chọn gói, bấm \"Tiếp tục\" và thanh toán. Sau đó gửi yêu cầu để người bán bắt đầu làm việc.'**
  String get profileFaqOrderA;

  /// No description provided for @profileFaqSafeQ.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán trên VietGig có an toàn không?'**
  String get profileFaqSafeQ;

  /// No description provided for @profileFaqSafeA.
  ///
  /// In vi, this message translates to:
  /// **'Tiền của bạn được VietGig giữ an toàn và chỉ chuyển cho người bán khi bạn chấp nhận bản giao.'**
  String get profileFaqSafeA;

  /// No description provided for @profileFaqCancelQ.
  ///
  /// In vi, this message translates to:
  /// **'Tôi có thể huỷ đơn hàng không?'**
  String get profileFaqCancelQ;

  /// No description provided for @profileFaqCancelA.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể gửi yêu cầu huỷ trong Trung tâm giải quyết của đơn hàng. Tiền hoàn sẽ vào Số dư VietGig.'**
  String get profileFaqCancelA;

  /// No description provided for @profileFaqSellerQ.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để trở thành người bán?'**
  String get profileFaqSellerQ;

  /// No description provided for @profileFaqSellerA.
  ///
  /// In vi, this message translates to:
  /// **'Vào tab Tài khoản, bật \"Chế độ người bán\" rồi tạo dịch vụ đầu tiên của bạn.'**
  String get profileFaqSellerA;

  /// No description provided for @profileFaqPayoutQ.
  ///
  /// In vi, this message translates to:
  /// **'Khi nào tôi nhận được tiền từ đơn bán?'**
  String get profileFaqPayoutQ;

  /// No description provided for @profileFaqPayoutA.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập sẽ khả dụng để rút sau 7 ngày kể từ khi đơn hàng hoàn tất.'**
  String get profileFaqPayoutA;

  /// No description provided for @profileFaqPasswordQ.
  ///
  /// In vi, this message translates to:
  /// **'Tôi quên mật khẩu thì phải làm sao?'**
  String get profileFaqPasswordQ;

  /// No description provided for @profileFaqPasswordA.
  ///
  /// In vi, this message translates to:
  /// **'Tại màn Đăng nhập, chọn \"Quên mật khẩu?\" và nhập email để nhận liên kết đặt lại.'**
  String get profileFaqPasswordA;

  /// No description provided for @profileContactUs.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ với chúng tôi'**
  String get profileContactUs;

  /// No description provided for @profileSupportEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email hỗ trợ'**
  String get profileSupportEmail;

  /// No description provided for @profileSupportEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'{email} · phản hồi trong 24 giờ'**
  String profileSupportEmailHint(String email);

  /// No description provided for @profileSupportEmailCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép địa chỉ email hỗ trợ'**
  String get profileSupportEmailCopied;

  /// No description provided for @profileHotline.
  ///
  /// In vi, this message translates to:
  /// **'Hotline'**
  String get profileHotline;

  /// No description provided for @profileHotlineHint.
  ///
  /// In vi, this message translates to:
  /// **'{phone} · 8:00 – 22:00 hằng ngày'**
  String profileHotlineHint(String phone);

  /// No description provided for @profileHotlineCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép số hotline'**
  String get profileHotlineCopied;

  /// No description provided for @profileSupportRequest.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu hỗ trợ'**
  String get profileSupportRequest;

  /// No description provided for @profileSupportRequestHint.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả vấn đề, chúng tôi sẽ liên hệ lại'**
  String get profileSupportRequestHint;

  /// No description provided for @profileSupportRequestSignIn.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để gửi yêu cầu'**
  String get profileSupportRequestSignIn;

  /// No description provided for @profileNewEmailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email mới'**
  String get profileNewEmailRequired;

  /// No description provided for @profileEmailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get profileEmailInvalid;

  /// No description provided for @profileEmailMustDiffer.
  ///
  /// In vi, this message translates to:
  /// **'Email mới phải khác email hiện tại'**
  String get profileEmailMustDiffer;

  /// No description provided for @profileEmailUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Email đã được cập nhật và đã gửi thư xác nhận.'**
  String get profileEmailUpdated;

  /// No description provided for @profileUpdateEmailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật địa chỉ email'**
  String get profileUpdateEmailTitle;

  /// No description provided for @profileUpdateEmailIntro.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ gửi email xác nhận tới địa chỉ mới của bạn.'**
  String get profileUpdateEmailIntro;

  /// No description provided for @profileCurrentEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email hiện tại'**
  String get profileCurrentEmail;

  /// No description provided for @profileNewEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email mới'**
  String get profileNewEmail;

  /// No description provided for @profileEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'vidu@email.com'**
  String get profileEmailHint;

  /// No description provided for @profileUpdateEmailSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật & gửi'**
  String get profileUpdateEmailSubmit;

  /// No description provided for @savedHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử xem'**
  String get savedHistoryTitle;

  /// No description provided for @savedHistoryClearTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá toàn bộ lịch sử xem?'**
  String get savedHistoryClearTitle;

  /// No description provided for @savedHistoryClearMessage.
  ///
  /// In vi, this message translates to:
  /// **'Các dịch vụ đã xem gần đây sẽ bị xoá khỏi tài khoản của bạn.'**
  String get savedHistoryClearMessage;

  /// No description provided for @savedClearAll.
  ///
  /// In vi, this message translates to:
  /// **'Xoá tất cả'**
  String get savedClearAll;

  /// No description provided for @savedHistoryCleared.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá lịch sử xem'**
  String get savedHistoryCleared;

  /// No description provided for @savedEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get savedEdit;

  /// No description provided for @savedHistoryEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dịch vụ đã xem'**
  String get savedHistoryEmptyTitle;

  /// No description provided for @savedHistoryEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Các dịch vụ bạn xem sẽ xuất hiện ở đây để dễ dàng quay lại.'**
  String get savedHistoryEmptyMessage;

  /// No description provided for @savedExploreVietGig.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá VietGig'**
  String get savedExploreVietGig;

  /// No description provided for @savedHistoryRecent.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ đã xem gần đây'**
  String get savedHistoryRecent;

  /// No description provided for @savedHistoryRemoved.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá khỏi lịch sử xem'**
  String get savedHistoryRemoved;

  /// No description provided for @savedNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên danh sách'**
  String get savedNameRequired;

  /// No description provided for @savedListsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách của tôi'**
  String get savedListsTitle;

  /// No description provided for @savedCreateList.
  ///
  /// In vi, this message translates to:
  /// **'+ Tạo danh sách'**
  String get savedCreateList;

  /// No description provided for @savedListExists.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã có danh sách tên \"{name}\"'**
  String savedListExists(String name);

  /// No description provided for @savedListCreated.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạo danh sách \"{name}\"'**
  String savedListCreated(String name);

  /// No description provided for @savedListsEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lưu các dịch vụ bạn thích'**
  String get savedListsEmptyTitle;

  /// No description provided for @savedListsEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp dịch vụ và người bán yêu thích vào các danh sách riêng.'**
  String get savedListsEmptyMessage;

  /// No description provided for @savedPublicTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách công khai'**
  String get savedPublicTitle;

  /// No description provided for @savedPublicSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ai có liên kết đều xem được'**
  String get savedPublicSubtitle;

  /// No description provided for @savedShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get savedShare;

  /// No description provided for @savedRename.
  ///
  /// In vi, this message translates to:
  /// **'Đổi tên'**
  String get savedRename;

  /// No description provided for @savedDeleteList.
  ///
  /// In vi, this message translates to:
  /// **'Xoá danh sách'**
  String get savedDeleteList;

  /// No description provided for @savedMakePublicTitle.
  ///
  /// In vi, this message translates to:
  /// **'Công khai danh sách?'**
  String get savedMakePublicTitle;

  /// No description provided for @savedMakePublicMessage.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách đang ở chế độ riêng tư. Bật công khai để người nhận liên kết có thể xem.'**
  String get savedMakePublicMessage;

  /// No description provided for @savedMakePublicConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Công khai & chia sẻ'**
  String get savedMakePublicConfirm;

  /// No description provided for @savedRenameTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đổi tên danh sách'**
  String get savedRenameTitle;

  /// No description provided for @savedRenamed.
  ///
  /// In vi, this message translates to:
  /// **'Đã đổi tên thành \"{name}\"'**
  String savedRenamed(String name);

  /// No description provided for @savedDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá danh sách này?'**
  String get savedDeleteTitle;

  /// No description provided for @savedDeleteMessage.
  ///
  /// In vi, this message translates to:
  /// **'Các dịch vụ và người bán trong \"{name}\" sẽ bị bỏ khỏi danh sách. Không thể hoàn tác.'**
  String savedDeleteMessage(String name);

  /// No description provided for @savedListDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá danh sách \"{name}\"'**
  String savedListDeleted(String name);

  /// No description provided for @savedRemovedFrom.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ khỏi \"{name}\"'**
  String savedRemovedFrom(String name);

  /// No description provided for @savedNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách không tồn tại'**
  String get savedNotFoundTitle;

  /// No description provided for @savedNotFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách này có thể đã bị xoá.'**
  String get savedNotFoundMessage;

  /// No description provided for @savedBackToLists.
  ///
  /// In vi, this message translates to:
  /// **'Về danh sách của tôi'**
  String get savedBackToLists;

  /// No description provided for @savedTabGigs.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ ({n})'**
  String savedTabGigs(int n);

  /// No description provided for @savedTabSellers.
  ///
  /// In vi, this message translates to:
  /// **'Người bán ({n})'**
  String savedTabSellers(int n);

  /// No description provided for @savedOptions.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn'**
  String get savedOptions;

  /// No description provided for @savedCreatedBy.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bởi {name}'**
  String savedCreatedBy(String name);

  /// No description provided for @savedCreatedByYou.
  ///
  /// In vi, this message translates to:
  /// **'bạn'**
  String get savedCreatedByYou;

  /// No description provided for @savedNoGigsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dịch vụ nào'**
  String get savedNoGigsTitle;

  /// No description provided for @savedNoGigsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bấm biểu tượng trái tim trên dịch vụ để lưu vào danh sách này.'**
  String get savedNoGigsMessage;

  /// No description provided for @savedExploreGigs.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá dịch vụ'**
  String get savedExploreGigs;

  /// No description provided for @savedUnsave.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ lưu'**
  String get savedUnsave;

  /// No description provided for @savedNoSellersTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có người bán nào'**
  String get savedNoSellersTitle;

  /// No description provided for @savedNoSellersMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bấm \"Lưu\" trên hồ sơ người bán để thêm vào danh sách này.'**
  String get savedNoSellersMessage;

  /// No description provided for @searchCategoryNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy danh mục'**
  String get searchCategoryNotFound;

  /// No description provided for @searchCategoryIntro.
  ///
  /// In vi, this message translates to:
  /// **'Thuê freelancer chuyên nghiệp cho {subtitle} và nhiều hơn nữa.'**
  String searchCategoryIntro(String subtitle);

  /// No description provided for @searchServiceCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} dịch vụ'**
  String searchServiceCount(String count);

  /// No description provided for @searchFeatured.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ nổi bật'**
  String get searchFeatured;

  /// No description provided for @searchNoGigsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dịch vụ'**
  String get searchNoGigsTitle;

  /// No description provided for @searchNoGigsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục này chưa có dịch vụ nào. Hãy quay lại sau nhé!'**
  String get searchNoGigsMessage;

  /// No description provided for @searchTabCategories.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get searchTabCategories;

  /// No description provided for @searchTabInterests.
  ///
  /// In vi, this message translates to:
  /// **'Sở thích'**
  String get searchTabInterests;

  /// No description provided for @searchInterestsGuestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá theo sở thích'**
  String get searchInterestsGuestTitle;

  /// No description provided for @searchInterestsGuestMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để chọn sở thích và nhận gợi ý dịch vụ phù hợp với bạn.'**
  String get searchInterestsGuestMessage;

  /// No description provided for @searchInterestsLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được sở thích'**
  String get searchInterestsLoadError;

  /// No description provided for @searchYourInterests.
  ///
  /// In vi, this message translates to:
  /// **'Sở thích của bạn'**
  String get searchYourInterests;

  /// No description provided for @searchEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get searchEdit;

  /// No description provided for @searchInterestsHint.
  ///
  /// In vi, this message translates to:
  /// **'Chọn sở thích để khám phá dịch vụ phù hợp hơn.'**
  String get searchInterestsHint;

  /// No description provided for @searchChooseInterests.
  ///
  /// In vi, this message translates to:
  /// **'Chọn sở thích'**
  String get searchChooseInterests;

  /// No description provided for @searchYouMayLike.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cũng có thể thích'**
  String get searchYouMayLike;

  /// No description provided for @searchAddInterest.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào sở thích'**
  String get searchAddInterest;

  /// No description provided for @searchInterestAdded.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm \"{name}\" vào sở thích'**
  String searchInterestAdded(String name);

  /// No description provided for @searchInterestsSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu sở thích của bạn'**
  String get searchInterestsSaved;

  /// No description provided for @searchSaveFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được: {error}'**
  String searchSaveFailed(String error);

  /// No description provided for @searchDeselectAll.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ chọn'**
  String get searchDeselectAll;

  /// No description provided for @searchInterestsIntro.
  ///
  /// In vi, this message translates to:
  /// **'Chọn những lĩnh vực bạn quan tâm, chúng tôi sẽ gợi ý dịch vụ phù hợp hơn.'**
  String get searchInterestsIntro;

  /// No description provided for @searchInterestsSelected.
  ///
  /// In vi, this message translates to:
  /// **'{n} sở thích đã chọn'**
  String searchInterestsSelected(int n);

  /// No description provided for @searchSellersHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm người bán'**
  String get searchSellersHint;

  /// No description provided for @searchTabGigs.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ'**
  String get searchTabGigs;

  /// No description provided for @searchTabSellers.
  ///
  /// In vi, this message translates to:
  /// **'Người bán'**
  String get searchTabSellers;

  /// No description provided for @searchSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý'**
  String get searchSuggestions;

  /// No description provided for @searchForQuery.
  ///
  /// In vi, this message translates to:
  /// **'Tìm \"{query}\"'**
  String searchForQuery(String query);

  /// No description provided for @searchFillField.
  ///
  /// In vi, this message translates to:
  /// **'Điền vào ô tìm kiếm'**
  String get searchFillField;

  /// No description provided for @searchHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử tìm kiếm'**
  String get searchHistory;

  /// No description provided for @searchClearHistory.
  ///
  /// In vi, this message translates to:
  /// **'Xoá lịch sử'**
  String get searchClearHistory;

  /// No description provided for @searchKeywordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập từ khoá như \"logo\", \"website\", \"dựng video\"…'**
  String get searchKeywordHint;

  /// No description provided for @searchRecentlyViewed.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ đã xem gần đây'**
  String get searchRecentlyViewed;

  /// No description provided for @searchManage.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý'**
  String get searchManage;

  /// No description provided for @searchSellersLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách người bán'**
  String get searchSellersLoadError;

  /// No description provided for @searchSellerNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy người bán'**
  String get searchSellerNotFound;

  /// No description provided for @searchSellerNoMatch.
  ///
  /// In vi, this message translates to:
  /// **'Không có người bán nào khớp với \"{query}\".'**
  String searchSellerNoMatch(String query);

  /// No description provided for @searchDeliveryTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian giao'**
  String get searchDeliveryTime;

  /// No description provided for @searchNoStyles.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có phong cách nào cho kết quả này'**
  String get searchNoStyles;

  /// No description provided for @searchStyle.
  ///
  /// In vi, this message translates to:
  /// **'Phong cách'**
  String get searchStyle;

  /// No description provided for @searchAllStyles.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả phong cách'**
  String get searchAllStyles;

  /// No description provided for @searchAllServices.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả dịch vụ'**
  String get searchAllServices;

  /// No description provided for @searchNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsFiltered.
  ///
  /// In vi, this message translates to:
  /// **'Hãy thử điều chỉnh hoặc xoá bộ lọc để xem thêm dịch vụ.'**
  String get searchNoResultsFiltered;

  /// No description provided for @searchNoResultsHint.
  ///
  /// In vi, this message translates to:
  /// **'Hãy thử từ khoá khác hoặc khám phá theo danh mục.'**
  String get searchNoResultsHint;

  /// No description provided for @searchClearFilters.
  ///
  /// In vi, this message translates to:
  /// **'Xoá bộ lọc'**
  String get searchClearFilters;

  /// No description provided for @searchBrowseCategories.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá danh mục'**
  String get searchBrowseCategories;

  /// No description provided for @searchRelated.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả liên quan'**
  String get searchRelated;

  /// No description provided for @searchChipAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get searchChipAll;

  /// No description provided for @searchChipAllCount.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả ({n})'**
  String searchChipAllCount(int n);

  /// No description provided for @searchChipCategory.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get searchChipCategory;

  /// No description provided for @searchChipIncludes.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ bao gồm'**
  String get searchChipIncludes;

  /// No description provided for @searchChipDelivery.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng'**
  String get searchChipDelivery;

  /// No description provided for @searchSellerLevel.
  ///
  /// In vi, this message translates to:
  /// **'Mức người bán'**
  String get searchSellerLevel;

  /// No description provided for @searchChipBudget.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách'**
  String get searchChipBudget;

  /// No description provided for @searchShopBy.
  ///
  /// In vi, this message translates to:
  /// **'Mua theo'**
  String get searchShopBy;

  /// No description provided for @searchSearching.
  ///
  /// In vi, this message translates to:
  /// **'Đang tìm…'**
  String get searchSearching;

  /// No description provided for @searchResultCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} kết quả'**
  String searchResultCount(String count);

  /// No description provided for @searchAny.
  ///
  /// In vi, this message translates to:
  /// **'Bất kỳ'**
  String get searchAny;

  /// No description provided for @searchDelivery24h.
  ///
  /// In vi, this message translates to:
  /// **'Trong 24 giờ'**
  String get searchDelivery24h;

  /// No description provided for @searchDeliveryUpTo.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa {n} ngày'**
  String searchDeliveryUpTo(int n);

  /// No description provided for @searchFilterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bộ lọc'**
  String get searchFilterTitle;

  /// No description provided for @searchClearAll.
  ///
  /// In vi, this message translates to:
  /// **'Xoá tất cả'**
  String get searchClearAll;

  /// No description provided for @searchAllCategories.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả danh mục'**
  String get searchAllCategories;

  /// No description provided for @searchPriceRange.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng giá (₫)'**
  String get searchPriceRange;

  /// No description provided for @searchPriceMin.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu'**
  String get searchPriceMin;

  /// No description provided for @searchPriceMax.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa'**
  String get searchPriceMax;

  /// No description provided for @searchPriceError.
  ///
  /// In vi, this message translates to:
  /// **'Giá tối thiểu phải nhỏ hơn giá tối đa'**
  String get searchPriceError;

  /// No description provided for @searchProOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ dịch vụ Pro'**
  String get searchProOnly;

  /// No description provided for @searchProOnlyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Do người bán đã được VietGig thẩm định chất lượng cung cấp.'**
  String get searchProOnlyDesc;

  /// No description provided for @searchShowResults.
  ///
  /// In vi, this message translates to:
  /// **'Hiện kết quả'**
  String get searchShowResults;

  /// No description provided for @searchShowResultsCount.
  ///
  /// In vi, this message translates to:
  /// **'Hiện kết quả ({n})'**
  String searchShowResultsCount(int n);

  /// No description provided for @sellerEarnings.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get sellerEarnings;

  /// No description provided for @sellerAvailable.
  ///
  /// In vi, this message translates to:
  /// **'Có thể rút'**
  String get sellerAvailable;

  /// No description provided for @sellerActiveOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đơn đang chạy'**
  String get sellerActiveOrders;

  /// No description provided for @sellerPaymentsClearing.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán đang xử lý'**
  String get sellerPaymentsClearing;

  /// No description provided for @sellerSuccessScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm thành công'**
  String get sellerSuccessScore;

  /// No description provided for @sellerRating.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá'**
  String get sellerRating;

  /// No description provided for @sellerResponseRate.
  ///
  /// In vi, this message translates to:
  /// **'Tỉ lệ phản hồi'**
  String get sellerResponseRate;

  /// No description provided for @sellerOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get sellerOrders;

  /// No description provided for @sellerClients.
  ///
  /// In vi, this message translates to:
  /// **'Khách hàng'**
  String get sellerClients;

  /// No description provided for @sellerGotIt.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiểu'**
  String get sellerGotIt;

  /// No description provided for @sellerOptions.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn'**
  String get sellerOptions;

  /// No description provided for @sellerChartDateFormat.
  ///
  /// In vi, this message translates to:
  /// **'dd/MM'**
  String get sellerChartDateFormat;

  /// No description provided for @sellerMonthFormat.
  ///
  /// In vi, this message translates to:
  /// **'M'**
  String get sellerMonthFormat;

  /// No description provided for @sellerDashLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được bảng điều khiển'**
  String get sellerDashLoadError;

  /// No description provided for @sellerDashGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào {name},'**
  String sellerDashGreeting(String name);

  /// No description provided for @sellerDashGreetingFallback.
  ///
  /// In vi, this message translates to:
  /// **'bạn'**
  String get sellerDashGreetingFallback;

  /// No description provided for @sellerDashWelcomeBack.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại'**
  String get sellerDashWelcomeBack;

  /// No description provided for @sellerDashSetupTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thiện hồ sơ người bán'**
  String get sellerDashSetupTitle;

  /// No description provided for @sellerDashSetupBody.
  ///
  /// In vi, this message translates to:
  /// **'Tạo dịch vụ đầu tiên và hoàn thiện hồ sơ để bắt đầu nhận đơn từ khách hàng.'**
  String get sellerDashSetupBody;

  /// No description provided for @sellerDashSetupLink.
  ///
  /// In vi, this message translates to:
  /// **'Xem dịch vụ của tôi →'**
  String get sellerDashSetupLink;

  /// No description provided for @sellerDashTodoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Việc cần làm'**
  String get sellerDashTodoTitle;

  /// No description provided for @sellerDashUnreadMessages.
  ///
  /// In vi, this message translates to:
  /// **'{n} tin nhắn chưa đọc'**
  String sellerDashUnreadMessages(int n);

  /// No description provided for @sellerDashUnreadNone.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian phản hồi của bạn đang tốt. Hãy tiếp tục phát huy!'**
  String get sellerDashUnreadNone;

  /// No description provided for @sellerDashUnreadSome.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời sớm để giữ tỉ lệ phản hồi cao.'**
  String get sellerDashUnreadSome;

  /// No description provided for @sellerDashOrdersToDeliver.
  ///
  /// In vi, this message translates to:
  /// **'{n} đơn hàng cần giao'**
  String sellerDashOrdersToDeliver(int n);

  /// No description provided for @sellerDashOrdersNone.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không có đơn nào sắp đến hạn giao.'**
  String get sellerDashOrdersNone;

  /// No description provided for @sellerDashOrdersSome.
  ///
  /// In vi, this message translates to:
  /// **'Giao đúng hạn để giữ điểm thành công cao.'**
  String get sellerDashOrdersSome;

  /// No description provided for @sellerDashMyGigs.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ của tôi'**
  String get sellerDashMyGigs;

  /// No description provided for @sellerDashManage.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý'**
  String get sellerDashManage;

  /// No description provided for @sellerDashStats.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get sellerDashStats;

  /// No description provided for @sellerDashLast7Days.
  ///
  /// In vi, this message translates to:
  /// **'7 ngày qua'**
  String get sellerDashLast7Days;

  /// No description provided for @sellerDashImpressions.
  ///
  /// In vi, this message translates to:
  /// **'Lượt hiển thị'**
  String get sellerDashImpressions;

  /// No description provided for @sellerDashClicks.
  ///
  /// In vi, this message translates to:
  /// **'Lượt nhấp'**
  String get sellerDashClicks;

  /// No description provided for @sellerDashConversion.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển đổi'**
  String get sellerDashConversion;

  /// No description provided for @sellerDashBriefsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Brief mới'**
  String get sellerDashBriefsTitle;

  /// No description provided for @sellerDashLearnMore.
  ///
  /// In vi, this message translates to:
  /// **'Tìm hiểu thêm'**
  String get sellerDashLearnMore;

  /// No description provided for @sellerDashBriefsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có brief mới'**
  String get sellerDashBriefsEmpty;

  /// No description provided for @sellerDashBriefsCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} brief phù hợp với bạn'**
  String sellerDashBriefsCount(int n);

  /// No description provided for @sellerDashBriefsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá dự án tiềm năng từ khách hàng – brief phù hợp với kỹ năng của bạn sẽ được gửi đến đây.'**
  String get sellerDashBriefsDesc;

  /// No description provided for @sellerDashViewDetails.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết'**
  String get sellerDashViewDetails;

  /// No description provided for @sellerDashEarningsThisMonth.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập tháng này'**
  String get sellerDashEarningsThisMonth;

  /// No description provided for @sellerDashAvgPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá bán TB'**
  String get sellerDashAvgPrice;

  /// No description provided for @sellerDashCancelledOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đơn đã huỷ'**
  String get sellerDashCancelledOrders;

  /// No description provided for @sellerDashActiveOrdersTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đang thực hiện'**
  String get sellerDashActiveOrdersTitle;

  /// No description provided for @sellerDashNoActiveOrders.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đơn hàng nào đang thực hiện.'**
  String get sellerDashNoActiveOrders;

  /// No description provided for @sellerDashMyLevel.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ của tôi'**
  String get sellerDashMyLevel;

  /// No description provided for @sellerDashDue.
  ///
  /// In vi, this message translates to:
  /// **'Hạn {date}'**
  String sellerDashDue(String date);

  /// No description provided for @sellerLevelTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan cấp độ'**
  String get sellerLevelTitle;

  /// No description provided for @sellerLevelSystem.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống cấp độ'**
  String get sellerLevelSystem;

  /// No description provided for @sellerLevelSystemDesc.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ được đánh giá lại hằng tháng dựa trên hiệu suất 60 ngày gần nhất của bạn.'**
  String get sellerLevelSystemDesc;

  /// No description provided for @sellerLevelColumn.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ'**
  String get sellerLevelColumn;

  /// No description provided for @sellerLevelTopRatedNote.
  ///
  /// In vi, this message translates to:
  /// **'Để đạt Top Rated, hồ sơ của bạn cần được đội ngũ VietGig xét duyệt thêm.'**
  String get sellerLevelTopRatedNote;

  /// No description provided for @sellerLevelTopReached.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã đạt cấp cao nhất!'**
  String get sellerLevelTopReached;

  /// No description provided for @sellerLevelNext.
  ///
  /// In vi, this message translates to:
  /// **'Cấp tiếp theo: {level}'**
  String sellerLevelNext(String level);

  /// No description provided for @sellerLevelPerformance.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số hiệu suất'**
  String get sellerLevelPerformance;

  /// No description provided for @sellerLevelBasedOn.
  ///
  /// In vi, this message translates to:
  /// **'Dựa trên hoạt động 60 ngày gần nhất.'**
  String get sellerLevelBasedOn;

  /// No description provided for @sellerLevelSuccessInfo.
  ///
  /// In vi, this message translates to:
  /// **'Điểm từ 1–10 phản ánh mức độ hài lòng của khách hàng, dựa trên đánh giá riêng tư, tỉ lệ huỷ đơn và giao đúng hạn.'**
  String get sellerLevelSuccessInfo;

  /// No description provided for @sellerLevelRatingInfo.
  ///
  /// In vi, this message translates to:
  /// **'Điểm đánh giá trung bình người mua dành cho bạn.'**
  String get sellerLevelRatingInfo;

  /// No description provided for @sellerLevelResponseInfo.
  ///
  /// In vi, this message translates to:
  /// **'Tỉ lệ tin nhắn mới bạn trả lời trong vòng 24 giờ.'**
  String get sellerLevelResponseInfo;

  /// No description provided for @sellerLevelOrdersInfo.
  ///
  /// In vi, this message translates to:
  /// **'Số đơn hàng đã hoàn thành.'**
  String get sellerLevelOrdersInfo;

  /// No description provided for @sellerLevelUniqueClients.
  ///
  /// In vi, this message translates to:
  /// **'Khách hàng duy nhất'**
  String get sellerLevelUniqueClients;

  /// No description provided for @sellerLevelUniqueClientsInfo.
  ///
  /// In vi, this message translates to:
  /// **'Số người mua khác nhau đã hoàn thành đơn với bạn.'**
  String get sellerLevelUniqueClientsInfo;

  /// No description provided for @sellerLevelEarningsInfo.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thu nhập từ các đơn đã hoàn thành.'**
  String get sellerLevelEarningsInfo;

  /// No description provided for @sellerLevelReachNext.
  ///
  /// In vi, this message translates to:
  /// **'Đạt cấp tiếp theo'**
  String get sellerLevelReachNext;

  /// No description provided for @sellerLevelProgressNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ tới cấp tiếp theo'**
  String get sellerLevelProgressNext;

  /// No description provided for @sellerLevelTarget.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu {level}'**
  String sellerLevelTarget(String level);

  /// No description provided for @sellerLevelExplain.
  ///
  /// In vi, this message translates to:
  /// **'Giải thích'**
  String get sellerLevelExplain;

  /// No description provided for @sellerRangeLast30.
  ///
  /// In vi, this message translates to:
  /// **'30 ngày qua'**
  String get sellerRangeLast30;

  /// No description provided for @sellerRangeLast3Months.
  ///
  /// In vi, this message translates to:
  /// **'3 tháng qua'**
  String get sellerRangeLast3Months;

  /// No description provided for @sellerRangeThisYear.
  ///
  /// In vi, this message translates to:
  /// **'Năm nay'**
  String get sellerRangeThisYear;

  /// No description provided for @sellerRangeLastYear.
  ///
  /// In vi, this message translates to:
  /// **'Năm ngoái'**
  String get sellerRangeLastYear;

  /// No description provided for @sellerEarningsPickRange.
  ///
  /// In vi, this message translates to:
  /// **'Chọn khoảng thời gian'**
  String get sellerEarningsPickRange;

  /// No description provided for @sellerEarningsWithdrawTo.
  ///
  /// In vi, this message translates to:
  /// **'Rút {amount} về'**
  String sellerEarningsWithdrawTo(String amount);

  /// No description provided for @sellerEarningsBank.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản ngân hàng'**
  String get sellerEarningsBank;

  /// No description provided for @sellerEarningsBankSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Vietcombank •••• 6789 · 1–3 ngày làm việc'**
  String get sellerEarningsBankSubtitle;

  /// No description provided for @sellerEarningsMomo.
  ///
  /// In vi, this message translates to:
  /// **'Ví MoMo'**
  String get sellerEarningsMomo;

  /// No description provided for @sellerEarningsMomoSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'090 •••• 123 · Nhận ngay'**
  String get sellerEarningsMomoSubtitle;

  /// No description provided for @sellerEarningsSentBank.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu rút {amount} về tài khoản ngân hàng'**
  String sellerEarningsSentBank(String amount);

  /// No description provided for @sellerEarningsSentMomo.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu rút {amount} về ví MoMo'**
  String sellerEarningsSentMomo(String amount);

  /// No description provided for @sellerEarningsWithdraw.
  ///
  /// In vi, this message translates to:
  /// **'Rút tiền'**
  String get sellerEarningsWithdraw;

  /// No description provided for @sellerEarningsNothing.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có khoản nào có thể rút.'**
  String get sellerEarningsNothing;

  /// No description provided for @sellerEarningsOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get sellerEarningsOverview;

  /// No description provided for @sellerEarningsCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hoàn thành'**
  String get sellerEarningsCompleted;

  /// No description provided for @sellerEarningsTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thu nhập: {amount}'**
  String sellerEarningsTotal(String amount);

  /// No description provided for @sellerEarningsTotalOrders.
  ///
  /// In vi, this message translates to:
  /// **'Tổng đơn hoàn thành: {n}'**
  String sellerEarningsTotalOrders(int n);

  /// No description provided for @sellerEarningsAnalytics.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích'**
  String get sellerEarningsAnalytics;

  /// No description provided for @sellerEarningsMonth.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập tháng {month}'**
  String sellerEarningsMonth(String month);

  /// No description provided for @sellerEarningsAvgPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá bán trung bình'**
  String get sellerEarningsAvgPrice;

  /// No description provided for @sellerEarningsRevenue.
  ///
  /// In vi, this message translates to:
  /// **'Doanh thu'**
  String get sellerEarningsRevenue;

  /// No description provided for @sellerEarningsClearingInfo.
  ///
  /// In vi, this message translates to:
  /// **'Khoản thanh toán từ đơn hoàn thành sẽ được giữ 14 ngày trước khi chuyển sang số dư có thể rút. Điều này giúp bảo vệ cả bạn và người mua khi có tranh chấp.'**
  String get sellerEarningsClearingInfo;

  /// No description provided for @sellerEarningsToDate.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập đến nay'**
  String get sellerEarningsToDate;

  /// No description provided for @sellerEarningsToDateInfo.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thu nhập bạn đã kiếm được trên VietGig kể từ khi bắt đầu bán, sau khi trừ phí dịch vụ.'**
  String get sellerEarningsToDateInfo;

  /// No description provided for @sellerEarningsExpenses.
  ///
  /// In vi, this message translates to:
  /// **'Chi phí đến nay'**
  String get sellerEarningsExpenses;

  /// No description provided for @sellerEarningsExpensesInfo.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số tiền bạn đã dùng thu nhập để thanh toán trên VietGig, ví dụ mua dịch vụ hoặc quảng bá dịch vụ của mình.'**
  String get sellerEarningsExpensesInfo;

  /// No description provided for @sellerEarningsWithdrawn.
  ///
  /// In vi, this message translates to:
  /// **'Đã rút đến nay'**
  String get sellerEarningsWithdrawn;

  /// No description provided for @sellerEarningsWithdrawnInfo.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số tiền bạn đã rút từ VietGig về tài khoản ngân hàng hoặc ví điện tử.'**
  String get sellerEarningsWithdrawnInfo;

  /// No description provided for @sellerAvailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch làm việc'**
  String get sellerAvailTitle;

  /// No description provided for @sellerAvailReasonVacation.
  ///
  /// In vi, this message translates to:
  /// **'Đi nghỉ'**
  String get sellerAvailReasonVacation;

  /// No description provided for @sellerAvailReasonOverloaded.
  ///
  /// In vi, this message translates to:
  /// **'Quá tải công việc'**
  String get sellerAvailReasonOverloaded;

  /// No description provided for @sellerAvailReasonOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get sellerAvailReasonOther;

  /// No description provided for @sellerAvailConfirmed.
  ///
  /// In vi, this message translates to:
  /// **'Đã xác nhận ngày bận của bạn'**
  String get sellerAvailConfirmed;

  /// No description provided for @sellerAvailChangesSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu thay đổi lịch bận'**
  String get sellerAvailChangesSaved;

  /// No description provided for @sellerAvailDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá lịch bận'**
  String get sellerAvailDeleted;

  /// No description provided for @sellerAvailDesc.
  ///
  /// In vi, this message translates to:
  /// **'Khi bận, dịch vụ của bạn bị ẩn và bạn không nhận đơn/tin nhắn mới. Tỉ lệ phản hồi của bạn sẽ không bị ảnh hưởng trong thời gian này.'**
  String get sellerAvailDesc;

  /// No description provided for @sellerAvailSet.
  ///
  /// In vi, this message translates to:
  /// **'Đặt ngày bận'**
  String get sellerAvailSet;

  /// No description provided for @sellerAvailUpcoming.
  ///
  /// In vi, this message translates to:
  /// **'Ngày bận sắp tới'**
  String get sellerAvailUpcoming;

  /// No description provided for @sellerAvailEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get sellerAvailEdit;

  /// No description provided for @sellerAvailReasonLine.
  ///
  /// In vi, this message translates to:
  /// **'Lý do: {reason}'**
  String sellerAvailReasonLine(String reason);

  /// No description provided for @sellerAvailReasonLineContact.
  ///
  /// In vi, this message translates to:
  /// **'Lý do: {reason} · Người mua vẫn có thể liên hệ'**
  String sellerAvailReasonLineContact(String reason);

  /// No description provided for @sellerAvailPickFirst.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày đầu'**
  String get sellerAvailPickFirst;

  /// No description provided for @sellerAvailPickLast.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày cuối'**
  String get sellerAvailPickLast;

  /// No description provided for @sellerAvailPick.
  ///
  /// In vi, this message translates to:
  /// **'Chọn'**
  String get sellerAvailPick;

  /// No description provided for @sellerAvailSaveError.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được: {error}'**
  String sellerAvailSaveError(String error);

  /// No description provided for @sellerAvailDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá lịch bận đã đặt?'**
  String get sellerAvailDeleteTitle;

  /// No description provided for @sellerAvailDeleteMessage.
  ///
  /// In vi, this message translates to:
  /// **'Thao tác này sẽ xoá các ngày bận hiện tại của bạn.'**
  String get sellerAvailDeleteMessage;

  /// No description provided for @sellerAvailEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa ngày bận'**
  String get sellerAvailEditTitle;

  /// No description provided for @sellerAvailFirstDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày đầu'**
  String get sellerAvailFirstDay;

  /// No description provided for @sellerAvailLastDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày cuối'**
  String get sellerAvailLastDay;

  /// No description provided for @sellerAvailInvalidRange.
  ///
  /// In vi, this message translates to:
  /// **'Ngày cuối phải sau hoặc trùng ngày đầu.'**
  String get sellerAvailInvalidRange;

  /// No description provided for @sellerAvailReason.
  ///
  /// In vi, this message translates to:
  /// **'Lý do'**
  String get sellerAvailReason;

  /// No description provided for @sellerAvailNoteLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú (tuỳ chọn)'**
  String get sellerAvailNoteLabel;

  /// No description provided for @sellerAvailNoteHint.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đang bận, nhưng sẽ sớm quay lại.'**
  String get sellerAvailNoteHint;

  /// No description provided for @sellerAvailNoteHelp.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú này sẽ hiển thị trong thông báo trên trang dịch vụ và hồ sơ của bạn.'**
  String get sellerAvailNoteHelp;

  /// No description provided for @sellerAvailAllowContact.
  ///
  /// In vi, this message translates to:
  /// **'Mọi người mua có thể liên hệ tôi'**
  String get sellerAvailAllowContact;

  /// No description provided for @sellerAvailAllowContactOn.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý: thời gian phản hồi các tin nhắn này vẫn tính vào tỉ lệ phản hồi. Chỉ bật nếu bạn có thể trả lời.'**
  String get sellerAvailAllowContactOn;

  /// No description provided for @sellerAvailAllowContactOff.
  ///
  /// In vi, this message translates to:
  /// **'Khi bận, người mua không thể đặt đơn hay liên hệ bạn, nhưng bạn vẫn có thể nhắn tin với người mua có đơn đang thực hiện.'**
  String get sellerAvailAllowContactOff;

  /// No description provided for @sellerAvailSaveChanges.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get sellerAvailSaveChanges;

  /// No description provided for @sellerAvailConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận ngày'**
  String get sellerAvailConfirm;

  /// No description provided for @sellerAvailDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xoá lịch bận'**
  String get sellerAvailDelete;

  /// No description provided for @sellerBriefsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Brief'**
  String get sellerBriefsTitle;

  /// No description provided for @sellerBriefsPrefs.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn brief'**
  String get sellerBriefsPrefs;

  /// No description provided for @sellerBriefsPrefsUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật tuỳ chọn brief'**
  String get sellerBriefsPrefsUpdated;

  /// No description provided for @sellerBriefsResponded.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi phản hồi cho brief “{title}”'**
  String sellerBriefsResponded(String title);

  /// No description provided for @sellerBriefsWhat.
  ///
  /// In vi, this message translates to:
  /// **'Brief là gì?'**
  String get sellerBriefsWhat;

  /// No description provided for @sellerBriefsWhatBody.
  ///
  /// In vi, this message translates to:
  /// **'Brief là mô tả dự án do người mua đăng lên. VietGig sẽ gửi đến bạn những brief phù hợp với dịch vụ và kỹ năng của bạn để bạn gửi báo giá.'**
  String get sellerBriefsWhatBody;

  /// No description provided for @sellerBriefsTabMatches.
  ///
  /// In vi, this message translates to:
  /// **'Phù hợp với bạn'**
  String get sellerBriefsTabMatches;

  /// No description provided for @sellerBriefsTabSent.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi đã gửi'**
  String get sellerBriefsTabSent;

  /// No description provided for @sellerBriefsOffTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang tắt nhận brief'**
  String get sellerBriefsOffTitle;

  /// No description provided for @sellerBriefsOffMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bật lại \"Nhận brief mới\" trong tuỳ chọn để không bỏ lỡ dự án phù hợp.'**
  String get sellerBriefsOffMessage;

  /// No description provided for @sellerBriefsOffAction.
  ///
  /// In vi, this message translates to:
  /// **'Mở tuỳ chọn brief'**
  String get sellerBriefsOffAction;

  /// No description provided for @sellerBriefsEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có brief phù hợp…'**
  String get sellerBriefsEmptyTitle;

  /// No description provided for @sellerBriefsEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ báo cho bạn ngay khi có brief phù hợp với kỹ năng của bạn.'**
  String get sellerBriefsEmptyMessage;

  /// No description provided for @sellerBriefsSentEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Có lẽ đã đến lúc cho một dự án mới'**
  String get sellerBriefsSentEmptyTitle;

  /// No description provided for @sellerBriefsSentEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi brief trong tab \"Phù hợp với bạn\" và quản lý các phản hồi đã gửi tại đây.'**
  String get sellerBriefsSentEmptyMessage;

  /// No description provided for @sellerBriefsIntroTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tab phù hợp của bạn'**
  String get sellerBriefsIntroTitle;

  /// No description provided for @sellerBriefsNewBadge.
  ///
  /// In vi, this message translates to:
  /// **'MỚI'**
  String get sellerBriefsNewBadge;

  /// No description provided for @sellerBriefsIntroBody.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả brief mới dành cho bạn sẽ hiển thị ở tab này – bạn có thể là người đầu tiên gửi báo giá.'**
  String get sellerBriefsIntroBody;

  /// No description provided for @sellerBriefsNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp'**
  String get sellerBriefsNext;

  /// No description provided for @sellerBriefsBuyer.
  ///
  /// In vi, this message translates to:
  /// **'Người mua'**
  String get sellerBriefsBuyer;

  /// No description provided for @sellerBriefsBudget.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách {budget} · {days}'**
  String sellerBriefsBudget(String budget, String days);

  /// No description provided for @sellerBriefsSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi'**
  String get sellerBriefsSent;

  /// No description provided for @sellerBriefsSendOffer.
  ///
  /// In vi, this message translates to:
  /// **'Gửi báo giá'**
  String get sellerBriefsSendOffer;

  /// No description provided for @sellerBriefsReceiveTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhận brief'**
  String get sellerBriefsReceiveTitle;

  /// No description provided for @sellerBriefsReceiveDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chọn có muốn nhận brief hay không. Bạn có thể bật lại bất cứ lúc nào.'**
  String get sellerBriefsReceiveDesc;

  /// No description provided for @sellerBriefsReceiveNew.
  ///
  /// In vi, this message translates to:
  /// **'Nhận brief mới'**
  String get sellerBriefsReceiveNew;

  /// No description provided for @sellerBriefsPriceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giá brief'**
  String get sellerBriefsPriceTitle;

  /// No description provided for @sellerBriefsPriceDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mức giá tối thiểu cho các brief bạn muốn nhận. Có thể thay đổi bất cứ lúc nào.'**
  String get sellerBriefsPriceDesc;

  /// No description provided for @sellerBriefsMinPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá tối thiểu (tuỳ chọn)'**
  String get sellerBriefsMinPrice;

  /// No description provided for @sellerBriefsPriceHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập giá'**
  String get sellerBriefsPriceHint;

  /// No description provided for @sellerGigsShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ dịch vụ'**
  String get sellerGigsShare;

  /// No description provided for @sellerGigsShareTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ dịch vụ của bạn'**
  String get sellerGigsShareTitle;

  /// No description provided for @sellerGigsShareDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ liên kết dịch vụ lên mạng xã hội để tiếp cận thêm nhiều người mua.'**
  String get sellerGigsShareDesc;

  /// No description provided for @sellerGigsLinkCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép liên kết dịch vụ'**
  String get sellerGigsLinkCopied;

  /// No description provided for @sellerGigsSampleNote.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ mẫu – bạn chưa có dịch vụ nào. Dưới đây là ví dụ để bạn tham khảo.'**
  String get sellerGigsSampleNote;

  /// No description provided for @sellerGigsEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dịch vụ'**
  String get sellerGigsEmptyTitle;

  /// No description provided for @sellerGigsEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tạo dịch vụ đầu tiên để bắt đầu nhận đơn.'**
  String get sellerGigsEmptyMessage;

  /// No description provided for @sellerGigsResumed.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ đã hoạt động trở lại'**
  String get sellerGigsResumed;

  /// No description provided for @sellerGigsPausedSnack.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạm dừng dịch vụ'**
  String get sellerGigsPausedSnack;

  /// No description provided for @sellerGigsBoost.
  ///
  /// In vi, this message translates to:
  /// **'Tăng lượt truy cập'**
  String get sellerGigsBoost;

  /// No description provided for @sellerGigsNoReviews.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đánh giá'**
  String get sellerGigsNoReviews;

  /// No description provided for @sellerGigsActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get sellerGigsActive;

  /// No description provided for @sellerGigsPaused.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng'**
  String get sellerGigsPaused;

  /// No description provided for @sellerGigsSample.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ mẫu'**
  String get sellerGigsSample;

  /// No description provided for @sellerGigsPromoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quảng bá trên mạng xã hội'**
  String get sellerGigsPromoTitle;

  /// No description provided for @sellerGigsPromoBody.
  ///
  /// In vi, this message translates to:
  /// **'Tạo video ngắn giới thiệu dịch vụ và chia sẻ lên Facebook, TikTok, Zalo để thu hút thêm người mua. Tính năng tạo video sẽ sớm ra mắt trên VietGig.'**
  String get sellerGigsPromoBody;

  /// No description provided for @sellerGigsPromoBanner.
  ///
  /// In vi, this message translates to:
  /// **'Quảng bá dịch vụ'**
  String get sellerGigsPromoBanner;

  /// No description provided for @sellerGigsFeatured.
  ///
  /// In vi, this message translates to:
  /// **'Nổi bật'**
  String get sellerGigsFeatured;

  /// No description provided for @sellerGigsPromoHeadline.
  ///
  /// In vi, this message translates to:
  /// **'Muốn có thêm người mua từ mạng xã hội? Tạo video quảng bá dịch vụ chỉ trong vài phút.'**
  String get sellerGigsPromoHeadline;

  /// No description provided for @sellerTplTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu báo giá'**
  String get sellerTplTitle;

  /// No description provided for @sellerTplSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu mẫu “{name}”'**
  String sellerTplSaved(String name);

  /// No description provided for @sellerTplDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá mẫu “{name}”'**
  String sellerTplDeleted(String name);

  /// No description provided for @sellerTplCreate.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mẫu'**
  String get sellerTplCreate;

  /// No description provided for @sellerTplEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mẫu cho báo giá riêng'**
  String get sellerTplEmptyTitle;

  /// No description provided for @sellerTplEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Lưu báo giá làm mẫu để dùng lại cho những lần sau.'**
  String get sellerTplEmptyMessage;

  /// No description provided for @sellerTplSwipeHint.
  ///
  /// In vi, this message translates to:
  /// **'Vuốt sang trái để xoá mẫu.'**
  String get sellerTplSwipeHint;

  /// No description provided for @sellerTplSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán một lần | Giao trong {days}'**
  String sellerTplSubtitle(String days);

  /// No description provided for @sellerTplSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mẫu báo giá'**
  String get sellerTplSheetTitle;

  /// No description provided for @sellerTplName.
  ///
  /// In vi, this message translates to:
  /// **'Tên mẫu'**
  String get sellerTplName;

  /// No description provided for @sellerTplNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Gói thiết kế cao cấp'**
  String get sellerTplNameHint;

  /// No description provided for @sellerTplNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên mẫu'**
  String get sellerTplNameRequired;

  /// No description provided for @sellerTplPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá'**
  String get sellerTplPrice;

  /// No description provided for @sellerTplPriceRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập giá'**
  String get sellerTplPriceRequired;

  /// No description provided for @sellerTplPriceMin.
  ///
  /// In vi, this message translates to:
  /// **'Giá tối thiểu là {amount}'**
  String sellerTplPriceMin(String amount);

  /// No description provided for @sellerTplDays.
  ///
  /// In vi, this message translates to:
  /// **'Số ngày giao'**
  String get sellerTplDays;

  /// No description provided for @sellerTplDaysSuffix.
  ///
  /// In vi, this message translates to:
  /// **'ngày'**
  String get sellerTplDaysSuffix;

  /// No description provided for @sellerTplDaysInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Số ngày từ 1 đến 90'**
  String get sellerTplDaysInvalid;

  /// No description provided for @sellerTplSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu mẫu'**
  String get sellerTplSave;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
