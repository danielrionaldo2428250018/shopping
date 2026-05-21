/// Hadiah yang bisa ditukar dengan poin (dikelola admin).
class RewardCatalogItem {
  const RewardCatalogItem({
    required this.id,
    required this.title,
    required this.description,
    required this.pointCost,
    this.active = true,
    this.voucherCode,
  });

  final String id;
  final String title;
  final String description;
  final int pointCost;
  final bool active;
  final String? voucherCode;

  RewardCatalogItem copyWith({
    String? title,
    String? description,
    int? pointCost,
    bool? active,
    String? voucherCode,
  }) {
    return RewardCatalogItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointCost: pointCost ?? this.pointCost,
      active: active ?? this.active,
      voucherCode: voucherCode ?? this.voucherCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'pointCost': pointCost,
        'active': active,
        'voucherCode': voucherCode,
      };

  factory RewardCatalogItem.fromJson(Map<String, dynamic> m) {
    return RewardCatalogItem(
      id: m['id'] as String,
      title: m['title'] as String,
      description: m['description'] as String,
      pointCost: (m['pointCost'] as num).toInt(),
      active: m['active'] as bool? ?? true,
      voucherCode: m['voucherCode'] as String?,
    );
  }
}

class UserRedemption {
  const UserRedemption({
    required this.rewardId,
    required this.title,
    required this.pointCost,
    required this.redeemedAt,
    this.voucherCode,
  });

  final String rewardId;
  final String title;
  final int pointCost;
  final DateTime redeemedAt;
  final String? voucherCode;

  Map<String, dynamic> toJson() => {
        'rewardId': rewardId,
        'title': title,
        'pointCost': pointCost,
        'redeemedAt': redeemedAt.toIso8601String(),
        'voucherCode': voucherCode,
      };

  factory UserRedemption.fromJson(Map<String, dynamic> m) {
    return UserRedemption(
      rewardId: m['rewardId'] as String,
      title: m['title'] as String,
      pointCost: (m['pointCost'] as num).toInt(),
      redeemedAt: DateTime.parse(m['redeemedAt'] as String),
      voucherCode: m['voucherCode'] as String?,
    );
  }
}
