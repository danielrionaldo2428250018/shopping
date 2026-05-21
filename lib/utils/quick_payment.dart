import '../l10n/app_localizations.dart';

/// E-wallet / pembayaran cepat — memicu sidik jari jika diaktifkan di pengaturan.
abstract final class QuickPayment {
  static bool isQuickPayment(String methodLabel, AppLocalizations loc) {
    if (methodLabel.isEmpty) return false;
    final quick = {
      loc.payOvo,
      loc.payGopay,
      loc.payDana,
      loc.payShopeePay,
    };
    return quick.contains(methodLabel);
  }
}
