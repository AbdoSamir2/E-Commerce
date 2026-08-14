import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      builder: (context, state) {
        return const _PlaceholderScreen(title: 'Splash');
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return const _PlaceholderScreen(title: 'Login');
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return const _PlaceholderScreen(title: 'Home');
      },
    ),
    GoRoute(
      path: AppRoutes.productDetails,
      builder: (context, state) {
        final productId = state.pathParameters['productId'];

        return _PlaceholderScreen(
          title: 'Product details',
          message: 'Product ID: $productId',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.cart,
      builder: (context, state) {
        return const _PlaceholderScreen(title: 'Cart');
      },
    ),
    GoRoute(
      path: AppRoutes.checkout,
      builder: (context, state) {
        return const _PlaceholderScreen(title: 'Checkout');
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) {
        return const _PlaceholderScreen(title: 'Profile');
      },
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, this.message});

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(message ?? '$title screen is under development.'),
      ),
    );
  }
}
