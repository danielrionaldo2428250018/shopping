# Katalog barang — Firebase Realtime Database

Produk disimpan di node **`products`** pada database:

`https://project-uas-44504-default-rtdb.asia-southeast1.firebasedatabase.app`

## Satu proyek Firebase

Agar Auth, RTDB, dan FCM (shopping-cloud) sama, gunakan proyek **`project-uas-44504`**:

1. Firebase Console → **Project Uas** → tambahkan app Android dengan package **`com.example.shopping`**.
2. Unduh **`google-services.json`** baru ke `android/app/`.
3. Jalankan `flutterfire configure` atau sesuaikan `lib/firebase_options.dart` (termasuk `databaseURL`).
4. Deploy **Rules** dari `database.rules.json`:

```bash
firebase use project-uas-44504
firebase deploy --only database
```

Atau salin isi `database.rules.json` ke **Firebase Console → Realtime Database → Rules → Publish**.

Rules `products`:
- **`.read: true` di node `products`** — wajib agar app bisa `listen` ke `/products` (bukan hanya per `$productId`).
- **Write**: pemilik (`sellerUid` = `auth.uid`), admin, atau pembeli yang mengurangi stok (checkout).

**Penting:** setelah ubah `database.rules.json`, jalankan `firebase deploy --only database` atau Publish di Console. Tanpa itu log akan `Permission denied` dan produk tidak muncul.

**Produk lama** tanpa `sellerUid`: edit sekali dari app (penjual) agar field terisi, atau hapus lalu tambah ulang.

## Notifikasi produk baru

Setelah publish dari app, `CatalogProvider` memanggil `shopping-cloud` → `POST /send-to-topic` (topic `preloved-shopping`), sama pola seperti fasum.

Pastikan `FcmConfig.cloudApiBaseUrl` mengarah ke deploy Vercel yang hidup dan service account **project-uas-44504** ada di env `FIREBASE_SERVICE_ACCOUNT_JSON`.

## Kosongkan semua produk

Di Firebase Console: hapus node **`products`**, atau dari folder `shopping-cloud`:

```powershell
node scripts/clear-rtdb-products.js
```

Produk hanya ditambah lewat **Add Product** di aplikasi (atau isi manual di Console).
