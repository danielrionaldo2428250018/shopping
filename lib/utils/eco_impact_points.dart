import 'loyalty_points.dart';

/// @deprecated Gunakan [loyaltyPointsForPurchaseTotal] — tetap dipakai field order.
int ecoPointsForPurchase({
  required int totalItemQuantity,
  required int distinctSkus,
  int? orderTotalRupiah,
}) {
  if (orderTotalRupiah != null && orderTotalRupiah > 0) {
    return loyaltyPointsForPurchaseTotal(orderTotalRupiah);
  }
  return 0;
}
