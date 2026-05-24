import '../l10n/app_localizations.dart';

/// Pesan singkat saat simpan/hapus produk ke RTDB gagal.
String catalogSaveFailureMessage(AppLocalizations loc, String? error) {
  if (error == null || error.trim().isEmpty) {
    return loc.publishFailed;
  }
  final e = error.trim();
  final lower = e.toLowerCase();
  if (e.contains('Firebase Auth belum siap')) {
    return 'Login belum siap. Tutup aplikasi, buka lagi, lalu masuk dengan Google.';
  }
  if (e == 'permission-denied' || lower.contains('permission-denied')) {
    return 'Akses ditolak. Produk harus milik akun Anda (sellerUid sama dengan login) '
        'atau belum punya pemilik — coba edit sekali atau buat produk baru.';
  }
  if (lower.contains('network') || lower.contains('unavailable')) {
    return 'Jaringan bermasalah. Coba lagi saat koneksi stabil.';
  }
  if (lower.contains('too large') || lower.contains('payload')) {
    return 'Data produk terlalu besar (biasanya foto). Pilih foto lebih kecil.';
  }
  return '${loc.publishFailed}\n$e';
}
