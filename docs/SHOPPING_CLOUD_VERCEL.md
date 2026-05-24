# shopping-cloud di Vercel (notifikasi seperti fasum)

Deploy Anda: **https://shopping-cloud.vercel.app**

App Flutter memanggil:

`POST https://shopping-cloud.vercel.app/send-to-topic`

## Wajib: Service Account Firebase

Saat ini `/health` mengembalikan `ok: false` jika **belum ada** env `FIREBASE_SERVICE_ACCOUNT_JSON`.

### Langkah (sekali)

1. Buka [Firebase Console](https://console.firebase.google.com) → proyek **`project-uas-44504`** (sama dengan `google-services.json` app).
2. **Project settings** → **Service accounts** → **Generate new private key** → unduh JSON.
3. Di Vercel → proyek **shopping-cloud** → **Settings** → **Environment Variables**:
   - Name: `FIREBASE_SERVICE_ACCOUNT_JSON`
   - Value: **seluruh isi file JSON** (satu baris juga boleh).
   - Environment: Production (+ Preview jika perlu).
4. **Redeploy** project (Deployments → … → Redeploy).

### Cek

Browser atau Postman:

`GET https://shopping-cloud.vercel.app/health`

Harus:

```json
{"ok":true,"firebase":"project-uas-44504","topic":"preloved-shopping"}
```

## Topic FCM (sama fasum)

| Topic | Siapa subscribe |
|-------|-----------------|
| `preloved-shopping` | Semua user (broadcast produk baru) |
| `preloved-seller-{slug-toko}` | Penjual saat login (pesan & pesanan toko itu) |

Slug toko = nama toko dinormalisasi (huruf kecil, spasi → `_`).

## Uji push

```bash
curl -X POST https://shopping-cloud.vercel.app/send-to-topic \
  -H "Content-Type: application/json" \
  -d "{\"topic\":\"preloved-shopping\",\"title\":\"Tes\",\"body\":\"Halo dari cloud\",\"senderName\":\"SECO\"}"
```

Respons sukses: `{"success":true,"ok":true,"messageId":"..."}`

## Deploy ulang dari folder `shopping-cloud/`

Di repo ini ada sumber API di folder **`shopping-cloud/`**. Di Vercel, set **Root Directory** = `shopping-cloud` (jika repo monorepo), lalu deploy.

## App Flutter

`lib/constants/fcm_config.dart` → `cloudApiBaseUrl` harus:

`https://shopping-cloud.vercel.app`

Setelah env Vercel benar + APK terbaru + izin notifikasi HP:

- Pembeli kirim chat / checkout → penjual dapat **FCM** + **banner atas layar** di app.
