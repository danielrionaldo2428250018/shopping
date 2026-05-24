const admin = require('firebase-admin');

function initAdmin() {
  if (admin.apps.length) return;
  if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
    const sa = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON);
    admin.initializeApp({ credential: admin.credential.cert(sa) });
    return;
  }
  try {
    // eslint-disable-next-line import/no-unresolved, global-require
    const sa = require('../serviceAccountKey.json');
    admin.initializeApp({ credential: admin.credential.cert(sa) });
  } catch (_) {
    throw new Error(
      'Service account tidak ditemukan. Set FIREBASE_SERVICE_ACCOUNT_JSON di Vercel atau letakkan serviceAccountKey.json (proyek project-uas-44504).',
    );
  }
}

function cors(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
}

module.exports = async (req, res) => {
  cors(res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') {
    return res.status(405).json({ success: false, error: 'Method not allowed' });
  }

  try {
    initAdmin();
    const body = req.body || {};
    const topic = String(body.topic || 'preloved-shopping');
    const title = String(body.title || 'SECO');
    const msgBody = String(body.body || '');
    const senderName = String(body.senderName || 'SECO');
    const senderPhotoUrl = String(body.senderPhotoUrl || '');
    const sentAt = String(body.sentAt || new Date().toISOString());
    const extra = body.data && typeof body.data === 'object' ? body.data : {};

    const dataPayload = {
      title,
      body: msgBody,
      senderName,
      senderPhotoUrl,
      sentAt,
      ...Object.fromEntries(
        Object.entries(extra).map(([k, v]) => [k, String(v)]),
      ),
    };

    const isOrder = dataPayload.type === 'order';
    const message = {
      topic,
      notification: { title, body: msgBody },
      data: dataPayload,
      android: {
        priority: 'high',
        notification: {
          channelId: isOrder ? 'preloved_orders' : 'preloved_detailed',
          priority: 'max',
          defaultSound: true,
          defaultVibrateTimings: true,
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            alert: { title, body: msgBody },
          },
        },
      },
    };

    const messageId = await admin.messaging().send(message);
    return res.status(200).json({ success: true, ok: true, messageId });
  } catch (e) {
    console.error('send-to-topic', e);
    return res.status(500).json({
      success: false,
      error: String(e.message || e),
    });
  }
};
