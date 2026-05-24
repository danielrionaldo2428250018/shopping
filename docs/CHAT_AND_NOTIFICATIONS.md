# Obrolan & notifikasi penjual

## Di mana pesan disimpan?

| Lokasi | Isi |
|--------|-----|
| **Firebase RTDB** | `chats/{threadId}/meta` + `chats/{threadId}/messages` |
| **App — ikon chat (beranda)** | `/notifications` → bagian **Obrolan** |
| **App — profil penjual** | **Pesan** / **Notifikasi** |
| **App — profil pembeli** | **Obrolan** (`/chats`) atau dari **Detail produk → Chat** |

## Kenapa penjual belum dapat notifikasi?

Sekarang ada **popup sistem** (flutter_local_notifications, pola fasum) + **FCM topic**:

1. Saat **pembeli** mengirim pesan → push ke topic `preloved-seller-{slug-toko}`
2. Saat **pembeli** checkout / beli langsung → push pesanan ke topic yang sama
3. Saat **penjual** app terbuka & pesanan masuk RTDB → popup lokal + entri di daftar Pesan
4. Saat **penjual login** → subscribe topic toko + daftar `sellerAccounts`

### Syarat notifikasi sampai ke HP penjual

- Penjual pernah **login** setelah jadi penjual (agar subscribe topic)
- **Izin notifikasi** diizinkan (dialog di halaman Pesan)
- **shopping-cloud** (`https://shopping-cloud.vercel.app`) + env `FIREBASE_SERVICE_ACCOUNT_JSON` di Vercel (lihat `docs/SHOPPING_CLOUD_VERCEL.md`)
- Aturan RTDB sudah di-deploy: `firebase deploy --only database`

## Uji cepat

1. Akun A (pembeli): buka produk → Chat → kirim pesan  
2. Akun B (penjual, nama toko sama dengan `sellerName` produk): login → buka **Pesan** → lihat thread → balas  
3. Penjual minimize app → pembeli kirim lagi → harus muncul notifikasi sistem (jika FCM OK)
