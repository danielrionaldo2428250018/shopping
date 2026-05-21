import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../l10n/app_localizations.dart';
import '../models/seller_application.dart';
import '../providers/auth_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/store_logo_avatar.dart';

/// Pemohon melihat status pengajuan penjual (read-only).
class SellerApplicationStatusScreen extends StatelessWidget {
  const SellerApplicationStatusScreen({super.key});

  static const route = '/my-seller-application';

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.sellerApplicationStatus)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              loc.signInToContinue,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
            appBar: AppBar(
        title: Text(loc.sellerApplicationStatus),
        backgroundColor: AppBranding.seedColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<SellerApplicationsProvider>(
        builder: (context, apps, _) {
          final app = apps.myLatestApplication;
          if (app == null) {
            return _EmptyState(
              message: loc.noSellerApplicationYet,
              actionLabel: loc.becomeSeller,
              onAction: () => Navigator.pushReplacementNamed(
                context,
                '/become-seller',
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatusBanner(status: app.status, loc: loc),
                const SizedBox(height: 16),
                Center(
                  child: StoreLogoAvatar(
                    storeName: app.storeName,
                    logoUrl: app.logoUrl,
                    logoPath: app.logoPath,
                    radius: 44,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  title: loc.storeInformation,
                  rows: [
                    _Row(loc.storeName, app.storeName),
                    _Row(loc.storeDescription, app.storeDescription),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: loc.contactInformation,
                  rows: [
                    _Row(loc.email, app.email),
                    _Row(loc.phoneLabel, app.phone),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: loc.storeAddress,
                  rows: [
                    _Row(loc.streetLabel, app.streetAddress),
                    _Row(loc.cityLabel, app.city),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: loc.administration,
                  rows: [
                    _Row(
                      loc.statusLabel,
                      sellerStatusLabel(app.status, loc),
                    ),
                    _Row(
                      loc.submittedLabel,
                      _formatDate(app.submittedAt),
                    ),
                    if (app.reviewedAt != null)
                      _Row(loc.reviewedLabel, _formatDate(app.reviewedAt!)),
                    if (app.rejectReason != null &&
                        app.rejectReason!.isNotEmpty)
                      _Row(loc.rejectReason, app.rejectReason!),
                  ],
                ),
                if (app.status == SellerApplicationStatus.rejected) ...[
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      '/become-seller',
                    ),
                    child: Text(loc.submitNewSellerApplication),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  static String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status, required this.loc});

  final SellerApplicationStatus status;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late IconData icon;
    late String message;

    switch (status) {
      case SellerApplicationStatus.pending:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade900;
        icon = Icons.hourglass_top_rounded;
        message = loc.applicationPendingMessage;
      case SellerApplicationStatus.approved:
        bg = Colors.green.shade50;
        fg = Colors.green.shade900;
        icon = Icons.check_circle_outline_rounded;
        message = loc.applicationApprovedMessage;
      case SellerApplicationStatus.rejected:
        bg = Colors.red.shade50;
        fg = Colors.red.shade900;
        icon = Icons.cancel_outlined;
        message = loc.applicationRejectedMessage;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final List<_Row> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 15, height: 1.35)),
        ],
      ),
    );
  }
}
