import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/seller_applications_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/store_logo_avatar.dart';

/// Edit profil toko penjual yang sudah disetujui.
class EditStoreScreen extends StatefulWidget {
  const EditStoreScreen({super.key});

  static const route = '/edit-store';

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  final _storeNameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final store =
        context.read<SellerApplicationsProvider>().myApprovedStore;
    if (store != null) {
      _storeNameCtrl.text = store.storeName;
      _descCtrl.text = store.storeDescription;
      _phoneCtrl.text = store.phone;
      _streetCtrl.text = store.streetAddress;
      _cityCtrl.text = store.city;
    }
  }

  @override
  void dispose() {
    _storeNameCtrl.dispose();
    _descCtrl.dispose();
    _phoneCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final loc = context.l10n;
    final apps = context.read<SellerApplicationsProvider>();
    final current = apps.myApprovedStore;
    if (current == null) return;

    final name = _storeNameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.storeNameHint)),
      );
      return;
    }

    setState(() => _saving = true);

    final updated = current.copyWith(
      storeName: name,
      storeDescription: _descCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      streetAddress: _streetCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      logoPath: null,
      logoUrl: null,
    );

    final ok = await apps.updateMyStore(updated);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.storeUpdated)),
      );
      Navigator.pop(context);
    } else {
      final detail = apps.loadError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            detail != null && detail.isNotEmpty
                ? loc.storeSaveFailedDetail(detail)
                : loc.storeSaveFailed,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final store =
        context.watch<SellerApplicationsProvider>().myApprovedStore;

    if (store == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.editStore)),
        body: Center(child: Text(loc.noSellerApplicationYet)),
      );
    }

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      appBar: AppBar(
        title: Text(loc.editStore),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ListenableBuilder(
                listenable: _storeNameCtrl,
                builder: (_, __) => StoreLogoAvatar(
                  storeName: _storeNameCtrl.text.isNotEmpty
                      ? _storeNameCtrl.text
                      : store.storeName,
                  radius: 48,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              loc.storeLogoInitialsHint,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _storeNameCtrl,
              decoration: InputDecoration(labelText: loc.storeName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: InputDecoration(labelText: loc.storeDescription),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: loc.phoneNumber),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _streetCtrl,
              decoration: InputDecoration(labelText: loc.streetAddress),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityCtrl,
              decoration: InputDecoration(labelText: loc.cityLabel),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.save),
            ),
          ],
        ),
      ),
    );
  }
}
