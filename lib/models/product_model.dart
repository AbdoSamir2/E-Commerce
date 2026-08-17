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
}

final List<ProductModel> dummyProducts = [
  ProductModel(
    id: 'prod_1',
    title: 'Wireless Headphones',
    price: '99.99',
    imageUrl: 'https://picsum.photos/200/300?random=1',
    rating: 4.8,
    description:
        'Experience true wireless freedom with these noise-canceling headphones. Up to 20 hours of battery life.',
    stockStatus: 'In stock',
  ),
  ProductModel(
    id: 'prod_2',
    title: 'Smart Watch Series 7',
    price: '149.50',
    imageUrl: 'https://picsum.photos/200/300?random=2',
    rating: 4.6,
    description:
        'A sleek and classic smart watch to keep track of your daily activities and notifications. Water-resistant and durable.',
    stockStatus: 'In stock',
  ),
  ProductModel(
    id: 'prod_3',
    title: 'Nike Running Shoes',
    price: '79.00',
    imageUrl: 'https://picsum.photos/200/300?random=3',
    rating: 4.3,
    description:
        'Lightweight running shoes designed for comfort and performance on every run.',
    stockStatus: 'Out of stock',
  ),
  ProductModel(
    id: 'prod_4',
    title: 'Casual Winter Jacket',
    price: '120.00',
    imageUrl: 'https://picsum.photos/200/300?random=4',
    rating: 4.7,
    description:
        'A warm and stylish winter jacket to keep you comfortable in cold weather.',
    stockStatus: 'In stock',
  ),
];
