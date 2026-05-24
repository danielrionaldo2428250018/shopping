import '../providers/loyalty_points_provider.dart';

/// Jenis manfaat voucher di halaman transaksi (checkout / beli langsung).
enum CheckoutVoucherKind {
  percent10Max50k,
  freeShipping,
  shippingOff15000,
  serviceFeeOff5Max25k,
}

/// Voucher yang dikenali saat checkout.
class CheckoutVoucher {
  const CheckoutVoucher({
    required this.code,
    required this.kind,
    required this.fromPoints,
    this.minSubtotal = 0,
  });

  final String code;
  final CheckoutVoucherKind kind;

  /// Dari penukaran poin (harus ada di riwayat & belum dipakai).
  final bool fromPoints;
  final int minSubtotal;
}

/// NEARMARKET10, GRATISONGKIR, POINONGKIR15, POIN10OFF, POINVIP1M, …
abstract final class CheckoutVoucherRules {
  static const nearMarket10 = 'NEARMARKET10';
  static const gratisOngkir = 'GRATISONGKIR';
  static const poinOngkir15 = 'POINONGKIR15';
  static const poin10Off = 'POIN10OFF';
  static const poinVip1m = 'POINVIP1M';

  static CheckoutVoucher? resolve(
    String rawCode,
    LoyaltyPointsProvider loyalty,
  ) {
    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) return null;

    switch (code) {
      case nearMarket10:
        return CheckoutVoucher(
          code: code,
          kind: CheckoutVoucherKind.percent10Max50k,
          fromPoints: false,
        );
      case gratisOngkir:
        return CheckoutVoucher(
          code: code,
          kind: CheckoutVoucherKind.freeShipping,
          fromPoints: false,
        );
      case poinOngkir15:
        if (!loyalty.isRedeemedVoucherAvailable(code)) return null;
        return const CheckoutVoucher(
          code: poinOngkir15,
          kind: CheckoutVoucherKind.shippingOff15000,
          fromPoints: true,
          minSubtotal: 100000,
        );
      case poin10Off:
        if (!loyalty.isRedeemedVoucherAvailable(code)) return null;
        return const CheckoutVoucher(
          code: poin10Off,
          kind: CheckoutVoucherKind.percent10Max50k,
          fromPoints: true,
        );
      case poinVip1m:
        if (!loyalty.isRedeemedVoucherAvailable(code)) return null;
        return const CheckoutVoucher(
          code: poinVip1m,
          kind: CheckoutVoucherKind.serviceFeeOff5Max25k,
          fromPoints: true,
        );
      default:
        return null;
    }
  }

  static int shippingAfterDiscount(int baseFee, CheckoutVoucher? voucher) {
    if (voucher == null) return baseFee;
    switch (voucher.kind) {
      case CheckoutVoucherKind.freeShipping:
        return 0;
      case CheckoutVoucherKind.shippingOff15000:
        return (baseFee - 15000).clamp(0, baseFee);
      default:
        return baseFee;
    }
  }

  static int orderDiscount(int subtotal, CheckoutVoucher? voucher) {
    if (voucher == null) return 0;
    switch (voucher.kind) {
      case CheckoutVoucherKind.percent10Max50k:
        return (subtotal * 0.1).round().clamp(0, 50000);
      case CheckoutVoucherKind.serviceFeeOff5Max25k:
        return (subtotal * 0.05).round().clamp(0, 25000);
      default:
        return 0;
    }
  }

  static bool meetsMinSubtotal(int subtotal, CheckoutVoucher? voucher) {
    if (voucher == null) return true;
    return subtotal >= voucher.minSubtotal;
  }
}
