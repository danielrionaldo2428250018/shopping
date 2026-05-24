# Plan Spark — foto produk di Realtime Database



Proyek **Spark** tidak bisa memakai Firebase Storage (perlu **Blaze**). Aplikasi ini **default** menyimpan foto produk di **Realtime Database**.



## Konfigurasi (default)



File `lib/config/media_upload_config.dart`:



```dart

static const bool useFirebaseStorage = false;

```



Foto dikompres (~640px, maks. ~500 KB) lalu disimpan sebagai **data-URL** di field `imageUrl` pada node `products/` di RTDB.



Logo toko memakai **inisial huruf** (tanpa unggah foto).



## Cocok untuk



- ~20 produk, 1–2 foto per produk (tugas / demo)

- Tanpa kartu kredit / tanpa upgrade Blaze



## Batasan



- Satu foto harus cukup kecil setelah kompresi (jika gagal: pilih foto lebih kecil)

- Banyak foto HD membuat database berat — hindari untuk produksi besar



## Jika nanti pakai Storage (Blaze)



1. Upgrade Blaze → aktifkan Storage di Console  

2. `firebase deploy --only storage`  

3. Ubah `useFirebaseStorage = true` di `media_upload_config.dart`


