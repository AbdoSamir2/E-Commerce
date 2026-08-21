import '../../../models/product_model.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.isSaving = false,
    this.errorMessage,
  });

  final ProductStatus status;
  final List<ProductModel> products;

  final bool isSaving;
  final String? errorMessage;

  bool get isEmpty => status == ProductStatus.success && products.isEmpty;

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    bool? isSaving,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
    );
  }
}
