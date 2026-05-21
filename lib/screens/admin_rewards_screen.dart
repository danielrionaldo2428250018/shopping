import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_admin_config.dart';
import '../constants/app_branding.dart';
import '../providers/auth_provider.dart';
import '../models/reward_catalog_item.dart';
import '../providers/rewards_catalog_provider.dart';
import '../utils/l10n_helpers.dart';

/// Admin: kelola hadiah yang bisa ditukar dengan poin.
class AdminRewardsScreen extends StatelessWidget {
  const AdminRewardsScreen({super.key});

  static const route = '/admin-rewards';

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final auth = context.watch<AuthProvider>();

    if (!isAppAdminConfigured || !auth.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.adminRewards)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              !isAppAdminConfigured
                  ? loc.adminEmailNotConfigured
                  : loc.adminAccessDenied,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.adminRewards),
        backgroundColor: AppBranding.seedColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(loc.addReward),
        backgroundColor: AppBranding.seedColor,
      ),
      body: Consumer<RewardsCatalogProvider>(
        builder: (context, catalog, _) {
          if (catalog.items.isEmpty) {
            return Center(child: Text(loc.noRewardsAdmin));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: catalog.items.length,
            itemBuilder: (context, i) {
              final item = catalog.items[i];
              return Card(
                child: ListTile(
                  title: Text(
                    rewardCatalogTitleL10n(loc, item.id) ?? item.title,
                  ),
                  subtitle: Text(
                    '${item.pointCost} · '
                    '${item.active ? loc.active : loc.no}'
                    '${item.voucherCode != null ? " · ${item.voucherCode}" : ""}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'edit') {
                        _openEditor(context, existing: item);
                      } else if (v == 'toggle') {
                        catalog.setActive(item.id, !item.active);
                      } else if (v == 'delete') {
                        catalog.removeItem(item.id);
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'edit', child: Text(loc.edit)),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(loc.activeInactive),
                      ),
                      PopupMenuItem(value: 'delete', child: Text(loc.delete)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context, {
    RewardCatalogItem? existing,
  }) async {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final costCtrl = TextEditingController(
      text: existing?.pointCost.toString() ?? '100',
    );
    final codeCtrl = TextEditingController(text: existing?.voucherCode ?? '');

    final loc = context.l10n;
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? loc.addReward : loc.edit),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(labelText: loc.productName),
              ),
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(labelText: loc.rewardDescription),
                maxLines: 3,
              ),
              TextField(
                controller: costCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: loc.rewardPointCost),
              ),
              TextField(
                controller: codeCtrl,
                decoration: InputDecoration(
                  labelText: loc.voucherCodeOptional,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.save),
          ),
        ],
      ),
    );

    if (saved != true || !context.mounted) return;

    final cost = int.tryParse(costCtrl.text.trim()) ?? 0;
    if (titleCtrl.text.trim().isEmpty || cost <= 0) return;

    final catalog = context.read<RewardsCatalogProvider>();
    final item = RewardCatalogItem(
      id: existing?.id ?? 'reward-${DateTime.now().millisecondsSinceEpoch}',
      title: titleCtrl.text.trim(),
      description: descCtrl.text.trim(),
      pointCost: cost,
      voucherCode: codeCtrl.text.trim().isEmpty ? null : codeCtrl.text.trim(),
      active: existing?.active ?? true,
    );

    if (existing == null) {
      catalog.addItem(item);
    } else {
      catalog.updateItem(item);
    }
  }
}
