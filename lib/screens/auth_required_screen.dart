import 'package:flutter/material.dart';

import '../constants/app_branding.dart';
import '../utils/l10n_helpers.dart';

/// Shown inside main tabs when the user is not signed in (Map, Saved, Profile).
class AuthRequiredScreen extends StatelessWidget {
  const AuthRequiredScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Scaffold(
            body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppBranding.seedColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 56,
                    color: AppBranding.seedColor,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  loc.authRequiredTitle,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Text(
                  loc.authRequiredBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    icon: const Icon(Icons.login_rounded, color: Colors.white),
                    label: Text(
                      loc.signIn,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppBranding.seedColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    icon: const Icon(
                      Icons.person_add_outlined,
                      color: AppBranding.seedColor,
                    ),
                    label: Text(
                      loc.createAccount,
                      style: const TextStyle(
                        color: AppBranding.seedColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(
                        color: AppBranding.seedColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
