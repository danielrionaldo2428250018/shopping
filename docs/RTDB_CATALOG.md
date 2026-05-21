# Katalog barang — Firebase Realtime Database

Produk disimpan di node **`products`** pada database:

`https://project-uas-44504-default-rtdb.asia-southeast1.firebasedatabase.app`

## Satu proyek Firebase

Agar Auth, RTDB, dan FCM (shopping-cloud) sama, gunakan proyek **`project-uas-44504`**:

1. Firebase Console → **Project Uas** → tambahkan app Android dengan package **`com.example.shopping`**.
2. Unduh **`google-services.json`** baru ke `android/app/`.
3. Jalankan `flutterfire configure` atau sesuaikan `lib/firebase_options.dart` (termasuk `databaseURL`).
4. Deploy **Rules** dari `database.rules.json` (tab Rules di Realtime Database).

Untuk uji tanpa login, sementara bisa set `.write": true` pada `products` — jangan dipakai di production.

## Notifikasi produk baru

Setelah publish dari app, `CatalogProvider` memanggil `shopping-cloud` → `POST /send-to-topic` (topic `preloved-shopping`), sama pola seperti fasum.

Pastikan `FcmConfig.cloudApiBaseUrl` mengarah ke deploy Vercel yang hidup dan service account **project-uas-44504** ada di env `FIREBASE_SERVICE_ACCOUNT_JSON`.

## Kosongkan semua produk

Di Firebase Console: hapus node **`products`**, atau dari folder `shopping-cloud`:

```powershell
node scripts/clear-rtdb-products.js
```

Produk hanya ditambah lewat **Add Product** di aplikasi (atau isi manual di Console).
