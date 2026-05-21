import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/seller_application.dart';

/// Akses cepat: `context.l10n.home`
extension AppL10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
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

String nativeLanguageName(String languageCode) {
  switch (languageCode) {
    case 'id':
      return 'Bahasa Indonesia';
    case 'en':
      return 'English';
    case 'ar':
      return 'العربية';
    case 'ko':
      return '한국어';
    case 'zh':
      return '中文';
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

String orderStatusLabel(AppLocalizations loc, String status) {
  switch (status) {
    case 'Completed':
      return loc.orderStatusCompleted;
    case 'Processing':
      return loc.orderStatusProcessing;
    case 'Cancelled':
      return loc.orderStatusCancelled;
    default:
      return status;
  }
}

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
