/// Status alur pesanan pembeli ↔ penjual.
abstract final class OrderStatus {
  static const processing = 'Processing';
  static const packing = 'Packing';
  static const inProcess = 'InProcess';
  static const completed = 'Completed';
  static const cancelled = 'Cancelled';

  static bool sellerCanCancel(String status) =>
      status == processing || status == packing;

  static bool buyerCanConfirmReceived(String status) => status == inProcess;
}
