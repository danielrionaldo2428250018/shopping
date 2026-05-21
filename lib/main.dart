import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'services/app_notifications.dart';
import 'services/cloud_api_service.dart';
import 'config/google_sign_in_config.dart';
import 'providers/inbox_messages_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/seller_applications_provider.dart';
import 'providers/settings_prefs_provider.dart';
import 'providers/theme_prefs_provider.dart';
import 'providers/user_profile_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/loyalty_points_provider.dart';
import 'providers/rewards_catalog_provider.dart';
import 'providers/catalog_provider.dart';

import 'bootstrap/startup_permissions.dart';
import 'constants/app_branding.dart';

/// NAVIGATION
import 'screens/main_navigation_screen.dart';

/// AUTH
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

/// GENERAL
import 'screens/splash_screen.dart';
import 'screens/search_screen.dart';
import 'screens/search_result_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/product_detail_screen.dart';

/// USER
import 'screens/profile_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/map_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/notification_chat_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/settings_screen.dart';

/// SELLER
import 'screens/become_seller_screen.dart';
import 'screens/store_dashboard.dart';
import 'screens/add_product_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/admin_seller_applications_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/buy_product_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/order_invoice_screen.dart';
import 'screens/payment_methods_screen.dart';
import 'screens/payment_success_screen.dart';
import 'screens/loyalty_rewards_screen.dart';
import 'screens/admin_rewards_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/seller_store_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  var firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (e, st) {
    debugPrint('Firebase init gagal: $e\n$st');
  }

  if (firebaseReady) {
    await AuthProvider.migrateClearLocalSellerDataForFirestore(prefs);
  }

  await initializeAppNotifications(firebaseReady: firebaseReady);

  if (kDebugMode) {
    if (!GoogleSignInConfig.isConfigured) {
      debugPrint('Google Sign-In: ${GoogleSignInConfig.setupHint}');
    }
    final cloud = await CloudApiService.checkHealth();
    debugPrint(
      cloud.ok
          ? 'shopping-cloud OK (${cloud.firebaseProject}, topic ${cloud.topic})'
          : 'shopping-cloud gagal: ${cloud.statusCode} ${cloud.message}',
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => SellerApplicationsProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => InboxMessagesProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProfileProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemePrefsProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsPrefsProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => LoyaltyPointsProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => RewardsCatalogProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => CatalogProvider(firebaseReady: firebaseReady),
        ),
      ],
      child: const _FirebaseAuthBinder(
        child: StartupPermissionsWrapper(
          child: MyApp(),
        ),
      ),
    ),
  );
}

/// Menghubungkan [SellerApplicationsProvider] dengan [AuthProvider] untuk sinkron status seller.
class _FirebaseAuthBinder extends StatefulWidget {
  const _FirebaseAuthBinder({required this.child});

  final Widget child;

  @override
  State<_FirebaseAuthBinder> createState() => _FirebaseAuthBinderState();
}

class _FirebaseAuthBinderState extends State<_FirebaseAuthBinder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      try {
        auth.bindFirebase(FirebaseAuth.instance);
      } catch (e) {
        debugPrint('bindFirebase: $e');
      }
      context.read<SellerApplicationsProvider>().bindAuth(auth);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class MyApp extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemePrefsProvider, LocaleProvider>(
      builder: (context, themePrefs, localeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (ctx) =>
              AppLocalizations.of(ctx)?.appBrandName ?? AppBranding.appName,
          locale: localeProvider.locale,
          localeResolutionCallback: (deviceLocale, supported) {
            if (deviceLocale != null) {
              for (final s in supported) {
                if (s.languageCode == deviceLocale.languageCode) {
                  return s;
                }
              }
            }
            return localeProvider.locale;
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: themePrefs.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppBranding.seedColor,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: AppBranding.scaffoldLight,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppBranding.seedColor,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: AppBranding.scaffoldDark,
          ),
          initialRoute: SplashScreen.route,
          routes: {

        SplashScreen.route:
            (context) =>
                const SplashScreen(),

        '/':
            (context) =>
                const MainNavigationScreen(),

        /// AUTH
        '/login': (context) =>
            const LoginScreen(),

        '/register': (context) =>
            const RegisterScreen(),

        /// SEARCH
        '/search': (context) =>
            const SearchScreen(),

        '/categories': (context) =>
            const CategoriesScreen(),

        '/product-detail':
            (context) {

          final raw =
              ModalRoute.of(
                    context,

                  )

                  ?.settings

                  .arguments;

          String? pid;

          if (raw is String) {

            pid = raw;

          }

          if (raw is Map && raw['productId'] is String) {

            pid = raw['productId'] as String;

          }

          return ProductDetailScreen(
            productId: pid,
          );
        },

        '/search-results':
            (context) {

          final raw =
              ModalRoute.of(
                    context,

                  )

                  ?.settings

                  .arguments;

          String query = '';

          String? category;
          List<String>? imageRank;

          if (raw is String) {

            query = raw;

          }

          if (raw is Map) {

            final q = raw['q'];

            if (q is String) {

              query = q;

            }

            final c = raw['category'];

            if (c is String) {

              category = c;

            }

            final ir = raw['imageRank'];

            if (ir is List) {

              imageRank = ir.map((e) => e.toString()).toList();

            }

          }

          return SearchResultScreen(
            initialQuery: query,
            categoryFilter: category,
            imageRankedProductIds: imageRank,
          );
        },

        '/cart':
            (context) =>
                const CartScreen(),

        '/checkout':
            (context) =>
                const CheckoutScreen(),

        '/payment-success':
            (context) {
          final raw =
              ModalRoute.of(context)?.settings.arguments;
          var points = 0;
          var total = 0;
          if (raw is Map) {
            final p = raw['points'];
            final t = raw['total'];
            if (p is int) points = p;
            if (p is num) points = p.toInt();
            if (t is int) total = t;
            if (t is num) total = t.toInt();
          }
          return PaymentSuccessScreen(
            pointsEarned: points,
            orderTotal: total,
          );
        },

        LoyaltyRewardsScreen.route:
            (context) => const LoyaltyRewardsScreen(),

        AdminRewardsScreen.route:
            (context) => const AdminRewardsScreen(),

        '/chat':
            (context) {

          final raw =
              ModalRoute.of(
                    context,

                  )

                  ?.settings

                  .arguments;

          return ChatScreen(
            args: ChatRouteArgs.resolve(raw),
          );
        },

        '/buy-product':
            (context) {

          final raw =
              ModalRoute.of(
                    context,

                  )

                  ?.settings

                  .arguments;

          final args = BuyProductRouteArgs.from(raw);
          if (args == null) {
            return Scaffold(
              body: Center(
                child: Text(AppLocalizations.of(context).productNotFound),
              ),
            );
          }
          return BuyProductScreen(args: args);
        },

        '/chats':
            (context) =>
                const ChatListScreen(),

        /// USER
        '/profile': (context) =>
            const ProfileScreen(),

        '/edit-profile':
            (context) =>
                const EditProfileScreen(),

        '/settings':
            (context) =>
                const SettingsScreen(),

        '/favorites': (context) =>
            const FavoritesScreen(),

        '/map': (context) =>
            const MapScreen(),

        '/orders': (context) =>
            const OrdersScreen(),

        '/reviews':
            (context) {
          final raw =
              ModalRoute.of(context)?.settings.arguments;
          String? oid;
          if (raw is Map && raw['orderId'] is String) {
            oid = raw['orderId'] as String;
          } else if (raw is String) {
            oid = raw;
          }
          return ReviewsScreen(orderId: oid);
        },

        '/notifications':
            (context) =>
                const NotificationsScreen(),

        NotificationChatScreen.route:
            (context) {
          final id =
              ModalRoute.of(context)?.settings.arguments as String? ?? '';
          return NotificationChatScreen(threadId: id);
        },

        '/help-support':
            (context) =>
                const HelpSupportScreen(),

        /// SELLER
        '/become-seller':
            (context) =>
                const BecomeSellerScreen(),

        '/store-dashboard':
            (context) =>
                const StoreDashboardScreen(),

        '/add-product':
            (context) =>
                const AddProductScreen(),

        '/edit-product':
            (context) =>
                const EditProductScreen(),

        /// ADMIN
        '/admin-seller-applications':
            (context) =>
                const AdminSellerApplicationsScreen(),

        AdminSellerDetailScreen.route:
            (context) {

          final raw =
              ModalRoute.of(
                    context,

                  )

                  ?.settings

                  .arguments;

          final id =
              raw is String
                  ? raw
                  : '';

          return AdminSellerDetailScreen(
            applicationId: id,
          );
        },

        OrderInvoiceScreen.route:
            (context) {
          final raw =
              ModalRoute.of(context)?.settings.arguments;
          final id = raw is String ? raw : '';
          return OrderInvoiceScreen(orderId: id);
        },

        SellerStoreScreen.route:
            (context) {
          final raw =
              ModalRoute.of(context)?.settings.arguments;
          final name = raw is String
              ? raw
              : (raw is Map && raw['sellerName'] is String)
                  ? raw['sellerName'] as String
                  : '';
          return SellerStoreScreen(sellerName: name);
        },

        PaymentMethodsScreen.route:
            (context) =>
                const PaymentMethodsScreen(),

      },

        );
      },
    );
  }
}