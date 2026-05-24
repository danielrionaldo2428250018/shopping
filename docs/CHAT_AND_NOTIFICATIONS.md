# Obrolan & notifikasi penjual

## Di mana pesan disimpan?

| Lokasi | Isi |
|--------|-----|
| **Firebase RTDB** | `chats/{threadId}/meta` + `chats/{threadId}/messages` |
| **App — ikon chat (beranda)** | `/notifications` → bagian **Obrolan** |
| **App — profil penjual** | **Pesan** / **Notifikasi** |
| **App — profil pembeli** | **Obrolan** (`/chats`) atau dari **Detail produk → Chat** |

## Kenapa penjual belum dapat notifikasi?

Sebelumnya hanya ada simpan ke RTDB — **belum ada push ke penjual**. Sekarang:

1. Saat **pembeli** mengirim pesan → push ke topic FCM `preloved-seller-{nama-toko}`
2. Saat **penjual login** → app subscribe topic toko tersebut + tautkan UID ke thread

### Syarat notifikasi sampai ke HP penjual

- Penjual pernah **login** setelah jadi penjual (agar subscribe topic)
- **Izin notifikasi** diizinkan (dialog di halaman Pesan)
- **shopping-cloud** (`FcmConfig.cloudApiBaseUrl`) online untuk kirim FCM
- Aturan RTDB sudah di-deploy: `firebase deploy --only database`

## Uji cepat

1. Akun A (pembeli): buka produk → Chat → kirim pesan  
2. Akun B (penjual, nama toko sama dengan `sellerName` produk): login → buka **Pesan** → lihat thread → balas  
3. Penjual minimize app → pembeli kirim lagi → harus muncul notifikasi sistem (jika FCM OK)
