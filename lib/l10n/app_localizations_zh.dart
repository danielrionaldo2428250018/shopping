// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get home => '首页';

  @override
  String get map => '地图';

  @override
  String get saved => '收藏';

  @override
  String get profile => '个人';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get english => '英语';

  @override
  String get indonesian => '印尼语';

  @override
  String get mandarin => '中文';

  @override
  String get korea => '韩语';

  @override
  String get arab => '阿拉伯语';

  @override
  String get unknownLanguage => '未知语言';

  @override
  String get searchHint => '搜索二手商品、分类...';

  @override
  String get searchWithPhoto => '拍照搜索';

  @override
  String get photoSearchSubtitle => '选择参考图片，Gemini AI 识别商品并匹配目录。';

  @override
  String get photoSearchCardHint => '点击此处或相机图标 — 相册或拍照。';

  @override
  String get chooseFromGallery => '从相册选择';

  @override
  String get takePhotoNow => '立即拍照';

  @override
  String get cancel => '取消';

  @override
  String get later => '稍后';

  @override
  String get save => '保存';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get ok => '确定';

  @override
  String get retry => '重试';

  @override
  String get seeAll => '查看全部';

  @override
  String get loading => '加载中…';

  @override
  String get continueRequestPermission => '继续并请求权限';

  @override
  String get notificationPermissionTitle => '通知权限';

  @override
  String notificationPermissionBody(String appName) {
    return '要在后台接收订单和消息更新，请为 $appName 开启通知。';
  }

  @override
  String get galleryPermissionRequired => '需要相册权限。';

  @override
  String get cameraPermissionRequired => '需要相机权限。';

  @override
  String get aiMatchingPhoto => 'AI 分析照片';

  @override
  String get aiMatchingSubtitle => 'Gemini 正在识别商品…';

  @override
  String photoSearchFailed(String error) {
    return '搜索失败：$error';
  }

  @override
  String photoSearchQuery(String query) {
    return '图片搜索：$query';
  }

  @override
  String get genericPhotoSearch => '图片搜索';

  @override
  String get trendingNow => '热门';

  @override
  String get recentSearches => '最近搜索';

  @override
  String get clearAll => '清除全部';

  @override
  String get noRecentSearches => '暂无搜索';

  @override
  String get messages => '消息';

  @override
  String get noConversations => '暂无对话。';

  @override
  String get inboxEmptyHint => '订单、促销和推送消息将显示在这里。';

  @override
  String get requestNotificationAgain => '再次请求通知权限';

  @override
  String get notificationRequestSent => '已发送通知权限请求。';

  @override
  String get searchPhotoTooltip => '拍照搜索';

  @override
  String get pushNotifications => '推送通知';

  @override
  String get pushNotificationsSubtitle => '消息与促销 (FCM)';

  @override
  String get settingsSubtitle => '管理账户与偏好';

  @override
  String get appearance => '外观';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get admin => '管理';

  @override
  String get adminSellerApps => '卖家申请';

  @override
  String get adminRewards => '管理奖励券';

  @override
  String get accountSection => '账户';

  @override
  String get editProfile => '编辑资料';

  @override
  String get becomeSeller => '成为卖家';

  @override
  String get logout => '退出登录';

  @override
  String get helpSupport => '帮助与支持';

  @override
  String get aboutApp => '关于应用';

  @override
  String get welcomeBack => '欢迎回来！';

  @override
  String get signInSubtitle => '登录以继续购物';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get signIn => '登录';

  @override
  String get orContinueWith => '或使用';

  @override
  String get continueWithGoogle => 'Google 登录';

  @override
  String get noAccount => '没有账户？';

  @override
  String get signUp => '注册';

  @override
  String get createAccount => '创建账户';

  @override
  String get registerSubtitle => '加入并开始买卖二手好物';

  @override
  String get fullName => '姓名';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get passwordMinHint => '至少 6 个字符';

  @override
  String get termsPrivacy => '我同意条款与隐私';

  @override
  String get haveAccount => '已有账户？';

  @override
  String get fillEmailPassword => '请填写邮箱和密码。';

  @override
  String get fillNameEmail => '请填写姓名和邮箱。';

  @override
  String get passwordMismatch => '两次密码不一致。';

  @override
  String get accountCreated => '账户创建成功。';

  @override
  String get googleSignInSuccess => 'Google 登录成功。';

  @override
  String get authRequiredTitle => '需要登录';

  @override
  String get authRequiredBody => '请登录或注册以使用此功能。';

  @override
  String get signInToContinue => '登录以继续';

  @override
  String get featuredForYou => '为你推荐';

  @override
  String get shopByCategory => '按分类浏览';

  @override
  String get catElectronics => '电子';

  @override
  String get catFashion => '时尚';

  @override
  String get catHome => '家居';

  @override
  String get catSports => '运动';

  @override
  String get noProductsYet => '暂无商品';

  @override
  String get noProductsHint => '成为第一个发布二手商品的人。';

  @override
  String productCount(int count) {
    return '$count 件商品';
  }

  @override
  String get addProduct => '添加商品';

  @override
  String get addNewProduct => '新商品';

  @override
  String get addProductPhotoHint => '最多 8 张 • 第一张为封面';

  @override
  String get productInfo => '商品信息';

  @override
  String get productName => '商品名称';

  @override
  String get selectCategory => '选择分类';

  @override
  String get priceLabel => '价格';

  @override
  String get stock => '库存';

  @override
  String get description => '描述';

  @override
  String get condition => '成色';

  @override
  String get condBrandNew => '全新';

  @override
  String get condLikeNew => '几乎全新';

  @override
  String get condGood => '良好';

  @override
  String get condFair => '一般';

  @override
  String get publishProduct => '发布';

  @override
  String get productPublished => '已发布';

  @override
  String get publishFailed => '保存失败。';

  @override
  String get productNameRequired => '请填写商品名称';

  @override
  String get categoryRequired => '请选择分类';

  @override
  String get priceRequired => '价格必须大于 0';

  @override
  String get stockRequired => '库存至少为 1';

  @override
  String get myStore => '我的店铺';

  @override
  String get storePerformance => '店铺表现';

  @override
  String get thisMonth => '本月';

  @override
  String get productsLabel => '商品';

  @override
  String get noStoreProducts => '暂无商品';

  @override
  String get noStoreProductsHint => '通过添加商品上架。';

  @override
  String get viewAll => '查看全部';

  @override
  String get active => '在售';

  @override
  String get outOfStock => '缺货';

  @override
  String soldCount(String label) {
    return '已售：$label';
  }

  @override
  String get orders => '订单';

  @override
  String get myOrders => '我的订单';

  @override
  String get noOrders => '暂无订单';

  @override
  String get cart => '购物车';

  @override
  String get emptyCart => '购物车为空';

  @override
  String get checkout => '结算';

  @override
  String get buyNow => '立即购买';

  @override
  String get addToCart => '加入购物车';

  @override
  String get productDetails => '商品详情';

  @override
  String get productNotFound => '未找到商品';

  @override
  String get chat => '聊天';

  @override
  String get chats => '聊天列表';

  @override
  String get noChats => '暂无聊天';

  @override
  String get nearbyStores => '附近店铺';

  @override
  String get favorites => '收藏';

  @override
  String get emptyFavorites => '暂无收藏';

  @override
  String get searchResults => '搜索结果';

  @override
  String get sortRelevance => '相关度';

  @override
  String get sortPriceLow => '价格从低到高';

  @override
  String get sortPriceHigh => '价格从高到低';

  @override
  String get conversationNotFound => '未找到对话';

  @override
  String get typeMessage => '输入消息…';

  @override
  String get send => '发送';

  @override
  String get loyaltyRewards => '积分与奖励';

  @override
  String get reviews => '评价';

  @override
  String get paymentSuccess => '支付成功';

  @override
  String get thankYouPurchase => '感谢购买！🌱';

  @override
  String pointsEarned(int points) {
    return '+$points 积分';
  }

  @override
  String resetPasswordSent(String email) {
    return '重置链接已发送至 $email';
  }

  @override
  String get enterEmailForReset => '请在上方输入邮箱以重置密码。';

  @override
  String get splashTagline => '环保二手市集';

  @override
  String get onboardingSellTitle => '出售闲置物品';

  @override
  String get onboardingSellSubtitle => '轻松把闲置变成收入。';

  @override
  String get onboardingBuyTitle => '发现优质好物';

  @override
  String get onboardingBuySubtitle => '购买附近可信的二手商品。';

  @override
  String get onboardingEcoTitle => '环保友好';

  @override
  String get onboardingEcoSubtitle => '减少浪费，支持可持续购物。';

  @override
  String get skip => '跳过';

  @override
  String get next => '下一步';

  @override
  String get getStarted => '开始';

  @override
  String get back => '返回';

  @override
  String get close => '关闭';

  @override
  String get understand => '知道了';

  @override
  String get apply => '应用';

  @override
  String get reset => '重置';

  @override
  String get sort => '排序';

  @override
  String get startShopping => '开始购物';

  @override
  String get startShoppingHint => '添加您喜欢的商品';

  @override
  String get details => '详情';

  @override
  String get viewLabel => '查看';

  @override
  String get today => '今天';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get changeProfilePhoto => '更换头像';

  @override
  String get profilePhotoUpdated => '头像已更新';

  @override
  String get profilePhotoFailed => '保存照片失败';

  @override
  String get profileSaved => '资料已保存';

  @override
  String get saveChanges => '保存更改';

  @override
  String get nameRequired => '请填写姓名';

  @override
  String get emailRequired => '请填写邮箱';

  @override
  String get emailInvalid => '邮箱格式无效';

  @override
  String get phoneMinDigits => '至少需要 10 位数字';

  @override
  String get phoneOrderHint => '电话号码用于订单和配送验证。';

  @override
  String get shippingSection => '配送';

  @override
  String get deliveryAddress => '收货地址';

  @override
  String get selectAddress => '选择地址';

  @override
  String get addressHome => '家（默认）';

  @override
  String get addressOffice => '办公室';

  @override
  String get addressApartment => '公寓';

  @override
  String get addressParents => '父母地址';

  @override
  String get paymentMethod => '支付方式';

  @override
  String get paymentMethodSubtitle => '虚拟账户、电子钱包、银行卡或货到付款';

  @override
  String get orderSummary => '摘要';

  @override
  String get totalPayment => '支付总额';

  @override
  String get promoCode => '优惠码';

  @override
  String get applyPromo => '应用';

  @override
  String get shippingReguler => '标准';

  @override
  String get shippingExpress => '加急';

  @override
  String get shippingEtaReguler => '2–3 个工作日';

  @override
  String get shippingEtaExpress => '1 个工作日';

  @override
  String subtotalLine(int count) {
    return '小计（$count 件）';
  }

  @override
  String shippingFeeLine(String method) {
    return '运费（$method）';
  }

  @override
  String get paymentLine => '支付';

  @override
  String stockLeft(int count) {
    return '库存 $count';
  }

  @override
  String get payBcaVa => 'BCA 虚拟账户';

  @override
  String get payMandiriVa => 'Mandiri 虚拟账户';

  @override
  String get payBniVa => 'BNI 虚拟账户';

  @override
  String get payOvo => 'OVO';

  @override
  String get payGopay => 'GoPay';

  @override
  String get payDana => 'DANA';

  @override
  String get payShopeePay => 'ShopeePay';

  @override
  String get payCard => '信用卡 / 借记卡';

  @override
  String get payCardSubtitle => 'Visa、Mastercard、JCB';

  @override
  String get payCod => '货到付款';

  @override
  String get payAutoVerify => '自动验证';

  @override
  String get phoneRequiredTitle => '需要电话号码';

  @override
  String get phoneHint => '08xx 或 +62…';

  @override
  String get saveAndContinue => '保存并继续';

  @override
  String get sortWishlist => '收藏排序';

  @override
  String get viewSellerStore => '查看卖家店铺';

  @override
  String get searchInChat => '在聊天中搜索';

  @override
  String get searchMessages => '搜索消息';

  @override
  String get keywordHint => '关键词…';

  @override
  String get mediaAndPhotos => '媒体与照片';

  @override
  String get noPhotosInChat => '此聊天中尚无照片。';

  @override
  String get muteChatNotif => '静音聊天通知';

  @override
  String get muteChatDemo => '聊天通知已静音（演示）';

  @override
  String get deleteConversation => '删除对话';

  @override
  String get deleteConversationQ => '删除对话？';

  @override
  String get deleteHistoryHint => '此设备上的消息记录将被清除。';

  @override
  String get reportConversation => '举报对话';

  @override
  String get reportSentDemo => '举报已发送（演示）';

  @override
  String get blockSeller => '屏蔽卖家';

  @override
  String get blockSellerDemo => '卖家已屏蔽（演示）';

  @override
  String get noMessagesYet => '暂无消息。';

  @override
  String get noSearchInChat => '没有匹配搜索的消息。';

  @override
  String get productNotLinked => '商品未关联目录';

  @override
  String get sendPhoto => '发送照片';

  @override
  String get adminSellerDesc => '审批 / 拒绝卖家申请';

  @override
  String get changePassword => '修改密码';

  @override
  String get changePasswordHint => '在登录页使用「忘记密码」，或通过 Firebase 邮件重置。';

  @override
  String get privacySecurity => '隐私与安全';

  @override
  String get privacySecurityDesc => '保护您的账户和数据';

  @override
  String get paymentMethods => '支付方式';

  @override
  String get paymentMethodsDesc => '银行卡与电子钱包';

  @override
  String get notificationsSection => '通知';

  @override
  String get emailNotifications => '邮件通知';

  @override
  String get smsNotifications => '短信通知';

  @override
  String get appPreferences => '应用偏好';

  @override
  String get darkMode => '深色模式';

  @override
  String get locationAccess => '位置访问';

  @override
  String get fingerprintAuth => '指纹认证';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicyDesc => '阅读我们的隐私条款';

  @override
  String get helpSupportDesc => '获取帮助';

  @override
  String get signOutQ => '退出登录？';

  @override
  String get signOutDesc => '退出您的账户';

  @override
  String get appVersion => '版本 1.0.0 • 用心制作 ❤️';

  @override
  String get submitApplication => '提交申请';

  @override
  String get becomeSellerTagline => '向附近买家出售您的二手商品';

  @override
  String get storeLogo => '店铺标志';

  @override
  String get uploadLogo => '上传标志';

  @override
  String get uploadLogoHint => 'PNG、JPG 最大 5MB';

  @override
  String get uploadLogoWebHint => '网页版无法上传标志（演示）。';

  @override
  String get storeInformation => '店铺信息';

  @override
  String get storeName => '店铺名称';

  @override
  String get storeNameHint => '输入店铺名称';

  @override
  String get storeDescription => '店铺描述';

  @override
  String get storeDescriptionHint => '向顾客介绍您的店铺…';

  @override
  String get contactInformation => '联系信息';

  @override
  String get emailHint => 'store@example.com';

  @override
  String get storeAddress => '店铺地址';

  @override
  String get streetAddress => '街道地址';

  @override
  String get streetHint => '输入店铺地址';

  @override
  String get cityHint => '输入城市';

  @override
  String get sellerAgreement => '卖家协议';

  @override
  String get sellerAgreementBody => '成为卖家即表示您同意我们的条款和卖家政策。您负责管理商品、订单和客户服务。';

  @override
  String get agreeTerms => '我同意 ';

  @override
  String get termsConditions => '条款与条件';

  @override
  String get sellerPolicy => '卖家政策';

  @override
  String get fillAllFields => '请填写所有字段并接受协议。';

  @override
  String get applicationSent => '申请已提交，管理员将审核。';

  @override
  String get applicationSentLocalFallback =>
      '仅保存在本设备。请部署 Firestore 规则（firestore.rules）以同步云端。';

  @override
  String get sellerEmailMustMatchAccount => '申请邮箱必须与当前登录账号邮箱一致。';

  @override
  String sendFailed(String error) {
    return '发送失败：$error';
  }

  @override
  String get approveApplicationQ => '批准申请？';

  @override
  String approveApplicationBody(String store, String email) {
    return '店铺：$store\n邮箱：$email\n用户使用此邮箱登录后即可销售。';
  }

  @override
  String get yesApprove => '是，批准';

  @override
  String approveFailed(String error) {
    return '批准失败：$error';
  }

  @override
  String get applicationApproved => '申请已批准。';

  @override
  String get rejectApplicationQ => '拒绝申请？';

  @override
  String get rejectReasonHint => '原因（可选）';

  @override
  String rejectFailed(String error) {
    return '拒绝失败：$error';
  }

  @override
  String get applicationRejected => '申请已拒绝。';

  @override
  String get tabApproved => '已批准';

  @override
  String get noDataYet => '暂无数据';

  @override
  String get notFound => '未找到';

  @override
  String get applicationNotFound => '未找到申请数据。';

  @override
  String get storeInfo => '店铺信息';

  @override
  String get administration => '管理';

  @override
  String get agreeTermsLabel => '已同意条款';

  @override
  String get rejectReason => '拒绝原因';

  @override
  String get approveBtn => '批准申请';

  @override
  String get localModeHint => '本地模式：数据保存在设备上。连接 Firebase 可与管理面板同步。';

  @override
  String sentOn(String date) {
    return '发送：$date';
  }

  @override
  String get addReward => '添加奖励';

  @override
  String get noRewardsAdmin => '暂无奖励。';

  @override
  String get activeInactive => '启用 / 停用';

  @override
  String get rewardDescription => '描述';

  @override
  String get rewardPointCost => '费用（积分）';

  @override
  String get voucherCodeOptional => '优惠券码（可选）';

  @override
  String get redeem => '兑换';

  @override
  String get notEnoughPoints => '积分不足以兑换此奖励。';

  @override
  String redeemConfirm(int cost, String desc) {
    return '兑换 $cost 积分？\n\n$desc';
  }

  @override
  String redeemSuccess(String extra) {
    return '兑换成功！$extra';
  }

  @override
  String get rewardsAvailable => '可用奖励';

  @override
  String get noActiveRewards => '管理员暂无活跃奖励。';

  @override
  String get redemptionHistory => '兑换记录';

  @override
  String voucherLine(String code, int cost) {
    return '码：$code · -$cost 积分';
  }

  @override
  String levelLine(int level, String name) {
    return '等级 $level · $name';
  }

  @override
  String get pointsAvailable => '可用积分';

  @override
  String lifetimePoints(int points) {
    return '累计总计：$points 积分';
  }

  @override
  String pointsToNext(String name, int remaining) {
    return '距 $name：还需 $remaining 积分';
  }

  @override
  String get maxLevelReached => '已达最高等级！';

  @override
  String get cannotOpenBrowser => '无法打开浏览器';

  @override
  String get liveChat => '在线客服';

  @override
  String get contactEmail => '联系邮箱';

  @override
  String get reportProblem => '报告问题';

  @override
  String get helpTitle => '我们能帮您什么？';

  @override
  String get helpSubtitle => '我们随时为您解决问题';

  @override
  String get catAccessories => '配饰';

  @override
  String get catFurniture => '家具';

  @override
  String get makeOffer => '出价';

  @override
  String get offerSubmitted => '出价已提交';

  @override
  String get submitOffer => '提交出价';

  @override
  String get currentPrice => '当前价格';

  @override
  String get yourOffer => '您的出价';

  @override
  String get enterOffer => '输入出价';

  @override
  String get sellerMayRespond => '卖家可接受或拒绝您的出价。';

  @override
  String get addPaymentMethod => '添加支付方式';

  @override
  String get addPaymentMethodDemo => '添加方式（演示）';

  @override
  String paymentSelectedDemo(String method) {
    return '已选择 $method（演示）';
  }

  @override
  String get productImages => '商品图片';

  @override
  String get monthlyTarget => '月度目标完成 65%';

  @override
  String orderDate(String date) {
    return '日期：$date';
  }

  @override
  String orderStatus(String status) {
    return '状态：$status';
  }

  @override
  String trackingNumber(String number) {
    return '运单：$number';
  }

  @override
  String get wishlist => '心愿单';

  @override
  String get changePasswordTitle => '修改密码';

  @override
  String get changeProfileInfo => '修改您的资料信息';

  @override
  String get reviewSample1 => '商品与描述一致，卖家响应及时。';

  @override
  String get reviewSample2 => '发货快，物品状况良好。';

  @override
  String get reviewSample3 => '推荐卖家 👍';

  @override
  String get demoChatHello => '你好，这件商品还有货吗？';

  @override
  String get demoChatYes => '你好！有的，还有库存 👍';

  @override
  String get demoChatNegotiate => '运费能优惠一点吗？';

  @override
  String get demoChatShipping => '可以，大雅加达地区我们补贴更多运费。';

  @override
  String get tabPending => '待处理';

  @override
  String get tabRejected => '已拒绝';

  @override
  String get nameLabel => '姓名';

  @override
  String get phoneLabel => '电话';

  @override
  String get streetLabel => '街道';

  @override
  String get cityLabel => '城市';

  @override
  String get statusLabel => '状态';

  @override
  String get reviewedLabel => '已审核';

  @override
  String get approveShort => '批准';

  @override
  String get rejectShort => '拒绝';

  @override
  String get catalogEmptyOrInvalid => '目录为空或商品 ID 无效。';

  @override
  String get chatSellerTooltip => '联系卖家';

  @override
  String get freeShipping => '免运费';

  @override
  String get estimatedDelivery => '预计送达 2–3 天';

  @override
  String get inStock => '有货';

  @override
  String get priceDisplay => '价格';

  @override
  String get adminPanelWeb => '管理面板（网页）';

  @override
  String openManualUrl(String url) {
    return '手动打开：$url';
  }

  @override
  String get locationDeniedSystem => '位置权限被拒绝。请在系统设置中开启。';

  @override
  String get biometricEnabledDemo => '生物识别已启用（演示 — 正式版需原生集成）';

  @override
  String get biometricDisabledDemo => '生物识别已关闭';

  @override
  String get discountLabel => '折扣';

  @override
  String get voucherNotRecognized => '优惠码无效。请尝试 NEARMARKET10 或 GRATISONGKIR';

  @override
  String get voucherPromoHint => 'NEARMARKET10（9折，最高5万）· GRATISONGKIR';

  @override
  String get onlineStatus => '在线';

  @override
  String get offlineStatus => '离线';

  @override
  String get homeHeroTagline => '二手好物，新故事';

  @override
  String get homeHeroSubtitle => '发现身边优质二手商品';

  @override
  String get appBrandName => 'PreLoved';

  @override
  String get defaultDisplayName => 'PreLoved 用户';

  @override
  String sortOrderLabel(String sort) {
    return '排序：$sort';
  }

  @override
  String get productNewNotification => 'PreLoved 新商品';

  @override
  String get storeNewNotification => 'PreLoved 新店铺';

  @override
  String get openRelatedPage => '打开相关页面';

  @override
  String get mapRequestingLocation => '正在请求位置权限…';

  @override
  String get mapLoadOsmFailed => '加载 OSM 数据失败，请检查网络。';

  @override
  String get mapLocationDeniedFallback => '位置被拒绝 — 显示雅加达地图。开启权限可显示您的位置。';

  @override
  String get mapGpsOffFallback => 'GPS 关闭 — 显示雅加达。请开启定位服务。';

  @override
  String get mapGpsFailedFallback => 'GPS 失败 — 回退雅加达。';

  @override
  String mapCoords(String coords) {
    return '坐标：$coords';
  }

  @override
  String get mapWebCorsHint => '网页版：Nominatim 被 CORS 阻止 — 请使用 Android/iOS 应用。';

  @override
  String get mapSellersTitle => '地图与卖家店铺';

  @override
  String get mapLegendHint => '铜色钉 = 认证卖家 · 灰色 = 周边 OSM 地点';

  @override
  String get mapSearchingSellers => '正在地图上搜索卖家位置…';

  @override
  String get mapLoadingNominatim => '正在从 Nominatim 加载点位…';

  @override
  String get mapOsmAttribution => '地图：OSM · 地址：Nominatim（请遵守使用政策）。';

  @override
  String get mapSearchPlacesHint => '搜索 OSM 地点类型（如餐厅、超市）';

  @override
  String get mapOpenOsmTooltip => '在 openstreetmap.org 打开';

  @override
  String get mapVerifiedSellers => '管理员已批准的卖家；位置来自店铺地址。';

  @override
  String get mapNoVerifiedSellers => '尚无认证卖家。请申请或等待管理员批准。';

  @override
  String get mapAddressNotFound => '地图上未找到该地址（请检查街道和城市）。';

  @override
  String get mapPinMobileOnly => '店铺地图钉仅在 Android/iOS 应用可用。';

  @override
  String get mapGeocoding => '正在查询坐标…';

  @override
  String get mapAwaitingGeocode => '等待地址映射…';

  @override
  String get mapSomeAddressesFailed => '部分地址无法自动映射。请修改申请地址或稍后重试。';

  @override
  String mapNearbyPlaces(int count) {
    return '周边地点 — OSM（$count）';
  }

  @override
  String get mapNoOsmResults => '此区域无 OSM 结果。请更改搜索关键词。';

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
      'Jl. Melati No. 12, Kebayoran Baru, 南雅加达 12120';

  @override
  String get demoAddrOfficeFull => 'Jl. Sudirman Kav 29, 南雅加达';

  @override
  String get demoAddrAptFull => 'Pejaten Timur Tower B, 南雅加达 12510';

  @override
  String get demoAddrParentsFull => 'Harapan Indah F12, Bekasi 17123';

  @override
  String get sellerNotifications => '通知';

  @override
  String get rewardSampleShipping => '运费券 15,000 卢比';

  @override
  String get rewardSampleDiscount => '9折（最高5万）';

  @override
  String get rewardSampleBag => '环保购物袋';

  @override
  String get rewardSampleFeeWaive => '免服务费 1 个月';

  @override
  String get homePrelovedDeal => 'PRELOVED DEAL';

  @override
  String get homeWeekThriftBest => '本周最佳二手价';

  @override
  String get homeTrustedSellersLine => '来自可信卖家的优质二手';

  @override
  String get homeExploreUsedBtn => '浏览二手好物';

  @override
  String get catalogLoadingBanner => '正在准备目录… 网络较慢时显示。';

  @override
  String get wishlistUpdatedSnack => '心愿单已更新';

  @override
  String get searchNoTrending => '暂无热门关键词。';

  @override
  String get searchPhotoSortHint => '按图片相似度排序';

  @override
  String get searchProductsHint => '搜索商品…';

  @override
  String get orderReviewBtn => '评价';

  @override
  String get orderTrackPackage => '追踪包裹';

  @override
  String orderTrackingNumber(String number) {
    return '运单号：\n$number';
  }

  @override
  String get orderTrackOrder => '追踪订单';

  @override
  String get orderBuyAgain => '再次购买';

  @override
  String get orderCancelQ => '取消订单？';

  @override
  String get orderCancelBody => '已取消的订单无法恢复。';

  @override
  String get orderCancelConfirm => '是的，取消';

  @override
  String get orderCancelledSnack => '订单已取消';

  @override
  String get orderCancelBtn => '取消';

  @override
  String get paymentSavedEarth => '您为地球出了一份力';

  @override
  String paymentPointsRule(String total) {
    return '每消费 1000 卢比 = 1 积分 · 总计 $total';
  }

  @override
  String get paymentOrderProcessing => '卖家正在处理您的订单。';

  @override
  String get paymentBackHome => '返回首页';

  @override
  String get paymentViewOrders => '查看订单';

  @override
  String mapDistanceFromYou(String km) {
    return '距您约 $km 公里';
  }

  @override
  String get mapWebNominatimUnavailable => '网页版无法使用 Nominatim 数据（CORS）。';

  @override
  String get shimmerSlowConnection => '加载中… 网络可能较慢。';

  @override
  String get shimmerFetchingSubtitle => '正在获取数据… 请稍候。';

  @override
  String ordersTabAll(int count) {
    return '全部 ($count)';
  }

  @override
  String ordersTabPending(int count) {
    return '待处理 ($count)';
  }

  @override
  String ordersTabCompleted(int count) {
    return '已完成 ($count)';
  }

  @override
  String orderTotalAmount(String amount) {
    return '合计 $amount';
  }

  @override
  String get orderStatusCompleted => '已完成';

  @override
  String get orderStatusProcessing => '处理中';

  @override
  String get orderStatusCancelled => '已取消';

  @override
  String get proSellerBadge => '专业卖家';

  @override
  String get authInvalidEmail => '邮箱格式无效。';

  @override
  String get authUserDisabled => '此账号已停用。';

  @override
  String get authUserNotFound => '邮箱未注册。';

  @override
  String get authWrongPassword => '密码错误。';

  @override
  String get authEmailInUse => '邮箱已被使用，请尝试登录。';

  @override
  String get authWeakPassword => '密码太弱（至少6位）。';

  @override
  String get authOperationNotAllowed => 'Firebase 未启用此登录方式。';

  @override
  String get authInvalidCredential => '邮箱或密码错误。';

  @override
  String get authTooManyRequests => '尝试次数过多，请稍后再试。';

  @override
  String get authNetworkFailed => '连接失败，请检查网络。';

  @override
  String get authAccountExistsDifferent => '该邮箱已通过其他方式注册（如 Google）。';

  @override
  String get authGoogleSignInFailed => 'Google 登录失败，请检查 SHA-1 与 Web Client ID。';

  @override
  String get authFirebaseNotReady => 'Firebase 未就绪，配置后请重启应用。';

  @override
  String authFailedWithCode(String code) {
    return '认证失败（$code）。';
  }

  @override
  String get authPlatformGoogleFailed => 'Google 登录失败，请在 Firebase 添加 SHA-1。';

  @override
  String authPlatformFailedWithCode(String code) {
    return '登录失败（$code）。';
  }
}
