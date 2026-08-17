import 'cart_item.dart';

enum CartStatus { initial, loading, success, failure }

class CartState {
  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  final CartStatus status;
  final List<CartItem> items;
  final String? errorMessage;

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get tax => subtotal * 0.05;

  double get shipping {
    if (items.isEmpty) return 0.0;
    return subtotal >= 100 ? 0.0 : 10.0;
  }

  double get grandTotal => subtotal + tax + shipping;

  int get totalItemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}
