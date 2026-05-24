import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../providers/auth_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import 'forgot_password_screen.dart';

/// Ubah kata sandi akun email/password (Firebase reauthenticate + update).
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static const route = '/change-password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final loc = context.l10n;
    final auth = context.read<AuthProvider>();

    if (!auth.canChangePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.changePasswordGoogleOnly)),
      );
      return;
    }

    final current = _currentCtrl.text;
    final newer = _newCtrl.text;
    final confirm = _confirmCtrl.text;

    if (current.isEmpty || newer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.fillEmailPassword)),
      );
      return;
    }
    if (newer.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.authWeakPassword)),
      );
      return;
    }
    if (newer != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.newPasswordMismatch)),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await auth.changePassword(
        currentPassword: current,
        newPassword: newer,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.changePasswordSuccess)),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AuthProvider.messageFor(e, loc))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.changePasswordTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(loc.signInToChangePassword),
          ),
        ),
      );
    }

    if (!auth.canChangePassword) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.changePasswordTitle)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: AppBranding.seedColor,
              ),
              const SizedBox(height: 16),
              Text(
                loc.changePasswordGoogleOnly,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, height: 1.4),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, ForgotPasswordScreen.route);
                },
                child: Text(loc.forgotPassword),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      appBar: AppBar(title: Text(loc.changePasswordTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              loc.changePasswordFormHint,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 20),
            _pwdField(
              controller: _currentCtrl,
              label: loc.currentPassword,
              obscure: _obscureCurrent,
              onToggle: () =>
                  setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            const SizedBox(height: 12),
            _pwdField(
              controller: _newCtrl,
              label: loc.newPassword,
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 12),
            _pwdField(
              controller: _confirmCtrl,
              label: loc.confirmNewPassword,
              obscure: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.save),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ForgotPasswordScreen.route);
              },
              child: Text(loc.forgotPassword),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pwdField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: appCardColor(context),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }
}
