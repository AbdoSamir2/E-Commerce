class CartItem {
  const CartItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  final String title;
  final double price;
  final String imageUrl;
  final int quantity;

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? title,
    double? price,
    String? imageUrl,
    int? quantity,
  }) {
    return CartItem(
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}
