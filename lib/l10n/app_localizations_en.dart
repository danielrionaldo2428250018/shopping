// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get map => 'Map';

  @override
  String get saved => 'Saved';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get mandarin => 'Mandarin';

  @override
  String get korea => 'Korean';

  @override
  String get arab => 'Arabic';

  @override
  String get unknownLanguage => 'Unknown language';

  @override
  String get searchHint => 'Search preloved items, categories...';

  @override
  String get searchWithPhoto => 'Search with photo';

  @override
  String get photoSearchSubtitle =>
      'Pick a reference image. Gemini AI identifies the item and matches the catalog.';

  @override
  String get photoSearchCardHint =>
      'Tap here or the camera icon — gallery or new photo.';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takePhotoNow => 'Take photo now';

  @override
  String get cancel => 'Cancel';

  @override
  String get later => 'Later';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Retry';

  @override
  String get seeAll => 'See all';

  @override
  String get loading => 'Loading…';

  @override
  String get continueRequestPermission => 'Continue & request permission';

  @override
  String get notificationPermissionTitle => 'Notification permission';

  @override
  String notificationPermissionBody(String appName) {
    return 'To get message & order updates while the app is in the background, enable notifications for $appName. You can decline — messages stay in the app.';
  }

  @override
  String get galleryPermissionRequired =>
      'Gallery permission is required to pick an image.';

  @override
  String get cameraPermissionRequired =>
      'Camera permission is required to take a photo.';

  @override
  String get aiMatchingPhoto => 'Analyzing photo with AI';

  @override
  String get aiMatchingSubtitle => 'Gemini is identifying the product…';

  @override
  String photoSearchFailed(String error) {
    return 'Photo search failed: $error';
  }

  @override
  String photoSearchQuery(String query) {
    return 'Photo search: $query';
  }

  @override
  String get genericPhotoSearch => 'Photo search';

  @override
  String get trendingNow => 'Trending now';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearAll => 'Clear all';

  @override
  String get noRecentSearches => 'No recent searches';

  @override
  String get messages => 'Messages';

  @override
  String get noConversations => 'No conversations yet.';

  @override
  String get inboxEmptyHint =>
      'Order updates, promos, and push messages will appear here.';

  @override
  String get requestNotificationAgain =>
      'Request notification permission again';

  @override
  String get notificationRequestSent => 'Notification permission request sent.';

  @override
  String get searchPhotoTooltip => 'Search with photo (gallery / camera)';

  @override
  String get pushNotifications => 'Push notifications';

  @override
  String get pushNotificationsSubtitle => 'Messages & promos (FCM)';

  @override
  String get settingsSubtitle => 'Manage your account and preferences';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System default';

  @override
  String get admin => 'Admin';

  @override
  String get adminSellerApps => 'Seller applications';

  @override
  String get adminRewards => 'Manage reward vouchers';

  @override
  String get accountSection => 'Account';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get becomeSeller => 'Become a seller';

  @override
  String get logout => 'Log out';

  @override
  String get helpSupport => 'Help & support';

  @override
  String get aboutApp => 'About the app';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get signInSubtitle => 'Sign in to continue shopping';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerSubtitle => 'Join and start buying & selling preloved';

  @override
  String get fullName => 'Full name';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordMinHint => 'At least 6 characters';

  @override
  String get termsPrivacy => 'I agree to Terms & Privacy';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get fillEmailPassword => 'Enter email and password.';

  @override
  String get fillNameEmail => 'Enter name and email.';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get accountCreated => 'Account created successfully.';

  @override
  String get googleSignInSuccess => 'Signed in with Google.';

  @override
  String get authRequiredTitle => 'Sign-in required';

  @override
  String get authRequiredBody => 'Sign in or register to access this feature.';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get featuredForYou => 'Featured for you';

  @override
  String get shopByCategory => 'Shop by category';

  @override
  String get catElectronics => 'Electronics';

  @override
  String get catFashion => 'Fashion';

  @override
  String get catHome => 'Home';

  @override
  String get catSports => 'Sports';

  @override
  String get noProductsYet => 'No products yet';

  @override
  String get noProductsHint => 'Be the first to list a preloved item.';

  @override
  String productCount(int count) {
    return '$count products';
  }

  @override
  String get addProduct => 'Add product';

  @override
  String get addNewProduct => 'New product';

  @override
  String get addProductPhotoHint => 'Max 8 images • First image is the cover';

  @override
  String get productInfo => 'Product information';

  @override
  String get productName => 'Product name';

  @override
  String get selectCategory => 'Select category';

  @override
  String get priceLabel => 'Price (IDR)';

  @override
  String get stock => 'Stock';

  @override
  String get description => 'Description';

  @override
  String get condition => 'Condition';

  @override
  String get condBrandNew => 'Brand new';

  @override
  String get condLikeNew => 'Like new';

  @override
  String get condGood => 'Good';

  @override
  String get condFair => 'Fair';

  @override
  String get publishProduct => 'Publish';

  @override
  String get productPublished => 'Product published';

  @override
  String get publishFailed => 'Save failed. Check Firebase login & RTDB rules.';

  @override
  String get productNameRequired => 'Product name is required';

  @override
  String get categoryRequired => 'Select a category';

  @override
  String get priceRequired => 'Price must be greater than 0';

  @override
  String get stockRequired => 'Stock must be at least 1';

  @override
  String get myStore => 'My store';

  @override
  String get storePerformance => 'Store performance';

  @override
  String get thisMonth => 'This month';

  @override
  String get productsLabel => 'Products';

  @override
  String get noStoreProducts => 'No products yet';

  @override
  String get noStoreProductsHint => 'Add one via Add product.';

  @override
  String get viewAll => 'View all';

  @override
  String get active => 'Active';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String soldCount(String label) {
    return 'Sold: $label';
  }

  @override
  String get orders => 'Orders';

  @override
  String get myOrders => 'My orders';

  @override
  String get noOrders => 'No orders yet';

  @override
  String get cart => 'Cart';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get checkout => 'Checkout';

  @override
  String get buyNow => 'Buy now';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get productDetails => 'Product details';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get chat => 'Chat';

  @override
  String get chats => 'Chats';

  @override
  String get noChats => 'No chats yet';

  @override
  String get nearbyStores => 'Nearby stores';

  @override
  String get favorites => 'Favorites';

  @override
  String get emptyFavorites => 'No favorites yet';

  @override
  String get searchResults => 'Search results';

  @override
  String get sortRelevance => 'Relevance';

  @override
  String get sortPriceLow => 'Lowest price';

  @override
  String get sortPriceHigh => 'Highest price';

  @override
  String get conversationNotFound => 'Conversation not found';

  @override
  String get typeMessage => 'Type a message…';

  @override
  String get send => 'Send';

  @override
  String get loyaltyRewards => 'Points & rewards';

  @override
  String get reviews => 'Reviews';

  @override
  String get paymentSuccess => 'Payment successful';

  @override
  String get thankYouPurchase => 'Thank you! A little greener for Earth 🌱';

  @override
  String pointsEarned(int points) {
    return '+$points points';
  }

  @override
  String resetPasswordSent(String email) {
    return 'Reset link sent to $email';
  }

  @override
  String get enterEmailForReset => 'Enter your email above to reset password.';

  @override
  String get splashTagline => 'Eco-friendly preloved marketplace';

  @override
  String get onboardingSellTitle => 'Sell unused items';

  @override
  String get onboardingSellSubtitle =>
      'Turn your unused products into money easily.';

  @override
  String get onboardingBuyTitle => 'Find quality items';

  @override
  String get onboardingBuySubtitle =>
      'Buy trusted second-hand products near you.';

  @override
  String get onboardingEcoTitle => 'Eco friendly';

  @override
  String get onboardingEcoSubtitle =>
      'Reduce waste and support sustainable shopping.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get started';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get understand => 'Got it';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get sort => 'Sort';

  @override
  String get startShopping => 'Start shopping';

  @override
  String get startShoppingHint => 'Add your favorite products';

  @override
  String get details => 'Details';

  @override
  String get viewLabel => 'View';

  @override
  String get today => 'Today';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get changeProfilePhoto => 'Change profile photo';

  @override
  String get profilePhotoUpdated => 'Profile photo updated';

  @override
  String get profilePhotoFailed => 'Failed to save photo';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Invalid email format';

  @override
  String get phoneMinDigits => 'At least 10 digits required';

  @override
  String get phoneOrderHint =>
      'Phone number is used for order & delivery verification.';

  @override
  String get shippingSection => 'Shipping';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get selectAddress => 'Select address';

  @override
  String get addressHome => 'Home (primary)';

  @override
  String get addressOffice => 'Office';

  @override
  String get addressApartment => 'Apartment';

  @override
  String get addressParents => 'Parents\' address';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get paymentMethodSubtitle => 'VA, e-wallet, card, or COD';

  @override
  String get orderSummary => 'Summary';

  @override
  String get totalPayment => 'Total payment';

  @override
  String get promoCode => 'Promo code';

  @override
  String get applyPromo => 'Apply';

  @override
  String get shippingReguler => 'Regular';

  @override
  String get shippingExpress => 'Express';

  @override
  String get shippingEtaReguler => '2–3 business days';

  @override
  String get shippingEtaExpress => '1 business day';

  @override
  String subtotalLine(int count) {
    return 'Subtotal ($count items)';
  }

  @override
  String shippingFeeLine(String method) {
    return 'Shipping ($method)';
  }

  @override
  String get paymentLine => 'Payment';

  @override
  String stockLeft(int count) {
    return 'Stock $count';
  }

  @override
  String get payBcaVa => 'BCA Virtual Account';

  @override
  String get payMandiriVa => 'Mandiri Virtual Account';

  @override
  String get payBniVa => 'BNI Virtual Account';

  @override
  String get payOvo => 'OVO';

  @override
  String get payGopay => 'GoPay';

  @override
  String get payDana => 'DANA';

  @override
  String get payShopeePay => 'ShopeePay';

  @override
  String get payCard => 'Credit / debit card';

  @override
  String get payCardSubtitle => 'Visa, Mastercard, JCB';

  @override
  String get payCod => 'COD (cash on delivery)';

  @override
  String get payAutoVerify => 'Auto verification';

  @override
  String get phoneRequiredTitle => 'Phone number required';

  @override
  String get phoneHint => '08xx or +62…';

  @override
  String get saveAndContinue => 'Save & continue';

  @override
  String get sortWishlist => 'Sort wishlist';

  @override
  String get viewSellerStore => 'View seller store';

  @override
  String get searchInChat => 'Search in chat';

  @override
  String get searchMessages => 'Search messages';

  @override
  String get keywordHint => 'Keyword…';

  @override
  String get mediaAndPhotos => 'Media & photos';

  @override
  String get noPhotosInChat => 'No photos in this chat yet.';

  @override
  String get muteChatNotif => 'Mute chat notifications';

  @override
  String get muteChatDemo => 'Chat notifications muted (demo)';

  @override
  String get deleteConversation => 'Delete conversation';

  @override
  String get deleteConversationQ => 'Delete conversation?';

  @override
  String get deleteHistoryHint =>
      'Message history on this device will be cleared.';

  @override
  String get reportConversation => 'Report conversation';

  @override
  String get reportSentDemo => 'Report sent (demo)';

  @override
  String get blockSeller => 'Block seller';

  @override
  String get blockSellerDemo => 'Seller blocked (demo)';

  @override
  String get noMessagesYet => 'No messages yet.';

  @override
  String get noSearchInChat => 'No messages match your search.';

  @override
  String get productNotLinked => 'Product not linked to catalog';

  @override
  String get sendPhoto => 'Send photo';

  @override
  String get adminSellerDesc => 'Approve / reject seller applications';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordHint =>
      'Use \"Forgot password\" on login, or reset via Firebase email.';

  @override
  String get privacySecurity => 'Privacy & security';

  @override
  String get privacySecurityDesc => 'Protect your account and data';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get paymentMethodsDesc => 'Cards & digital wallets';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get emailNotifications => 'Email notifications';

  @override
  String get smsNotifications => 'SMS notifications';

  @override
  String get appPreferences => 'App preferences';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get locationAccess => 'Location access';

  @override
  String get fingerprintAuth => 'Fingerprint authentication';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privacyPolicyDesc => 'Read our privacy terms';

  @override
  String get helpSupportDesc => 'Get help';

  @override
  String get signOutQ => 'Sign out?';

  @override
  String get signOutDesc => 'Sign out of your account';

  @override
  String get appVersion => 'Version 1.0.0 • Made with ❤️';

  @override
  String get submitApplication => 'Submit application';

  @override
  String get becomeSellerTagline => 'Sell your preloved items to nearby buyers';

  @override
  String get storeLogo => 'Store logo';

  @override
  String get uploadLogo => 'Upload logo';

  @override
  String get uploadLogoHint => 'PNG, JPG up to 5MB';

  @override
  String get uploadLogoWebHint => 'Logo upload not available on web (demo).';

  @override
  String get storeInformation => 'Store information';

  @override
  String get storeName => 'Store name';

  @override
  String get storeNameHint => 'Enter your store name';

  @override
  String get storeDescription => 'Store description';

  @override
  String get storeDescriptionHint => 'Tell customers about your store…';

  @override
  String get contactInformation => 'Contact information';

  @override
  String get emailHint => 'store@example.com';

  @override
  String get storeAddress => 'Store address';

  @override
  String get streetAddress => 'Street address';

  @override
  String get streetHint => 'Enter your store address';

  @override
  String get cityHint => 'Enter city';

  @override
  String get sellerAgreement => 'Seller agreement';

  @override
  String get sellerAgreementBody =>
      'By becoming a seller you agree to our Terms and Seller Policy. You manage products, orders, and customer service.';

  @override
  String get agreeTerms => 'I agree to ';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get sellerPolicy => 'Seller Policy';

  @override
  String get fillAllFields =>
      'Please complete all fields and accept the agreement.';

  @override
  String get applicationSent => 'Application submitted. Admin will review.';

  @override
  String get applicationSentLocalFallback =>
      'Saved on this device only. Deploy Firestore rules (firestore.rules) for cloud sync.';

  @override
  String get sellerEmailMustMatchAccount =>
      'Application email must match your signed-in account email.';

  @override
  String sendFailed(String error) {
    return 'Failed to send: $error';
  }

  @override
  String get approveApplicationQ => 'Approve application?';

  @override
  String approveApplicationBody(String store, String email) {
    return 'Store: $store\nEmail: $email\nUser can sell after logging in with this email.';
  }

  @override
  String get yesApprove => 'Yes, approve';

  @override
  String approveFailed(String error) {
    return 'Failed to approve: $error';
  }

  @override
  String get applicationApproved => 'Application approved.';

  @override
  String get rejectApplicationQ => 'Reject application?';

  @override
  String get rejectReasonHint => 'Reason (optional)';

  @override
  String rejectFailed(String error) {
    return 'Failed to reject: $error';
  }

  @override
  String get applicationRejected => 'Application rejected.';

  @override
  String get tabApproved => 'Approved';

  @override
  String get noDataYet => 'No data yet';

  @override
  String get notFound => 'Not found';

  @override
  String get applicationNotFound => 'Application data not found.';

  @override
  String get storeInfo => 'Store information';

  @override
  String get administration => 'Administration';

  @override
  String get agreeTermsLabel => 'Agreed to terms';

  @override
  String get rejectReason => 'Rejection reason';

  @override
  String get approveBtn => 'Approve application';

  @override
  String get localModeHint =>
      'Local mode: data on device. Connect Firebase to sync with admin panel.';

  @override
  String sentOn(String date) {
    return 'Sent: $date';
  }

  @override
  String get addReward => 'Add reward';

  @override
  String get noRewardsAdmin => 'No rewards yet.';

  @override
  String get activeInactive => 'Active / inactive';

  @override
  String get rewardDescription => 'Description';

  @override
  String get rewardPointCost => 'Cost (points)';

  @override
  String get voucherCodeOptional => 'Voucher code (optional)';

  @override
  String get redeem => 'Redeem';

  @override
  String get notEnoughPoints => 'Not enough points for this reward.';

  @override
  String redeemConfirm(int cost, String desc) {
    return 'Redeem $cost points?\n\n$desc';
  }

  @override
  String redeemSuccess(String extra) {
    return 'Redeemed successfully!$extra';
  }

  @override
  String get rewardsAvailable => 'Available rewards';

  @override
  String get noActiveRewards => 'No active rewards from admin.';

  @override
  String get redemptionHistory => 'Redemption history';

  @override
  String voucherLine(String code, int cost) {
    return 'Code: $code · -$cost pts';
  }

  @override
  String levelLine(int level, String name) {
    return 'Level $level · $name';
  }

  @override
  String get pointsAvailable => 'points available';

  @override
  String lifetimePoints(int points) {
    return 'Lifetime total: $points points';
  }

  @override
  String pointsToNext(String name, int remaining) {
    return 'Toward $name: $remaining points to go';
  }

  @override
  String get maxLevelReached => 'Highest level reached!';

  @override
  String get cannotOpenBrowser => 'Cannot open browser';

  @override
  String get liveChat => 'Live chat';

  @override
  String get contactEmail => 'Contact email';

  @override
  String get reportProblem => 'Report a problem';

  @override
  String get helpTitle => 'How can we help?';

  @override
  String get helpSubtitle => 'We are here to solve your problems';

  @override
  String get catAccessories => 'Accessories';

  @override
  String get catFurniture => 'Furniture';

  @override
  String get makeOffer => 'Make offer';

  @override
  String get offerSubmitted => 'Offer submitted';

  @override
  String get submitOffer => 'Submit offer';

  @override
  String get currentPrice => 'Current price';

  @override
  String get yourOffer => 'Your offer';

  @override
  String get enterOffer => 'Enter your offer';

  @override
  String get sellerMayRespond => 'Seller may accept or reject your offer.';

  @override
  String get addPaymentMethod => 'Add payment method';

  @override
  String get addPaymentMethodDemo => 'Add method (demo)';

  @override
  String paymentSelectedDemo(String method) {
    return '$method selected (demo)';
  }

  @override
  String get productImages => 'Product images';

  @override
  String get monthlyTarget => '65% of monthly target achieved';

  @override
  String orderDate(String date) {
    return 'Date: $date';
  }

  @override
  String orderStatus(String status) {
    return 'Status: $status';
  }

  @override
  String trackingNumber(String number) {
    return 'Tracking: $number';
  }

  @override
  String get wishlist => 'Wishlist';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get changeProfileInfo => 'Change your profile information';

  @override
  String get reviewSample1 => 'Product matches description, responsive seller.';

  @override
  String get reviewSample2 => 'Fast delivery, item in great condition.';

  @override
  String get reviewSample3 => 'Recommended seller 👍';

  @override
  String get demoChatHello => 'Hi, is this item still available?';

  @override
  String get demoChatYes => 'Hi! Yes, still in stock 👍';

  @override
  String get demoChatNegotiate => 'Can you discount shipping a bit?';

  @override
  String get demoChatShipping => 'Sure, we subsidize more for Greater Jakarta.';

  @override
  String get tabPending => 'Pending';

  @override
  String get tabRejected => 'Rejected';

  @override
  String get nameLabel => 'Name';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get streetLabel => 'Street';

  @override
  String get cityLabel => 'City';

  @override
  String get statusLabel => 'Status';

  @override
  String get reviewedLabel => 'Reviewed';

  @override
  String get approveShort => 'Approve';

  @override
  String get rejectShort => 'Reject';

  @override
  String get catalogEmptyOrInvalid =>
      'Catalog is empty or product ID is invalid.';

  @override
  String get chatSellerTooltip => 'Chat with seller';

  @override
  String get freeShipping => 'Free shipping';

  @override
  String get estimatedDelivery => 'Estimated delivery 2–3 days';

  @override
  String get inStock => 'In stock';

  @override
  String get priceDisplay => 'Price';

  @override
  String get adminPanelWeb => 'Admin panel (web)';

  @override
  String openManualUrl(String url) {
    return 'Open manually: $url';
  }

  @override
  String get locationDeniedSystem =>
      'Location permission denied. Enable it in system settings.';

  @override
  String get biometricEnabledDemo =>
      'Biometrics enabled (demo — native integration in production)';

  @override
  String get biometricDisabledDemo => 'Biometrics disabled';

  @override
  String get discountLabel => 'Discount';

  @override
  String get voucherNotRecognized =>
      'Code not recognized. Try NEARMARKET10 or GRATISONGKIR';

  @override
  String get voucherPromoHint =>
      'NEARMARKET10 (10% off, max 50k) · GRATISONGKIR';

  @override
  String get onlineStatus => 'Online';

  @override
  String get offlineStatus => 'Offline';

  @override
  String get homeHeroTagline => 'Preloved goods, new stories';

  @override
  String get homeHeroSubtitle => 'Find quality secondhand items near you';

  @override
  String get appBrandName => 'PreLoved';

  @override
  String get defaultDisplayName => 'PreLoved user';

  @override
  String sortOrderLabel(String sort) {
    return 'Sort: $sort';
  }

  @override
  String get productNewNotification => 'New product on PreLoved';

  @override
  String get storeNewNotification => 'New store on PreLoved';

  @override
  String get openRelatedPage => 'Open related page';

  @override
  String get mapRequestingLocation => 'Requesting location permission…';

  @override
  String get mapLoadOsmFailed =>
      'Failed to load OSM data. Check your connection.';

  @override
  String get mapLocationDeniedFallback =>
      'Location denied — showing Jakarta map. Enable permission for your position.';

  @override
  String get mapGpsOffFallback =>
      'GPS off — showing Jakarta. Turn on location services.';

  @override
  String get mapGpsFailedFallback => 'GPS failed — Jakarta fallback.';

  @override
  String mapCoords(String coords) {
    return 'Coordinates: $coords';
  }

  @override
  String get mapWebCorsHint =>
      'Web: Nominatim blocked by CORS — use the Android/iOS app.';

  @override
  String get mapSellersTitle => 'Map & seller stores';

  @override
  String get mapLegendHint =>
      'Copper pin = verified seller · grey = nearby OSM places';

  @override
  String get mapSearchingSellers => 'Searching seller locations on map…';

  @override
  String get mapLoadingNominatim => 'Loading points from Nominatim…';

  @override
  String get mapOsmAttribution =>
      'Map: OSM · Store address: Nominatim (follow usage policy).';

  @override
  String get mapSearchPlacesHint =>
      'Search OSM place type (e.g. restaurant, supermarket)';

  @override
  String get mapOpenOsmTooltip => 'Open on openstreetmap.org';

  @override
  String get mapVerifiedSellers =>
      'Sellers approved by admin; position from store address.';

  @override
  String get mapNoVerifiedSellers =>
      'No verified sellers yet. Apply or wait for admin approval.';

  @override
  String get mapAddressNotFound =>
      'Address not found on map (check street & city).';

  @override
  String get mapPinMobileOnly =>
      'Store pin on map available on Android/iOS app.';

  @override
  String get mapGeocoding => 'Looking up coordinates…';

  @override
  String get mapAwaitingGeocode => 'Waiting for address mapping…';

  @override
  String get mapSomeAddressesFailed =>
      'Some addresses could not be mapped. Edit the application address or try later.';

  @override
  String mapNearbyPlaces(int count) {
    return 'Nearby places — OSM ($count)';
  }

  @override
  String get mapNoOsmResults =>
      'No OSM results in this area. Change search keywords.';

  @override
  String get demoAddrHomeShort => 'Kebayoran Baru';

  @override
  String get demoAddrOfficeShort => 'Sudirman';

  @override
  String get demoAddrAptShort => 'Jl. Pejaten Timur';

  @override
  String get demoAddrParentsShort => 'Bekasi';

  @override
  String get demoAddrHomeFull =>
      'Jl. Melati No. 12, Kebayoran Baru, South Jakarta 12120';

  @override
  String get demoAddrOfficeFull => 'Jl. Sudirman Kav 29, South Jakarta';

  @override
  String get demoAddrAptFull =>
      'Pejaten Timur Tower B Apt, South Jakarta 12510';

  @override
  String get demoAddrParentsFull => 'Harapan Indah Block F12, Bekasi 17123';

  @override
  String get sellerNotifications => 'Notifications';

  @override
  String get rewardSampleShipping => 'Rp 15,000 shipping voucher';

  @override
  String get rewardSampleDiscount => '10% off (max Rp 50k)';

  @override
  String get rewardSampleBag => 'Eco-friendly shopping bag';

  @override
  String get rewardSampleFeeWaive => 'Free service fee for 1 month';

  @override
  String get homePrelovedDeal => 'PRELOVED DEAL';

  @override
  String get homeWeekThriftBest => 'Best thrift prices this week';

  @override
  String get homeTrustedSellersLine =>
      'Quality secondhand from trusted sellers';

  @override
  String get homeExploreUsedBtn => 'Explore preloved items';

  @override
  String get catalogLoadingBanner =>
      'Preparing catalog… shown when the connection is slow.';

  @override
  String get wishlistUpdatedSnack => 'Wishlist updated';

  @override
  String get searchNoTrending => 'No trending keywords yet.';

  @override
  String get searchPhotoSortHint => 'Sorted by photo similarity';

  @override
  String get searchProductsHint => 'Search products…';

  @override
  String get orderReviewBtn => 'Review';

  @override
  String get orderTrackPackage => 'Track package';

  @override
  String orderTrackingNumber(String number) {
    return 'Tracking number:\n$number';
  }

  @override
  String get orderTrackOrder => 'Track order';

  @override
  String get orderBuyAgain => 'Buy again';

  @override
  String get orderCancelQ => 'Cancel order?';

  @override
  String get orderCancelBody => 'Cancelled orders cannot be restored.';

  @override
  String get orderCancelConfirm => 'Yes, cancel';

  @override
  String get orderCancelledSnack => 'Order cancelled';

  @override
  String get orderCancelBtn => 'Cancel';

  @override
  String get paymentSavedEarth => 'You helped save the planet';

  @override
  String paymentPointsRule(String total) {
    return 'Rp 1,000 spent = 1 point · total $total';
  }

  @override
  String get paymentOrderProcessing =>
      'Your order is being processed by the seller.';

  @override
  String get paymentBackHome => 'Back to home';

  @override
  String get paymentViewOrders => 'View orders';

  @override
  String mapDistanceFromYou(String km) {
    return '~$km km from you';
  }

  @override
  String get mapWebNominatimUnavailable =>
      'On web, Nominatim data is unavailable (CORS).';

  @override
  String get shimmerSlowConnection => 'Loading… connection may be slow.';

  @override
  String get shimmerFetchingSubtitle => 'Fetching data… please wait.';

  @override
  String ordersTabAll(int count) {
    return 'All ($count)';
  }

  @override
  String ordersTabPending(int count) {
    return 'Pending ($count)';
  }

  @override
  String ordersTabCompleted(int count) {
    return 'Completed ($count)';
  }

  @override
  String orderTotalAmount(String amount) {
    return 'Total $amount';
  }

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get proSellerBadge => 'Pro Seller';

  @override
  String get authInvalidEmail => 'Invalid email format.';

  @override
  String get authUserDisabled => 'This account has been disabled.';

  @override
  String get authUserNotFound => 'Email is not registered.';

  @override
  String get authWrongPassword => 'Wrong password.';

  @override
  String get authEmailInUse => 'Email already in use. Try signing in.';

  @override
  String get authWeakPassword => 'Password too weak (at least 6 characters).';

  @override
  String get authOperationNotAllowed =>
      'Sign-in method not enabled in Firebase Console.';

  @override
  String get authInvalidCredential => 'Incorrect email or password.';

  @override
  String get authTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get authNetworkFailed => 'Connection failed. Check your internet.';

  @override
  String get authAccountExistsDifferent =>
      'Email registered with another method (e.g. Google).';

  @override
  String get authGoogleSignInFailed =>
      'Google sign-in failed. Check SHA-1, Web Client ID, and Google provider in Firebase.';

  @override
  String get authFirebaseNotReady =>
      'Firebase not ready. Restart the app after configuring google-services.json.';

  @override
  String authFailedWithCode(String code) {
    return 'Authentication failed ($code).';
  }

  @override
  String get authPlatformGoogleFailed =>
      'Google Sign-In failed. Add SHA-1 in Firebase Console and re-download google-services.json.';

  @override
  String authPlatformFailedWithCode(String code) {
    return 'Sign-in failed ($code).';
  }
}
