/// Email admin tunggal — harus sama dengan akun **Email/Password** di Firebase Auth.
///
/// Jika menu admin tidak muncul, salin **User UID** dari Firebase Console
/// (Authentication → Users → baris akun Anda) ke [kAppAdminUidLocal] di bawah.
///
/// Deploy Firestore: sesuaikan juga `adminEmail()` di `firestore.rules`.
const String kAppAdminEmailLocal = 'danielrionaldo_2428250018@mhs.mdp.ac.id';

/// Opsional. Isi UID lengkap jika login sudah benar tetapi `isAdmin` tetap false.
const String kAppAdminUidLocal = 'S3zzmx2SJ5WDN8bhzJHep5BTepy1';
