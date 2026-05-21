import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../utils/l10n_helpers.dart';

class BiometricAuthService {
  BiometricAuthService._();

  static final BiometricAuthService instance = BiometricAuthService._();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceReady() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Konfirmasi sidik jari / Face ID sebelum menyelesaikan pembayaran cepat.
  Future<bool> authenticateForPayment(BuildContext context) async {
    final loc = context.l10n;

    try {
      return await _auth.authenticate(
        localizedReason: loc.biometricAuthPaymentReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
