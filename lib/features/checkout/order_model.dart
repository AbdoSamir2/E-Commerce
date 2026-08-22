import '../cart/logic/cart/cart_item.dart';

class Order {
  final String orderId;
  final DateTime date;
  final List<CartItem> items;
  final double totalPrice;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String postalCode;
  final String paymentMethod;

  const Order({
    required this.orderId,
    required this.date,
    required this.items,
    required this.totalPrice,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.paymentMethod,
  });

  int get totalItemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'paymentMethod': paymentMethod,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];

    return Order(
      orderId: json['orderId'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      items: rawItems
          .whereType<Map>()
          .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
    );
  }
}
