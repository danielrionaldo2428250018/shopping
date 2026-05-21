import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/seller_application.dart';

const String kSellerApplicationsCollection = 'sellerApplications';

Map<String, dynamic> sellerApplicationToCreateMap(SellerApplication a) {
  return {
    'submittedAt': Timestamp.fromDate(a.submittedAt),
    'storeName': a.storeName,
    'storeDescription': a.storeDescription,
    'email': a.email,
    'phone': a.phone,
    'streetAddress': a.streetAddress,
    'city': a.city,
    'agreedToTerms': a.agreedToTerms,
    'logoPath': a.logoPath,
    'logoUrl': a.logoUrl,
    'status': a.status.name,
    'rejectReason': a.rejectReason,
    'reviewedAt': a.reviewedAt != null
        ? Timestamp.fromDate(a.reviewedAt!)
        : null,
    if (a.latitude != null) 'latitude': a.latitude,
    if (a.longitude != null) 'longitude': a.longitude,
  };
}

SellerApplication sellerApplicationFromFirestore(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final m = doc.data()!;
  DateTime parseTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  return SellerApplication(
    id: doc.id,
    submittedAt: parseTime(m['submittedAt']),
    storeName: m['storeName'] as String? ?? '',
    storeDescription: m['storeDescription'] as String? ?? '',
    email: (m['email'] as String? ?? '').toLowerCase(),
    phone: m['phone'] as String? ?? '',
    streetAddress: m['streetAddress'] as String? ?? '',
    city: m['city'] as String? ?? '',
    agreedToTerms: m['agreedToTerms'] as bool? ?? false,
    logoPath: m['logoPath'] as String?,
    logoUrl: m['logoUrl'] as String?,
    status: SellerApplicationStatus.values.firstWhere(
      (e) => e.name == (m['status'] as String? ?? 'pending'),
      orElse: () => SellerApplicationStatus.pending,
    ),
    rejectReason: m['rejectReason'] as String?,
    reviewedAt: m['reviewedAt'] != null ? parseTime(m['reviewedAt']) : null,
    latitude: (m['latitude'] as num?)?.toDouble(),
    longitude: (m['longitude'] as num?)?.toDouble(),
  );
}

class SellerApplicationsRepository {
  SellerApplicationsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(kSellerApplicationsCollection);

  Stream<List<SellerApplication>> watchAll() {
    return _col
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => sellerApplicationFromFirestore(d))
              .toList(),
        );
  }

  /// Hanya pengajuan milik pemohon (email = akun login).
  Stream<List<SellerApplication>> watchByEmail(String email) {
    final e = email.trim().toLowerCase();
    return _col
        .where('email', isEqualTo: e)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => sellerApplicationFromFirestore(d))
              .toList()
            ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt)),
        );
  }

  Future<void> create(SellerApplication a) async {
    await _col.doc(a.id).set(sellerApplicationToCreateMap(a));
  }

  Future<void> approve(String id) async {
    await _col.doc(id).update({
      'status': SellerApplicationStatus.approved.name,
      'reviewedAt': FieldValue.serverTimestamp(),
      'rejectReason': null,
    });
  }

  Future<void> reject(String id, {String reason = ''}) async {
    await _col.doc(id).update({
      'status': SellerApplicationStatus.rejected.name,
      'reviewedAt': FieldValue.serverTimestamp(),
      'rejectReason': reason.trim().isEmpty ? null : reason.trim(),
    });
  }

  Future<void> updateCoordinates(String id, double lat, double lng) async {
    await _col.doc(id).update({
      'latitude': lat,
      'longitude': lng,
    });
  }

  /// Hapus semua dokumen (panel admin / migrasi). Gunakan batch jika banyak.
  Future<int> deleteAllDocuments() async {
    final snap = await _col.get();
    var n = 0;
    for (final d in snap.docs) {
      await d.reference.delete();
      n++;
    }
    return n;
  }
}
