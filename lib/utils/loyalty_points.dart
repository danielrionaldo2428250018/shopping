/// Poin loyalitas: **Rp 1.000 belanja = 1 poin** (Rp 10.000 → 10 poin).
int loyaltyPointsForPurchaseTotal(int totalRupiah) {
  if (totalRupiah <= 0) return 0;
  return totalRupiah ~/ 1000;
}

class LoyaltyLevelTier {
  const LoyaltyLevelTier({
    required this.minLifetimePoints,
    required this.name,
    required this.index,
  });

  final int minLifetimePoints;
  final String name;
  final int index;
}

/// Level berdasarkan **total poin seumur hidup** (lifetime earned).
const List<LoyaltyLevelTier> kLoyaltyLevelTiers = [
  LoyaltyLevelTier(minLifetimePoints: 0, name: 'Newcomer', index: 0),
  LoyaltyLevelTier(minLifetimePoints: 500, name: 'Beginner', index: 1),
  LoyaltyLevelTier(minLifetimePoints: 2000, name: 'Bronze', index: 2),
  LoyaltyLevelTier(minLifetimePoints: 5000, name: 'Silver', index: 3),
  LoyaltyLevelTier(minLifetimePoints: 10000, name: 'Gold', index: 4),
  LoyaltyLevelTier(minLifetimePoints: 20000, name: 'Platinum', index: 5),
  LoyaltyLevelTier(minLifetimePoints: 35000, name: 'Diamond', index: 6),
  LoyaltyLevelTier(minLifetimePoints: 50000, name: 'Eco Champion', index: 7),
  LoyaltyLevelTier(minLifetimePoints: 75000, name: 'Planet Hero', index: 8),
  LoyaltyLevelTier(minLifetimePoints: 100000, name: 'Earth Guardian', index: 9),
];

LoyaltyLevelTier currentLoyaltyLevel(int lifetimePoints) {
  var current = kLoyaltyLevelTiers.first;
  for (final t in kLoyaltyLevelTiers) {
    if (lifetimePoints >= t.minLifetimePoints) {
      current = t;
    }
  }
  return current;
}

LoyaltyLevelTier? nextLoyaltyLevel(int lifetimePoints) {
  for (final t in kLoyaltyLevelTiers) {
    if (lifetimePoints < t.minLifetimePoints) return t;
  }
  return null;
}

/// Progres 0.0–1.0 menuju level berikutnya.
double loyaltyLevelProgress(int lifetimePoints) {
  final next = nextLoyaltyLevel(lifetimePoints);
  if (next == null) return 1.0;
  final current = currentLoyaltyLevel(lifetimePoints);
  final span = next.minLifetimePoints - current.minLifetimePoints;
  if (span <= 0) return 0;
  return ((lifetimePoints - current.minLifetimePoints) / span).clamp(0.0, 1.0);
}
