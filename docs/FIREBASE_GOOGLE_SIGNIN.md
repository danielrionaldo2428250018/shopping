# Google Sign-In dengan Firebase Authentication



Agar tombol **Continue with Google** berfungsi di PreLoved (Android).



## 1. Firebase Console — proyek **shop-e1ab3**



1. [Firebase Console](https://console.firebase.google.com) → **shop-e1ab3**.

2. **Build** → **Authentication** → **Sign-in method**.

3. Aktifkan **Google** → email support → **Save**.

4. Aktifkan **Email/Password** jika dipakai.



## 2. SHA-1 fingerprint (Android)



```powershell

cd android

.\gradlew signingReport

```



Salin **SHA-1** (dan **SHA-256**) dari variant `debug`.



1. **Project settings** → app Android `com.example.shopping`.

2. **Add fingerprint** → tempel SHA-1 & SHA-256 → Save.



## 3. Unduh ulang `google-services.json`



Ganti `android/app/google-services.json`.



Pastikan `oauth_client` **tidak kosong** (minimal client_type **3** = Web).



## 4. Web Client ID di Flutter



Salin **Web client ID** (client_type 3) ke:



`lib/config/google_sign_in_local.dart`



```dart

const String kGoogleWebClientIdLocal =

    'XXXX.apps.googleusercontent.com';

```



Atau saat run:



```powershell

flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=XXXX.apps.googleusercontent.com

```



## 5. Build ulang



```powershell

flutter clean

flutter pub get

flutter run

```



Log debug akan menampilkan `shopping-cloud OK` jika Vercel hidup, atau peringatan jika Web Client ID belum diisi.



## Error umum



| Gejala | Solusi |

|--------|--------|

| `ApiException: 10` | SHA-1 belum ditambahkan atau json lama |

| `oauth_client: []` | Unduh ulang json setelah enable Google + SHA-1 |

| `Token Google kosong` | Isi Web Client ID di `google_sign_in_local.dart` |

| `operation-not-allowed` | Enable Google di Authentication |

| `invalid-credential` | Web Client ID salah atau proyek tidak cocok |

| Pesan "belum dikonfigurasi" | Isi `kGoogleWebClientIdLocal` (langkah 4) |



## Cek berhasil



1. Login → **Continue with Google** → masuk beranda.

2. Firebase Console → **Authentication** → **Users** → user Google muncul.



Lihat juga `docs/FIREBASE_ALIGNMENT.md` untuk RTDB + Vercel + FCM.


