import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/navigation/presentation/screens/main_shell.dart';
import '../../features/checkout/screen/checkout_screen.dart';
import '../../features/checkout/screen/order_history_screen.dart';
import '../../features/checkout/screen/order_success.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/cart/logic/cart/cart_screen.dart';
import '../../features/productdetailed/ProductDetaildScreen.dart';
import '../../models/product_model.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,

  errorBuilder: (context, state) {
    return _PlaceholderScreen(
      title: 'Page not found',
      message: state.error?.toString(),
    );
  },

  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) {return const SplashScreen();},
    ),

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {return const LoginScreen();},
    ),

    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {return const MainShell();},
    ),

    GoRoute(
      path: AppRoutes.productDetails,
      builder: (context, state) {
        final product = state.extra as ProductModel;

        return ProductDetailScreen(
          id: product.id,
          title: product.title,
          price: double.parse(product.price),
          imageUrl: product.imageUrl,
          description: product.description,
          stockStatus: product.stockStatus,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.cart,
      builder: (context, state) {
        return CartScreen(onStartShopping: () {context.go(AppRoutes.home);},);
      },
    ),

    GoRoute(
      path: AppRoutes.checkout,
      builder: (context, state) {
        return const CheckoutScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.orderSuccess,
      builder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'] ?? '';
        return OrderSuccessScreen(orderId: orderId,);
      },
    ),

    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) {return const ProfileScreen();},
    ),

    GoRoute(
      path: AppRoutes.orderHistory,
      builder: (context, state) {return const OrderHistoryScreen();},
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, this.message,});
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          message ?? '$title screen is under development.',
        ),
      ),
    );
  }
}