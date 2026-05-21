# Penyelarasan Firebase (app + RTDB + Vercel)

## Arsitektur saat ini

| Layanan | Proyek Firebase |
|---------|-----------------|
| App (Auth, FCM token di HP) | **shop-e1ab3** (`google-services.json`) |
| Realtime Database barang | **project-uas-44504** |
| shopping-cloud (Vercel) | **project-uas-44504** |

## Vercel sudah terhubung

Cek di browser atau Postman:

`GET https://shopping-cloud-vert.vercel.app/health`

Harus `{"ok":true,"firebase":"project-uas-44504",...}`.

Saat debug, app mencetak hasil cek ini di log (`shopping-cloud OK` / `gagal`).

## Notifikasi push (FCM topic)

Topic `preloved-shopping` harus ada di **proyek yang sama** dengan app yang subscribe.

- App subscribe lewat FCM token proyek **shop-e1ab3**.
- Cloud mengirim lewat service account **project-uas-44504**.

**Agar notifikasi sampai ke HP:** pilih salah satu:

1. **Disarankan jangka panjang:** pindahkan app ke **project-uas-44504** (tambah Android `com.example.shopping`, ganti `google-services.json` + `firebase_options.dart`).
2. **Alternatif:** ganti service account di Vercel ke **shop-e1ab3** dan deploy ulang shopping-cloud.

## Realtime Database

- Baca produk: rules `.read: true` → semua user bisa lihat katalog.
- Tulis produk: rules `.write: "auth != null"` → butuh login Firebase.

Token login dari **shop-e1ab3** tidak otomatis valid di rules **project-uas**. Jika publish produk gagal:

- Sementara (dev): di Console RTDB set `products` → `.write": true`.
- Production: satukan proyek app dengan RTDB (poin 1 di atas).

## Google Sign-In

Wajib di proyek **shop-e1ab3** (sama `google-services.json`):

1. Authentication → Google → Enable.
2. SHA-1 + SHA-256 dari `cd android; .\gradlew signingReport`.
3. Unduh ulang `google-services.json` (`oauth_client` tidak kosong).
4. Isi Web Client ID di `lib/config/google_sign_in_local.dart`.

Detail: `docs/FIREBASE_GOOGLE_SIGNIN.md`.
