// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get home => 'Beranda';

  @override
  String get map => 'Peta';

  @override
  String get saved => 'Favorit';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Pengaturan';

  @override
  String get language => 'Bahasa';

  @override
  String get english => 'Inggris';

  @override
  String get indonesian => 'Indonesia';

  @override
  String get mandarin => 'Mandarin';

  @override
  String get korea => 'Korea';

  @override
  String get arab => 'Arab';

  @override
  String get unknownLanguage => 'Bahasa tidak dikenal';

  @override
  String get searchHint => 'Cari barang bekas, kategori...';

  @override
  String get searchWithPhoto => 'Cari dengan foto';

  @override
  String get photoSearchSubtitle =>
      'Pilih gambar referensi. AI Gemini mengenali barang lalu mencocokkan dengan katalog.';

  @override
  String get photoSearchCardHint =>
      'Ketuk di sini atau ikon kamera — galeri atau foto baru.';

  @override
  String get chooseFromGallery => 'Pilih dari galeri';

  @override
  String get takePhotoNow => 'Ambil foto sekarang';

  @override
  String get cancel => 'Batal';

  @override
  String get later => 'Nanti';

  @override
  String get save => 'Simpan';

  @override
  String get edit => 'Ubah';

  @override
  String get delete => 'Hapus';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Coba lagi';

  @override
  String get seeAll => 'Lihat semua';

  @override
  String get loading => 'Memuat…';

  @override
  String get continueRequestPermission => 'Lanjut & minta izin';

  @override
  String get notificationPermissionTitle => 'Izin notifikasi';

  @override
  String notificationPermissionBody(String appName) {
    return 'Agar pesan & update bisa mengingatkan Anda saat aplikasi di latar, aktifkan notifikasi untuk $appName. Anda bisa menolak — pesan tetap di aplikasi.';
  }

  @override
  String get galleryPermissionRequired =>
      'Izin galeri diperlukan untuk memilih gambar.';

  @override
  String get galleryPermissionOpenSettings =>
      'Akses galeri diblokir. Buka pengaturan aplikasi untuk mengizinkan foto.';

  @override
  String productPhotosMax(int count) {
    return 'Maksimal $count foto per produk.';
  }

  @override
  String productPhotosAdded(int count) {
    return '$count foto ditambahkan.';
  }

  @override
  String get productPhotoRequired => 'Tambahkan minimal satu foto produk.';

  @override
  String get cameraPermissionRequired =>
      'Izin kamera diperlukan untuk mengambil foto.';

  @override
  String get aiMatchingPhoto => 'Menganalisis foto dengan AI';

  @override
  String get aiMatchingSubtitle =>
      'Gemini mengenali barang… hasil segera muncul.';

  @override
  String photoSearchFailed(String error) {
    return 'Pencarian foto gagal: $error';
  }

  @override
  String photoSearchQuery(String query) {
    return 'Pencarian foto: $query';
  }

  @override
  String get genericPhotoSearch => 'Pencarian foto';

  @override
  String get trendingNow => 'Sedang tren';

  @override
  String get recentSearches => 'Pencarian terakhir';

  @override
  String get clearAll => 'Hapus semua';

  @override
  String get noRecentSearches => 'Belum ada pencarian';

  @override
  String get messages => 'Pesan';

  @override
  String get noConversations => 'Belum ada percakapan.';

  @override
  String get inboxEmptyHint =>
      'Pesan dari pesanan, promo, atau push akan muncul di sini.';

  @override
  String get chatListEmptyHint =>
      'Belum ada obrolan. Buka produk, lalu ketuk Chat dengan penjual untuk memulai.';

  @override
  String get chatStartHint =>
      'Ketik pesan di bawah untuk memulai obrolan dengan penjual.';

  @override
  String get signInToChat => 'Masuk dulu untuk mengirim pesan.';

  @override
  String get notificationsSection => 'Notifikasi';

  @override
  String get chatHistoryLocalOnly =>
      'Riwayat obrolan disimpan di cloud; hapus lokal tidak menghapus pesan di server.';

  @override
  String get chatImageComingSoon =>
      'Kirim foto di chat akan hadir di versi berikutnya.';

  @override
  String get requestNotificationAgain => 'Minta izin notifikasi lagi';

  @override
  String get notificationRequestSent => 'Permintaan izin notifikasi dikirim.';

  @override
  String get searchPhotoTooltip => 'Cari dengan foto (galeri / kamera)';

  @override
  String get pushNotifications => 'Notifikasi push';

  @override
  String get pushNotificationsSubtitle => 'Pesan & promo (FCM)';

  @override
  String get settingsSubtitle => 'Kelola akun dan preferensi Anda';

  @override
  String get appearance => 'Tampilan';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Ikuti sistem';

  @override
  String get admin => 'Admin';

  @override
  String get adminSellerApps => 'Pengajuan penjual';

  @override
  String get adminRewards => 'Kelola voucher hadiah';

  @override
  String get accountSection => 'Akun';

  @override
  String get editProfile => 'Ubah profil';

  @override
  String get becomeSeller => 'Jadi penjual';

  @override
  String get logout => 'Keluar';

  @override
  String get helpSupport => 'Bantuan & dukungan';

  @override
  String get aboutApp => 'Tentang aplikasi';

  @override
  String get welcomeBack => 'Selamat datang kembali!';

  @override
  String get signInSubtitle => 'Masuk untuk lanjut berbelanja';

  @override
  String get email => 'Email';

  @override
  String get password => 'Kata sandi';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get forgotPasswordTitle => 'Lupa kata sandi';

  @override
  String get forgotPasswordBody =>
      'Masukkan email akun Anda. Kami akan mengirim link reset kata sandi dari Firebase ke kotak masuk email.';

  @override
  String get sendResetEmail => 'Kirim link reset';

  @override
  String get backToLogin => 'Kembali ke login';

  @override
  String get currentPassword => 'Kata sandi saat ini';

  @override
  String get newPassword => 'Kata sandi baru';

  @override
  String get confirmNewPassword => 'Konfirmasi kata sandi baru';

  @override
  String get newPasswordMismatch => 'Konfirmasi kata sandi baru tidak cocok.';

  @override
  String get changePasswordSuccess => 'Kata sandi berhasil diubah.';

  @override
  String get changePasswordGoogleOnly =>
      'Akun Google tidak bisa ubah sandi di sini. Gunakan Lupa kata sandi atau kelola akun Google.';

  @override
  String get changePasswordFormHint =>
      'Masukkan sandi saat ini lalu sandi baru (minimal 6 karakter).';

  @override
  String get signInToChangePassword => 'Masuk dulu untuk mengubah kata sandi.';

  @override
  String get authRequiresRecentLogin =>
      'Demi keamanan, keluar lalu masuk lagi sebelum mengubah kata sandi.';

  @override
  String get chatOpenFailed =>
      'Gagal membuka obrolan. Periksa login dan aturan Realtime Database.';

  @override
  String get sellerChatSyncHint =>
      'Sebagai penjual: minta pembeli kirim pesan dari produk toko Anda, lalu ketuk Muat obrolan. Deploy aturan RTDB: firebase deploy --only database';

  @override
  String get buyerMessages => 'Obrolan pembelian';

  @override
  String get sellerStoreMessages => 'Pesan dari pembeli';

  @override
  String get buyerChatEmptyHint =>
      'Belum ada obrolan pembelian. Buka produk lalu ketuk Chat dengan penjual.';

  @override
  String get reloadChats => 'Muat obrolan';

  @override
  String get chatSyncing => 'Memuat obrolan…';

  @override
  String get signIn => 'Masuk';

  @override
  String get orContinueWith => 'Atau lanjut dengan';

  @override
  String get continueWithGoogle => 'Lanjut dengan Google';

  @override
  String get noAccount => 'Belum punya akun?';

  @override
  String get signUp => 'Daftar';

  @override
  String get createAccount => 'Buat akun';

  @override
  String get registerSubtitle => 'Bergabung dan mulai jual beli preloved';

  @override
  String get fullName => 'Nama lengkap';

  @override
  String get confirmPassword => 'Konfirmasi kata sandi';

  @override
  String get passwordMinHint => 'Minimal 6 karakter';

  @override
  String get termsPrivacy => 'Saya setuju Syarat & Privasi';

  @override
  String get haveAccount => 'Sudah punya akun?';

  @override
  String get fillEmailPassword => 'Isi email dan kata sandi.';

  @override
  String get fillNameEmail => 'Isi nama dan email.';

  @override
  String get passwordMismatch => 'Konfirmasi kata sandi tidak cocok.';

  @override
  String get accountCreated => 'Akun berhasil dibuat.';

  @override
  String get googleSignInSuccess => 'Berhasil masuk dengan Google.';

  @override
  String get authRequiredTitle => 'Masuk diperlukan';

  @override
  String get authRequiredBody => 'Masuk atau daftar untuk mengakses fitur ini.';

  @override
  String get signInToContinue => 'Masuk untuk melanjutkan';

  @override
  String get featuredForYou => 'Unggulan untuk Anda';

  @override
  String get shopByCategory => 'Belanja per kategori';

  @override
  String get catElectronics => 'Elektronik';

  @override
  String get catFashion => 'Fashion';

  @override
  String get catHome => 'Rumah';

  @override
  String get catSports => 'Olahraga';

  @override
  String get noProductsYet => 'Belum ada produk';

  @override
  String get noProductsHint =>
      'Jadilah yang pertama menambah listing preloved.';

  @override
  String productCount(int count) {
    return '$count produk';
  }

  @override
  String get addProduct => 'Tambah produk';

  @override
  String get addNewProduct => 'Produk baru';

  @override
  String get addProductPhotoHint => 'Maks. 8 foto • Foto pertama jadi sampul';

  @override
  String get productInfo => 'Informasi produk';

  @override
  String get productName => 'Nama produk';

  @override
  String get selectCategory => 'Pilih kategori';

  @override
  String get priceLabel => 'Harga (Rp)';

  @override
  String get stock => 'Stok';

  @override
  String get description => 'Deskripsi';

  @override
  String get condition => 'Kondisi';

  @override
  String get condBrandNew => 'Baru';

  @override
  String get condLikeNew => 'Seperti baru';

  @override
  String get condGood => 'Baik';

  @override
  String get condFair => 'Cukup';

  @override
  String get publishProduct => 'Publikasikan';

  @override
  String get productPublished => 'Produk dipublikasikan';

  @override
  String get publishFailed =>
      'Gagal menyimpan. Cek login Firebase & aturan RTDB.';

  @override
  String get productNameRequired => 'Nama produk wajib diisi';

  @override
  String get categoryRequired => 'Pilih kategori';

  @override
  String get priceRequired => 'Harga harus lebih dari 0';

  @override
  String get stockRequired => 'Stok minimal 1';

  @override
  String get myStore => 'Toko saya';

  @override
  String get storePerformance => 'Performa toko';

  @override
  String get thisMonth => 'Bulan ini';

  @override
  String get productsLabel => 'Produk';

  @override
  String get noStoreProducts => 'Belum ada produk';

  @override
  String get noStoreProductsHint => 'Tambahkan lewat Tambah produk.';

  @override
  String get viewAll => 'Lihat semua';

  @override
  String get active => 'Aktif';

  @override
  String get outOfStock => 'Habis';

  @override
  String get checkoutStockFailed =>
      'Stok tidak mencukupi. Perbarui jumlah atau coba lagi nanti.';

  @override
  String soldCount(String label) {
    return 'Terjual: $label';
  }

  @override
  String get orders => 'Pesanan';

  @override
  String get myOrders => 'Pesanan saya';

  @override
  String get noOrders => 'Belum ada pesanan';

  @override
  String get cart => 'Keranjang';

  @override
  String get emptyCart => 'Keranjang kosong';

  @override
  String get checkout => 'Checkout';

  @override
  String get buyNow => 'Beli sekarang';

  @override
  String get addToCart => 'Tambah ke keranjang';

  @override
  String get productDetails => 'Detail produk';

  @override
  String get productNotFound => 'Produk tidak ditemukan';

  @override
  String get chat => 'Obrolan';

  @override
  String get chats => 'Obrolan';

  @override
  String get noChats => 'Belum ada obrolan';

  @override
  String get nearbyStores => 'Toko terdekat';

  @override
  String get favorites => 'Favorit';

  @override
  String get emptyFavorites => 'Belum ada favorit';

  @override
  String get emptyReviews => 'Belum ada ulasan';

  @override
  String get emptyReviewsHint =>
      'Ulasan Anda akan muncul di sini setelah menulis dari pesanan selesai.';

  @override
  String get uploadProductImageFailed =>
      'Gagal mengunggah foto ke cloud. Coba lagi atau hubungi admin.';

  @override
  String get uploadProductImageAuthRequired =>
      'Masuk dengan akun (email/Google) dulu agar foto bisa diunggah.';

  @override
  String get uploadProductImageStorageRules =>
      'Unggah foto ditolak. Pastikan sudah login, Storage aktif di Firebase, lalu jalankan: firebase deploy --only storage (lihat docs/FIREBASE_STORAGE.md).';

  @override
  String get storeSaveFailed =>
      'Gagal menyimpan profil toko. Deploy aturan Firestore (firestore.rules) dan pastikan login dengan email pemilik toko.';

  @override
  String storeSaveFailedDetail(String detail) {
    return 'Gagal menyimpan toko: $detail';
  }

  @override
  String get uploadProductImageFileMissing =>
      'File foto tidak ditemukan. Pilih ulang dari galeri.';

  @override
  String get uploadProductImageNetwork =>
      'Koneksi gagal saat mengunggah. Periksa internet lalu coba lagi.';

  @override
  String get uploadProductImageTooLarge =>
      'Foto terlalu besar. Pilih gambar yang lebih kecil atau potong ulang.';

  @override
  String get photoSavedWithoutStorage =>
      'Foto disimpan lewat database (plan Spark, tanpa Firebase Storage).';

  @override
  String get searchResults => 'Hasil pencarian';

  @override
  String get sortRelevance => 'Relevansi';

  @override
  String get sortPriceLow => 'Harga terendah';

  @override
  String get sortPriceHigh => 'Harga tertinggi';

  @override
  String get conversationNotFound => 'Percakapan tidak ditemukan';

  @override
  String get typeMessage => 'Ketik pesan…';

  @override
  String get send => 'Kirim';

  @override
  String get loyaltyRewards => 'Poin & hadiah';

  @override
  String get reviews => 'Ulasan';

  @override
  String get paymentSuccess => 'Pembayaran berhasil';

  @override
  String get thankYouPurchase => 'Terima kasih! Bumi sedikit lebih hijau 🌱';

  @override
  String pointsEarned(int points) {
    return '+$points poin';
  }

  @override
  String resetPasswordSent(String email) {
    return 'Link reset dikirim ke $email';
  }

  @override
  String get enterEmailForReset =>
      'Masukkan email di atas untuk reset kata sandi.';

  @override
  String get splashTagline => 'Marketplace second ramah bumi';

  @override
  String get onboardingSellTitle => 'Jual barang tidak terpakai';

  @override
  String get onboardingSellSubtitle =>
      'Ubah barang menganggur jadi uang dengan mudah.';

  @override
  String get onboardingBuyTitle => 'Temukan barang berkualitas';

  @override
  String get onboardingBuySubtitle =>
      'Beli barang bekas terpercaya di dekat Anda.';

  @override
  String get onboardingEcoTitle => 'Ramah lingkungan';

  @override
  String get onboardingEcoSubtitle =>
      'Kurangi sampah, dukung belanja berkelanjutan.';

  @override
  String get skip => 'Lewati';

  @override
  String get next => 'Lanjut';

  @override
  String get getStarted => 'Mulai';

  @override
  String get back => 'Kembali';

  @override
  String get close => 'Tutup';

  @override
  String get understand => 'Mengerti';

  @override
  String get apply => 'Terapkan';

  @override
  String get reset => 'Atur ulang';

  @override
  String get sort => 'Urutkan';

  @override
  String get startShopping => 'Mulai belanja';

  @override
  String get startShoppingHint => 'Yuk tambahkan produk favoritmu';

  @override
  String get details => 'Detail';

  @override
  String get viewLabel => 'Lihat';

  @override
  String get today => 'Hari ini';

  @override
  String get phoneNumber => 'Nomor telepon';

  @override
  String get changeProfilePhoto => 'Ubah foto profil';

  @override
  String get profilePhotoUpdated => 'Foto profil diperbarui';

  @override
  String get profilePhotoFailed => 'Gagal menyimpan foto';

  @override
  String get profileSaved => 'Profil disimpan';

  @override
  String get saveChanges => 'Simpan perubahan';

  @override
  String get nameRequired => 'Nama tidak boleh kosong';

  @override
  String get emailRequired => 'Email tidak boleh kosong';

  @override
  String get emailInvalid => 'Format email tidak valid';

  @override
  String get phoneMinDigits => 'Minimal 10 digit nomor aktif';

  @override
  String get phoneOrderHint =>
      'Nomor telepon dipakai untuk verifikasi pesanan & pengiriman.';

  @override
  String get shippingSection => 'Pengiriman';

  @override
  String get deliveryAddress => 'Alamat pengiriman';

  @override
  String get selectAddress => 'Pilih alamat';

  @override
  String get addressHome => 'Rumah (utama)';

  @override
  String get addressOffice => 'Kantor';

  @override
  String get addressApartment => 'Kos / apartemen';

  @override
  String get addressParents => 'Alamat orang tua';

  @override
  String get paymentMethod => 'Metode pembayaran';

  @override
  String get paymentMethodSubtitle => 'VA, e-wallet, kartu, atau COD';

  @override
  String get orderSummary => 'Ringkasan';

  @override
  String get totalPayment => 'Total pembayaran';

  @override
  String get promoCode => 'Kode promo';

  @override
  String get applyPromo => 'Pakai';

  @override
  String get shippingReguler => 'Reguler';

  @override
  String get shippingExpress => 'Ekspres';

  @override
  String get shippingEtaReguler => '2–3 hari kerja';

  @override
  String get shippingEtaExpress => '1 hari kerja';

  @override
  String subtotalLine(int count) {
    return 'Subtotal ($count item)';
  }

  @override
  String shippingFeeLine(String method) {
    return 'Ongkir ($method)';
  }

  @override
  String get paymentLine => 'Pembayaran';

  @override
  String stockLeft(int count) {
    return 'Stok $count';
  }

  @override
  String get payBcaVa => 'Virtual Account BCA';

  @override
  String get payMandiriVa => 'Virtual Account Mandiri';

  @override
  String get payBniVa => 'Virtual Account BNI';

  @override
  String get payOvo => 'OVO';

  @override
  String get payGopay => 'GoPay';

  @override
  String get payDana => 'DANA';

  @override
  String get payShopeePay => 'ShopeePay';

  @override
  String get payCard => 'Kartu kredit / debit';

  @override
  String get payCardSubtitle => 'Visa, Mastercard, JCB';

  @override
  String get payCod => 'COD (bayar di tempat)';

  @override
  String get payAutoVerify => 'Verifikasi otomatatis';

  @override
  String get phoneRequiredTitle => 'Nomor telepon wajib';

  @override
  String get phoneHint => '08xx atau +62…';

  @override
  String get saveAndContinue => 'Simpan & lanjut';

  @override
  String get sortWishlist => 'Urutkan wishlist';

  @override
  String get viewSellerStore => 'Lihat halaman toko';

  @override
  String get storeLocationTitle => 'Lokasi toko';

  @override
  String get storeMapZoomHint =>
      'Cubit (zoom) atau ketuk untuk memuat peta lokasi';

  @override
  String get searchInChat => 'Cari dalam chat';

  @override
  String get searchMessages => 'Cari pesan';

  @override
  String get keywordHint => 'Kata kunci…';

  @override
  String get mediaAndPhotos => 'Media & foto';

  @override
  String get noPhotosInChat => 'Belum ada foto dalam chat ini.';

  @override
  String get muteChatNotif => 'Bisukan notifikasi chat';

  @override
  String get muteChatDemo => 'Notifikasi untuk chat ini dibisukan (demo)';

  @override
  String get deleteConversation => 'Hapus percakapan';

  @override
  String get deleteConversationQ => 'Hapus percakapan?';

  @override
  String get deleteHistoryHint =>
      'Riwayat pesan di perangkat ini akan dikosongkan.';

  @override
  String get reportConversation => 'Laporkan percakapan';

  @override
  String get reportSentDemo => 'Laporan dikirim (demo)';

  @override
  String get blockSeller => 'Blokir penjual';

  @override
  String get blockSellerDemo => 'Penjual diblokir (demo)';

  @override
  String get noMessagesYet => 'Belum ada percakapan.';

  @override
  String get noSearchInChat => 'Tidak ada pesan yang cocok dengan pencarian.';

  @override
  String get productNotLinked => 'Produk tidak terikat ke katalog';

  @override
  String get sendPhoto => 'Kirim foto';

  @override
  String get adminSellerDesc =>
      'Setujui / tolak & lihat formulir calon penjual';

  @override
  String get changePassword => 'Ubah kata sandi';

  @override
  String get changePasswordHint => 'Ubah sandi akun email/password Anda.';

  @override
  String get privacySecurity => 'Privasi & keamanan';

  @override
  String get privacySecurityDesc => 'Lindungi akun dan data Anda';

  @override
  String get paymentMethods => 'Metode pembayaran';

  @override
  String get paymentMethodsDesc => 'Kartu & dompet digital';

  @override
  String get emailNotifications => 'Notifikasi email';

  @override
  String get smsNotifications => 'Notifikasi SMS';

  @override
  String get appPreferences => 'Preferensi aplikasi';

  @override
  String get darkMode => 'Mode gelap';

  @override
  String get locationAccess => 'Akses lokasi';

  @override
  String get fingerprintAuth => 'Autentikasi sidik jari';

  @override
  String get fingerprintAuthSubtitle =>
      'Hanya untuk pembayaran cepat (OVO, GoPay, DANA, ShopeePay)';

  @override
  String get biometricAuthPaymentReason =>
      'Konfirmasi identitas untuk menyelesaikan pembayaran cepat';

  @override
  String get biometricNotAvailable =>
      'Sidik jari tidak tersedia di perangkat ini';

  @override
  String get biometricAuthFailed => 'Autentikasi gagal. Pembayaran dibatalkan.';

  @override
  String get privacyPolicy => 'Kebijakan privasi';

  @override
  String get privacyPolicyDesc => 'Baca ketentuan privasi kami';

  @override
  String get helpSupportDesc => 'Dapatkan bantuan';

  @override
  String get signOutQ => 'Keluar?';

  @override
  String get signOutDesc => 'Keluar dari akun Anda';

  @override
  String get appVersion => 'Versi 1.0.0 • Dibuat dengan ❤️';

  @override
  String get submitApplication => 'Kirim pengajuan';

  @override
  String get becomeSellerTagline =>
      'Jual barang preloved Anda ke pembeli di sekitar';

  @override
  String get storeLogo => 'Logo toko';

  @override
  String get storeLogoInitialsHint =>
      'Logo otomatis dari inisial nama toko (huruf pertama setiap kata, maks. 3). Tidak perlu unggah foto.';

  @override
  String get uploadLogo => 'Unggah logo';

  @override
  String get uploadLogoHint => 'PNG, JPG maks. 5MB';

  @override
  String get uploadLogoWebHint =>
      'Unggah logo tidak tersedia di web untuk demo.';

  @override
  String get uploadLogoFailedKeepLocal =>
      'Logo cloud gagal diunggah; pengajuan tetap dikirim dengan logo lokal.';

  @override
  String get storeInformation => 'Informasi toko';

  @override
  String get storeName => 'Nama toko';

  @override
  String get storeNameHint => 'Masukkan nama toko';

  @override
  String get storeDescription => 'Deskripsi toko';

  @override
  String get storeDescriptionHint => 'Ceritakan tentang toko Anda…';

  @override
  String get contactInformation => 'Informasi kontak';

  @override
  String get emailHint => 'toko@contoh.com';

  @override
  String get storeAddress => 'Alamat toko';

  @override
  String get streetAddress => 'Alamat jalan';

  @override
  String get streetHint => 'Masukkan alamat toko';

  @override
  String get cityHint => 'Masukkan kota';

  @override
  String get sellerAgreement => 'Perjanjian penjual';

  @override
  String get sellerAgreementBody =>
      'Dengan menjadi penjual, Anda setuju Syarat Layanan dan Kebijakan Penjual. Anda bertanggung jawab atas produk, pesanan, dan layanan pelanggan.';

  @override
  String get agreeTerms => 'Saya setuju ';

  @override
  String get termsConditions => 'Syarat & Ketentuan';

  @override
  String get sellerPolicy => 'Kebijakan penjual';

  @override
  String get fillAllFields =>
      'Harap lengkapi semua field dan centang persetujuan.';

  @override
  String get applicationSent => 'Pengajuan dikirim. Admin akan meninjau.';

  @override
  String get applicationSentLocalFallback =>
      'Pengajuan tersimpan di perangkat ini. Admin perlu buka aplikasi yang sama atau deploy aturan Firestore (firestore.rules).';

  @override
  String get sellerEmailMustMatchAccount =>
      'Email pengajuan harus sama dengan email akun yang sedang login.';

  @override
  String sendFailed(String error) {
    return 'Gagal mengirim: $error';
  }

  @override
  String get approveApplicationQ => 'Setujui pengajuan?';

  @override
  String approveApplicationBody(String store, String email) {
    return 'Toko: $store\nEmail: $email\nPengguna bisa masuk sebagai penjual setelah login dengan email tersebut.';
  }

  @override
  String get yesApprove => 'Ya, setujui';

  @override
  String approveFailed(String error) {
    return 'Gagal menyetujui: $error';
  }

  @override
  String get applicationApproved => 'Pengajuan disetujui.';

  @override
  String get rejectApplicationQ => 'Tolak pengajuan?';

  @override
  String get rejectReasonHint => 'Alasan (opsional)';

  @override
  String rejectFailed(String error) {
    return 'Gagal menolak: $error';
  }

  @override
  String get applicationRejected => 'Pengajuan ditolak.';

  @override
  String get tabApproved => 'Disetujui';

  @override
  String get noDataYet => 'Belum ada data';

  @override
  String get notFound => 'Tidak ditemukan';

  @override
  String get applicationNotFound => 'Data pengajuan tidak ada.';

  @override
  String get storeInfo => 'Informasi toko';

  @override
  String get administration => 'Administrasi';

  @override
  String get agreeTermsLabel => 'Setuju syarat';

  @override
  String get rejectReason => 'Alasan tolak';

  @override
  String get approveBtn => 'Setujui pengajuan';

  @override
  String get localModeHint =>
      'Mode lokal: pengajuan di perangkat. Hubungkan Firebase untuk sinkron panel admin web.';

  @override
  String sentOn(String date) {
    return 'Dikirim: $date';
  }

  @override
  String get addReward => 'Tambah hadiah';

  @override
  String get noRewardsAdmin => 'Belum ada hadiah.';

  @override
  String get activeInactive => 'Aktif / nonaktif';

  @override
  String get rewardDescription => 'Deskripsi';

  @override
  String get rewardPointCost => 'Biaya (poin)';

  @override
  String get voucherCodeOptional => 'Kode voucher (opsional)';

  @override
  String get redeem => 'Tukar';

  @override
  String get notEnoughPoints => 'Poin tidak cukup untuk hadiah ini.';

  @override
  String redeemConfirm(int cost, String desc) {
    return 'Tukar $cost poin?\n\n$desc';
  }

  @override
  String redeemSuccess(String extra) {
    return 'Berhasil ditukar!$extra';
  }

  @override
  String get rewardsAvailable => 'Hadiah tersedia';

  @override
  String get noActiveRewards => 'Belum ada hadiah aktif dari admin.';

  @override
  String get redemptionHistory => 'Riwayat penukaran';

  @override
  String voucherLine(String code, int cost) {
    return 'Kode: $code · -$cost poin';
  }

  @override
  String levelLine(int level, String name) {
    return 'Level $level · $name';
  }

  @override
  String get pointsAvailable => 'poin tersedia';

  @override
  String lifetimePoints(int points) {
    return 'Total seumur hidup: $points poin';
  }

  @override
  String pointsToNext(String name, int remaining) {
    return 'Menuju $name: $remaining poin lagi';
  }

  @override
  String get maxLevelReached => 'Level tertinggi tercapai!';

  @override
  String get cannotOpenBrowser => 'Tidak dapat membuka browser';

  @override
  String get liveChat => 'Live Chat';

  @override
  String get contactEmail => 'Email kontak';

  @override
  String get reportProblem => 'Laporkan masalah';

  @override
  String get helpTitle => 'Bagaimana kami bisa membantu?';

  @override
  String get helpSubtitle => 'Kami siap menyelesaikan masalah Anda';

  @override
  String get catAccessories => 'Aksesoris';

  @override
  String get catFurniture => 'Furnitur';

  @override
  String get makeOffer => 'Ajukan penawaran';

  @override
  String get offerSubmitted => 'Penawaran terkirim';

  @override
  String get submitOffer => 'Kirim penawaran';

  @override
  String get currentPrice => 'Harga saat ini';

  @override
  String get yourOffer => 'Penawaran Anda';

  @override
  String get enterOffer => 'Masukkan penawaran';

  @override
  String get sellerMayRespond =>
      'Penjual dapat menerima atau menolak penawaran Anda.';

  @override
  String get addPaymentMethod => 'Tambah metode pembayaran';

  @override
  String get addPaymentMethodDemo => 'Tambah metode (demo)';

  @override
  String paymentSelectedDemo(String method) {
    return '$method dipilih (demo)';
  }

  @override
  String get productImages => 'Gambar produk';

  @override
  String get monthlyTarget => '65% target bulanan tercapai';

  @override
  String orderDate(String date) {
    return 'Tanggal: $date';
  }

  @override
  String orderStatus(String status) {
    return 'Status: $status';
  }

  @override
  String trackingNumber(String number) {
    return 'Resi: $number';
  }

  @override
  String get wishlist => 'Daftar simpan';

  @override
  String get changePasswordTitle => 'Ubah kata sandi';

  @override
  String get changeProfileInfo => 'Ubah informasi profil Anda';

  @override
  String get reviewSample1 => 'Produk sesuai deskripsi, penjual responsif.';

  @override
  String get reviewSample2 => 'Pengiriman cepat, barang masih bagus.';

  @override
  String get reviewSample3 => 'Penjual direkomendasikan 👍';

  @override
  String get demoChatHello => 'Halo, apakah barang ini masih tersedia?';

  @override
  String get demoChatYes => 'Halo! Ya, masih ready stock 👍';

  @override
  String get demoChatNegotiate => 'Bisa nego sedikit untuk ongkir?';

  @override
  String get demoChatShipping =>
      'Bisa, untuk wilayah Jabodetabek ongkir lebih hemat.';

  @override
  String get tabPending => 'Menunggu';

  @override
  String get tabRejected => 'Ditolak';

  @override
  String get nameLabel => 'Nama';

  @override
  String get phoneLabel => 'Telepon';

  @override
  String get streetLabel => 'Jalan';

  @override
  String get cityLabel => 'Kota';

  @override
  String get statusLabel => 'Status';

  @override
  String get reviewedLabel => 'Ditinjau';

  @override
  String get approveShort => 'Setujui';

  @override
  String get rejectShort => 'Tolak';

  @override
  String get catalogEmptyOrInvalid =>
      'Katalog masih kosong atau ID produk tidak valid.';

  @override
  String get chatSellerTooltip => 'Chat penjual';

  @override
  String get freeShipping => 'Gratis ongkir';

  @override
  String get estimatedDelivery => 'Perkiraan pengiriman 2–3 hari';

  @override
  String get inStock => 'Tersedia';

  @override
  String get priceDisplay => 'Harga';

  @override
  String get adminPanelWeb => 'Panel admin (website)';

  @override
  String openManualUrl(String url) {
    return 'Buka manual: $url';
  }

  @override
  String get locationDeniedSystem =>
      'Izin lokasi ditolak. Aktifkan di pengaturan sistem.';

  @override
  String get biometricEnabledDemo =>
      'Biometrik diaktifkan (demo — integrasi natif di produksi)';

  @override
  String get biometricDisabledDemo => 'Biometrik dinonaktifkan';

  @override
  String get discountLabel => 'Diskon';

  @override
  String get voucherNotRecognized =>
      'Kode tidak dikenali. Coba NEARMARKET10 atau GRATISONGKIR';

  @override
  String get voucherPromoHint =>
      'NEARMARKET10 (diskon 10%, max 50rb) · GRATISONGKIR';

  @override
  String get voucherPointHint =>
      'Kode dari tukar poin (Poin & Hadiah): POINONGKIR15, POIN10OFF, POINVIP1M';

  @override
  String get voucherPointNotOwned =>
      'Kode tidak dikenali, belum ditukar poin, atau sudah dipakai';

  @override
  String get voucherRedeemedAvailable =>
      'Voucher poin Anda (ketuk untuk pakai):';

  @override
  String voucherApplied(String code) {
    return 'Voucher $code diterapkan';
  }

  @override
  String voucherMinPurchase(String amount) {
    return 'Voucher ini berlaku minimal belanja $amount';
  }

  @override
  String get onlineStatus => 'Online';

  @override
  String get offlineStatus => 'Offline';

  @override
  String get homeHeroTagline => 'Barang second, cerita baru';

  @override
  String get homeHeroSubtitle =>
      'Temukan barang bekas berkualitas di sekitarmu';

  @override
  String get appBrandName => 'SECO';

  @override
  String get defaultDisplayName => 'Pengguna SECO';

  @override
  String sortOrderLabel(String sort) {
    return 'Urutan: $sort';
  }

  @override
  String get productNewNotification => 'Produk baru di PreLoved';

  @override
  String get storeNewNotification => 'Toko baru di PreLoved';

  @override
  String storeNewNotificationBody(String storeName) {
    return '$storeName resmi jadi penjual. Cek katalog preloved terbaru!';
  }

  @override
  String get storeNewNotificationSender => 'Admin PreLoved';

  @override
  String get openRelatedPage => 'Buka halaman terkait';

  @override
  String get mapRequestingLocation => 'Meminta izin lokasi…';

  @override
  String get mapLoadOsmFailed => 'Gagal memuat data OSM. Periksa koneksi.';

  @override
  String get mapLocationDeniedFallback =>
      'Izin lokasi ditolak — peta Jakarta. Aktifkan izin untuk posisi Anda.';

  @override
  String get mapGpsOffFallback =>
      'GPS mati — menampilkan Jakarta. Nyalakan layanan lokasi.';

  @override
  String get mapGpsFailedFallback => 'GPS gagal — fallback Jakarta.';

  @override
  String mapCoords(String coords) {
    return 'Koordinat: $coords';
  }

  @override
  String get mapWebCorsHint =>
      'Web: data Nominatim diblokir CORS — gunakan aplikasi Android/iOS.';

  @override
  String get mapSellersTitle => 'Peta & toko penjual';

  @override
  String get mapLegendHint =>
      'Pin tembaga = toko seller terverifikasi · abu = tempat OSM sekitar';

  @override
  String get mapSearchingSellers => 'Mencari lokasi toko penjual di peta…';

  @override
  String get mapLoadingNominatim => 'Memuat titik dari Nominatim…';

  @override
  String get mapOsmAttribution =>
      'Peta: OSM · Alamat toko: Nominatim (patuhi kebijakan penggunaan).';

  @override
  String get mapSearchPlacesHint =>
      'Cari jenis tempat OSM (mis. restoran, minimarket)';

  @override
  String get mapOpenOsmTooltip => 'Buka di openstreetmap.org';

  @override
  String get mapVerifiedSellers =>
      'Penjual yang pengajuannya disetujui admin; posisi dari alamat toko.';

  @override
  String get mapNoVerifiedSellers =>
      'Belum ada penjual terverifikasi. Ajukan atau tunggu persetujuan admin.';

  @override
  String get mapAddressNotFound =>
      'Alamat tidak ditemukan di peta (periksa jalan & kota).';

  @override
  String get mapPinMobileOnly =>
      'Pin toko di peta tersedia di aplikasi Android/iOS.';

  @override
  String get mapGeocoding => 'Mencari koordinat…';

  @override
  String get mapAwaitingGeocode => 'Menunggu pemetaan alamat…';

  @override
  String get mapSomeAddressesFailed =>
      'Beberapa alamat tidak bisa dipetakan otomatis. Edit alamat di pengajuan atau coba lagi nanti.';

  @override
  String mapNearbyPlaces(int count) {
    return 'Tempat sekitar — OSM ($count)';
  }

  @override
  String get mapNoOsmResults =>
      'Tidak ada hasil OSM di area ini. Ubah kata kunci pencarian.';

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
      'Jl. Melati No. 12, Kebayoran Baru, Jakarta Selatan 12120';

  @override
  String get demoAddrOfficeFull => 'Jl. Sudirman Kav 29, Jakarta Selatan';

  @override
  String get demoAddrAptFull =>
      'Apartemen Pejaten Timur Tower B, Jakarta Selatan 12510';

  @override
  String get demoAddrParentsFull =>
      'Perumahan Harapan Indah Blok F12, Bekasi 17123';

  @override
  String get sellerNotifications => 'Notifikasi';

  @override
  String get rewardSampleShipping => 'Voucher ongkir Rp 15.000';

  @override
  String get rewardSampleDiscount => 'Diskon 10% (maks Rp 50rb)';

  @override
  String get rewardSampleBag => 'Tas belanja ramah lingkungan';

  @override
  String get rewardSampleFeeWaive => 'Gratis biaya layanan 1 bulan';

  @override
  String get rewardSampleShippingDesc =>
      'Potongan ongkir untuk 1x checkout (min. belanja Rp 100rb).';

  @override
  String get rewardSampleDiscountDesc =>
      'Berlaku untuk kategori Fashion & Electronics.';

  @override
  String get rewardSampleBagDesc =>
      'Ambil di event PreLoved atau kirim ke alamat profil.';

  @override
  String get rewardSampleFeeWaiveDesc =>
      'Untuk member setia — tanpa biaya admin penjual.';

  @override
  String rewardPointCostLine(int cost) {
    return '$cost poin';
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
  String get homePrelovedDeal => 'PENAWARAN SECO';

  @override
  String get homeWeekThriftBest => 'Harga thrifting terbaik minggu ini';

  @override
  String get homeTrustedSellersLine =>
      'Barang bekas berkualitas dari penjual terpercaya';

  @override
  String get homeExploreUsedBtn => 'Jelajahi Barang Bekas';

  @override
  String get catalogLoadingBanner =>
      'Menyiapkan katalog… tampilan ini membantu saat sinyal lambat.';

  @override
  String get wishlistUpdatedSnack => 'Wishlist diperbarui';

  @override
  String get searchNoTrending => 'Belum ada kata kunci trending.';

  @override
  String get searchPhotoSortHint => 'Urutan dari kemiripan foto';

  @override
  String get searchProductsHint => 'Cari produk…';

  @override
  String get orderReviewBtn => 'Ulasan';

  @override
  String get orderTrackPackage => 'Lacak paket';

  @override
  String orderTrackingNumber(String number) {
    return 'Nomor resi:\n$number';
  }

  @override
  String get orderTrackOrder => 'Lacak pesanan';

  @override
  String get orderBuyAgain => 'Beli lagi';

  @override
  String get orderCancelQ => 'Batalkan pesanan?';

  @override
  String get orderCancelBody =>
      'Pesanan yang dibatalkan tidak dapat dikembalikan.';

  @override
  String get orderCancelConfirm => 'Ya, batalkan';

  @override
  String get orderCancelledSnack => 'Pesanan dibatalkan';

  @override
  String get orderCancelBtn => 'Batal';

  @override
  String get orderConfirmReceivedQ => 'Konfirmasi pesanan diterima?';

  @override
  String get orderConfirmReceivedBody =>
      'Pastikan barang sudah Anda terima dalam kondisi baik. Status pesanan akan menjadi Selesai.';

  @override
  String get orderConfirmReceivedBtn => 'Sudah sampai';

  @override
  String get orderCompletedSnack => 'Pesanan ditandai selesai';

  @override
  String orderCompletedAt(String date) {
    return 'Diterima: $date';
  }

  @override
  String get paymentSavedEarth => 'Anda telah menyelamatkan bumi';

  @override
  String paymentPointsRule(String total) {
    return 'Rp 1.000 belanja = 1 poin · total belanja $total';
  }

  @override
  String get paymentOrderProcessing => 'Pesanan Anda sedang diproses penjual.';

  @override
  String get paymentBackHome => 'Kembali ke beranda';

  @override
  String get paymentViewOrders => 'Lihat pesanan';

  @override
  String mapDistanceFromYou(String km) {
    return '~$km km dari Anda';
  }

  @override
  String get mapWebNominatimUnavailable =>
      'Di web, data Nominatim tidak tersedia (CORS).';

  @override
  String get shimmerSlowConnection => 'Memuat… koneksi mungkin sedang lambat.';

  @override
  String get shimmerFetchingSubtitle => 'Mengambil data… mohon tunggu.';

  @override
  String get ordersTabAll => 'Semua';

  @override
  String get ordersTabPending => 'Menunggu';

  @override
  String get ordersTabCompleted => 'Selesai';

  @override
  String orderTotalAmount(String amount) {
    return 'Total $amount';
  }

  @override
  String get orderStatusCompleted => 'Selesai';

  @override
  String get orderStatusProcessing => 'Diproses';

  @override
  String get orderStatusCancelled => 'Dibatalkan';

  @override
  String get proSellerBadge => 'Penjual Pro';

  @override
  String get authInvalidEmail => 'Format email tidak valid.';

  @override
  String get authUserDisabled => 'Akun ini dinonaktifkan.';

  @override
  String get authUserNotFound => 'Email belum terdaftar.';

  @override
  String get authWrongPassword => 'Kata sandi salah.';

  @override
  String get authEmailInUse => 'Email sudah digunakan. Coba masuk.';

  @override
  String get authWeakPassword =>
      'Kata sandi terlalu lemah (minimal 6 karakter).';

  @override
  String get authOperationNotAllowed =>
      'Metode masuk belum diaktifkan di Firebase Console.';

  @override
  String get authInvalidCredential => 'Email atau kata sandi salah.';

  @override
  String get authTooManyRequests =>
      'Terlalu banyak percobaan. Coba lagi nanti.';

  @override
  String get authNetworkFailed => 'Koneksi gagal. Periksa internet Anda.';

  @override
  String get authAccountExistsDifferent =>
      'Email sudah terdaftar dengan metode lain (mis. Google).';

  @override
  String get authGoogleSignInFailed =>
      'Gagal masuk dengan Google. Periksa SHA-1, Web Client ID, dan provider Google di Firebase.';

  @override
  String get authFirebaseNotReady =>
      'Firebase belum siap. Restart aplikasi setelah konfigurasi google-services.json.';

  @override
  String authFailedWithCode(String code) {
    return 'Autentikasi gagal ($code).';
  }

  @override
  String get authPlatformGoogleFailed =>
      'Google Sign-In gagal. Tambahkan SHA-1 di Firebase Console dan unduh ulang google-services.json.';

  @override
  String authPlatformFailedWithCode(String code) {
    return 'Masuk gagal ($code).';
  }

  @override
  String get authGoogleSignInCancelled => 'Masuk Google dibatalkan.';

  @override
  String get authGoogleNoEmail => 'Akun Google tidak memiliki email.';

  @override
  String get authGoogleEmptyToken =>
      'Token Google kosong. Periksa Web Client ID dan oauth_client di google-services.json.';

  @override
  String get authGoogleNetworkError =>
      'Koneksi gagal saat masuk Google. Periksa internet Anda.';

  @override
  String get sellerApplicationStatus => 'Status pengajuan penjual';

  @override
  String get noSellerApplicationYet => 'Anda belum mengajukan menjadi penjual.';

  @override
  String get applicationPendingMessage =>
      'Pengajuan sedang ditinjau admin. Mohon tunggu persetujuan atau penolakan.';

  @override
  String get applicationApprovedMessage =>
      'Disetujui! Anda dapat menggunakan fitur penjual di aplikasi.';

  @override
  String get applicationRejectedMessage =>
      'Pengajuan ditolak. Lihat alasan di bawah atau ajukan ulang.';

  @override
  String get submitNewSellerApplication => 'Ajukan ulang';

  @override
  String get viewSellerApplicationStatus => 'Lihat status pengajuan';

  @override
  String get adminAccessDenied => 'Anda tidak memiliki akses ke bagian ini.';

  @override
  String get adminEmailNotConfigured =>
      'Email admin belum diatur. Edit lib/config/app_admin_local.dart dan firestore.rules (adminEmail).';

  @override
  String get submittedLabel => 'Diajukan';

  @override
  String get accountLoginLabel => 'Akun yang login';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleUser => 'Pengguna';

  @override
  String adminLoginHint(String email) {
    return 'Panel admin hanya untuk $email. Masuk dengan Email/Kata sandi (bukan Google) memakai alamat itu.';
  }

  @override
  String get ecoModeTitle => 'Mode ringan';

  @override
  String get ecoModeSubtitle =>
      'Green computing: gambar lebih kecil, beranda lebih sedikit item, startup lebih ringan — cocok HP RAM kecil.';

  @override
  String get clearLocalData => 'Hapus data lokal';

  @override
  String get clearLocalDataSubtitle =>
      'Hapus pesanan, favorit, dan ulasan tersimpan di HP ini. Tutup lalu buka lagi aplikasinya.';

  @override
  String get clearLocalDataDone =>
      'Data lokal dihapus. Tutup aplikasi sepenuhnya lalu buka lagi.';

  @override
  String get editStore => 'Edit toko';

  @override
  String get deleteStore => 'Hapus toko';

  @override
  String get deleteStoreConfirm =>
      'Toko dan semua produk Anda akan dihapus dari aplikasi. Lanjutkan?';

  @override
  String get storeUpdated => 'Profil toko diperbarui.';

  @override
  String get storeDeleted => 'Toko dihapus.';

  @override
  String get productUpdated => 'Produk diperbarui.';

  @override
  String get productDeleted => 'Produk dihapus.';

  @override
  String get deleteProductConfirm =>
      'Produk ini akan dihapus permanen dari katalog.';

  @override
  String get manageSellerRequests => 'Kelola pengajuan penjual';

  @override
  String get manageRewards => 'Kelola hadiah';
}
