import '../constants/app_admin_config.dart';
import '../models/catalog_product.dart';

/// Apakah pengguna boleh mengubah/menghapus produk ini.
bool canManageCatalogProduct({
  required CatalogProduct product,
  required String? uid,
  required String? accountEmail,
  required bool isSeller,
  required String? myStoreName,
}) {
  if (isAppAdminUser(email: accountEmail, uid: uid)) return true;
  if (uid != null &&
      uid.isNotEmpty &&
      product.sellerUid.isNotEmpty &&
      product.sellerUid == uid) {
    return true;
  }
  if (isSeller &&
      myStoreName != null &&
      myStoreName.isNotEmpty &&
      product.sellerName == myStoreName) {
    return true;
  }
  return false;
}
