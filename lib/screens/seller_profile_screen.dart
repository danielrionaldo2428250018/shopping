import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/inbox_messages_provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/l10n_helpers.dart';
import 'admin_rewards_screen.dart';
import 'settings_screen.dart';

/// Profil pemilik toko (penjual) — menu ke My Store, Orders, Settings.
class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  static const Color _purple = Color(0xFF8E44AD);

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 52, 20, 100),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF8E44AD),
                        Color(0xFFC9A3E8),
                        Colors.white,
                      ],
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
                            backgroundColor: Colors.white,
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
                            style: const TextStyle(
                              color: Colors.white,
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
                              color:
                                  Colors.white.withValues(alpha: 0.92),
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
                          Chip(
                            avatar: Icon(
                              Icons.workspace_premium_rounded,
                              size: 18,
                              color: Colors.amber.shade700,
                            ),
                            label: Text(
                              loc.proSellerBadge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.2),
                            side: BorderSide.none,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/edit-profile',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.65),
                              ),
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
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: -56,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(18),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          _stat(
                            Icons.shopping_bag_outlined,
                            '12',
                            loc.orders,
                          ),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                          _stat(
                            Icons.military_tech_outlined,
                            '8',
                            loc.reviews,
                          ),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                          _stat(
                            Icons.inventory_2_outlined,
                            '24',
                            loc.wishlist,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 76),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Consumer<InboxMessagesProvider>(
                      builder: (context, inbox, _) {
                        final unread = inbox.unreadCount;
                        return _row(
                          context,
                          icon: Icons.notifications_none_rounded,
                          iconBg: Colors.blue.shade50,
                          iconColor: Colors.blue.shade700,
                          title: loc.sellerNotifications,
                          badge: unread > 0 ? '$unread' : null,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/notifications',
                          ),
                        );
                      },
                    ),
                    Divider(height: 1, color: Colors.grey.shade200),
                    _row(
                      context,
                      icon: Icons.storefront_rounded,
                      iconBg: Colors.green.shade50,
                      iconColor: Colors.green.shade700,
                      title: loc.myStore,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/store-dashboard',
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey.shade200),
                    _row(
                      context,
                      icon: Icons.inventory_2_outlined,
                      iconBg: Colors.purple.shade50,
                      iconColor: _purple,
                      title: loc.myOrders,
                      onTap: () =>
                          Navigator.pushNamed(context, '/orders'),
                    ),
                    if (context.watch<AuthProvider>().isAdmin) ...[
                      Divider(height: 1, color: Colors.grey.shade200),
                      Container(
                        color: Colors.orange.shade50,
                        child: _row(
                          context,
                          icon: Icons.admin_panel_settings_outlined,
                          iconBg: Colors.orange.shade100,
                          iconColor: Colors.orange.shade800,
                          title: loc.adminSellerApps,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/admin-seller-applications',
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _row(
                        context,
                        icon: Icons.card_membership_outlined,
                        iconBg: Colors.orange.shade50,
                        iconColor: Colors.orange.shade800,
                        title: loc.adminRewards,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AdminRewardsScreen.route,
                        ),
                      ),
                    ],
                    Divider(height: 1, color: Colors.grey.shade200),
                    _row(
                      context,
                      icon: Icons.settings_outlined,
                      iconBg: Colors.grey.shade100,
                      iconColor: Colors.grey.shade700,
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
                    Divider(height: 1, color: Colors.grey.shade200),
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
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red.shade50,
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

  Widget _stat(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: _purple),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
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
              child: Icon(icon, color: iconColor),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
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
