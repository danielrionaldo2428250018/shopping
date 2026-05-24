import '../l10n/app_localizations.dart';
import '../services/upload_service.dart';

String uploadFailureMessage(AppLocalizations loc, UploadFailure failure) {
  switch (failure.code) {
    case UploadFailureCode.notAuthenticated:
      return loc.uploadProductImageAuthRequired;
    case UploadFailureCode.fileMissing:
      return loc.uploadProductImageFileMissing;
    case UploadFailureCode.storageRules:
      return loc.uploadProductImageStorageRules;
    case UploadFailureCode.network:
      return loc.uploadProductImageNetwork;
    case UploadFailureCode.unauthorized:
      return loc.uploadProductImageStorageRules;
    case UploadFailureCode.imageTooLarge:
      return loc.uploadProductImageTooLarge;
    case UploadFailureCode.unknown:
      return loc.uploadProductImageFailed;
  }
}
