import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

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
    Locale('ar'),
    Locale('en'),
    Locale('id'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @home.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get home;

  /// No description provided for @map.
  ///
  /// In id, this message translates to:
  /// **'Peta'**
  String get map;

  /// No description provided for @saved.
  ///
  /// In id, this message translates to:
  /// **'Favorit'**
  String get saved;

  /// No description provided for @profile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @english.
  ///
  /// In id, this message translates to:
  /// **'Inggris'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get indonesian;

  /// No description provided for @mandarin.
  ///
  /// In id, this message translates to:
  /// **'Mandarin'**
  String get mandarin;

  /// No description provided for @korea.
  ///
  /// In id, this message translates to:
  /// **'Korea'**
  String get korea;

  /// No description provided for @arab.
  ///
  /// In id, this message translates to:
  /// **'Arab'**
  String get arab;

  /// No description provided for @unknownLanguage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa tidak dikenal'**
  String get unknownLanguage;

  /// No description provided for @searchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari barang bekas, kategori...'**
  String get searchHint;

  /// No description provided for @searchWithPhoto.
  ///
  /// In id, this message translates to:
  /// **'Cari dengan foto'**
  String get searchWithPhoto;

  /// No description provided for @photoSearchSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih gambar referensi. AI Gemini mengenali barang lalu mencocokkan dengan katalog.'**
  String get photoSearchSubtitle;

  /// No description provided for @photoSearchCardHint.
  ///
  /// In id, this message translates to:
  /// **'Ketuk di sini atau ikon kamera — galeri atau foto baru.'**
  String get photoSearchCardHint;

  /// No description provided for @chooseFromGallery.
  ///
  /// In id, this message translates to:
  /// **'Pilih dari galeri'**
  String get chooseFromGallery;

  /// No description provided for @takePhotoNow.
  ///
  /// In id, this message translates to:
  /// **'Ambil foto sekarang'**
  String get takePhotoNow;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @later.
  ///
  /// In id, this message translates to:
  /// **'Nanti'**
  String get later;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get delete;

  /// No description provided for @yes.
  ///
  /// In id, this message translates to:
  /// **'Ya'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In id, this message translates to:
  /// **'Tidak'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In id, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get retry;

  /// No description provided for @seeAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat semua'**
  String get seeAll;

  /// No description provided for @loading.
  ///
  /// In id, this message translates to:
  /// **'Memuat…'**
  String get loading;

  /// No description provided for @continueRequestPermission.
  ///
  /// In id, this message translates to:
  /// **'Lanjut & minta izin'**
  String get continueRequestPermission;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In id, this message translates to:
  /// **'Izin notifikasi'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionBody.
  ///
  /// In id, this message translates to:
  /// **'Agar pesan & update bisa mengingatkan Anda saat aplikasi di latar, aktifkan notifikasi untuk {appName}. Anda bisa menolak — pesan tetap di aplikasi.'**
  String notificationPermissionBody(String appName);

  /// No description provided for @galleryPermissionRequired.
  ///
  /// In id, this message translates to:
  /// **'Izin galeri diperlukan untuk memilih gambar.'**
  String get galleryPermissionRequired;

  /// No description provided for @galleryPermissionOpenSettings.
  ///
  /// In id, this message translates to:
  /// **'Akses galeri diblokir. Buka pengaturan aplikasi untuk mengizinkan foto.'**
  String get galleryPermissionOpenSettings;

  /// No description provided for @productPhotosMax.
  ///
  /// In id, this message translates to:
  /// **'Maksimal {count} foto per produk.'**
  String productPhotosMax(int count);

  /// No description provided for @productPhotosAdded.
  ///
  /// In id, this message translates to:
  /// **'{count} foto ditambahkan.'**
  String productPhotosAdded(int count);

  /// No description provided for @productPhotoRequired.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan minimal satu foto produk.'**
  String get productPhotoRequired;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In id, this message translates to:
  /// **'Izin kamera diperlukan untuk mengambil foto.'**
  String get cameraPermissionRequired;

  /// No description provided for @aiMatchingPhoto.
  ///
  /// In id, this message translates to:
  /// **'Menganalisis foto dengan AI'**
  String get aiMatchingPhoto;

  /// No description provided for @aiMatchingSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Gemini mengenali barang… hasil segera muncul.'**
  String get aiMatchingSubtitle;

  /// No description provided for @photoSearchFailed.
  ///
  /// In id, this message translates to:
  /// **'Pencarian foto gagal: {error}'**
  String photoSearchFailed(String error);

  /// No description provided for @photoSearchQuery.
  ///
  /// In id, this message translates to:
  /// **'Pencarian foto: {query}'**
  String photoSearchQuery(String query);

  /// No description provided for @genericPhotoSearch.
  ///
  /// In id, this message translates to:
  /// **'Pencarian foto'**
  String get genericPhotoSearch;

  /// No description provided for @trendingNow.
  ///
  /// In id, this message translates to:
  /// **'Sedang tren'**
  String get trendingNow;

  /// No description provided for @recentSearches.
  ///
  /// In id, this message translates to:
  /// **'Pencarian terakhir'**
  String get recentSearches;

  /// No description provided for @clearAll.
  ///
  /// In id, this message translates to:
  /// **'Hapus semua'**
  String get clearAll;

  /// No description provided for @noRecentSearches.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pencarian'**
  String get noRecentSearches;

  /// No description provided for @messages.
  ///
  /// In id, this message translates to:
  /// **'Pesan'**
  String get messages;

  /// No description provided for @noConversations.
  ///
  /// In id, this message translates to:
  /// **'Belum ada percakapan.'**
  String get noConversations;

  /// No description provided for @inboxEmptyHint.
  ///
  /// In id, this message translates to:
  /// **'Pesan dari pesanan, promo, atau push akan muncul di sini.'**
  String get inboxEmptyHint;

  /// No description provided for @chatListEmptyHint.
  ///
  /// In id, this message translates to:
  /// **'Belum ada obrolan. Buka produk, lalu ketuk Chat dengan penjual untuk memulai.'**
  String get chatListEmptyHint;

  /// No description provided for @chatStartHint.
  ///
  /// In id, this message translates to:
  /// **'Ketik pesan di bawah untuk memulai obrolan dengan penjual.'**
  String get chatStartHint;

  /// No description provided for @signInToChat.
  ///
  /// In id, this message translates to:
  /// **'Masuk dulu untuk mengirim pesan.'**
  String get signInToChat;

  /// No description provided for @notificationsSection.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get notificationsSection;

  /// No description provided for @chatHistoryLocalOnly.
  ///
  /// In id, this message translates to:
  /// **'Riwayat obrolan disimpan di cloud; hapus lokal tidak menghapus pesan di server.'**
  String get chatHistoryLocalOnly;

  /// No description provided for @chatImageComingSoon.
  ///
  /// In id, this message translates to:
  /// **'Kirim foto di chat akan hadir di versi berikutnya.'**
  String get chatImageComingSoon;

  /// No description provided for @requestNotificationAgain.
  ///
  /// In id, this message translates to:
  /// **'Minta izin notifikasi lagi'**
  String get requestNotificationAgain;

  /// No description provided for @notificationRequestSent.
  ///
  /// In id, this message translates to:
  /// **'Permintaan izin notifikasi dikirim.'**
  String get notificationRequestSent;

  /// No description provided for @searchPhotoTooltip.
  ///
  /// In id, this message translates to:
  /// **'Cari dengan foto (galeri / kamera)'**
  String get searchPhotoTooltip;

  /// No description provided for @pushNotifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi push'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pesan & promo (FCM)'**
  String get pushNotificationsSubtitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kelola akun dan preferensi Anda'**
  String get settingsSubtitle;

  /// No description provided for @appearance.
  ///
  /// In id, this message translates to:
  /// **'Tampilan'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikuti sistem'**
  String get themeSystem;

  /// No description provided for @admin.
  ///
  /// In id, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @adminSellerApps.
  ///
  /// In id, this message translates to:
  /// **'Pengajuan penjual'**
  String get adminSellerApps;

  /// No description provided for @adminRewards.
  ///
  /// In id, this message translates to:
  /// **'Kelola voucher hadiah'**
  String get adminRewards;

  /// No description provided for @accountSection.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get accountSection;

  /// No description provided for @editProfile.
  ///
  /// In id, this message translates to:
  /// **'Ubah profil'**
  String get editProfile;

  /// No description provided for @becomeSeller.
  ///
  /// In id, this message translates to:
  /// **'Jadi penjual'**
  String get becomeSeller;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @helpSupport.
  ///
  /// In id, this message translates to:
  /// **'Bantuan & dukungan'**
  String get helpSupport;

  /// No description provided for @aboutApp.
  ///
  /// In id, this message translates to:
  /// **'Tentang aplikasi'**
  String get aboutApp;

  /// No description provided for @welcomeBack.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang kembali!'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk untuk lanjut berbelanja'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In id, this message translates to:
  /// **'Lupa kata sandi?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In id, this message translates to:
  /// **'Lupa kata sandi'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In id, this message translates to:
  /// **'Masukkan email akun Anda. Kami akan mengirim link reset kata sandi dari Firebase ke kotak masuk email.'**
  String get forgotPasswordBody;

  /// No description provided for @sendResetEmail.
  ///
  /// In id, this message translates to:
  /// **'Kirim link reset'**
  String get sendResetEmail;

  /// No description provided for @backToLogin.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke login'**
  String get backToLogin;

  /// No description provided for @currentPassword.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi saat ini'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi baru'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi kata sandi baru'**
  String get confirmNewPassword;

  /// No description provided for @newPasswordMismatch.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi kata sandi baru tidak cocok.'**
  String get newPasswordMismatch;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi berhasil diubah.'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordGoogleOnly.
  ///
  /// In id, this message translates to:
  /// **'Akun Google tidak bisa ubah sandi di sini. Gunakan Lupa kata sandi atau kelola akun Google.'**
  String get changePasswordGoogleOnly;

  /// No description provided for @changePasswordFormHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan sandi saat ini lalu sandi baru (minimal 6 karakter).'**
  String get changePasswordFormHint;

  /// No description provided for @signInToChangePassword.
  ///
  /// In id, this message translates to:
  /// **'Masuk dulu untuk mengubah kata sandi.'**
  String get signInToChangePassword;

  /// No description provided for @authRequiresRecentLogin.
  ///
  /// In id, this message translates to:
  /// **'Demi keamanan, keluar lalu masuk lagi sebelum mengubah kata sandi.'**
  String get authRequiresRecentLogin;

  /// No description provided for @chatOpenFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal membuka obrolan. Periksa login dan aturan Realtime Database.'**
  String get chatOpenFailed;

  /// No description provided for @sellerChatSyncHint.
  ///
  /// In id, this message translates to:
  /// **'Sebagai penjual: minta pembeli kirim pesan dari produk toko Anda, lalu ketuk Muat obrolan. Deploy aturan RTDB: firebase deploy --only database'**
  String get sellerChatSyncHint;

  /// No description provided for @buyerMessages.
  ///
  /// In id, this message translates to:
  /// **'Obrolan pembelian'**
  String get buyerMessages;

  /// No description provided for @sellerStoreMessages.
  ///
  /// In id, this message translates to:
  /// **'Pesan dari pembeli'**
  String get sellerStoreMessages;

  /// No description provided for @buyerChatEmptyHint.
  ///
  /// In id, this message translates to:
  /// **'Belum ada obrolan pembelian. Buka produk lalu ketuk Chat dengan penjual.'**
  String get buyerChatEmptyHint;

  /// No description provided for @reloadChats.
  ///
  /// In id, this message translates to:
  /// **'Muat obrolan'**
  String get reloadChats;

  /// No description provided for @chatSyncing.
  ///
  /// In id, this message translates to:
  /// **'Memuat obrolan…'**
  String get chatSyncing;

  /// No description provided for @signIn.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get signIn;

  /// No description provided for @orContinueWith.
  ///
  /// In id, this message translates to:
  /// **'Atau lanjut dengan'**
  String get orContinueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In id, this message translates to:
  /// **'Lanjut dengan Google'**
  String get continueWithGoogle;

  /// No description provided for @noAccount.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In id, this message translates to:
  /// **'Buat akun'**
  String get createAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Bergabung dan mulai jual beli preloved'**
  String get registerSubtitle;

  /// No description provided for @fullName.
  ///
  /// In id, this message translates to:
  /// **'Nama lengkap'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi kata sandi'**
  String get confirmPassword;

  /// No description provided for @passwordMinHint.
  ///
  /// In id, this message translates to:
  /// **'Minimal 6 karakter'**
  String get passwordMinHint;

  /// No description provided for @termsPrivacy.
  ///
  /// In id, this message translates to:
  /// **'Saya setuju Syarat & Privasi'**
  String get termsPrivacy;

  /// No description provided for @haveAccount.
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun?'**
  String get haveAccount;

  /// No description provided for @fillEmailPassword.
  ///
  /// In id, this message translates to:
  /// **'Isi email dan kata sandi.'**
  String get fillEmailPassword;

  /// No description provided for @fillNameEmail.
  ///
  /// In id, this message translates to:
  /// **'Isi nama dan email.'**
  String get fillNameEmail;

  /// No description provided for @passwordMismatch.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi kata sandi tidak cocok.'**
  String get passwordMismatch;

  /// No description provided for @accountCreated.
  ///
  /// In id, this message translates to:
  /// **'Akun berhasil dibuat.'**
  String get accountCreated;

  /// No description provided for @googleSignInSuccess.
  ///
  /// In id, this message translates to:
  /// **'Berhasil masuk dengan Google.'**
  String get googleSignInSuccess;

  /// No description provided for @authRequiredTitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk diperlukan'**
  String get authRequiredTitle;

  /// No description provided for @authRequiredBody.
  ///
  /// In id, this message translates to:
  /// **'Masuk atau daftar untuk mengakses fitur ini.'**
  String get authRequiredBody;

  /// No description provided for @signInToContinue.
  ///
  /// In id, this message translates to:
  /// **'Masuk untuk melanjutkan'**
  String get signInToContinue;

  /// No description provided for @featuredForYou.
  ///
  /// In id, this message translates to:
  /// **'Unggulan untuk Anda'**
  String get featuredForYou;

  /// No description provided for @shopByCategory.
  ///
  /// In id, this message translates to:
  /// **'Belanja per kategori'**
  String get shopByCategory;

  /// No description provided for @catElectronics.
  ///
  /// In id, this message translates to:
  /// **'Elektronik'**
  String get catElectronics;

  /// No description provided for @catFashion.
  ///
  /// In id, this message translates to:
  /// **'Fashion'**
  String get catFashion;

  /// No description provided for @catHome.
  ///
  /// In id, this message translates to:
  /// **'Rumah'**
  String get catHome;

  /// No description provided for @catSports.
  ///
  /// In id, this message translates to:
  /// **'Olahraga'**
  String get catSports;

  /// No description provided for @noProductsYet.
  ///
  /// In id, this message translates to:
  /// **'Belum ada produk'**
  String get noProductsYet;

  /// No description provided for @noProductsHint.
  ///
  /// In id, this message translates to:
  /// **'Jadilah yang pertama menambah listing preloved.'**
  String get noProductsHint;

  /// No description provided for @productCount.
  ///
  /// In id, this message translates to:
  /// **'{count} produk'**
  String productCount(int count);

  /// No description provided for @addProduct.
  ///
  /// In id, this message translates to:
  /// **'Tambah produk'**
  String get addProduct;

  /// No description provided for @addNewProduct.
  ///
  /// In id, this message translates to:
  /// **'Produk baru'**
  String get addNewProduct;

  /// No description provided for @addProductPhotoHint.
  ///
  /// In id, this message translates to:
  /// **'Maks. 8 foto • Foto pertama jadi sampul'**
  String get addProductPhotoHint;

  /// No description provided for @productInfo.
  ///
  /// In id, this message translates to:
  /// **'Informasi produk'**
  String get productInfo;

  /// No description provided for @productName.
  ///
  /// In id, this message translates to:
  /// **'Nama produk'**
  String get productName;

  /// No description provided for @selectCategory.
  ///
  /// In id, this message translates to:
  /// **'Pilih kategori'**
  String get selectCategory;

  /// No description provided for @priceLabel.
  ///
  /// In id, this message translates to:
  /// **'Harga (Rp)'**
  String get priceLabel;

  /// No description provided for @stock.
  ///
  /// In id, this message translates to:
  /// **'Stok'**
  String get stock;

  /// No description provided for @description.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get description;

  /// No description provided for @condition.
  ///
  /// In id, this message translates to:
  /// **'Kondisi'**
  String get condition;

  /// No description provided for @condBrandNew.
  ///
  /// In id, this message translates to:
  /// **'Baru'**
  String get condBrandNew;

  /// No description provided for @condLikeNew.
  ///
  /// In id, this message translates to:
  /// **'Seperti baru'**
  String get condLikeNew;

  /// No description provided for @condGood.
  ///
  /// In id, this message translates to:
  /// **'Baik'**
  String get condGood;

  /// No description provided for @condFair.
  ///
  /// In id, this message translates to:
  /// **'Cukup'**
  String get condFair;

  /// No description provided for @publishProduct.
  ///
  /// In id, this message translates to:
  /// **'Publikasikan'**
  String get publishProduct;

  /// No description provided for @productPublished.
  ///
  /// In id, this message translates to:
  /// **'Produk dipublikasikan'**
  String get productPublished;

  /// No description provided for @publishFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan. Cek login Firebase & aturan RTDB.'**
  String get publishFailed;

  /// No description provided for @productNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama produk wajib diisi'**
  String get productNameRequired;

  /// No description provided for @categoryRequired.
  ///
  /// In id, this message translates to:
  /// **'Pilih kategori'**
  String get categoryRequired;

  /// No description provided for @priceRequired.
  ///
  /// In id, this message translates to:
  /// **'Harga harus lebih dari 0'**
  String get priceRequired;

  /// No description provided for @stockRequired.
  ///
  /// In id, this message translates to:
  /// **'Stok minimal 1'**
  String get stockRequired;

  /// No description provided for @myStore.
  ///
  /// In id, this message translates to:
  /// **'Toko saya'**
  String get myStore;

  /// No description provided for @storePerformance.
  ///
  /// In id, this message translates to:
  /// **'Performa toko'**
  String get storePerformance;

  /// No description provided for @thisMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan ini'**
  String get thisMonth;

  /// No description provided for @productsLabel.
  ///
  /// In id, this message translates to:
  /// **'Produk'**
  String get productsLabel;

  /// No description provided for @noStoreProducts.
  ///
  /// In id, this message translates to:
  /// **'Belum ada produk'**
  String get noStoreProducts;

  /// No description provided for @noStoreProductsHint.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan lewat Tambah produk.'**
  String get noStoreProductsHint;

  /// No description provided for @viewAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat semua'**
  String get viewAll;

  /// No description provided for @active.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get active;

  /// No description provided for @outOfStock.
  ///
  /// In id, this message translates to:
  /// **'Habis'**
  String get outOfStock;

  /// No description provided for @checkoutStockFailed.
  ///
  /// In id, this message translates to:
  /// **'Stok tidak mencukupi. Perbarui jumlah atau coba lagi nanti.'**
  String get checkoutStockFailed;

  /// No description provided for @soldCount.
  ///
  /// In id, this message translates to:
  /// **'Terjual: {label}'**
  String soldCount(String label);

  /// No description provided for @orders.
  ///
  /// In id, this message translates to:
  /// **'Pesanan'**
  String get orders;

  /// No description provided for @myOrders.
  ///
  /// In id, this message translates to:
  /// **'Pesanan saya'**
  String get myOrders;

  /// No description provided for @noOrders.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pesanan'**
  String get noOrders;

  /// No description provided for @cart.
  ///
  /// In id, this message translates to:
  /// **'Keranjang'**
  String get cart;

  /// No description provided for @emptyCart.
  ///
  /// In id, this message translates to:
  /// **'Keranjang kosong'**
  String get emptyCart;

  /// No description provided for @checkout.
  ///
  /// In id, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @buyNow.
  ///
  /// In id, this message translates to:
  /// **'Beli sekarang'**
  String get buyNow;

  /// No description provided for @addToCart.
  ///
  /// In id, this message translates to:
  /// **'Tambah ke keranjang'**
  String get addToCart;

  /// No description provided for @productDetails.
  ///
  /// In id, this message translates to:
  /// **'Detail produk'**
  String get productDetails;

  /// No description provided for @productNotFound.
  ///
  /// In id, this message translates to:
  /// **'Produk tidak ditemukan'**
  String get productNotFound;

  /// No description provided for @chat.
  ///
  /// In id, this message translates to:
  /// **'Obrolan'**
  String get chat;

  /// No description provided for @chats.
  ///
  /// In id, this message translates to:
  /// **'Obrolan'**
  String get chats;

  /// No description provided for @noChats.
  ///
  /// In id, this message translates to:
  /// **'Belum ada obrolan'**
  String get noChats;

  /// No description provided for @nearbyStores.
  ///
  /// In id, this message translates to:
  /// **'Toko terdekat'**
  String get nearbyStores;

  /// No description provided for @favorites.
  ///
  /// In id, this message translates to:
  /// **'Favorit'**
  String get favorites;

  /// No description provided for @emptyFavorites.
  ///
  /// In id, this message translates to:
  /// **'Belum ada favorit'**
  String get emptyFavorites;

  /// No description provided for @emptyReviews.
  ///
  /// In id, this message translates to:
  /// **'Belum ada ulasan'**
  String get emptyReviews;

  /// No description provided for @emptyReviewsHint.
  ///
  /// In id, this message translates to:
  /// **'Ulasan Anda akan muncul di sini setelah menulis dari pesanan selesai.'**
  String get emptyReviewsHint;

  /// No description provided for @uploadProductImageFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengunggah foto ke cloud. Coba lagi atau hubungi admin.'**
  String get uploadProductImageFailed;

  /// No description provided for @uploadProductImageAuthRequired.
  ///
  /// In id, this message translates to:
  /// **'Masuk dengan akun (email/Google) dulu agar foto bisa diunggah.'**
  String get uploadProductImageAuthRequired;

  /// No description provided for @uploadProductImageStorageRules.
  ///
  /// In id, this message translates to:
  /// **'Unggah foto ditolak. Pastikan sudah login, Storage aktif di Firebase, lalu jalankan: firebase deploy --only storage (lihat docs/FIREBASE_STORAGE.md).'**
  String get uploadProductImageStorageRules;

  /// No description provided for @storeSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan profil toko. Deploy aturan Firestore (firestore.rules) dan pastikan login dengan email pemilik toko.'**
  String get storeSaveFailed;

  /// No description provided for @storeSaveFailedDetail.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan toko: {detail}'**
  String storeSaveFailedDetail(String detail);

  /// No description provided for @uploadProductImageFileMissing.
  ///
  /// In id, this message translates to:
  /// **'File foto tidak ditemukan. Pilih ulang dari galeri.'**
  String get uploadProductImageFileMissing;

  /// No description provided for @uploadProductImageNetwork.
  ///
  /// In id, this message translates to:
  /// **'Koneksi gagal saat mengunggah. Periksa internet lalu coba lagi.'**
  String get uploadProductImageNetwork;

  /// No description provided for @uploadProductImageTooLarge.
  ///
  /// In id, this message translates to:
  /// **'Foto terlalu besar. Pilih gambar yang lebih kecil atau potong ulang.'**
  String get uploadProductImageTooLarge;

  /// No description provided for @photoSavedWithoutStorage.
  ///
  /// In id, this message translates to:
  /// **'Foto disimpan lewat database (plan Spark, tanpa Firebase Storage).'**
  String get photoSavedWithoutStorage;

  /// No description provided for @searchResults.
  ///
  /// In id, this message translates to:
  /// **'Hasil pencarian'**
  String get searchResults;

  /// No description provided for @sortRelevance.
  ///
  /// In id, this message translates to:
  /// **'Relevansi'**
  String get sortRelevance;

  /// No description provided for @sortPriceLow.
  ///
  /// In id, this message translates to:
  /// **'Harga terendah'**
  String get sortPriceLow;

  /// No description provided for @sortPriceHigh.
  ///
  /// In id, this message translates to:
  /// **'Harga tertinggi'**
  String get sortPriceHigh;

  /// No description provided for @conversationNotFound.
  ///
  /// In id, this message translates to:
  /// **'Percakapan tidak ditemukan'**
  String get conversationNotFound;

  /// No description provided for @typeMessage.
  ///
  /// In id, this message translates to:
  /// **'Ketik pesan…'**
  String get typeMessage;

  /// No description provided for @send.
  ///
  /// In id, this message translates to:
  /// **'Kirim'**
  String get send;

  /// No description provided for @loyaltyRewards.
  ///
  /// In id, this message translates to:
  /// **'Poin & hadiah'**
  String get loyaltyRewards;

  /// No description provided for @reviews.
  ///
  /// In id, this message translates to:
  /// **'Ulasan'**
  String get reviews;

  /// No description provided for @paymentSuccess.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran berhasil'**
  String get paymentSuccess;

  /// No description provided for @thankYouPurchase.
  ///
  /// In id, this message translates to:
  /// **'Terima kasih! Bumi sedikit lebih hijau 🌱'**
  String get thankYouPurchase;

  /// No description provided for @pointsEarned.
  ///
  /// In id, this message translates to:
  /// **'+{points} poin'**
  String pointsEarned(int points);

  /// No description provided for @resetPasswordSent.
  ///
  /// In id, this message translates to:
  /// **'Link reset dikirim ke {email}'**
  String resetPasswordSent(String email);

  /// No description provided for @enterEmailForReset.
  ///
  /// In id, this message translates to:
  /// **'Masukkan email di atas untuk reset kata sandi.'**
  String get enterEmailForReset;

  /// No description provided for @splashTagline.
  ///
  /// In id, this message translates to:
  /// **'Marketplace second ramah bumi'**
  String get splashTagline;

  /// No description provided for @onboardingSellTitle.
  ///
  /// In id, this message translates to:
  /// **'Jual barang tidak terpakai'**
  String get onboardingSellTitle;

  /// No description provided for @onboardingSellSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Ubah barang menganggur jadi uang dengan mudah.'**
  String get onboardingSellSubtitle;

  /// No description provided for @onboardingBuyTitle.
  ///
  /// In id, this message translates to:
  /// **'Temukan barang berkualitas'**
  String get onboardingBuyTitle;

  /// No description provided for @onboardingBuySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Beli barang bekas terpercaya di dekat Anda.'**
  String get onboardingBuySubtitle;

  /// No description provided for @onboardingEcoTitle.
  ///
  /// In id, this message translates to:
  /// **'Ramah lingkungan'**
  String get onboardingEcoTitle;

  /// No description provided for @onboardingEcoSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kurangi sampah, dukung belanja berkelanjutan.'**
  String get onboardingEcoSubtitle;

  /// No description provided for @skip.
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In id, this message translates to:
  /// **'Mulai'**
  String get getStarted;

  /// No description provided for @back.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get back;

  /// No description provided for @close.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get close;

  /// No description provided for @understand.
  ///
  /// In id, this message translates to:
  /// **'Mengerti'**
  String get understand;

  /// No description provided for @apply.
  ///
  /// In id, this message translates to:
  /// **'Terapkan'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In id, this message translates to:
  /// **'Atur ulang'**
  String get reset;

  /// No description provided for @sort.
  ///
  /// In id, this message translates to:
  /// **'Urutkan'**
  String get sort;

  /// No description provided for @startShopping.
  ///
  /// In id, this message translates to:
  /// **'Mulai belanja'**
  String get startShopping;

  /// No description provided for @startShoppingHint.
  ///
  /// In id, this message translates to:
  /// **'Yuk tambahkan produk favoritmu'**
  String get startShoppingHint;

  /// No description provided for @details.
  ///
  /// In id, this message translates to:
  /// **'Detail'**
  String get details;

  /// No description provided for @viewLabel.
  ///
  /// In id, this message translates to:
  /// **'Lihat'**
  String get viewLabel;

  /// No description provided for @today.
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get today;

  /// No description provided for @phoneNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon'**
  String get phoneNumber;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In id, this message translates to:
  /// **'Ubah foto profil'**
  String get changeProfilePhoto;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In id, this message translates to:
  /// **'Foto profil diperbarui'**
  String get profilePhotoUpdated;

  /// No description provided for @profilePhotoFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan foto'**
  String get profilePhotoFailed;

  /// No description provided for @profileSaved.
  ///
  /// In id, this message translates to:
  /// **'Profil disimpan'**
  String get profileSaved;

  /// No description provided for @saveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan perubahan'**
  String get saveChanges;

  /// No description provided for @nameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama tidak boleh kosong'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In id, this message translates to:
  /// **'Email tidak boleh kosong'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid'**
  String get emailInvalid;

  /// No description provided for @phoneMinDigits.
  ///
  /// In id, this message translates to:
  /// **'Minimal 10 digit nomor aktif'**
  String get phoneMinDigits;

  /// No description provided for @phoneOrderHint.
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon dipakai untuk verifikasi pesanan & pengiriman.'**
  String get phoneOrderHint;

  /// No description provided for @shippingSection.
  ///
  /// In id, this message translates to:
  /// **'Pengiriman'**
  String get shippingSection;

  /// No description provided for @deliveryAddress.
  ///
  /// In id, this message translates to:
  /// **'Alamat pengiriman'**
  String get deliveryAddress;

  /// No description provided for @selectAddress.
  ///
  /// In id, this message translates to:
  /// **'Pilih alamat'**
  String get selectAddress;

  /// No description provided for @addressHome.
  ///
  /// In id, this message translates to:
  /// **'Rumah (utama)'**
  String get addressHome;

  /// No description provided for @addressOffice.
  ///
  /// In id, this message translates to:
  /// **'Kantor'**
  String get addressOffice;

  /// No description provided for @addressApartment.
  ///
  /// In id, this message translates to:
  /// **'Kos / apartemen'**
  String get addressApartment;

  /// No description provided for @addressParents.
  ///
  /// In id, this message translates to:
  /// **'Alamat orang tua'**
  String get addressParents;

  /// No description provided for @paymentMethod.
  ///
  /// In id, this message translates to:
  /// **'Metode pembayaran'**
  String get paymentMethod;

  /// No description provided for @paymentMethodSubtitle.
  ///
  /// In id, this message translates to:
  /// **'VA, e-wallet, kartu, atau COD'**
  String get paymentMethodSubtitle;

  /// No description provided for @orderSummary.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan'**
  String get orderSummary;

  /// No description provided for @totalPayment.
  ///
  /// In id, this message translates to:
  /// **'Total pembayaran'**
  String get totalPayment;

  /// No description provided for @promoCode.
  ///
  /// In id, this message translates to:
  /// **'Kode promo'**
  String get promoCode;

  /// No description provided for @applyPromo.
  ///
  /// In id, this message translates to:
  /// **'Pakai'**
  String get applyPromo;

  /// No description provided for @shippingReguler.
  ///
  /// In id, this message translates to:
  /// **'Reguler'**
  String get shippingReguler;

  /// No description provided for @shippingExpress.
  ///
  /// In id, this message translates to:
  /// **'Ekspres'**
  String get shippingExpress;

  /// No description provided for @shippingEtaReguler.
  ///
  /// In id, this message translates to:
  /// **'2–3 hari kerja'**
  String get shippingEtaReguler;

  /// No description provided for @shippingEtaExpress.
  ///
  /// In id, this message translates to:
  /// **'1 hari kerja'**
  String get shippingEtaExpress;

  /// No description provided for @subtotalLine.
  ///
  /// In id, this message translates to:
  /// **'Subtotal ({count} item)'**
  String subtotalLine(int count);

  /// No description provided for @shippingFeeLine.
  ///
  /// In id, this message translates to:
  /// **'Ongkir ({method})'**
  String shippingFeeLine(String method);

  /// No description provided for @paymentLine.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran'**
  String get paymentLine;

  /// No description provided for @stockLeft.
  ///
  /// In id, this message translates to:
  /// **'Stok {count}'**
  String stockLeft(int count);

  /// No description provided for @payBcaVa.
  ///
  /// In id, this message translates to:
  /// **'Virtual Account BCA'**
  String get payBcaVa;

  /// No description provided for @payMandiriVa.
  ///
  /// In id, this message translates to:
  /// **'Virtual Account Mandiri'**
  String get payMandiriVa;

  /// No description provided for @payBniVa.
  ///
  /// In id, this message translates to:
  /// **'Virtual Account BNI'**
  String get payBniVa;

  /// No description provided for @payOvo.
  ///
  /// In id, this message translates to:
  /// **'OVO'**
  String get payOvo;

  /// No description provided for @payGopay.
  ///
  /// In id, this message translates to:
  /// **'GoPay'**
  String get payGopay;

  /// No description provided for @payDana.
  ///
  /// In id, this message translates to:
  /// **'DANA'**
  String get payDana;

  /// No description provided for @payShopeePay.
  ///
  /// In id, this message translates to:
  /// **'ShopeePay'**
  String get payShopeePay;

  /// No description provided for @payCard.
  ///
  /// In id, this message translates to:
  /// **'Kartu kredit / debit'**
  String get payCard;

  /// No description provided for @payCardSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Visa, Mastercard, JCB'**
  String get payCardSubtitle;

  /// No description provided for @payCod.
  ///
  /// In id, this message translates to:
  /// **'COD (bayar di tempat)'**
  String get payCod;

  /// No description provided for @payAutoVerify.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi otomatatis'**
  String get payAutoVerify;

  /// No description provided for @phoneRequiredTitle.
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon wajib'**
  String get phoneRequiredTitle;

  /// No description provided for @phoneHint.
  ///
  /// In id, this message translates to:
  /// **'08xx atau +62…'**
  String get phoneHint;

  /// No description provided for @saveAndContinue.
  ///
  /// In id, this message translates to:
  /// **'Simpan & lanjut'**
  String get saveAndContinue;

  /// No description provided for @sortWishlist.
  ///
  /// In id, this message translates to:
  /// **'Urutkan wishlist'**
  String get sortWishlist;

  /// No description provided for @viewSellerStore.
  ///
  /// In id, this message translates to:
  /// **'Lihat halaman toko'**
  String get viewSellerStore;

  /// No description provided for @storeLocationTitle.
  ///
  /// In id, this message translates to:
  /// **'Lokasi toko'**
  String get storeLocationTitle;

  /// No description provided for @storeMapZoomHint.
  ///
  /// In id, this message translates to:
  /// **'Cubit (zoom) atau ketuk untuk memuat peta lokasi'**
  String get storeMapZoomHint;

  /// No description provided for @searchInChat.
  ///
  /// In id, this message translates to:
  /// **'Cari dalam chat'**
  String get searchInChat;

  /// No description provided for @searchMessages.
  ///
  /// In id, this message translates to:
  /// **'Cari pesan'**
  String get searchMessages;

  /// No description provided for @keywordHint.
  ///
  /// In id, this message translates to:
  /// **'Kata kunci…'**
  String get keywordHint;

  /// No description provided for @mediaAndPhotos.
  ///
  /// In id, this message translates to:
  /// **'Media & foto'**
  String get mediaAndPhotos;

  /// No description provided for @noPhotosInChat.
  ///
  /// In id, this message translates to:
  /// **'Belum ada foto dalam chat ini.'**
  String get noPhotosInChat;

  /// No description provided for @muteChatNotif.
  ///
  /// In id, this message translates to:
  /// **'Bisukan notifikasi chat'**
  String get muteChatNotif;

  /// No description provided for @muteChatDemo.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi untuk chat ini dibisukan (demo)'**
  String get muteChatDemo;

  /// No description provided for @deleteConversation.
  ///
  /// In id, this message translates to:
  /// **'Hapus percakapan'**
  String get deleteConversation;

  /// No description provided for @deleteConversationQ.
  ///
  /// In id, this message translates to:
  /// **'Hapus percakapan?'**
  String get deleteConversationQ;

  /// No description provided for @deleteHistoryHint.
  ///
  /// In id, this message translates to:
  /// **'Riwayat pesan di perangkat ini akan dikosongkan.'**
  String get deleteHistoryHint;

  /// No description provided for @reportConversation.
  ///
  /// In id, this message translates to:
  /// **'Laporkan percakapan'**
  String get reportConversation;

  /// No description provided for @reportSentDemo.
  ///
  /// In id, this message translates to:
  /// **'Laporan dikirim (demo)'**
  String get reportSentDemo;

  /// No description provided for @blockSeller.
  ///
  /// In id, this message translates to:
  /// **'Blokir penjual'**
  String get blockSeller;

  /// No description provided for @blockSellerDemo.
  ///
  /// In id, this message translates to:
  /// **'Penjual diblokir (demo)'**
  String get blockSellerDemo;

  /// No description provided for @noMessagesYet.
  ///
  /// In id, this message translates to:
  /// **'Belum ada percakapan.'**
  String get noMessagesYet;

  /// No description provided for @noSearchInChat.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada pesan yang cocok dengan pencarian.'**
  String get noSearchInChat;

  /// No description provided for @productNotLinked.
  ///
  /// In id, this message translates to:
  /// **'Produk tidak terikat ke katalog'**
  String get productNotLinked;

  /// No description provided for @sendPhoto.
  ///
  /// In id, this message translates to:
  /// **'Kirim foto'**
  String get sendPhoto;

  /// No description provided for @adminSellerDesc.
  ///
  /// In id, this message translates to:
  /// **'Setujui / tolak & lihat formulir calon penjual'**
  String get adminSellerDesc;

  /// No description provided for @changePassword.
  ///
  /// In id, this message translates to:
  /// **'Ubah kata sandi'**
  String get changePassword;

  /// No description provided for @changePasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Ubah sandi akun email/password Anda.'**
  String get changePasswordHint;

  /// No description provided for @privacySecurity.
  ///
  /// In id, this message translates to:
  /// **'Privasi & keamanan'**
  String get privacySecurity;

  /// No description provided for @privacySecurityDesc.
  ///
  /// In id, this message translates to:
  /// **'Lindungi akun dan data Anda'**
  String get privacySecurityDesc;

  /// No description provided for @paymentMethods.
  ///
  /// In id, this message translates to:
  /// **'Metode pembayaran'**
  String get paymentMethods;

  /// No description provided for @paymentMethodsDesc.
  ///
  /// In id, this message translates to:
  /// **'Kartu & dompet digital'**
  String get paymentMethodsDesc;

  /// No description provided for @emailNotifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi email'**
  String get emailNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi SMS'**
  String get smsNotifications;

  /// No description provided for @appPreferences.
  ///
  /// In id, this message translates to:
  /// **'Preferensi aplikasi'**
  String get appPreferences;

  /// No description provided for @darkMode.
  ///
  /// In id, this message translates to:
  /// **'Mode gelap'**
  String get darkMode;

  /// No description provided for @locationAccess.
  ///
  /// In id, this message translates to:
  /// **'Akses lokasi'**
  String get locationAccess;

  /// No description provided for @fingerprintAuth.
  ///
  /// In id, this message translates to:
  /// **'Autentikasi sidik jari'**
  String get fingerprintAuth;

  /// No description provided for @fingerprintAuthSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hanya untuk pembayaran cepat (OVO, GoPay, DANA, ShopeePay)'**
  String get fingerprintAuthSubtitle;

  /// No description provided for @biometricAuthPaymentReason.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi identitas untuk menyelesaikan pembayaran cepat'**
  String get biometricAuthPaymentReason;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In id, this message translates to:
  /// **'Sidik jari tidak tersedia di perangkat ini'**
  String get biometricNotAvailable;

  /// No description provided for @biometricAuthFailed.
  ///
  /// In id, this message translates to:
  /// **'Autentikasi gagal. Pembayaran dibatalkan.'**
  String get biometricAuthFailed;

  /// No description provided for @privacyPolicy.
  ///
  /// In id, this message translates to:
  /// **'Kebijakan privasi'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In id, this message translates to:
  /// **'Baca ketentuan privasi kami'**
  String get privacyPolicyDesc;

  /// No description provided for @helpSupportDesc.
  ///
  /// In id, this message translates to:
  /// **'Dapatkan bantuan'**
  String get helpSupportDesc;

  /// No description provided for @signOutQ.
  ///
  /// In id, this message translates to:
  /// **'Keluar?'**
  String get signOutQ;

  /// No description provided for @signOutDesc.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari akun Anda'**
  String get signOutDesc;

  /// No description provided for @appVersion.
  ///
  /// In id, this message translates to:
  /// **'Versi 1.0.0 • Dibuat dengan ❤️'**
  String get appVersion;

  /// No description provided for @submitApplication.
  ///
  /// In id, this message translates to:
  /// **'Kirim pengajuan'**
  String get submitApplication;

  /// No description provided for @becomeSellerTagline.
  ///
  /// In id, this message translates to:
  /// **'Jual barang preloved Anda ke pembeli di sekitar'**
  String get becomeSellerTagline;

  /// No description provided for @storeLogo.
  ///
  /// In id, this message translates to:
  /// **'Logo toko'**
  String get storeLogo;

  /// No description provided for @storeLogoInitialsHint.
  ///
  /// In id, this message translates to:
  /// **'Logo otomatis dari inisial nama toko (huruf pertama setiap kata, maks. 3). Tidak perlu unggah foto.'**
  String get storeLogoInitialsHint;

  /// No description provided for @uploadLogo.
  ///
  /// In id, this message translates to:
  /// **'Unggah logo'**
  String get uploadLogo;

  /// No description provided for @uploadLogoHint.
  ///
  /// In id, this message translates to:
  /// **'PNG, JPG maks. 5MB'**
  String get uploadLogoHint;

  /// No description provided for @uploadLogoWebHint.
  ///
  /// In id, this message translates to:
  /// **'Unggah logo tidak tersedia di web untuk demo.'**
  String get uploadLogoWebHint;

  /// No description provided for @uploadLogoFailedKeepLocal.
  ///
  /// In id, this message translates to:
  /// **'Logo cloud gagal diunggah; pengajuan tetap dikirim dengan logo lokal.'**
  String get uploadLogoFailedKeepLocal;

  /// No description provided for @storeInformation.
  ///
  /// In id, this message translates to:
  /// **'Informasi toko'**
  String get storeInformation;

  /// No description provided for @storeName.
  ///
  /// In id, this message translates to:
  /// **'Nama toko'**
  String get storeName;

  /// No description provided for @storeNameHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama toko'**
  String get storeNameHint;

  /// No description provided for @storeDescription.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi toko'**
  String get storeDescription;

  /// No description provided for @storeDescriptionHint.
  ///
  /// In id, this message translates to:
  /// **'Ceritakan tentang toko Anda…'**
  String get storeDescriptionHint;

  /// No description provided for @contactInformation.
  ///
  /// In id, this message translates to:
  /// **'Informasi kontak'**
  String get contactInformation;

  /// No description provided for @emailHint.
  ///
  /// In id, this message translates to:
  /// **'toko@contoh.com'**
  String get emailHint;

  /// No description provided for @storeAddress.
  ///
  /// In id, this message translates to:
  /// **'Alamat toko'**
  String get storeAddress;

  /// No description provided for @streetAddress.
  ///
  /// In id, this message translates to:
  /// **'Alamat jalan'**
  String get streetAddress;

  /// No description provided for @streetHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan alamat toko'**
  String get streetHint;

  /// No description provided for @cityHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kota'**
  String get cityHint;

  /// No description provided for @sellerAgreement.
  ///
  /// In id, this message translates to:
  /// **'Perjanjian penjual'**
  String get sellerAgreement;

  /// No description provided for @sellerAgreementBody.
  ///
  /// In id, this message translates to:
  /// **'Dengan menjadi penjual, Anda setuju Syarat Layanan dan Kebijakan Penjual. Anda bertanggung jawab atas produk, pesanan, dan layanan pelanggan.'**
  String get sellerAgreementBody;

  /// No description provided for @agreeTerms.
  ///
  /// In id, this message translates to:
  /// **'Saya setuju '**
  String get agreeTerms;

  /// No description provided for @termsConditions.
  ///
  /// In id, this message translates to:
  /// **'Syarat & Ketentuan'**
  String get termsConditions;

  /// No description provided for @sellerPolicy.
  ///
  /// In id, this message translates to:
  /// **'Kebijakan penjual'**
  String get sellerPolicy;

  /// No description provided for @fillAllFields.
  ///
  /// In id, this message translates to:
  /// **'Harap lengkapi semua field dan centang persetujuan.'**
  String get fillAllFields;

  /// No description provided for @applicationSent.
  ///
  /// In id, this message translates to:
  /// **'Pengajuan dikirim. Admin akan meninjau.'**
  String get applicationSent;

  /// No description provided for @applicationSentLocalFallback.
  ///
  /// In id, this message translates to:
  /// **'Pengajuan tersimpan di perangkat ini. Admin perlu buka aplikasi yang sama atau deploy aturan Firestore (firestore.rules).'**
  String get applicationSentLocalFallback;

  /// No description provided for @sellerEmailMustMatchAccount.
  ///
  /// In id, this message translates to:
  /// **'Email pengajuan harus sama dengan email akun yang sedang login.'**
  String get sellerEmailMustMatchAccount;

  /// No description provided for @sendFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengirim: {error}'**
  String sendFailed(String error);

  /// No description provided for @approveApplicationQ.
  ///
  /// In id, this message translates to:
  /// **'Setujui pengajuan?'**
  String get approveApplicationQ;

  /// No description provided for @approveApplicationBody.
  ///
  /// In id, this message translates to:
  /// **'Toko: {store}\nEmail: {email}\nPengguna bisa masuk sebagai penjual setelah login dengan email tersebut.'**
  String approveApplicationBody(String store, String email);

  /// No description provided for @yesApprove.
  ///
  /// In id, this message translates to:
  /// **'Ya, setujui'**
  String get yesApprove;

  /// No description provided for @approveFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyetujui: {error}'**
  String approveFailed(String error);

  /// No description provided for @applicationApproved.
  ///
  /// In id, this message translates to:
  /// **'Pengajuan disetujui.'**
  String get applicationApproved;

  /// No description provided for @rejectApplicationQ.
  ///
  /// In id, this message translates to:
  /// **'Tolak pengajuan?'**
  String get rejectApplicationQ;

  /// No description provided for @rejectReasonHint.
  ///
  /// In id, this message translates to:
  /// **'Alasan (opsional)'**
  String get rejectReasonHint;

  /// No description provided for @rejectFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menolak: {error}'**
  String rejectFailed(String error);

  /// No description provided for @applicationRejected.
  ///
  /// In id, this message translates to:
  /// **'Pengajuan ditolak.'**
  String get applicationRejected;

  /// No description provided for @tabApproved.
  ///
  /// In id, this message translates to:
  /// **'Disetujui'**
  String get tabApproved;

  /// No description provided for @noDataYet.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data'**
  String get noDataYet;

  /// No description provided for @notFound.
  ///
  /// In id, this message translates to:
  /// **'Tidak ditemukan'**
  String get notFound;

  /// No description provided for @applicationNotFound.
  ///
  /// In id, this message translates to:
  /// **'Data pengajuan tidak ada.'**
  String get applicationNotFound;

  /// No description provided for @storeInfo.
  ///
  /// In id, this message translates to:
  /// **'Informasi toko'**
  String get storeInfo;

  /// No description provided for @administration.
  ///
  /// In id, this message translates to:
  /// **'Administrasi'**
  String get administration;

  /// No description provided for @agreeTermsLabel.
  ///
  /// In id, this message translates to:
  /// **'Setuju syarat'**
  String get agreeTermsLabel;

  /// No description provided for @rejectReason.
  ///
  /// In id, this message translates to:
  /// **'Alasan tolak'**
  String get rejectReason;

  /// No description provided for @approveBtn.
  ///
  /// In id, this message translates to:
  /// **'Setujui pengajuan'**
  String get approveBtn;

  /// No description provided for @localModeHint.
  ///
  /// In id, this message translates to:
  /// **'Mode lokal: pengajuan di perangkat. Hubungkan Firebase untuk sinkron panel admin web.'**
  String get localModeHint;

  /// No description provided for @sentOn.
  ///
  /// In id, this message translates to:
  /// **'Dikirim: {date}'**
  String sentOn(String date);

  /// No description provided for @addReward.
  ///
  /// In id, this message translates to:
  /// **'Tambah hadiah'**
  String get addReward;

  /// No description provided for @noRewardsAdmin.
  ///
  /// In id, this message translates to:
  /// **'Belum ada hadiah.'**
  String get noRewardsAdmin;

  /// No description provided for @activeInactive.
  ///
  /// In id, this message translates to:
  /// **'Aktif / nonaktif'**
  String get activeInactive;

  /// No description provided for @rewardDescription.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get rewardDescription;

  /// No description provided for @rewardPointCost.
  ///
  /// In id, this message translates to:
  /// **'Biaya (poin)'**
  String get rewardPointCost;

  /// No description provided for @voucherCodeOptional.
  ///
  /// In id, this message translates to:
  /// **'Kode voucher (opsional)'**
  String get voucherCodeOptional;

  /// No description provided for @redeem.
  ///
  /// In id, this message translates to:
  /// **'Tukar'**
  String get redeem;

  /// No description provided for @notEnoughPoints.
  ///
  /// In id, this message translates to:
  /// **'Poin tidak cukup untuk hadiah ini.'**
  String get notEnoughPoints;

  /// No description provided for @redeemConfirm.
  ///
  /// In id, this message translates to:
  /// **'Tukar {cost} poin?\n\n{desc}'**
  String redeemConfirm(int cost, String desc);

  /// No description provided for @redeemSuccess.
  ///
  /// In id, this message translates to:
  /// **'Berhasil ditukar!{extra}'**
  String redeemSuccess(String extra);

  /// No description provided for @rewardsAvailable.
  ///
  /// In id, this message translates to:
  /// **'Hadiah tersedia'**
  String get rewardsAvailable;

  /// No description provided for @noActiveRewards.
  ///
  /// In id, this message translates to:
  /// **'Belum ada hadiah aktif dari admin.'**
  String get noActiveRewards;

  /// No description provided for @redemptionHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat penukaran'**
  String get redemptionHistory;

  /// No description provided for @voucherLine.
  ///
  /// In id, this message translates to:
  /// **'Kode: {code} · -{cost} poin'**
  String voucherLine(String code, int cost);

  /// No description provided for @levelLine.
  ///
  /// In id, this message translates to:
  /// **'Level {level} · {name}'**
  String levelLine(int level, String name);

  /// No description provided for @pointsAvailable.
  ///
  /// In id, this message translates to:
  /// **'poin tersedia'**
  String get pointsAvailable;

  /// No description provided for @lifetimePoints.
  ///
  /// In id, this message translates to:
  /// **'Total seumur hidup: {points} poin'**
  String lifetimePoints(int points);

  /// No description provided for @pointsToNext.
  ///
  /// In id, this message translates to:
  /// **'Menuju {name}: {remaining} poin lagi'**
  String pointsToNext(String name, int remaining);

  /// No description provided for @maxLevelReached.
  ///
  /// In id, this message translates to:
  /// **'Level tertinggi tercapai!'**
  String get maxLevelReached;

  /// No description provided for @cannotOpenBrowser.
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat membuka browser'**
  String get cannotOpenBrowser;

  /// No description provided for @liveChat.
  ///
  /// In id, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @contactEmail.
  ///
  /// In id, this message translates to:
  /// **'Email kontak'**
  String get contactEmail;

  /// No description provided for @reportProblem.
  ///
  /// In id, this message translates to:
  /// **'Laporkan masalah'**
  String get reportProblem;

  /// No description provided for @helpTitle.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana kami bisa membantu?'**
  String get helpTitle;

  /// No description provided for @helpSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kami siap menyelesaikan masalah Anda'**
  String get helpSubtitle;

  /// No description provided for @catAccessories.
  ///
  /// In id, this message translates to:
  /// **'Aksesoris'**
  String get catAccessories;

  /// No description provided for @catFurniture.
  ///
  /// In id, this message translates to:
  /// **'Furnitur'**
  String get catFurniture;

  /// No description provided for @makeOffer.
  ///
  /// In id, this message translates to:
  /// **'Ajukan penawaran'**
  String get makeOffer;

  /// No description provided for @offerSubmitted.
  ///
  /// In id, this message translates to:
  /// **'Penawaran terkirim'**
  String get offerSubmitted;

  /// No description provided for @submitOffer.
  ///
  /// In id, this message translates to:
  /// **'Kirim penawaran'**
  String get submitOffer;

  /// No description provided for @currentPrice.
  ///
  /// In id, this message translates to:
  /// **'Harga saat ini'**
  String get currentPrice;

  /// No description provided for @yourOffer.
  ///
  /// In id, this message translates to:
  /// **'Penawaran Anda'**
  String get yourOffer;

  /// No description provided for @enterOffer.
  ///
  /// In id, this message translates to:
  /// **'Masukkan penawaran'**
  String get enterOffer;

  /// No description provided for @sellerMayRespond.
  ///
  /// In id, this message translates to:
  /// **'Penjual dapat menerima atau menolak penawaran Anda.'**
  String get sellerMayRespond;

  /// No description provided for @addPaymentMethod.
  ///
  /// In id, this message translates to:
  /// **'Tambah metode pembayaran'**
  String get addPaymentMethod;

  /// No description provided for @addPaymentMethodDemo.
  ///
  /// In id, this message translates to:
  /// **'Tambah metode (demo)'**
  String get addPaymentMethodDemo;

  /// No description provided for @paymentSelectedDemo.
  ///
  /// In id, this message translates to:
  /// **'{method} dipilih (demo)'**
  String paymentSelectedDemo(String method);

  /// No description provided for @productImages.
  ///
  /// In id, this message translates to:
  /// **'Gambar produk'**
  String get productImages;

  /// No description provided for @monthlyTarget.
  ///
  /// In id, this message translates to:
  /// **'65% target bulanan tercapai'**
  String get monthlyTarget;

  /// No description provided for @orderDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal: {date}'**
  String orderDate(String date);

  /// No description provided for @orderStatus.
  ///
  /// In id, this message translates to:
  /// **'Status: {status}'**
  String orderStatus(String status);

  /// No description provided for @trackingNumber.
  ///
  /// In id, this message translates to:
  /// **'Resi: {number}'**
  String trackingNumber(String number);

  /// No description provided for @wishlist.
  ///
  /// In id, this message translates to:
  /// **'Daftar simpan'**
  String get wishlist;

  /// No description provided for @changePasswordTitle.
  ///
  /// In id, this message translates to:
  /// **'Ubah kata sandi'**
  String get changePasswordTitle;

  /// No description provided for @changeProfileInfo.
  ///
  /// In id, this message translates to:
  /// **'Ubah informasi profil Anda'**
  String get changeProfileInfo;

  /// No description provided for @reviewSample1.
  ///
  /// In id, this message translates to:
  /// **'Produk sesuai deskripsi, penjual responsif.'**
  String get reviewSample1;

  /// No description provided for @reviewSample2.
  ///
  /// In id, this message translates to:
  /// **'Pengiriman cepat, barang masih bagus.'**
  String get reviewSample2;

  /// No description provided for @reviewSample3.
  ///
  /// In id, this message translates to:
  /// **'Penjual direkomendasikan 👍'**
  String get reviewSample3;

  /// No description provided for @demoChatHello.
  ///
  /// In id, this message translates to:
  /// **'Halo, apakah barang ini masih tersedia?'**
  String get demoChatHello;

  /// No description provided for @demoChatYes.
  ///
  /// In id, this message translates to:
  /// **'Halo! Ya, masih ready stock 👍'**
  String get demoChatYes;

  /// No description provided for @demoChatNegotiate.
  ///
  /// In id, this message translates to:
  /// **'Bisa nego sedikit untuk ongkir?'**
  String get demoChatNegotiate;

  /// No description provided for @demoChatShipping.
  ///
  /// In id, this message translates to:
  /// **'Bisa, untuk wilayah Jabodetabek ongkir lebih hemat.'**
  String get demoChatShipping;

  /// No description provided for @tabPending.
  ///
  /// In id, this message translates to:
  /// **'Menunggu'**
  String get tabPending;

  /// No description provided for @tabRejected.
  ///
  /// In id, this message translates to:
  /// **'Ditolak'**
  String get tabRejected;

  /// No description provided for @nameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama'**
  String get nameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In id, this message translates to:
  /// **'Telepon'**
  String get phoneLabel;

  /// No description provided for @streetLabel.
  ///
  /// In id, this message translates to:
  /// **'Jalan'**
  String get streetLabel;

  /// No description provided for @cityLabel.
  ///
  /// In id, this message translates to:
  /// **'Kota'**
  String get cityLabel;

  /// No description provided for @statusLabel.
  ///
  /// In id, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @reviewedLabel.
  ///
  /// In id, this message translates to:
  /// **'Ditinjau'**
  String get reviewedLabel;

  /// No description provided for @approveShort.
  ///
  /// In id, this message translates to:
  /// **'Setujui'**
  String get approveShort;

  /// No description provided for @rejectShort.
  ///
  /// In id, this message translates to:
  /// **'Tolak'**
  String get rejectShort;

  /// No description provided for @catalogEmptyOrInvalid.
  ///
  /// In id, this message translates to:
  /// **'Katalog masih kosong atau ID produk tidak valid.'**
  String get catalogEmptyOrInvalid;

  /// No description provided for @chatSellerTooltip.
  ///
  /// In id, this message translates to:
  /// **'Chat penjual'**
  String get chatSellerTooltip;

  /// No description provided for @freeShipping.
  ///
  /// In id, this message translates to:
  /// **'Gratis ongkir'**
  String get freeShipping;

  /// No description provided for @estimatedDelivery.
  ///
  /// In id, this message translates to:
  /// **'Perkiraan pengiriman 2–3 hari'**
  String get estimatedDelivery;

  /// No description provided for @inStock.
  ///
  /// In id, this message translates to:
  /// **'Tersedia'**
  String get inStock;

  /// No description provided for @priceDisplay.
  ///
  /// In id, this message translates to:
  /// **'Harga'**
  String get priceDisplay;

  /// No description provided for @adminPanelWeb.
  ///
  /// In id, this message translates to:
  /// **'Panel admin (website)'**
  String get adminPanelWeb;

  /// No description provided for @openManualUrl.
  ///
  /// In id, this message translates to:
  /// **'Buka manual: {url}'**
  String openManualUrl(String url);

  /// No description provided for @locationDeniedSystem.
  ///
  /// In id, this message translates to:
  /// **'Izin lokasi ditolak. Aktifkan di pengaturan sistem.'**
  String get locationDeniedSystem;

  /// No description provided for @biometricEnabledDemo.
  ///
  /// In id, this message translates to:
  /// **'Biometrik diaktifkan (demo — integrasi natif di produksi)'**
  String get biometricEnabledDemo;

  /// No description provided for @biometricDisabledDemo.
  ///
  /// In id, this message translates to:
  /// **'Biometrik dinonaktifkan'**
  String get biometricDisabledDemo;

  /// No description provided for @discountLabel.
  ///
  /// In id, this message translates to:
  /// **'Diskon'**
  String get discountLabel;

  /// No description provided for @voucherNotRecognized.
  ///
  /// In id, this message translates to:
  /// **'Kode tidak dikenali. Coba NEARMARKET10 atau GRATISONGKIR'**
  String get voucherNotRecognized;

  /// No description provided for @voucherPromoHint.
  ///
  /// In id, this message translates to:
  /// **'NEARMARKET10 (diskon 10%, max 50rb) · GRATISONGKIR'**
  String get voucherPromoHint;

  /// No description provided for @onlineStatus.
  ///
  /// In id, this message translates to:
  /// **'Online'**
  String get onlineStatus;

  /// No description provided for @offlineStatus.
  ///
  /// In id, this message translates to:
  /// **'Offline'**
  String get offlineStatus;

  /// No description provided for @homeHeroTagline.
  ///
  /// In id, this message translates to:
  /// **'Barang second, cerita baru'**
  String get homeHeroTagline;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Temukan barang bekas berkualitas di sekitarmu'**
  String get homeHeroSubtitle;

  /// No description provided for @appBrandName.
  ///
  /// In id, this message translates to:
  /// **'SECO'**
  String get appBrandName;

  /// No description provided for @defaultDisplayName.
  ///
  /// In id, this message translates to:
  /// **'Pengguna SECO'**
  String get defaultDisplayName;

  /// No description provided for @sortOrderLabel.
  ///
  /// In id, this message translates to:
  /// **'Urutan: {sort}'**
  String sortOrderLabel(String sort);

  /// No description provided for @productNewNotification.
  ///
  /// In id, this message translates to:
  /// **'Produk baru di PreLoved'**
  String get productNewNotification;

  /// No description provided for @storeNewNotification.
  ///
  /// In id, this message translates to:
  /// **'Toko baru di PreLoved'**
  String get storeNewNotification;

  /// No description provided for @storeNewNotificationBody.
  ///
  /// In id, this message translates to:
  /// **'{storeName} resmi jadi penjual. Cek katalog preloved terbaru!'**
  String storeNewNotificationBody(String storeName);

  /// No description provided for @storeNewNotificationSender.
  ///
  /// In id, this message translates to:
  /// **'Admin PreLoved'**
  String get storeNewNotificationSender;

  /// No description provided for @openRelatedPage.
  ///
  /// In id, this message translates to:
  /// **'Buka halaman terkait'**
  String get openRelatedPage;

  /// No description provided for @mapRequestingLocation.
  ///
  /// In id, this message translates to:
  /// **'Meminta izin lokasi…'**
  String get mapRequestingLocation;

  /// No description provided for @mapLoadOsmFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data OSM. Periksa koneksi.'**
  String get mapLoadOsmFailed;

  /// No description provided for @mapLocationDeniedFallback.
  ///
  /// In id, this message translates to:
  /// **'Izin lokasi ditolak — peta Jakarta. Aktifkan izin untuk posisi Anda.'**
  String get mapLocationDeniedFallback;

  /// No description provided for @mapGpsOffFallback.
  ///
  /// In id, this message translates to:
  /// **'GPS mati — menampilkan Jakarta. Nyalakan layanan lokasi.'**
  String get mapGpsOffFallback;

  /// No description provided for @mapGpsFailedFallback.
  ///
  /// In id, this message translates to:
  /// **'GPS gagal — fallback Jakarta.'**
  String get mapGpsFailedFallback;

  /// No description provided for @mapCoords.
  ///
  /// In id, this message translates to:
  /// **'Koordinat: {coords}'**
  String mapCoords(String coords);

  /// No description provided for @mapWebCorsHint.
  ///
  /// In id, this message translates to:
  /// **'Web: data Nominatim diblokir CORS — gunakan aplikasi Android/iOS.'**
  String get mapWebCorsHint;

  /// No description provided for @mapSellersTitle.
  ///
  /// In id, this message translates to:
  /// **'Peta & toko penjual'**
  String get mapSellersTitle;

  /// No description provided for @mapLegendHint.
  ///
  /// In id, this message translates to:
  /// **'Pin tembaga = toko seller terverifikasi · abu = tempat OSM sekitar'**
  String get mapLegendHint;

  /// No description provided for @mapSearchingSellers.
  ///
  /// In id, this message translates to:
  /// **'Mencari lokasi toko penjual di peta…'**
  String get mapSearchingSellers;

  /// No description provided for @mapLoadingNominatim.
  ///
  /// In id, this message translates to:
  /// **'Memuat titik dari Nominatim…'**
  String get mapLoadingNominatim;

  /// No description provided for @mapOsmAttribution.
  ///
  /// In id, this message translates to:
  /// **'Peta: OSM · Alamat toko: Nominatim (patuhi kebijakan penggunaan).'**
  String get mapOsmAttribution;

  /// No description provided for @mapSearchPlacesHint.
  ///
  /// In id, this message translates to:
  /// **'Cari jenis tempat OSM (mis. restoran, minimarket)'**
  String get mapSearchPlacesHint;

  /// No description provided for @mapOpenOsmTooltip.
  ///
  /// In id, this message translates to:
  /// **'Buka di openstreetmap.org'**
  String get mapOpenOsmTooltip;

  /// No description provided for @mapVerifiedSellers.
  ///
  /// In id, this message translates to:
  /// **'Penjual yang pengajuannya disetujui admin; posisi dari alamat toko.'**
  String get mapVerifiedSellers;

  /// No description provided for @mapNoVerifiedSellers.
  ///
  /// In id, this message translates to:
  /// **'Belum ada penjual terverifikasi. Ajukan atau tunggu persetujuan admin.'**
  String get mapNoVerifiedSellers;

  /// No description provided for @mapAddressNotFound.
  ///
  /// In id, this message translates to:
  /// **'Alamat tidak ditemukan di peta (periksa jalan & kota).'**
  String get mapAddressNotFound;

  /// No description provided for @mapPinMobileOnly.
  ///
  /// In id, this message translates to:
  /// **'Pin toko di peta tersedia di aplikasi Android/iOS.'**
  String get mapPinMobileOnly;

  /// No description provided for @mapGeocoding.
  ///
  /// In id, this message translates to:
  /// **'Mencari koordinat…'**
  String get mapGeocoding;

  /// No description provided for @mapAwaitingGeocode.
  ///
  /// In id, this message translates to:
  /// **'Menunggu pemetaan alamat…'**
  String get mapAwaitingGeocode;

  /// No description provided for @mapSomeAddressesFailed.
  ///
  /// In id, this message translates to:
  /// **'Beberapa alamat tidak bisa dipetakan otomatis. Edit alamat di pengajuan atau coba lagi nanti.'**
  String get mapSomeAddressesFailed;

  /// No description provided for @mapNearbyPlaces.
  ///
  /// In id, this message translates to:
  /// **'Tempat sekitar — OSM ({count})'**
  String mapNearbyPlaces(int count);

  /// No description provided for @mapNoOsmResults.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada hasil OSM di area ini. Ubah kata kunci pencarian.'**
  String get mapNoOsmResults;

  /// No description provided for @demoAddrHomeShort.
  ///
  /// In id, this message translates to:
  /// **'Kebayoran Baru'**
  String get demoAddrHomeShort;

  /// No description provided for @demoAddrOfficeShort.
  ///
  /// In id, this message translates to:
  /// **'Sudirman'**
  String get demoAddrOfficeShort;

  /// No description provided for @demoAddrAptShort.
  ///
  /// In id, this message translates to:
  /// **'Jl. Pejaten Timur'**
  String get demoAddrAptShort;

  /// No description provided for @demoAddrParentsShort.
  ///
  /// In id, this message translates to:
  /// **'Bekasi'**
  String get demoAddrParentsShort;

  /// No description provided for @demoAddrHomeFull.
  ///
  /// In id, this message translates to:
  /// **'Jl. Melati No. 12, Kebayoran Baru, Jakarta Selatan 12120'**
  String get demoAddrHomeFull;

  /// No description provided for @demoAddrOfficeFull.
  ///
  /// In id, this message translates to:
  /// **'Jl. Sudirman Kav 29, Jakarta Selatan'**
  String get demoAddrOfficeFull;

  /// No description provided for @demoAddrAptFull.
  ///
  /// In id, this message translates to:
  /// **'Apartemen Pejaten Timur Tower B, Jakarta Selatan 12510'**
  String get demoAddrAptFull;

  /// No description provided for @demoAddrParentsFull.
  ///
  /// In id, this message translates to:
  /// **'Perumahan Harapan Indah Blok F12, Bekasi 17123'**
  String get demoAddrParentsFull;

  /// No description provided for @sellerNotifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get sellerNotifications;

  /// No description provided for @rewardSampleShipping.
  ///
  /// In id, this message translates to:
  /// **'Voucher ongkir Rp 15.000'**
  String get rewardSampleShipping;

  /// No description provided for @rewardSampleDiscount.
  ///
  /// In id, this message translates to:
  /// **'Diskon 10% (maks Rp 50rb)'**
  String get rewardSampleDiscount;

  /// No description provided for @rewardSampleBag.
  ///
  /// In id, this message translates to:
  /// **'Tas belanja ramah lingkungan'**
  String get rewardSampleBag;

  /// No description provided for @rewardSampleFeeWaive.
  ///
  /// In id, this message translates to:
  /// **'Gratis biaya layanan 1 bulan'**
  String get rewardSampleFeeWaive;

  /// No description provided for @rewardSampleShippingDesc.
  ///
  /// In id, this message translates to:
  /// **'Potongan ongkir untuk 1x checkout (min. belanja Rp 100rb).'**
  String get rewardSampleShippingDesc;

  /// No description provided for @rewardSampleDiscountDesc.
  ///
  /// In id, this message translates to:
  /// **'Berlaku untuk kategori Fashion & Electronics.'**
  String get rewardSampleDiscountDesc;

  /// No description provided for @rewardSampleBagDesc.
  ///
  /// In id, this message translates to:
  /// **'Ambil di event PreLoved atau kirim ke alamat profil.'**
  String get rewardSampleBagDesc;

  /// No description provided for @rewardSampleFeeWaiveDesc.
  ///
  /// In id, this message translates to:
  /// **'Untuk member setia — tanpa biaya admin penjual.'**
  String get rewardSampleFeeWaiveDesc;

  /// No description provided for @rewardPointCostLine.
  ///
  /// In id, this message translates to:
  /// **'{cost} poin'**
  String rewardPointCostLine(int cost);

  /// No description provided for @nativeLangIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get nativeLangIndonesian;

  /// No description provided for @nativeLangEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get nativeLangEnglish;

  /// No description provided for @nativeLangArabic.
  ///
  /// In id, this message translates to:
  /// **'العربية'**
  String get nativeLangArabic;

  /// No description provided for @nativeLangKorean.
  ///
  /// In id, this message translates to:
  /// **'한국어'**
  String get nativeLangKorean;

  /// No description provided for @nativeLangChinese.
  ///
  /// In id, this message translates to:
  /// **'中文'**
  String get nativeLangChinese;

  /// No description provided for @homePrelovedDeal.
  ///
  /// In id, this message translates to:
  /// **'PENAWARAN SECO'**
  String get homePrelovedDeal;

  /// No description provided for @homeWeekThriftBest.
  ///
  /// In id, this message translates to:
  /// **'Harga thrifting terbaik minggu ini'**
  String get homeWeekThriftBest;

  /// No description provided for @homeTrustedSellersLine.
  ///
  /// In id, this message translates to:
  /// **'Barang bekas berkualitas dari penjual terpercaya'**
  String get homeTrustedSellersLine;

  /// No description provided for @homeExploreUsedBtn.
  ///
  /// In id, this message translates to:
  /// **'Jelajahi Barang Bekas'**
  String get homeExploreUsedBtn;

  /// No description provided for @catalogLoadingBanner.
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan katalog… tampilan ini membantu saat sinyal lambat.'**
  String get catalogLoadingBanner;

  /// No description provided for @wishlistUpdatedSnack.
  ///
  /// In id, this message translates to:
  /// **'Wishlist diperbarui'**
  String get wishlistUpdatedSnack;

  /// No description provided for @searchNoTrending.
  ///
  /// In id, this message translates to:
  /// **'Belum ada kata kunci trending.'**
  String get searchNoTrending;

  /// No description provided for @searchPhotoSortHint.
  ///
  /// In id, this message translates to:
  /// **'Urutan dari kemiripan foto'**
  String get searchPhotoSortHint;

  /// No description provided for @searchProductsHint.
  ///
  /// In id, this message translates to:
  /// **'Cari produk…'**
  String get searchProductsHint;

  /// No description provided for @orderReviewBtn.
  ///
  /// In id, this message translates to:
  /// **'Ulasan'**
  String get orderReviewBtn;

  /// No description provided for @orderTrackPackage.
  ///
  /// In id, this message translates to:
  /// **'Lacak paket'**
  String get orderTrackPackage;

  /// No description provided for @orderTrackingNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor resi:\n{number}'**
  String orderTrackingNumber(String number);

  /// No description provided for @orderTrackOrder.
  ///
  /// In id, this message translates to:
  /// **'Lacak pesanan'**
  String get orderTrackOrder;

  /// No description provided for @orderBuyAgain.
  ///
  /// In id, this message translates to:
  /// **'Beli lagi'**
  String get orderBuyAgain;

  /// No description provided for @orderCancelQ.
  ///
  /// In id, this message translates to:
  /// **'Batalkan pesanan?'**
  String get orderCancelQ;

  /// No description provided for @orderCancelBody.
  ///
  /// In id, this message translates to:
  /// **'Pesanan yang dibatalkan tidak dapat dikembalikan.'**
  String get orderCancelBody;

  /// No description provided for @orderCancelConfirm.
  ///
  /// In id, this message translates to:
  /// **'Ya, batalkan'**
  String get orderCancelConfirm;

  /// No description provided for @orderCancelledSnack.
  ///
  /// In id, this message translates to:
  /// **'Pesanan dibatalkan'**
  String get orderCancelledSnack;

  /// No description provided for @orderCancelBtn.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get orderCancelBtn;

  /// No description provided for @orderConfirmReceivedQ.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi pesanan diterima?'**
  String get orderConfirmReceivedQ;

  /// No description provided for @orderConfirmReceivedBody.
  ///
  /// In id, this message translates to:
  /// **'Pastikan barang sudah Anda terima dalam kondisi baik. Status pesanan akan menjadi Selesai.'**
  String get orderConfirmReceivedBody;

  /// No description provided for @orderConfirmReceivedBtn.
  ///
  /// In id, this message translates to:
  /// **'Sudah sampai'**
  String get orderConfirmReceivedBtn;

  /// No description provided for @orderCompletedSnack.
  ///
  /// In id, this message translates to:
  /// **'Pesanan ditandai selesai'**
  String get orderCompletedSnack;

  /// No description provided for @orderCompletedAt.
  ///
  /// In id, this message translates to:
  /// **'Diterima: {date}'**
  String orderCompletedAt(String date);

  /// No description provided for @paymentSavedEarth.
  ///
  /// In id, this message translates to:
  /// **'Anda telah menyelamatkan bumi'**
  String get paymentSavedEarth;

  /// No description provided for @paymentPointsRule.
  ///
  /// In id, this message translates to:
  /// **'Rp 1.000 belanja = 1 poin · total belanja {total}'**
  String paymentPointsRule(String total);

  /// No description provided for @paymentOrderProcessing.
  ///
  /// In id, this message translates to:
  /// **'Pesanan Anda sedang diproses penjual.'**
  String get paymentOrderProcessing;

  /// No description provided for @paymentBackHome.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke beranda'**
  String get paymentBackHome;

  /// No description provided for @paymentViewOrders.
  ///
  /// In id, this message translates to:
  /// **'Lihat pesanan'**
  String get paymentViewOrders;

  /// No description provided for @mapDistanceFromYou.
  ///
  /// In id, this message translates to:
  /// **'~{km} km dari Anda'**
  String mapDistanceFromYou(String km);

  /// No description provided for @mapWebNominatimUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Di web, data Nominatim tidak tersedia (CORS).'**
  String get mapWebNominatimUnavailable;

  /// No description provided for @shimmerSlowConnection.
  ///
  /// In id, this message translates to:
  /// **'Memuat… koneksi mungkin sedang lambat.'**
  String get shimmerSlowConnection;

  /// No description provided for @shimmerFetchingSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Mengambil data… mohon tunggu.'**
  String get shimmerFetchingSubtitle;

  /// No description provided for @ordersTabAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get ordersTabAll;

  /// No description provided for @ordersTabPending.
  ///
  /// In id, this message translates to:
  /// **'Menunggu'**
  String get ordersTabPending;

  /// No description provided for @ordersTabCompleted.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get ordersTabCompleted;

  /// No description provided for @orderTotalAmount.
  ///
  /// In id, this message translates to:
  /// **'Total {amount}'**
  String orderTotalAmount(String amount);

  /// No description provided for @orderStatusCompleted.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusProcessing.
  ///
  /// In id, this message translates to:
  /// **'Diproses'**
  String get orderStatusProcessing;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan'**
  String get orderStatusCancelled;

  /// No description provided for @proSellerBadge.
  ///
  /// In id, this message translates to:
  /// **'Penjual Pro'**
  String get proSellerBadge;

  /// No description provided for @authInvalidEmail.
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid.'**
  String get authInvalidEmail;

  /// No description provided for @authUserDisabled.
  ///
  /// In id, this message translates to:
  /// **'Akun ini dinonaktifkan.'**
  String get authUserDisabled;

  /// No description provided for @authUserNotFound.
  ///
  /// In id, this message translates to:
  /// **'Email belum terdaftar.'**
  String get authUserNotFound;

  /// No description provided for @authWrongPassword.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi salah.'**
  String get authWrongPassword;

  /// No description provided for @authEmailInUse.
  ///
  /// In id, this message translates to:
  /// **'Email sudah digunakan. Coba masuk.'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi terlalu lemah (minimal 6 karakter).'**
  String get authWeakPassword;

  /// No description provided for @authOperationNotAllowed.
  ///
  /// In id, this message translates to:
  /// **'Metode masuk belum diaktifkan di Firebase Console.'**
  String get authOperationNotAllowed;

  /// No description provided for @authInvalidCredential.
  ///
  /// In id, this message translates to:
  /// **'Email atau kata sandi salah.'**
  String get authInvalidCredential;

  /// No description provided for @authTooManyRequests.
  ///
  /// In id, this message translates to:
  /// **'Terlalu banyak percobaan. Coba lagi nanti.'**
  String get authTooManyRequests;

  /// No description provided for @authNetworkFailed.
  ///
  /// In id, this message translates to:
  /// **'Koneksi gagal. Periksa internet Anda.'**
  String get authNetworkFailed;

  /// No description provided for @authAccountExistsDifferent.
  ///
  /// In id, this message translates to:
  /// **'Email sudah terdaftar dengan metode lain (mis. Google).'**
  String get authAccountExistsDifferent;

  /// No description provided for @authGoogleSignInFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal masuk dengan Google. Periksa SHA-1, Web Client ID, dan provider Google di Firebase.'**
  String get authGoogleSignInFailed;

  /// No description provided for @authFirebaseNotReady.
  ///
  /// In id, this message translates to:
  /// **'Firebase belum siap. Restart aplikasi setelah konfigurasi google-services.json.'**
  String get authFirebaseNotReady;

  /// No description provided for @authFailedWithCode.
  ///
  /// In id, this message translates to:
  /// **'Autentikasi gagal ({code}).'**
  String authFailedWithCode(String code);

  /// No description provided for @authPlatformGoogleFailed.
  ///
  /// In id, this message translates to:
  /// **'Google Sign-In gagal. Tambahkan SHA-1 di Firebase Console dan unduh ulang google-services.json.'**
  String get authPlatformGoogleFailed;

  /// No description provided for @authPlatformFailedWithCode.
  ///
  /// In id, this message translates to:
  /// **'Masuk gagal ({code}).'**
  String authPlatformFailedWithCode(String code);

  /// No description provided for @authGoogleSignInCancelled.
  ///
  /// In id, this message translates to:
  /// **'Masuk Google dibatalkan.'**
  String get authGoogleSignInCancelled;

  /// No description provided for @authGoogleNoEmail.
  ///
  /// In id, this message translates to:
  /// **'Akun Google tidak memiliki email.'**
  String get authGoogleNoEmail;

  /// No description provided for @authGoogleEmptyToken.
  ///
  /// In id, this message translates to:
  /// **'Token Google kosong. Periksa Web Client ID dan oauth_client di google-services.json.'**
  String get authGoogleEmptyToken;

  /// No description provided for @authGoogleNetworkError.
  ///
  /// In id, this message translates to:
  /// **'Koneksi gagal saat masuk Google. Periksa internet Anda.'**
  String get authGoogleNetworkError;

  /// No description provided for @sellerApplicationStatus.
  ///
  /// In id, this message translates to:
  /// **'Status pengajuan penjual'**
  String get sellerApplicationStatus;

  /// No description provided for @noSellerApplicationYet.
  ///
  /// In id, this message translates to:
  /// **'Anda belum mengajukan menjadi penjual.'**
  String get noSellerApplicationYet;

  /// No description provided for @applicationPendingMessage.
  ///
  /// In id, this message translates to:
  /// **'Pengajuan sedang ditinjau admin. Mohon tunggu persetujuan atau penolakan.'**
  String get applicationPendingMessage;

  /// No description provided for @applicationApprovedMessage.
  ///
  /// In id, this message translates to:
  /// **'Disetujui! Anda dapat menggunakan fitur penjual di aplikasi.'**
  String get applicationApprovedMessage;

  /// No description provided for @applicationRejectedMessage.
  ///
  /// In id, this message translates to:
  /// **'Pengajuan ditolak. Lihat alasan di bawah atau ajukan ulang.'**
  String get applicationRejectedMessage;

  /// No description provided for @submitNewSellerApplication.
  ///
  /// In id, this message translates to:
  /// **'Ajukan ulang'**
  String get submitNewSellerApplication;

  /// No description provided for @viewSellerApplicationStatus.
  ///
  /// In id, this message translates to:
  /// **'Lihat status pengajuan'**
  String get viewSellerApplicationStatus;

  /// No description provided for @adminAccessDenied.
  ///
  /// In id, this message translates to:
  /// **'Anda tidak memiliki akses ke bagian ini.'**
  String get adminAccessDenied;

  /// No description provided for @adminEmailNotConfigured.
  ///
  /// In id, this message translates to:
  /// **'Email admin belum diatur. Edit lib/config/app_admin_local.dart dan firestore.rules (adminEmail).'**
  String get adminEmailNotConfigured;

  /// No description provided for @submittedLabel.
  ///
  /// In id, this message translates to:
  /// **'Diajukan'**
  String get submittedLabel;

  /// No description provided for @accountLoginLabel.
  ///
  /// In id, this message translates to:
  /// **'Akun yang login'**
  String get accountLoginLabel;

  /// No description provided for @roleAdmin.
  ///
  /// In id, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleUser.
  ///
  /// In id, this message translates to:
  /// **'Pengguna'**
  String get roleUser;

  /// No description provided for @adminLoginHint.
  ///
  /// In id, this message translates to:
  /// **'Panel admin hanya untuk {email}. Masuk dengan Email/Kata sandi (bukan Google) memakai alamat itu.'**
  String adminLoginHint(String email);

  /// No description provided for @ecoModeTitle.
  ///
  /// In id, this message translates to:
  /// **'Mode ringan'**
  String get ecoModeTitle;

  /// No description provided for @ecoModeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Green computing: gambar lebih kecil, beranda lebih sedikit item, startup lebih ringan — cocok HP RAM kecil.'**
  String get ecoModeSubtitle;

  /// No description provided for @clearLocalData.
  ///
  /// In id, this message translates to:
  /// **'Hapus data lokal'**
  String get clearLocalData;

  /// No description provided for @clearLocalDataSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus pesanan, favorit, dan ulasan tersimpan di HP ini. Tutup lalu buka lagi aplikasinya.'**
  String get clearLocalDataSubtitle;

  /// No description provided for @clearLocalDataDone.
  ///
  /// In id, this message translates to:
  /// **'Data lokal dihapus. Tutup aplikasi sepenuhnya lalu buka lagi.'**
  String get clearLocalDataDone;

  /// No description provided for @editStore.
  ///
  /// In id, this message translates to:
  /// **'Edit toko'**
  String get editStore;

  /// No description provided for @deleteStore.
  ///
  /// In id, this message translates to:
  /// **'Hapus toko'**
  String get deleteStore;

  /// No description provided for @deleteStoreConfirm.
  ///
  /// In id, this message translates to:
  /// **'Toko dan semua produk Anda akan dihapus dari aplikasi. Lanjutkan?'**
  String get deleteStoreConfirm;

  /// No description provided for @storeUpdated.
  ///
  /// In id, this message translates to:
  /// **'Profil toko diperbarui.'**
  String get storeUpdated;

  /// No description provided for @storeDeleted.
  ///
  /// In id, this message translates to:
  /// **'Toko dihapus.'**
  String get storeDeleted;

  /// No description provided for @productUpdated.
  ///
  /// In id, this message translates to:
  /// **'Produk diperbarui.'**
  String get productUpdated;

  /// No description provided for @productDeleted.
  ///
  /// In id, this message translates to:
  /// **'Produk dihapus.'**
  String get productDeleted;

  /// No description provided for @deleteProductConfirm.
  ///
  /// In id, this message translates to:
  /// **'Produk ini akan dihapus permanen dari katalog.'**
  String get deleteProductConfirm;

  /// No description provided for @manageSellerRequests.
  ///
  /// In id, this message translates to:
  /// **'Kelola pengajuan penjual'**
  String get manageSellerRequests;

  /// No description provided for @manageRewards.
  ///
  /// In id, this message translates to:
  /// **'Kelola hadiah'**
  String get manageRewards;
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
      <String>['ar', 'en', 'id', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
