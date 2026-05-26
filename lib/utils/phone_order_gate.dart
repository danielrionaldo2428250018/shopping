import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_profile_provider.dart';
import 'l10n_helpers.dart';

bool _digitsOk(String raw) {
  final d = raw.replaceAll(RegExp(r'\D'), '');
  return d.length >= 10;
}

/// Menampilkan dialog jika belum ada nomor HP valid; mengembalikan true jika boleh lanjut checkout.
Future<bool> ensurePhoneForOrder(BuildContext context) async {
  final loc = context.l10n;
  final profile = context.read<UserProfileProvider>();
  if (profile.hasValidPhone) return true;

  final ctrl = TextEditingController(text: profile.phone ?? '');
  final ok = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(loc.phoneRequiredTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.phoneOrderHint),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: loc.phoneHint,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_digitsOk(ctrl.text)) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(loc.phoneOrderHint)),
              );
              return;
            }
            Navigator.pop(ctx, true);
          },
          child: Text(loc.saveAndContinue),
        ),
      ],
    ),
  );

  if (ok == true && _digitsOk(ctrl.text)) {
    profile.setPhone(ctrl.text.trim());
    return true;
  }
  return false;
}
