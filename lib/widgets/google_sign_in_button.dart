import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/l10n_helpers.dart';

/// Tombol Google — Firebase Authentication.
class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({
    super.key,
    this.label,
  });

  final String? label;

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _loading = false;

  Future<void> _handlePress() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final result =
          await context.read<AuthProvider>().signInWithGoogle();
      if (!mounted) return;

      context.read<UserProfileProvider>().saveProfile(
            displayName: result.displayName,
            email: result.email,
            phone: context.read<UserProfileProvider>().phone ?? '',
          );

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.googleSignInSuccess),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthProvider.messageFor(e, context.l10n)),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label ?? context.l10n.continueWithGoogle;
    return OutlinedButton(
      onPressed: _loading ? null : _handlePress,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: _loading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    'G',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4285F4),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
    );
  }
}
