import '../l10n/app_localizations.dart';

bool _isId(AppLocalizations loc) =>
    loc.localeName.startsWith('id');

String orderStatusLabelExtended(AppLocalizations loc, String status) {
  switch (status) {
    case 'Packing':
      return _isId(loc) ? 'Dikemas' : 'Packing';
    case 'InProcess':
      return _isId(loc) ? 'Di proses' : 'In transit';
    case 'Processing':
      return loc.orderStatusProcessing;
    case 'Completed':
      return loc.orderStatusCompleted;
    case 'Cancelled':
      return loc.orderStatusCancelled;
    default:
      return status;
  }
}

String orderSellerNewTitle(AppLocalizations loc) =>
    _isId(loc) ? 'Pesanan baru' : 'New order';

String orderSellerNewBody(AppLocalizations loc, String orderId) =>
    _isId(loc)
        ? 'Pesanan $orderId menunggu dikemas.'
        : 'Order $orderId is waiting to be packed.';

String orderStartPackingBtn(AppLocalizations loc) =>
    _isId(loc) ? 'Mulai dikemas' : 'Start packing';

String orderFinishPackingBtn(AppLocalizations loc) =>
    _isId(loc) ? 'Selesai dikemas' : 'Finish packing';

String orderCancelOrderBtn(AppLocalizations loc) =>
    _isId(loc) ? 'Batalkan pesanan' : 'Cancel order';

String orderCancelConfirmQ(AppLocalizations loc) =>
    _isId(loc) ? 'Batalkan pesanan ini?' : 'Cancel this order?';

String orderSellerOrdersTitle(AppLocalizations loc) =>
    _isId(loc) ? 'Pesanan toko' : 'Store orders';

String orderReviewTitle(AppLocalizations loc) =>
    _isId(loc) ? 'Ulas produk' : 'Review product';

String orderReviewHint(AppLocalizations loc) =>
    _isId(loc) ? 'Ceritakan pengalaman Anda…' : 'Share your experience…';

String orderReviewSubmit(AppLocalizations loc) =>
    _isId(loc) ? 'Kirim ulasan' : 'Submit review';

String orderComplainBtn(AppLocalizations loc) =>
    _isId(loc) ? 'Komplain' : 'Complain';

String orderReturnBtn(AppLocalizations loc) =>
    _isId(loc) ? 'Return' : 'Return';

String orderComplainPlaceholder(AppLocalizations loc) =>
    _isId(loc)
        ? 'Fitur komplain akan segera hadir.'
        : 'Complaint feature coming soon.';

String orderReturnPlaceholder(AppLocalizations loc) =>
    _isId(loc)
        ? 'Fitur return akan segera hadir.'
        : 'Return feature coming soon.';

String orderBuyerWaitingPack(AppLocalizations loc) =>
    _isId(loc)
        ? 'Penjual menyiapkan pesanan Anda.'
        : 'Seller is preparing your order.';

String orderCannotCancelInProcess(AppLocalizations loc) =>
    _isId(loc)
        ? 'Pesanan sudah dikirim — tidak bisa dibatalkan penjual.'
        : 'Order is in transit — seller cannot cancel.';
