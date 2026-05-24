import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../models/seller_application.dart';
import 'order_flow_l10n.dart';

/// Akses cepat: `context.l10n.home`
extension AppL10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Label bahasa untuk pemilih di Settings (sama pola fasum).
String languageLabel(AppLocalizations loc, String languageCode) {
  switch (languageCode) {
    case 'en':
      return loc.english;
    case 'id':
      return loc.indonesian;
    case 'ar':
      return loc.arab;
    case 'ko':
      return loc.korea;
    case 'zh':
      return loc.mandarin;
    default:
      return loc.unknownLanguage;
  }
}

/// [AppLocalizations] untuk kode bahasa tanpa [BuildContext] (notifikasi, provider).
AppLocalizations appLocalizationsForLanguage(String languageCode) {
  return lookupAppLocalizations(Locale(languageCode));
}

AppLocalizations appLocalizationsFromPrefs(SharedPreferences prefs) {
  return appLocalizationsForLanguage(prefs.getString('locale') ?? 'id');
}

String nativeLanguageName(AppLocalizations loc, String languageCode) {
  switch (languageCode) {
    case 'id':
      return loc.nativeLangIndonesian;
    case 'en':
      return loc.nativeLangEnglish;
    case 'ar':
      return loc.nativeLangArabic;
    case 'ko':
      return loc.nativeLangKorean;
    case 'zh':
      return loc.nativeLangChinese;
    default:
      return languageCode;
  }
}

/// Judul hadiah demo yang disimpan dengan id tetap di [RewardsCatalogProvider].
String? rewardCatalogTitleL10n(AppLocalizations loc, String id) {
  switch (id) {
    case 'voucher-ongkir-50':
      return loc.rewardSampleShipping;
    case 'voucher-diskon-10':
      return loc.rewardSampleDiscount;
    case 'voucher-eco-bag':
      return loc.rewardSampleBag;
    case 'voucher-premium':
      return loc.rewardSampleFeeWaive;
    default:
      return null;
  }
}

String? rewardCatalogDescriptionL10n(AppLocalizations loc, String id) {
  switch (id) {
    case 'voucher-ongkir-50':
      return loc.rewardSampleShippingDesc;
    case 'voucher-diskon-10':
      return loc.rewardSampleDiscountDesc;
    case 'voucher-eco-bag':
      return loc.rewardSampleBagDesc;
    case 'voucher-premium':
      return loc.rewardSampleFeeWaiveDesc;
    default:
      return null;
  }
}

String orderStatusLabel(AppLocalizations loc, String status) =>
    orderStatusLabelExtended(loc, status);

String sellerStatusLabel(
  SellerApplicationStatus status,
  AppLocalizations loc,
) {
  switch (status) {
    case SellerApplicationStatus.pending:
      return loc.tabPending;
    case SellerApplicationStatus.approved:
      return loc.tabApproved;
    case SellerApplicationStatus.rejected:
      return loc.tabRejected;
  }
}

const List<Locale> kAppLanguageLocales = [
  Locale('id'),
  Locale('en'),
  Locale('ar'),
  Locale('ko'),
  Locale('zh'),
];
