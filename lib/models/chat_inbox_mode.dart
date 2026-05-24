/// Mode daftar pesan: pembeli, penjual, atau gabungan.
enum ChatInboxMode {
  /// Hanya obrolan saat user membeli (tampilkan nama toko).
  buyer,

  /// Hanya obrolan masuk ke toko penjual (tampilkan nama pembeli).
  seller,

  /// Semua obrolan (ikon beranda).
  all,
}
