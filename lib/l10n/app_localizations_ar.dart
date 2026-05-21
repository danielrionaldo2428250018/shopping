// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get home => 'الرئيسية';

  @override
  String get map => 'الخريطة';

  @override
  String get saved => 'المحفوظات';

  @override
  String get profile => 'الملف';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get indonesian => 'الإندونيسية';

  @override
  String get mandarin => 'الماندرين';

  @override
  String get korea => 'الكورية';

  @override
  String get arab => 'العربية';

  @override
  String get unknownLanguage => 'لغة غير معروفة';

  @override
  String get searchHint => 'ابحث عن سلع مستعملة، فئات...';

  @override
  String get searchWithPhoto => 'البحث بالصورة';

  @override
  String get photoSearchSubtitle =>
      'اختر صورة مرجعية. يحدد Gemini المنتج ويطابق الكتالوج.';

  @override
  String get photoSearchCardHint =>
      'اضغط هنا أو أيقونة الكاميرا — المعرض أو صورة جديدة.';

  @override
  String get chooseFromGallery => 'من المعرض';

  @override
  String get takePhotoNow => 'التقط صورة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get later => 'لاحقاً';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get ok => 'موافق';

  @override
  String get retry => 'إعادة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get loading => 'جاري التحميل…';

  @override
  String get continueRequestPermission => 'متابعة وطلب الإذن';

  @override
  String get notificationPermissionTitle => 'إذن الإشعارات';

  @override
  String notificationPermissionBody(String appName) {
    return 'لتلقي تحديثات الرسائل والطلبات في الخلفية، فعّل الإشعارات لـ $appName. يمكنك الرفض.';
  }

  @override
  String get galleryPermissionRequired => 'مطلوب إذن المعرض.';

  @override
  String get cameraPermissionRequired => 'مطلوب إذن الكاميرا.';

  @override
  String get aiMatchingPhoto => 'تحليل الصورة بالذكاء الاصطناعي';

  @override
  String get aiMatchingSubtitle => 'Gemini يحدد المنتج…';

  @override
  String photoSearchFailed(String error) {
    return 'فشل البحث: $error';
  }

  @override
  String photoSearchQuery(String query) {
    return 'بحث بالصورة: $query';
  }

  @override
  String get genericPhotoSearch => 'بحث بالصورة';

  @override
  String get trendingNow => 'الرائج';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get noRecentSearches => 'لا توجد عمليات بحث';

  @override
  String get messages => 'الرسائل';

  @override
  String get noConversations => 'لا توجد محادثات.';

  @override
  String get inboxEmptyHint => 'ستظهر رسائل الطلبات والعروض هنا.';

  @override
  String get requestNotificationAgain => 'طلب الإذن مرة أخرى';

  @override
  String get notificationRequestSent => 'تم إرسال طلب الإذن.';

  @override
  String get searchPhotoTooltip => 'بحث بالصورة';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get pushNotificationsSubtitle => 'رسائل وعروض (FCM)';

  @override
  String get settingsSubtitle => 'إدارة الحساب والتفضيلات';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get admin => 'المسؤول';

  @override
  String get adminSellerApps => 'طلبات البائعين';

  @override
  String get adminRewards => 'إدارة القسائم';

  @override
  String get accountSection => 'الحساب';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String get becomeSeller => 'كن بائعاً';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get helpSupport => 'المساعدة';

  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get signInSubtitle => 'سجّل الدخول لمتابعة التسوق';

  @override
  String get email => 'البريد';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get orContinueWith => 'أو تابع مع';

  @override
  String get continueWithGoogle => 'Google';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'التسجيل';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'انضم وابدأ بيع وشراء المستعمل';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordMinHint => '6 أحرف على الأقل';

  @override
  String get termsPrivacy => 'أوافق على الشروط والخصوصية';

  @override
  String get haveAccount => 'لديك حساب؟';

  @override
  String get fillEmailPassword => 'أدخل البريد وكلمة المرور.';

  @override
  String get fillNameEmail => 'أدخل الاسم والبريد.';

  @override
  String get passwordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get accountCreated => 'تم إنشاء الحساب.';

  @override
  String get googleSignInSuccess => 'تم الدخول عبر Google.';

  @override
  String get authRequiredTitle => 'يلزم تسجيل الدخول';

  @override
  String get authRequiredBody => 'سجّل الدخول أو أنشئ حساباً للوصول.';

  @override
  String get signInToContinue => 'سجّل الدخول للمتابعة';

  @override
  String get featuredForYou => 'مميز لك';

  @override
  String get shopByCategory => 'تسوق حسب الفئة';

  @override
  String get catElectronics => 'إلكترونيات';

  @override
  String get catFashion => 'أزياء';

  @override
  String get catHome => 'منزل';

  @override
  String get catSports => 'رياضة';

  @override
  String get noProductsYet => 'لا توجد منتجات';

  @override
  String get noProductsHint => 'كن أول من يضيف إعلاناً.';

  @override
  String productCount(int count) {
    return '$count منتجات';
  }

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get addNewProduct => 'منتج جديد';

  @override
  String get addProductPhotoHint => '8 صور كحد أقصى • الأولى غلاف';

  @override
  String get productInfo => 'معلومات المنتج';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get selectCategory => 'اختر الفئة';

  @override
  String get priceLabel => 'السعر';

  @override
  String get stock => 'المخزون';

  @override
  String get description => 'الوصف';

  @override
  String get condition => 'الحالة';

  @override
  String get condBrandNew => 'جديد';

  @override
  String get condLikeNew => 'كالجديد';

  @override
  String get condGood => 'جيد';

  @override
  String get condFair => 'مقبول';

  @override
  String get publishProduct => 'نشر';

  @override
  String get productPublished => 'تم النشر';

  @override
  String get publishFailed => 'فشل الحفظ.';

  @override
  String get productNameRequired => 'اسم المنتج مطلوب';

  @override
  String get categoryRequired => 'اختر الفئة';

  @override
  String get priceRequired => 'السعر يجب أن يكون أكبر من 0';

  @override
  String get stockRequired => 'المخزون 1 على الأقل';

  @override
  String get myStore => 'متجري';

  @override
  String get storePerformance => 'أداء المتجر';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get productsLabel => 'المنتجات';

  @override
  String get noStoreProducts => 'لا منتجات';

  @override
  String get noStoreProductsHint => 'أضف عبر إضافة منتج.';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get active => 'نشط';

  @override
  String get outOfStock => 'نفد';

  @override
  String soldCount(String label) {
    return 'مباع: $label';
  }

  @override
  String get orders => 'الطلبات';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get noOrders => 'لا طلبات';

  @override
  String get cart => 'السلة';

  @override
  String get emptyCart => 'السلة فارغة';

  @override
  String get checkout => 'الدفع';

  @override
  String get buyNow => 'اشتر الآن';

  @override
  String get addToCart => 'أضف للسلة';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String get productNotFound => 'المنتج غير موجود';

  @override
  String get chat => 'دردشة';

  @override
  String get chats => 'المحادثات';

  @override
  String get noChats => 'لا محادثات';

  @override
  String get nearbyStores => 'متاجر قريبة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get emptyFavorites => 'لا مفضلات';

  @override
  String get searchResults => 'نتائج البحث';

  @override
  String get sortRelevance => 'الصلة';

  @override
  String get sortPriceLow => 'أقل سعر';

  @override
  String get sortPriceHigh => 'أعلى سعر';

  @override
  String get conversationNotFound => 'المحادثة غير موجودة';

  @override
  String get typeMessage => 'اكتب رسالة…';

  @override
  String get send => 'إرسال';

  @override
  String get loyaltyRewards => 'النقاط والمكافآت';

  @override
  String get reviews => 'التقييمات';

  @override
  String get paymentSuccess => 'تم الدفع';

  @override
  String get thankYouPurchase => 'شكراً! 🌱';

  @override
  String pointsEarned(int points) {
    return '+$points نقطة';
  }

  @override
  String resetPasswordSent(String email) {
    return 'أُرسل الرابط إلى $email';
  }

  @override
  String get enterEmailForReset => 'أدخل بريدك أعلاه لإعادة التعيين.';

  @override
  String get splashTagline => 'سوق مستعمل صديق للبيئة';

  @override
  String get onboardingSellTitle => 'بع ما لا تستخدمه';

  @override
  String get onboardingSellSubtitle => 'حوّل منتجاتك إلى مال بسهولة.';

  @override
  String get onboardingBuyTitle => 'اعثر على جودة';

  @override
  String get onboardingBuySubtitle => 'اشترِ مستعملاً موثوقاً قربك.';

  @override
  String get onboardingEcoTitle => 'صديق للبيئة';

  @override
  String get onboardingEcoSubtitle => 'قلل النفايات وادعم الاستدامة.';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get back => 'رجوع';

  @override
  String get close => 'إغلاق';

  @override
  String get understand => 'فهمت';

  @override
  String get apply => 'تطبيق';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get sort => 'ترتيب';

  @override
  String get startShopping => 'ابدأ التسوق';

  @override
  String get startShoppingHint => 'أضف منتجاتك المفضلة';

  @override
  String get details => 'التفاصيل';

  @override
  String get viewLabel => 'عرض';

  @override
  String get today => 'اليوم';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get changeProfilePhoto => 'تغيير صورة الملف';

  @override
  String get profilePhotoUpdated => 'تم تحديث صورة الملف';

  @override
  String get profilePhotoFailed => 'فشل حفظ الصورة';

  @override
  String get profileSaved => 'تم حفظ الملف';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get emailRequired => 'البريد مطلوب';

  @override
  String get emailInvalid => 'صيغة البريد غير صالحة';

  @override
  String get phoneMinDigits => 'مطلوب 10 أرقام على الأقل';

  @override
  String get phoneOrderHint => 'يُستخدم رقم الهاتف للتحقق من الطلب والتوصيل.';

  @override
  String get shippingSection => 'الشحن';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get selectAddress => 'اختر العنوان';

  @override
  String get addressHome => 'المنزل (رئيسي)';

  @override
  String get addressOffice => 'المكتب';

  @override
  String get addressApartment => 'الشقة';

  @override
  String get addressParents => 'عنوان الوالدين';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get paymentMethodSubtitle =>
      'حساب افتراضي، محفظة، بطاقة، أو الدفع عند الاستلام';

  @override
  String get orderSummary => 'الملخص';

  @override
  String get totalPayment => 'إجمالي الدفع';

  @override
  String get promoCode => 'رمز ترويجي';

  @override
  String get applyPromo => 'تطبيق';

  @override
  String get shippingReguler => 'عادي';

  @override
  String get shippingExpress => 'سريع';

  @override
  String get shippingEtaReguler => '2–3 أيام عمل';

  @override
  String get shippingEtaExpress => 'يوم عمل واحد';

  @override
  String subtotalLine(int count) {
    return 'المجموع الفرعي ($count عناصر)';
  }

  @override
  String shippingFeeLine(String method) {
    return 'الشحن ($method)';
  }

  @override
  String get paymentLine => 'الدفع';

  @override
  String stockLeft(int count) {
    return 'المخزون $count';
  }

  @override
  String get payBcaVa => 'حساب BCA الافتراضي';

  @override
  String get payMandiriVa => 'حساب Mandiri الافتراضي';

  @override
  String get payBniVa => 'حساب BNI الافتراضي';

  @override
  String get payOvo => 'OVO';

  @override
  String get payGopay => 'GoPay';

  @override
  String get payDana => 'DANA';

  @override
  String get payShopeePay => 'ShopeePay';

  @override
  String get payCard => 'بطاقة ائتمان / خصم';

  @override
  String get payCardSubtitle => 'Visa، Mastercard، JCB';

  @override
  String get payCod => 'الدفع عند الاستلام';

  @override
  String get payAutoVerify => 'تحقق تلقائي';

  @override
  String get phoneRequiredTitle => 'رقم الهاتف مطلوب';

  @override
  String get phoneHint => '08xx أو +62…';

  @override
  String get saveAndContinue => 'حفظ ومتابعة';

  @override
  String get sortWishlist => 'ترتيب المفضلة';

  @override
  String get viewSellerStore => 'عرض متجر البائع';

  @override
  String get searchInChat => 'بحث في الدردشة';

  @override
  String get searchMessages => 'بحث في الرسائل';

  @override
  String get keywordHint => 'كلمة مفتاحية…';

  @override
  String get mediaAndPhotos => 'الوسائط والصور';

  @override
  String get noPhotosInChat => 'لا توجد صور في هذه الدردشة بعد.';

  @override
  String get muteChatNotif => 'كتم إشعارات الدردشة';

  @override
  String get muteChatDemo => 'تم كتم إشعارات الدردشة (تجريبي)';

  @override
  String get deleteConversation => 'حذف المحادثة';

  @override
  String get deleteConversationQ => 'حذف المحادثة؟';

  @override
  String get deleteHistoryHint => 'سيتم مسح سجل الرسائل على هذا الجهاز.';

  @override
  String get reportConversation => 'الإبلاغ عن المحادثة';

  @override
  String get reportSentDemo => 'تم إرسال البلاغ (تجريبي)';

  @override
  String get blockSeller => 'حظر البائع';

  @override
  String get blockSellerDemo => 'تم حظر البائع (تجريبي)';

  @override
  String get noMessagesYet => 'لا رسائل بعد.';

  @override
  String get noSearchInChat => 'لا توجد رسائل مطابقة للبحث.';

  @override
  String get productNotLinked => 'المنتج غير مرتبط بالكتالوج';

  @override
  String get sendPhoto => 'إرسال صورة';

  @override
  String get adminSellerDesc => 'الموافقة / رفض طلبات البائعين';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get changePasswordHint =>
      'استخدم \"نسيت كلمة المرور\" في تسجيل الدخول، أو أعد التعيين عبر بريد Firebase.';

  @override
  String get privacySecurity => 'الخصوصية والأمان';

  @override
  String get privacySecurityDesc => 'احمِ حسابك وبياناتك';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get paymentMethodsDesc => 'البطاقات والمحافظ الرقمية';

  @override
  String get notificationsSection => 'الإشعارات';

  @override
  String get emailNotifications => 'إشعارات البريد';

  @override
  String get smsNotifications => 'إشعارات SMS';

  @override
  String get appPreferences => 'تفضيلات التطبيق';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get locationAccess => 'الوصول للموقع';

  @override
  String get fingerprintAuth => 'المصادقة ببصمة الإصبع';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicyDesc => 'اقرأ شروط الخصوصية';

  @override
  String get helpSupportDesc => 'احصل على المساعدة';

  @override
  String get signOutQ => 'تسجيل الخروج؟';

  @override
  String get signOutDesc => 'الخروج من حسابك';

  @override
  String get appVersion => 'الإصدار 1.0.0 • صُنع بـ ❤️';

  @override
  String get submitApplication => 'إرسال الطلب';

  @override
  String get becomeSellerTagline => 'بع سلعك المستعملة للمشترين القريبين';

  @override
  String get storeLogo => 'شعار المتجر';

  @override
  String get uploadLogo => 'رفع الشعار';

  @override
  String get uploadLogoHint => 'PNG، JPG حتى 5MB';

  @override
  String get uploadLogoWebHint => 'رفع الشعار غير متاح على الويب (تجريبي).';

  @override
  String get storeInformation => 'معلومات المتجر';

  @override
  String get storeName => 'اسم المتجر';

  @override
  String get storeNameHint => 'أدخل اسم المتجر';

  @override
  String get storeDescription => 'وصف المتجر';

  @override
  String get storeDescriptionHint => 'أخبر العملاء عن متجرك…';

  @override
  String get contactInformation => 'معلومات الاتصال';

  @override
  String get emailHint => 'store@example.com';

  @override
  String get storeAddress => 'عنوان المتجر';

  @override
  String get streetAddress => 'عنوان الشارع';

  @override
  String get streetHint => 'أدخل عنوان المتجر';

  @override
  String get cityHint => 'أدخل المدينة';

  @override
  String get sellerAgreement => 'اتفاقية البائع';

  @override
  String get sellerAgreementBody =>
      'بكونك بائعاً، فإنك توافق على الشروط وسياسة البائع. أنت مسؤول عن المنتجات والطلبات وخدمة العملاء.';

  @override
  String get agreeTerms => 'أوافق على ';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get sellerPolicy => 'سياسة البائع';

  @override
  String get fillAllFields => 'يرجى إكمال جميع الحقول وقبول الاتفاقية.';

  @override
  String get applicationSent => 'تم إرسال الطلب. سيراجعه المسؤول.';

  @override
  String get applicationSentLocalFallback =>
      'تم الحفظ على هذا الجهاز فقط. انشر قواعد Firestore (firestore.rules).';

  @override
  String get sellerEmailMustMatchAccount =>
      'يجب أن يطابق البريد بريد الحساب المسجل.';

  @override
  String sendFailed(String error) {
    return 'فشل الإرسال: $error';
  }

  @override
  String get approveApplicationQ => 'الموافقة على الطلب؟';

  @override
  String approveApplicationBody(String store, String email) {
    return 'المتجر: $store\nالبريد: $email\nيمكن للمستخدم البيع بعد تسجيل الدخول بهذا البريد.';
  }

  @override
  String get yesApprove => 'نعم، وافق';

  @override
  String approveFailed(String error) {
    return 'فشلت الموافقة: $error';
  }

  @override
  String get applicationApproved => 'تمت الموافقة على الطلب.';

  @override
  String get rejectApplicationQ => 'رفض الطلب؟';

  @override
  String get rejectReasonHint => 'السبب (اختياري)';

  @override
  String rejectFailed(String error) {
    return 'فشل الرفض: $error';
  }

  @override
  String get applicationRejected => 'تم رفض الطلب.';

  @override
  String get tabApproved => 'موافق عليه';

  @override
  String get noDataYet => 'لا بيانات بعد';

  @override
  String get notFound => 'غير موجود';

  @override
  String get applicationNotFound => 'بيانات الطلب غير موجودة.';

  @override
  String get storeInfo => 'معلومات المتجر';

  @override
  String get administration => 'الإدارة';

  @override
  String get agreeTermsLabel => 'موافق على الشروط';

  @override
  String get rejectReason => 'سبب الرفض';

  @override
  String get approveBtn => 'الموافقة على الطلب';

  @override
  String get localModeHint =>
      'الوضع المحلي: البيانات على الجهاز. اربط Firebase للمزامنة مع لوحة المسؤول.';

  @override
  String sentOn(String date) {
    return 'أُرسل: $date';
  }

  @override
  String get addReward => 'إضافة مكافأة';

  @override
  String get noRewardsAdmin => 'لا مكافآت بعد.';

  @override
  String get activeInactive => 'نشط / غير نشط';

  @override
  String get rewardDescription => 'الوصف';

  @override
  String get rewardPointCost => 'التكلفة (نقاط)';

  @override
  String get voucherCodeOptional => 'رمز القسيمة (اختياري)';

  @override
  String get redeem => 'استبدال';

  @override
  String get notEnoughPoints => 'النقاط غير كافية لهذه المكافأة.';

  @override
  String redeemConfirm(int cost, String desc) {
    return 'استبدال $cost نقطة؟\n\n$desc';
  }

  @override
  String redeemSuccess(String extra) {
    return 'تم الاستبدال بنجاح!$extra';
  }

  @override
  String get rewardsAvailable => 'المكافآت المتاحة';

  @override
  String get noActiveRewards => 'لا مكافآت نشطة من المسؤول.';

  @override
  String get redemptionHistory => 'سجل الاستبدال';

  @override
  String voucherLine(String code, int cost) {
    return 'الرمز: $code · -$cost نقطة';
  }

  @override
  String levelLine(int level, String name) {
    return 'المستوى $level · $name';
  }

  @override
  String get pointsAvailable => 'نقاط متاحة';

  @override
  String lifetimePoints(int points) {
    return 'الإجمالي مدى الحياة: $points نقطة';
  }

  @override
  String pointsToNext(String name, int remaining) {
    return 'نحو $name: $remaining نقطة متبقية';
  }

  @override
  String get maxLevelReached => 'تم الوصول لأعلى مستوى!';

  @override
  String get cannotOpenBrowser => 'تعذر فتح المتصفح';

  @override
  String get liveChat => 'دردشة مباشرة';

  @override
  String get contactEmail => 'بريد الاتصال';

  @override
  String get reportProblem => 'الإبلاغ عن مشكلة';

  @override
  String get helpTitle => 'كيف يمكننا المساعدة؟';

  @override
  String get helpSubtitle => 'نحن هنا لحل مشاكلك';

  @override
  String get catAccessories => 'إكسسوارات';

  @override
  String get catFurniture => 'أثاث';

  @override
  String get makeOffer => 'تقديم عرض';

  @override
  String get offerSubmitted => 'تم إرسال العرض';

  @override
  String get submitOffer => 'إرسال العرض';

  @override
  String get currentPrice => 'السعر الحالي';

  @override
  String get yourOffer => 'عرضك';

  @override
  String get enterOffer => 'أدخل عرضك';

  @override
  String get sellerMayRespond => 'قد يقبل البائع أو يرفض عرضك.';

  @override
  String get addPaymentMethod => 'إضافة طريقة دفع';

  @override
  String get addPaymentMethodDemo => 'إضافة طريقة (تجريبي)';

  @override
  String paymentSelectedDemo(String method) {
    return 'تم اختيار $method (تجريبي)';
  }

  @override
  String get productImages => 'صور المنتج';

  @override
  String get monthlyTarget => 'تم تحقيق 65% من الهدف الشهري';

  @override
  String orderDate(String date) {
    return 'التاريخ: $date';
  }

  @override
  String orderStatus(String status) {
    return 'الحالة: $status';
  }

  @override
  String trackingNumber(String number) {
    return 'التتبع: $number';
  }

  @override
  String get wishlist => 'المفضلة';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get changeProfileInfo => 'تغيير معلومات ملفك';

  @override
  String get reviewSample1 => 'المنتج يطابق الوصف، البائع متجاوب.';

  @override
  String get reviewSample2 => 'توصيل سريع، السلعة بحالة ممتازة.';

  @override
  String get reviewSample3 => 'بائع موصى به 👍';

  @override
  String get demoChatHello => 'مرحباً، هل هذا المنتج متوفر؟';

  @override
  String get demoChatYes => 'مرحباً! نعم، لا يزال متوفراً 👍';

  @override
  String get demoChatNegotiate => 'هل يمكن خصم الشحن قليلاً؟';

  @override
  String get demoChatShipping =>
      'بالتأكيد، ندعم الشحن أكثر لمنطقة جاكرتا الكبرى.';

  @override
  String get tabPending => 'قيد الانتظار';

  @override
  String get tabRejected => 'مرفوض';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get streetLabel => 'الشارع';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get reviewedLabel => 'تمت المراجعة';

  @override
  String get approveShort => 'موافقة';

  @override
  String get rejectShort => 'رفض';

  @override
  String get catalogEmptyOrInvalid => 'الكتالوج فارغ أو معرف المنتج غير صالح.';

  @override
  String get chatSellerTooltip => 'محادثة البائع';

  @override
  String get freeShipping => 'شحن مجاني';

  @override
  String get estimatedDelivery => 'التسليم المتوقع 2–3 أيام';

  @override
  String get inStock => 'متوفر';

  @override
  String get priceDisplay => 'السعر';

  @override
  String get adminPanelWeb => 'لوحة الإدارة (ويب)';

  @override
  String openManualUrl(String url) {
    return 'فتح يدوياً: $url';
  }

  @override
  String get locationDeniedSystem =>
      'تم رفض إذن الموقع. فعّله من إعدادات النظام.';

  @override
  String get biometricEnabledDemo =>
      'تم تفعيل البصمة (تجريبي — تكامل أصلي في الإنتاج)';

  @override
  String get biometricDisabledDemo => 'تم تعطيل البصمة';

  @override
  String get discountLabel => 'خصم';

  @override
  String get voucherNotRecognized =>
      'رمز غير معروف. جرّب NEARMARKET10 أو GRATISONGKIR';

  @override
  String get voucherPromoHint =>
      'NEARMARKET10 (خصم 10%، حد 50 ألف) · GRATISONGKIR';

  @override
  String get onlineStatus => 'متصل';

  @override
  String get offlineStatus => 'غير متصل';

  @override
  String get homeHeroTagline => 'سلع مستعملة، قصص جديدة';

  @override
  String get homeHeroSubtitle => 'اعثر على مستعملات جيدة بالقرب منك';

  @override
  String get appBrandName => 'PreLoved';

  @override
  String get defaultDisplayName => 'مستخدم PreLoved';

  @override
  String sortOrderLabel(String sort) {
    return 'الترتيب: $sort';
  }

  @override
  String get productNewNotification => 'منتج جديد على PreLoved';

  @override
  String get storeNewNotification => 'متجر جديد على PreLoved';

  @override
  String storeNewNotificationBody(String storeName) {
    return '$storeName أصبح بائعاً رسمياً. تصفّح أحدث كتالوج السلع المستعملة!';
  }

  @override
  String get storeNewNotificationSender => 'مسؤول PreLoved';

  @override
  String get openRelatedPage => 'فتح الصفحة المرتبطة';

  @override
  String get mapRequestingLocation => 'طلب إذن الموقع…';

  @override
  String get mapLoadOsmFailed => 'فشل تحميل بيانات OSM. تحقق من الاتصال.';

  @override
  String get mapLocationDeniedFallback =>
      'الموقع مرفوض — خريطة جاكرتا. فعّل الإذن لموقعك.';

  @override
  String get mapGpsOffFallback => 'GPS مغلق — عرض جاكرتا. شغّل خدمات الموقع.';

  @override
  String get mapGpsFailedFallback => 'فشل GPS — جاكرتا احتياطياً.';

  @override
  String mapCoords(String coords) {
    return 'الإحداثيات: $coords';
  }

  @override
  String get mapWebCorsHint =>
      'الويب: Nominatim محجوب CORS — استخدم تطبيق Android/iOS.';

  @override
  String get mapSellersTitle => 'الخريطة ومتاجر البائعين';

  @override
  String get mapLegendHint => 'دبوس نحاسي = بائع موثق · رمادي = أماكن OSM';

  @override
  String get mapSearchingSellers => 'البحث عن مواقع البائعين…';

  @override
  String get mapLoadingNominatim => 'تحميل النقاط من Nominatim…';

  @override
  String get mapOsmAttribution =>
      'الخريطة: OSM · العنوان: Nominatim (اتبع السياسة).';

  @override
  String get mapSearchPlacesHint => 'ابحث نوع مكان OSM (مثلاً مطعم، سوبرماركت)';

  @override
  String get mapOpenOsmTooltip => 'فتح على openstreetmap.org';

  @override
  String get mapVerifiedSellers => 'بائعون معتمدون؛ الموقع من عنوان المتجر.';

  @override
  String get mapNoVerifiedSellers =>
      'لا بائعين موثقين بعد. قدّم أو انتظر موافقة الإدارة.';

  @override
  String get mapAddressNotFound => 'العنوان غير موجود على الخريطة.';

  @override
  String get mapPinMobileOnly => 'دبوس المتجر متاح على Android/iOS.';

  @override
  String get mapGeocoding => 'جاري البحث عن الإحداثيات…';

  @override
  String get mapAwaitingGeocode => 'في انتظار ربط العنوان…';

  @override
  String get mapSomeAddressesFailed =>
      'بعض العناوين لم تُربط. عدّل العنوان أو حاول لاحقاً.';

  @override
  String mapNearbyPlaces(int count) {
    return 'أماكن قريبة — OSM ($count)';
  }

  @override
  String get mapNoOsmResults => 'لا نتائج OSM. غيّر كلمات البحث.';

  @override
  String get demoAddrHomeShort => 'كيبايان بارو';

  @override
  String get demoAddrOfficeShort => 'سوديرمان';

  @override
  String get demoAddrAptShort => 'جل. بيجاتين تيمور';

  @override
  String get demoAddrParentsShort => 'بيكاسي';

  @override
  String get demoAddrHomeFull =>
      'جل. ميلاتي 12، كيبايان بارو، جاكرتا الجنوبية 12120';

  @override
  String get demoAddrOfficeFull => 'جل. سوديرمان كاف 29، جاكرتا الجنوبية';

  @override
  String get demoAddrAptFull => 'برج بيجاتين تيمور B، جاكرتا الجنوبية 12510';

  @override
  String get demoAddrParentsFull => 'هارابان إينداه F12، بيكاسي 17123';

  @override
  String get sellerNotifications => 'الإشعارات';

  @override
  String get rewardSampleShipping => 'قسيمة شحن 15,000 روبية';

  @override
  String get rewardSampleDiscount => 'خصم 10% (حد 50 ألف)';

  @override
  String get rewardSampleBag => 'حقيبة تسوق صديقة للبيئة';

  @override
  String get rewardSampleFeeWaive => 'إعفاء رسوم الخدمة لشهر';

  @override
  String get rewardSampleShippingDesc =>
      'خصم شحن لمرة شراء واحدة (حد أدنى 100 ألف روبية).';

  @override
  String get rewardSampleDiscountDesc => 'صالح لفئات الأزياء والإلكترونيات.';

  @override
  String get rewardSampleBagDesc =>
      'استلام من فعاليات PreLoved أو الشحن لعنوان الملف.';

  @override
  String get rewardSampleFeeWaiveDesc =>
      'للأعضاء المخلصين — بدون رسوم إدارة البائع.';

  @override
  String rewardPointCostLine(int cost) {
    return '$cost نقطة';
  }

  @override
  String get nativeLangIndonesian => 'Bahasa Indonesia';

  @override
  String get nativeLangEnglish => 'English';

  @override
  String get nativeLangArabic => 'العربية';

  @override
  String get nativeLangKorean => '한국어';

  @override
  String get nativeLangChinese => '中文';

  @override
  String get homePrelovedDeal => 'PRELOVED DEAL';

  @override
  String get homeWeekThriftBest => 'أفضل أسعار التوفيق هذا الأسبوع';

  @override
  String get homeTrustedSellersLine => 'مستعملات جيدة من بائعين موثوقين';

  @override
  String get homeExploreUsedBtn => 'استكشف المستعمل';

  @override
  String get catalogLoadingBanner =>
      'جاري تحضير الكتالوج… يظهر عند بطء الاتصال.';

  @override
  String get wishlistUpdatedSnack => 'تم تحديث المفضلة';

  @override
  String get searchNoTrending => 'لا كلمات رائجة بعد.';

  @override
  String get searchPhotoSortHint => 'مرتبة حسب تشابه الصورة';

  @override
  String get searchProductsHint => 'ابحث عن منتجات…';

  @override
  String get orderReviewBtn => 'مراجعة';

  @override
  String get orderTrackPackage => 'تتبع الطرد';

  @override
  String orderTrackingNumber(String number) {
    return 'رقم التتبع:\n$number';
  }

  @override
  String get orderTrackOrder => 'تتبع الطلب';

  @override
  String get orderBuyAgain => 'اشترِ مجدداً';

  @override
  String get orderCancelQ => 'إلغاء الطلب؟';

  @override
  String get orderCancelBody => 'لا يمكن استعادة الطلبات الملغاة.';

  @override
  String get orderCancelConfirm => 'نعم، إلغاء';

  @override
  String get orderCancelledSnack => 'تم إلغاء الطلب';

  @override
  String get orderCancelBtn => 'إلغاء';

  @override
  String get paymentSavedEarth => 'لقد ساعدت في إنقاذ الكوكب';

  @override
  String paymentPointsRule(String total) {
    return '1000 روبية = نقطة واحدة · الإجمالي $total';
  }

  @override
  String get paymentOrderProcessing => 'طلبك قيد المعالجة من البائع.';

  @override
  String get paymentBackHome => 'العودة للرئيسية';

  @override
  String get paymentViewOrders => 'عرض الطلبات';

  @override
  String mapDistanceFromYou(String km) {
    return '~$km كم منك';
  }

  @override
  String get mapWebNominatimUnavailable =>
      'على الويب، بيانات Nominatim غير متاحة (CORS).';

  @override
  String get shimmerSlowConnection => 'جاري التحميل… قد يكون الاتصال بطيئاً.';

  @override
  String get shimmerFetchingSubtitle => 'جاري جلب البيانات… انتظر.';

  @override
  String ordersTabAll(int count) {
    return 'الكل ($count)';
  }

  @override
  String ordersTabPending(int count) {
    return 'قيد الانتظار ($count)';
  }

  @override
  String ordersTabCompleted(int count) {
    return 'مكتمل ($count)';
  }

  @override
  String orderTotalAmount(String amount) {
    return 'الإجمالي $amount';
  }

  @override
  String get orderStatusCompleted => 'مكتمل';

  @override
  String get orderStatusProcessing => 'قيد المعالجة';

  @override
  String get orderStatusCancelled => 'ملغى';

  @override
  String get proSellerBadge => 'بائع محترف';

  @override
  String get authInvalidEmail => 'صيغة البريد غير صالحة.';

  @override
  String get authUserDisabled => 'تم تعطيل هذا الحساب.';

  @override
  String get authUserNotFound => 'البريد غير مسجل.';

  @override
  String get authWrongPassword => 'كلمة المرور خاطئة.';

  @override
  String get authEmailInUse => 'البريد مستخدم. جرّب تسجيل الدخول.';

  @override
  String get authWeakPassword => 'كلمة مرور ضعيفة (6 أحرف على الأقل).';

  @override
  String get authOperationNotAllowed => 'طريقة الدخول غير مفعّلة في Firebase.';

  @override
  String get authInvalidCredential => 'بريد أو كلمة مرور خاطئة.';

  @override
  String get authTooManyRequests => 'محاولات كثيرة. حاول لاحقاً.';

  @override
  String get authNetworkFailed => 'فشل الاتصال. تحقق من الإنترنت.';

  @override
  String get authAccountExistsDifferent =>
      'البريد مسجل بطريقة أخرى (مثل Google).';

  @override
  String get authGoogleSignInFailed =>
      'فشل دخول Google. تحقق من SHA-1 وWeb Client ID.';

  @override
  String get authFirebaseNotReady =>
      'Firebase غير جاهز. أعد تشغيل التطبيق بعد الإعداد.';

  @override
  String authFailedWithCode(String code) {
    return 'فشل المصادقة ($code).';
  }

  @override
  String get authPlatformGoogleFailed =>
      'فشل Google Sign-In. أضف SHA-1 في Firebase.';

  @override
  String authPlatformFailedWithCode(String code) {
    return 'فشل الدخول ($code).';
  }

  @override
  String get authGoogleSignInCancelled => 'تم إلغاء تسجيل الدخول عبر Google.';

  @override
  String get authGoogleNoEmail => 'حساب Google لا يحتوي على بريد إلكتروني.';

  @override
  String get authGoogleEmptyToken =>
      'رمز Google فارغ. تحقق من Web Client ID وoauth_client في google-services.json.';

  @override
  String get authGoogleNetworkError =>
      'فشل الاتصال أثناء تسجيل الدخول عبر Google. تحقق من الإنترنت.';

  @override
  String get sellerApplicationStatus => 'حالة طلب البائع';

  @override
  String get noSellerApplicationYet => 'لم تقدّم طلب بائع بعد.';

  @override
  String get applicationPendingMessage =>
      'طلبك قيد المراجعة. انتظر قرار المسؤول.';

  @override
  String get applicationApprovedMessage =>
      'تمت الموافقة! يمكنك استخدام ميزات البائع.';

  @override
  String get applicationRejectedMessage =>
      'تم رفض طلبك. راجع السبب أو قدّم طلباً جديداً.';

  @override
  String get submitNewSellerApplication => 'تقديم طلب جديد';

  @override
  String get viewSellerApplicationStatus => 'عرض حالة الطلب';

  @override
  String get adminAccessDenied => 'حساب المسؤول المحدد فقط يمكنه الوصول.';

  @override
  String get adminEmailNotConfigured =>
      'لم يُضبط بريد المسؤول. عدّل app_admin_local.dart وfirestore.rules.';

  @override
  String get submittedLabel => 'تاريخ التقديم';

  @override
  String get accountLoginLabel => 'الحساب المسجّل';

  @override
  String get roleAdmin => 'مسؤول';

  @override
  String get roleUser => 'مستخدم';

  @override
  String adminLoginHint(String email) {
    return 'لوحة الإدارة لـ $email فقط. سجّل الدخول بالبريد/كلمة المرور (ليس Google).';
  }
}
