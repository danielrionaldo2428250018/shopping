import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../models/seller_application.dart';
import '../providers/auth_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/store_logo_avatar.dart';
import 'seller_application_status_screen.dart';

/// Form pengajuan menjadi penjual barang bekas — data ke antrian admin.
class BecomeSellerScreen extends StatefulWidget {
  const BecomeSellerScreen({
    super.key,
  });

  @override
  State<BecomeSellerScreen> createState() =>
      _BecomeSellerScreenState();
}

class _BecomeSellerScreenState extends State<BecomeSellerScreen> {
  final storeNameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();

  bool agreedTerms = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final email = auth.accountEmail;
      if (email != null && email.isNotEmpty) {
        emailCtrl.text = email;
      }
      if (!mounted || auth.isAdmin) return;
      final apps =
          Provider.of<SellerApplicationsProvider>(context, listen: false);
      final mine = apps.myLatestApplication;
      if (mine != null &&
          mine.status != SellerApplicationStatus.rejected) {
        Navigator.pushReplacementNamed(
          context,
          SellerApplicationStatusScreen.route,
        );
      }
    });
  }

  @override
  void dispose() {
    storeNameCtrl.dispose();
    descCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  InputDecoration _outline(String hint) {

    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppBranding.seedColor, width: 1.35),
      ),
    );
  }

  Widget _label(String text) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required List<Widget> children,
  }) {

    return Container(
      width: double.infinity,
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
            title,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  bool _validate() {

    bool ok =
        storeNameCtrl.text.trim().isNotEmpty &&
            descCtrl.text.trim().isNotEmpty &&
            emailCtrl.text.trim().isNotEmpty &&
            phoneCtrl.text.trim().isNotEmpty &&
            streetCtrl.text.trim().isNotEmpty &&
            cityCtrl.text.trim().isNotEmpty &&
            agreedTerms;

    if (!ok) {
      final loc = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.fillAllFields),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return ok;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    final loc = context.l10n;

    final appId = 'SELL-${DateTime.now().millisecondsSinceEpoch}';

    final app = SellerApplication(
      id: appId,
      submittedAt: DateTime.now(),
      storeName:
          storeNameCtrl.text.trim(),
      storeDescription:
          descCtrl.text.trim(),
      email:
          emailCtrl.text.trim().toLowerCase(),
      phone:
          phoneCtrl.text.trim(),
      streetAddress:
          streetCtrl.text.trim(),
      city:
          cityCtrl.text.trim(),
      agreedToTerms:
          agreedTerms,
    );

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final accountEmail = auth.accountEmail?.trim().toLowerCase();
    if (accountEmail == null || accountEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.signInToContinue),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (app.email != accountEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.sellerEmailMustMatchAccount),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final apps = Provider.of<SellerApplicationsProvider>(
      context,
      listen: false,
    );
    if (apps.hasPendingForEmail(accountEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.applicationPendingMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(
        context,
        SellerApplicationStatusScreen.route,
      );
      return;
    }

    bool savedToCloud = false;
    try {
      savedToCloud = await Provider.of<SellerApplicationsProvider>(
        context,
        listen: false,
      ).submit(app);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.sendFailed(e.toString())),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          savedToCloud ? loc.applicationSent : loc.applicationSentLocalFallback,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );

    Navigator.pushReplacementNamed(
      context,
      SellerApplicationStatusScreen.route,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    return Scaffold(
            bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 12,

        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          AppBranding.seedColor.withValues(alpha: 0.12),
                      foregroundColor: AppBranding.seedColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      loc.cancel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex:
                      2,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon:
                        const Icon(
                      Icons.article_outlined,
                      color:
                          Colors.white,
                    ),

                    label: Text(
                      loc.submitApplication,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: FilledButton.styleFrom(
                      backgroundColor:
                          AppBranding.seedColor,

                      foregroundColor:
                          Colors.white,

                      elevation: 0,

                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            14,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            width:
                double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppBranding.authGradient,
              ),
            ),

            padding: EdgeInsets.only(
              left: 8,
              right: 16,
              top:
                  MediaQuery.paddingOf(context).top + 8,
              bottom: 22,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Colors.white.withValues(
                      alpha:
                          0.2,
                    ),
                  ),

                  onPressed: () => Navigator.pop(
                    context,
                  ),

                  icon: const Icon(
                    Icons.chevron_left,
                    color:
                        Colors.white,
                  ),

                  iconSize:
                      26,
                ),

                const SizedBox(
                  height:
                      12,
                ),

                Text(
                  loc.becomeSeller,

                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height:
                      8,
                ),

                Text(
                  loc.becomeSellerTagline,

                  style:
                      TextStyle(
                    color:
                        Colors.white.withValues(
                      alpha:
                          0.9,
                    ),
                    fontSize:
                        14,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: appPageInsets(context, top: 12, bottom: 16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _card(
                    title: loc.storeLogo,
                    children: [
                      Center(
                        child: ListenableBuilder(
                          listenable: storeNameCtrl,
                          builder: (_, __) => StoreLogoAvatar(
                            storeName: storeNameCtrl.text.trim().isNotEmpty
                                ? storeNameCtrl.text.trim()
                                : '?',
                            radius: 44,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        loc.storeLogoInitialsHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        14,
                  ),

                  _card(
                    title: loc.storeInformation,
                    children: [
                      _label(loc.storeName),
                      TextField(
                        controller: storeNameCtrl,
                        decoration: _outline(loc.storeNameHint).copyWith(
                          prefixIcon: Icon(
                            Icons.storefront_outlined,
                            color:
                                Colors.grey.shade600,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height:
                            14,
                      ),

                      _label(loc.storeDescription),
                      TextField(
                        controller: descCtrl,
                        maxLines: 4,
                        decoration: _outline(loc.storeDescriptionHint),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        14,
                  ),

                  _card(
                    title: loc.contactInformation,
                    children: [
                      _label(loc.email),
                      TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _outline(loc.emailHint).copyWith(
                          prefixIcon:
                              Icon(
                            Icons.mail_outline,
                            color:
                                Colors.grey.shade600,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height:
                            14,
                      ),

                      _label(loc.phoneNumber),
                      TextField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: _outline(loc.phoneHint).copyWith(
                          prefixIcon:
                              Icon(
                            Icons.phone_outlined,
                            color:
                                Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        14,
                  ),

                  _card(
                    title: loc.storeAddress,
                    children: [
                      _label(loc.streetAddress),
                      TextField(
                        controller: streetCtrl,
                        decoration: _outline(loc.streetHint).copyWith(
                          prefixIcon:
                              Icon(
                            Icons.place_outlined,
                            color:
                                Colors.grey.shade600,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height:
                            14,
                      ),

                      _label(loc.cityLabel),
                      TextField(
                        controller: cityCtrl,
                        decoration: _outline(loc.cityHint).copyWith(
                          prefixIcon:
                              Icon(
                            Icons.place_outlined,
                            color:
                                Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        14,
                  ),

                  _card(
                    title: loc.sellerAgreement,
                    children: [
                      Text(
                        loc.sellerAgreementBody,
                        style:
                            TextStyle(
                          height:
                              1.55,
                          color:
                              Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(
                        height:
                            14,
                      ),

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value:
                                agreedTerms,
                            activeColor:
                                AppBranding.seedColor,

                            materialTapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap,

                            onChanged: (v) {

                              setState(() {

                                agreedTerms =
                                    v ??
                                        false;
                              });
                            },
                          ),

                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(
                                top:
                                    10,
                              ),
                              child:
                                  RichText(
                                text:
                                    TextSpan(
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.grey
                                            .shade800,
                                    height:
                                        1.45,
                                  ),
                                  children: [
                                    TextSpan(text: loc.agreeTerms),
                                    TextSpan(
                                      text: loc.termsConditions,
                                      style: TextStyle(
                                        color: AppBranding.seedColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: ' & '),
                                    TextSpan(
                                      text: loc.sellerPolicy,
                                      style:
                                          TextStyle(
                                        color:
                                            AppBranding.seedColor,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
