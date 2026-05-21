import 'package:flutter/material.dart';

import '../utils/l10n_helpers.dart';

/// Daftar metode pembayaran tersimpan (demo).
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  static const route = '/payment-methods';

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.paymentMethods),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tile(
            context,
            icon: Icons.account_balance_rounded,
            title: loc.payBcaVa,
            subtitle: loc.payAutoVerify,
            selected: true,
          ),
          _tile(
            context,
            icon: Icons.phone_android_rounded,
            title: loc.payOvo,
            subtitle: loc.paymentMethodsDesc,
            selected: false,
          ),
          _tile(
            context,
            icon: Icons.payment_rounded,
            title: loc.payCard,
            subtitle: loc.payCardSubtitle,
            selected: false,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.addPaymentMethodDemo)),
              );
            },
            icon: const Icon(Icons.add),
            label: Text(loc.addPaymentMethod),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
  }) {
    final loc = context.l10n;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF7B42F6)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: selected
            ? const Icon(Icons.check_circle, color: Color(0xFF7B42F6))
            : null,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.paymentSelectedDemo(title))),
          );
        },
      ),
    );
  }
}
