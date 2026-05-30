import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/catalog_product.dart';
import '../data/catalog_data.dart' show catalogProductById, formatIdr;
import '../providers/auth_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/loyalty_points_provider.dart';
import '../providers/location_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../providers/settings_prefs_provider.dart';
import '../utils/checkout_voucher.dart';
import '../utils/phone_order_gate.dart';
import '../widgets/app_network_image.dart';
import '../utils/l10n_helpers.dart';

/// Argument navigasi dari detail produk (atau default demo).
class BuyProductRouteArgs {
  const BuyProductRouteArgs({
    required this.productId,
    required this.title,
    required this.unitPrice,
    required this.imageUrl,
    required this.sellerName,
    this.stock = 25,
  });

  final String productId;
  final String title;
  final int unitPrice;
  final String imageUrl;
  final String sellerName;
  final int stock;

  static BuyProductRouteArgs? from(Object? raw) {
    if (raw is BuyProductRouteArgs) return raw;
    return null;
  }

  factory BuyProductRouteArgs.fromProduct(CatalogProduct p) {
    return BuyProductRouteArgs(
      productId: p.id,
      title: p.title,
      unitPrice: p.unitPrice,
      imageUrl: p.imageUrl,
      sellerName: p.sellerName,
      stock: p.stock,
    );
  }
}

String _formatIdr(int amount) {
  final digits = amount.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buf.write('.');
    }
    buf.write(digits[i]);
  }
  return 'Rp $buf';
}

/// Halaman checkout singkat: jumlah, pengiriman, alamat, ringkasan bayar.
class BuyProductScreen extends StatefulWidget {
  const BuyProductScreen({
    super.key,
    required this.args,
  });

  final BuyProductRouteArgs args;

  @override
  State<BuyProductScreen> createState() => _BuyProductScreenState();
}

class _BuyProductScreenState extends State<BuyProductScreen> {
  static const Color _purple = Color(0xFF7B42F6);

  late int _qty;
  late final TextEditingController _qtyCtrl;
  final _qtyFocus = FocusNode();
  int _shippingIndex = 0;
  final _voucherCtrl = TextEditingController();
  String _appliedVoucher = '';

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
    final prefs = context.read<SettingsPrefsProvider>();
    final userCity = context.read<LocationProvider>().city;

    final app = context
        .read<SellerApplicationsProvider>()
        .approvedStoreBySellerName(widget.args.sellerName);
    var sellerCity = app?.city.trim() ?? '';
    if (sellerCity.isEmpty) {
      final fresh = catalogProductById(widget.args.productId);
      sellerCity = fresh?.locationLabel.trim() ?? '';
    }

    final canUseLocation =
        prefs.locationFeatureEnabled && userCity.trim().isNotEmpty;
    final canPickup = canUseLocation &&
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

  String _addrBuy =
      'Jl. Melati No. 12, RT 03/RW 05\nKebayoran Baru, Jakarta Selatan\n12120';

  @override
  void initState() {
    super.initState();
    _qty = 1;
    _qtyCtrl = TextEditingController(text: '1');
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    });
  }

  @override
  void dispose() {
    _voucherCtrl.dispose();
    _qtyCtrl.dispose();
    _qtyFocus.dispose();
    super.dispose();
  }

  void _applyQtyTyped() {
    final raw = _qtyCtrl.text.trim();
    var n = int.tryParse(raw);
    if (n == null || n < 1) n = 1;
    final fresh = catalogProductById(widget.args.productId);
    final maxStock = fresh?.stock ?? widget.args.stock;
    if (n > maxStock) n = maxStock;
    if (n < 1) n = 1;
    setState(() {
      _qty = n!;
      _qtyCtrl.text = '$_qty';
    });
  }

  void _ensureShippingIndexEnabled(AppLocalizations loc) {
    final opts = _shippingOptions(loc);
    if (opts.isEmpty) return;
    if (_shippingIndex >= opts.length) _shippingIndex = 0;
    if (opts[_shippingIndex].enabled) return;
    final firstEnabled = opts.indexWhere((o) => o.enabled);
    _shippingIndex = firstEnabled >= 0 ? firstEnabled : 0;
  }

  int get _subtotal => widget.args.unitPrice * _qty;

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

  int _discount(LoyaltyPointsProvider loyalty) {
    return CheckoutVoucherRules.orderDiscount(
      _subtotal,
      _resolvedVoucher(loyalty),
    );
  }

  int _total(LoyaltyPointsProvider loyalty) {
    return _subtotal + _shippingFee(loyalty) - _discount(loyalty);
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
    if (!CheckoutVoucherRules.meetsMinSubtotal(_subtotal, voucher)) {
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

  void _incQty() {
    if (_qty >= widget.args.stock) return;
    setState(() {
      _qty++;
      _qtyCtrl.text = '$_qty';
    });
  }

  void _decQty() {
    if (_qty <= 1) return;
    setState(() {
      _qty--;
      _qtyCtrl.text = '$_qty';
    });
  }

  Future<void> _pickAddressBuy() async {
    final loc = context.l10n;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text(loc.selectAddress)),
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
      setState(() => _addrBuy = choice);
    }
  }

  Future<void> _pickPaymentBuy() async {
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
                onTap: () => Navigator.pop(ctx, loc.payBcaVa),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: Text(loc.payMandiriVa),
                onTap: () => Navigator.pop(ctx, loc.payMandiriVa),
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
                leading: const Icon(Icons.payment_rounded),
                title: Text(loc.payDana),
                onTap: () => Navigator.pop(ctx, loc.payDana),
              ),
              ListTile(
                leading: const Icon(Icons.credit_card_rounded),
                title: Text(loc.payCard),
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

  Future<void> _confirmOrder() async {
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

    final loyalty = context.read<LoyaltyPointsProvider>();
    final voucher = _resolvedVoucher(loyalty);
    if (voucher != null &&
        !CheckoutVoucherRules.meetsMinSubtotal(_subtotal, voucher)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.voucherMinPurchase(formatIdr(voucher.minSubtotal))),
        ),
      );
      return;
    }
    final ship = _shippingFee(loyalty);
    final disc = _discount(loyalty);

    final fresh = catalogProductById(widget.args.productId);
    final maxStock = fresh?.stock ?? widget.args.stock;
    if (_qty > maxStock) {
      setState(() => _qty = maxStock.clamp(1, maxStock));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.checkoutStockFailed)),
      );
      return;
    }

    final catalog = context.read<CatalogProvider>();
    final stockLine = (
      productId: widget.args.productId,
      quantity: _qty,
    );

    setState(() => _isPlacing = true);
    try {
      final stockOk = await catalog.fulfillPurchaseStock([stockLine]);
      if (!mounted) return;
      if (!stockOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.checkoutStockFailed)),
        );
        return;
      }

      final result = await context.read<OrdersProvider>().addSingleBuy(
            productId: widget.args.productId,
            quantity: _qty,
            shippingFee: ship,
            discount: disc,
            buyerUid: buyerUid,
            buyerName: context.read<AuthProvider>().displayName ??
                FirebaseAuth.instance.currentUser?.displayName,
          );
      if (!mounted) return;
      if (result.orderId.isEmpty) {
        catalog.restorePurchaseStock([stockLine]);
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
    } catch (_) {
      if (!mounted) return;
      catalog.restorePurchaseStock([stockLine]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.checkoutOrderFailed)),
      );
    } finally {
      if (mounted) setState(() => _isPlacing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LocationProvider>();
    final loc = context.l10n;
    final loyalty = context.watch<LoyaltyPointsProvider>();
    final a = widget.args;
    final total = _total(loyalty);
    final disc = _discount(loyalty);

    return Scaffold(
            body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            backgroundColor: _purple,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 48, bottom: 14),
              title: Text(
                loc.buyNow,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF7F3DFF),
                      Color(0xFFB388FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _productCard(a),
                const SizedBox(height: 14),
                _sectionTitle(loc.stock),
                const SizedBox(height: 8),
                _qtyCard(loc),
                const SizedBox(height: 14),
                _sectionTitle(loc.shippingSection),
                const SizedBox(height: 8),
                _shippingCard(loc),
                const SizedBox(height: 14),
                _sectionTitle(loc.deliveryAddress),
                const SizedBox(height: 8),
                _addressCard(loc),
                const SizedBox(height: 14),
                _sectionTitle(loc.paymentMethod),
                const SizedBox(height: 8),
                _paymentCard(loc),
                const SizedBox(height: 14),
                _sectionTitle(loc.promoCode),
                const SizedBox(height: 8),
                _voucherCard(loc, loyalty),
                const SizedBox(height: 14),
                _sectionTitle(loc.orderSummary),
                const SizedBox(height: 8),
                _summaryCard(loc, loyalty, total, disc),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 16,
        color: Colors.white,
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
                      _formatIdr(total),
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
                    onPressed: _confirmOrder,
                    style: FilledButton.styleFrom(
                      backgroundColor: _purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: _isPlacing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.payment_rounded),
                    label: Text(
                      loc.buyNow,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        t,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _productCard(BuyProductRouteArgs a) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppNetworkImage(
              url: a.imageUrl,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatIdr(a.unitPrice),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: _purple,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: 15,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        a.sellerName,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyCard(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(
            loc.stock,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _decQty,
                  icon: const Icon(Icons.remove_rounded),
                  color: _purple,
                ),
                SizedBox(
                  width: 56,
                  child: TextField(
                    controller: _qtyCtrl,
                    focusNode: _qtyFocus,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    onSubmitted: (_) => _applyQtyTyped(),
                    onEditingComplete: _applyQtyTyped,
                  ),
                ),
                IconButton(
                  onPressed: _qty >= widget.args.stock ? null : _incQty,
                  icon: const Icon(Icons.add_rounded),
                  color: _purple,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            loc.stockLeft(widget.args.stock),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shippingCard(AppLocalizations loc) {
    final opts = _shippingOptions(loc);
    _ensureShippingIndexEnabled(loc);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: List.generate(opts.length, (i) {
          final o = opts[i];
          final sel = _shippingIndex == i;
          final borderRadius = BorderRadius.vertical(
            top: i == 0 ? const Radius.circular(14) : Radius.zero,
            bottom: i == opts.length - 1
                ? const Radius.circular(14)
                : Radius.zero,
          );
          return Material(
            color: sel
                ? const Color(0xFFF3EEFF).withValues(alpha: 0.55)
                : Colors.transparent,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: o.enabled ? () => setState(() => _shippingIndex = i) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            o.enabled
                                ? '${o.eta} • ${_formatIdr(o.fee)}'
                                : '${o.eta} • ${_formatIdr(o.fee)} • ${loc.pickupOnlySameCity}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      sel
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: o.enabled
                          ? (sel ? _purple : Colors.grey.shade400)
                          : Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _addressCard(AppLocalizations loc) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _pickAddressBuy,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: _purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          loc.addressHome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            loc.active,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _addrBuy,
                      style: TextStyle(
                        height: 1.45,
                        color: Colors.grey.shade800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentCard(AppLocalizations loc) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _pickPaymentBuy,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.payments_outlined, color: _purple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.paymentMethod,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _displayPayment(loc),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _voucherCard(AppLocalizations loc, LoyaltyPointsProvider loyalty) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
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
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            loc.voucherPointHint,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          if (loyalty.unusedRedeemedVoucherCodes().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              loc.voucherRedeemedAvailable,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
                style: FilledButton.styleFrom(backgroundColor: _purple),
                child: Text(loc.applyPromo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    AppLocalizations loc,
    LoyaltyPointsProvider loyalty,
    int total,
    int disc,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _sumRow(loc.subtotalLine(_qty), _formatIdr(_subtotal)),
          const SizedBox(height: 10),
          _sumRow(
            loc.shippingFeeLine(
              _shippingOptions(loc)[
                _shippingIndex.clamp(0, _shippingOptions(loc).length - 1)
              ].label,
            ),
            _formatIdr(_shippingFee(loyalty)),
          ),
          if (disc > 0) ...[
            const SizedBox(height: 8),
            _sumRow(loc.discountLabel, '- ${_formatIdr(disc)}'),
          ],
          const SizedBox(height: 8),
          _sumRow(loc.paymentLine, _displayPayment(loc)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.grey.shade200),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.totalPayment,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                _formatIdr(total),
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
    );
  }

  Widget _sumRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
