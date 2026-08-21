import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/catalog/presentation/add_product_screen.dart';
import '../../features/navigation/presentation/screens/main_shell.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  errorBuilder: (context, state) {
    return PageNotFoundScreen(message: state.error?.toString());
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) {
        return const SignupScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return const MainShell();
      },
    ),
    GoRoute(
      path: AppRoutes.addProduct,
      builder: (context, state) {
        return const AddProductScreen();
      },
    ),
  ],
);

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(child: Text(message ?? 'That page does not exist.')),
    );
  }
}
