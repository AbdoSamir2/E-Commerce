abstract final class ApiConstants {
  static const baseUrl = 'https://fakestoreapi.com';

  static const products = '/products';
  static const categories = '/products/categories';
  static const login = '/auth/login';
  static const users = '/users';

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 15);
  static const sendTimeout = Duration(seconds: 15);

  static String productById(int productId) {
    return '$products/$productId';
  }

  static String productsByCategory(String category) {
    return '$products/category/${Uri.encodeComponent(category)}';
  }

  static String userById(int userId) {
    return '$users/$userId';
  }
}
