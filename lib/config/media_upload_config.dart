/// Unggah foto produk — default **Realtime Database** (data-URL terkompres, plan Spark).
///
/// Logo toko memakai inisial huruf (tanpa unggah). Untuk Firebase Storage, set
/// [useFirebaseStorage] = true lalu deploy `storage.rules` (perlu Blaze).
abstract final class MediaUploadConfig {
  /// `false` = simpan foto di RTDB (`imageUrl` data-URL). `true` = Firebase Storage.
  static const bool useFirebaseStorage = false;

  /// Kompresi saat unggah ke Firebase Storage.
  static const int productImageMaxWidth = 1024;
  static const int productImageJpegQuality = 78;

  /// Kompresi saat simpan ke RTDB (lebih kecil = scroll lebih ringan).
  static const int rtdbImageMaxWidth = 480;
  static const int rtdbImageJpegQuality = 65;
  static const int rtdbImageMaxBytes = 320000;
}
