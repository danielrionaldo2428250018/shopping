import 'catalog_product.dart';

/// Satu baris keranjang (identitas produk + qty).
class CartLine {
  CartLine({
    required this.product,
    required this.quantity,
  });

  final CatalogProduct product;
  int quantity;

  int get lineTotal => product.unitPrice * quantity;
}
