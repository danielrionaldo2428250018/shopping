import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // 🔥 CREATE
  Future<void> addProduct({
    required String name,
    required String price,
    required List<String> images,
  }) async {
    await _db.collection('products').add({
      'name': name.toLowerCase(), // 🔥 penting untuk search
      'price': price,
      'images': images,
      'coverIndex': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔥 READ ALL
  Stream<QuerySnapshot> getProducts() {
    return _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // 🔥 READ SINGLE
  Stream<DocumentSnapshot> getProduct(String id) {
    return _db.collection('products').doc(id).snapshots();
  }

  // 🔥 DELETE
  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }

  // 🔥 UPDATE FULL
  Future<void> updateProductFull({
    required String id,
    required String name,
    required String price,
    required List<String> images,
    required int coverIndex,
  }) async {
    await _db.collection('products').doc(id).update({
      'name': name.toLowerCase(), // 🔥 konsisten search
      'price': price,
      'images': images,
      'coverIndex': coverIndex,
    });
  }

  // 🔥 SEARCH (REALTIME)
  Stream<QuerySnapshot> searchProducts(String query) {
    if (query.isEmpty) {
      return getProducts();
    }

    return _db
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('name', isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
        .snapshots();
  }

  // 🔥 SORT BY PRICE (OPTIONAL QUERY)
  Stream<QuerySnapshot> getProductsSortedByPrice(bool ascending) {
    return _db
        .collection('products')
        .orderBy('price', descending: !ascending)
        .snapshots();
  }
}