import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routing/app_router.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';

import 'features/auth/data/auth_repository.dart';
import 'features/auth/logic/auth_cubit.dart';
import 'features/cart/logic/cart/cart_cubit.dart';
import 'features/catalog/data/product_repository.dart';
import 'features/catalog/logic/product_cubit.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({required this.localStorageService, super.key});

  final LocalStorageService localStorageService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LocalStorageService>.value(
          value: localStorageService,
        ),
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<ProductRepository>(
          create: (_) => ProductRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(
            create: (context) =>
                CartCubit(context.read<LocalStorageService>())..loadCart(),
          ),
          BlocProvider(
            create: (context) => AuthCubit(context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                ProductCubit(context.read<ProductRepository>())..loadProducts(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDark = state is DarkThemeState;

            return MaterialApp.router(
              title: 'E-Commerce',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              routerConfig: appRouter,
            );
          },
        ),
      ),
    );
  }
}
