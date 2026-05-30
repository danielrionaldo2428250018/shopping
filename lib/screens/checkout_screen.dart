import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart' show catalogProductById, formatIdr;
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/loyalty_points_provider.dart';
import '../providers/location_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../providers/settings_prefs_provider.dart';
import '../services/biometric_auth_service.dart';
import '../utils/app_screen_style.dart';
import '../utils/responsive_layout.dart';
import '../utils/l10n_helpers.dart';
import '../utils/phone_order_gate.dart';
import '../widgets/app_network_image.dart';
import '../utils/checkout_voucher.dart';
import '../utils/quick_payment.dart';

/// Checkout alur keranjang: ongkir, voucher, ringkasan, bayar.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const Color _purple = Color(0xFF7B42F6);

  final _voucherCtrl = TextEditingController();
  int _shippingIndex = 0;
  String _appliedVoucher = '';

  String _addressSummary = '';

  String _paymentLabel = '';
  bool _locTried = false;
  bool _isPlacing = false;

  ({String key, String label, String eta, int fee, bool enabled})
      _shippingOptionForKey(
    String key,
    AppLocalizations loc, {
    required bool enabled,
  }) {
    switch (key) {
      case 'cargo':
        return (
          key: key,
          label: loc.shippingCargo,
          eta: loc.shippingEtaCargo,
          fee: 60000,
          enabled: enabled,
        );
      case 'express':
        return (
          key: key,
          label: loc.shippingExpress,
          eta: loc.shippingEtaExpress,
          fee: 35000,
          enabled: enabled,
        );
      case 'pickup':
        return (
          key: key,
          label: loc.shippingPickup,
          eta: loc.shippingEtaPickup,
          fee: 0,
          enabled: enabled,
        );
      default:
        return (
          key: 'reguler',
          label: loc.shippingReguler,
          eta: loc.shippingEtaReguler,
          fee: 15000,
          enabled: enabled,
        );
    }
  }

  List<({String key, String label, String eta, int fee, bool enabled})>
      _shippingOptions(AppLocalizations loc) {
    final cart = context.read<CartProvider>();
    final prefs = context.read<SettingsPrefsProvider>();
    final userCity = context.read<LocationProvider>().city;

    final storeNames =
        cart.lines.map((l) => l.product.sellerName.trim()).toSet();
    final singleStore = storeNames.length == 1;

    String sellerCity = '';
    if (singleStore) {
      final storeName = storeNames.first;
      final app = context
          .read<SellerApplicationsProvider>()
          .approvedStoreBySellerName(storeName);
      sellerCity = app?.city.trim() ?? '';
      if (sellerCity.isEmpty && cart.lines.isNotEmpty) {
        sellerCity = cart.lines.first.product.locationLabel.trim();
      }
    }

    final canUseLocation =
        prefs.locationFeatureEnabled && userCity.trim().isNotEmpty;
    final canPickup = canUseLocation &&
        singleStore &&
        sellerCity.isNotEmpty &&
        context.read<LocationProvider>().isSameCity(sellerCity);

    const keys = <String>['cargo', 'express', 'reguler', 'pickup'];
    return keys
        .map(
          (k) => _shippingOptionForKey(
            k,
            loc,
            enabled: k == 'pickup' ? canPickup : true,
          ),
        )
        .toList();
  }

  String _displayPayment(AppLocalizations loc) =>
      _paymentLabel.isEmpty ? loc.payBcaVa : _paymentLabel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_addressSummary.isEmpty) {
      _addressSummary = context.l10n.demoAddrHomeFull;
    }
    final prefs = context.read<SettingsPrefsProvider>();
    if (prefs.locationFeatureEnabled && !_locTried) {
      _locTried = true;
      final locProv = context.read<LocationProvider>();
      Future<void> refreshLoc() async {
        final ok = locProv.city.trim().isEmpty
            ? await locProv.requestAndRefresh()
            : await locProv.refreshIfPermitted();
        if (ok && mounted) {
          context.read<SettingsPrefsProvider>().setLocationFeature(true);
        }
      }
      unawaited(refreshLoc());
    }
  }

  void _ensureShippingIndexEnabled(AppLocalizations loc) {
    final opts = _shippingOptions(loc);
    if (opts.isEmpty) return;
    if (_shippingIndex >= opts.length) _shippingIndex = 0;
    if (opts[_shippingIndex].enabled) return;
    final firstEnabled = opts.indexWhere((o) => o.enabled);
    _shippingIndex = firstEnabled >= 0 ? firstEnabled : 0;
  }

  @override
  void dispose() {
    _voucherCtrl.dispose();
    super.dispose();
  }

  CheckoutVoucher? _resolvedVoucher(LoyaltyPointsProvider loyalty) {
    if (_appliedVoucher.isEmpty) return null;
    return CheckoutVoucherRules.resolve(_appliedVoucher, loyalty);
  }

  int _shippingFee(LoyaltyPointsProvider loyalty) {
    final loc = context.l10n;
    _ensureShippingIndexEnabled(loc);
    final opts = _shippingOptions(loc);
    final base = opts.isEmpty ? 0 : opts[_shippingIndex].fee;
    return CheckoutVoucherRules.shippingAfterDiscount(
      base,
      _resolvedVoucher(loyalty),
    );
  }

  int _discount(int subtotal, LoyaltyPointsProvider loyalty) {
    return CheckoutVoucherRules.orderDiscount(
      subtotal,
      _resolvedVoucher(loyalty),
    );
  }

  Future<void> _pickAddress() async {
    final loc = context.l10n;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text(loc.deliveryAddress)),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: Text(loc.addressHome),
                subtitle: Text(loc.demoAddrHomeShort),
                onTap: () => Navigator.pop(ctx, loc.demoAddrHomeFull),
              ),
              ListTile(
                leading: const Icon(Icons.work_outline_rounded),
                title: Text(loc.addressOffice),
                subtitle: Text(loc.demoAddrOfficeShort),
                onTap: () => Navigator.pop(ctx, loc.demoAddrOfficeFull),
              ),
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(loc.addressApartment),
                subtitle: Text(loc.demoAddrAptShort),
                onTap: () => Navigator.pop(ctx, loc.demoAddrAptFull),
              ),
              ListTile(
                leading: const Icon(Icons.family_restroom_outlined),
                title: Text(loc.addressParents),
                subtitle: Text(loc.demoAddrParentsShort),
                onTap: () => Navigator.pop(ctx, loc.demoAddrParentsFull),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice != null) {
      setState(() => _addressSummary = choice);
    }
  }

  Future<void> _pickPayment() async {
    final loc = context.l10n;
    final choice = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(loc.paymentMethod),
                subtitle: Text(loc.paymentMethodSubtitle),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_rounded),
                title: Text(loc.payBcaVa),
                subtitle: Text(loc.payAutoVerify),
                onTap: () => Navigator.pop(ctx, loc.payBcaVa),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: Text(loc.payMandiriVa),
                onTap: () => Navigator.pop(ctx, loc.payMandiriVa),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_outlined),
                title: Text(loc.payBniVa),
                onTap: () => Navigator.pop(ctx, loc.payBniVa),
              ),
              ListTile(
                leading: const Icon(Icons.phone_android_rounded),
                title: Text(loc.payOvo),
                onTap: () => Navigator.pop(ctx, loc.payOvo),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_rounded),
                title: Text(loc.payGopay),
                onTap: () => Navigator.pop(ctx, loc.payGopay),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: Text(loc.payShopeePay),
                onTap: () => Navigator.pop(ctx, loc.payShopeePay),
              ),
              ListTile(
                leading: const Icon(Icons.payment_rounded),
                title: Text(loc.payDana),
                onTap: () => Navigator.pop(ctx, loc.payDana),
              ),
              ListTile(
                leading: const Icon(Icons.credit_card_rounded),
                title: Text(loc.payCard),
                subtitle: Text(loc.payCardSubtitle),
                onTap: () => Navigator.pop(ctx, loc.payCard),
              ),
              ListTile(
                leading: const Icon(Icons.payments_rounded),
                title: Text(loc.payCod),
                onTap: () => Navigator.pop(ctx, loc.payCod),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice != null) {
      setState(() => _paymentLabel = choice);
    }
  }

  void _applyVoucher() {
    final loc = context.l10n;
    final loyalty = context.read<LoyaltyPointsProvider>();
    final code = _voucherCtrl.text.trim();
    if (code.isEmpty) {
      setState(() => _appliedVoucher = '');
      return;
    }
    final voucher = CheckoutVoucherRules.resolve(code, loyalty);
    if (voucher == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.voucherPointNotOwned)),
      );
      return;
    }
    final sub = context.read<CartProvider>().subtotal;
    if (!CheckoutVoucherRules.meetsMinSubtotal(sub, voucher)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.voucherMinPurchase(formatIdr(voucher.minSubtotal))),
        ),
      );
      return;
    }
    setState(() => _appliedVoucher = voucher.code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.voucherApplied(voucher.code))),
    );
  }

  Future<void> _placeOrder() async {
    if (_isPlacing) return;
    if (!await ensurePhoneForOrder(context)) return;
    if (!context.mounted) return;

    final loc = context.l10n;
    final buyerUid = context.read<AuthProvider>().uid ??
        FirebaseAuth.instance.currentUser?.uid;
    if (buyerUid == null || buyerUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.signInToContinue)),
      );
      return;
    }
    final setPrefs = context.read<SettingsPrefsProvider>();
    final payment = _displayPayment(loc);
    if (setPrefs.fingerprintAuth &&
        QuickPayment.isQuickPayment(payment, loc)) {
      final ok =
          await BiometricAuthService.instance.authenticateForPayment(context);
      if (!context.mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.biometricAuthFailed)),
        );
        return;
      }
    }

    final cart = context.read<CartProvider>();
    final orders = context.read<OrdersProvider>();
    final catalog = context.read<CatalogProvider>();
    final loyalty = context.read<LoyaltyPointsProvider>();
    final sub = cart.subtotal;
    final voucher = _resolvedVoucher(loyalty);
    if (voucher != null &&
        !CheckoutVoucherRules.meetsMinSubtotal(sub, voucher)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.voucherMinPurchase(formatIdr(voucher.minSubtotal))),
        ),
      );
      return;
    }
    final ship = _shippingFee(loyalty);
    final disc = _discount(sub, loyalty);
    final total = sub + ship - disc;

    if (cart.lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.cartEmptyCheckout)),
      );
      return;
    }
    if (total < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.checkoutOrderFailed)),
      );
      return;
    }

    final stockLines = cart.lines
        .map((l) => (productId: l.product.id, quantity: l.quantity))
        .toList();

    setState(() => _isPlacing = true);
    try {
      for (final line in cart.lines) {
        final fresh =
            catalogProductById(line.product.id) ?? line.product;
        if (line.quantity > fresh.stock) {
          cart.setQuantity(line.product.id, fresh.stock);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.checkoutStockFailed)),
          );
          return;
        }
      }

      final stockOk = await catalog.fulfillPurchaseStock(stockLines);
      if (!mounted) return;
      if (!stockOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.checkoutStockFailed)),
        );
        return;
      }

      final result = await orders.addFromCheckout(
        cart: cart,
        shippingFee: ship,
        discount: disc,
        buyerUid: buyerUid,
        buyerName: context.read<AuthProvider>().displayName ??
            FirebaseAuth.instance.currentUser?.displayName,
      );
      if (!mounted) return;
      if (result.orderId.isEmpty) {
        catalog.restorePurchaseStock(stockLines);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.checkoutOrderFailed)),
        );
        return;
      }
      if (voucher != null &&
          voucher.fromPoints &&
          result.orderId.isNotEmpty) {
        loyalty.markVoucherUsed(voucher.code, result.orderId);
      }
      final earned = loyalty.earnFromPurchase(
        result.total,
        orderId: result.orderId,
      );

      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed(
        '/payment-success',
        arguments: {
          'points': earned,
          'total': result.total,
        },
      );
    } catch (e) {
      if (!mounted) return;
      catalog.restorePurchaseStock(stockLines);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.checkoutOrderFailed)),
      );
    } finally {
      if (mounted) setState(() => _isPlacing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final loyalty = context.watch<LoyaltyPointsProvider>();
    final sub = cart.subtotal;
    final ship = _shippingFee(loyalty);
    final disc = _discount(sub, loyalty);
    final total = sub + ship - disc;

    if (cart.lines.isEmpty) {
      final loc = context.l10n;
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.checkout),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loc.emptyCart),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.cancel),
              ),
            ],
          ),
        ),
      );
    }

    final loc = context.l10n;
    context.watch<LocationProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.checkout,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Material(
        elevation: 16,
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.totalPayment,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formatIdr(total),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _placeOrder,
                    icon: _isPlacing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.lock_outline_rounded),
                    label: Text(
                      loc.buyNow,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ResponsivePage(
        child: SingleChildScrollView(
        padding: appPageInsets(context, top: 12, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.orderSummary,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...cart.lines.map((line) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppNetworkImage(
                        url: line.product.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            line.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${line.quantity} × ${formatIdr(line.product.unitPrice)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatIdr(line.lineTotal),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.shippingSection,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(_shippingOptions(loc).length, (i) {
                    final o = _shippingOptions(loc)[i];
                    final sel = _shippingIndex == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: sel
                            ? const Color(0xFFF3EEFF).withValues(alpha: 0.6)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: o.enabled
                              ? () => setState(() => _shippingIndex = i)
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  sel
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: o.enabled
                                      ? (sel ? _purple : Colors.grey)
                                      : Colors.grey.shade400,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        o.label,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        o.enabled
                                            ? '${o.eta} • ${formatIdr(o.fee)}'
                                            : '${o.eta} • ${formatIdr(o.fee)} • ${loc.pickupOnlySameCity}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.promoCode,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.voucherPromoHint,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.voucherPointHint,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (loyalty.unusedRedeemedVoucherCodes().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        loc.voucherRedeemedAvailable,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: loyalty.unusedRedeemedVoucherCodes().map((code) {
                        return ActionChip(
                          label: Text(code),
                          onPressed: () {
                            _voucherCtrl.text = code;
                            _applyVoucher();
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _voucherCtrl,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: loc.promoCode,
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: _applyVoucher,
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple,
                        ),
                        child: Text(loc.applyPromo),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _card(
              child: Column(
                children: [
                  _sumRow(loc.subtotalLine(cart.itemCount), formatIdr(sub)),
                  const SizedBox(height: 8),
                  _sumRow(
                    loc.shippingFeeLine(
                      _shippingOptions(loc)[
                        _shippingIndex.clamp(0, _shippingOptions(loc).length - 1)
                      ].label,
                    ),
                    formatIdr(ship),
                  ),
                  if (disc > 0) ...[
                    const SizedBox(height: 8),
                    _sumRow(loc.discountLabel, '- ${formatIdr(disc)}', negative: true),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.totalPayment,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        formatIdr(total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _card(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.home_outlined, color: _purple),
                ),
                title: Text(
                  loc.deliveryAddress,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_addressSummary),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickAddress,
              ),
            ),
            const SizedBox(height: 12),
            _card(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.payments_outlined, color: _purple),
                ),
                title: Text(
                  loc.paymentMethod,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_displayPayment(loc)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickPayment,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appBorderColor(context)),
      ),
      child: child,
    );
  }

  Widget _sumRow(String label, String value, {bool negative = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: negative ? Colors.green.shade700 : null,
          ),
        ),
      ],
    );
  }
}
