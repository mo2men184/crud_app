import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'products';

  Future<void> addProduct(Product product) async {
    await _db.collection(_collection).add(product.toMap());
  }

  Future<List<Product>> getProducts(int limit) async {
    var snapshot =
        await _db.collection(_collection).limit(limit).orderBy('name').get();

    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateProduct(Product product) async {
    await _db.collection(_collection).doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _db.collection(_collection).doc(productId).delete();
  }
}
