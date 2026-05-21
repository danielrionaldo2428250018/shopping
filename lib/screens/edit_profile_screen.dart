import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/user_profile_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';

/// Edit profil lengkap: foto (izin galeri/kamera), nama, email, nomor HP (tersimpan lokal).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final p = context.read<UserProfileProvider>();
    _nameCtrl.text = p.displayName ?? '';
    _emailCtrl.text = p.email ?? '';
    _phoneCtrl.text = p.phone ?? '';
    if (_nameCtrl.text.isEmpty) {
      _nameCtrl.text = context.l10n.defaultDisplayName;
    }
    if (_emailCtrl.text.isEmpty) _emailCtrl.text = 'user@email.com';
    if (_phoneCtrl.text.isEmpty) _phoneCtrl.text = '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _ensurePhotoPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      await Permission.camera.request();
    } else {
      await Permission.photos.request();
    }
  }

  Future<void> _pickAvatar(ImageSource source) async {
    await _ensurePhotoPermissions(source);
    if (!mounted) return;

    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (file == null || !mounted) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final dest = File('${dir.path}/profile_avatar.jpg');
      await File(file.path).copy(dest.path);
      if (!mounted) return;
      context.read<UserProfileProvider>().setAvatarLocalPath(dest.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.profilePhotoUpdated)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.profilePhotoFailed)),
        );
      }
    }
  }

  void _showPhotoSourceSheet() {
    final loc = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(loc.chooseFromGallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickAvatar(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(loc.takePhotoNow),
              onTap: () {
                Navigator.pop(ctx);
                _pickAvatar(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final profile = context.read<UserProfileProvider>();
    profile.saveProfile(
      displayName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );

    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(content: Text(context.l10n.profileSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    const purple = Color(0xFF7F3DFF);

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      appBar: AppBar(
        backgroundColor: appCardColor(context),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          loc.editProfile,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: purple,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              loc.saveChanges,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Consumer<UserProfileProvider>(
                builder: (context, profile, _) {
                  final path = profile.avatarLocalPath;
                  final hasFile = path != null &&
                      path.isNotEmpty &&
                      File(path).existsSync();
                  final avatarPath = path;
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: hasFile && avatarPath != null
                            ? FileImage(File(avatarPath))
                            : null,
                        child: !hasFile
                            ? const Icon(
                                Icons.person_rounded,
                                size: 64,
                                color: purple,
                              )
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextButton.icon(
                        onPressed: _showPhotoSourceSheet,
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: Text(loc.changeProfilePhoto),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              _field(
                label: loc.fullName,
                controller: _nameCtrl,
                icon: Icons.person_outline,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return loc.nameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _field(
                label: loc.email,
                controller: _emailCtrl,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return loc.emailRequired;
                  }
                  if (!v.contains('@')) {
                    return loc.emailInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _field(
                label: loc.phoneNumber,
                controller: _phoneCtrl,
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  final digits = v?.replaceAll(RegExp(r'\D'), '') ?? '';
                  if (digits.length < 10) {
                    return loc.phoneMinDigits;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                loc.phoneOrderHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF7F3DFF)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
