import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../constants/app_admin_config.dart';
import '../providers/auth_provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/settings_prefs_provider.dart';
import '../providers/theme_prefs_provider.dart';
import '../services/app_notifications.dart';
import '../services/biometric_auth_service.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final localeProvider = context.watch<LocaleProvider>();
    final themePrefs = context.watch<ThemePrefsProvider>();
    final setPrefs = context.watch<SettingsPrefsProvider>();
    final selectedLang = localeProvider.locale.languageCode;

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),

      body: SafeArea(
        child: Column(
          children: [

            /// ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                26,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF7F3DFF),
                    Color(0xFFEDE7FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      /// BACK BUTTON
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder:
                              const CircleBorder(),
                          onTap: () {
                            Navigator.maybePop(context);
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.all(
                              10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withOpacity(
                                0.2,
                              ),
                              shape:
                                  BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Text(
                        loc.settings,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    loc.settingsSubtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            /// ================= BODY =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    _sectionTitle(loc.language),
                    const SizedBox(height: 10),
                    _settingCard(
                      children: [
                        for (final locale in kAppLanguageLocales) ...[
                          if (locale != kAppLanguageLocales.first)
                            Divider(
                              color: Colors.grey.shade200,
                              height: 1,
                            ),
                          RadioListTile<String>(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            title: Text(
                              languageLabel(loc, locale.languageCode),
                            ),
                            subtitle: Text(
                              nativeLanguageName(loc, locale.languageCode),
                            ),
                            value: locale.languageCode,
                            groupValue: selectedLang,
                            onChanged: (_) =>
                                localeProvider.setLocale(locale),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// ACCOUNT
                    _sectionTitle(loc.accountSection),

                    const SizedBox(height: 14),

                    _settingCard(
                      children: [
                        Consumer2<AuthProvider, UserProfileProvider>(
                          builder: (context, auth, profile, _) {
                            if (!auth.isLoggedIn) {
                              return const SizedBox.shrink();
                            }
                            final isAdmin = auth.isAdminWithProfileEmail(
                              profile.email,
                            );
                            final email = auth.resolvedAccountEmail ??
                                profile.email ??
                                '-';
                            final role =
                                isAdmin ? loc.roleAdmin : loc.roleUser;
                            return Column(
                              children: [
                                _settingTile(
                                  icon: Icons.badge_outlined,
                                  iconColor: Colors.indigo,
                                  title: loc.accountLoginLabel,
                                  subtitle: '$email · $role',
                                  onTap: null,
                                ),
                                if (!isAdmin) ...[
                                  Divider(
                                    color: Colors.grey.shade200,
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      8,
                                      16,
                                      12,
                                    ),
                                    child: Text(
                                      loc.adminLoginHint(kAppAdminEmail),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                                Divider(
                                  color: Colors.grey.shade200,
                                  height: 1,
                                ),
                              ],
                            );
                          },
                        ),

                        _settingTile(
                          icon: Icons.person_outline,
                          iconColor: Colors.blue,
                          title: loc.editProfile,
                          subtitle: loc.changeProfileInfo,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/edit-profile',
                          ),
                        ),

                        Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                        ),

                        _settingTile(
                          icon: Icons.lock_outline,
                          iconColor: const Color(0xFF7B42F6),
                          title: loc.changePassword,
                          subtitle: loc.changePasswordHint,
                          onTap: () => showDialog<void>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(loc.changePasswordTitle),
                              content: Text(loc.changePasswordHint),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Text(loc.understand),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                        ),

                        _settingTile(
                          icon: Icons.security_rounded,
                          iconColor: Colors.green,
                          title: loc.privacySecurity,
                          subtitle: loc.privacySecurityDesc,
                          onTap: () => showModalBottomSheet<void>(
                            context: context,
                            builder: (ctx) => Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.privacySecurity,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    loc.privacySecurityDesc,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      height: 1.45,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text(loc.close),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                        ),

                        _settingTile(
                          icon: Icons.credit_card_outlined,
                          iconColor: Colors.pink,
                          title: loc.paymentMethods,
                          subtitle: loc.paymentMethodsDesc,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/payment-methods',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// PREFERENCES
                    _sectionTitle(loc.notificationsSection),

                    const SizedBox(height: 14),

                    _settingCard(
                      children: [
                        _switchTile(
                          icon: Icons.notifications_active_outlined,
                          iconColor: const Color(0xFF7B42F6),
                          title: loc.pushNotifications,
                          subtitle: loc.pushNotificationsSubtitle,
                          value: setPrefs.pushNotifications,
                          onChanged: (value) async {
                            if (value) {
                              await Permission.notification.request();
                              await requestFcmNotificationPermission();
                            }
                            setPrefs.setPush(value);
                          },
                        ),
                        Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                        ),
                        _switchTile(
                          icon: Icons.email_outlined,
                          iconColor: Colors.blue,
                          title: loc.emailNotifications,
                          value: setPrefs.emailNotifications,
                          onChanged: setPrefs.setEmail,
                        ),
                        Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                        ),
                        _switchTile(
                          icon: Icons.phone_android_rounded,
                          iconColor: Colors.green,
                          title: loc.smsNotifications,
                          value: setPrefs.smsNotifications,
                          onChanged: setPrefs.setSms,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle(loc.appPreferences),

                    const SizedBox(height: 14),

                    _settingCard(
                      children: [
                        _switchTile(
                          icon: Icons.dark_mode_outlined,
                          iconColor: const Color(0xFF7B42F6),
                          title: loc.darkMode,
                          value: themePrefs.isDark,
                          onChanged: themePrefs.setDark,
                        ),

                        Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                        ),

                        _switchTile(
                          icon:
                              Icons.location_on_outlined,
                          iconColor: Colors.teal,
                          title: loc.locationAccess,
                          value: setPrefs.locationFeatureEnabled,
                          onChanged: (value) {
                            () async {
                              if (value) {
                                final st = await Permission.locationWhenInUse
                                    .request();
                                if (!context.mounted) return;
                                if (!st.isGranted && !st.isLimited) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(loc.locationDeniedSystem),
                                    ),
                                  );
                                  return;
                                }
                              }
                              setPrefs.setLocationFeature(value);
                            }();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// SECURITY
                    _sectionTitle(loc.privacySecurity),

                    const SizedBox(height: 14),

                    _settingCard(
                      children: [

                        _switchTile(
                          icon: Icons.fingerprint_outlined,
                          iconColor: Colors.indigo,
                          title: loc.fingerprintAuth,
                          subtitle: loc.fingerprintAuthSubtitle,
                          value: setPrefs.fingerprintAuth,
                          onChanged: (value) async {
                            if (value) {
                              if (!await BiometricAuthService.instance
                                  .isDeviceReady()) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(loc.biometricNotAvailable),
                                  ),
                                );
                                return;
                              }
                              final ok = await BiometricAuthService.instance
                                  .authenticateForPayment(context);
                              if (!context.mounted) return;
                              if (!ok) return;
                            }
                            setPrefs.setFingerprint(value);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value
                                      ? loc.fingerprintAuthSubtitle
                                      : loc.biometricDisabledDemo,
                                ),
                              ),
                            );
                          },
                        ),

                        Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                        ),

                        _settingTile(
                          icon:
                              Icons.security_outlined,
                          iconColor: Colors.pink,
                          title: loc.privacyPolicy,
                          subtitle: loc.privacyPolicyDesc,
                          onTap: () => showDialog<void>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(loc.privacyPolicy),
                              content: SingleChildScrollView(
                                child: Text(
                                  loc.privacyPolicyDesc,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Text(loc.close),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                        ),

                        _settingTile(
                          icon: Icons.help_outline,
                          iconColor: Colors.amber,
                          title: loc.helpSupport,
                          subtitle: loc.helpSupportDesc,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/help-support',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// LOGOUT
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(loc.signOutQ),
                              content: Text(loc.signOutDesc),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, false),
                                  child: Text(loc.cancel),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, true),
                                  child: Text(loc.logout),
                                ),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) {
                            context.read<AuthProvider>().logout();
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                              '/',
                              (r) => r.isFirst,
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.red.shade100,
                            ),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding:
                                  const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                            ),
                            title: Text(
                              loc.logout,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(loc.signOutDesc),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// VERSION
                    Text(
                      loc.appVersion,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 4),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  /// ================= CARD =================
  Widget _settingCard({
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: appCardColor(context),
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: appBorderColor(context),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  /// ================= NORMAL TILE =================
  Widget _settingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// ================= SWITCH TILE =================
  Widget _switchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 6,
      ),
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            )
          : null,
      activeTrackColor: const Color(0xFF7B42F6),
      activeThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey.shade300,
      inactiveThumbColor: Colors.grey.shade500,
    );
  }
}