import 'package:flutter/material.dart';

/// SCREENS
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/become_seller_screen.dart';

class AppRouter {

  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {

    switch (settings.name) {

      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case '/map':
        return MaterialPageRoute(
          builder: (_) => const MapScreen(),
        );

      case '/favorites':
        return MaterialPageRoute(
          builder: (_) =>
              const FavoritesScreen(),
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );

      case '/orders':
        return MaterialPageRoute(
          builder: (_) => const OrdersScreen(),
        );

      case '/notifications':
        return MaterialPageRoute(
          builder: (_) =>
              const NotificationsScreen(),
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) =>
              const SettingsScreen(),
        );

      case '/become-seller':
        return MaterialPageRoute(
          builder: (_) =>
              const BecomeSellerScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
    }
  }
}