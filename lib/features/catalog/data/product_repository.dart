import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/product_model.dart';

class ProductFailure implements Exception {
  const ProductFailure(this.message);

  final String message;

  @override
  String toString() => 'ProductFailure(message: $message)';
}

class ProductRepository {
  ProductRepository({FirebaseFirestore? firestore})
    : _injectedFirestore = firestore;

  final FirebaseFirestore? _injectedFirestore;

  FirebaseFirestore get _firestore =>
      _injectedFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final snapshot = await _products.get();

      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList();
    } on FirebaseException catch (error) {
      throw ProductFailure(_messageFor(error));
    }
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      final data = product.toMap()
        ..['createdAt'] = FieldValue.serverTimestamp();

      final reference = await _products.add(data);

      return ProductModel(
        id: reference.id,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        rating: product.rating,
        description: product.description,
        stockStatus: product.stockStatus,
      );
    } on FirebaseException catch (error) {
      throw ProductFailure(_messageFor(error));
    }
  }

  String _messageFor(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'You do not have permission to do that. '
            'Check your Firestore security rules.';
      case 'unavailable':
        return 'Could not reach the server. Check your connection.';
      case 'not-found':
        return 'That product no longer exists.';
      case 'no-app':
        return 'Firebase is unavailable on this platform. '
            'Run the app on Android, iOS, or the web.';
      default:
        return error.message ?? 'Something went wrong. Please try again.';
    }
  }
}
