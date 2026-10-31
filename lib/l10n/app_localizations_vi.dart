// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get authPwRuleLength => 'Ít nhất 8 ký tự';

  @override
  String get authPwRuleUpper => 'Ít nhất 1 chữ in hoa';

  @override
  String get authPwRuleLower => 'Ít nhất 1 chữ thường';

  @override
  String get authPwRuleDigit => 'Ít nhất 1 chữ số';

  @override
  String get authContinueWithApple => 'Tiếp tục với Apple';

  @override
  String get authContinueWithGoogle => 'Tiếp tục với Google';

  @override
  String get authContinueWithFacebook => 'Tiếp tục với Facebook';

  @override
  String get authTermsPrefix => 'Bằng việc tham gia, bạn đồng ý với ';

  @override
  String get authTermsLink => 'Điều khoản dịch vụ';

  @override
  String get authTermsSuffix => ' của VietGig.';

  @override
  String get authTermsBody =>
      '1. Bạn chịu trách nhiệm về thông tin tài khoản và bảo mật mật khẩu.\n\n2. Mọi giao dịch phải được thực hiện qua VietGig để được bảo vệ thanh toán.\n\n3. Nghiêm cấm đăng tải nội dung vi phạm pháp luật Việt Nam hoặc quyền sở hữu trí tuệ.\n\n4. VietGig có quyền tạm khoá tài khoản vi phạm chính sách cộng đồng.\n\n5. Dữ liệu cá nhân được xử lý theo Chính sách quyền riêng tư.';

  @override
  String get authSkip => 'Bỏ qua';

  @override
  String get authContinue => 'Tiếp tục';

  @override
  String get authFinish => 'Hoàn tất';

  @override
  String get authClear => 'Xoá';

  @override
  String get authShowPassword => 'Hiện mật khẩu';

  @override
  String get authHidePassword => 'Ẩn mật khẩu';

  @override
  String get authPasswordHint => 'Mật khẩu';

  @override
  String get authEmailHint => 'Email';

  @override
  String get authResendEmail => 'Gửi lại email';

  @override
  String get authWelcomeHeadline => 'Dịch vụ freelance.\nTheo yêu cầu.';

  @override
  String get authWelcomeBuyTitle => 'Tìm dịch vụ';

  @override
  String get authWelcomeBuySubtitle =>
      'Tôi đang tìm freelancer tài năng để hợp tác';

  @override
  String get authWelcomeSellTitle => 'Bán dịch vụ';

  @override
  String get authWelcomeSellSubtitle => 'Tôi muốn cung cấp dịch vụ của mình';

  @override
  String get authSignInTitle => 'Đăng nhập vào tài khoản';

  @override
  String get authSignInSubtitle => 'Chào mừng bạn quay lại VietGig!';

  @override
  String get authIdHint => 'Email hoặc tên người dùng';

  @override
  String get authIdRequired => 'Vui lòng nhập email hoặc tên người dùng';

  @override
  String get authPasswordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get authForgotLink => 'Quên mật khẩu?';

  @override
  String get authNoAccount => 'Chưa có tài khoản? ';

  @override
  String get authJoinNow => 'Tham gia ngay';

  @override
  String authDemoAccount(String email, String password) {
    return 'Tài khoản dùng thử: $email / $password';
  }

  @override
  String get authFill => 'Điền';

  @override
  String get authSignUpTitle => 'Tham gia VietGig';

  @override
  String get authSignUpSubtitle => 'Có thể cần xác minh bổ sung ở bước sau.';

  @override
  String get authUsernameHint => 'Tên người dùng công khai';

  @override
  String get authUsernameInvalid =>
      '4–20 ký tự: chữ không dấu, số, \"_\" hoặc \".\"';

  @override
  String get authUsernameNote =>
      'Bạn không thể đổi tên người dùng sau này, hãy chọn thật kỹ.';

  @override
  String get authEmailInvalid => 'Email không hợp lệ';

  @override
  String get authSignUpSubmit => 'Đăng ký';

  @override
  String get authHaveAccount => 'Đã có tài khoản? ';

  @override
  String get authOnbPurposeWork => 'Công việc hoặc kinh doanh chính';

  @override
  String get authOnbPurposeWorkDesc =>
      'Dự án cho công ty bạn đang làm hoặc cho việc kinh doanh của riêng bạn.';

  @override
  String get authOnbPurposeSide => 'Dự án phụ hoặc kinh doanh nhỏ';

  @override
  String get authOnbPurposeSideDesc =>
      'Bất cứ việc gì bạn làm ngoài công việc chính, như một dự án tay trái.';

  @override
  String get authOnbPurposePersonal => 'Mục đích cá nhân';

  @override
  String get authOnbPurposePersonalDesc =>
      'Dịch vụ cho sự phát triển hoặc sở thích riêng, ngoài công việc.';

  @override
  String get authOnbExpNew => 'Mới bắt đầu';

  @override
  String get authOnbExpOnline => 'Freelance online';

  @override
  String get authOnbExpOffline => 'Freelance offline';

  @override
  String get authOnbExpBoth => 'Cả online và offline';

  @override
  String get authOnbSaveError => 'Không lưu được lựa chọn, vui lòng thử lại.';

  @override
  String get authOnbPurposeTitle => 'Bạn dùng VietGig để làm gì?';

  @override
  String get authOnbPurposeSub => 'Có thể chọn nhiều mục.';

  @override
  String get authOnbInterestTitle => 'Chọn dịch vụ phù hợp với nhu cầu của bạn';

  @override
  String get authOnbInterestSub => 'Chọn ít nhất một mục.';

  @override
  String get authOnbOther => 'Khác';

  @override
  String get authOnbLookingForTitle => 'Bạn đang tìm dịch vụ gì?';

  @override
  String get authOnbLookingForHint => 'VD: Thiết kế menu nhà hàng';

  @override
  String get authOnbExpTitle => 'Kinh nghiệm freelance của bạn?';

  @override
  String get authOnbExpSub =>
      'Dù bạn theo phong cách nào, chúng tôi đều hỗ trợ.';

  @override
  String get authVerifyResent => 'Đã gửi lại email xác nhận';

  @override
  String get authVerifySendFailed => 'Gửi email thất bại, vui lòng thử lại.';

  @override
  String get authVerifyActivated => 'Tài khoản đã được kích hoạt!';

  @override
  String get authVerifyNotYet => 'Chưa xác nhận được, vui lòng thử lại.';

  @override
  String get authVerifyDoneTitle => 'Email của bạn đã được xác nhận';

  @override
  String get authVerifyTitle => 'Xác nhận email để tiếp tục';

  @override
  String get authVerifySentTo => 'Chúng tôi đã gửi email tới:';

  @override
  String get authVerifyBody =>
      'Bấm vào liên kết trong email để xác minh địa chỉ và kích hoạt tài khoản của bạn.';

  @override
  String get authVerifyWrongEmail => 'Không phải email bạn muốn dùng?';

  @override
  String get authVerifyChangeEmail => 'Đổi địa chỉ email';

  @override
  String get authVerifyDemoNote =>
      'Bản demo: bấm \"Tôi đã xác nhận\" để mô phỏng việc mở liên kết.';

  @override
  String get authVerifyConfirm => 'Tôi đã xác nhận';

  @override
  String authResendIn(int seconds) {
    return 'Gửi lại email sau ${seconds}s';
  }

  @override
  String get authForgotInvalidEmail => 'Vui lòng nhập email hợp lệ';

  @override
  String get authForgotSent => 'Đã gửi liên kết đặt lại mật khẩu';

  @override
  String get authForgotTitle => 'Quên mật khẩu';

  @override
  String get authForgotHeading => 'Đặt lại mật khẩu';

  @override
  String get authForgotBody =>
      'Nhập email bạn đã dùng để đăng ký, chúng tôi sẽ gửi liên kết đặt lại mật khẩu.';

  @override
  String get authForgotSubmit => 'Gửi liên kết';

  @override
  String get authForgotCheckInbox => 'Kiểm tra hộp thư của bạn';

  @override
  String authForgotSentTo(String email) {
    return 'Chúng tôi đã gửi liên kết đặt lại mật khẩu tới\n$email';
  }

  @override
  String get authBackToSignIn => 'Quay lại đăng nhập';

  @override
  String get commonSeeAll => 'Xem tất cả';

  @override
  String get commonCancel => 'Huỷ';

  @override
  String get commonOk => 'OK';

  @override
  String get commonAgree => 'Đồng ý';

  @override
  String get commonUndo => 'Hoàn tác';

  @override
  String get commonBack => 'Quay lại';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonSaved => 'Đã lưu';

  @override
  String get commonDone => 'Xong';

  @override
  String get commonDelete => 'Xoá';

  @override
  String get commonCreate => 'Tạo';

  @override
  String get commonOr => 'Hoặc';

  @override
  String get commonSignIn => 'Đăng nhập';

  @override
  String get commonMessage => 'Nhắn tin';

  @override
  String get commonErrorTitle => 'Đã có lỗi xảy ra';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonFrom => 'Từ';

  @override
  String get commonUnderConstruction => 'Đang xây dựng';

  @override
  String get timeDays => 'Ngày';

  @override
  String get timeHours => 'Giờ';

  @override
  String get timeMinutes => 'Phút';

  @override
  String get timeJustNow => 'Vừa xong';

  @override
  String get timeYesterday => 'Hôm qua';

  @override
  String timeMinutesAgo(int n) {
    return '$n phút trước';
  }

  @override
  String timeHoursAgo(int n) {
    return '$n giờ trước';
  }

  @override
  String timeDaysAgo(int n) {
    return '$n ngày trước';
  }

  @override
  String timeMonthsAgo(int n) {
    return '$n tháng trước';
  }

  @override
  String timeYearsAgo(int n) {
    return '$n năm trước';
  }

  @override
  String timeNDays(int n) {
    return '$n ngày';
  }

  @override
  String get weekday1 => 'Thứ Hai';

  @override
  String get weekday2 => 'Thứ Ba';

  @override
  String get weekday3 => 'Thứ Tư';

  @override
  String get weekday4 => 'Thứ Năm';

  @override
  String get weekday5 => 'Thứ Sáu';

  @override
  String get weekday6 => 'Thứ Bảy';

  @override
  String get weekday7 => 'Chủ Nhật';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navInbox => 'Hộp thư';

  @override
  String get navSearch => 'Tìm kiếm';

  @override
  String get navOrders => 'Đơn hàng';

  @override
  String get navAccount => 'Tài khoản';

  @override
  String get badgeChoice => 'VIETGIG CHỌN';

  @override
  String get orderStatusAwaitingRequirements => 'CHỜ YÊU CẦU';

  @override
  String get orderStatusInProgress => 'ĐANG THỰC HIỆN';

  @override
  String get orderStatusDelivered => 'ĐÃ GIAO';

  @override
  String get orderStatusRevisionRequested => 'YÊU CẦU SỬA';

  @override
  String get orderStatusCompleted => 'HOÀN THÀNH';

  @override
  String get orderStatusCancelled => 'ĐÃ HUỶ';

  @override
  String get orderStatusDisputed => 'ĐANG GIẢI QUYẾT';

  @override
  String get levelNew => 'Mới';

  @override
  String get levelOne => 'Cấp 1';

  @override
  String get levelTwo => 'Cấp 2';

  @override
  String get levelTopRated => 'Top Rated';

  @override
  String get sortRelevance => 'Phù hợp nhất';

  @override
  String get sortBestSelling => 'Bán chạy';

  @override
  String get sortNewest => 'Mới nhất';

  @override
  String get sortPriceLow => 'Giá thấp đến cao';

  @override
  String get sortPriceHigh => 'Giá cao đến thấp';

  @override
  String get sortRating => 'Đánh giá cao';

  @override
  String get offerStatusPending => 'Đang chờ';

  @override
  String get offerStatusAccepted => 'Đã chấp nhận';

  @override
  String get offerStatusDeclined => 'Đã từ chối';

  @override
  String get offerStatusWithdrawn => 'Đã rút lại';

  @override
  String get offerStatusExpired => 'Hết hạn';

  @override
  String get revisionsUnlimited => 'Không giới hạn';

  @override
  String get saveSignInTitle => 'Đăng nhập để lưu';

  @override
  String get saveSignInMessage =>
      'Bạn cần đăng nhập để lưu dịch vụ vào danh sách yêu thích.';

  @override
  String get saveSheetTitle => 'Danh sách đã lưu';

  @override
  String get saveCreateNewLink => '+ Tạo danh sách mới';

  @override
  String get saveCreateNewTitle => 'Tạo danh sách mới';

  @override
  String get saveListNameHint => 'Tên danh sách';

  @override
  String get saveListEmpty => 'Danh sách trống';

  @override
  String saveListCount(int gigs, int sellers) {
    return '$gigs dịch vụ • $sellers người bán';
  }

  @override
  String get notifKeyInbox => 'Tin nhắn hộp thư';

  @override
  String get notifKeyOrderMessages => 'Tin nhắn đơn hàng';

  @override
  String get notifKeyOrderUpdates => 'Cập nhật đơn hàng';

  @override
  String get notifKeyRatingReminders => 'Nhắc đánh giá';

  @override
  String get notifKeyBuyerBriefs => 'Brief từ người mua';

  @override
  String get notifKeyMyGigs => 'Dịch vụ của tôi';

  @override
  String get notifKeyMyAccount => 'Tài khoản của tôi';

  @override
  String get notifKeyPromotions => 'Thông báo khuyến mãi';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'English';

  @override
  String get authErrorMissingCredentials =>
      'Vui lòng nhập email/tên đăng nhập và mật khẩu.';

  @override
  String get authErrorUserNotFound => 'Không tìm thấy tài khoản này.';

  @override
  String get authErrorWrongPassword => 'Mật khẩu không đúng. Vui lòng thử lại.';

  @override
  String get authErrorUsernameTaken => 'Tên người dùng đã tồn tại.';

  @override
  String get authErrorEmailTaken => 'Email này đã được đăng ký.';

  @override
  String get authErrorInvalidEmail => 'Email không hợp lệ.';

  @override
  String get authErrorActiveOrders =>
      'Bạn không thể xoá tài khoản khi còn đơn hàng đang thực hiện. Vui lòng liên hệ bộ phận hỗ trợ.';

  @override
  String get authErrorUnknown => 'Đã có lỗi xảy ra. Vui lòng thử lại.';

  @override
  String get gigLinkCopied => 'Đã sao chép liên kết';

  @override
  String get gigSearchHint => 'Tìm dịch vụ';

  @override
  String get gigCriteriaCommunication => 'Mức độ giao tiếp';

  @override
  String get gigCriteriaQuality => 'Chất lượng sản phẩm';

  @override
  String get gigCriteriaValue => 'Đáng giá tiền';

  @override
  String get gigRatingOverall => 'Đánh giá tổng quan';

  @override
  String gigReviewCount(String count) {
    return '$count đánh giá';
  }

  @override
  String get gigReviewSortPositive => 'Tích cực nhất';

  @override
  String get gigReviewSortNegative => 'Tiêu cực nhất';

  @override
  String get gigSortBy => 'Sắp xếp theo';

  @override
  String get gigSortTooltip => 'Sắp xếp';

  @override
  String get gigReviewPrice => 'Giá';

  @override
  String get gigReviewDuration => 'Thời gian';

  @override
  String get gigSellerResponse => 'Phản hồi của người bán';

  @override
  String get gigResponseHide => 'Ẩn';

  @override
  String get gigResponseRead => 'Đọc';

  @override
  String get gigNewSeller => 'Người bán mới';

  @override
  String get gigShare => 'Chia sẻ';

  @override
  String get gigReport => 'Báo cáo dịch vụ';

  @override
  String get gigReportTitle => 'Vì sao bạn báo cáo dịch vụ này?';

  @override
  String get gigReportCopyright => 'Vi phạm bản quyền';

  @override
  String get gigReportContent => 'Nội dung không phù hợp';

  @override
  String get gigReportSpam => 'Lừa đảo / spam';

  @override
  String get gigReportOther => 'Lý do khác';

  @override
  String get gigReportThanks =>
      'Cảm ơn bạn! Chúng tôi sẽ xem xét báo cáo trong 24 giờ.';

  @override
  String get gigNotFoundTitle => 'Dịch vụ không tồn tại';

  @override
  String get gigNotFoundMessage => 'Dịch vụ này có thể đã bị gỡ hoặc tạm ẩn.';

  @override
  String get gigNotFoundAction => 'Khám phá dịch vụ khác';

  @override
  String get gigMore => 'Thêm';

  @override
  String get gigFaqTitle => 'Câu hỏi thường gặp';

  @override
  String get gigPortfolio => 'Portfolio';

  @override
  String gigMoreFromSeller(String name) {
    return 'Dịch vụ khác của $name';
  }

  @override
  String get gigSellerFallback => 'người bán';

  @override
  String get gigRecentlyViewed => 'Đã xem gần đây';

  @override
  String get gigShowLess => 'Thu gọn';

  @override
  String get gigShowMore => 'Xem thêm';

  @override
  String gigShowMoreSkills(int n) {
    return 'Xem thêm $n kỹ năng';
  }

  @override
  String get gigDeliveryTime => 'Thời gian giao';

  @override
  String get gigRevisions => 'Số lần sửa';

  @override
  String gigContinueWithPrice(String price) {
    return 'Tiếp tục ($price)';
  }

  @override
  String get gigComparePackages => 'So sánh gói';

  @override
  String get gigPackage => 'Gói';

  @override
  String gigSelectPackage(String tier) {
    return 'Chọn $tier';
  }

  @override
  String get gigAboutSeller => 'Về người bán';

  @override
  String get gigFrom => 'Đến từ';

  @override
  String get gigMemberSince => 'Thành viên từ';

  @override
  String gigMemberSinceValue(String month, String year) {
    return 'Th$month/$year';
  }

  @override
  String gigMemberSinceLong(String month, String year) {
    return 'Tháng $month/$year';
  }

  @override
  String get gigAvgResponse => 'Phản hồi TB';

  @override
  String get gigAvgResponseLong => 'Thời gian phản hồi TB';

  @override
  String gigHours(int n) {
    return '$n giờ';
  }

  @override
  String get gigLanguages => 'Ngôn ngữ';

  @override
  String get gigContact => 'Liên hệ';

  @override
  String get gigNoReviews => 'Chưa có đánh giá nào.';

  @override
  String gigSeeAllReviews(String count) {
    return 'Xem tất cả $count đánh giá';
  }

  @override
  String get gigSeeAllReviewsPlain => 'Xem tất cả đánh giá';

  @override
  String get gigTabAbout => 'Giới thiệu';

  @override
  String get gigTabGigs => 'Dịch vụ';

  @override
  String get gigTabReviews => 'Đánh giá';

  @override
  String get gigTabClients => 'Khách hàng';

  @override
  String get gigUserNotFoundTitle => 'Không tìm thấy người dùng';

  @override
  String get gigUserNotFoundMessage =>
      'Tài khoản này không tồn tại hoặc đã bị vô hiệu hoá.';

  @override
  String get gigVettedTitle => 'Được VietGig Pro thẩm định';

  @override
  String gigVettedMessage(String name) {
    return '$name đã được đội ngũ VietGig Pro lựa chọn nhờ chuyên môn đã được kiểm chứng.';
  }

  @override
  String get gigVettedFor => 'Được thẩm định cho';

  @override
  String get gigOffersHourly => 'Nhận việc theo giờ';

  @override
  String get gigInfo => 'Thông tin';

  @override
  String gigFromWithLocalTime(String place, String time) {
    return '$place ($time giờ địa phương)';
  }

  @override
  String get gigSkills => 'Kỹ năng';

  @override
  String get gigCertEducation => 'Chứng chỉ & Học vấn';

  @override
  String get gigCertificates => 'Chứng chỉ';

  @override
  String get gigEducation => 'Học vấn';

  @override
  String get gigNoGigsTitle => 'Chưa có dịch vụ';

  @override
  String gigNoGigsMessage(String name) {
    return '$name chưa đăng dịch vụ nào.';
  }

  @override
  String get gigNoReviewsTitle => 'Chưa có đánh giá';

  @override
  String get gigNoReviewsMessage =>
      'Hãy là người đầu tiên làm việc và đánh giá người bán này.';

  @override
  String get gigNoPortfolio => 'Chưa có portfolio';

  @override
  String gigPortfolioIntro(String name) {
    return 'Một số dự án $name đã thực hiện, giúp bạn hiểu rõ hơn về chuyên môn.';
  }

  @override
  String get gigNoClients => 'Chưa có khách hàng doanh nghiệp';

  @override
  String gigClientProject(String company) {
    return 'Dự án với $company';
  }

  @override
  String gigClientIndustry(String industry) {
    return 'Ngành: $industry';
  }

  @override
  String get gigFilterAll => 'Tất cả';

  @override
  String get gigFilterFive => '5 sao';

  @override
  String get gigFilterFour => '4 sao';

  @override
  String get gigFilterLow => '3 sao trở xuống';

  @override
  String get gigFilterResponded => 'Có phản hồi';

  @override
  String get gigSellerNotFound => 'Không tìm thấy người bán';

  @override
  String gigReviewsShown(int n) {
    return '$n đánh giá hiển thị';
  }

  @override
  String get gigNoMatchingReviews => 'Không có đánh giá phù hợp';

  @override
  String gigPortfolioOf(String name) {
    return 'Portfolio của $name';
  }

  @override
  String get gigNoProjectsTitle => 'Chưa có dự án nào';

  @override
  String get gigNoProjectsMessage => 'Người bán chưa thêm dự án vào portfolio.';

  @override
  String gigPortfolioScreenIntro(String name) {
    return 'Một số dự án $name đã thực hiện để bạn hiểu rõ hơn về chuyên môn.';
  }

  @override
  String get gigProjectNotFoundTitle => 'Không tìm thấy dự án';

  @override
  String get gigProjectNotFoundMessage =>
      'Dự án này có thể đã bị xoá khỏi portfolio.';

  @override
  String gigBy(String name) {
    return 'Bởi $name';
  }

  @override
  String gigProjectDefaultDescription(String name) {
    return 'Dự án do $name thực hiện cho khách hàng trên VietGig.';
  }

  @override
  String get homeCategoriesTooltip => 'Danh mục';

  @override
  String get homeVerifyTitle => 'Vui lòng xác nhận email';

  @override
  String homeVerifyMessage(String email) {
    return 'Chúng tôi đã gửi email xác nhận tới $email. Hãy kiểm tra hộp thư và kích hoạt tài khoản.';
  }

  @override
  String get homeVerifyYourAddress => 'địa chỉ của bạn';

  @override
  String get homeVerifyAction => 'Kích hoạt email →';

  @override
  String get homeGuestMessage =>
      'Đăng nhập để lưu dịch vụ, nhắn tin và đặt hàng.';

  @override
  String get homePopularServices => 'Dịch vụ phổ biến';

  @override
  String get homeCategoriesError => 'Không tải được danh mục';

  @override
  String get homeCustomOffers => 'Báo giá riêng dành cho bạn';

  @override
  String get homeActiveOrders => 'Đơn hàng đang thực hiện';

  @override
  String homeOrderDue(String date) {
    return 'Hạn giao: $date';
  }

  @override
  String get homeInterestsTitle => 'Bạn quan tâm gì?';

  @override
  String get homeInterestAdd => '+ Thêm';

  @override
  String get homeInterestAdded => 'Đã thêm vào sở thích';

  @override
  String get homeInterestRemoved => 'Đã bỏ khỏi sở thích';

  @override
  String get homeRecentlyViewed => 'Đã xem gần đây';

  @override
  String get homeMostLoved => 'Được yêu thích nhất';

  @override
  String get homeInviteTitle => 'Chia sẻ & nhận tới 2.500.000 ₫';

  @override
  String get homeInviteMessage =>
      'Tặng bạn bè giảm 10% cho đơn đầu tiên và nhận tới 2.500.000 ₫ khi họ đặt hàng trên VietGig.';

  @override
  String get homeInviteAction => 'Mời bạn bè →';

  @override
  String homeOfferSummary(String price, String days) {
    return '$price • $days giao hàng';
  }

  @override
  String homeOfferExpires(String time) {
    return 'Báo giá hết hạn lúc $time';
  }

  @override
  String get homeOfferOpenChat => 'Mở chat';

  @override
  String get homeOfferView => 'Xem';

  @override
  String get inboxEdit => 'Sửa';

  @override
  String get inboxFilterTitle => 'Bộ lọc';

  @override
  String get inboxSelectTitle => 'Chọn cuộc trò chuyện';

  @override
  String inboxSelectedCount(int n) {
    return '$n đã chọn';
  }

  @override
  String get inboxEmptyTitle => 'Chưa có tin nhắn nào';

  @override
  String get inboxEmptyMessage =>
      'Gửi tin nhắn đầu tiên cho người bán để trao đổi về dự án của bạn. Mọi cuộc trò chuyện sẽ xuất hiện tại đây.';

  @override
  String get inboxFilterEmptyTitle => 'Thử điều chỉnh bộ lọc';

  @override
  String inboxFilterEmptyMessage(String filter) {
    return 'Không có kết quả cho $filter.';
  }

  @override
  String get inboxClearFilter => 'Xoá bộ lọc';

  @override
  String get inboxArchive => 'Lưu trữ';

  @override
  String get inboxUnarchive => 'Bỏ lưu trữ';

  @override
  String get inboxStar => 'Gắn sao';

  @override
  String get inboxUnstar => 'Bỏ gắn sao';

  @override
  String get inboxUnstarShort => 'Bỏ sao';

  @override
  String get inboxMore => 'Thêm';

  @override
  String get inboxChangeLabels => 'Đổi nhãn';

  @override
  String get inboxBlock => 'Chặn';

  @override
  String get inboxUnblock => 'Bỏ chặn';

  @override
  String get inboxReport => 'Báo cáo';

  @override
  String get inboxMarkRead => 'Đánh dấu đã đọc';

  @override
  String get inboxMarkUnread => 'Đánh dấu chưa đọc';

  @override
  String get inboxMarkedRead => 'Đã đánh dấu đã đọc';

  @override
  String get inboxMarkedUnread => 'Đã đánh dấu chưa đọc';

  @override
  String inboxConversationCount(int n) {
    return '$n cuộc trò chuyện';
  }

  @override
  String inboxBulkArchived(int n) {
    return 'Đã lưu trữ $n cuộc trò chuyện';
  }

  @override
  String inboxBulkUnarchived(int n) {
    return 'Đã chuyển $n cuộc trò chuyện về Hộp thư';
  }

  @override
  String inboxBulkStarred(int n) {
    return 'Đã gắn sao $n cuộc trò chuyện';
  }

  @override
  String get inboxUnstarred => 'Đã bỏ gắn sao';

  @override
  String get inboxLabelsUpdated => 'Đã cập nhật nhãn';

  @override
  String inboxBlockManyTitle(int n) {
    return 'Chặn $n người dùng?';
  }

  @override
  String get inboxBlockManyMessage =>
      'Bạn sẽ không nhận được tin nhắn từ những người này nữa.';

  @override
  String get inboxUserBlocked => 'Đã chặn người dùng';

  @override
  String get inboxUserUnblocked => 'Đã bỏ chặn người dùng';

  @override
  String get inboxDeleteTitle => 'Xoá cuộc trò chuyện?';

  @override
  String inboxDeleteManyMessage(int n) {
    return 'Xoá $n cuộc trò chuyện đã chọn? Thao tác này không thể hoàn tác.';
  }

  @override
  String inboxBulkDeleted(int n) {
    return 'Đã xoá $n cuộc trò chuyện';
  }

  @override
  String get inboxUnknownUser => 'Người dùng VietGig';

  @override
  String get inboxUser => 'Người dùng';

  @override
  String get inboxStartConversation => 'Bắt đầu cuộc trò chuyện';

  @override
  String get inboxFilterInbox => 'Hộp thư';

  @override
  String get inboxFilterAll => 'Tất cả';

  @override
  String get inboxFilterUnread => 'Chưa đọc';

  @override
  String get inboxFilterStarred => 'Gắn sao';

  @override
  String get inboxFilterArchived => 'Lưu trữ';

  @override
  String get inboxFilterSpam => 'Spam';

  @override
  String get inboxFilterOffers => 'Báo giá riêng';

  @override
  String get inboxLabelsHeader => 'Nhãn';

  @override
  String get inboxLabelPickerTitle => 'Chọn nhãn';

  @override
  String get inboxApply => 'Áp dụng';

  @override
  String get inboxNewLabelHint => 'Tên nhãn mới';

  @override
  String get inboxAddLabel => 'Thêm nhãn mới';

  @override
  String get inboxArchivedOne => 'Đã lưu trữ cuộc trò chuyện';

  @override
  String get inboxUnarchivedOne => 'Đã chuyển cuộc trò chuyện về Hộp thư';

  @override
  String get inboxStarredOne => 'Đã gắn sao cuộc trò chuyện';

  @override
  String get inboxBlockTitle => 'Chặn người dùng này?';

  @override
  String get inboxBlockMessage =>
      'Bạn sẽ không nhận được tin nhắn từ người này nữa. Bạn có thể bỏ chặn trong mục Spam.';

  @override
  String get inboxDeleteMessage =>
      'Bạn có chắc muốn xoá cuộc trò chuyện này? Thao tác này không thể hoàn tác.';

  @override
  String get inboxDeletedOne => 'Đã xoá cuộc trò chuyện';

  @override
  String get inboxReportTitle => 'Báo cáo người dùng';

  @override
  String get inboxReportFraud => 'Lừa đảo hoặc gian lận';

  @override
  String get inboxReportOffsite => 'Yêu cầu thanh toán ngoài VietGig';

  @override
  String get inboxReportAbuse => 'Ngôn từ xúc phạm';

  @override
  String get inboxReportSpam => 'Spam';

  @override
  String get inboxReportThanks =>
      'Cảm ơn bạn! Chúng tôi sẽ xem xét báo cáo trong 24 giờ.';

  @override
  String get inboxAutoReply => 'Cảm ơn bạn! Mình sẽ phản hồi chi tiết sớm nhé.';

  @override
  String get inboxSendFailed => 'Không gửi được tin nhắn. Vui lòng thử lại.';

  @override
  String get inboxYou => 'Bạn';

  @override
  String inboxPlainFile(String name) {
    return 'Tệp: $name';
  }

  @override
  String inboxPlainOffer(String title, String price) {
    return 'Báo giá: $title – $price';
  }

  @override
  String get inboxVideoInvite => 'Lời mời gọi video';

  @override
  String get inboxVideoInviteText => 'Mình mời bạn tham gia cuộc gọi video nhé';

  @override
  String get inboxAttachAlbum => 'Album ảnh';

  @override
  String get inboxAttachCamera => 'Máy ảnh';

  @override
  String get inboxAttachFile => 'Gửi tệp';

  @override
  String get inboxAttachOffer => 'Tạo báo giá';

  @override
  String get inboxAttachVideo => 'Bắt đầu gọi video';

  @override
  String get inboxQuickReplies => 'Trả lời nhanh';

  @override
  String get inboxQuickFallbackName => 'bạn';

  @override
  String get inboxReply => 'Trả lời';

  @override
  String get inboxForward => 'Chuyển tiếp';

  @override
  String get inboxCopy => 'Sao chép';

  @override
  String get inboxCopied => 'Đã sao chép tin nhắn';

  @override
  String inboxForwarded(int n) {
    return 'Đã chuyển tiếp tới $n cuộc trò chuyện';
  }

  @override
  String get inboxWithdrawOfferTitle => 'Rút lại báo giá?';

  @override
  String get inboxWithdrawOfferMessage =>
      'Khách hàng sẽ không thể chấp nhận báo giá này nữa.';

  @override
  String get inboxDeclineOfferTitle => 'Từ chối báo giá?';

  @override
  String get inboxDeclineOfferMessage =>
      'Người bán sẽ được thông báo rằng bạn đã từ chối báo giá này.';

  @override
  String get inboxWithdraw => 'Rút lại';

  @override
  String get inboxDecline => 'Từ chối';

  @override
  String get inboxOfferWithdrawn => 'Đã rút lại báo giá';

  @override
  String get inboxOfferDeclined => 'Đã từ chối báo giá';

  @override
  String get inboxSafetyTitle => 'Chúng tôi luôn bảo vệ bạn';

  @override
  String get inboxCallDialogMessage =>
      'VietGig ghi lại các cuộc gọi video để giữ an toàn cho cả hai bên và hỗ trợ giải quyết khi có tranh chấp. Vui lòng không chia sẻ thông tin thanh toán trong cuộc gọi.';

  @override
  String get inboxOpenCall => 'Mở cuộc gọi';

  @override
  String get inboxCallConnecting => 'Đang kết nối cuộc gọi video… (mô phỏng)';

  @override
  String get inboxCallGuidelinesTitle => 'Hướng dẫn gọi video';

  @override
  String get inboxCallGuidelinesMessage =>
      '• Chỉ trao đổi nội dung liên quan tới dự án.\n• Không chia sẻ thông tin thanh toán hoặc liên hệ ngoài VietGig.\n• Cuộc gọi được ghi lại và lưu trong 30 ngày.\n• Bạn có thể báo cáo hành vi không phù hợp sau cuộc gọi.';

  @override
  String get inboxGotIt => 'Đã hiểu';

  @override
  String get inboxActiveOrdersTitle => 'Đơn hàng đang thực hiện';

  @override
  String get inboxNoOrdersTitle => 'Chưa có đơn hàng nào';

  @override
  String inboxNoOrdersMessage(String name) {
    return 'Bạn chưa có đơn hàng đang thực hiện với $name.';
  }

  @override
  String get inboxThisPartner => 'đối tác này';

  @override
  String inboxOrderDue(String date, String price) {
    return 'Hạn giao: $date · $price';
  }

  @override
  String get inboxMessagesTitle => 'Tin nhắn';

  @override
  String get inboxOnline => 'Online';

  @override
  String inboxLocalTime(String time) {
    return 'Giờ địa phương $time';
  }

  @override
  String get inboxOptionsTooltip => 'Tuỳ chọn';

  @override
  String get inboxLoadFailed => 'Không tải được tin nhắn';

  @override
  String get inboxNotFoundTitle => 'Không tìm thấy cuộc trò chuyện';

  @override
  String get inboxNotFoundMessage => 'Cuộc trò chuyện có thể đã bị xoá.';

  @override
  String get inboxScrollDown => 'Cuộn xuống cuối';

  @override
  String get inboxBlockedNotice => 'Bạn đã chặn người dùng này.';

  @override
  String get inboxSafetyDialogTitle => 'Giữ an toàn trên VietGig';

  @override
  String get inboxSafetyDialogMessage =>
      'Khi thanh toán và trao đổi qua VietGig, bạn được bảo vệ bởi chính sách hoàn tiền và đội ngũ hỗ trợ. Đừng bao giờ chuyển khoản trực tiếp hoặc chia sẻ thông tin đăng nhập cho người khác.';

  @override
  String inboxStartChatHint(String name) {
    return 'Gửi tin nhắn cho $name để bắt đầu trò chuyện.';
  }

  @override
  String get inboxPartner => 'đối tác';

  @override
  String inboxTyping(String name) {
    return '$name đang soạn tin…';
  }

  @override
  String get inboxPartnerCap => 'Đối tác';

  @override
  String get inboxAttachment => 'Tệp đính kèm';

  @override
  String inboxDownloading(String name) {
    return 'Đang tải xuống $name…';
  }

  @override
  String get inboxFileFallback => 'tệp';

  @override
  String get inboxCallCancelled => 'Đã huỷ lời mời gọi video';

  @override
  String get inboxCallDeclined => 'Đã từ chối lời mời gọi video';

  @override
  String inboxReplyingTo(String name) {
    return 'Đang trả lời $name…';
  }

  @override
  String get inboxAttachTooltip => 'Đính kèm';

  @override
  String get inboxInputHint => 'Nhập tin nhắn…';

  @override
  String get inboxSend => 'Gửi';

  @override
  String get inboxToday => 'Hôm nay';

  @override
  String get inboxSafetyBanner =>
      'Vì sự an toàn của bạn, hãy giữ mọi thanh toán và trao đổi trên VietGig. ';

  @override
  String get inboxLearnMore => 'Tìm hiểu thêm';

  @override
  String get inboxRelatedTo => 'Tin nhắn này liên quan tới:';

  @override
  String inboxMilestoneCount(int n) {
    return '$n cột mốc';
  }

  @override
  String inboxDeliverIn(int n) {
    return 'Giao trong $n ngày';
  }

  @override
  String inboxOptionsSummary(int n, String list) {
    return '$n tuỳ chọn: $list';
  }

  @override
  String inboxOfferPrice(String price) {
    return 'Giá báo: $price';
  }

  @override
  String inboxOfferExpiresAt(String time) {
    return 'Báo giá hết hạn lúc $time';
  }

  @override
  String get inboxViewFullOffer => 'Xem toàn bộ báo giá';

  @override
  String get inboxWithdrawOffer => 'Rút lại báo giá';

  @override
  String get inboxVideoSent => 'Bạn đã gửi lời mời gọi video';

  @override
  String get inboxVideoJoinPrompt => 'Đang tham gia?';

  @override
  String get inboxVideoGuidelinesLink => 'Xem hướng dẫn gọi video';

  @override
  String get inboxVideoRecorded =>
      'Cuộc gọi video sẽ được ghi lại và lưu trữ để mọi người tham gia có thể tải về.';

  @override
  String get inboxVideoDeclinedLabel => 'Đã từ chối lời mời';

  @override
  String get inboxJoin => 'Tham gia';

  @override
  String get inboxCancelInvite => 'Huỷ lời mời';

  @override
  String get inboxOptCustomAssets => 'Tài nguyên tuỳ chỉnh';

  @override
  String get inboxOptResponsive => 'Thiết kế responsive';

  @override
  String get inboxOptWireframe => 'Wireframe';

  @override
  String get inboxOptPrototype => 'Prototype';

  @override
  String get inboxOptSourceFiles => 'File nguồn';

  @override
  String inboxOptPages(int n) {
    return '$n trang/màn hình';
  }

  @override
  String get inboxPagesLabel => 'Số trang/màn hình';

  @override
  String get inboxErrGig => 'Vui lòng chọn dịch vụ';

  @override
  String get inboxErrDescEmpty => 'Vui lòng nhập mô tả báo giá';

  @override
  String get inboxErrDescShort => 'Mô tả cần ít nhất 20 ký tự';

  @override
  String get inboxErrPriceEmpty => 'Vui lòng nhập tổng giá';

  @override
  String inboxErrMinPrice(String price) {
    return 'Giá tối thiểu $price';
  }

  @override
  String get inboxErrDays => 'Vui lòng chọn thời gian giao';

  @override
  String get inboxErrMilestones => 'Cần ít nhất 2 cột mốc';

  @override
  String get inboxErrTemplate => 'Vui lòng đặt tên cho mẫu';

  @override
  String get inboxErrMsTitle => 'Vui lòng nhập tên cột mốc';

  @override
  String get inboxErrMsDesc => 'Vui lòng nhập mô tả';

  @override
  String get inboxLinkGigTitle => 'Liên kết với dịch vụ';

  @override
  String get inboxPayTypeTitle => 'Bạn muốn nhận thanh toán thế nào?';

  @override
  String get inboxPayTypeSubtitle => 'Chọn hình thức phù hợp nhất với dự án.';

  @override
  String get inboxPaySingle => 'Thanh toán một lần';

  @override
  String get inboxPaySingleDesc =>
      'Nhận toàn bộ thanh toán khi hoàn thành dự án.';

  @override
  String get inboxPayMilestone => 'Theo cột mốc';

  @override
  String get inboxPayMilestoneDesc =>
      'Làm từng bước và nhận thanh toán sau mỗi cột mốc hoàn thành.';

  @override
  String get inboxDeliveryTime => 'Thời gian giao';

  @override
  String get inboxRevisionsTitle => 'Số lượt sửa';

  @override
  String get inboxNoRevisions => 'Không sửa';

  @override
  String inboxRevisionsCount(int n) {
    return '$n lượt sửa';
  }

  @override
  String get inboxOfferExpiry => 'Thời hạn báo giá';

  @override
  String get inboxCheckOffer => 'Vui lòng kiểm tra lại thông tin báo giá';

  @override
  String inboxOfferSentTemplate(String name) {
    return 'Đã gửi báo giá và lưu mẫu “$name”';
  }

  @override
  String get inboxOfferSent => 'Đã gửi báo giá';

  @override
  String get inboxOfferSendFailed =>
      'Không gửi được báo giá. Vui lòng thử lại.';

  @override
  String get inboxCreateOfferTitle => 'Tạo báo giá';

  @override
  String get inboxGigsLoadFailed => 'Không tải được dịch vụ';

  @override
  String get inboxLinkOfferToGig => 'Liên kết báo giá với dịch vụ';

  @override
  String get inboxChange => 'Đổi';

  @override
  String get inboxNoGigs => 'Bạn chưa có dịch vụ nào để liên kết.';

  @override
  String get inboxOfferDescHeader => 'Mô tả báo giá';

  @override
  String get inboxOfferDescHint => 'VD: sản phẩm bàn giao, tiến độ, số lượng…';

  @override
  String get inboxTotalPrice => 'Tổng giá';

  @override
  String get inboxPick => 'Chọn';

  @override
  String get inboxRevisionsOptional => 'Số lượt sửa (tuỳ chọn)';

  @override
  String inboxMilestoneRowSummary(String price, int days, int revisions) {
    return '$price | $days ngày | $revisions lượt sửa';
  }

  @override
  String inboxMaxMilestones(int n) {
    return 'Tối đa $n cột mốc';
  }

  @override
  String get inboxAddMilestone => 'Thêm cột mốc';

  @override
  String inboxMilestoneTotal(String price, int days, int revisions) {
    return 'Tổng: $price | $days ngày | $revisions lượt sửa';
  }

  @override
  String get inboxAddOptions => 'Thêm tuỳ chọn';

  @override
  String get inboxServiceOptions => 'Tuỳ chọn dịch vụ';

  @override
  String inboxSelectedN(int n) {
    return 'Đã chọn $n';
  }

  @override
  String get inboxOfferSettings => 'Thiết lập báo giá';

  @override
  String get inboxRequireInfo => 'Yêu cầu khách gửi thông tin';

  @override
  String get inboxRequireInfoDesc =>
      'Khách cần trả lời câu hỏi yêu cầu trước khi bắt đầu';

  @override
  String get inboxSaveTemplate => 'Lưu làm mẫu';

  @override
  String get inboxReuseTemplate => 'Dùng lại cho các báo giá sau';

  @override
  String get inboxTemplateNameHint => 'Đặt tên cho mẫu';

  @override
  String get inboxSendMilestoneOffer => 'Gửi báo giá cột mốc';

  @override
  String get inboxSendOffer => 'Gửi báo giá';

  @override
  String inboxMilestoneN(int n) {
    return 'Cột mốc $n';
  }

  @override
  String get inboxDeleteMilestone => 'Xoá cột mốc';

  @override
  String get inboxDeleteMilestoneTitle => 'Xoá cột mốc này?';

  @override
  String get inboxMsTitleHeader => 'Tên cột mốc';

  @override
  String get inboxMsTitleHint => 'VD: Wireframe & concept';

  @override
  String get inboxDescHeader => 'Mô tả';

  @override
  String get inboxMsDescHint => 'Sản phẩm bàn giao, phạm vi công việc…';

  @override
  String inboxMsPriceLabel(String price) {
    return 'Giá (tối thiểu $price)';
  }

  @override
  String get inboxViewOffer => 'Xem báo giá';

  @override
  String get inboxViewMilestoneOffer => 'Xem báo giá theo cột mốc';

  @override
  String get inboxOfferNotFound => 'Không tìm thấy báo giá';

  @override
  String get inboxOfferNotFoundMessage => 'Báo giá này có thể đã bị xoá.';

  @override
  String inboxFirstMilestoneCharge(String price) {
    return 'Bạn chỉ bị tính phí cho cột mốc đầu tiên ($price).';
  }

  @override
  String get inboxContinueCheckout => 'Tiếp tục thanh toán';

  @override
  String inboxOfferStatusBanner(String status) {
    return 'Báo giá này $status.';
  }

  @override
  String get inboxOfferDetails => 'Chi tiết báo giá';

  @override
  String get inboxDetailPrice => 'Giá';

  @override
  String get inboxDetailTime => 'Thời gian';

  @override
  String get inboxDetailRevisions => 'Lượt sửa';

  @override
  String get inboxDetailExpires => 'Hết hạn';

  @override
  String get inboxDetailRequirements => 'Yêu cầu';

  @override
  String get inboxDetailRequirementsValue =>
      'Cần gửi thông tin trước khi bắt đầu';

  @override
  String get inboxIncludes => 'Bao gồm';

  @override
  String get inboxMilestoneDetails => 'Chi tiết cột mốc';

  @override
  String get inboxMilestoneTooltip =>
      'Người bán sẽ giao từng cột mốc. Bạn thanh toán cho từng cột mốc trước khi bắt đầu.';

  @override
  String get inboxTotal => 'Tổng cộng';

  @override
  String inboxMilestoneLine(int days, String price, int revisions) {
    return '$days ngày | $price | $revisions lượt sửa';
  }

  @override
  String get inboxOpening => 'Đang mở cuộc trò chuyện…';

  @override
  String get inboxOpenFailed => 'Không mở được cuộc trò chuyện';

  @override
  String get inboxForwardTitle => 'Chuyển tiếp tin nhắn';

  @override
  String get inboxRecentConversations => 'Cuộc trò chuyện gần đây';

  @override
  String get inboxNoOtherConversations => 'Chưa có cuộc trò chuyện khác';

  @override
  String inboxForwardCount(int n) {
    return 'Chuyển tiếp ($n)';
  }

  @override
  String get inboxAddNew => 'Thêm mới';

  @override
  String get inboxQuickEmptyTitle => 'Chưa có mẫu trả lời nhanh';

  @override
  String get inboxQuickEmptyMessage =>
      'Tạo mẫu để trả lời khách hàng chỉ với một chạm.';

  @override
  String get inboxQuickSaved => 'Đã lưu mẫu trả lời nhanh';

  @override
  String get inboxQuickNewTitle => 'Trả lời nhanh mới';

  @override
  String get inboxQuickName => 'Tên';

  @override
  String get inboxQuickNameHint => 'Đặt tên cho mẫu trả lời';

  @override
  String get inboxQuickBody => 'Nội dung tin nhắn';

  @override
  String get inboxQuickBodyHint => 'Nhập nội dung…';

  @override
  String inboxQuickTip(String token) {
    return 'Mẹo: gõ $token để tự động chèn tên người nhận.';
  }

  @override
  String get ordersNotFoundTitle => 'Không tìm thấy đơn hàng';

  @override
  String get ordersNotFoundMessage =>
      'Đơn hàng có thể đã bị xoá hoặc bạn không có quyền xem.';

  @override
  String get ordersNotFoundAction => 'Về danh sách đơn hàng';

  @override
  String get ordersUnknownUser => 'Người dùng VietGig';

  @override
  String get ordersAttachTitle => 'Đính kèm tệp';

  @override
  String get ordersAttachCamera => 'Mở máy ảnh';

  @override
  String get ordersAttachGallery => 'Mở thư viện ảnh';

  @override
  String get ordersAttachFile => 'Tệp';

  @override
  String get ordersRemoveFile => 'Xoá tệp';

  @override
  String get ordersApply => 'Áp dụng';

  @override
  String get ordersSend => 'Gửi';

  @override
  String ordersInfoDateCode(String date, String code) {
    return '$date · Mã đơn $code';
  }

  @override
  String ordersInfoExtra(String name) {
    return 'Dịch vụ thêm: $name';
  }

  @override
  String get ordersInfoSubtotal => 'Tạm tính';

  @override
  String get ordersInfoServiceFee => 'Phí dịch vụ';

  @override
  String get ordersInfoTip => 'Tiền tip';

  @override
  String get ordersInfoTotal => 'Tổng thanh toán';

  @override
  String get ordersInfoDueDate => 'Ngày giao';

  @override
  String get ordersInfoPaidWith => 'Thanh toán qua';

  @override
  String get ordersManageTitle => 'Quản lý đơn hàng';

  @override
  String get ordersNotifications => 'Thông báo';

  @override
  String get ordersOptions => 'Tuỳ chọn';

  @override
  String get ordersSortDue => 'Hạn giao gần nhất';

  @override
  String get ordersSortNewest => 'Mới đặt gần đây';

  @override
  String get ordersTabNeedsAction => 'Cần xử lý';

  @override
  String get ordersTabInProgress => 'Đang thực hiện';

  @override
  String get ordersTabNew => 'Mới';

  @override
  String get ordersTabDelivered => 'Đã giao';

  @override
  String get ordersTabCompleted => 'Hoàn thành';

  @override
  String get ordersTabCancelled => 'Đã huỷ';

  @override
  String ordersTabWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get ordersFilterTitle => 'Sắp xếp & lọc';

  @override
  String get ordersFilterReset => 'Đặt lại';

  @override
  String get ordersFilterSortBy => 'Sắp xếp theo';

  @override
  String get ordersFilterStatus => 'Trạng thái';

  @override
  String get ordersFilterAll => 'Tất cả';

  @override
  String get ordersGroupOverdue => 'Đã quá hạn';

  @override
  String get ordersGroupDue2Days => 'Đến hạn trong 2 ngày';

  @override
  String get ordersGroupDue2To5Days => 'Đến hạn trong 2–5 ngày';

  @override
  String get ordersGroupDueLater => 'Đến hạn sau 5 ngày';

  @override
  String get ordersEmptyTitle => 'Tất cả đơn hàng của bạn ở đây';

  @override
  String get ordersEmptySellerMessage =>
      'Khi khách đặt dịch vụ của bạn, đơn hàng sẽ xuất hiện tại đây.';

  @override
  String get ordersEmptyBuyerMessage =>
      'Khi bạn đặt một dịch vụ, bạn có thể theo dõi tiến độ đơn hàng tại đây.';

  @override
  String get ordersEmptySellerAction => 'Quản lý dịch vụ của tôi';

  @override
  String get ordersEmptyBuyerAction => 'Khám phá dịch vụ';

  @override
  String ordersCardMenuTitle(String code) {
    return 'Đơn hàng $code';
  }

  @override
  String get ordersCardMenuOpen => 'Xem chi tiết đơn hàng';

  @override
  String get ordersCardMenuChatBuyer => 'Nhắn tin cho khách';

  @override
  String get ordersCardMenuChatSeller => 'Nhắn tin cho người bán';

  @override
  String get ordersResolutionCenter => 'Trung tâm giải quyết';

  @override
  String get ordersCopyCode => 'Sao chép mã đơn';

  @override
  String ordersCodeCopied(String code) {
    return 'Đã sao chép mã đơn $code';
  }

  @override
  String get ordersCardUser => 'Người dùng';

  @override
  String get ordersCardLoading => 'Đang tải…';

  @override
  String ordersCardDue(String date) {
    return 'Hạn giao $date';
  }

  @override
  String ordersCardPlaced(String date) {
    return 'Đặt ngày $date';
  }

  @override
  String ordersDetailError(String error) {
    return 'Có lỗi xảy ra: $error';
  }

  @override
  String get ordersDetailMenuUnread => 'Đánh dấu chưa đọc';

  @override
  String get ordersDetailMenuExtra => 'Thêm dịch vụ';

  @override
  String get ordersDetailDeliver => 'Giao đơn hàng';

  @override
  String get ordersDetailMenuGig => 'Xem dịch vụ';

  @override
  String get ordersDetailMarkedUnread => 'Đã đánh dấu đơn hàng là chưa đọc';

  @override
  String get ordersDetailPickExtra => 'Chọn dịch vụ bạn muốn thêm ở phía trên';

  @override
  String ordersDetailAddExtraTitle(String title) {
    return 'Thêm \"$title\"?';
  }

  @override
  String ordersDetailAddExtraMessage(String price) {
    return 'Bạn sẽ thanh toán thêm $price.';
  }

  @override
  String ordersDetailAddExtraMessageDays(String price, int days) {
    return 'Bạn sẽ thanh toán thêm $price và thời gian giao kéo dài thêm $days ngày.';
  }

  @override
  String get ordersDetailAddExtraConfirm => 'Thêm';

  @override
  String ordersDetailExtraAdded(String title) {
    return 'Đã thêm \"$title\" vào đơn hàng';
  }

  @override
  String get ordersDetailRequestAccepted => 'Bạn đã chấp nhận yêu cầu';

  @override
  String get ordersDetailRequestDeclined => 'Bạn đã từ chối yêu cầu';

  @override
  String get ordersDetailApproveTitle => 'Sẵn sàng nhận bản cuối?';

  @override
  String get ordersDetailApproveMessage =>
      'Sau bước này bạn sẽ không thể yêu cầu chỉnh sửa cho đơn hàng nữa.';

  @override
  String get ordersDetailCompletedSnack => 'Đơn hàng đã hoàn thành!';

  @override
  String get ordersDetailRequestRevision => 'Yêu cầu chỉnh sửa';

  @override
  String get ordersDetailNeedMoreTime => 'Tôi cần thêm thời gian để xem';

  @override
  String get ordersDetailNewTag => 'MỚI';

  @override
  String get ordersDetailResolutionPrefix =>
      'Nếu gặp vấn đề với đơn hàng, hãy vào ';

  @override
  String get ordersDetailRevisionSubtitle =>
      'Mô tả rõ những điểm bạn muốn người bán thay đổi.';

  @override
  String get ordersDetailRevisionHint =>
      'VD: Bạn có thể đổi màu chủ đạo sang xanh đậm hơn không?';

  @override
  String get ordersDetailSendRequest => 'Gửi yêu cầu';

  @override
  String get ordersDetailRevisionSent =>
      'Đã gửi yêu cầu chỉnh sửa cho người bán';

  @override
  String get ordersDetailMoreTimeTitle => 'Thêm thời gian xem bản giao';

  @override
  String get ordersDetailMoreTimeMessage =>
      'Bạn cần thêm bao nhiêu ngày? Bạn có thể quay lại thêm nếu cần – tối đa 5 ngày.';

  @override
  String ordersDetailNewReviewDeadline(String date) {
    return 'Hạn duyệt mới: $date';
  }

  @override
  String get ordersDetailExtendReview => 'Gia hạn thời gian xem';

  @override
  String ordersDetailReviewExtended(int days) {
    return 'Xong! Bạn có thêm $days ngày để xem bản giao.';
  }

  @override
  String get ordersDetailRemindOn =>
      'Chúng tôi sẽ nhắc bạn 1 ngày trước hạn giao';

  @override
  String get ordersDetailRemindOff => 'Đã tắt nhắc nhở';

  @override
  String get ordersDetailThanksTitle => 'Cảm ơn bạn đã đặt hàng!';

  @override
  String get ordersDetailThanksMessage => 'Người bán sẽ bắt tay vào làm ngay.';

  @override
  String get ordersDetailWaitingRequirements => 'Đang chờ khách gửi yêu cầu';

  @override
  String get ordersDetailSubmitRequirements =>
      'Gửi yêu cầu để bắt đầu đơn hàng';

  @override
  String get ordersDetailWaitingRequirementsMessage =>
      'Đơn hàng sẽ bắt đầu khi khách gửi đầy đủ thông tin bạn yêu cầu.';

  @override
  String get ordersDetailSubmitRequirementsMessage =>
      'Người bán cần thông tin từ bạn. Thời gian giao chỉ bắt đầu tính sau khi bạn gửi yêu cầu.';

  @override
  String get ordersDetailLetterToBuyer => 'Thư gửi khách';

  @override
  String get ordersDetailExtend => 'Gia hạn';

  @override
  String get ordersDetailExtrasTitle => 'Thêm dịch vụ cho đơn hàng';

  @override
  String get ordersDetailHide => 'Ẩn';

  @override
  String get ordersDetailAddMore => '+ Thêm nữa';

  @override
  String get ordersDetailAdd => '+ Thêm';

  @override
  String get ordersDetailCancelRequestTitle => 'Yêu cầu huỷ đơn hàng';

  @override
  String get ordersDetailExtensionRequestTitle => 'Yêu cầu gia hạn';

  @override
  String get ordersDetailCancelRequestedByYou =>
      'Bạn đã yêu cầu huỷ đơn hàng này.';

  @override
  String ordersDetailCancelRequestedBy(String name) {
    return '$name đã yêu cầu huỷ đơn hàng này.';
  }

  @override
  String ordersDetailExtensionRequestedByYou(int days) {
    return 'Bạn đã yêu cầu gia hạn ngày giao thêm $days ngày.';
  }

  @override
  String ordersDetailExtensionRequestedBy(String name, int days) {
    return '$name đã yêu cầu gia hạn ngày giao thêm $days ngày.';
  }

  @override
  String get ordersDetailExtensionLength => 'Thời lượng gia hạn';

  @override
  String get ordersDetailNewDueDate => 'Ngày giao mới';

  @override
  String ordersDetailAwaitingResponse(String name, String date) {
    return 'Đang chờ phản hồi từ $name (tới $date)';
  }

  @override
  String ordersDetailRespondBefore(String date) {
    return 'Bạn cần phản hồi trước $date, nếu không yêu cầu sẽ tự động được chấp nhận.';
  }

  @override
  String get ordersDetailAccept => 'Chấp nhận';

  @override
  String get ordersDetailDecline => 'Từ chối';

  @override
  String get ordersDetailYouDelivered => 'Bạn đã giao đơn hàng';

  @override
  String get ordersDetailYourDelivery => 'Đây là bản giao của bạn';

  @override
  String ordersDetailFileCount(int n) {
    return '$n tệp';
  }

  @override
  String ordersDetailDownloadingAll(int n) {
    return 'Đang tải $n tệp về máy…';
  }

  @override
  String get ordersDetailDownloadAll => 'Tải tất cả';

  @override
  String get ordersDetailVirusScanned => 'Đã quét virus';

  @override
  String ordersDetailDownloadingFile(String name) {
    return 'Đang tải \"$name\"…';
  }

  @override
  String get ordersDetailAwaitingBuyerReview =>
      'Đang chờ khách duyệt bản giao.';

  @override
  String ordersDetailBuyerReviewUntil(String date) {
    return 'Khách có tới $date để duyệt. Sau thời điểm này đơn sẽ tự động hoàn thành.';
  }

  @override
  String get ordersDetailApproveDelivery => 'Duyệt bản giao';

  @override
  String get ordersDetailNotReady => 'Chưa sẵn sàng';

  @override
  String get ordersDetailReviewHint =>
      'Hãy duyệt bản giao, yêu cầu chỉnh sửa hoặc xin thêm thời gian để xem.';

  @override
  String ordersDetailReviewUntil(String date) {
    return 'Bạn có tới $date để duyệt bản giao, yêu cầu chỉnh sửa hoặc thêm thời gian xem. Sau thời điểm này, đơn hàng sẽ được tự động đánh dấu hoàn thành.';
  }

  @override
  String get ordersDetailCompletedTitle => 'Đơn hàng đã hoàn thành';

  @override
  String get ordersDetailCompletedMessage => 'Cảm ơn bạn đã sử dụng VietGig.';

  @override
  String get ordersDetailBuyerReview => 'Đánh giá của khách';

  @override
  String get ordersDetailMyReview => 'Đánh giá của tôi';

  @override
  String get ordersDetailNoBuyerReview => 'Khách chưa để lại đánh giá.';

  @override
  String get ordersDetailShareExperience =>
      'Chia sẻ trải nghiệm của bạn để giúp người mua khác lựa chọn.';

  @override
  String get ordersDetailWriteReview => 'Viết đánh giá';

  @override
  String ordersDetailTipped(String amount, String name) {
    return 'Bạn đã tip $amount cho $name. Cảm ơn bạn!';
  }

  @override
  String get ordersDetailTipTitle => 'Người bán xuất sắc xứng đáng được tip';

  @override
  String get ordersDetailTipMessage => 'Tip được chuyển 100% cho người bán.';

  @override
  String get ordersDetailSendTip => 'Gửi tip';

  @override
  String get ordersDetailCancelledTitle => 'Đơn hàng đã bị huỷ';

  @override
  String get ordersDetailCancelledMessage =>
      'Số tiền đã được hoàn vào số dư VietGig của bạn.';

  @override
  String get ordersDetailExpectedDelivery => 'Ngày giao dự kiến';

  @override
  String get ordersDetailRemindOffAction => 'Tắt nhắc';

  @override
  String get ordersDetailRemindMe => 'Nhắc tôi';

  @override
  String ordersDetailAddedToCalendar(String date) {
    return 'Đã thêm hạn giao $date vào lịch';
  }

  @override
  String get ordersDetailAddToCalendar => 'Thêm vào lịch';

  @override
  String get ordersDetailActivity => 'Hoạt động';

  @override
  String get ordersCheckoutTitle => 'Nâng cấp';

  @override
  String get ordersCheckoutGigNotFoundTitle => 'Không tìm thấy dịch vụ';

  @override
  String get ordersCheckoutGigNotFoundMessage =>
      'Dịch vụ này có thể đã ngừng bán.';

  @override
  String get ordersCheckoutExploreOther => 'Khám phá dịch vụ khác';

  @override
  String get ordersCheckoutSelectedPackage => 'Gói đã chọn';

  @override
  String ordersCheckoutDeliveryIn(int days) {
    return 'Giao trong $days ngày';
  }

  @override
  String ordersCheckoutRevisions(String revisions) {
    return '$revisions lượt chỉnh sửa';
  }

  @override
  String get ordersCheckoutAddExtras => 'Thêm dịch vụ cho đơn hàng';

  @override
  String get ordersCheckoutNoExtras => 'Dịch vụ này không có tuỳ chọn bổ sung.';

  @override
  String ordersCheckoutEstimatedDelivery(int days) {
    return 'Thời gian giao dự kiến: $days ngày';
  }

  @override
  String ordersCheckoutContinue(String amount) {
    return 'Tiếp tục ($amount)';
  }

  @override
  String get ordersCheckoutNoExtraTime => 'Không thêm thời gian';

  @override
  String ordersCheckoutExtraDays(int days) {
    return '+$days ngày';
  }

  @override
  String ordersCheckoutFasterDays(int days) {
    return 'Giao nhanh hơn $days ngày';
  }

  @override
  String get ordersCheckoutQuantity => 'Số lượng';

  @override
  String get ordersAddCardTitle => 'Thêm thẻ mới';

  @override
  String get ordersAddCardInvalidNumber => 'Số thẻ không hợp lệ';

  @override
  String get ordersAddCardInvalidMonth => 'Tháng không hợp lệ';

  @override
  String get ordersAddCardExpired => 'Thẻ đã hết hạn';

  @override
  String get ordersAddCardHolderPlaceholder => 'HỌ TÊN CHỦ THẺ';

  @override
  String get ordersAddCardNumber => 'Số thẻ';

  @override
  String get ordersAddCardNumberRequired => 'Vui lòng nhập số thẻ hợp lệ';

  @override
  String get ordersAddCardLastName => 'Họ';

  @override
  String get ordersAddCardFirstName => 'Tên';

  @override
  String get ordersAddCardRequired => 'Bắt buộc';

  @override
  String get ordersAddCardCvvHelp => '3–4 chữ số ở mặt sau thẻ';

  @override
  String get ordersAddCardSecure =>
      'Thông tin thẻ được mã hoá và lưu trữ an toàn.';

  @override
  String get ordersAddCardPay => 'Thanh toán';

  @override
  String get ordersReviewTitle => 'Xem lại đơn hàng';

  @override
  String get ordersReviewMethodCard => 'Thẻ tín dụng/ghi nợ';

  @override
  String get ordersReviewMethodBank => 'Chuyển khoản ngân hàng';

  @override
  String get ordersReviewPromoTitle => 'Mã khuyến mãi';

  @override
  String get ordersReviewPromoHint => 'Nhập mã, VD: VIETGIG10';

  @override
  String get ordersReviewPromoEmpty => 'Vui lòng nhập mã';

  @override
  String get ordersReviewPromoInvalid => 'Mã không hợp lệ hoặc đã hết hạn';

  @override
  String ordersReviewPromoApplied(String code) {
    return 'Đã áp dụng mã $code – giảm 10%';
  }

  @override
  String get ordersReviewCardAdded => 'Đã thêm thẻ thanh toán';

  @override
  String ordersReviewPayFailed(String error) {
    return 'Thanh toán thất bại: $error';
  }

  @override
  String get ordersReviewSuccessTitle => 'Tuyệt vời! Đơn hàng đã được tạo';

  @override
  String get ordersReviewSuccessNeedRequirements =>
      'Hãy gửi yêu cầu để người bán bắt đầu thực hiện đơn hàng của bạn.';

  @override
  String get ordersReviewSuccessStarted =>
      'Người bán sẽ bắt đầu thực hiện ngay. Chúc mừng bước đầu tiên của bạn!';

  @override
  String get ordersReviewViewOrder => 'Xem đơn hàng';

  @override
  String get ordersReviewCustomOffer => 'Báo giá riêng';

  @override
  String get ordersReviewPaymentMethod => 'Phương thức thanh toán';

  @override
  String get ordersReviewCardSaved => 'Thẻ đã lưu – sẵn sàng thanh toán';

  @override
  String get ordersReviewOrderDetails => 'Chi tiết đơn hàng';

  @override
  String get ordersReviewExtras => 'Dịch vụ thêm';

  @override
  String get ordersReviewSummary => 'Tóm tắt';

  @override
  String get ordersReviewFeeTooltip =>
      'Phí giúp VietGig vận hành nền tảng và hỗ trợ khách hàng 24/7.';

  @override
  String get ordersReviewEnterCode => 'Nhập mã';

  @override
  String get ordersReviewTotal => 'Tổng';

  @override
  String get ordersReviewEstimatedDelivery => 'Ngày giao dự kiến';

  @override
  String get ordersReviewTerms =>
      'Khi nhấn nút bên dưới, bạn đồng ý với Điều khoản dịch vụ và Chính sách thanh toán của VietGig. Số tiền chỉ được chuyển cho người bán khi bạn duyệt bản giao.';

  @override
  String get ordersReviewSecure => 'Thông tin thanh toán của bạn được bảo mật';

  @override
  String get ordersReviewAddPayment => 'Thêm phương thức thanh toán';

  @override
  String ordersReviewPay(String amount) {
    return 'Thanh toán ($amount)';
  }

  @override
  String get ordersReviewProcessing => 'Đang xử lý đơn hàng của bạn…';

  @override
  String get ordersReviewDontClose => 'Vui lòng không đóng ứng dụng.';

  @override
  String get ordersReqTitle => 'Yêu cầu';

  @override
  String get ordersReqFallbackQuestion =>
      'Hãy mô tả chi tiết yêu cầu của bạn cho đơn hàng này.';

  @override
  String ordersReqSendFailed(String error) {
    return 'Không gửi được yêu cầu: $error';
  }

  @override
  String get ordersReqSent => 'Đã gửi yêu cầu. Đơn hàng của bạn đã bắt đầu!';

  @override
  String get ordersReqAlreadyTitle => 'Yêu cầu đã được gửi';

  @override
  String get ordersReqAlreadyMessage =>
      'Đơn hàng này không cần thêm thông tin. Bạn có thể nhắn tin cho người bán nếu muốn bổ sung.';

  @override
  String get ordersReqBackToOrder => 'Quay lại đơn hàng';

  @override
  String get ordersReqOptional => '(không bắt buộc)';

  @override
  String get ordersReqConfirm =>
      'Tôi xác nhận thông tin cung cấp là chính xác và đầy đủ. Mọi thay đổi sau này cần người bán đồng ý và có thể phát sinh chi phí.';

  @override
  String get ordersReqSubmit => 'Gửi yêu cầu';

  @override
  String get ordersReqHint => 'Vui lòng điền thông tin cần thiết';

  @override
  String get ordersReqAttachMore => 'Đính kèm tệp khác';

  @override
  String get ordersDeliverTitle => 'Giao hàng';

  @override
  String get ordersDeliverNoQuickResponses =>
      'Bạn chưa có mẫu trả lời nhanh nào';

  @override
  String get ordersDeliverQuickResponses => 'Trả lời nhanh';

  @override
  String ordersDeliverSendError(String error) {
    return 'Không gửi được bản giao: $error';
  }

  @override
  String get ordersDeliverSent =>
      'Đã gửi bản giao cho khách. Khách có 3 ngày để duyệt.';

  @override
  String get ordersDeliverSellerOnly =>
      'Chỉ người bán mới có thể giao đơn hàng';

  @override
  String get ordersDeliverUnavailable => 'Không thể giao đơn hàng lúc này';

  @override
  String ordersDeliverCurrentStatus(String status) {
    return 'Trạng thái hiện tại: $status.';
  }

  @override
  String get ordersDeliverBackToOrder => 'Quay lại đơn hàng';

  @override
  String ordersDeliverMessageTo(String name) {
    return 'Lời nhắn gửi $name';
  }

  @override
  String get ordersDeliverInsertQuick => 'Chèn mẫu trả lời nhanh';

  @override
  String get ordersDeliverMessageHint =>
      'Mô tả những gì bạn giao, hướng dẫn sử dụng tệp và lời cảm ơn tới khách (ít nhất 10 ký tự).';

  @override
  String get ordersDeliverAttachments => 'Tệp đính kèm';

  @override
  String get ordersDeliverAttachMore => 'Đính kèm thêm tệp';

  @override
  String get ordersDeliverFileNote =>
      'Tối đa 5 GB mỗi tệp. Khách sẽ nhận được thông báo ngay khi bạn gửi bản giao.';

  @override
  String get ordersDeliverUploading => 'Đang tải tệp lên…';

  @override
  String get ordersDeliverSubmit => 'Gửi bản giao';

  @override
  String ordersResolutionError(String error) {
    return 'Có lỗi xảy ra: $error';
  }

  @override
  String ordersResolutionUpdateChat(String code, String text) {
    return '[Yêu cầu cập nhật đơn $code] $text';
  }

  @override
  String ordersResolutionUpdateSent(String name) {
    return 'Đã gửi yêu cầu cập nhật tới $name';
  }

  @override
  String get ordersResolutionTitle => 'Trung tâm giải quyết';

  @override
  String get ordersResolutionUpdateTitle => 'Yêu cầu cập nhật';

  @override
  String get ordersResolutionExtendTitle => 'Gia hạn thời gian giao';

  @override
  String get ordersResolutionCancelTitle => 'Huỷ đơn hàng';

  @override
  String get ordersResolutionSupportPrompt => 'Không tìm thấy điều bạn cần? ';

  @override
  String get ordersResolutionSupportLink => 'Liên hệ Bộ phận hỗ trợ';

  @override
  String get ordersResolutionOrderInfo => 'Thông tin đơn hàng';

  @override
  String get ordersResolutionDisputeTitle => 'Đang giải quyết tranh chấp';

  @override
  String get ordersResolutionDisputeBody =>
      'Đơn hàng này đang có một yêu cầu chờ phản hồi. Vui lòng đợi bên kia phản hồi trước khi mở yêu cầu mới. Nếu gặp vấn đề, Bộ phận hỗ trợ của VietGig luôn sẵn sàng giúp bạn.';

  @override
  String get ordersResolutionPendingCancel => 'Yêu cầu huỷ đơn';

  @override
  String ordersResolutionPendingExtend(int days) {
    return 'Yêu cầu gia hạn $days ngày';
  }

  @override
  String ordersResolutionPendingLine(String request, String time) {
    return '$request · gửi lúc $time';
  }

  @override
  String get ordersResolutionCompleted => 'Đơn hàng đã hoàn thành';

  @override
  String get ordersResolutionCancelled => 'Đơn hàng đã bị huỷ';

  @override
  String get ordersResolutionEndedBody =>
      'Đơn hàng đã kết thúc nên không thể mở yêu cầu mới. Nếu cần hỗ trợ, hãy liên hệ với chúng tôi.';

  @override
  String get ordersResolutionWelcome => 'Chào mừng!';

  @override
  String get ordersResolutionWelcomeBody =>
      'Bạn có thể giải quyết vấn đề với đơn hàng tại đây.';

  @override
  String get ordersResolutionHowHelp => 'Chúng tôi giúp gì được cho bạn?';

  @override
  String get ordersResolutionMenuUpdate => 'Yêu cầu cập nhật tiến độ';

  @override
  String get ordersResolutionMenuMessageBuyer => 'Nhắn tin cho khách';

  @override
  String get ordersResolutionUpdateHeading => 'Gửi lời nhắn tới người bán';

  @override
  String ordersResolutionUpdateBody(String name) {
    return 'Hỏi $name về tiến độ đơn hàng. Tin nhắn sẽ được gửi vào hộp thư của bạn.';
  }

  @override
  String get ordersResolutionUpdateHint =>
      'VD: Chào bạn, mình muốn hỏi đơn hàng đang tiến triển thế nào rồi?';

  @override
  String get ordersResolutionSendRequest => 'Gửi yêu cầu';

  @override
  String get ordersResolutionExtendHeading => 'Bạn cần thêm bao nhiêu ngày?';

  @override
  String get ordersResolutionExtendDays => 'Số ngày gia hạn';

  @override
  String get ordersResolutionCurrentDue => 'Ngày giao hiện tại';

  @override
  String get ordersResolutionNewDue => 'Dự kiến giao ngày';

  @override
  String get ordersResolutionMessage => 'Lời nhắn';

  @override
  String get ordersResolutionExtendHintSeller =>
      'VD: Mình cần thêm thời gian để hoàn thiện chi tiết cho bạn. Mong bạn thông cảm!';

  @override
  String get ordersResolutionExtendHintBuyer =>
      'VD: Mình cần thêm thời gian để chuẩn bị tài liệu cho bạn.';

  @override
  String get ordersResolutionExtendNoteSeller =>
      'Khách có 2 ngày để phản hồi. Nếu không phản hồi, yêu cầu sẽ tự động được chấp nhận.';

  @override
  String get ordersResolutionExtendNoteBuyer =>
      'Người bán có 2 ngày để phản hồi. Nếu không phản hồi, yêu cầu sẽ tự động được chấp nhận.';

  @override
  String get ordersResolutionExtendSubmit => 'Gửi yêu cầu gia hạn';

  @override
  String ordersResolutionExtendSent(int days) {
    return 'Đã gửi yêu cầu gia hạn $days ngày';
  }

  @override
  String ordersResolutionRefundNote(String amount) {
    return 'Nếu người bán đồng ý, $amount sẽ được hoàn vào số dư VietGig của bạn.';
  }

  @override
  String get ordersResolutionFeedbackHeading => 'Phản hồi cho người bán';

  @override
  String get ordersResolutionCancelHint =>
      'Cho người bán biết lý do bạn muốn huỷ đơn (không bắt buộc)';

  @override
  String get ordersResolutionReasonHeading => 'Lý do huỷ';

  @override
  String get ordersResolutionReasonNote => 'Chỉ VietGig thấy lý do này.';

  @override
  String get ordersResolutionReasonNoResponse => 'Người bán không phản hồi';

  @override
  String get ordersResolutionReasonQuality => 'Chất lượng kém';

  @override
  String get ordersResolutionReasonWrongItem =>
      'Không nhận được đúng thứ đã đặt';

  @override
  String get ordersResolutionReasonTooMuchGuidance =>
      'Người bán cần quá nhiều hướng dẫn';

  @override
  String get ordersResolutionReasonLanguage => 'Rào cản ngôn ngữ';

  @override
  String get ordersResolutionReasonOther => 'Khác';

  @override
  String get ordersResolutionRateSeller => 'Đánh giá trải nghiệm với người bán';

  @override
  String get ordersResolutionCancelSubmit => 'Gửi yêu cầu huỷ';

  @override
  String ordersResolutionSellerRatingNote(int rating) {
    return '(Đánh giá người bán: $rating/5)';
  }

  @override
  String get ordersResolutionCancelSent =>
      'Đã gửi yêu cầu huỷ. Người bán có tối đa 2 ngày để phản hồi.';

  @override
  String get ordersRateThanksReview => 'Cảm ơn bạn đã đánh giá!';

  @override
  String ordersRateSubmitError(String error) {
    return 'Không gửi được đánh giá: $error';
  }

  @override
  String get ordersRateCustomTitle => 'Số tiền tuỳ chỉnh (VND)';

  @override
  String get ordersRateCustomHint => 'VD: 70000';

  @override
  String get ordersRateCustomHelper => 'Tối thiểu 25.000 ₫';

  @override
  String get ordersRateCustomError => 'Số tiền tối thiểu là 25.000 ₫';

  @override
  String ordersRateTipError(String error) {
    return 'Không gửi được tip: $error';
  }

  @override
  String ordersRateTipSent(String amount, String name) {
    return 'Đã gửi tip $amount cho $name. Cảm ơn bạn!';
  }

  @override
  String get ordersRateLater => 'Để sau';

  @override
  String get ordersRateSkip => 'Bỏ qua';

  @override
  String get ordersRateBuyerOnly =>
      'Chỉ người mua mới có thể đánh giá đơn hàng này';

  @override
  String get ordersRateNotYet => 'Chưa thể đánh giá';

  @override
  String get ordersRateNotYetBody =>
      'Bạn có thể đánh giá sau khi duyệt bản giao và đơn hàng hoàn thành.';

  @override
  String get ordersRateContinue => 'Tiếp tục';

  @override
  String get ordersRateStar1 => 'Kém';

  @override
  String get ordersRateStar2 => 'Tạm';

  @override
  String get ordersRateStar3 => 'Tốt';

  @override
  String get ordersRateStar4 => 'Rất tốt';

  @override
  String get ordersRateStar5 => 'Xuất sắc';

  @override
  String get ordersRatePositiveDetail => 'Chú ý chi tiết';

  @override
  String get ordersRatePositiveCreative => 'Sáng tạo';

  @override
  String get ordersRatePositiveAesthetic => 'Thẩm mỹ';

  @override
  String get ordersRatePositiveProfessional => 'Chuyên nghiệp';

  @override
  String get ordersRatePositiveExceeded => 'Vượt kỳ vọng';

  @override
  String get ordersRatePositiveOnBrand => 'Đúng thương hiệu';

  @override
  String get ordersRateNegativeLate => 'Chậm tiến độ';

  @override
  String get ordersRateNegativeDetail => 'Thiếu chi tiết';

  @override
  String get ordersRateNegativeOffBrief => 'Không đúng yêu cầu';

  @override
  String get ordersRateNegativeCommunication => 'Giao tiếp chưa tốt';

  @override
  String get ordersRateNegativeQuality => 'Chất lượng chưa đạt';

  @override
  String get ordersRateNegativeRevisions => 'Cần nhiều chỉnh sửa';

  @override
  String get ordersRateQualityTitle =>
      'Bạn đánh giá chất lượng bản giao thế nào?';

  @override
  String get ordersRateGoodTitle => 'Thật tuyệt! Điều gì khiến nó xuất sắc?';

  @override
  String get ordersRateBadTitle => 'Rất tiếc! Điều gì chưa ổn?';

  @override
  String get ordersRateValueTitle => 'Bạn đánh giá giá trị của bản giao?';

  @override
  String ordersRateValueBody(int days, String amount) {
    return 'Dự án mất $days ngày với chi phí $amount.';
  }

  @override
  String get ordersRateTopicsDefault =>
      'chất lượng, giao tiếp và thời gian phản hồi';

  @override
  String get ordersRateWriteTitle => 'Viết đánh giá công khai';

  @override
  String ordersRateWriteBody(String topics) {
    return 'Chia sẻ chi tiết về trải nghiệm làm việc với người bán và kết quả cuối cùng, cùng các chủ đề như: $topics.';
  }

  @override
  String get ordersRateTextHint =>
      'Viết ít nhất 10 ký tự. Hãy cho người mua khác biết cảm nhận trung thực của bạn.';

  @override
  String get ordersRateShareTitle => 'Chia sẻ mẫu công việc công khai';

  @override
  String get ordersRateShareBody =>
      'Mẫu công việc có thể hiển thị cùng đánh giá trên trang người bán. Tôi xác nhận mẫu không chứa thông tin cá nhân hay nhạy cảm.';

  @override
  String get ordersRateSubmit => 'Gửi đánh giá';

  @override
  String get ordersRatePublicNote =>
      'Giá đơn hàng và thông tin hồ sơ của bạn sẽ hiển thị công khai cùng đánh giá.';

  @override
  String get ordersRateThanks => 'Cảm ơn bạn!';

  @override
  String ordersRateTipped(String amount, String name) {
    return 'Bạn đã gửi tip $amount cho $name.';
  }

  @override
  String ordersRateTipPrompt(String name) {
    return 'Bạn có thể gửi tip để cảm ơn $name. Tip được chuyển 100% cho người bán.';
  }

  @override
  String get ordersRateCustom => 'Tuỳ chỉnh';

  @override
  String get ordersRateSendTip => 'Gửi tip';

  @override
  String ordersRateSendTipAmount(String amount) {
    return 'Gửi tip $amount';
  }

  @override
  String get ordersRateNoFee =>
      'Bạn sẽ không bị tính phí dịch vụ cho tiền tip.';

  @override
  String get profileAccount => 'Tài khoản';

  @override
  String get profileLanguage => 'Ngôn ngữ';

  @override
  String get profileAppearance => 'Giao diện';

  @override
  String get profileCurrency => 'Tiền tệ';

  @override
  String get profileNotifications => 'Thông báo';

  @override
  String get profileSecurity => 'Bảo mật';

  @override
  String get profilePreferences => 'Tuỳ chọn';

  @override
  String get profileSupportCenter => 'Trung tâm hỗ trợ';

  @override
  String get profileSendFeedback => 'Gửi góp ý';

  @override
  String get profileThemeLight => 'Sáng';

  @override
  String get profileThemeDark => 'Tối';

  @override
  String get profileThemeSystem => 'Theo hệ thống';

  @override
  String get profileThemeSystemShort => 'Hệ thống';

  @override
  String get profileFeedbackIdea => 'Chia sẻ ý tưởng';

  @override
  String get profileFeedbackIdeaHint => 'Gợi ý tính năng mới hoặc cải tiến';

  @override
  String get profileFeedbackBug => 'Báo lỗi';

  @override
  String get profileFeedbackBugHint => 'Có gì đó không hoạt động như mong đợi';

  @override
  String get profileSwitchedToSeller => 'Đã chuyển sang chế độ người bán';

  @override
  String get profileSwitchedToBuyer => 'Đã chuyển sang chế độ người mua';

  @override
  String get profileSwitchModeFailed =>
      'Không thể chuyển chế độ, vui lòng thử lại.';

  @override
  String get profileBecomeSellerTitle => 'Trở thành người bán?';

  @override
  String get profileBecomeSellerMessage =>
      'Bạn có thể đăng dịch vụ, nhận đơn và kiếm thu nhập trên VietGig. Bạn luôn có thể chuyển lại chế độ người mua.';

  @override
  String get profileBecomeSellerConfirm => 'Bắt đầu bán';

  @override
  String get profileSellerMode => 'Chế độ người bán';

  @override
  String get profileSellerModeOn => 'Quản lý dịch vụ và đơn bán';

  @override
  String get profileSellerModeOff => 'Bật để bắt đầu bán dịch vụ';

  @override
  String get profileMyVietGig => 'VietGig của tôi';

  @override
  String get profileEarnings => 'Thu nhập';

  @override
  String get profileOfferTemplates => 'Mẫu báo giá';

  @override
  String get profileBuyerBriefs => 'Brief từ người mua';

  @override
  String get profileShareGigs => 'Chia sẻ dịch vụ';

  @override
  String get profileMyProfile => 'Hồ sơ của tôi';

  @override
  String get profileAvailability => 'Lịch làm việc';

  @override
  String get profileSavedLists => 'Danh sách đã lưu';

  @override
  String get profileMyInterests => 'Sở thích của tôi';

  @override
  String get profileBrowsingHistory => 'Lịch sử xem';

  @override
  String get profileInviteFriends => 'Mời bạn bè';

  @override
  String get profileSettings => 'Cài đặt';

  @override
  String get profileSupport => 'Hỗ trợ';

  @override
  String get profileBecomeSeller => 'Trở thành người bán';

  @override
  String get profileNeedActivation => 'Bạn cần kích hoạt tài khoản';

  @override
  String get profileActivateAccount => 'Kích hoạt tài khoản';

  @override
  String get profileGuest => 'Khách';

  @override
  String get profileGuestWelcome => 'Chào mừng đến VietGig!';

  @override
  String get profileJoin => 'Tham gia VietGig';

  @override
  String get profileGeneral => 'Chung';

  @override
  String profileVersion(String version) {
    return 'Phiên bản $version';
  }

  @override
  String get profileSignOutTitle => 'Đăng xuất?';

  @override
  String get profileSignOutMessage =>
      'Bạn sẽ cần đăng nhập lại để tiếp tục mua và bán dịch vụ.';

  @override
  String get profileSignOut => 'Đăng xuất';

  @override
  String get profileSignOutFailed => 'Đăng xuất thất bại, vui lòng thử lại.';

  @override
  String get profileAccountInfo => 'Thông tin tài khoản';

  @override
  String get profileUsername => 'Tên người dùng';

  @override
  String get profileFullName => 'Họ và tên';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileVerified => 'Đã xác minh';

  @override
  String get profileUnverified => 'Chưa xác minh';

  @override
  String get profileEditProfile => 'Sửa hồ sơ';

  @override
  String get profilePersonalBalance => 'Số dư cá nhân';

  @override
  String get profileManageAccount => 'Quản lý tài khoản';

  @override
  String get profileDeactivateAndDelete => 'Huỷ kích hoạt & xoá tài khoản';

  @override
  String get profilePrivacy => 'Quyền riêng tư';

  @override
  String get profilePrivacySearchVisible =>
      'Hiển thị hồ sơ trên công cụ tìm kiếm';

  @override
  String get profilePrivacyPersonalized => 'Cho phép cá nhân hoá gợi ý dịch vụ';

  @override
  String get profilePrivacyShareUsage => 'Chia sẻ dữ liệu sử dụng ẩn danh';

  @override
  String get profilePrivacySaved => 'Đã lưu cài đặt quyền riêng tư';

  @override
  String get profileOnlineStatus => 'Trạng thái online';

  @override
  String get profileOnlineStatusHint =>
      'Bạn sẽ hiển thị online khi đang mở ứng dụng.';

  @override
  String get profileOnlineShown => 'Bạn đang hiển thị online';

  @override
  String get profileOnlineHidden => 'Đã ẩn trạng thái online';

  @override
  String get profileResetLinkSent =>
      'Đã gửi liên kết đổi mật khẩu tới email của bạn';

  @override
  String get profileChangePassword => 'Đổi mật khẩu';

  @override
  String get profileChangePasswordHint =>
      'Nhận liên kết đặt lại mật khẩu qua email';

  @override
  String get profileTwoFactor => 'Xác thực 2 lớp';

  @override
  String get profileTwoFactorHint =>
      'Yêu cầu mã xác minh khi đăng nhập trên thiết bị mới';

  @override
  String get profileTwoFactorOn => 'Đã bật xác thực 2 lớp';

  @override
  String get profileTwoFactorOff => 'Đã tắt xác thực 2 lớp';

  @override
  String profileLanguageChanged(String language) {
    return 'Đã chuyển ngôn ngữ sang $language';
  }

  @override
  String get profilePushTab => 'Thông báo đẩy';

  @override
  String get profileEmailTab => 'Email';

  @override
  String get profileSendTestPush => 'Gửi thông báo thử';

  @override
  String get profileTestPushSent => 'Đã gửi thông báo thử tới thiết bị của bạn';

  @override
  String get profileSendTestEmail => 'Gửi email thử';

  @override
  String get profileTestEmailSent => 'Đã gửi email thử tới hộp thư của bạn';

  @override
  String get profileCurrencyVnd => 'Đồng Việt Nam';

  @override
  String get profileCurrencyUsd => 'Đô la Mỹ';

  @override
  String get profileCurrencyEur => 'Euro';

  @override
  String get profileCurrencyGbp => 'Bảng Anh';

  @override
  String get profileCurrencyJpy => 'Yên Nhật';

  @override
  String get profileCurrencyKrw => 'Won Hàn Quốc';

  @override
  String get profileCurrencyCny => 'Nhân dân tệ';

  @override
  String get profileCurrencySgd => 'Đô la Singapore';

  @override
  String get profileCurrencyThb => 'Baht Thái';

  @override
  String get profileCurrencyAud => 'Đô la Úc';

  @override
  String get profileCurrencyCad => 'Đô la Canada';

  @override
  String profileCurrencyChanged(String currency) {
    return 'Đã đổi tiền tệ hiển thị sang $currency';
  }

  @override
  String get profileAppearanceSystemNote =>
      'Nếu chọn \"Hệ thống\", VietGig sẽ tự động điều chỉnh giao diện theo cài đặt của thiết bị.';

  @override
  String get profileBalanceHelpEarningsTitle => 'Thu nhập';

  @override
  String get profileBalanceHelpEarnings =>
      'Tiền bạn kiếm được từ dịch vụ của mình. Có thể rút về ngân hàng hoặc dùng để mua dịch vụ.';

  @override
  String get profileBalanceHelpRefundTitle => 'Số dư từ đơn đã huỷ';

  @override
  String get profileBalanceHelpRefund =>
      'Khoản tiền được hoàn từ các đơn hàng đã huỷ, có thể dùng cho lần mua tiếp theo.';

  @override
  String get profileBalanceHelpCreditsTitle => 'Credits';

  @override
  String get profileBalanceHelpCredits =>
      'Credits được dùng khi thanh toán đơn hàng. Hãy kiểm tra hạn sử dụng để không bị mất.';

  @override
  String get profileBalanceHelpPayTitle => 'Thanh toán bằng số dư';

  @override
  String get profileBalanceHelpPay =>
      'Khi có số dư, bạn có thể dùng tiền và credits làm phương thức thanh toán chính cho đơn mới.';

  @override
  String get profileBalanceExplain => 'Giải thích';

  @override
  String get profileBalanceVietGig => 'Số dư VietGig';

  @override
  String get profileBalanceFromCancelled => 'Từ đơn đã huỷ';

  @override
  String get profileBalanceCreditsVietGig => 'Credits VietGig';

  @override
  String get profileBalanceCredits => 'Credits';

  @override
  String get profileBalanceMoreCredits =>
      'Muốn có thêm credits? Giới thiệu bạn bè và nhận ưu đãi hấp dẫn!';

  @override
  String get profileBalanceGetCredits => 'Nhận credits VietGig';

  @override
  String get profileReasonEmails =>
      'Tôi muốn huỷ đăng ký nhận email từ VietGig';

  @override
  String get profileReasonUsername => 'Tôi muốn đổi tên người dùng';

  @override
  String get profileReasonOtherAccount => 'Tôi có một tài khoản VietGig khác';

  @override
  String get profileReasonNotFound => 'Tôi không tìm được thứ mình cần';

  @override
  String get profileReasonComplex => 'VietGig phức tạp hoặc khó sử dụng';

  @override
  String get profileReasonBadSeller => 'Trải nghiệm không tốt với người bán';

  @override
  String get profileReasonPolicy =>
      'Tôi không hài lòng với chính sách của VietGig';

  @override
  String get profileReasonOther => 'Khác';

  @override
  String get profileDeactivateConfirmTitle => 'Huỷ kích hoạt tài khoản?';

  @override
  String get profileDeactivateConfirmMessage =>
      'Hồ sơ của bạn sẽ bị ẩn và các đơn đang thực hiện sẽ bị huỷ. Bạn có thể kích hoạt lại bằng cách đăng nhập.';

  @override
  String get profileDeactivateConfirm => 'Huỷ kích hoạt';

  @override
  String get profileDeleteConfirmTitle => 'Xoá vĩnh viễn tài khoản?';

  @override
  String get profileDeleteConfirmMessage => 'Thao tác này không thể hoàn tác.';

  @override
  String get profileDeleteAccount => 'Xoá tài khoản';

  @override
  String get profileActionNotAllowed => 'Bạn không thể thực hiện thao tác này';

  @override
  String get profileGenericError => 'Đã có lỗi xảy ra, vui lòng thử lại.';

  @override
  String get profileDeactivateAccount => 'Huỷ kích hoạt tài khoản';

  @override
  String get profileContinue => 'Tiếp tục';

  @override
  String get profileContinueDelete => 'Tiếp tục xoá tài khoản';

  @override
  String get profileDeactivateTitle => 'Huỷ kích hoạt & xoá';

  @override
  String get profileDeactivateHeading =>
      'Huỷ kích hoạt hoặc xoá tài khoản VietGig';

  @override
  String get profileDeactivateIntro =>
      'Nếu bạn muốn tạm ngưng sử dụng, hãy huỷ kích hoạt tài khoản. Nếu muốn xoá vĩnh viễn toàn bộ dữ liệu khỏi VietGig, hãy chọn xoá tài khoản.';

  @override
  String get profileDeactivateDescription =>
      'Hồ sơ của bạn sẽ không hiển thị trên VietGig. Các đơn đang thực hiện sẽ bị huỷ.';

  @override
  String get profileDeleteDescription =>
      'Xoá tài khoản là vĩnh viễn và không thể khôi phục. Bạn sẽ không thể lấy lại tệp hoặc thông tin từ các đơn hàng trên VietGig.';

  @override
  String get profileDeleteWhatHappens =>
      'Điều gì xảy ra khi bạn xoá tài khoản?';

  @override
  String get profileDeletePermanentNote =>
      'Quá trình xoá là vĩnh viễn và không thể hoàn tác. Có thể mất tới 30 ngày để hoàn tất.';

  @override
  String get profileDeleteBulletUsername =>
      'Tên người dùng gắn với tài khoản này sẽ không thể dùng lại cho tài khoản mới.';

  @override
  String get profileDeleteBulletData =>
      'Toàn bộ tin nhắn, đơn hàng, đánh giá và danh sách đã lưu sẽ bị xoá.';

  @override
  String get profileDeleteBulletBalance =>
      'Số dư và credits chưa sử dụng sẽ bị huỷ.';

  @override
  String get profileDeleteBulletReview =>
      'Bạn nên xem lại các đơn hàng và tải về tệp cần thiết trước khi xoá.';

  @override
  String get profileLeavingBecause => 'Tôi rời đi vì';

  @override
  String get profileTellUsMore =>
      'Hãy cho chúng tôi biết thêm (không bắt buộc)';

  @override
  String get profileTellUsMoreHint => 'Giúp chúng tôi làm tốt hơn...';

  @override
  String get profileSpokenVietnamese => 'Tiếng Việt';

  @override
  String get profileSpokenEnglish => 'Tiếng Anh';

  @override
  String get profileSpokenChinese => 'Tiếng Trung';

  @override
  String get profileSpokenJapanese => 'Tiếng Nhật';

  @override
  String get profileSpokenKorean => 'Tiếng Hàn';

  @override
  String get profileSpokenFrench => 'Tiếng Pháp';

  @override
  String get profileSkillEmpty => 'Nhập tên kỹ năng';

  @override
  String get profileSkillDuplicate => 'Kỹ năng này đã có';

  @override
  String profileSkillMax(int max) {
    return 'Tối đa $max kỹ năng';
  }

  @override
  String get profileNameTooShort => 'Họ tên phải có ít nhất 2 ký tự';

  @override
  String get profileLanguageRequired => 'Vui lòng chọn ít nhất một ngôn ngữ';

  @override
  String get profileSaved => 'Đã lưu hồ sơ';

  @override
  String get profileSaveFailed => 'Không lưu được hồ sơ, vui lòng thử lại.';

  @override
  String get profileChangeAvatar => 'Đổi ảnh đại diện';

  @override
  String get profileAvatarUploadSoon =>
      'Tải ảnh đại diện sẽ có khi kết nối máy chủ';

  @override
  String get profileNameHint => 'VD: Nguyễn Minh Anh';

  @override
  String get profileHeadline => 'Giới thiệu ngắn';

  @override
  String get profileHeadlineHint => 'VD: Chủ cửa hàng thời trang online';

  @override
  String get profileBio => 'Mô tả về bạn';

  @override
  String get profileBioHint =>
      'Chia sẻ đôi chút về bạn, công việc và điều bạn đang tìm kiếm...';

  @override
  String get profileSkills => 'Kỹ năng';

  @override
  String get profileSkillHint => 'VD: Figma, Copywriting';

  @override
  String get profileAddSkill => 'Thêm';

  @override
  String get profileNoSkills => 'Chưa có kỹ năng nào.';

  @override
  String get profileSaveChanges => 'Lưu thay đổi';

  @override
  String get profileAreaNotifications => 'Thông báo';

  @override
  String get profileAreaInbox => 'Hộp thư';

  @override
  String get profileAreaSearch => 'Tìm dịch vụ';

  @override
  String get profileAreaPayments => 'Thanh toán';

  @override
  String get profileAreaOrders => 'Quản lý đơn';

  @override
  String get profileAreaOther => 'Khác';

  @override
  String get profileAttachFile => 'Đính kèm tệp';

  @override
  String get profileAttachScreenshot => 'Ảnh chụp màn hình';

  @override
  String get profileAttachDocument => 'Tài liệu';

  @override
  String get profileFeedbackThanksBug => 'Cảm ơn bạn đã báo lỗi';

  @override
  String get profileFeedbackThanksIdea => 'Cảm ơn bạn đã chia sẻ ý tưởng';

  @override
  String get profileFeedbackThanksBugMessage =>
      'Đội ngũ kỹ thuật sẽ kiểm tra và khắc phục sớm nhất có thể.';

  @override
  String get profileFeedbackThanksIdeaMessage =>
      'Góp ý của bạn giúp VietGig ngày càng tốt hơn cho cộng đồng.';

  @override
  String get profileFeedbackSendFailed => 'Gửi thất bại, vui lòng thử lại.';

  @override
  String get profileFeedbackAreaBug => 'Lỗi xảy ra ở khu vực nào?';

  @override
  String get profileFeedbackAreaIdea => 'Ý tưởng liên quan khu vực nào?';

  @override
  String get profileFeedbackAreaRequired => 'Vui lòng chọn một khu vực';

  @override
  String get profileFeedbackDescribeBug => 'Mô tả lỗi bạn gặp phải';

  @override
  String get profileFeedbackDescribeIdea =>
      'Kể cho chúng tôi về ý tưởng của bạn';

  @override
  String get profileFeedbackBugHintText =>
      'Bạn đã làm gì, điều gì xảy ra và bạn mong đợi điều gì?';

  @override
  String get profileFeedbackIdeaHintText =>
      'Ý tưởng của bạn là tính năng mới hay thay đổi tính năng hiện có? Nó sẽ giúp trải nghiệm tốt hơn thế nào?';

  @override
  String profileFeedbackMinChars(int n) {
    return 'Vui lòng nhập ít nhất $n ký tự';
  }

  @override
  String get profileRemoveFile => 'Gỡ tệp';

  @override
  String get profileFeedbackCanContact =>
      'Chúng tôi có thể liên hệ bạn nếu có câu hỏi không?';

  @override
  String get profileFeedbackContactYes => 'Có, sẵn lòng trao đổi';

  @override
  String get profileFeedbackContactNo => 'Không, lúc này thì không';

  @override
  String get profileFeedbackChoiceRequired => 'Vui lòng chọn một lựa chọn';

  @override
  String get profileFeedbackSubmit => 'Gửi';

  @override
  String get profileShareVia => 'Chia sẻ qua';

  @override
  String get profileShareSms => 'Tin nhắn SMS';

  @override
  String profileShareLinkCopied(String app) {
    return 'Đã sao chép liên kết – dán vào $app để gửi cho bạn bè';
  }

  @override
  String get profileInviteHeadline => 'Chia sẻ & nhận tới 2.500.000 ₫';

  @override
  String get profileInviteBody =>
      'Tặng bạn bè giảm 10% cho đơn đầu tiên, bạn nhận 10% giá trị đơn của họ dưới dạng credits.';

  @override
  String get profileReferralCode => 'Mã giới thiệu của bạn';

  @override
  String get profileCodeCopied => 'Đã sao chép mã giới thiệu';

  @override
  String get profileCopy => 'Sao chép';

  @override
  String get profileInviteLinkCopied => 'Đã sao chép liên kết mời';

  @override
  String get profileCopyLink => 'Sao chép link';

  @override
  String get profileShare => 'Chia sẻ';

  @override
  String get profileHowItWorks => 'Cách hoạt động';

  @override
  String get profileInviteStep1Title => 'Gửi lời mời';

  @override
  String get profileInviteStep1 =>
      'Chia sẻ mã hoặc liên kết giới thiệu cho bạn bè.';

  @override
  String get profileInviteStep2Title => 'Bạn bè đặt đơn đầu tiên';

  @override
  String get profileInviteStep2 =>
      'Họ được giảm 10% cho đơn hàng đầu tiên trên VietGig.';

  @override
  String get profileInviteStep3Title => 'Bạn nhận credits';

  @override
  String get profileInviteStep3 =>
      'Nhận 10% giá trị đơn, tối đa 2.500.000 ₫ trong 12 tháng.';

  @override
  String get profileGotIt => 'Đã hiểu';

  @override
  String get profilePushEnabled => 'Đã bật thông báo đẩy';

  @override
  String get profileMarkedAllRead => 'Đã đánh dấu tất cả là đã đọc';

  @override
  String get profileMarkAllRead => 'Đánh dấu đã đọc';

  @override
  String get profileNotifEmptyTitle => 'Luôn cập nhật';

  @override
  String get profileNotifEmptyMessage =>
      'Bật thông báo đẩy để không bỏ lỡ tin nhắn, cập nhật đơn hàng và ưu đãi.';

  @override
  String get profileEnablePush => 'Bật thông báo đẩy';

  @override
  String get profileNotifToday => 'HÔM NAY';

  @override
  String get profileNotifEarlier => 'TRƯỚC ĐÓ';

  @override
  String get profileNotifDeleted => 'Đã xoá thông báo';

  @override
  String get profileAccountNotice => 'Thông báo tài khoản';

  @override
  String get profileAccountNoticeUnverified =>
      'Chúng tôi đã gửi email xác nhận. Hãy kiểm tra hộp thư và kích hoạt tài khoản để dùng đầy đủ tính năng.';

  @override
  String get profileAccountNoticeComplete =>
      'Hoàn thiện hồ sơ giúp người bán hiểu rõ bạn hơn và phản hồi nhanh hơn.';

  @override
  String get profileActivateEmailLink => 'Kích hoạt email →';

  @override
  String get profileUpdateProfileLink => 'Cập nhật hồ sơ →';

  @override
  String get profileFaq => 'Câu hỏi thường gặp';

  @override
  String get profileFaqOrderQ => 'Làm sao để đặt một dịch vụ?';

  @override
  String get profileFaqOrderA =>
      'Tìm dịch vụ phù hợp, chọn gói, bấm \"Tiếp tục\" và thanh toán. Sau đó gửi yêu cầu để người bán bắt đầu làm việc.';

  @override
  String get profileFaqSafeQ => 'Thanh toán trên VietGig có an toàn không?';

  @override
  String get profileFaqSafeA =>
      'Tiền của bạn được VietGig giữ an toàn và chỉ chuyển cho người bán khi bạn chấp nhận bản giao.';

  @override
  String get profileFaqCancelQ => 'Tôi có thể huỷ đơn hàng không?';

  @override
  String get profileFaqCancelA =>
      'Bạn có thể gửi yêu cầu huỷ trong Trung tâm giải quyết của đơn hàng. Tiền hoàn sẽ vào Số dư VietGig.';

  @override
  String get profileFaqSellerQ => 'Làm sao để trở thành người bán?';

  @override
  String get profileFaqSellerA =>
      'Vào tab Tài khoản, bật \"Chế độ người bán\" rồi tạo dịch vụ đầu tiên của bạn.';

  @override
  String get profileFaqPayoutQ => 'Khi nào tôi nhận được tiền từ đơn bán?';

  @override
  String get profileFaqPayoutA =>
      'Thu nhập sẽ khả dụng để rút sau 7 ngày kể từ khi đơn hàng hoàn tất.';

  @override
  String get profileFaqPasswordQ => 'Tôi quên mật khẩu thì phải làm sao?';

  @override
  String get profileFaqPasswordA =>
      'Tại màn Đăng nhập, chọn \"Quên mật khẩu?\" và nhập email để nhận liên kết đặt lại.';

  @override
  String get profileContactUs => 'Liên hệ với chúng tôi';

  @override
  String get profileSupportEmail => 'Email hỗ trợ';

  @override
  String profileSupportEmailHint(String email) {
    return '$email · phản hồi trong 24 giờ';
  }

  @override
  String get profileSupportEmailCopied => 'Đã sao chép địa chỉ email hỗ trợ';

  @override
  String get profileHotline => 'Hotline';

  @override
  String profileHotlineHint(String phone) {
    return '$phone · 8:00 – 22:00 hằng ngày';
  }

  @override
  String get profileHotlineCopied => 'Đã sao chép số hotline';

  @override
  String get profileSupportRequest => 'Gửi yêu cầu hỗ trợ';

  @override
  String get profileSupportRequestHint =>
      'Mô tả vấn đề, chúng tôi sẽ liên hệ lại';

  @override
  String get profileSupportRequestSignIn => 'Đăng nhập để gửi yêu cầu';

  @override
  String get profileNewEmailRequired => 'Vui lòng nhập email mới';

  @override
  String get profileEmailInvalid => 'Email không hợp lệ';

  @override
  String get profileEmailMustDiffer => 'Email mới phải khác email hiện tại';

  @override
  String get profileEmailUpdated =>
      'Email đã được cập nhật và đã gửi thư xác nhận.';

  @override
  String get profileUpdateEmailTitle => 'Cập nhật địa chỉ email';

  @override
  String get profileUpdateEmailIntro =>
      'Chúng tôi sẽ gửi email xác nhận tới địa chỉ mới của bạn.';

  @override
  String get profileCurrentEmail => 'Email hiện tại';

  @override
  String get profileNewEmail => 'Email mới';

  @override
  String get profileEmailHint => 'vidu@email.com';

  @override
  String get profileUpdateEmailSubmit => 'Cập nhật & gửi';

  @override
  String get savedHistoryTitle => 'Lịch sử xem';

  @override
  String get savedHistoryClearTitle => 'Xoá toàn bộ lịch sử xem?';

  @override
  String get savedHistoryClearMessage =>
      'Các dịch vụ đã xem gần đây sẽ bị xoá khỏi tài khoản của bạn.';

  @override
  String get savedClearAll => 'Xoá tất cả';

  @override
  String get savedHistoryCleared => 'Đã xoá lịch sử xem';

  @override
  String get savedEdit => 'Sửa';

  @override
  String get savedHistoryEmptyTitle => 'Chưa có dịch vụ đã xem';

  @override
  String get savedHistoryEmptyMessage =>
      'Các dịch vụ bạn xem sẽ xuất hiện ở đây để dễ dàng quay lại.';

  @override
  String get savedExploreVietGig => 'Khám phá VietGig';

  @override
  String get savedHistoryRecent => 'Dịch vụ đã xem gần đây';

  @override
  String get savedHistoryRemoved => 'Đã xoá khỏi lịch sử xem';

  @override
  String get savedNameRequired => 'Vui lòng nhập tên danh sách';

  @override
  String get savedListsTitle => 'Danh sách của tôi';

  @override
  String get savedCreateList => '+ Tạo danh sách';

  @override
  String savedListExists(String name) {
    return 'Bạn đã có danh sách tên \"$name\"';
  }

  @override
  String savedListCreated(String name) {
    return 'Đã tạo danh sách \"$name\"';
  }

  @override
  String get savedListsEmptyTitle => 'Lưu các dịch vụ bạn thích';

  @override
  String get savedListsEmptyMessage =>
      'Sắp xếp dịch vụ và người bán yêu thích vào các danh sách riêng.';

  @override
  String get savedPublicTitle => 'Danh sách công khai';

  @override
  String get savedPublicSubtitle => 'Ai có liên kết đều xem được';

  @override
  String get savedShare => 'Chia sẻ';

  @override
  String get savedRename => 'Đổi tên';

  @override
  String get savedDeleteList => 'Xoá danh sách';

  @override
  String get savedMakePublicTitle => 'Công khai danh sách?';

  @override
  String get savedMakePublicMessage =>
      'Danh sách đang ở chế độ riêng tư. Bật công khai để người nhận liên kết có thể xem.';

  @override
  String get savedMakePublicConfirm => 'Công khai & chia sẻ';

  @override
  String get savedRenameTitle => 'Đổi tên danh sách';

  @override
  String savedRenamed(String name) {
    return 'Đã đổi tên thành \"$name\"';
  }

  @override
  String get savedDeleteTitle => 'Xoá danh sách này?';

  @override
  String savedDeleteMessage(String name) {
    return 'Các dịch vụ và người bán trong \"$name\" sẽ bị bỏ khỏi danh sách. Không thể hoàn tác.';
  }

  @override
  String savedListDeleted(String name) {
    return 'Đã xoá danh sách \"$name\"';
  }

  @override
  String savedRemovedFrom(String name) {
    return 'Đã bỏ khỏi \"$name\"';
  }

  @override
  String get savedNotFoundTitle => 'Danh sách không tồn tại';

  @override
  String get savedNotFoundMessage => 'Danh sách này có thể đã bị xoá.';

  @override
  String get savedBackToLists => 'Về danh sách của tôi';

  @override
  String savedTabGigs(int n) {
    return 'Dịch vụ ($n)';
  }

  @override
  String savedTabSellers(int n) {
    return 'Người bán ($n)';
  }

  @override
  String get savedOptions => 'Tuỳ chọn';

  @override
  String savedCreatedBy(String name) {
    return 'Tạo bởi $name';
  }

  @override
  String get savedCreatedByYou => 'bạn';

  @override
  String get savedNoGigsTitle => 'Chưa có dịch vụ nào';

  @override
  String get savedNoGigsMessage =>
      'Bấm biểu tượng trái tim trên dịch vụ để lưu vào danh sách này.';

  @override
  String get savedExploreGigs => 'Khám phá dịch vụ';

  @override
  String get savedUnsave => 'Bỏ lưu';

  @override
  String get savedNoSellersTitle => 'Chưa có người bán nào';

  @override
  String get savedNoSellersMessage =>
      'Bấm \"Lưu\" trên hồ sơ người bán để thêm vào danh sách này.';

  @override
  String get searchCategoryNotFound => 'Không tìm thấy danh mục';

  @override
  String searchCategoryIntro(String subtitle) {
    return 'Thuê freelancer chuyên nghiệp cho $subtitle và nhiều hơn nữa.';
  }

  @override
  String searchServiceCount(String count) {
    return '$count dịch vụ';
  }

  @override
  String get searchFeatured => 'Dịch vụ nổi bật';

  @override
  String get searchNoGigsTitle => 'Chưa có dịch vụ';

  @override
  String get searchNoGigsMessage =>
      'Danh mục này chưa có dịch vụ nào. Hãy quay lại sau nhé!';

  @override
  String get searchTabCategories => 'Danh mục';

  @override
  String get searchTabInterests => 'Sở thích';

  @override
  String get searchInterestsGuestTitle => 'Khám phá theo sở thích';

  @override
  String get searchInterestsGuestMessage =>
      'Đăng nhập để chọn sở thích và nhận gợi ý dịch vụ phù hợp với bạn.';

  @override
  String get searchInterestsLoadError => 'Không tải được sở thích';

  @override
  String get searchYourInterests => 'Sở thích của bạn';

  @override
  String get searchEdit => 'Sửa';

  @override
  String get searchInterestsHint =>
      'Chọn sở thích để khám phá dịch vụ phù hợp hơn.';

  @override
  String get searchChooseInterests => 'Chọn sở thích';

  @override
  String get searchYouMayLike => 'Bạn cũng có thể thích';

  @override
  String get searchAddInterest => 'Thêm vào sở thích';

  @override
  String searchInterestAdded(String name) {
    return 'Đã thêm \"$name\" vào sở thích';
  }

  @override
  String get searchInterestsSaved => 'Đã lưu sở thích của bạn';

  @override
  String searchSaveFailed(String error) {
    return 'Không lưu được: $error';
  }

  @override
  String get searchDeselectAll => 'Bỏ chọn';

  @override
  String get searchInterestsIntro =>
      'Chọn những lĩnh vực bạn quan tâm, chúng tôi sẽ gợi ý dịch vụ phù hợp hơn.';

  @override
  String searchInterestsSelected(int n) {
    return '$n sở thích đã chọn';
  }

  @override
  String get searchSellersHint => 'Tìm người bán';

  @override
  String get searchTabGigs => 'Dịch vụ';

  @override
  String get searchTabSellers => 'Người bán';

  @override
  String get searchSuggestions => 'Gợi ý';

  @override
  String searchForQuery(String query) {
    return 'Tìm \"$query\"';
  }

  @override
  String get searchFillField => 'Điền vào ô tìm kiếm';

  @override
  String get searchHistory => 'Lịch sử tìm kiếm';

  @override
  String get searchClearHistory => 'Xoá lịch sử';

  @override
  String get searchKeywordHint =>
      'Nhập từ khoá như \"logo\", \"website\", \"dựng video\"…';

  @override
  String get searchRecentlyViewed => 'Dịch vụ đã xem gần đây';

  @override
  String get searchManage => 'Quản lý';

  @override
  String get searchSellersLoadError => 'Không tải được danh sách người bán';

  @override
  String get searchSellerNotFound => 'Không tìm thấy người bán';

  @override
  String searchSellerNoMatch(String query) {
    return 'Không có người bán nào khớp với \"$query\".';
  }

  @override
  String get searchDeliveryTime => 'Thời gian giao';

  @override
  String get searchNoStyles => 'Chưa có phong cách nào cho kết quả này';

  @override
  String get searchStyle => 'Phong cách';

  @override
  String get searchAllStyles => 'Tất cả phong cách';

  @override
  String get searchAllServices => 'Tất cả dịch vụ';

  @override
  String get searchNoResults => 'Không tìm thấy kết quả';

  @override
  String get searchNoResultsFiltered =>
      'Hãy thử điều chỉnh hoặc xoá bộ lọc để xem thêm dịch vụ.';

  @override
  String get searchNoResultsHint =>
      'Hãy thử từ khoá khác hoặc khám phá theo danh mục.';

  @override
  String get searchClearFilters => 'Xoá bộ lọc';

  @override
  String get searchBrowseCategories => 'Khám phá danh mục';

  @override
  String get searchRelated => 'Kết quả liên quan';

  @override
  String get searchChipAll => 'Tất cả';

  @override
  String searchChipAllCount(int n) {
    return 'Tất cả ($n)';
  }

  @override
  String get searchChipCategory => 'Danh mục';

  @override
  String get searchChipIncludes => 'Dịch vụ bao gồm';

  @override
  String get searchChipDelivery => 'Giao hàng';

  @override
  String get searchSellerLevel => 'Mức người bán';

  @override
  String get searchChipBudget => 'Ngân sách';

  @override
  String get searchShopBy => 'Mua theo';

  @override
  String get searchSearching => 'Đang tìm…';

  @override
  String searchResultCount(String count) {
    return '$count kết quả';
  }

  @override
  String get searchAny => 'Bất kỳ';

  @override
  String get searchDelivery24h => 'Trong 24 giờ';

  @override
  String searchDeliveryUpTo(int n) {
    return 'Tối đa $n ngày';
  }

  @override
  String get searchFilterTitle => 'Bộ lọc';

  @override
  String get searchClearAll => 'Xoá tất cả';

  @override
  String get searchAllCategories => 'Tất cả danh mục';

  @override
  String get searchPriceRange => 'Khoảng giá (₫)';

  @override
  String get searchPriceMin => 'Tối thiểu';

  @override
  String get searchPriceMax => 'Tối đa';

  @override
  String get searchPriceError => 'Giá tối thiểu phải nhỏ hơn giá tối đa';

  @override
  String get searchProOnly => 'Chỉ dịch vụ Pro';

  @override
  String get searchProOnlyDesc =>
      'Do người bán đã được VietGig thẩm định chất lượng cung cấp.';

  @override
  String get searchShowResults => 'Hiện kết quả';

  @override
  String searchShowResultsCount(int n) {
    return 'Hiện kết quả ($n)';
  }

  @override
  String get sellerEarnings => 'Thu nhập';

  @override
  String get sellerAvailable => 'Có thể rút';

  @override
  String get sellerActiveOrders => 'Đơn đang chạy';

  @override
  String get sellerPaymentsClearing => 'Thanh toán đang xử lý';

  @override
  String get sellerSuccessScore => 'Điểm thành công';

  @override
  String get sellerRating => 'Đánh giá';

  @override
  String get sellerResponseRate => 'Tỉ lệ phản hồi';

  @override
  String get sellerOrders => 'Đơn hàng';

  @override
  String get sellerClients => 'Khách hàng';

  @override
  String get sellerGotIt => 'Đã hiểu';

  @override
  String get sellerOptions => 'Tuỳ chọn';

  @override
  String get sellerChartDateFormat => 'dd/MM';

  @override
  String get sellerMonthFormat => 'M';

  @override
  String get sellerDashLoadError => 'Không tải được bảng điều khiển';

  @override
  String sellerDashGreeting(String name) {
    return 'Chào $name,';
  }

  @override
  String get sellerDashGreetingFallback => 'bạn';

  @override
  String get sellerDashWelcomeBack => 'Chào mừng trở lại';

  @override
  String get sellerDashSetupTitle => 'Hoàn thiện hồ sơ người bán';

  @override
  String get sellerDashSetupBody =>
      'Tạo dịch vụ đầu tiên và hoàn thiện hồ sơ để bắt đầu nhận đơn từ khách hàng.';

  @override
  String get sellerDashSetupLink => 'Xem dịch vụ của tôi →';

  @override
  String get sellerDashTodoTitle => 'Việc cần làm';

  @override
  String sellerDashUnreadMessages(int n) {
    return '$n tin nhắn chưa đọc';
  }

  @override
  String get sellerDashUnreadNone =>
      'Thời gian phản hồi của bạn đang tốt. Hãy tiếp tục phát huy!';

  @override
  String get sellerDashUnreadSome => 'Trả lời sớm để giữ tỉ lệ phản hồi cao.';

  @override
  String sellerDashOrdersToDeliver(int n) {
    return '$n đơn hàng cần giao';
  }

  @override
  String get sellerDashOrdersNone => 'Bạn không có đơn nào sắp đến hạn giao.';

  @override
  String get sellerDashOrdersSome =>
      'Giao đúng hạn để giữ điểm thành công cao.';

  @override
  String get sellerDashMyGigs => 'Dịch vụ của tôi';

  @override
  String get sellerDashManage => 'Quản lý';

  @override
  String get sellerDashStats => 'Thống kê';

  @override
  String get sellerDashLast7Days => '7 ngày qua';

  @override
  String get sellerDashImpressions => 'Lượt hiển thị';

  @override
  String get sellerDashClicks => 'Lượt nhấp';

  @override
  String get sellerDashConversion => 'Chuyển đổi';

  @override
  String get sellerDashBriefsTitle => 'Brief mới';

  @override
  String get sellerDashLearnMore => 'Tìm hiểu thêm';

  @override
  String get sellerDashBriefsEmpty => 'Chưa có brief mới';

  @override
  String sellerDashBriefsCount(int n) {
    return '$n brief phù hợp với bạn';
  }

  @override
  String get sellerDashBriefsDesc =>
      'Khám phá dự án tiềm năng từ khách hàng – brief phù hợp với kỹ năng của bạn sẽ được gửi đến đây.';

  @override
  String get sellerDashViewDetails => 'Xem chi tiết';

  @override
  String get sellerDashEarningsThisMonth => 'Thu nhập tháng này';

  @override
  String get sellerDashAvgPrice => 'Giá bán TB';

  @override
  String get sellerDashCancelledOrders => 'Đơn đã huỷ';

  @override
  String get sellerDashActiveOrdersTitle => 'Đơn hàng đang thực hiện';

  @override
  String get sellerDashNoActiveOrders => 'Chưa có đơn hàng nào đang thực hiện.';

  @override
  String get sellerDashMyLevel => 'Cấp độ của tôi';

  @override
  String sellerDashDue(String date) {
    return 'Hạn $date';
  }

  @override
  String get sellerLevelTitle => 'Tổng quan cấp độ';

  @override
  String get sellerLevelSystem => 'Hệ thống cấp độ';

  @override
  String get sellerLevelSystemDesc =>
      'Cấp độ được đánh giá lại hằng tháng dựa trên hiệu suất 60 ngày gần nhất của bạn.';

  @override
  String get sellerLevelColumn => 'Cấp độ';

  @override
  String get sellerLevelTopRatedNote =>
      'Để đạt Top Rated, hồ sơ của bạn cần được đội ngũ VietGig xét duyệt thêm.';

  @override
  String get sellerLevelTopReached => 'Bạn đã đạt cấp cao nhất!';

  @override
  String sellerLevelNext(String level) {
    return 'Cấp tiếp theo: $level';
  }

  @override
  String get sellerLevelPerformance => 'Chỉ số hiệu suất';

  @override
  String get sellerLevelBasedOn => 'Dựa trên hoạt động 60 ngày gần nhất.';

  @override
  String get sellerLevelSuccessInfo =>
      'Điểm từ 1–10 phản ánh mức độ hài lòng của khách hàng, dựa trên đánh giá riêng tư, tỉ lệ huỷ đơn và giao đúng hạn.';

  @override
  String get sellerLevelRatingInfo =>
      'Điểm đánh giá trung bình người mua dành cho bạn.';

  @override
  String get sellerLevelResponseInfo =>
      'Tỉ lệ tin nhắn mới bạn trả lời trong vòng 24 giờ.';

  @override
  String get sellerLevelOrdersInfo => 'Số đơn hàng đã hoàn thành.';

  @override
  String get sellerLevelUniqueClients => 'Khách hàng duy nhất';

  @override
  String get sellerLevelUniqueClientsInfo =>
      'Số người mua khác nhau đã hoàn thành đơn với bạn.';

  @override
  String get sellerLevelEarningsInfo =>
      'Tổng thu nhập từ các đơn đã hoàn thành.';

  @override
  String get sellerLevelReachNext => 'Đạt cấp tiếp theo';

  @override
  String get sellerLevelProgressNext => 'Tiến độ tới cấp tiếp theo';

  @override
  String sellerLevelTarget(String level) {
    return 'Mục tiêu $level';
  }

  @override
  String get sellerLevelExplain => 'Giải thích';

  @override
  String get sellerRangeLast30 => '30 ngày qua';

  @override
  String get sellerRangeLast3Months => '3 tháng qua';

  @override
  String get sellerRangeThisYear => 'Năm nay';

  @override
  String get sellerRangeLastYear => 'Năm ngoái';

  @override
  String get sellerEarningsPickRange => 'Chọn khoảng thời gian';

  @override
  String sellerEarningsWithdrawTo(String amount) {
    return 'Rút $amount về';
  }

  @override
  String get sellerEarningsBank => 'Tài khoản ngân hàng';

  @override
  String get sellerEarningsBankSubtitle =>
      'Vietcombank •••• 6789 · 1–3 ngày làm việc';

  @override
  String get sellerEarningsMomo => 'Ví MoMo';

  @override
  String get sellerEarningsMomoSubtitle => '090 •••• 123 · Nhận ngay';

  @override
  String sellerEarningsSentBank(String amount) {
    return 'Đã gửi yêu cầu rút $amount về tài khoản ngân hàng';
  }

  @override
  String sellerEarningsSentMomo(String amount) {
    return 'Đã gửi yêu cầu rút $amount về ví MoMo';
  }

  @override
  String get sellerEarningsWithdraw => 'Rút tiền';

  @override
  String get sellerEarningsNothing => 'Bạn chưa có khoản nào có thể rút.';

  @override
  String get sellerEarningsOverview => 'Tổng quan';

  @override
  String get sellerEarningsCompleted => 'Đơn hoàn thành';

  @override
  String sellerEarningsTotal(String amount) {
    return 'Tổng thu nhập: $amount';
  }

  @override
  String sellerEarningsTotalOrders(int n) {
    return 'Tổng đơn hoàn thành: $n';
  }

  @override
  String get sellerEarningsAnalytics => 'Phân tích';

  @override
  String sellerEarningsMonth(String month) {
    return 'Thu nhập tháng $month';
  }

  @override
  String get sellerEarningsAvgPrice => 'Giá bán trung bình';

  @override
  String get sellerEarningsRevenue => 'Doanh thu';

  @override
  String get sellerEarningsClearingInfo =>
      'Khoản thanh toán từ đơn hoàn thành sẽ được giữ 14 ngày trước khi chuyển sang số dư có thể rút. Điều này giúp bảo vệ cả bạn và người mua khi có tranh chấp.';

  @override
  String get sellerEarningsToDate => 'Thu nhập đến nay';

  @override
  String get sellerEarningsToDateInfo =>
      'Tổng thu nhập bạn đã kiếm được trên VietGig kể từ khi bắt đầu bán, sau khi trừ phí dịch vụ.';

  @override
  String get sellerEarningsExpenses => 'Chi phí đến nay';

  @override
  String get sellerEarningsExpensesInfo =>
      'Tổng số tiền bạn đã dùng thu nhập để thanh toán trên VietGig, ví dụ mua dịch vụ hoặc quảng bá dịch vụ của mình.';

  @override
  String get sellerEarningsWithdrawn => 'Đã rút đến nay';

  @override
  String get sellerEarningsWithdrawnInfo =>
      'Tổng số tiền bạn đã rút từ VietGig về tài khoản ngân hàng hoặc ví điện tử.';

  @override
  String get sellerAvailTitle => 'Lịch làm việc';

  @override
  String get sellerAvailReasonVacation => 'Đi nghỉ';

  @override
  String get sellerAvailReasonOverloaded => 'Quá tải công việc';

  @override
  String get sellerAvailReasonOther => 'Khác';

  @override
  String get sellerAvailConfirmed => 'Đã xác nhận ngày bận của bạn';

  @override
  String get sellerAvailChangesSaved => 'Đã lưu thay đổi lịch bận';

  @override
  String get sellerAvailDeleted => 'Đã xoá lịch bận';

  @override
  String get sellerAvailDesc =>
      'Khi bận, dịch vụ của bạn bị ẩn và bạn không nhận đơn/tin nhắn mới. Tỉ lệ phản hồi của bạn sẽ không bị ảnh hưởng trong thời gian này.';

  @override
  String get sellerAvailSet => 'Đặt ngày bận';

  @override
  String get sellerAvailUpcoming => 'Ngày bận sắp tới';

  @override
  String get sellerAvailEdit => 'Sửa';

  @override
  String sellerAvailReasonLine(String reason) {
    return 'Lý do: $reason';
  }

  @override
  String sellerAvailReasonLineContact(String reason) {
    return 'Lý do: $reason · Người mua vẫn có thể liên hệ';
  }

  @override
  String get sellerAvailPickFirst => 'Chọn ngày đầu';

  @override
  String get sellerAvailPickLast => 'Chọn ngày cuối';

  @override
  String get sellerAvailPick => 'Chọn';

  @override
  String sellerAvailSaveError(String error) {
    return 'Không lưu được: $error';
  }

  @override
  String get sellerAvailDeleteTitle => 'Xoá lịch bận đã đặt?';

  @override
  String get sellerAvailDeleteMessage =>
      'Thao tác này sẽ xoá các ngày bận hiện tại của bạn.';

  @override
  String get sellerAvailEditTitle => 'Sửa ngày bận';

  @override
  String get sellerAvailFirstDay => 'Ngày đầu';

  @override
  String get sellerAvailLastDay => 'Ngày cuối';

  @override
  String get sellerAvailInvalidRange =>
      'Ngày cuối phải sau hoặc trùng ngày đầu.';

  @override
  String get sellerAvailReason => 'Lý do';

  @override
  String get sellerAvailNoteLabel => 'Ghi chú (tuỳ chọn)';

  @override
  String get sellerAvailNoteHint => 'Tôi đang bận, nhưng sẽ sớm quay lại.';

  @override
  String get sellerAvailNoteHelp =>
      'Ghi chú này sẽ hiển thị trong thông báo trên trang dịch vụ và hồ sơ của bạn.';

  @override
  String get sellerAvailAllowContact => 'Mọi người mua có thể liên hệ tôi';

  @override
  String get sellerAvailAllowContactOn =>
      'Lưu ý: thời gian phản hồi các tin nhắn này vẫn tính vào tỉ lệ phản hồi. Chỉ bật nếu bạn có thể trả lời.';

  @override
  String get sellerAvailAllowContactOff =>
      'Khi bận, người mua không thể đặt đơn hay liên hệ bạn, nhưng bạn vẫn có thể nhắn tin với người mua có đơn đang thực hiện.';

  @override
  String get sellerAvailSaveChanges => 'Lưu thay đổi';

  @override
  String get sellerAvailConfirm => 'Xác nhận ngày';

  @override
  String get sellerAvailDelete => 'Xoá lịch bận';

  @override
  String get sellerBriefsTitle => 'Brief';

  @override
  String get sellerBriefsPrefs => 'Tuỳ chọn brief';

  @override
  String get sellerBriefsPrefsUpdated => 'Đã cập nhật tuỳ chọn brief';

  @override
  String sellerBriefsResponded(String title) {
    return 'Đã gửi phản hồi cho brief “$title”';
  }

  @override
  String get sellerBriefsWhat => 'Brief là gì?';

  @override
  String get sellerBriefsWhatBody =>
      'Brief là mô tả dự án do người mua đăng lên. VietGig sẽ gửi đến bạn những brief phù hợp với dịch vụ và kỹ năng của bạn để bạn gửi báo giá.';

  @override
  String get sellerBriefsTabMatches => 'Phù hợp với bạn';

  @override
  String get sellerBriefsTabSent => 'Phản hồi đã gửi';

  @override
  String get sellerBriefsOffTitle => 'Bạn đang tắt nhận brief';

  @override
  String get sellerBriefsOffMessage =>
      'Bật lại \"Nhận brief mới\" trong tuỳ chọn để không bỏ lỡ dự án phù hợp.';

  @override
  String get sellerBriefsOffAction => 'Mở tuỳ chọn brief';

  @override
  String get sellerBriefsEmptyTitle => 'Chưa có brief phù hợp…';

  @override
  String get sellerBriefsEmptyMessage =>
      'Chúng tôi sẽ báo cho bạn ngay khi có brief phù hợp với kỹ năng của bạn.';

  @override
  String get sellerBriefsSentEmptyTitle => 'Có lẽ đã đến lúc cho một dự án mới';

  @override
  String get sellerBriefsSentEmptyMessage =>
      'Phản hồi brief trong tab \"Phù hợp với bạn\" và quản lý các phản hồi đã gửi tại đây.';

  @override
  String get sellerBriefsIntroTitle => 'Tab phù hợp của bạn';

  @override
  String get sellerBriefsNewBadge => 'MỚI';

  @override
  String get sellerBriefsIntroBody =>
      'Tất cả brief mới dành cho bạn sẽ hiển thị ở tab này – bạn có thể là người đầu tiên gửi báo giá.';

  @override
  String get sellerBriefsNext => 'Tiếp';

  @override
  String get sellerBriefsBuyer => 'Người mua';

  @override
  String sellerBriefsBudget(String budget, String days) {
    return 'Ngân sách $budget · $days';
  }

  @override
  String get sellerBriefsSent => 'Đã gửi';

  @override
  String get sellerBriefsSendOffer => 'Gửi báo giá';

  @override
  String get sellerBriefsReceiveTitle => 'Nhận brief';

  @override
  String get sellerBriefsReceiveDesc =>
      'Chọn có muốn nhận brief hay không. Bạn có thể bật lại bất cứ lúc nào.';

  @override
  String get sellerBriefsReceiveNew => 'Nhận brief mới';

  @override
  String get sellerBriefsPriceTitle => 'Giá brief';

  @override
  String get sellerBriefsPriceDesc =>
      'Đặt mức giá tối thiểu cho các brief bạn muốn nhận. Có thể thay đổi bất cứ lúc nào.';

  @override
  String get sellerBriefsMinPrice => 'Giá tối thiểu (tuỳ chọn)';

  @override
  String get sellerBriefsPriceHint => 'Nhập giá';

  @override
  String get sellerGigsShare => 'Chia sẻ dịch vụ';

  @override
  String get sellerGigsShareTitle => 'Chia sẻ dịch vụ của bạn';

  @override
  String get sellerGigsShareDesc =>
      'Chia sẻ liên kết dịch vụ lên mạng xã hội để tiếp cận thêm nhiều người mua.';

  @override
  String get sellerGigsLinkCopied => 'Đã sao chép liên kết dịch vụ';

  @override
  String get sellerGigsSampleNote =>
      'Dịch vụ mẫu – bạn chưa có dịch vụ nào. Dưới đây là ví dụ để bạn tham khảo.';

  @override
  String get sellerGigsEmptyTitle => 'Chưa có dịch vụ';

  @override
  String get sellerGigsEmptyMessage =>
      'Tạo dịch vụ đầu tiên để bắt đầu nhận đơn.';

  @override
  String get sellerGigsResumed => 'Dịch vụ đã hoạt động trở lại';

  @override
  String get sellerGigsPausedSnack => 'Đã tạm dừng dịch vụ';

  @override
  String get sellerGigsBoost => 'Tăng lượt truy cập';

  @override
  String get sellerGigsNoReviews => 'Chưa có đánh giá';

  @override
  String get sellerGigsActive => 'Đang hoạt động';

  @override
  String get sellerGigsPaused => 'Tạm dừng';

  @override
  String get sellerGigsSample => 'Dịch vụ mẫu';

  @override
  String get sellerGigsPromoTitle => 'Quảng bá trên mạng xã hội';

  @override
  String get sellerGigsPromoBody =>
      'Tạo video ngắn giới thiệu dịch vụ và chia sẻ lên Facebook, TikTok, Zalo để thu hút thêm người mua. Tính năng tạo video sẽ sớm ra mắt trên VietGig.';

  @override
  String get sellerGigsPromoBanner => 'Quảng bá dịch vụ';

  @override
  String get sellerGigsFeatured => 'Nổi bật';

  @override
  String get sellerGigsPromoHeadline =>
      'Muốn có thêm người mua từ mạng xã hội? Tạo video quảng bá dịch vụ chỉ trong vài phút.';

  @override
  String get sellerTplTitle => 'Mẫu báo giá';

  @override
  String sellerTplSaved(String name) {
    return 'Đã lưu mẫu “$name”';
  }

  @override
  String sellerTplDeleted(String name) {
    return 'Đã xoá mẫu “$name”';
  }

  @override
  String get sellerTplCreate => 'Tạo mẫu';

  @override
  String get sellerTplEmptyTitle => 'Tạo mẫu cho báo giá riêng';

  @override
  String get sellerTplEmptyMessage =>
      'Lưu báo giá làm mẫu để dùng lại cho những lần sau.';

  @override
  String get sellerTplSwipeHint => 'Vuốt sang trái để xoá mẫu.';

  @override
  String sellerTplSubtitle(String days) {
    return 'Thanh toán một lần | Giao trong $days';
  }

  @override
  String get sellerTplSheetTitle => 'Tạo mẫu báo giá';

  @override
  String get sellerTplName => 'Tên mẫu';

  @override
  String get sellerTplNameHint => 'VD: Gói thiết kế cao cấp';

  @override
  String get sellerTplNameRequired => 'Vui lòng nhập tên mẫu';

  @override
  String get sellerTplPrice => 'Giá';

  @override
  String get sellerTplPriceRequired => 'Vui lòng nhập giá';

  @override
  String sellerTplPriceMin(String amount) {
    return 'Giá tối thiểu là $amount';
  }

  @override
  String get sellerTplDays => 'Số ngày giao';

  @override
  String get sellerTplDaysSuffix => 'ngày';

  @override
  String get sellerTplDaysInvalid => 'Số ngày từ 1 đến 90';

  @override
  String get sellerTplSave => 'Lưu mẫu';
}
