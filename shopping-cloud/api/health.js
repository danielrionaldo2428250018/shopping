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
      'Service account tidak ditemukan. Set FIREBASE_SERVICE_ACCOUNT_JSON di Vercel (proyek project-uas-44504).',
    );
  }
}

module.exports = async (req, res) => {
  try {
    initAdmin();
    const projectId =
      admin.app().options?.projectId ||
      process.env.GCLOUD_PROJECT ||
      'project-uas-44504';
    return res.status(200).json({
      ok: true,
      firebase: projectId,
      topic: 'preloved-shopping',
    });
  } catch (e) {
    return res.status(500).json({
      ok: false,
      error: String(e.message || e),
      hint: 'Set FIREBASE_SERVICE_ACCOUNT_JSON di Vercel (service account project-uas-44504).',
    });
  }
};
