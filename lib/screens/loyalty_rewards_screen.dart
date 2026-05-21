import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../models/reward_catalog_item.dart';
import '../providers/loyalty_points_provider.dart';
import '../providers/rewards_catalog_provider.dart';
import '../utils/loyalty_points.dart';
import '../utils/l10n_helpers.dart';

/// Tukar poin dengan voucher / hadiah dari katalog admin.
class LoyaltyRewardsScreen extends StatelessWidget {
  const LoyaltyRewardsScreen({super.key});

  static const route = '/loyalty-rewards';

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(loc.loyaltyRewards),
        backgroundColor: AppBranding.seedColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<LoyaltyPointsProvider, RewardsCatalogProvider>(
        builder: (context, loyalty, catalog, _) {
          final level = currentLoyaltyLevel(loyalty.lifetimeEarned);
          final items = catalog.activeItems;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _BalanceCard(
                balance: loyalty.balance,
                lifetime: loyalty.lifetimeEarned,
                levelName: level.name,
                levelIndex: level.index,
              ),
              const SizedBox(height: 20),
              Text(
                loc.rewardsAvailable,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(loc.noActiveRewards),
                  ),
                )
              else
                ...items.map(
                  (item) => _RewardTile(
                    item: item,
                    canAfford: loyalty.balance >= item.pointCost,
                    onRedeem: () => _redeem(context, item),
                  ),
                ),
              if (loyalty.redemptionLog.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  loc.redemptionHistory,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...loyalty.redemptionLog.take(8).map((r) {
                  final title = r['title'] as String? ?? '';
                  final cost = r['pointCost'] as int? ?? 0;
                  final code = r['voucherCode'] as String?;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.card_giftcard_rounded),
                      title: Text(title),
                      subtitle: Text(
                        code != null && code.isNotEmpty
                            ? loc.voucherLine(code, cost)
                            : '-$cost',
                      ),
                    ),
                  );
                }),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _redeem(BuildContext context, RewardCatalogItem item) async {
    final loc = context.l10n;
    final loyalty = context.read<LoyaltyPointsProvider>();
    if (loyalty.balance < item.pointCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.notEnoughPoints)),
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(rewardCatalogTitleL10n(loc, item.id) ?? item.title),
        content: Text(
          loc.redeemConfirm(
            item.pointCost,
            rewardCatalogDescriptionL10n(loc, item.id) ?? item.description,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.redeem),
          ),
        ],
      ),
    );

    if (ok != true || !context.mounted) return;

    final success = loyalty.redeem(
      rewardId: item.id,
      title: rewardCatalogTitleL10n(loc, item.id) ?? item.title,
      pointCost: item.pointCost,
      voucherCode: item.voucherCode,
    );

    if (!context.mounted) return;
    if (success) {
      final codeMsg = item.voucherCode != null
          ? ' ${item.voucherCode}'
          : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.redeemSuccess(codeMsg)),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.balance,
    required this.lifetime,
    required this.levelName,
    required this.levelIndex,
  });

  final int balance;
  final int lifetime;
  final String levelName;
  final int levelIndex;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final progress = loyaltyLevelProgress(lifetime);
    final next = nextLoyaltyLevel(lifetime);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppBranding.seedColor,
            AppBranding.seedColor.withValues(alpha: 0.75),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  loc.levelLine(levelIndex, levelName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '$balance',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            loc.pointsAvailable,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            loc.lifetimePoints(lifetime),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              color: Colors.amber,
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 6),
            Text(
              loc.pointsToNext(next.name, next.minLifetimePoints - lifetime),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ] else
            Text(
              loc.maxLevelReached,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({
    required this.item,
    required this.canAfford,
    required this.onRedeem,
  });

  final RewardCatalogItem item;
  final bool canAfford;
  final VoidCallback onRedeem;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppBranding.seedColor.withValues(alpha: 0.15),
              child: Icon(
                Icons.local_offer_rounded,
                color: AppBranding.seedColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rewardCatalogTitleL10n(loc, item.id) ?? item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rewardCatalogDescriptionL10n(loc, item.id) ??
                        item.description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.rewardPointCostLine(item.pointCost),
                    style: TextStyle(
                      color: AppBranding.seedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: canAfford ? onRedeem : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppBranding.seedColor,
              ),
              child: Text(loc.redeem),
            ),
          ],
        ),
      ),
    );
  }
}
