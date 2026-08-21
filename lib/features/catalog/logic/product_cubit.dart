import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/product_model.dart';
import '../data/product_repository.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this._productRepository) : super(const ProductState());

  final ProductRepository _productRepository;

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final products = await _productRepository.fetchProducts();

      emit(
        ProductState(
          status: ProductStatus.success,
          products: List.unmodifiable(products),
        ),
      );
    } on ProductFailure catch (failure) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<bool> addProduct(ProductModel product) async {
    emit(state.copyWith(isSaving: true));

    try {
      final saved = await _productRepository.addProduct(product);

      emit(
        ProductState(
          status: ProductStatus.success,
          products: List.unmodifiable([...state.products, saved]),
        ),
      );

      return true;
    } on ProductFailure catch (failure) {
      emit(state.copyWith(isSaving: false, errorMessage: failure.message));

      return false;
    }
  }
}
