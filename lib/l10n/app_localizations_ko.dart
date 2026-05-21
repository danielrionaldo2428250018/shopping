// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get home => '홈';

  @override
  String get map => '지도';

  @override
  String get saved => '저장';

  @override
  String get profile => '프로필';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get english => '영어';

  @override
  String get indonesian => '인도네시아어';

  @override
  String get mandarin => '중국어';

  @override
  String get korea => '한국어';

  @override
  String get arab => '아랍어';

  @override
  String get unknownLanguage => '알 수 없는 언어';

  @override
  String get searchHint => '중고품, 카테고리 검색...';

  @override
  String get searchWithPhoto => '사진으로 검색';

  @override
  String get photoSearchSubtitle => '참고 이미지를 선택하세요. Gemini AI가 상품을 인식합니다.';

  @override
  String get photoSearchCardHint => '여기 또는 카메라 아이콘 — 갤러리 또는 새 사진.';

  @override
  String get chooseFromGallery => '갤러리에서 선택';

  @override
  String get takePhotoNow => '사진 촬영';

  @override
  String get cancel => '취소';

  @override
  String get later => '나중에';

  @override
  String get save => '저장';

  @override
  String get edit => '수정';

  @override
  String get delete => '삭제';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';

  @override
  String get ok => '확인';

  @override
  String get retry => '다시 시도';

  @override
  String get seeAll => '전체 보기';

  @override
  String get loading => '로딩 중…';

  @override
  String get continueRequestPermission => '계속 및 권한 요청';

  @override
  String get notificationPermissionTitle => '알림 권한';

  @override
  String notificationPermissionBody(String appName) {
    return '백그라운드에서 주문·메시지 알림을 받으려면 $appName 알림을 켜세요.';
  }

  @override
  String get galleryPermissionRequired => '갤러리 권한이 필요합니다.';

  @override
  String get cameraPermissionRequired => '카메라 권한이 필요합니다.';

  @override
  String get aiMatchingPhoto => 'AI로 사진 분석';

  @override
  String get aiMatchingSubtitle => 'Gemini가 상품을 인식 중…';

  @override
  String photoSearchFailed(String error) {
    return '검색 실패: $error';
  }

  @override
  String photoSearchQuery(String query) {
    return '사진 검색: $query';
  }

  @override
  String get genericPhotoSearch => '사진 검색';

  @override
  String get trendingNow => '인기';

  @override
  String get recentSearches => '최근 검색';

  @override
  String get clearAll => '전체 삭제';

  @override
  String get noRecentSearches => '검색 기록 없음';

  @override
  String get messages => '메시지';

  @override
  String get noConversations => '대화가 없습니다.';

  @override
  String get inboxEmptyHint => '주문·프로모션·푸시 메시지가 여기에 표시됩니다.';

  @override
  String get requestNotificationAgain => '알림 권한 다시 요청';

  @override
  String get notificationRequestSent => '알림 권한 요청을 보냈습니다.';

  @override
  String get searchPhotoTooltip => '사진으로 검색';

  @override
  String get pushNotifications => '푸시 알림';

  @override
  String get pushNotificationsSubtitle => '메시지 및 프로모 (FCM)';

  @override
  String get settingsSubtitle => '계정 및 환경설정 관리';

  @override
  String get appearance => '화면';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get themeSystem => '시스템';

  @override
  String get admin => '관리자';

  @override
  String get adminSellerApps => '판매자 신청';

  @override
  String get adminRewards => '리워드 관리';

  @override
  String get accountSection => '계정';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get becomeSeller => '판매자 되기';

  @override
  String get logout => '로그아웃';

  @override
  String get helpSupport => '도움말';

  @override
  String get aboutApp => '앱 정보';

  @override
  String get welcomeBack => '다시 오신 것을 환영합니다!';

  @override
  String get signInSubtitle => '쇼핑을 계속하려면 로그인하세요';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get forgotPassword => '비밀번호 찾기';

  @override
  String get signIn => '로그인';

  @override
  String get orContinueWith => '또는';

  @override
  String get continueWithGoogle => 'Google로 계속';

  @override
  String get noAccount => '계정이 없으신가요?';

  @override
  String get signUp => '가입';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get registerSubtitle => '가입하고 중고 거래를 시작하세요';

  @override
  String get fullName => '이름';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get passwordMinHint => '최소 6자';

  @override
  String get termsPrivacy => '약관 및 개인정보에 동의';

  @override
  String get haveAccount => '이미 계정이 있으신가요?';

  @override
  String get fillEmailPassword => '이메일과 비밀번호를 입력하세요.';

  @override
  String get fillNameEmail => '이름과 이메일을 입력하세요.';

  @override
  String get passwordMismatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get accountCreated => '계정이 생성되었습니다.';

  @override
  String get googleSignInSuccess => 'Google 로그인 성공.';

  @override
  String get authRequiredTitle => '로그인 필요';

  @override
  String get authRequiredBody => '이 기능을 사용하려면 로그인하세요.';

  @override
  String get signInToContinue => '계속하려면 로그인';

  @override
  String get featuredForYou => '추천 상품';

  @override
  String get shopByCategory => '카테고리별';

  @override
  String get catElectronics => '전자';

  @override
  String get catFashion => '패션';

  @override
  String get catHome => '홈';

  @override
  String get catSports => '스포츠';

  @override
  String get noProductsYet => '상품 없음';

  @override
  String get noProductsHint => '첫 리스팅을 등록해 보세요.';

  @override
  String productCount(int count) {
    return '상품 $count개';
  }

  @override
  String get addProduct => '상품 추가';

  @override
  String get addNewProduct => '새 상품';

  @override
  String get addProductPhotoHint => '최대 8장 • 첫 사진이 커버';

  @override
  String get productInfo => '상품 정보';

  @override
  String get productName => '상품명';

  @override
  String get selectCategory => '카테고리 선택';

  @override
  String get priceLabel => '가격';

  @override
  String get stock => '재고';

  @override
  String get description => '설명';

  @override
  String get condition => '상태';

  @override
  String get condBrandNew => '새 상품';

  @override
  String get condLikeNew => '거의 새 것';

  @override
  String get condGood => '양호';

  @override
  String get condFair => '보통';

  @override
  String get publishProduct => '게시';

  @override
  String get productPublished => '게시됨';

  @override
  String get publishFailed => '저장 실패.';

  @override
  String get productNameRequired => '상품명 필수';

  @override
  String get categoryRequired => '카테고리 선택';

  @override
  String get priceRequired => '가격은 0보다 커야 함';

  @override
  String get stockRequired => '재고 최소 1';

  @override
  String get myStore => '내 스토어';

  @override
  String get storePerformance => '스토어 성과';

  @override
  String get thisMonth => '이번 달';

  @override
  String get productsLabel => '상품';

  @override
  String get noStoreProducts => '상품 없음';

  @override
  String get noStoreProductsHint => '상품 추가에서 등록하세요.';

  @override
  String get viewAll => '전체';

  @override
  String get active => '판매 중';

  @override
  String get outOfStock => '품절';

  @override
  String soldCount(String label) {
    return '판매: $label';
  }

  @override
  String get orders => '주문';

  @override
  String get myOrders => '내 주문';

  @override
  String get noOrders => '주문 없음';

  @override
  String get cart => '장바구니';

  @override
  String get emptyCart => '장바구니가 비었습니다';

  @override
  String get checkout => '결제';

  @override
  String get buyNow => '바로 구매';

  @override
  String get addToCart => '장바구니 담기';

  @override
  String get productDetails => '상품 상세';

  @override
  String get productNotFound => '상품을 찾을 수 없음';

  @override
  String get chat => '채팅';

  @override
  String get chats => '채팅 목록';

  @override
  String get noChats => '채팅 없음';

  @override
  String get nearbyStores => '근처 매장';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get emptyFavorites => '즐겨찾기 없음';

  @override
  String get searchResults => '검색 결과';

  @override
  String get sortRelevance => '관련도';

  @override
  String get sortPriceLow => '낮은 가격';

  @override
  String get sortPriceHigh => '높은 가격';

  @override
  String get conversationNotFound => '대화를 찾을 수 없음';

  @override
  String get typeMessage => '메시지 입력…';

  @override
  String get send => '보내기';

  @override
  String get loyaltyRewards => '포인트 & 리워드';

  @override
  String get reviews => '리뷰';

  @override
  String get paymentSuccess => '결제 완료';

  @override
  String get thankYouPurchase => '감사합니다! 🌱';

  @override
  String pointsEarned(int points) {
    return '+$points 포인트';
  }

  @override
  String resetPasswordSent(String email) {
    return '재설정 링크를 $email로 보냈습니다';
  }

  @override
  String get enterEmailForReset => '위에 이메일을 입력하세요.';

  @override
  String get splashTagline => '친환경 중고 마켓';

  @override
  String get onboardingSellTitle => '안 쓰는 물건 팔기';

  @override
  String get onboardingSellSubtitle => '쉽게 현금으로 바꿔 보세요.';

  @override
  String get onboardingBuyTitle => '좋은 상품 찾기';

  @override
  String get onboardingBuySubtitle => '믿을 수 있는 중고품을 구매하세요.';

  @override
  String get onboardingEcoTitle => '친환경';

  @override
  String get onboardingEcoSubtitle => '쓰레기를 줄이고 지속 가능한 쇼핑을.';

  @override
  String get skip => '건너뛰기';

  @override
  String get next => '다음';

  @override
  String get getStarted => '시작하기';

  @override
  String get back => '뒤로';

  @override
  String get close => '닫기';

  @override
  String get understand => '알겠습니다';

  @override
  String get apply => '적용';

  @override
  String get reset => '초기화';

  @override
  String get sort => '정렬';

  @override
  String get startShopping => '쇼핑 시작';

  @override
  String get startShoppingHint => '좋아하는 상품을 추가하세요';

  @override
  String get details => '상세';

  @override
  String get viewLabel => '보기';

  @override
  String get today => '오늘';

  @override
  String get phoneNumber => '전화번호';

  @override
  String get changeProfilePhoto => '프로필 사진 변경';

  @override
  String get profilePhotoUpdated => '프로필 사진이 업데이트되었습니다';

  @override
  String get profilePhotoFailed => '사진 저장 실패';

  @override
  String get profileSaved => '프로필 저장됨';

  @override
  String get saveChanges => '변경 사항 저장';

  @override
  String get nameRequired => '이름을 입력하세요';

  @override
  String get emailRequired => '이메일을 입력하세요';

  @override
  String get emailInvalid => '이메일 형식이 올바르지 않습니다';

  @override
  String get phoneMinDigits => '최소 10자리 필요';

  @override
  String get phoneOrderHint => '전화번호는 주문 및 배송 확인에 사용됩니다.';

  @override
  String get shippingSection => '배송';

  @override
  String get deliveryAddress => '배송 주소';

  @override
  String get selectAddress => '주소 선택';

  @override
  String get addressHome => '집 (기본)';

  @override
  String get addressOffice => '사무실';

  @override
  String get addressApartment => '아파트';

  @override
  String get addressParents => '부모님 주소';

  @override
  String get paymentMethod => '결제 수단';

  @override
  String get paymentMethodSubtitle => '가상계좌, 전자지갑, 카드 또는 착불';

  @override
  String get orderSummary => '요약';

  @override
  String get totalPayment => '총 결제 금액';

  @override
  String get promoCode => '프로모 코드';

  @override
  String get applyPromo => '적용';

  @override
  String get shippingReguler => '일반';

  @override
  String get shippingExpress => '특급';

  @override
  String get shippingEtaReguler => '2–3 영업일';

  @override
  String get shippingEtaExpress => '1 영업일';

  @override
  String subtotalLine(int count) {
    return '소계 ($count개)';
  }

  @override
  String shippingFeeLine(String method) {
    return '배송비 ($method)';
  }

  @override
  String get paymentLine => '결제';

  @override
  String stockLeft(int count) {
    return '재고 $count';
  }

  @override
  String get payBcaVa => 'BCA 가상계좌';

  @override
  String get payMandiriVa => 'Mandiri 가상계좌';

  @override
  String get payBniVa => 'BNI 가상계좌';

  @override
  String get payOvo => 'OVO';

  @override
  String get payGopay => 'GoPay';

  @override
  String get payDana => 'DANA';

  @override
  String get payShopeePay => 'ShopeePay';

  @override
  String get payCard => '신용 / 체크카드';

  @override
  String get payCardSubtitle => 'Visa, Mastercard, JCB';

  @override
  String get payCod => '착불 (배송 시 결제)';

  @override
  String get payAutoVerify => '자동 확인';

  @override
  String get phoneRequiredTitle => '전화번호 필요';

  @override
  String get phoneHint => '08xx 또는 +62…';

  @override
  String get saveAndContinue => '저장 및 계속';

  @override
  String get sortWishlist => '위시리스트 정렬';

  @override
  String get viewSellerStore => '판매자 스토어 보기';

  @override
  String get searchInChat => '채팅에서 검색';

  @override
  String get searchMessages => '메시지 검색';

  @override
  String get keywordHint => '키워드…';

  @override
  String get mediaAndPhotos => '미디어 및 사진';

  @override
  String get noPhotosInChat => '이 채팅에 아직 사진이 없습니다.';

  @override
  String get muteChatNotif => '채팅 알림 끄기';

  @override
  String get muteChatDemo => '채팅 알림이 꺼졌습니다 (데모)';

  @override
  String get deleteConversation => '대화 삭제';

  @override
  String get deleteConversationQ => '대화를 삭제할까요?';

  @override
  String get deleteHistoryHint => '이 기기의 메시지 기록이 삭제됩니다.';

  @override
  String get reportConversation => '대화 신고';

  @override
  String get reportSentDemo => '신고가 전송되었습니다 (데모)';

  @override
  String get blockSeller => '판매자 차단';

  @override
  String get blockSellerDemo => '판매자가 차단되었습니다 (데모)';

  @override
  String get noMessagesYet => '아직 메시지가 없습니다.';

  @override
  String get noSearchInChat => '검색과 일치하는 메시지가 없습니다.';

  @override
  String get productNotLinked => '카탈로그에 연결되지 않은 상품';

  @override
  String get sendPhoto => '사진 보내기';

  @override
  String get adminSellerDesc => '판매자 신청 승인 / 거절';

  @override
  String get changePassword => '비밀번호 변경';

  @override
  String get changePasswordHint =>
      '로그인에서 \"비밀번호 찾기\"를 사용하거나 Firebase 이메일로 재설정하세요.';

  @override
  String get privacySecurity => '개인정보 및 보안';

  @override
  String get privacySecurityDesc => '계정과 데이터를 보호하세요';

  @override
  String get paymentMethods => '결제 수단';

  @override
  String get paymentMethodsDesc => '카드 및 디지털 지갑';

  @override
  String get notificationsSection => '알림';

  @override
  String get emailNotifications => '이메일 알림';

  @override
  String get smsNotifications => 'SMS 알림';

  @override
  String get appPreferences => '앱 환경설정';

  @override
  String get darkMode => '다크 모드';

  @override
  String get locationAccess => '위치 접근';

  @override
  String get fingerprintAuth => '지문 인증';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyPolicyDesc => '개인정보 약관 읽기';

  @override
  String get helpSupportDesc => '도움 받기';

  @override
  String get signOutQ => '로그아웃할까요?';

  @override
  String get signOutDesc => '계정에서 로그아웃';

  @override
  String get appVersion => '버전 1.0.0 • ❤️로 제작';

  @override
  String get submitApplication => '신청 제출';

  @override
  String get becomeSellerTagline => '근처 구매자에게 중고품을 판매하세요';

  @override
  String get storeLogo => '스토어 로고';

  @override
  String get uploadLogo => '로고 업로드';

  @override
  String get uploadLogoHint => 'PNG, JPG 최대 5MB';

  @override
  String get uploadLogoWebHint => '웹에서는 로고 업로드 불가 (데모).';

  @override
  String get storeInformation => '스토어 정보';

  @override
  String get storeName => '스토어 이름';

  @override
  String get storeNameHint => '스토어 이름 입력';

  @override
  String get storeDescription => '스토어 설명';

  @override
  String get storeDescriptionHint => '고객에게 스토어를 소개하세요…';

  @override
  String get contactInformation => '연락처 정보';

  @override
  String get emailHint => 'store@example.com';

  @override
  String get storeAddress => '스토어 주소';

  @override
  String get streetAddress => '도로명 주소';

  @override
  String get streetHint => '스토어 주소 입력';

  @override
  String get cityHint => '도시 입력';

  @override
  String get sellerAgreement => '판매자 약관';

  @override
  String get sellerAgreementBody =>
      '판매자가 되면 이용약관 및 판매자 정책에 동의합니다. 상품, 주문, 고객 서비스를 관리합니다.';

  @override
  String get agreeTerms => '다음에 동의합니다: ';

  @override
  String get termsConditions => '이용약관';

  @override
  String get sellerPolicy => '판매자 정책';

  @override
  String get fillAllFields => '모든 항목을 작성하고 약관에 동의하세요.';

  @override
  String get applicationSent => '신청이 제출되었습니다. 관리자가 검토합니다.';

  @override
  String get applicationSentLocalFallback =>
      '이 기기에만 저장되었습니다. Firestore 규칙(firestore.rules)을 배포하세요.';

  @override
  String get sellerEmailMustMatchAccount => '신청 이메일은 로그인한 계정 이메일과 같아야 합니다.';

  @override
  String sendFailed(String error) {
    return '전송 실패: $error';
  }

  @override
  String get approveApplicationQ => '신청을 승인할까요?';

  @override
  String approveApplicationBody(String store, String email) {
    return '스토어: $store\n이메일: $email\n해당 이메일로 로그인하면 판매할 수 있습니다.';
  }

  @override
  String get yesApprove => '예, 승인';

  @override
  String approveFailed(String error) {
    return '승인 실패: $error';
  }

  @override
  String get applicationApproved => '신청이 승인되었습니다.';

  @override
  String get rejectApplicationQ => '신청을 거절할까요?';

  @override
  String get rejectReasonHint => '사유 (선택)';

  @override
  String rejectFailed(String error) {
    return '거절 실패: $error';
  }

  @override
  String get applicationRejected => '신청이 거절되었습니다.';

  @override
  String get tabApproved => '승인됨';

  @override
  String get noDataYet => '아직 데이터 없음';

  @override
  String get notFound => '찾을 수 없음';

  @override
  String get applicationNotFound => '신청 데이터를 찾을 수 없습니다.';

  @override
  String get storeInfo => '스토어 정보';

  @override
  String get administration => '관리';

  @override
  String get agreeTermsLabel => '약관 동의';

  @override
  String get rejectReason => '거절 사유';

  @override
  String get approveBtn => '신청 승인';

  @override
  String get localModeHint => '로컬 모드: 기기에 데이터 저장. Firebase 연결 시 관리 패널과 동기화.';

  @override
  String sentOn(String date) {
    return '전송: $date';
  }

  @override
  String get addReward => '리워드 추가';

  @override
  String get noRewardsAdmin => '아직 리워드 없음.';

  @override
  String get activeInactive => '활성 / 비활성';

  @override
  String get rewardDescription => '설명';

  @override
  String get rewardPointCost => '비용 (포인트)';

  @override
  String get voucherCodeOptional => '바우처 코드 (선택)';

  @override
  String get redeem => '교환';

  @override
  String get notEnoughPoints => '이 리워드에 포인트가 부족합니다.';

  @override
  String redeemConfirm(int cost, String desc) {
    return '$cost 포인트를 교환할까요?\n\n$desc';
  }

  @override
  String redeemSuccess(String extra) {
    return '교환 성공!$extra';
  }

  @override
  String get rewardsAvailable => '사용 가능한 리워드';

  @override
  String get noActiveRewards => '관리자의 활성 리워드 없음.';

  @override
  String get redemptionHistory => '교환 내역';

  @override
  String voucherLine(String code, int cost) {
    return '코드: $code · -$cost pts';
  }

  @override
  String levelLine(int level, String name) {
    return '레벨 $level · $name';
  }

  @override
  String get pointsAvailable => '사용 가능 포인트';

  @override
  String lifetimePoints(int points) {
    return '누적 합계: $points 포인트';
  }

  @override
  String pointsToNext(String name, int remaining) {
    return '$name까지: $remaining 포인트 남음';
  }

  @override
  String get maxLevelReached => '최고 레벨 달성!';

  @override
  String get cannotOpenBrowser => '브라우저를 열 수 없습니다';

  @override
  String get liveChat => '라이브 채팅';

  @override
  String get contactEmail => '문의 이메일';

  @override
  String get reportProblem => '문제 신고';

  @override
  String get helpTitle => '무엇을 도와드릴까요?';

  @override
  String get helpSubtitle => '문제 해결을 위해 여기 있습니다';

  @override
  String get catAccessories => '액세서리';

  @override
  String get catFurniture => '가구';

  @override
  String get makeOffer => '가격 제안';

  @override
  String get offerSubmitted => '제안이 제출되었습니다';

  @override
  String get submitOffer => '제안 제출';

  @override
  String get currentPrice => '현재 가격';

  @override
  String get yourOffer => '제안 가격';

  @override
  String get enterOffer => '제안 가격 입력';

  @override
  String get sellerMayRespond => '판매자가 제안을 수락하거나 거절할 수 있습니다.';

  @override
  String get addPaymentMethod => '결제 수단 추가';

  @override
  String get addPaymentMethodDemo => '수단 추가 (데모)';

  @override
  String paymentSelectedDemo(String method) {
    return '$method 선택됨 (데모)';
  }

  @override
  String get productImages => '상품 이미지';

  @override
  String get monthlyTarget => '월간 목표 65% 달성';

  @override
  String orderDate(String date) {
    return '날짜: $date';
  }

  @override
  String orderStatus(String status) {
    return '상태: $status';
  }

  @override
  String trackingNumber(String number) {
    return '운송장: $number';
  }

  @override
  String get wishlist => '위시리스트';

  @override
  String get changePasswordTitle => '비밀번호 변경';

  @override
  String get changeProfileInfo => '프로필 정보 변경';

  @override
  String get reviewSample1 => '설명과 일치, 판매자 응답 빠름.';

  @override
  String get reviewSample2 => '빠른 배송, 상품 상태 우수.';

  @override
  String get reviewSample3 => '추천 판매자 👍';

  @override
  String get demoChatHello => '안녕하세요, 이 상품 아직 있나요?';

  @override
  String get demoChatYes => '안녕하세요! 네, 아직 재고 있습니다 👍';

  @override
  String get demoChatNegotiate => '배송비 조금 할인해 주실 수 있나요?';

  @override
  String get demoChatShipping => '네, 자카르타 권역은 배송비를 더 지원해 드립니다.';

  @override
  String get tabPending => '대기';

  @override
  String get tabRejected => '거절';

  @override
  String get nameLabel => '이름';

  @override
  String get phoneLabel => '전화';

  @override
  String get streetLabel => '거리';

  @override
  String get cityLabel => '도시';

  @override
  String get statusLabel => '상태';

  @override
  String get reviewedLabel => '검토됨';

  @override
  String get approveShort => '승인';

  @override
  String get rejectShort => '거절';

  @override
  String get catalogEmptyOrInvalid => '카탈로그가 비었거나 상품 ID가 잘못되었습니다.';

  @override
  String get chatSellerTooltip => '판매자와 채팅';

  @override
  String get freeShipping => '무료 배송';

  @override
  String get estimatedDelivery => '예상 배송 2–3일';

  @override
  String get inStock => '재고 있음';

  @override
  String get priceDisplay => '가격';

  @override
  String get adminPanelWeb => '관리자 패널(웹)';

  @override
  String openManualUrl(String url) {
    return '수동 열기: $url';
  }

  @override
  String get locationDeniedSystem => '위치 권한이 거부되었습니다. 시스템 설정에서 활성화하세요.';

  @override
  String get biometricEnabledDemo => '생체 인증 활성화(데모 — 프로덕션에서 네이티브 연동)';

  @override
  String get biometricDisabledDemo => '생체 인증 비활성화';

  @override
  String get discountLabel => '할인';

  @override
  String get voucherNotRecognized =>
      '코드를 인식하지 못했습니다. NEARMARKET10 또는 GRATISONGKIR을 시도하세요';

  @override
  String get voucherPromoHint => 'NEARMARKET10 (10% 할인, 최대 5만) · GRATISONGKIR';

  @override
  String get onlineStatus => '온라인';

  @override
  String get offlineStatus => '오프라인';

  @override
  String get homeHeroTagline => '중고품, 새로운 이야기';

  @override
  String get homeHeroSubtitle => '주변의 양질의 중고를 찾아보세요';

  @override
  String get appBrandName => 'PreLoved';

  @override
  String get defaultDisplayName => 'PreLoved 사용자';

  @override
  String sortOrderLabel(String sort) {
    return '정렬: $sort';
  }

  @override
  String get productNewNotification => 'PreLoved 신규 상품';

  @override
  String get storeNewNotification => 'PreLoved 신규 스토어';

  @override
  String storeNewNotificationBody(String storeName) {
    return '$storeName이(가) 공식 판매자가 되었습니다. 최신 프리러브드 카탈로그를 확인하세요!';
  }

  @override
  String get storeNewNotificationSender => 'PreLoved 관리자';

  @override
  String get openRelatedPage => '관련 페이지 열기';

  @override
  String get mapRequestingLocation => '위치 권한 요청 중…';

  @override
  String get mapLoadOsmFailed => 'OSM 데이터 로드 실패. 연결을 확인하세요.';

  @override
  String get mapLocationDeniedFallback =>
      '위치 거부 — 자카르타 지도. 권한을 켜면 내 위치를 표시합니다.';

  @override
  String get mapGpsOffFallback => 'GPS 꺼짐 — 자카르타 표시. 위치 서비스를 켜세요.';

  @override
  String get mapGpsFailedFallback => 'GPS 실패 — 자카르타 대체.';

  @override
  String mapCoords(String coords) {
    return '좌표: $coords';
  }

  @override
  String get mapWebCorsHint => '웹: Nominatim CORS 차단 — Android/iOS 앱을 사용하세요.';

  @override
  String get mapSellersTitle => '지도 및 판매자 매장';

  @override
  String get mapLegendHint => '구리 핀 = 인증 판매자 · 회색 = 주변 OSM 장소';

  @override
  String get mapSearchingSellers => '지도에서 판매자 위치 검색 중…';

  @override
  String get mapLoadingNominatim => 'Nominatim에서 지점 로드 중…';

  @override
  String get mapOsmAttribution => '지도: OSM · 주소: Nominatim(이용 정책 준수).';

  @override
  String get mapSearchPlacesHint => 'OSM 장소 유형 검색(예: 레스토랑, 슈퍼마켓)';

  @override
  String get mapOpenOsmTooltip => 'openstreetmap.org에서 열기';

  @override
  String get mapVerifiedSellers => '관리자 승인 판매자; 매장 주소 기준 위치.';

  @override
  String get mapNoVerifiedSellers => '인증 판매자 없음. 신청하거나 관리자 승인을 기다리세요.';

  @override
  String get mapAddressNotFound => '지도에서 주소를 찾을 수 없습니다.';

  @override
  String get mapPinMobileOnly => '매장 핀은 Android/iOS 앱에서 사용 가능.';

  @override
  String get mapGeocoding => '좌표 조회 중…';

  @override
  String get mapAwaitingGeocode => '주소 매핑 대기 중…';

  @override
  String get mapSomeAddressesFailed =>
      '일부 주소를 매핑하지 못했습니다. 신청 주소를 수정하거나 나중에 다시 시도하세요.';

  @override
  String mapNearbyPlaces(int count) {
    return '주변 장소 — OSM ($count)';
  }

  @override
  String get mapNoOsmResults => '이 지역에 OSM 결과 없음. 검색어를 변경하세요.';

  @override
  String get demoAddrHomeShort => '케바요란 바루';

  @override
  String get demoAddrOfficeShort => '수디르만';

  @override
  String get demoAddrAptShort => '페자텐 티무르';

  @override
  String get demoAddrParentsShort => '베카시';

  @override
  String get demoAddrHomeFull => '멜라티 12, 케바요란 바루, 자카르타 남부 12120';

  @override
  String get demoAddrOfficeFull => '수디르만 29, 자카르타 남부';

  @override
  String get demoAddrAptFull => '페자텐 티무르 타워 B, 자카르타 남부 12510';

  @override
  String get demoAddrParentsFull => '하라판 인다 F12, 베카시 17123';

  @override
  String get sellerNotifications => '알림';

  @override
  String get rewardSampleShipping => '배송 바우처 15,000루피아';

  @override
  String get rewardSampleDiscount => '10% 할인(최대 5만)';

  @override
  String get rewardSampleBag => '친환경 쇼핑백';

  @override
  String get rewardSampleFeeWaive => '1개월 서비스 수수료 면제';

  @override
  String get rewardSampleShippingDesc => '1회 결제 배송 할인(최소 구매 10만 루피아).';

  @override
  String get rewardSampleDiscountDesc => '패션·전자 카테고리에 적용.';

  @override
  String get rewardSampleBagDesc => 'PreLoved 행사 수령 또는 프로필 주소로 배송.';

  @override
  String get rewardSampleFeeWaiveDesc => '충성 회원 — 판매자 수수료 면제.';

  @override
  String rewardPointCostLine(int cost) {
    return '$cost포인트';
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
  String get homeWeekThriftBest => '이번 주 최고의 중고 가격';

  @override
  String get homeTrustedSellersLine => '신뢰할 수 있는 판매자의 양질의 중고';

  @override
  String get homeExploreUsedBtn => '중고 상품 둘러보기';

  @override
  String get catalogLoadingBanner => '카탈로그 준비 중… 연결이 느릴 때 표시됩니다.';

  @override
  String get wishlistUpdatedSnack => '위시리스트가 업데이트되었습니다';

  @override
  String get searchNoTrending => '아직 인기 검색어가 없습니다.';

  @override
  String get searchPhotoSortHint => '사진 유사도 순';

  @override
  String get searchProductsHint => '상품 검색…';

  @override
  String get orderReviewBtn => '리뷰';

  @override
  String get orderTrackPackage => '배송 추적';

  @override
  String orderTrackingNumber(String number) {
    return '운송장:\n$number';
  }

  @override
  String get orderTrackOrder => '주문 추적';

  @override
  String get orderBuyAgain => '다시 구매';

  @override
  String get orderCancelQ => '주문을 취소할까요?';

  @override
  String get orderCancelBody => '취소된 주문은 복구할 수 없습니다.';

  @override
  String get orderCancelConfirm => '예, 취소';

  @override
  String get orderCancelledSnack => '주문이 취소되었습니다';

  @override
  String get orderCancelBtn => '취소';

  @override
  String get paymentSavedEarth => '지구를 구했습니다';

  @override
  String paymentPointsRule(String total) {
    return '1,000루피아 구매 = 1포인트 · 총 $total';
  }

  @override
  String get paymentOrderProcessing => '판매자가 주문을 처리 중입니다.';

  @override
  String get paymentBackHome => '홈으로';

  @override
  String get paymentViewOrders => '주문 보기';

  @override
  String mapDistanceFromYou(String km) {
    return '약 ${km}km 거리';
  }

  @override
  String get mapWebNominatimUnavailable =>
      '웹에서는 Nominatim 데이터를 사용할 수 없습니다(CORS).';

  @override
  String get shimmerSlowConnection => '로딩 중… 연결이 느릴 수 있습니다.';

  @override
  String get shimmerFetchingSubtitle => '데이터를 가져오는 중… 잠시만 기다려 주세요.';

  @override
  String ordersTabAll(int count) {
    return '전체 ($count)';
  }

  @override
  String ordersTabPending(int count) {
    return '대기 ($count)';
  }

  @override
  String ordersTabCompleted(int count) {
    return '완료 ($count)';
  }

  @override
  String orderTotalAmount(String amount) {
    return '합계 $amount';
  }

  @override
  String get orderStatusCompleted => '완료';

  @override
  String get orderStatusProcessing => '처리 중';

  @override
  String get orderStatusCancelled => '취소됨';

  @override
  String get proSellerBadge => '프로 판매자';

  @override
  String get authInvalidEmail => '이메일 형식이 올바르지 않습니다.';

  @override
  String get authUserDisabled => '비활성화된 계정입니다.';

  @override
  String get authUserNotFound => '등록되지 않은 이메일입니다.';

  @override
  String get authWrongPassword => '비밀번호가 틀렸습니다.';

  @override
  String get authEmailInUse => '이미 사용 중인 이메일입니다. 로그인하세요.';

  @override
  String get authWeakPassword => '비밀번호가 너무 약합니다(6자 이상).';

  @override
  String get authOperationNotAllowed => 'Firebase에서 로그인 방식이 비활성화되어 있습니다.';

  @override
  String get authInvalidCredential => '이메일 또는 비밀번호가 틀렸습니다.';

  @override
  String get authTooManyRequests => '시도가 너무 많습니다. 나중에 다시 시도하세요.';

  @override
  String get authNetworkFailed => '연결 실패. 인터넷을 확인하세요.';

  @override
  String get authAccountExistsDifferent => '다른 방식(예: Google)으로 등록된 이메일입니다.';

  @override
  String get authGoogleSignInFailed =>
      'Google 로그인 실패. SHA-1과 Web Client ID를 확인하세요.';

  @override
  String get authFirebaseNotReady => 'Firebase가 준비되지 않았습니다. 설정 후 앱을 재시작하세요.';

  @override
  String authFailedWithCode(String code) {
    return '인증 실패 ($code).';
  }

  @override
  String get authPlatformGoogleFailed =>
      'Google Sign-In 실패. Firebase에 SHA-1을 추가하세요.';

  @override
  String authPlatformFailedWithCode(String code) {
    return '로그인 실패 ($code).';
  }

  @override
  String get authGoogleSignInCancelled => 'Google 로그인이 취소되었습니다.';

  @override
  String get authGoogleNoEmail => 'Google 계정에 이메일이 없습니다.';

  @override
  String get authGoogleEmptyToken =>
      'Google 토큰이 비어 있습니다. Web Client ID와 google-services.json의 oauth_client를 확인하세요.';

  @override
  String get authGoogleNetworkError => 'Google 로그인 중 연결에 실패했습니다. 인터넷을 확인하세요.';
}
