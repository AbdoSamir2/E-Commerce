class ProductModel {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  final double rating;
  final String description;
  final String stockStatus;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.rating = 4.5,
    this.description = 'No description available.',
    this.stockStatus = 'In stock',
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      title: (data['title'] as Object?)?.toString() ?? 'Untitled product',
      price: _readPrice(data['price']),
      imageUrl: (data['imageUrl'] as Object?)?.toString() ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.5,
      description:
          (data['description'] as Object?)?.toString() ??
          'No description available.',
      stockStatus: (data['stockStatus'] as Object?)?.toString() ?? 'In stock',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': double.tryParse(price) ?? 0.0,
      'imageUrl': imageUrl,
      'rating': rating,
      'description': description,
      'stockStatus': stockStatus,
    };
  }

  static String _readPrice(Object? value) {
    if (value is num) {
      return value.toStringAsFixed(2);
    }

    return double.tryParse(value?.toString() ?? '')?.toStringAsFixed(2) ??
        '0.00';
  }
}
