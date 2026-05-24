# Firebase Storage — unggah foto produk

## Bukan izin galeri

Jika foto **sudah muncul** di form tambah produk tetapi publikasi gagal dengan pesan unggah, penyebabnya hampir selalu **Firebase Storage** (rules / belum login), bukan izin galeri.

## Wajib: deploy rules Firestore (edit toko)

Jika **logo/foto toko terunggah** tetapi simpan profil toko gagal, deploy aturan Firestore:

```bash
firebase use project-uas-44504
firebase deploy --only firestore:rules
```

File `firestore.rules` mengizinkan pemilik toko (email = akun login, status `approved`) mengubah data toko.

## Wajib: deploy rules Storage

Proyek: **project-uas-44504**  
Bucket: `project-uas-44504.firebasestorage.app`

1. Pasang [Firebase CLI](https://firebase.google.com/docs/cli) dan login: `firebase login`
2. Di folder proyek `shopping`:

```bash
firebase use project-uas-44504
firebase deploy --only storage
```

Atau salin isi `storage.rules` ke **Firebase Console → Storage → Rules → Publish**.

Rules mengizinkan user yang **sudah login** (`auth != null`) menulis ke:

- `products/{uid}/*.jpg`
- `store_logos/{applicationId}/*.jpg`

## Wajib: user sudah login Firebase

Unggah memakai `FirebaseAuth.currentUser`. Masuk lewat **email/kata sandi** atau **Google** di aplikasi sebelum publikasikan produk.

## Aktifkan Storage di Console

Firebase Console → **Build → Storage** → **Get started** (jika belum pernah).

## Cek error di log

Jalankan `flutter run` dan lihat log saat gagal:

- `unauthorized` / `permission-denied` → rules belum di-deploy
- `unauthenticated` → belum login Firebase
- `bucket-not-found` → Storage belum diaktifkan di proyek
