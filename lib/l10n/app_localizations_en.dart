// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authPwRuleLength => 'At least 8 characters';

  @override
  String get authPwRuleUpper => 'At least 1 uppercase letter';

  @override
  String get authPwRuleLower => 'At least 1 lowercase letter';

  @override
  String get authPwRuleDigit => 'At least 1 number';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithFacebook => 'Continue with Facebook';

  @override
  String get authTermsPrefix => 'By joining, you agree to the VietGig ';

  @override
  String get authTermsLink => 'Terms of Service';

  @override
  String get authTermsSuffix => '.';

  @override
  String get authTermsBody =>
      '1. You are responsible for your account information and keeping your password secure.\n\n2. All transactions must be made through VietGig to be covered by payment protection.\n\n3. Posting content that violates Vietnamese law or intellectual property rights is strictly prohibited.\n\n4. VietGig may temporarily suspend accounts that violate the community guidelines.\n\n5. Personal data is processed in accordance with the Privacy Policy.';

  @override
  String get authSkip => 'Skip';

  @override
  String get authContinue => 'Continue';

  @override
  String get authFinish => 'Finish';

  @override
  String get authClear => 'Clear';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authPasswordHint => 'Password';

  @override
  String get authEmailHint => 'Email';

  @override
  String get authResendEmail => 'Resend email';

  @override
  String get authWelcomeHeadline => 'Freelance services.\nOn demand.';

  @override
  String get authWelcomeBuyTitle => 'Find services';

  @override
  String get authWelcomeBuySubtitle =>
      'I\'m looking for talented freelancers to work with';

  @override
  String get authWelcomeSellTitle => 'Sell services';

  @override
  String get authWelcomeSellSubtitle => 'I want to offer my services';

  @override
  String get authSignInTitle => 'Sign in to your account';

  @override
  String get authSignInSubtitle => 'Welcome back to VietGig!';

  @override
  String get authIdHint => 'Email or username';

  @override
  String get authIdRequired => 'Please enter your email or username';

  @override
  String get authPasswordRequired => 'Please enter your password';

  @override
  String get authForgotLink => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authJoinNow => 'Join now';

  @override
  String authDemoAccount(String email, String password) {
    return 'Demo account: $email / $password';
  }

  @override
  String get authFill => 'Fill in';

  @override
  String get authSignUpTitle => 'Join VietGig';

  @override
  String get authSignUpSubtitle =>
      'Additional verification may be required later.';

  @override
  String get authUsernameHint => 'Public username';

  @override
  String get authUsernameInvalid =>
      '4–20 characters: letters, numbers, \"_\" or \".\"';

  @override
  String get authUsernameNote =>
      'You can\'t change your username later, so choose carefully.';

  @override
  String get authEmailInvalid => 'Invalid email';

  @override
  String get authSignUpSubmit => 'Sign up';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authOnbPurposeWork => 'Primary job or business';

  @override
  String get authOnbPurposeWorkDesc =>
      'Projects for the company you work for or for your own business.';

  @override
  String get authOnbPurposeSide => 'Side project or small business';

  @override
  String get authOnbPurposeSideDesc =>
      'Anything you do outside your main job, like a side hustle.';

  @override
  String get authOnbPurposePersonal => 'Personal use';

  @override
  String get authOnbPurposePersonalDesc =>
      'Services for personal growth or hobbies, outside of work.';

  @override
  String get authOnbExpNew => 'Just getting started';

  @override
  String get authOnbExpOnline => 'Online freelancing';

  @override
  String get authOnbExpOffline => 'Offline freelancing';

  @override
  String get authOnbExpBoth => 'Both online and offline';

  @override
  String get authOnbSaveError =>
      'Couldn\'t save your choices. Please try again.';

  @override
  String get authOnbPurposeTitle => 'What will you use VietGig for?';

  @override
  String get authOnbPurposeSub => 'You can choose more than one.';

  @override
  String get authOnbInterestTitle => 'Pick the services that fit your needs';

  @override
  String get authOnbInterestSub => 'Choose at least one.';

  @override
  String get authOnbOther => 'Other';

  @override
  String get authOnbLookingForTitle => 'What service are you looking for?';

  @override
  String get authOnbLookingForHint => 'E.g. Restaurant menu design';

  @override
  String get authOnbExpTitle => 'What\'s your freelancing experience?';

  @override
  String get authOnbExpSub => 'Whatever your style, we\'ve got you covered.';

  @override
  String get authVerifyResent => 'Verification email resent';

  @override
  String get authVerifySendFailed =>
      'Couldn\'t send the email. Please try again.';

  @override
  String get authVerifyActivated => 'Your account has been activated!';

  @override
  String get authVerifyNotYet => 'Couldn\'t verify yet. Please try again.';

  @override
  String get authVerifyDoneTitle => 'Your email has been verified';

  @override
  String get authVerifyTitle => 'Verify your email to continue';

  @override
  String get authVerifySentTo => 'We sent an email to:';

  @override
  String get authVerifyBody =>
      'Tap the link in the email to verify your address and activate your account.';

  @override
  String get authVerifyWrongEmail => 'Not the email you want to use?';

  @override
  String get authVerifyChangeEmail => 'Change email address';

  @override
  String get authVerifyDemoNote =>
      'Demo: tap \"I\'ve verified\" to simulate opening the link.';

  @override
  String get authVerifyConfirm => 'I\'ve verified';

  @override
  String authResendIn(int seconds) {
    return 'Resend email in ${seconds}s';
  }

  @override
  String get authForgotInvalidEmail => 'Please enter a valid email';

  @override
  String get authForgotSent => 'Password reset link sent';

  @override
  String get authForgotTitle => 'Forgot password';

  @override
  String get authForgotHeading => 'Reset your password';

  @override
  String get authForgotBody =>
      'Enter the email you signed up with and we\'ll send you a link to reset your password.';

  @override
  String get authForgotSubmit => 'Send link';

  @override
  String get authForgotCheckInbox => 'Check your inbox';

  @override
  String authForgotSentTo(String email) {
    return 'We sent a password reset link to\n$email';
  }

  @override
  String get authBackToSignIn => 'Back to sign in';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonOk => 'OK';

  @override
  String get commonAgree => 'Confirm';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonBack => 'Back';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSaved => 'Saved';

  @override
  String get commonDone => 'Done';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonOr => 'Or';

  @override
  String get commonSignIn => 'Sign in';

  @override
  String get commonMessage => 'Message';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonFrom => 'From';

  @override
  String get commonUnderConstruction => 'Under construction';

  @override
  String get timeDays => 'Days';

  @override
  String get timeHours => 'Hours';

  @override
  String get timeMinutes => 'Minutes';

  @override
  String get timeJustNow => 'Just now';

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String timeMinutesAgo(int n) {
    return '$n min ago';
  }

  @override
  String timeHoursAgo(int n) {
    return '$n h ago';
  }

  @override
  String timeDaysAgo(int n) {
    return '$n days ago';
  }

  @override
  String timeMonthsAgo(int n) {
    return '$n months ago';
  }

  @override
  String timeYearsAgo(int n) {
    return '$n years ago';
  }

  @override
  String timeNDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get weekday1 => 'Monday';

  @override
  String get weekday2 => 'Tuesday';

  @override
  String get weekday3 => 'Wednesday';

  @override
  String get weekday4 => 'Thursday';

  @override
  String get weekday5 => 'Friday';

  @override
  String get weekday6 => 'Saturday';

  @override
  String get weekday7 => 'Sunday';

  @override
  String get navHome => 'Home';

  @override
  String get navInbox => 'Inbox';

  @override
  String get navSearch => 'Search';

  @override
  String get navOrders => 'Orders';

  @override
  String get navAccount => 'Account';

  @override
  String get badgeChoice => 'VIETGIG\'S CHOICE';

  @override
  String get orderStatusAwaitingRequirements => 'AWAITING INFO';

  @override
  String get orderStatusInProgress => 'IN PROGRESS';

  @override
  String get orderStatusDelivered => 'DELIVERED';

  @override
  String get orderStatusRevisionRequested => 'REVISION';

  @override
  String get orderStatusCompleted => 'COMPLETED';

  @override
  String get orderStatusCancelled => 'CANCELLED';

  @override
  String get orderStatusDisputed => 'IN RESOLUTION';

  @override
  String get levelNew => 'New';

  @override
  String get levelOne => 'Level 1';

  @override
  String get levelTwo => 'Level 2';

  @override
  String get levelTopRated => 'Top Rated';

  @override
  String get sortRelevance => 'Most relevant';

  @override
  String get sortBestSelling => 'Best selling';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortPriceLow => 'Price: low to high';

  @override
  String get sortPriceHigh => 'Price: high to low';

  @override
  String get sortRating => 'Top rated';

  @override
  String get offerStatusPending => 'Pending';

  @override
  String get offerStatusAccepted => 'Accepted';

  @override
  String get offerStatusDeclined => 'Declined';

  @override
  String get offerStatusWithdrawn => 'Withdrawn';

  @override
  String get offerStatusExpired => 'Expired';

  @override
  String get revisionsUnlimited => 'Unlimited';

  @override
  String get saveSignInTitle => 'Sign in to save';

  @override
  String get saveSignInMessage =>
      'You need to sign in to save services to your lists.';

  @override
  String get saveSheetTitle => 'Saved lists';

  @override
  String get saveCreateNewLink => '+ Create a new list';

  @override
  String get saveCreateNewTitle => 'Create a new list';

  @override
  String get saveListNameHint => 'List name';

  @override
  String get saveListEmpty => 'Empty list';

  @override
  String saveListCount(int gigs, int sellers) {
    return '$gigs gigs • $sellers sellers';
  }

  @override
  String get notifKeyInbox => 'Inbox messages';

  @override
  String get notifKeyOrderMessages => 'Order messages';

  @override
  String get notifKeyOrderUpdates => 'Order updates';

  @override
  String get notifKeyRatingReminders => 'Rating reminders';

  @override
  String get notifKeyBuyerBriefs => 'Buyer briefs';

  @override
  String get notifKeyMyGigs => 'My gigs';

  @override
  String get notifKeyMyAccount => 'My account';

  @override
  String get notifKeyPromotions => 'Promotions';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get languageEnglish => 'English';

  @override
  String get authErrorMissingCredentials =>
      'Please enter your email/username and password.';

  @override
  String get authErrorUserNotFound => 'We couldn\'t find this account.';

  @override
  String get authErrorWrongPassword => 'Incorrect password. Please try again.';

  @override
  String get authErrorUsernameTaken => 'This username is already taken.';

  @override
  String get authErrorEmailTaken => 'This email is already registered.';

  @override
  String get authErrorInvalidEmail => 'Invalid email address.';

  @override
  String get authErrorActiveOrders =>
      'You can\'t delete your account while you have orders in progress. Please contact support.';

  @override
  String get authErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get gigLinkCopied => 'Link copied';

  @override
  String get gigSearchHint => 'Search for services';

  @override
  String get gigCriteriaCommunication => 'Seller communication';

  @override
  String get gigCriteriaQuality => 'Quality of delivery';

  @override
  String get gigCriteriaValue => 'Value for money';

  @override
  String get gigRatingOverall => 'Overall rating';

  @override
  String gigReviewCount(String count) {
    return '$count reviews';
  }

  @override
  String get gigReviewSortPositive => 'Most positive';

  @override
  String get gigReviewSortNegative => 'Most negative';

  @override
  String get gigSortBy => 'Sort by';

  @override
  String get gigSortTooltip => 'Sort';

  @override
  String get gigReviewPrice => 'Price';

  @override
  String get gigReviewDuration => 'Duration';

  @override
  String get gigSellerResponse => 'Seller\'s response';

  @override
  String get gigResponseHide => 'Hide';

  @override
  String get gigResponseRead => 'Read';

  @override
  String get gigNewSeller => 'New seller';

  @override
  String get gigShare => 'Share';

  @override
  String get gigReport => 'Report this service';

  @override
  String get gigReportTitle => 'Why are you reporting this service?';

  @override
  String get gigReportCopyright => 'Copyright infringement';

  @override
  String get gigReportContent => 'Inappropriate content';

  @override
  String get gigReportSpam => 'Scam / spam';

  @override
  String get gigReportOther => 'Other reason';

  @override
  String get gigReportThanks =>
      'Thank you! We\'ll review your report within 24 hours.';

  @override
  String get gigNotFoundTitle => 'Service not found';

  @override
  String get gigNotFoundMessage =>
      'This service may have been removed or temporarily hidden.';

  @override
  String get gigNotFoundAction => 'Explore other services';

  @override
  String get gigMore => 'More';

  @override
  String get gigFaqTitle => 'FAQ';

  @override
  String get gigPortfolio => 'Portfolio';

  @override
  String gigMoreFromSeller(String name) {
    return 'More services by $name';
  }

  @override
  String get gigSellerFallback => 'this seller';

  @override
  String get gigRecentlyViewed => 'Recently viewed';

  @override
  String get gigShowLess => 'Show less';

  @override
  String get gigShowMore => 'Show more';

  @override
  String gigShowMoreSkills(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Show $n more skills',
      one: 'Show 1 more skill',
    );
    return '$_temp0';
  }

  @override
  String get gigDeliveryTime => 'Delivery time';

  @override
  String get gigRevisions => 'Revisions';

  @override
  String gigContinueWithPrice(String price) {
    return 'Continue ($price)';
  }

  @override
  String get gigComparePackages => 'Compare packages';

  @override
  String get gigPackage => 'Package';

  @override
  String gigSelectPackage(String tier) {
    return 'Select $tier';
  }

  @override
  String get gigAboutSeller => 'About the seller';

  @override
  String get gigFrom => 'From';

  @override
  String get gigMemberSince => 'Member since';

  @override
  String gigMemberSinceValue(String month, String year) {
    return '$month/$year';
  }

  @override
  String gigMemberSinceLong(String month, String year) {
    return '$month/$year';
  }

  @override
  String get gigAvgResponse => 'Avg. response';

  @override
  String get gigAvgResponseLong => 'Avg. response time';

  @override
  String gigHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get gigLanguages => 'Languages';

  @override
  String get gigContact => 'Contact';

  @override
  String get gigNoReviews => 'No reviews yet.';

  @override
  String gigSeeAllReviews(String count) {
    return 'See all $count reviews';
  }

  @override
  String get gigSeeAllReviewsPlain => 'See all reviews';

  @override
  String get gigTabAbout => 'About';

  @override
  String get gigTabGigs => 'Services';

  @override
  String get gigTabReviews => 'Reviews';

  @override
  String get gigTabClients => 'Clients';

  @override
  String get gigUserNotFoundTitle => 'User not found';

  @override
  String get gigUserNotFoundMessage =>
      'This account doesn\'t exist or has been deactivated.';

  @override
  String get gigVettedTitle => 'Vetted by VietGig Pro';

  @override
  String gigVettedMessage(String name) {
    return '$name was hand-picked by the VietGig Pro team for proven expertise.';
  }

  @override
  String get gigVettedFor => 'Vetted for';

  @override
  String get gigOffersHourly => 'Offers hourly work';

  @override
  String get gigInfo => 'Info';

  @override
  String gigFromWithLocalTime(String place, String time) {
    return '$place ($time local time)';
  }

  @override
  String get gigSkills => 'Skills';

  @override
  String get gigCertEducation => 'Certifications & Education';

  @override
  String get gigCertificates => 'Certifications';

  @override
  String get gigEducation => 'Education';

  @override
  String get gigNoGigsTitle => 'No services yet';

  @override
  String gigNoGigsMessage(String name) {
    return '$name hasn\'t posted any services yet.';
  }

  @override
  String get gigNoReviewsTitle => 'No reviews yet';

  @override
  String get gigNoReviewsMessage =>
      'Be the first to work with and review this seller.';

  @override
  String get gigNoPortfolio => 'No portfolio yet';

  @override
  String gigPortfolioIntro(String name) {
    return 'A selection of projects $name has completed, to help you understand their expertise.';
  }

  @override
  String get gigNoClients => 'No business clients yet';

  @override
  String gigClientProject(String company) {
    return 'Project with $company';
  }

  @override
  String gigClientIndustry(String industry) {
    return 'Industry: $industry';
  }

  @override
  String get gigFilterAll => 'All';

  @override
  String get gigFilterFive => '5 stars';

  @override
  String get gigFilterFour => '4 stars';

  @override
  String get gigFilterLow => '3 stars & below';

  @override
  String get gigFilterResponded => 'With response';

  @override
  String get gigSellerNotFound => 'Seller not found';

  @override
  String gigReviewsShown(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n reviews shown',
      one: '1 review shown',
    );
    return '$_temp0';
  }

  @override
  String get gigNoMatchingReviews => 'No matching reviews';

  @override
  String gigPortfolioOf(String name) {
    return '$name\'s portfolio';
  }

  @override
  String get gigNoProjectsTitle => 'No projects yet';

  @override
  String get gigNoProjectsMessage =>
      'This seller hasn\'t added any projects to their portfolio.';

  @override
  String gigPortfolioScreenIntro(String name) {
    return 'A selection of projects $name has completed, so you can better understand their expertise.';
  }

  @override
  String get gigProjectNotFoundTitle => 'Project not found';

  @override
  String get gigProjectNotFoundMessage =>
      'This project may have been removed from the portfolio.';

  @override
  String gigBy(String name) {
    return 'By $name';
  }

  @override
  String gigProjectDefaultDescription(String name) {
    return 'A project $name completed for a client on VietGig.';
  }

  @override
  String get homeCategoriesTooltip => 'Categories';

  @override
  String get homeVerifyTitle => 'Please verify your email';

  @override
  String homeVerifyMessage(String email) {
    return 'We sent a verification email to $email. Check your inbox to activate your account.';
  }

  @override
  String get homeVerifyYourAddress => 'your address';

  @override
  String get homeVerifyAction => 'Activate email →';

  @override
  String get homeGuestMessage =>
      'Sign in to save services, send messages and place orders.';

  @override
  String get homePopularServices => 'Popular services';

  @override
  String get homeCategoriesError => 'Couldn\'t load categories';

  @override
  String get homeCustomOffers => 'Custom offers for you';

  @override
  String get homeActiveOrders => 'Active orders';

  @override
  String homeOrderDue(String date) {
    return 'Due: $date';
  }

  @override
  String get homeInterestsTitle => 'What are you interested in?';

  @override
  String get homeInterestAdd => '+ Add';

  @override
  String get homeInterestAdded => 'Added to your interests';

  @override
  String get homeInterestRemoved => 'Removed from your interests';

  @override
  String get homeRecentlyViewed => 'Recently viewed';

  @override
  String get homeMostLoved => 'Most loved';

  @override
  String get homeInviteTitle => 'Share & earn up to 2,500,000 ₫';

  @override
  String get homeInviteMessage =>
      'Give friends 10% off their first order and earn up to 2,500,000 ₫ when they buy on VietGig.';

  @override
  String get homeInviteAction => 'Invite friends →';

  @override
  String homeOfferSummary(String price, String days) {
    return '$price • $days delivery';
  }

  @override
  String homeOfferExpires(String time) {
    return 'Offer expires at $time';
  }

  @override
  String get homeOfferOpenChat => 'Open chat';

  @override
  String get homeOfferView => 'View';

  @override
  String get inboxEdit => 'Edit';

  @override
  String get inboxFilterTitle => 'Filters';

  @override
  String get inboxSelectTitle => 'Select conversations';

  @override
  String inboxSelectedCount(int n) {
    return '$n selected';
  }

  @override
  String get inboxEmptyTitle => 'No messages yet';

  @override
  String get inboxEmptyMessage =>
      'Send your first message to a seller to discuss your project. All your conversations will appear here.';

  @override
  String get inboxFilterEmptyTitle => 'Try adjusting your filters';

  @override
  String inboxFilterEmptyMessage(String filter) {
    return 'No results for $filter.';
  }

  @override
  String get inboxClearFilter => 'Clear filters';

  @override
  String get inboxArchive => 'Archive';

  @override
  String get inboxUnarchive => 'Unarchive';

  @override
  String get inboxStar => 'Star';

  @override
  String get inboxUnstar => 'Unstar';

  @override
  String get inboxUnstarShort => 'Unstar';

  @override
  String get inboxMore => 'More';

  @override
  String get inboxChangeLabels => 'Edit labels';

  @override
  String get inboxBlock => 'Block';

  @override
  String get inboxUnblock => 'Unblock';

  @override
  String get inboxReport => 'Report';

  @override
  String get inboxMarkRead => 'Mark as read';

  @override
  String get inboxMarkUnread => 'Mark as unread';

  @override
  String get inboxMarkedRead => 'Marked as read';

  @override
  String get inboxMarkedUnread => 'Marked as unread';

  @override
  String inboxConversationCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n conversations',
      one: '1 conversation',
    );
    return '$_temp0';
  }

  @override
  String inboxBulkArchived(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Archived $n conversations',
      one: 'Archived 1 conversation',
    );
    return '$_temp0';
  }

  @override
  String inboxBulkUnarchived(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Moved $n conversations back to Inbox',
      one: 'Moved 1 conversation back to Inbox',
    );
    return '$_temp0';
  }

  @override
  String inboxBulkStarred(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Starred $n conversations',
      one: 'Starred 1 conversation',
    );
    return '$_temp0';
  }

  @override
  String get inboxUnstarred => 'Removed star';

  @override
  String get inboxLabelsUpdated => 'Labels updated';

  @override
  String inboxBlockManyTitle(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Block $n users?',
      one: 'Block 1 user?',
    );
    return '$_temp0';
  }

  @override
  String get inboxBlockManyMessage =>
      'You will no longer receive messages from these people.';

  @override
  String get inboxUserBlocked => 'User blocked';

  @override
  String get inboxUserUnblocked => 'User unblocked';

  @override
  String get inboxDeleteTitle => 'Delete conversation?';

  @override
  String inboxDeleteManyMessage(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Delete $n selected conversations? This can\'t be undone.',
      one: 'Delete the selected conversation? This can\'t be undone.',
    );
    return '$_temp0';
  }

  @override
  String inboxBulkDeleted(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Deleted $n conversations',
      one: 'Deleted 1 conversation',
    );
    return '$_temp0';
  }

  @override
  String get inboxUnknownUser => 'VietGig user';

  @override
  String get inboxUser => 'User';

  @override
  String get inboxStartConversation => 'Start the conversation';

  @override
  String get inboxFilterInbox => 'Inbox';

  @override
  String get inboxFilterAll => 'All';

  @override
  String get inboxFilterUnread => 'Unread';

  @override
  String get inboxFilterStarred => 'Starred';

  @override
  String get inboxFilterArchived => 'Archived';

  @override
  String get inboxFilterSpam => 'Spam';

  @override
  String get inboxFilterOffers => 'Custom offers';

  @override
  String get inboxLabelsHeader => 'Labels';

  @override
  String get inboxLabelPickerTitle => 'Select labels';

  @override
  String get inboxApply => 'Apply';

  @override
  String get inboxNewLabelHint => 'New label name';

  @override
  String get inboxAddLabel => 'Add new label';

  @override
  String get inboxArchivedOne => 'Conversation archived';

  @override
  String get inboxUnarchivedOne => 'Conversation moved back to Inbox';

  @override
  String get inboxStarredOne => 'Conversation starred';

  @override
  String get inboxBlockTitle => 'Block this user?';

  @override
  String get inboxBlockMessage =>
      'You will no longer receive messages from this person. You can unblock them from Spam.';

  @override
  String get inboxDeleteMessage =>
      'Are you sure you want to delete this conversation? This can\'t be undone.';

  @override
  String get inboxDeletedOne => 'Conversation deleted';

  @override
  String get inboxReportTitle => 'Report user';

  @override
  String get inboxReportFraud => 'Scam or fraud';

  @override
  String get inboxReportOffsite => 'Asked to pay outside VietGig';

  @override
  String get inboxReportAbuse => 'Abusive language';

  @override
  String get inboxReportSpam => 'Spam';

  @override
  String get inboxReportThanks =>
      'Thank you! We\'ll review your report within 24 hours.';

  @override
  String get inboxAutoReply =>
      'Thanks! I\'ll get back to you with details shortly.';

  @override
  String get inboxSendFailed => 'Couldn\'t send the message. Please try again.';

  @override
  String get inboxYou => 'You';

  @override
  String inboxPlainFile(String name) {
    return 'File: $name';
  }

  @override
  String inboxPlainOffer(String title, String price) {
    return 'Offer: $title – $price';
  }

  @override
  String get inboxVideoInvite => 'Video call invitation';

  @override
  String get inboxVideoInviteText => 'I\'d like to invite you to a video call';

  @override
  String get inboxAttachAlbum => 'Photo library';

  @override
  String get inboxAttachCamera => 'Camera';

  @override
  String get inboxAttachFile => 'Send a file';

  @override
  String get inboxAttachOffer => 'Create an offer';

  @override
  String get inboxAttachVideo => 'Start a video call';

  @override
  String get inboxQuickReplies => 'Quick responses';

  @override
  String get inboxQuickFallbackName => 'there';

  @override
  String get inboxReply => 'Reply';

  @override
  String get inboxForward => 'Forward';

  @override
  String get inboxCopy => 'Copy';

  @override
  String get inboxCopied => 'Message copied';

  @override
  String inboxForwarded(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Forwarded to $n conversations',
      one: 'Forwarded to 1 conversation',
    );
    return '$_temp0';
  }

  @override
  String get inboxWithdrawOfferTitle => 'Withdraw offer?';

  @override
  String get inboxWithdrawOfferMessage =>
      'The buyer will no longer be able to accept this offer.';

  @override
  String get inboxDeclineOfferTitle => 'Decline offer?';

  @override
  String get inboxDeclineOfferMessage =>
      'The seller will be notified that you declined this offer.';

  @override
  String get inboxWithdraw => 'Withdraw';

  @override
  String get inboxDecline => 'Decline';

  @override
  String get inboxOfferWithdrawn => 'Offer withdrawn';

  @override
  String get inboxOfferDeclined => 'Offer declined';

  @override
  String get inboxSafetyTitle => 'We\'ve got your back';

  @override
  String get inboxCallDialogMessage =>
      'VietGig records video calls to keep both sides safe and to help resolve any disputes. Please don\'t share payment details during the call.';

  @override
  String get inboxOpenCall => 'Open call';

  @override
  String get inboxCallConnecting => 'Connecting video call… (simulated)';

  @override
  String get inboxCallGuidelinesTitle => 'Video call guidelines';

  @override
  String get inboxCallGuidelinesMessage =>
      '• Keep the conversation about the project.\n• Don\'t share payment details or contact info outside VietGig.\n• Calls are recorded and kept for 30 days.\n• You can report inappropriate behavior after the call.';

  @override
  String get inboxGotIt => 'Got it';

  @override
  String get inboxActiveOrdersTitle => 'Active orders';

  @override
  String get inboxNoOrdersTitle => 'No orders yet';

  @override
  String inboxNoOrdersMessage(String name) {
    return 'You don\'t have any active orders with $name.';
  }

  @override
  String get inboxThisPartner => 'this person';

  @override
  String inboxOrderDue(String date, String price) {
    return 'Due: $date · $price';
  }

  @override
  String get inboxMessagesTitle => 'Messages';

  @override
  String get inboxOnline => 'Online';

  @override
  String inboxLocalTime(String time) {
    return 'Local time $time';
  }

  @override
  String get inboxOptionsTooltip => 'Options';

  @override
  String get inboxLoadFailed => 'Couldn\'t load messages';

  @override
  String get inboxNotFoundTitle => 'Conversation not found';

  @override
  String get inboxNotFoundMessage => 'This conversation may have been deleted.';

  @override
  String get inboxScrollDown => 'Scroll to bottom';

  @override
  String get inboxBlockedNotice => 'You blocked this user.';

  @override
  String get inboxSafetyDialogTitle => 'Stay safe on VietGig';

  @override
  String get inboxSafetyDialogMessage =>
      'When you pay and communicate through VietGig, you\'re protected by our refund policy and support team. Never send money directly or share your login details with anyone.';

  @override
  String inboxStartChatHint(String name) {
    return 'Send $name a message to start the conversation.';
  }

  @override
  String get inboxPartner => 'your contact';

  @override
  String inboxTyping(String name) {
    return '$name is typing…';
  }

  @override
  String get inboxPartnerCap => 'Your contact';

  @override
  String get inboxAttachment => 'Attachment';

  @override
  String inboxDownloading(String name) {
    return 'Downloading $name…';
  }

  @override
  String get inboxFileFallback => 'file';

  @override
  String get inboxCallCancelled => 'Video call invitation cancelled';

  @override
  String get inboxCallDeclined => 'Video call invitation declined';

  @override
  String inboxReplyingTo(String name) {
    return 'Replying to $name…';
  }

  @override
  String get inboxAttachTooltip => 'Attach';

  @override
  String get inboxInputHint => 'Type a message…';

  @override
  String get inboxSend => 'Send';

  @override
  String get inboxToday => 'Today';

  @override
  String get inboxSafetyBanner =>
      'For your safety, keep all payments and communication on VietGig. ';

  @override
  String get inboxLearnMore => 'Learn more';

  @override
  String get inboxRelatedTo => 'This message is about:';

  @override
  String inboxMilestoneCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n milestones',
      one: '1 milestone',
    );
    return '$_temp0';
  }

  @override
  String inboxDeliverIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Delivery in $n days',
      one: 'Delivery in 1 day',
    );
    return '$_temp0';
  }

  @override
  String inboxOptionsSummary(int n, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n options',
      one: '1 option',
    );
    return '$_temp0: $list';
  }

  @override
  String inboxOfferPrice(String price) {
    return 'Offer price: $price';
  }

  @override
  String inboxOfferExpiresAt(String time) {
    return 'Offer expires at $time';
  }

  @override
  String get inboxViewFullOffer => 'View full offer';

  @override
  String get inboxWithdrawOffer => 'Withdraw offer';

  @override
  String get inboxVideoSent => 'You sent a video call invitation';

  @override
  String get inboxVideoJoinPrompt => 'Joining?';

  @override
  String get inboxVideoGuidelinesLink => 'View video call guidelines';

  @override
  String get inboxVideoRecorded =>
      'The video call will be recorded and stored so all participants can download it.';

  @override
  String get inboxVideoDeclinedLabel => 'Invitation declined';

  @override
  String get inboxJoin => 'Join';

  @override
  String get inboxCancelInvite => 'Cancel invitation';

  @override
  String get inboxOptCustomAssets => 'Custom assets';

  @override
  String get inboxOptResponsive => 'Responsive design';

  @override
  String get inboxOptWireframe => 'Wireframe';

  @override
  String get inboxOptPrototype => 'Prototype';

  @override
  String get inboxOptSourceFiles => 'Source files';

  @override
  String inboxOptPages(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pages/screens',
      one: '1 page/screen',
    );
    return '$_temp0';
  }

  @override
  String get inboxPagesLabel => 'Number of pages/screens';

  @override
  String get inboxErrGig => 'Please select a gig';

  @override
  String get inboxErrDescEmpty => 'Please enter an offer description';

  @override
  String get inboxErrDescShort => 'Description must be at least 20 characters';

  @override
  String get inboxErrPriceEmpty => 'Please enter the total price';

  @override
  String inboxErrMinPrice(String price) {
    return 'Minimum price is $price';
  }

  @override
  String get inboxErrDays => 'Please select a delivery time';

  @override
  String get inboxErrMilestones => 'At least 2 milestones are required';

  @override
  String get inboxErrTemplate => 'Please name your template';

  @override
  String get inboxErrMsTitle => 'Please enter a milestone name';

  @override
  String get inboxErrMsDesc => 'Please enter a description';

  @override
  String get inboxLinkGigTitle => 'Link to a gig';

  @override
  String get inboxPayTypeTitle => 'How would you like to get paid?';

  @override
  String get inboxPayTypeSubtitle =>
      'Choose the option that best fits the project.';

  @override
  String get inboxPaySingle => 'Single payment';

  @override
  String get inboxPaySingleDesc =>
      'Get paid in full when the project is complete.';

  @override
  String get inboxPayMilestone => 'Milestones';

  @override
  String get inboxPayMilestoneDesc =>
      'Work step by step and get paid after each completed milestone.';

  @override
  String get inboxDeliveryTime => 'Delivery time';

  @override
  String get inboxRevisionsTitle => 'Revisions';

  @override
  String get inboxNoRevisions => 'No revisions';

  @override
  String inboxRevisionsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n revisions',
      one: '1 revision',
    );
    return '$_temp0';
  }

  @override
  String get inboxOfferExpiry => 'Offer expiration';

  @override
  String get inboxCheckOffer => 'Please review the offer details';

  @override
  String inboxOfferSentTemplate(String name) {
    return 'Offer sent and template “$name” saved';
  }

  @override
  String get inboxOfferSent => 'Offer sent';

  @override
  String get inboxOfferSendFailed =>
      'Couldn\'t send the offer. Please try again.';

  @override
  String get inboxCreateOfferTitle => 'Create offer';

  @override
  String get inboxGigsLoadFailed => 'Couldn\'t load gigs';

  @override
  String get inboxLinkOfferToGig => 'Link the offer to a gig';

  @override
  String get inboxChange => 'Change';

  @override
  String get inboxNoGigs => 'You don\'t have any gigs to link yet.';

  @override
  String get inboxOfferDescHeader => 'Offer description';

  @override
  String get inboxOfferDescHint => 'E.g. deliverables, timeline, quantity…';

  @override
  String get inboxTotalPrice => 'Total price';

  @override
  String get inboxPick => 'Select';

  @override
  String get inboxRevisionsOptional => 'Revisions (optional)';

  @override
  String inboxMilestoneRowSummary(String price, int days, int revisions) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    String _temp1 = intl.Intl.pluralLogic(
      revisions,
      locale: localeName,
      other: '$revisions revisions',
      one: '1 revision',
    );
    return '$price | $_temp0 | $_temp1';
  }

  @override
  String inboxMaxMilestones(int n) {
    return 'Up to $n milestones';
  }

  @override
  String get inboxAddMilestone => 'Add milestone';

  @override
  String inboxMilestoneTotal(String price, int days, int revisions) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    String _temp1 = intl.Intl.pluralLogic(
      revisions,
      locale: localeName,
      other: '$revisions revisions',
      one: '1 revision',
    );
    return 'Total: $price | $_temp0 | $_temp1';
  }

  @override
  String get inboxAddOptions => 'Add-ons';

  @override
  String get inboxServiceOptions => 'Service options';

  @override
  String inboxSelectedN(int n) {
    return '$n selected';
  }

  @override
  String get inboxOfferSettings => 'Offer settings';

  @override
  String get inboxRequireInfo => 'Request requirements from buyer';

  @override
  String get inboxRequireInfoDesc =>
      'The buyer must answer the requirement questions before work begins';

  @override
  String get inboxSaveTemplate => 'Save as template';

  @override
  String get inboxReuseTemplate => 'Reuse for future offers';

  @override
  String get inboxTemplateNameHint => 'Name your template';

  @override
  String get inboxSendMilestoneOffer => 'Send milestone offer';

  @override
  String get inboxSendOffer => 'Send offer';

  @override
  String inboxMilestoneN(int n) {
    return 'Milestone $n';
  }

  @override
  String get inboxDeleteMilestone => 'Delete milestone';

  @override
  String get inboxDeleteMilestoneTitle => 'Delete this milestone?';

  @override
  String get inboxMsTitleHeader => 'Milestone name';

  @override
  String get inboxMsTitleHint => 'E.g. Wireframe & concept';

  @override
  String get inboxDescHeader => 'Description';

  @override
  String get inboxMsDescHint => 'Deliverables, scope of work…';

  @override
  String inboxMsPriceLabel(String price) {
    return 'Price (min. $price)';
  }

  @override
  String get inboxViewOffer => 'View offer';

  @override
  String get inboxViewMilestoneOffer => 'View milestone offer';

  @override
  String get inboxOfferNotFound => 'Offer not found';

  @override
  String get inboxOfferNotFoundMessage => 'This offer may have been deleted.';

  @override
  String inboxFirstMilestoneCharge(String price) {
    return 'You\'ll only be charged for the first milestone ($price).';
  }

  @override
  String get inboxContinueCheckout => 'Continue to checkout';

  @override
  String inboxOfferStatusBanner(String status) {
    return 'Offer status: $status.';
  }

  @override
  String get inboxOfferDetails => 'Offer details';

  @override
  String get inboxDetailPrice => 'Price';

  @override
  String get inboxDetailTime => 'Duration';

  @override
  String get inboxDetailRevisions => 'Revisions';

  @override
  String get inboxDetailExpires => 'Expires';

  @override
  String get inboxDetailRequirements => 'Requirements';

  @override
  String get inboxDetailRequirementsValue =>
      'Must be submitted before work begins';

  @override
  String get inboxIncludes => 'Includes';

  @override
  String get inboxMilestoneDetails => 'Milestone details';

  @override
  String get inboxMilestoneTooltip =>
      'The seller delivers one milestone at a time. You pay for each milestone before it starts.';

  @override
  String get inboxTotal => 'Total';

  @override
  String inboxMilestoneLine(int days, String price, int revisions) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    String _temp1 = intl.Intl.pluralLogic(
      revisions,
      locale: localeName,
      other: '$revisions revisions',
      one: '1 revision',
    );
    return '$_temp0 | $price | $_temp1';
  }

  @override
  String get inboxOpening => 'Opening conversation…';

  @override
  String get inboxOpenFailed => 'Couldn\'t open the conversation';

  @override
  String get inboxForwardTitle => 'Forward message';

  @override
  String get inboxRecentConversations => 'Recent conversations';

  @override
  String get inboxNoOtherConversations => 'No other conversations yet';

  @override
  String inboxForwardCount(int n) {
    return 'Forward ($n)';
  }

  @override
  String get inboxAddNew => 'Add new';

  @override
  String get inboxQuickEmptyTitle => 'No quick responses yet';

  @override
  String get inboxQuickEmptyMessage =>
      'Create a template to reply to buyers with a single tap.';

  @override
  String get inboxQuickSaved => 'Quick response saved';

  @override
  String get inboxQuickNewTitle => 'New quick response';

  @override
  String get inboxQuickName => 'Name';

  @override
  String get inboxQuickNameHint => 'Name your quick response';

  @override
  String get inboxQuickBody => 'Message';

  @override
  String get inboxQuickBodyHint => 'Type your message…';

  @override
  String inboxQuickTip(String token) {
    return 'Tip: type $token to automatically insert the recipient\'s name.';
  }

  @override
  String get ordersNotFoundTitle => 'Order not found';

  @override
  String get ordersNotFoundMessage =>
      'This order may have been deleted, or you don\'t have permission to view it.';

  @override
  String get ordersNotFoundAction => 'Back to orders';

  @override
  String get ordersUnknownUser => 'VietGig user';

  @override
  String get ordersAttachTitle => 'Attach files';

  @override
  String get ordersAttachCamera => 'Open camera';

  @override
  String get ordersAttachGallery => 'Open photo library';

  @override
  String get ordersAttachFile => 'Files';

  @override
  String get ordersRemoveFile => 'Remove file';

  @override
  String get ordersApply => 'Apply';

  @override
  String get ordersSend => 'Send';

  @override
  String ordersInfoDateCode(String date, String code) {
    return '$date · Order $code';
  }

  @override
  String ordersInfoExtra(String name) {
    return 'Extra: $name';
  }

  @override
  String get ordersInfoSubtotal => 'Subtotal';

  @override
  String get ordersInfoServiceFee => 'Service fee';

  @override
  String get ordersInfoTip => 'Tip';

  @override
  String get ordersInfoTotal => 'Total';

  @override
  String get ordersInfoDueDate => 'Delivery date';

  @override
  String get ordersInfoPaidWith => 'Paid with';

  @override
  String get ordersManageTitle => 'Manage orders';

  @override
  String get ordersNotifications => 'Notifications';

  @override
  String get ordersOptions => 'Options';

  @override
  String get ordersSortDue => 'Due soonest';

  @override
  String get ordersSortNewest => 'Most recent';

  @override
  String get ordersTabNeedsAction => 'Needs action';

  @override
  String get ordersTabInProgress => 'In progress';

  @override
  String get ordersTabNew => 'New';

  @override
  String get ordersTabDelivered => 'Delivered';

  @override
  String get ordersTabCompleted => 'Completed';

  @override
  String get ordersTabCancelled => 'Cancelled';

  @override
  String ordersTabWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get ordersFilterTitle => 'Sort & filter';

  @override
  String get ordersFilterReset => 'Reset';

  @override
  String get ordersFilterSortBy => 'Sort by';

  @override
  String get ordersFilterStatus => 'Status';

  @override
  String get ordersFilterAll => 'All';

  @override
  String get ordersGroupOverdue => 'Overdue';

  @override
  String get ordersGroupDue2Days => 'Due within 2 days';

  @override
  String get ordersGroupDue2To5Days => 'Due in 2–5 days';

  @override
  String get ordersGroupDueLater => 'Due in more than 5 days';

  @override
  String get ordersEmptyTitle => 'All your orders live here';

  @override
  String get ordersEmptySellerMessage =>
      'When buyers order your services, their orders will show up here.';

  @override
  String get ordersEmptyBuyerMessage =>
      'Once you order a service, you can track its progress here.';

  @override
  String get ordersEmptySellerAction => 'Manage my gigs';

  @override
  String get ordersEmptyBuyerAction => 'Explore services';

  @override
  String ordersCardMenuTitle(String code) {
    return 'Order $code';
  }

  @override
  String get ordersCardMenuOpen => 'View order details';

  @override
  String get ordersCardMenuChatBuyer => 'Message the buyer';

  @override
  String get ordersCardMenuChatSeller => 'Message the seller';

  @override
  String get ordersResolutionCenter => 'Resolution Center';

  @override
  String get ordersCopyCode => 'Copy order number';

  @override
  String ordersCodeCopied(String code) {
    return 'Order number $code copied';
  }

  @override
  String get ordersCardUser => 'User';

  @override
  String get ordersCardLoading => 'Loading…';

  @override
  String ordersCardDue(String date) {
    return 'Due $date';
  }

  @override
  String ordersCardPlaced(String date) {
    return 'Ordered $date';
  }

  @override
  String ordersDetailError(String error) {
    return 'Something went wrong: $error';
  }

  @override
  String get ordersDetailMenuUnread => 'Mark as unread';

  @override
  String get ordersDetailMenuExtra => 'Add extras';

  @override
  String get ordersDetailDeliver => 'Deliver order';

  @override
  String get ordersDetailMenuGig => 'View gig';

  @override
  String get ordersDetailMarkedUnread => 'Order marked as unread';

  @override
  String get ordersDetailPickExtra => 'Choose the extras you want to add above';

  @override
  String ordersDetailAddExtraTitle(String title) {
    return 'Add \"$title\"?';
  }

  @override
  String ordersDetailAddExtraMessage(String price) {
    return 'You\'ll pay an additional $price.';
  }

  @override
  String ordersDetailAddExtraMessageDays(String price, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'You\'ll pay an additional $price and delivery will be extended by $_temp0.';
  }

  @override
  String get ordersDetailAddExtraConfirm => 'Add';

  @override
  String ordersDetailExtraAdded(String title) {
    return '\"$title\" added to your order';
  }

  @override
  String get ordersDetailRequestAccepted => 'You accepted the request';

  @override
  String get ordersDetailRequestDeclined => 'You declined the request';

  @override
  String get ordersDetailApproveTitle => 'Ready to accept the final delivery?';

  @override
  String get ordersDetailApproveMessage =>
      'After this step, you won\'t be able to request revisions for this order.';

  @override
  String get ordersDetailCompletedSnack => 'Your order is complete!';

  @override
  String get ordersDetailRequestRevision => 'Request a revision';

  @override
  String get ordersDetailNeedMoreTime => 'I need more time to review';

  @override
  String get ordersDetailNewTag => 'NEW';

  @override
  String get ordersDetailResolutionPrefix =>
      'If you have an issue with this order, go to the ';

  @override
  String get ordersDetailRevisionSubtitle =>
      'Clearly describe what you\'d like the seller to change.';

  @override
  String get ordersDetailRevisionHint =>
      'E.g. Could you make the main color a darker blue?';

  @override
  String get ordersDetailSendRequest => 'Send request';

  @override
  String get ordersDetailRevisionSent => 'Revision request sent to the seller';

  @override
  String get ordersDetailMoreTimeTitle => 'More time to review the delivery';

  @override
  String get ordersDetailMoreTimeMessage =>
      'How many more days do you need? You can come back for more if needed – up to 5 days.';

  @override
  String ordersDetailNewReviewDeadline(String date) {
    return 'New review deadline: $date';
  }

  @override
  String get ordersDetailExtendReview => 'Extend review time';

  @override
  String ordersDetailReviewExtended(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days more days',
      one: '1 more day',
    );
    return 'Done! You have $_temp0 to review the delivery.';
  }

  @override
  String get ordersDetailRemindOn =>
      'We\'ll remind you 1 day before the due date';

  @override
  String get ordersDetailRemindOff => 'Reminder turned off';

  @override
  String get ordersDetailThanksTitle => 'Thanks for your order!';

  @override
  String get ordersDetailThanksMessage =>
      'The seller will get started right away.';

  @override
  String get ordersDetailWaitingRequirements =>
      'Waiting for the buyer\'s requirements';

  @override
  String get ordersDetailSubmitRequirements =>
      'Submit requirements to start your order';

  @override
  String get ordersDetailWaitingRequirementsMessage =>
      'The order will start once the buyer submits all the information you requested.';

  @override
  String get ordersDetailSubmitRequirementsMessage =>
      'The seller needs some information from you. The delivery time only starts once you submit the requirements.';

  @override
  String get ordersDetailLetterToBuyer => 'Message buyer';

  @override
  String get ordersDetailExtend => 'Extend';

  @override
  String get ordersDetailExtrasTitle => 'Add extras to your order';

  @override
  String get ordersDetailHide => 'Hide';

  @override
  String get ordersDetailAddMore => '+ Add more';

  @override
  String get ordersDetailAdd => '+ Add';

  @override
  String get ordersDetailCancelRequestTitle => 'Cancellation request';

  @override
  String get ordersDetailExtensionRequestTitle => 'Extension request';

  @override
  String get ordersDetailCancelRequestedByYou =>
      'You requested to cancel this order.';

  @override
  String ordersDetailCancelRequestedBy(String name) {
    return '$name requested to cancel this order.';
  }

  @override
  String ordersDetailExtensionRequestedByYou(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'You requested to extend the delivery date by $_temp0.';
  }

  @override
  String ordersDetailExtensionRequestedBy(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$name requested to extend the delivery date by $_temp0.';
  }

  @override
  String get ordersDetailExtensionLength => 'Extension';

  @override
  String get ordersDetailNewDueDate => 'New delivery date';

  @override
  String ordersDetailAwaitingResponse(String name, String date) {
    return 'Waiting for $name to respond (until $date)';
  }

  @override
  String ordersDetailRespondBefore(String date) {
    return 'Please respond before $date, otherwise the request will be accepted automatically.';
  }

  @override
  String get ordersDetailAccept => 'Accept';

  @override
  String get ordersDetailDecline => 'Decline';

  @override
  String get ordersDetailYouDelivered => 'You delivered the order';

  @override
  String get ordersDetailYourDelivery => 'Here\'s your delivery';

  @override
  String ordersDetailFileCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n files',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String ordersDetailDownloadingAll(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n files',
      one: '1 file',
    );
    return 'Downloading $_temp0…';
  }

  @override
  String get ordersDetailDownloadAll => 'Download all';

  @override
  String get ordersDetailVirusScanned => 'Virus scanned';

  @override
  String ordersDetailDownloadingFile(String name) {
    return 'Downloading \"$name\"…';
  }

  @override
  String get ordersDetailAwaitingBuyerReview =>
      'Waiting for the buyer to review the delivery.';

  @override
  String ordersDetailBuyerReviewUntil(String date) {
    return 'The buyer has until $date to review. After that, the order will be completed automatically.';
  }

  @override
  String get ordersDetailApproveDelivery => 'Approve delivery';

  @override
  String get ordersDetailNotReady => 'Not ready yet';

  @override
  String get ordersDetailReviewHint =>
      'Approve the delivery, request a revision, or ask for more time to review.';

  @override
  String ordersDetailReviewUntil(String date) {
    return 'You have until $date to approve the delivery, request a revision, or ask for more time to review. After that, the order will be marked as complete automatically.';
  }

  @override
  String get ordersDetailCompletedTitle => 'Order completed';

  @override
  String get ordersDetailCompletedMessage => 'Thank you for using VietGig.';

  @override
  String get ordersDetailBuyerReview => 'Buyer\'s review';

  @override
  String get ordersDetailMyReview => 'My review';

  @override
  String get ordersDetailNoBuyerReview =>
      'The buyer hasn\'t left a review yet.';

  @override
  String get ordersDetailShareExperience =>
      'Share your experience to help other buyers choose.';

  @override
  String get ordersDetailWriteReview => 'Write a review';

  @override
  String ordersDetailTipped(String amount, String name) {
    return 'You tipped $name $amount. Thank you!';
  }

  @override
  String get ordersDetailTipTitle => 'Great sellers deserve a tip';

  @override
  String get ordersDetailTipMessage => '100% of your tip goes to the seller.';

  @override
  String get ordersDetailSendTip => 'Leave a tip';

  @override
  String get ordersDetailCancelledTitle => 'Order cancelled';

  @override
  String get ordersDetailCancelledMessage =>
      'The amount has been refunded to your VietGig balance.';

  @override
  String get ordersDetailExpectedDelivery => 'Expected delivery';

  @override
  String get ordersDetailRemindOffAction => 'Turn off reminder';

  @override
  String get ordersDetailRemindMe => 'Remind me';

  @override
  String ordersDetailAddedToCalendar(String date) {
    return 'Due date $date added to your calendar';
  }

  @override
  String get ordersDetailAddToCalendar => 'Add to calendar';

  @override
  String get ordersDetailActivity => 'Activity';

  @override
  String get ordersCheckoutTitle => 'Upgrade';

  @override
  String get ordersCheckoutGigNotFoundTitle => 'Service not found';

  @override
  String get ordersCheckoutGigNotFoundMessage =>
      'This service may no longer be available.';

  @override
  String get ordersCheckoutExploreOther => 'Explore other services';

  @override
  String get ordersCheckoutSelectedPackage => 'Selected package';

  @override
  String ordersCheckoutDeliveryIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days-day delivery',
      one: '1-day delivery',
    );
    return '$_temp0';
  }

  @override
  String ordersCheckoutRevisions(String revisions) {
    return '$revisions revisions';
  }

  @override
  String get ordersCheckoutAddExtras => 'Add extras to your order';

  @override
  String get ordersCheckoutNoExtras => 'This service has no add-on options.';

  @override
  String ordersCheckoutEstimatedDelivery(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Estimated delivery: $days days',
      one: 'Estimated delivery: 1 day',
    );
    return '$_temp0';
  }

  @override
  String ordersCheckoutContinue(String amount) {
    return 'Continue ($amount)';
  }

  @override
  String get ordersCheckoutNoExtraTime => 'No extra time';

  @override
  String ordersCheckoutExtraDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '+$days days',
      one: '+1 day',
    );
    return '$_temp0';
  }

  @override
  String ordersCheckoutFasterDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days faster',
      one: '1 day faster',
    );
    return '$_temp0';
  }

  @override
  String get ordersCheckoutQuantity => 'Quantity';

  @override
  String get ordersAddCardTitle => 'Add a new card';

  @override
  String get ordersAddCardInvalidNumber => 'Invalid card number';

  @override
  String get ordersAddCardInvalidMonth => 'Invalid month';

  @override
  String get ordersAddCardExpired => 'This card has expired';

  @override
  String get ordersAddCardHolderPlaceholder => 'CARDHOLDER NAME';

  @override
  String get ordersAddCardNumber => 'Card number';

  @override
  String get ordersAddCardNumberRequired => 'Please enter a valid card number';

  @override
  String get ordersAddCardLastName => 'Last name';

  @override
  String get ordersAddCardFirstName => 'First name';

  @override
  String get ordersAddCardRequired => 'Required';

  @override
  String get ordersAddCardCvvHelp => '3–4 digits on the back of your card';

  @override
  String get ordersAddCardSecure =>
      'Your card details are encrypted and stored securely.';

  @override
  String get ordersAddCardPay => 'Pay';

  @override
  String get ordersReviewTitle => 'Review your order';

  @override
  String get ordersReviewMethodCard => 'Credit/debit card';

  @override
  String get ordersReviewMethodBank => 'Bank transfer';

  @override
  String get ordersReviewPromoTitle => 'Promo code';

  @override
  String get ordersReviewPromoHint => 'Enter a code, e.g. VIETGIG10';

  @override
  String get ordersReviewPromoEmpty => 'Please enter a code';

  @override
  String get ordersReviewPromoInvalid => 'This code is invalid or has expired';

  @override
  String ordersReviewPromoApplied(String code) {
    return 'Code $code applied – 10% off';
  }

  @override
  String get ordersReviewCardAdded => 'Payment card added';

  @override
  String ordersReviewPayFailed(String error) {
    return 'Payment failed: $error';
  }

  @override
  String get ordersReviewSuccessTitle => 'Great! Your order has been placed';

  @override
  String get ordersReviewSuccessNeedRequirements =>
      'Submit your requirements so the seller can start working on your order.';

  @override
  String get ordersReviewSuccessStarted =>
      'The seller will get started right away. Congratulations on your first step!';

  @override
  String get ordersReviewViewOrder => 'View order';

  @override
  String get ordersReviewCustomOffer => 'Custom offer';

  @override
  String get ordersReviewPaymentMethod => 'Payment method';

  @override
  String get ordersReviewCardSaved => 'Saved card – ready to pay';

  @override
  String get ordersReviewOrderDetails => 'Order details';

  @override
  String get ordersReviewExtras => 'Extras';

  @override
  String get ordersReviewSummary => 'Summary';

  @override
  String get ordersReviewFeeTooltip =>
      'This fee helps VietGig run the platform and provide 24/7 customer support.';

  @override
  String get ordersReviewEnterCode => 'Enter code';

  @override
  String get ordersReviewTotal => 'Total';

  @override
  String get ordersReviewEstimatedDelivery => 'Estimated delivery';

  @override
  String get ordersReviewTerms =>
      'By tapping the button below, you agree to VietGig\'s Terms of Service and Payment Policy. Funds are released to the seller only after you approve the delivery.';

  @override
  String get ordersReviewSecure => 'Your payment information is secure';

  @override
  String get ordersReviewAddPayment => 'Add payment method';

  @override
  String ordersReviewPay(String amount) {
    return 'Pay ($amount)';
  }

  @override
  String get ordersReviewProcessing => 'Processing your order…';

  @override
  String get ordersReviewDontClose => 'Please don\'t close the app.';

  @override
  String get ordersReqTitle => 'Requirements';

  @override
  String get ordersReqFallbackQuestion =>
      'Please describe your requirements for this order in detail.';

  @override
  String ordersReqSendFailed(String error) {
    return 'Couldn\'t submit requirements: $error';
  }

  @override
  String get ordersReqSent => 'Requirements submitted. Your order has started!';

  @override
  String get ordersReqAlreadyTitle => 'Requirements already submitted';

  @override
  String get ordersReqAlreadyMessage =>
      'This order doesn\'t need any more information. You can message the seller if you\'d like to add anything.';

  @override
  String get ordersReqBackToOrder => 'Back to order';

  @override
  String get ordersReqOptional => '(optional)';

  @override
  String get ordersReqConfirm =>
      'I confirm the information provided is accurate and complete. Any later changes require the seller\'s agreement and may incur extra costs.';

  @override
  String get ordersReqSubmit => 'Submit requirements';

  @override
  String get ordersReqHint => 'Please fill in the required information';

  @override
  String get ordersReqAttachMore => 'Attach another file';

  @override
  String get ordersDeliverTitle => 'Deliver order';

  @override
  String get ordersDeliverNoQuickResponses =>
      'You don\'t have any quick responses yet';

  @override
  String get ordersDeliverQuickResponses => 'Quick responses';

  @override
  String ordersDeliverSendError(String error) {
    return 'Couldn\'t send the delivery: $error';
  }

  @override
  String get ordersDeliverSent =>
      'Delivery sent to the buyer. They have 3 days to review it.';

  @override
  String get ordersDeliverSellerOnly =>
      'Only the seller can deliver this order';

  @override
  String get ordersDeliverUnavailable =>
      'This order can\'t be delivered right now';

  @override
  String ordersDeliverCurrentStatus(String status) {
    return 'Current status: $status.';
  }

  @override
  String get ordersDeliverBackToOrder => 'Back to order';

  @override
  String ordersDeliverMessageTo(String name) {
    return 'Message to $name';
  }

  @override
  String get ordersDeliverInsertQuick => 'Insert a quick response';

  @override
  String get ordersDeliverMessageHint =>
      'Describe what you\'re delivering, how to use the files, and add a thank-you note for the buyer (at least 10 characters).';

  @override
  String get ordersDeliverAttachments => 'Attachments';

  @override
  String get ordersDeliverAttachMore => 'Attach more files';

  @override
  String get ordersDeliverFileNote =>
      'Up to 5 GB per file. The buyer will be notified as soon as you send the delivery.';

  @override
  String get ordersDeliverUploading => 'Uploading files…';

  @override
  String get ordersDeliverSubmit => 'Send delivery';

  @override
  String ordersResolutionError(String error) {
    return 'Something went wrong: $error';
  }

  @override
  String ordersResolutionUpdateChat(String code, String text) {
    return '[Update request for order $code] $text';
  }

  @override
  String ordersResolutionUpdateSent(String name) {
    return 'Update request sent to $name';
  }

  @override
  String get ordersResolutionTitle => 'Resolution Center';

  @override
  String get ordersResolutionUpdateTitle => 'Request an update';

  @override
  String get ordersResolutionExtendTitle => 'Extend delivery time';

  @override
  String get ordersResolutionCancelTitle => 'Cancel order';

  @override
  String get ordersResolutionSupportPrompt => 'Can\'t find what you need? ';

  @override
  String get ordersResolutionSupportLink => 'Contact Customer Support';

  @override
  String get ordersResolutionOrderInfo => 'Order details';

  @override
  String get ordersResolutionDisputeTitle => 'Dispute in progress';

  @override
  String get ordersResolutionDisputeBody =>
      'This order has a request awaiting a response. Please wait for the other party to respond before opening a new request. If you run into any issues, VietGig Support is always here to help.';

  @override
  String get ordersResolutionPendingCancel => 'Cancellation request';

  @override
  String ordersResolutionPendingExtend(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days-day extension request',
      one: '1-day extension request',
    );
    return '$_temp0';
  }

  @override
  String ordersResolutionPendingLine(String request, String time) {
    return '$request · sent $time';
  }

  @override
  String get ordersResolutionCompleted => 'Order completed';

  @override
  String get ordersResolutionCancelled => 'Order cancelled';

  @override
  String get ordersResolutionEndedBody =>
      'This order has ended, so new requests can\'t be opened. If you need help, please contact us.';

  @override
  String get ordersResolutionWelcome => 'Welcome!';

  @override
  String get ordersResolutionWelcomeBody =>
      'You can resolve issues with your order here.';

  @override
  String get ordersResolutionHowHelp => 'How can we help?';

  @override
  String get ordersResolutionMenuUpdate => 'Request a progress update';

  @override
  String get ordersResolutionMenuMessageBuyer => 'Message the buyer';

  @override
  String get ordersResolutionUpdateHeading => 'Send a message to the seller';

  @override
  String ordersResolutionUpdateBody(String name) {
    return 'Ask $name about the order\'s progress. The message will be sent to your inbox.';
  }

  @override
  String get ordersResolutionUpdateHint =>
      'E.g. Hi, I\'d like to check how the order is coming along.';

  @override
  String get ordersResolutionSendRequest => 'Send request';

  @override
  String get ordersResolutionExtendHeading => 'How many more days do you need?';

  @override
  String get ordersResolutionExtendDays => 'Extra days';

  @override
  String get ordersResolutionCurrentDue => 'Current delivery date';

  @override
  String get ordersResolutionNewDue => 'New delivery date';

  @override
  String get ordersResolutionMessage => 'Message';

  @override
  String get ordersResolutionExtendHintSeller =>
      'E.g. I need a bit more time to polish the details for you. Thanks for your understanding!';

  @override
  String get ordersResolutionExtendHintBuyer =>
      'E.g. I need more time to prepare the materials for you.';

  @override
  String get ordersResolutionExtendNoteSeller =>
      'The buyer has 2 days to respond. If they don\'t, the request will be accepted automatically.';

  @override
  String get ordersResolutionExtendNoteBuyer =>
      'The seller has 2 days to respond. If they don\'t, the request will be accepted automatically.';

  @override
  String get ordersResolutionExtendSubmit => 'Send extension request';

  @override
  String ordersResolutionExtendSent(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Request to extend by $days days sent',
      one: 'Request to extend by 1 day sent',
    );
    return '$_temp0';
  }

  @override
  String ordersResolutionRefundNote(String amount) {
    return 'If the seller agrees, $amount will be refunded to your VietGig balance.';
  }

  @override
  String get ordersResolutionFeedbackHeading => 'Feedback for the seller';

  @override
  String get ordersResolutionCancelHint =>
      'Let the seller know why you want to cancel (optional)';

  @override
  String get ordersResolutionReasonHeading => 'Reason for cancelling';

  @override
  String get ordersResolutionReasonNote => 'Only VietGig can see this reason.';

  @override
  String get ordersResolutionReasonNoResponse => 'Seller isn\'t responding';

  @override
  String get ordersResolutionReasonQuality => 'Poor quality';

  @override
  String get ordersResolutionReasonWrongItem =>
      'Didn\'t receive what I ordered';

  @override
  String get ordersResolutionReasonTooMuchGuidance =>
      'Seller needs too much guidance';

  @override
  String get ordersResolutionReasonLanguage => 'Language barrier';

  @override
  String get ordersResolutionReasonOther => 'Other';

  @override
  String get ordersResolutionRateSeller =>
      'Rate your experience with the seller';

  @override
  String get ordersResolutionCancelSubmit => 'Send cancellation request';

  @override
  String ordersResolutionSellerRatingNote(int rating) {
    return '(Seller rating: $rating/5)';
  }

  @override
  String get ordersResolutionCancelSent =>
      'Cancellation request sent. The seller has up to 2 days to respond.';

  @override
  String get ordersRateThanksReview => 'Thanks for your review!';

  @override
  String ordersRateSubmitError(String error) {
    return 'Couldn\'t submit your review: $error';
  }

  @override
  String get ordersRateCustomTitle => 'Custom amount (VND)';

  @override
  String get ordersRateCustomHint => 'E.g. 70000';

  @override
  String get ordersRateCustomHelper => 'Minimum 25,000 ₫';

  @override
  String get ordersRateCustomError => 'The minimum amount is 25,000 ₫';

  @override
  String ordersRateTipError(String error) {
    return 'Couldn\'t send the tip: $error';
  }

  @override
  String ordersRateTipSent(String amount, String name) {
    return 'You sent a $amount tip to $name. Thank you!';
  }

  @override
  String get ordersRateLater => 'Later';

  @override
  String get ordersRateSkip => 'Skip';

  @override
  String get ordersRateBuyerOnly => 'Only the buyer can review this order';

  @override
  String get ordersRateNotYet => 'Can\'t review yet';

  @override
  String get ordersRateNotYetBody =>
      'You can leave a review once you\'ve approved the delivery and the order is complete.';

  @override
  String get ordersRateContinue => 'Continue';

  @override
  String get ordersRateStar1 => 'Poor';

  @override
  String get ordersRateStar2 => 'Fair';

  @override
  String get ordersRateStar3 => 'Good';

  @override
  String get ordersRateStar4 => 'Very good';

  @override
  String get ordersRateStar5 => 'Excellent';

  @override
  String get ordersRatePositiveDetail => 'Attention to detail';

  @override
  String get ordersRatePositiveCreative => 'Creative';

  @override
  String get ordersRatePositiveAesthetic => 'Great aesthetics';

  @override
  String get ordersRatePositiveProfessional => 'Professional';

  @override
  String get ordersRatePositiveExceeded => 'Exceeded expectations';

  @override
  String get ordersRatePositiveOnBrand => 'On brand';

  @override
  String get ordersRateNegativeLate => 'Behind schedule';

  @override
  String get ordersRateNegativeDetail => 'Lacked detail';

  @override
  String get ordersRateNegativeOffBrief => 'Didn\'t match the brief';

  @override
  String get ordersRateNegativeCommunication => 'Poor communication';

  @override
  String get ordersRateNegativeQuality => 'Quality not up to par';

  @override
  String get ordersRateNegativeRevisions => 'Needed many revisions';

  @override
  String get ordersRateQualityTitle =>
      'How would you rate the quality of the delivery?';

  @override
  String get ordersRateGoodTitle => 'Awesome! What made it great?';

  @override
  String get ordersRateBadTitle => 'Sorry to hear that! What went wrong?';

  @override
  String get ordersRateValueTitle =>
      'How would you rate the value of the delivery?';

  @override
  String ordersRateValueBody(int days, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'The project took $days days and cost $amount.',
      one: 'The project took 1 day and cost $amount.',
    );
    return '$_temp0';
  }

  @override
  String get ordersRateTopicsDefault =>
      'quality, communication and response time';

  @override
  String get ordersRateWriteTitle => 'Write a public review';

  @override
  String ordersRateWriteBody(String topics) {
    return 'Share details about your experience working with the seller and the final result, covering topics such as: $topics.';
  }

  @override
  String get ordersRateTextHint =>
      'Write at least 10 characters. Let other buyers know your honest impressions.';

  @override
  String get ordersRateShareTitle => 'Share work sample publicly';

  @override
  String get ordersRateShareBody =>
      'The work sample may be shown with your review on the seller\'s page. I confirm the sample contains no personal or sensitive information.';

  @override
  String get ordersRateSubmit => 'Submit review';

  @override
  String get ordersRatePublicNote =>
      'The order price and your profile information will be shown publicly with your review.';

  @override
  String get ordersRateThanks => 'Thank you!';

  @override
  String ordersRateTipped(String amount, String name) {
    return 'You sent a $amount tip to $name.';
  }

  @override
  String ordersRateTipPrompt(String name) {
    return 'You can send a tip to thank $name. 100% of the tip goes to the seller.';
  }

  @override
  String get ordersRateCustom => 'Custom';

  @override
  String get ordersRateSendTip => 'Send tip';

  @override
  String ordersRateSendTipAmount(String amount) {
    return 'Send $amount tip';
  }

  @override
  String get ordersRateNoFee => 'You won\'t be charged a service fee on tips.';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileCurrency => 'Currency';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileSecurity => 'Security';

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileSupportCenter => 'Help center';

  @override
  String get profileSendFeedback => 'Send feedback';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileThemeSystem => 'System default';

  @override
  String get profileThemeSystemShort => 'System';

  @override
  String get profileFeedbackIdea => 'Share an idea';

  @override
  String get profileFeedbackIdeaHint =>
      'Suggest a new feature or an improvement';

  @override
  String get profileFeedbackBug => 'Report a bug';

  @override
  String get profileFeedbackBugHint => 'Something isn\'t working as expected';

  @override
  String get profileSwitchedToSeller => 'Switched to selling mode';

  @override
  String get profileSwitchedToBuyer => 'Switched to buying mode';

  @override
  String get profileSwitchModeFailed =>
      'Couldn\'t switch modes. Please try again.';

  @override
  String get profileBecomeSellerTitle => 'Become a seller?';

  @override
  String get profileBecomeSellerMessage =>
      'You can publish services, take orders and earn money on VietGig. You can switch back to buying mode at any time.';

  @override
  String get profileBecomeSellerConfirm => 'Start selling';

  @override
  String get profileSellerMode => 'Selling mode';

  @override
  String get profileSellerModeOn => 'Manage your services and sales';

  @override
  String get profileSellerModeOff => 'Turn on to start selling services';

  @override
  String get profileMyVietGig => 'My VietGig';

  @override
  String get profileEarnings => 'Earnings';

  @override
  String get profileOfferTemplates => 'Offer templates';

  @override
  String get profileBuyerBriefs => 'Buyer briefs';

  @override
  String get profileShareGigs => 'Share services';

  @override
  String get profileMyProfile => 'My profile';

  @override
  String get profileAvailability => 'Availability';

  @override
  String get profileSavedLists => 'Saved lists';

  @override
  String get profileMyInterests => 'My interests';

  @override
  String get profileBrowsingHistory => 'Browsing history';

  @override
  String get profileInviteFriends => 'Invite friends';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileSupport => 'Support';

  @override
  String get profileBecomeSeller => 'Become a seller';

  @override
  String get profileNeedActivation => 'Please activate your account';

  @override
  String get profileActivateAccount => 'Activate account';

  @override
  String get profileGuest => 'Guest';

  @override
  String get profileGuestWelcome => 'Welcome to VietGig!';

  @override
  String get profileJoin => 'Join VietGig';

  @override
  String get profileGeneral => 'General';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String get profileSignOutTitle => 'Sign out?';

  @override
  String get profileSignOutMessage =>
      'You\'ll need to sign in again to keep buying and selling services.';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSignOutFailed => 'Couldn\'t sign out. Please try again.';

  @override
  String get profileAccountInfo => 'Account information';

  @override
  String get profileUsername => 'Username';

  @override
  String get profileFullName => 'Full name';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileVerified => 'Verified';

  @override
  String get profileUnverified => 'Unverified';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get profilePersonalBalance => 'Personal balance';

  @override
  String get profileManageAccount => 'Account management';

  @override
  String get profileDeactivateAndDelete => 'Deactivate & delete account';

  @override
  String get profilePrivacy => 'Privacy';

  @override
  String get profilePrivacySearchVisible => 'Show my profile in search engines';

  @override
  String get profilePrivacyPersonalized =>
      'Allow personalized service recommendations';

  @override
  String get profilePrivacyShareUsage => 'Share anonymous usage data';

  @override
  String get profilePrivacySaved => 'Privacy settings saved';

  @override
  String get profileOnlineStatus => 'Online status';

  @override
  String get profileOnlineStatusHint =>
      'You\'ll appear online while the app is open.';

  @override
  String get profileOnlineShown => 'You now appear online';

  @override
  String get profileOnlineHidden => 'Online status hidden';

  @override
  String get profileResetLinkSent =>
      'We\'ve sent a password reset link to your email';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileChangePasswordHint => 'Get a password reset link by email';

  @override
  String get profileTwoFactor => 'Two-factor authentication';

  @override
  String get profileTwoFactorHint =>
      'Require a verification code when signing in on a new device';

  @override
  String get profileTwoFactorOn => 'Two-factor authentication turned on';

  @override
  String get profileTwoFactorOff => 'Two-factor authentication turned off';

  @override
  String profileLanguageChanged(String language) {
    return 'Language changed to $language';
  }

  @override
  String get profilePushTab => 'Push notifications';

  @override
  String get profileEmailTab => 'Email';

  @override
  String get profileSendTestPush => 'Send test notification';

  @override
  String get profileTestPushSent => 'Test notification sent to your device';

  @override
  String get profileSendTestEmail => 'Send test email';

  @override
  String get profileTestEmailSent => 'Test email sent to your inbox';

  @override
  String get profileCurrencyVnd => 'Vietnamese dong';

  @override
  String get profileCurrencyUsd => 'US dollar';

  @override
  String get profileCurrencyEur => 'Euro';

  @override
  String get profileCurrencyGbp => 'British pound';

  @override
  String get profileCurrencyJpy => 'Japanese yen';

  @override
  String get profileCurrencyKrw => 'South Korean won';

  @override
  String get profileCurrencyCny => 'Chinese yuan';

  @override
  String get profileCurrencySgd => 'Singapore dollar';

  @override
  String get profileCurrencyThb => 'Thai baht';

  @override
  String get profileCurrencyAud => 'Australian dollar';

  @override
  String get profileCurrencyCad => 'Canadian dollar';

  @override
  String profileCurrencyChanged(String currency) {
    return 'Display currency changed to $currency';
  }

  @override
  String get profileAppearanceSystemNote =>
      'If you choose \"System\", VietGig will automatically match your device settings.';

  @override
  String get profileBalanceHelpEarningsTitle => 'Earnings';

  @override
  String get profileBalanceHelpEarnings =>
      'Money you earn from your services. You can withdraw it to your bank or use it to buy services.';

  @override
  String get profileBalanceHelpRefundTitle => 'Balance from cancelled orders';

  @override
  String get profileBalanceHelpRefund =>
      'Refunds from cancelled orders, which you can use for your next purchase.';

  @override
  String get profileBalanceHelpCreditsTitle => 'Credits';

  @override
  String get profileBalanceHelpCredits =>
      'Credits can be applied when you pay for orders. Check their expiry date so you don\'t lose them.';

  @override
  String get profileBalanceHelpPayTitle => 'Paying with your balance';

  @override
  String get profileBalanceHelpPay =>
      'When you have a balance, you can use your funds and credits as the main payment method for new orders.';

  @override
  String get profileBalanceExplain => 'Explain';

  @override
  String get profileBalanceVietGig => 'VietGig balance';

  @override
  String get profileBalanceFromCancelled => 'From cancelled orders';

  @override
  String get profileBalanceCreditsVietGig => 'VietGig Credits';

  @override
  String get profileBalanceCredits => 'Credits';

  @override
  String get profileBalanceMoreCredits =>
      'Want more credits? Refer your friends and get great rewards!';

  @override
  String get profileBalanceGetCredits => 'Get VietGig Credits';

  @override
  String get profileReasonEmails => 'I want to unsubscribe from VietGig emails';

  @override
  String get profileReasonUsername => 'I want to change my username';

  @override
  String get profileReasonOtherAccount => 'I have another VietGig account';

  @override
  String get profileReasonNotFound => 'I couldn\'t find what I need';

  @override
  String get profileReasonComplex => 'VietGig is complicated or hard to use';

  @override
  String get profileReasonBadSeller => 'I had a bad experience with a seller';

  @override
  String get profileReasonPolicy => 'I\'m unhappy with VietGig\'s policies';

  @override
  String get profileReasonOther => 'Other';

  @override
  String get profileDeactivateConfirmTitle => 'Deactivate your account?';

  @override
  String get profileDeactivateConfirmMessage =>
      'Your profile will be hidden and any active orders will be cancelled. You can reactivate by signing in again.';

  @override
  String get profileDeactivateConfirm => 'Deactivate';

  @override
  String get profileDeleteConfirmTitle => 'Permanently delete your account?';

  @override
  String get profileDeleteConfirmMessage => 'This action cannot be undone.';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileActionNotAllowed => 'You can\'t do this right now';

  @override
  String get profileGenericError => 'Something went wrong. Please try again.';

  @override
  String get profileDeactivateAccount => 'Deactivate account';

  @override
  String get profileContinue => 'Continue';

  @override
  String get profileContinueDelete => 'Continue to delete account';

  @override
  String get profileDeactivateTitle => 'Deactivate & delete';

  @override
  String get profileDeactivateHeading =>
      'Deactivate or delete your VietGig account';

  @override
  String get profileDeactivateIntro =>
      'If you want to take a break, deactivate your account. If you want to permanently remove all your data from VietGig, choose to delete your account.';

  @override
  String get profileDeactivateDescription =>
      'Your profile won\'t be visible on VietGig. Any active orders will be cancelled.';

  @override
  String get profileDeleteDescription =>
      'Deleting your account is permanent and can\'t be reversed. You won\'t be able to recover files or information from your VietGig orders.';

  @override
  String get profileDeleteWhatHappens =>
      'What happens when you delete your account?';

  @override
  String get profileDeletePermanentNote =>
      'Deletion is permanent and cannot be undone. It may take up to 30 days to complete.';

  @override
  String get profileDeleteBulletUsername =>
      'The username linked to this account can\'t be reused for a new account.';

  @override
  String get profileDeleteBulletData =>
      'All your messages, orders, reviews and saved lists will be deleted.';

  @override
  String get profileDeleteBulletBalance =>
      'Any unused balance and credits will be forfeited.';

  @override
  String get profileDeleteBulletReview =>
      'We recommend reviewing your orders and downloading any files you need before deleting.';

  @override
  String get profileLeavingBecause => 'I\'m leaving because';

  @override
  String get profileTellUsMore => 'Tell us more (optional)';

  @override
  String get profileTellUsMoreHint => 'Help us do better...';

  @override
  String get profileSpokenVietnamese => 'Vietnamese';

  @override
  String get profileSpokenEnglish => 'English';

  @override
  String get profileSpokenChinese => 'Chinese';

  @override
  String get profileSpokenJapanese => 'Japanese';

  @override
  String get profileSpokenKorean => 'Korean';

  @override
  String get profileSpokenFrench => 'French';

  @override
  String get profileSkillEmpty => 'Enter a skill name';

  @override
  String get profileSkillDuplicate => 'You\'ve already added this skill';

  @override
  String profileSkillMax(int max) {
    return 'Up to $max skills';
  }

  @override
  String get profileNameTooShort => 'Name must be at least 2 characters';

  @override
  String get profileLanguageRequired => 'Please select at least one language';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileSaveFailed =>
      'Couldn\'t save your profile. Please try again.';

  @override
  String get profileChangeAvatar => 'Change profile photo';

  @override
  String get profileAvatarUploadSoon =>
      'Photo upload will be available once the server is connected';

  @override
  String get profileNameHint => 'e.g. Nguyen Minh Anh';

  @override
  String get profileHeadline => 'Headline';

  @override
  String get profileHeadlineHint => 'e.g. Online fashion store owner';

  @override
  String get profileBio => 'About you';

  @override
  String get profileBioHint =>
      'Share a bit about yourself, your work and what you\'re looking for...';

  @override
  String get profileSkills => 'Skills';

  @override
  String get profileSkillHint => 'e.g. Figma, Copywriting';

  @override
  String get profileAddSkill => 'Add';

  @override
  String get profileNoSkills => 'No skills added yet.';

  @override
  String get profileSaveChanges => 'Save changes';

  @override
  String get profileAreaNotifications => 'Notifications';

  @override
  String get profileAreaInbox => 'Inbox';

  @override
  String get profileAreaSearch => 'Finding services';

  @override
  String get profileAreaPayments => 'Payments';

  @override
  String get profileAreaOrders => 'Order management';

  @override
  String get profileAreaOther => 'Other';

  @override
  String get profileAttachFile => 'Attach file';

  @override
  String get profileAttachScreenshot => 'Screenshot';

  @override
  String get profileAttachDocument => 'Document';

  @override
  String get profileFeedbackThanksBug => 'Thanks for reporting the bug';

  @override
  String get profileFeedbackThanksIdea => 'Thanks for sharing your idea';

  @override
  String get profileFeedbackThanksBugMessage =>
      'Our engineering team will look into it and fix it as soon as possible.';

  @override
  String get profileFeedbackThanksIdeaMessage =>
      'Your feedback helps make VietGig better for everyone.';

  @override
  String get profileFeedbackSendFailed => 'Couldn\'t send. Please try again.';

  @override
  String get profileFeedbackAreaBug => 'Where did the bug happen?';

  @override
  String get profileFeedbackAreaIdea => 'Which area is your idea about?';

  @override
  String get profileFeedbackAreaRequired => 'Please select an area';

  @override
  String get profileFeedbackDescribeBug => 'Describe the bug you ran into';

  @override
  String get profileFeedbackDescribeIdea => 'Tell us about your idea';

  @override
  String get profileFeedbackBugHintText =>
      'What did you do, what happened, and what did you expect?';

  @override
  String get profileFeedbackIdeaHintText =>
      'Is your idea a new feature or a change to an existing one? How would it improve the experience?';

  @override
  String profileFeedbackMinChars(int n) {
    return 'Please enter at least $n characters';
  }

  @override
  String get profileRemoveFile => 'Remove file';

  @override
  String get profileFeedbackCanContact =>
      'May we contact you if we have any questions?';

  @override
  String get profileFeedbackContactYes => 'Yes, I\'m happy to chat';

  @override
  String get profileFeedbackContactNo => 'No, not right now';

  @override
  String get profileFeedbackChoiceRequired => 'Please choose an option';

  @override
  String get profileFeedbackSubmit => 'Send';

  @override
  String get profileShareVia => 'Share via';

  @override
  String get profileShareSms => 'SMS';

  @override
  String profileShareLinkCopied(String app) {
    return 'Link copied – paste it into $app to send to your friends';
  }

  @override
  String get profileInviteHeadline => 'Share & earn up to 2,500,000 ₫';

  @override
  String get profileInviteBody =>
      'Give your friends 10% off their first order, and get 10% of their order value as credits.';

  @override
  String get profileReferralCode => 'Your referral code';

  @override
  String get profileCodeCopied => 'Referral code copied';

  @override
  String get profileCopy => 'Copy';

  @override
  String get profileInviteLinkCopied => 'Invite link copied';

  @override
  String get profileCopyLink => 'Copy link';

  @override
  String get profileShare => 'Share';

  @override
  String get profileHowItWorks => 'How it works';

  @override
  String get profileInviteStep1Title => 'Send an invite';

  @override
  String get profileInviteStep1 =>
      'Share your referral code or link with friends.';

  @override
  String get profileInviteStep2Title => 'Your friend places their first order';

  @override
  String get profileInviteStep2 =>
      'They get 10% off their first order on VietGig.';

  @override
  String get profileInviteStep3Title => 'You earn credits';

  @override
  String get profileInviteStep3 =>
      'Get 10% of the order value, up to 2,500,000 ₫ over 12 months.';

  @override
  String get profileGotIt => 'Got it';

  @override
  String get profilePushEnabled => 'Push notifications turned on';

  @override
  String get profileMarkedAllRead => 'All notifications marked as read';

  @override
  String get profileMarkAllRead => 'Mark all as read';

  @override
  String get profileNotifEmptyTitle => 'Stay in the loop';

  @override
  String get profileNotifEmptyMessage =>
      'Turn on push notifications so you never miss messages, order updates and offers.';

  @override
  String get profileEnablePush => 'Turn on push notifications';

  @override
  String get profileNotifToday => 'TODAY';

  @override
  String get profileNotifEarlier => 'EARLIER';

  @override
  String get profileNotifDeleted => 'Notification deleted';

  @override
  String get profileAccountNotice => 'Account notice';

  @override
  String get profileAccountNoticeUnverified =>
      'We\'ve sent you a confirmation email. Check your inbox and activate your account to unlock all features.';

  @override
  String get profileAccountNoticeComplete =>
      'A complete profile helps sellers understand you better and respond faster.';

  @override
  String get profileActivateEmailLink => 'Activate email →';

  @override
  String get profileUpdateProfileLink => 'Update profile →';

  @override
  String get profileFaq => 'Frequently asked questions';

  @override
  String get profileFaqOrderQ => 'How do I order a service?';

  @override
  String get profileFaqOrderA =>
      'Find the right service, pick a package, tap \"Continue\" and pay. Then submit your requirements so the seller can get started.';

  @override
  String get profileFaqSafeQ => 'Is paying on VietGig safe?';

  @override
  String get profileFaqSafeA =>
      'VietGig holds your payment securely and only releases it to the seller once you accept the delivery.';

  @override
  String get profileFaqCancelQ => 'Can I cancel an order?';

  @override
  String get profileFaqCancelA =>
      'You can request a cancellation from the order\'s Resolution Center. Refunds go to your VietGig balance.';

  @override
  String get profileFaqSellerQ => 'How do I become a seller?';

  @override
  String get profileFaqSellerA =>
      'Go to the Account tab, turn on \"Selling mode\" and create your first service.';

  @override
  String get profileFaqPayoutQ => 'When do I get paid for my sales?';

  @override
  String get profileFaqPayoutA =>
      'Earnings become available for withdrawal 7 days after the order is completed.';

  @override
  String get profileFaqPasswordQ => 'What if I forget my password?';

  @override
  String get profileFaqPasswordA =>
      'On the Sign in screen, tap \"Forgot password?\" and enter your email to receive a reset link.';

  @override
  String get profileContactUs => 'Contact us';

  @override
  String get profileSupportEmail => 'Support email';

  @override
  String profileSupportEmailHint(String email) {
    return '$email · replies within 24 hours';
  }

  @override
  String get profileSupportEmailCopied => 'Support email address copied';

  @override
  String get profileHotline => 'Hotline';

  @override
  String profileHotlineHint(String phone) {
    return '$phone · 8:00 AM – 10:00 PM daily';
  }

  @override
  String get profileHotlineCopied => 'Hotline number copied';

  @override
  String get profileSupportRequest => 'Submit a support request';

  @override
  String get profileSupportRequestHint =>
      'Describe the issue and we\'ll get back to you';

  @override
  String get profileSupportRequestSignIn => 'Sign in to submit a request';

  @override
  String get profileNewEmailRequired => 'Please enter a new email';

  @override
  String get profileEmailInvalid => 'Invalid email address';

  @override
  String get profileEmailMustDiffer =>
      'The new email must be different from your current one';

  @override
  String get profileEmailUpdated =>
      'Your email has been updated and a confirmation email has been sent.';

  @override
  String get profileUpdateEmailTitle => 'Update email address';

  @override
  String get profileUpdateEmailIntro =>
      'We\'ll send a confirmation email to your new address.';

  @override
  String get profileCurrentEmail => 'Current email';

  @override
  String get profileNewEmail => 'New email';

  @override
  String get profileEmailHint => 'example@email.com';

  @override
  String get profileUpdateEmailSubmit => 'Update & send';

  @override
  String get savedHistoryTitle => 'Browsing history';

  @override
  String get savedHistoryClearTitle => 'Clear all browsing history?';

  @override
  String get savedHistoryClearMessage =>
      'Recently viewed services will be removed from your account.';

  @override
  String get savedClearAll => 'Clear all';

  @override
  String get savedHistoryCleared => 'Browsing history cleared';

  @override
  String get savedEdit => 'Edit';

  @override
  String get savedHistoryEmptyTitle => 'No viewed services yet';

  @override
  String get savedHistoryEmptyMessage =>
      'Services you view will appear here so you can easily get back to them.';

  @override
  String get savedExploreVietGig => 'Explore VietGig';

  @override
  String get savedHistoryRecent => 'Recently viewed services';

  @override
  String get savedHistoryRemoved => 'Removed from browsing history';

  @override
  String get savedNameRequired => 'Please enter a list name';

  @override
  String get savedListsTitle => 'My lists';

  @override
  String get savedCreateList => '+ Create list';

  @override
  String savedListExists(String name) {
    return 'You already have a list named \"$name\"';
  }

  @override
  String savedListCreated(String name) {
    return 'List \"$name\" created';
  }

  @override
  String get savedListsEmptyTitle => 'Save the services you love';

  @override
  String get savedListsEmptyMessage =>
      'Organize your favorite services and sellers into your own lists.';

  @override
  String get savedPublicTitle => 'Public list';

  @override
  String get savedPublicSubtitle => 'Anyone with the link can view it';

  @override
  String get savedShare => 'Share';

  @override
  String get savedRename => 'Rename';

  @override
  String get savedDeleteList => 'Delete list';

  @override
  String get savedMakePublicTitle => 'Make list public?';

  @override
  String get savedMakePublicMessage =>
      'This list is private. Make it public so people with the link can view it.';

  @override
  String get savedMakePublicConfirm => 'Make public & share';

  @override
  String get savedRenameTitle => 'Rename list';

  @override
  String savedRenamed(String name) {
    return 'Renamed to \"$name\"';
  }

  @override
  String get savedDeleteTitle => 'Delete this list?';

  @override
  String savedDeleteMessage(String name) {
    return 'Services and sellers in \"$name\" will be removed from the list. This can\'t be undone.';
  }

  @override
  String savedListDeleted(String name) {
    return 'List \"$name\" deleted';
  }

  @override
  String savedRemovedFrom(String name) {
    return 'Removed from \"$name\"';
  }

  @override
  String get savedNotFoundTitle => 'List not found';

  @override
  String get savedNotFoundMessage => 'This list may have been deleted.';

  @override
  String get savedBackToLists => 'Back to my lists';

  @override
  String savedTabGigs(int n) {
    return 'Services ($n)';
  }

  @override
  String savedTabSellers(int n) {
    return 'Sellers ($n)';
  }

  @override
  String get savedOptions => 'Options';

  @override
  String savedCreatedBy(String name) {
    return 'Created by $name';
  }

  @override
  String get savedCreatedByYou => 'you';

  @override
  String get savedNoGigsTitle => 'No services yet';

  @override
  String get savedNoGigsMessage =>
      'Tap the heart icon on a service to save it to this list.';

  @override
  String get savedExploreGigs => 'Explore services';

  @override
  String get savedUnsave => 'Unsave';

  @override
  String get savedNoSellersTitle => 'No sellers yet';

  @override
  String get savedNoSellersMessage =>
      'Tap \"Save\" on a seller\'s profile to add them to this list.';

  @override
  String get searchCategoryNotFound => 'Category not found';

  @override
  String searchCategoryIntro(String subtitle) {
    return 'Hire professional freelancers for $subtitle and more.';
  }

  @override
  String searchServiceCount(String count) {
    return '$count services';
  }

  @override
  String get searchFeatured => 'Featured services';

  @override
  String get searchNoGigsTitle => 'No services yet';

  @override
  String get searchNoGigsMessage =>
      'This category doesn\'t have any services yet. Check back soon!';

  @override
  String get searchTabCategories => 'Categories';

  @override
  String get searchTabInterests => 'Interests';

  @override
  String get searchInterestsGuestTitle => 'Explore by interest';

  @override
  String get searchInterestsGuestMessage =>
      'Sign in to choose your interests and get service recommendations tailored to you.';

  @override
  String get searchInterestsLoadError => 'Couldn\'t load your interests';

  @override
  String get searchYourInterests => 'Your interests';

  @override
  String get searchEdit => 'Edit';

  @override
  String get searchInterestsHint =>
      'Choose interests to discover more relevant services.';

  @override
  String get searchChooseInterests => 'Choose interests';

  @override
  String get searchYouMayLike => 'You might also like';

  @override
  String get searchAddInterest => 'Add to interests';

  @override
  String searchInterestAdded(String name) {
    return 'Added \"$name\" to your interests';
  }

  @override
  String get searchInterestsSaved => 'Your interests have been saved';

  @override
  String searchSaveFailed(String error) {
    return 'Couldn\'t save: $error';
  }

  @override
  String get searchDeselectAll => 'Clear';

  @override
  String get searchInterestsIntro =>
      'Choose the fields you\'re interested in and we\'ll recommend more relevant services.';

  @override
  String searchInterestsSelected(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n interests selected',
      one: '1 interest selected',
    );
    return '$_temp0';
  }

  @override
  String get searchSellersHint => 'Search for sellers';

  @override
  String get searchTabGigs => 'Services';

  @override
  String get searchTabSellers => 'Sellers';

  @override
  String get searchSuggestions => 'Suggestions';

  @override
  String searchForQuery(String query) {
    return 'Search for \"$query\"';
  }

  @override
  String get searchFillField => 'Fill in search box';

  @override
  String get searchHistory => 'Search history';

  @override
  String get searchClearHistory => 'Clear history';

  @override
  String get searchKeywordHint =>
      'Try keywords like \"logo\", \"website\", \"video editing\"…';

  @override
  String get searchRecentlyViewed => 'Recently viewed services';

  @override
  String get searchManage => 'Manage';

  @override
  String get searchSellersLoadError => 'Couldn\'t load sellers';

  @override
  String get searchSellerNotFound => 'No sellers found';

  @override
  String searchSellerNoMatch(String query) {
    return 'No sellers match \"$query\".';
  }

  @override
  String get searchDeliveryTime => 'Delivery time';

  @override
  String get searchNoStyles => 'No styles available for these results';

  @override
  String get searchStyle => 'Style';

  @override
  String get searchAllStyles => 'All styles';

  @override
  String get searchAllServices => 'All services';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get searchNoResultsFiltered =>
      'Try adjusting or clearing your filters to see more services.';

  @override
  String get searchNoResultsHint =>
      'Try a different keyword or browse by category.';

  @override
  String get searchClearFilters => 'Clear filters';

  @override
  String get searchBrowseCategories => 'Browse categories';

  @override
  String get searchRelated => 'Related searches';

  @override
  String get searchChipAll => 'All';

  @override
  String searchChipAllCount(int n) {
    return 'All ($n)';
  }

  @override
  String get searchChipCategory => 'Category';

  @override
  String get searchChipIncludes => 'Service includes';

  @override
  String get searchChipDelivery => 'Delivery';

  @override
  String get searchSellerLevel => 'Seller level';

  @override
  String get searchChipBudget => 'Budget';

  @override
  String get searchShopBy => 'Shop by';

  @override
  String get searchSearching => 'Searching…';

  @override
  String searchResultCount(String count) {
    return '$count results';
  }

  @override
  String get searchAny => 'Any';

  @override
  String get searchDelivery24h => 'Within 24 hours';

  @override
  String searchDeliveryUpTo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Up to $n days',
      one: 'Up to 1 day',
    );
    return '$_temp0';
  }

  @override
  String get searchFilterTitle => 'Filters';

  @override
  String get searchClearAll => 'Clear all';

  @override
  String get searchAllCategories => 'All categories';

  @override
  String get searchPriceRange => 'Price range (₫)';

  @override
  String get searchPriceMin => 'Minimum';

  @override
  String get searchPriceMax => 'Maximum';

  @override
  String get searchPriceError =>
      'Minimum price must be lower than maximum price';

  @override
  String get searchProOnly => 'Pro services only';

  @override
  String get searchProOnlyDesc =>
      'Offered by sellers whose quality has been vetted by VietGig.';

  @override
  String get searchShowResults => 'Show results';

  @override
  String searchShowResultsCount(int n) {
    return 'Show results ($n)';
  }

  @override
  String get sellerEarnings => 'Earnings';

  @override
  String get sellerAvailable => 'Available to withdraw';

  @override
  String get sellerActiveOrders => 'Active orders';

  @override
  String get sellerPaymentsClearing => 'Payments clearing';

  @override
  String get sellerSuccessScore => 'Success score';

  @override
  String get sellerRating => 'Rating';

  @override
  String get sellerResponseRate => 'Response rate';

  @override
  String get sellerOrders => 'Orders';

  @override
  String get sellerClients => 'Clients';

  @override
  String get sellerGotIt => 'Got it';

  @override
  String get sellerOptions => 'Options';

  @override
  String get sellerChartDateFormat => 'MMM d';

  @override
  String get sellerMonthFormat => 'MMMM';

  @override
  String get sellerDashLoadError => 'Couldn\'t load your dashboard';

  @override
  String sellerDashGreeting(String name) {
    return 'Hi $name,';
  }

  @override
  String get sellerDashGreetingFallback => 'there';

  @override
  String get sellerDashWelcomeBack => 'Welcome back';

  @override
  String get sellerDashSetupTitle => 'Complete your seller profile';

  @override
  String get sellerDashSetupBody =>
      'Create your first gig and complete your profile to start getting orders from clients.';

  @override
  String get sellerDashSetupLink => 'View my gigs →';

  @override
  String get sellerDashTodoTitle => 'To-dos';

  @override
  String sellerDashUnreadMessages(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n unread messages',
      one: '1 unread message',
    );
    return '$_temp0';
  }

  @override
  String get sellerDashUnreadNone =>
      'Your response time is looking great. Keep it up!';

  @override
  String get sellerDashUnreadSome =>
      'Reply soon to keep your response rate high.';

  @override
  String sellerDashOrdersToDeliver(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n orders to deliver',
      one: '1 order to deliver',
    );
    return '$_temp0';
  }

  @override
  String get sellerDashOrdersNone => 'You have no orders due soon.';

  @override
  String get sellerDashOrdersSome =>
      'Deliver on time to keep your success score high.';

  @override
  String get sellerDashMyGigs => 'My gigs';

  @override
  String get sellerDashManage => 'Manage';

  @override
  String get sellerDashStats => 'Statistics';

  @override
  String get sellerDashLast7Days => 'Last 7 days';

  @override
  String get sellerDashImpressions => 'Impressions';

  @override
  String get sellerDashClicks => 'Clicks';

  @override
  String get sellerDashConversion => 'Conversion';

  @override
  String get sellerDashBriefsTitle => 'New briefs';

  @override
  String get sellerDashLearnMore => 'Learn more';

  @override
  String get sellerDashBriefsEmpty => 'No new briefs yet';

  @override
  String sellerDashBriefsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n briefs match your skills',
      one: '1 brief matches your skills',
    );
    return '$_temp0';
  }

  @override
  String get sellerDashBriefsDesc =>
      'Discover promising projects from clients – briefs that match your skills will show up here.';

  @override
  String get sellerDashViewDetails => 'View details';

  @override
  String get sellerDashEarningsThisMonth => 'Earnings this month';

  @override
  String get sellerDashAvgPrice => 'Avg. selling price';

  @override
  String get sellerDashCancelledOrders => 'Cancelled orders';

  @override
  String get sellerDashActiveOrdersTitle => 'Orders in progress';

  @override
  String get sellerDashNoActiveOrders => 'You have no orders in progress.';

  @override
  String get sellerDashMyLevel => 'My level';

  @override
  String sellerDashDue(String date) {
    return 'Due $date';
  }

  @override
  String get sellerLevelTitle => 'Level overview';

  @override
  String get sellerLevelSystem => 'Level system';

  @override
  String get sellerLevelSystemDesc =>
      'Levels are re-evaluated every month based on your performance over the last 60 days.';

  @override
  String get sellerLevelColumn => 'Level';

  @override
  String get sellerLevelTopRatedNote =>
      'To become Top Rated, your profile also needs to be reviewed by the VietGig team.';

  @override
  String get sellerLevelTopReached => 'You\'ve reached the highest level!';

  @override
  String sellerLevelNext(String level) {
    return 'Next level: $level';
  }

  @override
  String get sellerLevelPerformance => 'Performance metrics';

  @override
  String get sellerLevelBasedOn =>
      'Based on your activity over the last 60 days.';

  @override
  String get sellerLevelSuccessInfo =>
      'A score from 1–10 that reflects client satisfaction, based on private reviews, cancellation rate and on-time delivery.';

  @override
  String get sellerLevelRatingInfo =>
      'The average rating buyers have given you.';

  @override
  String get sellerLevelResponseInfo =>
      'The share of new messages you reply to within 24 hours.';

  @override
  String get sellerLevelOrdersInfo => 'The number of orders you\'ve completed.';

  @override
  String get sellerLevelUniqueClients => 'Unique clients';

  @override
  String get sellerLevelUniqueClientsInfo =>
      'The number of different buyers who have completed orders with you.';

  @override
  String get sellerLevelEarningsInfo => 'Total earnings from completed orders.';

  @override
  String get sellerLevelReachNext => 'Required for next level';

  @override
  String get sellerLevelProgressNext => 'Progress to next level';

  @override
  String sellerLevelTarget(String level) {
    return '$level target';
  }

  @override
  String get sellerLevelExplain => 'Learn more';

  @override
  String get sellerRangeLast30 => 'Last 30 days';

  @override
  String get sellerRangeLast3Months => 'Last 3 months';

  @override
  String get sellerRangeThisYear => 'This year';

  @override
  String get sellerRangeLastYear => 'Last year';

  @override
  String get sellerEarningsPickRange => 'Select a time range';

  @override
  String sellerEarningsWithdrawTo(String amount) {
    return 'Withdraw $amount to';
  }

  @override
  String get sellerEarningsBank => 'Bank account';

  @override
  String get sellerEarningsBankSubtitle =>
      'Vietcombank •••• 6789 · 1–3 business days';

  @override
  String get sellerEarningsMomo => 'MoMo wallet';

  @override
  String get sellerEarningsMomoSubtitle => '090 •••• 123 · Instant';

  @override
  String sellerEarningsSentBank(String amount) {
    return 'Withdrawal request for $amount to your bank account has been sent';
  }

  @override
  String sellerEarningsSentMomo(String amount) {
    return 'Withdrawal request for $amount to your MoMo wallet has been sent';
  }

  @override
  String get sellerEarningsWithdraw => 'Withdraw';

  @override
  String get sellerEarningsNothing =>
      'You don\'t have any funds to withdraw yet.';

  @override
  String get sellerEarningsOverview => 'Overview';

  @override
  String get sellerEarningsCompleted => 'Completed orders';

  @override
  String sellerEarningsTotal(String amount) {
    return 'Total earnings: $amount';
  }

  @override
  String sellerEarningsTotalOrders(int n) {
    return 'Total completed orders: $n';
  }

  @override
  String get sellerEarningsAnalytics => 'Analytics';

  @override
  String sellerEarningsMonth(String month) {
    return '$month earnings';
  }

  @override
  String get sellerEarningsAvgPrice => 'Average selling price';

  @override
  String get sellerEarningsRevenue => 'Revenue';

  @override
  String get sellerEarningsClearingInfo =>
      'Payments from completed orders are held for 14 days before moving to your available balance. This protects both you and the buyer in case of a dispute.';

  @override
  String get sellerEarningsToDate => 'Earnings to date';

  @override
  String get sellerEarningsToDateInfo =>
      'The total you\'ve earned on VietGig since you started selling, after service fees.';

  @override
  String get sellerEarningsExpenses => 'Expenses to date';

  @override
  String get sellerEarningsExpensesInfo =>
      'The total amount of your earnings you\'ve spent on VietGig, for example buying services or promoting your gigs.';

  @override
  String get sellerEarningsWithdrawn => 'Withdrawn to date';

  @override
  String get sellerEarningsWithdrawnInfo =>
      'The total amount you\'ve withdrawn from VietGig to your bank account or e-wallet.';

  @override
  String get sellerAvailTitle => 'Availability';

  @override
  String get sellerAvailReasonVacation => 'On vacation';

  @override
  String get sellerAvailReasonOverloaded => 'Too much work';

  @override
  String get sellerAvailReasonOther => 'Other';

  @override
  String get sellerAvailConfirmed => 'Your unavailable dates are confirmed';

  @override
  String get sellerAvailChangesSaved =>
      'Your availability changes have been saved';

  @override
  String get sellerAvailDeleted => 'Unavailable dates removed';

  @override
  String get sellerAvailDesc =>
      'While you\'re unavailable, your gigs are hidden and you won\'t receive new orders or messages. Your response rate won\'t be affected during this time.';

  @override
  String get sellerAvailSet => 'Set unavailable dates';

  @override
  String get sellerAvailUpcoming => 'Upcoming unavailable dates';

  @override
  String get sellerAvailEdit => 'Edit';

  @override
  String sellerAvailReasonLine(String reason) {
    return 'Reason: $reason';
  }

  @override
  String sellerAvailReasonLineContact(String reason) {
    return 'Reason: $reason · Buyers can still contact you';
  }

  @override
  String get sellerAvailPickFirst => 'Select first day';

  @override
  String get sellerAvailPickLast => 'Select last day';

  @override
  String get sellerAvailPick => 'Select';

  @override
  String sellerAvailSaveError(String error) {
    return 'Couldn\'t save: $error';
  }

  @override
  String get sellerAvailDeleteTitle => 'Remove your unavailable dates?';

  @override
  String get sellerAvailDeleteMessage =>
      'This will remove your current unavailable dates.';

  @override
  String get sellerAvailEditTitle => 'Edit unavailable dates';

  @override
  String get sellerAvailFirstDay => 'First day';

  @override
  String get sellerAvailLastDay => 'Last day';

  @override
  String get sellerAvailInvalidRange =>
      'The last day must be on or after the first day.';

  @override
  String get sellerAvailReason => 'Reason';

  @override
  String get sellerAvailNoteLabel => 'Note (optional)';

  @override
  String get sellerAvailNoteHint =>
      'I\'m away right now, but I\'ll be back soon.';

  @override
  String get sellerAvailNoteHelp =>
      'This note will appear in the notice on your gig pages and profile.';

  @override
  String get sellerAvailAllowContact => 'Let all buyers contact me';

  @override
  String get sellerAvailAllowContactOn =>
      'Note: your response time to these messages still counts toward your response rate. Only turn this on if you can reply.';

  @override
  String get sellerAvailAllowContactOff =>
      'While you\'re unavailable, buyers can\'t place orders or contact you, but you can still message buyers with orders in progress.';

  @override
  String get sellerAvailSaveChanges => 'Save changes';

  @override
  String get sellerAvailConfirm => 'Confirm dates';

  @override
  String get sellerAvailDelete => 'Remove unavailable dates';

  @override
  String get sellerBriefsTitle => 'Briefs';

  @override
  String get sellerBriefsPrefs => 'Brief preferences';

  @override
  String get sellerBriefsPrefsUpdated => 'Brief preferences updated';

  @override
  String sellerBriefsResponded(String title) {
    return 'Response sent for brief “$title”';
  }

  @override
  String get sellerBriefsWhat => 'What is a brief?';

  @override
  String get sellerBriefsWhatBody =>
      'A brief is a project description posted by a buyer. VietGig sends you briefs that match your gigs and skills so you can send an offer.';

  @override
  String get sellerBriefsTabMatches => 'Matched for you';

  @override
  String get sellerBriefsTabSent => 'Sent responses';

  @override
  String get sellerBriefsOffTitle => 'You\'ve turned off briefs';

  @override
  String get sellerBriefsOffMessage =>
      'Turn \"Receive new briefs\" back on in preferences so you don\'t miss matching projects.';

  @override
  String get sellerBriefsOffAction => 'Open brief preferences';

  @override
  String get sellerBriefsEmptyTitle => 'No matching briefs yet…';

  @override
  String get sellerBriefsEmptyMessage =>
      'We\'ll let you know as soon as there\'s a brief that matches your skills.';

  @override
  String get sellerBriefsSentEmptyTitle => 'Maybe it\'s time for a new project';

  @override
  String get sellerBriefsSentEmptyMessage =>
      'Respond to briefs in the \"Matched for you\" tab and manage your sent responses here.';

  @override
  String get sellerBriefsIntroTitle => 'Your matches tab';

  @override
  String get sellerBriefsNewBadge => 'NEW';

  @override
  String get sellerBriefsIntroBody =>
      'All new briefs for you will appear in this tab – you could be the first to send an offer.';

  @override
  String get sellerBriefsNext => 'Next';

  @override
  String get sellerBriefsBuyer => 'Buyer';

  @override
  String sellerBriefsBudget(String budget, String days) {
    return 'Budget $budget · $days';
  }

  @override
  String get sellerBriefsSent => 'Sent';

  @override
  String get sellerBriefsSendOffer => 'Send offer';

  @override
  String get sellerBriefsReceiveTitle => 'Receive briefs';

  @override
  String get sellerBriefsReceiveDesc =>
      'Choose whether you want to receive briefs. You can turn this back on at any time.';

  @override
  String get sellerBriefsReceiveNew => 'Receive new briefs';

  @override
  String get sellerBriefsPriceTitle => 'Brief price';

  @override
  String get sellerBriefsPriceDesc =>
      'Set a minimum price for the briefs you want to receive. You can change it at any time.';

  @override
  String get sellerBriefsMinPrice => 'Minimum price (optional)';

  @override
  String get sellerBriefsPriceHint => 'Enter a price';

  @override
  String get sellerGigsShare => 'Share gig';

  @override
  String get sellerGigsShareTitle => 'Share your gigs';

  @override
  String get sellerGigsShareDesc =>
      'Share your gig links on social media to reach more buyers.';

  @override
  String get sellerGigsLinkCopied => 'Gig link copied';

  @override
  String get sellerGigsSampleNote =>
      'Sample gigs – you don\'t have any gigs yet. Here are some examples for reference.';

  @override
  String get sellerGigsEmptyTitle => 'No gigs yet';

  @override
  String get sellerGigsEmptyMessage =>
      'Create your first gig to start receiving orders.';

  @override
  String get sellerGigsResumed => 'Your gig is active again';

  @override
  String get sellerGigsPausedSnack => 'Gig paused';

  @override
  String get sellerGigsBoost => 'Get more traffic';

  @override
  String get sellerGigsNoReviews => 'No reviews yet';

  @override
  String get sellerGigsActive => 'Active';

  @override
  String get sellerGigsPaused => 'Paused';

  @override
  String get sellerGigsSample => 'Sample gig';

  @override
  String get sellerGigsPromoTitle => 'Promote on social media';

  @override
  String get sellerGigsPromoBody =>
      'Create a short video introducing your gig and share it on Facebook, TikTok or Zalo to attract more buyers. Video creation is coming soon to VietGig.';

  @override
  String get sellerGigsPromoBanner => 'Promote your gig';

  @override
  String get sellerGigsFeatured => 'Featured';

  @override
  String get sellerGigsPromoHeadline =>
      'Want more buyers from social media? Create a promo video for your gig in just a few minutes.';

  @override
  String get sellerTplTitle => 'Offer templates';

  @override
  String sellerTplSaved(String name) {
    return 'Template “$name” saved';
  }

  @override
  String sellerTplDeleted(String name) {
    return 'Template “$name” deleted';
  }

  @override
  String get sellerTplCreate => 'Create template';

  @override
  String get sellerTplEmptyTitle => 'Create templates for custom offers';

  @override
  String get sellerTplEmptyMessage =>
      'Save offers as templates to reuse them later.';

  @override
  String get sellerTplSwipeHint => 'Swipe left to delete a template.';

  @override
  String sellerTplSubtitle(String days) {
    return 'One-time payment | Delivery in $days';
  }

  @override
  String get sellerTplSheetTitle => 'Create offer template';

  @override
  String get sellerTplName => 'Template name';

  @override
  String get sellerTplNameHint => 'E.g. Premium design package';

  @override
  String get sellerTplNameRequired => 'Please enter a template name';

  @override
  String get sellerTplPrice => 'Price';

  @override
  String get sellerTplPriceRequired => 'Please enter a price';

  @override
  String sellerTplPriceMin(String amount) {
    return 'The minimum price is $amount';
  }

  @override
  String get sellerTplDays => 'Delivery days';

  @override
  String get sellerTplDaysSuffix => 'days';

  @override
  String get sellerTplDaysInvalid => 'Enter between 1 and 90 days';

  @override
  String get sellerTplSave => 'Save template';
}
