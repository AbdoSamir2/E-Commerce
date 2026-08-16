import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/local_storage_service.dart';
import 'cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._localStorageService) : super(const CartState());

  final LocalStorageService _localStorageService;

  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      final savedData = await _localStorageService.getJson(StorageKeys.cart);

      if (savedData is! List) {
        emit(const CartState(status: CartStatus.success));
        return;
      }

      final items = savedData
          .whereType<Map>()
          .map(
            (item) => CartItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      emit(CartState(
        status: CartStatus.success,
        items: items,
      ));
    } catch (_) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Could not restore your cart.',
        ),
      );
    }
  }

  Future<void> addToCart({
    required String title,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) async {
    final updatedItems = [...state.items];
    final index = updatedItems.indexWhere((item) => item.title == title);

    if (index == -1) {
      updatedItems.add(
        CartItem(
          title: title,
          price: price,
          imageUrl: imageUrl,
          quantity: quantity,
        ),
      );
    } else {
      final item = updatedItems[index];
      updatedItems[index] = item.copyWith(
        quantity: item.quantity + quantity,
      );
    }

    await _saveAndEmit(updatedItems);
  }

  Future<void> incrementQuantity(String title) async {
    final updatedItems = state.items.map((item) {
      if (item.title == title) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();

    await _saveAndEmit(updatedItems);
  }

  Future<void> decrementQuantity(String title) async {
    final updatedItems = state.items
        .map((item) {
          if (item.title == title) {
            return item.copyWith(quantity: item.quantity - 1);
          }
          return item;
        })
        .where((item) => item.quantity > 0)
        .toList();

    await _saveAndEmit(updatedItems);
  }

  Future<void> removeFromCart(String title) async {
    final updatedItems =
        state.items.where((item) => item.title != title).toList();

    await _saveAndEmit(updatedItems);
  }

  Future<void> clearCart() async {
    emit(const CartState(status: CartStatus.success));

    try {
      await _localStorageService.remove(StorageKeys.cart);
    } catch (_) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Could not clear your cart.',
        ),
      );
    }
  }

  Future<void> _saveAndEmit(List<CartItem> items) async {
    emit(
      CartState(
        status: CartStatus.success,
        items: List.unmodifiable(items),
      ),
    );

    try {
      await _localStorageService.saveJson(
        StorageKeys.cart,
        items.map((item) => item.toJson()).toList(),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Could not save your cart.',
        ),
      );
    }
  }
}
