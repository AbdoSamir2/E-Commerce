class Order
{
  final String orderId;
  final DateTime date;
  final double totalPrice;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String postalCode;
  final String paymentMethod;

  Order({
    required this.orderId,
    required this.date,
    required this.totalPrice,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'date': date.toIso8601String(),
      'totalPrice': totalPrice,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'paymentMethod': paymentMethod,
    };
  }
}