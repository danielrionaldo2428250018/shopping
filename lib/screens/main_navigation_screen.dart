import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../utils/app_screen_style.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

import 'auth_required_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'seller_profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
  });

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  /// Tab selain beranda baru dibangun setelah pengguna membukannya.
  final Set<int> _builtTabs = {0};

  void _selectTab(int index) {
    setState(() {
      _builtTabs.add(index);
      currentIndex = index;
    });
  }

  Widget _lazyTab(int index, Widget child) {
    if (!_builtTabs.contains(index)) {
      return const SizedBox.shrink();
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      body: IndexedStack(
        index: currentIndex,
        children: [
          _lazyTab(0, const HomeScreen()),
          _lazyTab(
            1,
            auth.isLoggedIn
                ? const FavoritesScreen()
                : const AuthRequiredScreen(),
          ),
          _lazyTab(
            2,
            auth.isLoggedIn
                ? (auth.isSeller
                    ? const SellerProfileScreen()
                    : const ProfileScreen())
                : const AuthRequiredScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: appCardElevated(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: loc.home,
                  selected: currentIndex == 0,
                  onTap: () => _selectTab(0),
                ),
                _NavItem(
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: loc.saved,
                  selected: currentIndex == 1,
                  onTap: () => _selectTab(1),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: loc.profile,
                  selected: currentIndex == 2,
                  onTap: () => _selectTab(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected
                    ? AppBranding.seedColor.withValues(alpha: 0.14)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                selected ? activeIcon : icon,
                size: 24,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : appMutedTextColor(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : appMutedTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
