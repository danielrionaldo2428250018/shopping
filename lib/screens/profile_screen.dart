import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../providers/auth_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../providers/loyalty_points_provider.dart';
import '../models/chat_inbox_mode.dart';
import '../providers/inbox_messages_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/user_profile_provider.dart';
import '../styles/app_colors_extension.dart';
import '../utils/app_screen_style.dart';
import '../utils/loyalty_points.dart';
import '../utils/l10n_helpers.dart';
import 'admin_rewards_screen.dart';
import 'loyalty_rewards_screen.dart';
import 'seller_application_status_screen.dart';
import 'settings_screen.dart';

/// Profil user biasa — header gradient, kartu statistik, menu.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _purple = Color(0xFF8E44AD);

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final colors = appColors(context);
    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 52, 20, 28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: colors.profileHeaderGradient,
                    ),
                  ),
                  child: Column(
                    children: [
                      Consumer<UserProfileProvider>(
                        builder: (context, profile, _) {
                          final path = profile.avatarLocalPath;
                          final hasAvatar = path != null &&
                              path.isNotEmpty &&
                              File(path).existsSync();
                          final avatarPath = path;
                          return CircleAvatar(
                            radius: 48,
                            backgroundColor: appCardColor(context),
                            backgroundImage:
                                hasAvatar && avatarPath != null
                                ? FileImage(File(avatarPath))
                                : null,
                            child: !hasAvatar
                                ? const Icon(
                                    Icons.person_rounded,
                                    size: 52,
                                    color: _purple,
                                  )
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      Consumer<UserProfileProvider>(
                        builder: (context, profile, _) {
                          return Text(
                            profile.displayNameOrDefault,
                            style: TextStyle(
                              color: colors.onHeader,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Consumer<UserProfileProvider>(
                        builder: (context, profile, _) {
                          return Text(
                            profile.handleOrDefault,
                            style: TextStyle(
                              color: colors.onHeader.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          Consumer<LoyaltyPointsProvider>(
                            builder: (context, loyalty, _) {
                              final level =
                                  currentLoyaltyLevel(loyalty.lifetimeEarned);
                              return Chip(
                                avatar: Icon(
                                  Icons.eco_rounded,
                                  size: 18,
                                  color: Colors.green.shade300,
                                ),
                                label: Text(
                                  loc.levelLine(level.index, level.name),
                                  style: TextStyle(
                                    color: colors.headerPillText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: colors.headerPillBg,
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              );
                            },
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/edit-profile',
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.headerPillBg,
                              foregroundColor: colors.headerPillText,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            child: Text(loc.editProfile),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: appPageInsets(context),
              child: Consumer<LoyaltyPointsProvider>(
                builder: (context, loyalty, _) {
                  final level =
                      currentLoyaltyLevel(loyalty.lifetimeEarned);
                  final progress = loyaltyLevelProgress(loyalty.lifetimeEarned);
                  final next = nextLoyaltyLevel(loyalty.lifetimeEarned);
                  return Material(
                    color: appCardColor(context),
                    borderRadius: BorderRadius.circular(18),
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.08),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => Navigator.pushNamed(
                        context,
                        LoyaltyRewardsScreen.route,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.stars_rounded,
                                  color: Colors.amber.shade700,
                                  size: 28,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    loc.loyaltyRewards,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${loyalty.balance}',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppBranding.seedColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${loc.levelLine(level.index, level.name)} · ${loc.lifetimePoints(loyalty.lifetimeEarned)}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade200,
                                color: AppBranding.seedColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              next != null
                                  ? loc.pointsToNext(
                                      next.name,
                                      next.minLifetimePoints -
                                          loyalty.lifetimeEarned,
                                    )
                                  : loc.maxLevelReached,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  loc.redeem,
                                  style: TextStyle(
                                    color: AppBranding.seedColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: appPageInsets(context),
              child: Container(
                decoration: BoxDecoration(
                  color: appCardColor(context),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .shadowColor
                          .withValues(alpha: 0.08),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _menuRow(
                      context,
                      iconBg: Colors.green.shade50,
                      iconColor: Colors.green.shade700,
                      icon: Icons.card_giftcard_rounded,
                      title: loc.loyaltyRewards,
                      onTap: () => Navigator.pushNamed(
                        context,
                        LoyaltyRewardsScreen.route,
                      ),
                    ),
                    Divider(height: 1, color: appBorderColor(context)),
                    Consumer2<InboxMessagesProvider, ChatProvider>(
                      builder: (context, inbox, chat, _) {
                        final unread =
                            inbox.unreadCount +
                            chat.unreadForMode(ChatInboxMode.buyer);
                        return _menuRow(
                          context,
                          iconBg: Colors.purple.shade50,
                          iconColor: _purple,
                          icon: Icons.chat_bubble_outline_rounded,
                          title: loc.messages,
                          badge: unread > 0 ? '$unread' : null,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/notifications',
                            arguments: ChatInboxMode.buyer,
                          ),
                        );
                      },
                    ),
                    Divider(height: 1, color: appBorderColor(context)),
                    _menuRow(
                      context,
                      iconBg: Colors.purple.shade50,
                      iconColor: _purple,
                      icon: Icons.shopping_cart_outlined,
                      title: loc.cart,
                      onTap: () =>
                          Navigator.pushNamed(context, '/cart'),
                    ),
                    Divider(height: 1, color: appBorderColor(context)),
                    _menuRow(
                      context,
                      iconBg: Colors.purple.shade50,
                      iconColor: _purple,
                      icon: Icons.inventory_2_outlined,
                      title: loc.myOrders,
                      onTap: () =>
                          Navigator.pushNamed(context, '/orders'),
                    ),
                    Divider(height: 1, color: appBorderColor(context)),
                    Consumer3<AuthProvider, SellerApplicationsProvider,
                        UserProfileProvider>(
                      builder: (context, auth, apps, profile, _) {
                        if (!auth.isLoggedIn) {
                          return const SizedBox.shrink();
                        }
                        if (auth.isAdmin) {
                          return Column(
                            children: [
                              _menuRow(
                                context,
                                iconBg: Colors.purple.shade50,
                                iconColor: _purple,
                                icon: Icons.fact_check_outlined,
                                title: loc.manageSellerRequests,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/admin-seller-applications',
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: appBorderColor(context),
                              ),
                              _menuRow(
                                context,
                                iconBg: Colors.purple.shade50,
                                iconColor: _purple,
                                icon: Icons.card_giftcard_outlined,
                                title: loc.manageRewards,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AdminRewardsScreen.route,
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: appBorderColor(context),
                              ),
                            ],
                          );
                        }
                        if (auth.isSeller) {
                          return const SizedBox.shrink();
                        }
                        final hasApp = apps.hasMyApplication;
                        return Column(
                          children: [
                            Container(
                              color: const Color(0xFFEFFAF0),
                              child: _menuRow(
                                context,
                                iconBg: Colors.green.shade50,
                                iconColor: Colors.green.shade700,
                                icon: hasApp
                                    ? Icons.fact_check_outlined
                                    : Icons.storefront_outlined,
                                title: hasApp
                                    ? loc.viewSellerApplicationStatus
                                    : loc.becomeSeller,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  hasApp
                                      ? SellerApplicationStatusScreen.route
                                      : '/become-seller',
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey.shade200,
                            ),
                          ],
                        );
                      },
                    ),
                    _menuRow(
                      context,
                      iconBg: Colors.grey.shade100,
                      iconColor: Colors.grey.shade700,
                      icon: Icons.settings_outlined,
                      title: loc.settings,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    Divider(height: 1, color: appBorderColor(context)),
                    InkWell(
                      onTap: () {
                        Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).logout();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      borderRadius:
                          const BorderRadius.vertical(bottom: Radius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  Colors.red.shade50,
                              child: Icon(
                                Icons.logout_rounded,
                                color: Colors.red.shade400,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                loc.logout,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.shade600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget _menuRow(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? badge,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: iconBg,
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style:
                      const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
