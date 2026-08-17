class ProductModel {
  final String title;
  final String price;
  final String imageUrl;
  final double rating;

  ProductModel({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.rating = 4.5,
  });
}

final List<ProductModel> dummyProducts = [
  ProductModel(
    title: 'Wireless Headphones',
    price: '99.99',
    imageUrl: 'https://picsum.photos/200/300?random=1',
    rating: 4.8,
  ),
  ProductModel(
    title: 'Smart Watch Series 7',
    price: '149.50',
    imageUrl: 'https://picsum.photos/200/300?random=2',
    rating: 4.6,
  ),
  ProductModel(
    title: 'Nike Running Shoes',
    price: '79.00',
    imageUrl: 'https://picsum.photos/200/300?random=3',
    rating: 4.3,
  ),
  ProductModel(
    title: 'Casual Winter Jacket',
    price: '120.00',
    imageUrl: 'https://picsum.photos/200/300?random=4',
    rating: 4.7,
  ),
];
