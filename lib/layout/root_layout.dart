import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

import '../screens/home_screen.dart';
import '../screens/map_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart';

import '../screens/auth_required_screen.dart';
import '../utils/l10n_helpers.dart';

class RootLayout extends StatefulWidget {

  const RootLayout({
    super.key,
  });

  @override
  State<RootLayout> createState() =>
      _RootLayoutState();
}

class _RootLayoutState
    extends State<RootLayout> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    final loc = context.l10n;

    final screens = [

      /// HOME
      const HomeScreen(),

      /// MAP
      auth.isLoggedIn
          ? const MapScreen()
          : const AuthRequiredScreen(),

      /// FAVORITE
      auth.isLoggedIn
          ? const FavoritesScreen()
          : const AuthRequiredScreen(),

      /// PROFILE
      auth.isLoggedIn
          ? const ProfileScreen()
          : const AuthRequiredScreen(),
    ];

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {
            currentIndex = index;
          });
        },

        type:
            BottomNavigationBarType.fixed,

        selectedItemColor:
            const Color(0xFF7F3DFF),

        unselectedItemColor:
            Colors.grey,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: loc.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            activeIcon: Icon(Icons.location_on),
            label: loc.map,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: loc.saved,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: loc.profile,
          ),
        ],
      ),
    );
  }
}