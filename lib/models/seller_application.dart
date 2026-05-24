/// Status pengajuan menjadi penjual (untuk panel admin).
enum SellerApplicationStatus {
  pending,
  approved,
  rejected,
}

extension SellerApplicationStatusX on SellerApplicationStatus {
  String get label {
    switch (this) {
      case SellerApplicationStatus.pending:
        return 'Menunggu';
      case SellerApplicationStatus.approved:
        return 'Disetujui';
      case SellerApplicationStatus.rejected:
        return 'Ditolak';
    }
  }
}

/// Satu pengajuan calon seller (data yang diisi + keputusan admin).
class SellerApplication {
  SellerApplication({
    required this.id,
    required this.submittedAt,
    required this.storeName,
    required this.storeDescription,
    required this.email,
    required this.phone,
    required this.streetAddress,
    required this.city,
    required this.agreedToTerms,
    this.logoPath,
    this.logoUrl,
    this.status = SellerApplicationStatus.pending,
    this.rejectReason,
    this.reviewedAt,
    this.latitude,
    this.longitude,
  });

  final String id;
  final DateTime submittedAt;
  String? logoPath;

  /// URL publik logo toko (Firebase Storage) — dipakai di halaman toko.
  String? logoUrl;

  final String storeName;
  final String storeDescription;
  /// Harus sama dengan email akun login agar otomatis jadi seller saat disetujui.
  final String email;
  final String phone;
  final String streetAddress;
  final String city;
  final bool agreedToTerms;

  SellerApplicationStatus status;
  String? rejectReason;
  DateTime? reviewedAt;

  /// Koordinat toko (geocoding OSM); diisi setelah berhasil lookup untuk peta.
  double? latitude;
  double? longitude;

  Map<String, dynamic> toJson() => {
        'id': id,
        'submittedAt': submittedAt.toIso8601String(),
        'storeName': storeName,
        'storeDescription': storeDescription,
        'email': email,
        'phone': phone,
        'streetAddress': streetAddress,
        'city': city,
        'agreedToTerms': agreedToTerms,
        'logoPath': logoPath,
        'logoUrl': logoUrl,
        'status': status.name,
        'rejectReason': rejectReason,
        'reviewedAt': reviewedAt?.toIso8601String(),
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

  SellerApplication copyWith({
    String? storeName,
    String? storeDescription,
    String? phone,
    String? streetAddress,
    String? city,
    String? logoPath,
    String? logoUrl,
    SellerApplicationStatus? status,
    String? rejectReason,
    DateTime? reviewedAt,
    double? latitude,
    double? longitude,
  }) {
    return SellerApplication(
      id: id,
      submittedAt: submittedAt,
      storeName: storeName ?? this.storeName,
      storeDescription: storeDescription ?? this.storeDescription,
      email: email,
      phone: phone ?? this.phone,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      agreedToTerms: agreedToTerms,
      logoPath: logoPath ?? this.logoPath,
      logoUrl: logoUrl ?? this.logoUrl,
      status: status ?? this.status,
      rejectReason: rejectReason ?? this.rejectReason,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory SellerApplication.fromJson(Map<String, dynamic> m) {
    return SellerApplication(
      id: m['id'] as String,
      submittedAt: DateTime.parse(m['submittedAt'] as String),
      storeName: m['storeName'] as String,
      storeDescription: m['storeDescription'] as String,
      email: m['email'] as String,
      phone: m['phone'] as String,
      streetAddress: m['streetAddress'] as String,
      city: m['city'] as String,
      agreedToTerms: m['agreedToTerms'] as bool,
      logoPath: m['logoPath'] as String?,
      logoUrl: m['logoUrl'] as String?,
      status: SellerApplicationStatus.values.firstWhere(
        (e) => e.name == m['status'],
        orElse: () => SellerApplicationStatus.pending,
      ),
      rejectReason: m['rejectReason'] as String?,
      reviewedAt: m['reviewedAt'] != null
          ? DateTime.tryParse(m['reviewedAt'] as String)
          : null,
      latitude: (m['latitude'] as num?)?.toDouble(),
      longitude: (m['longitude'] as num?)?.toDouble(),
    );
  }
}
