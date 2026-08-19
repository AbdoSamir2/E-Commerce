abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const productDetails = '/products/:productId';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const profile = '/profile';
  static const orderHistory = '/order-history';

  static String productDetailsLocation(int productId,)
  {
    return '/products/$productId';
  }
}