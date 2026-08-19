import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/api_client.dart';
import 'core/routing/app_router.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'features/cart/logic/cart/cart_cubit.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({
    required this.apiClient,
    required this.localStorageService,
    super.key,
  });

  final ApiClient apiClient;
  final LocalStorageService localStorageService;

  @override
  Widget build(BuildContext context)
  {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>.value(value: apiClient,),
        RepositoryProvider<LocalStorageService>.value(value: localStorageService,),
      ],

      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeCubit(),
          ),

          BlocProvider(
            create: (context) => CartCubit(context.read<LocalStorageService>(),)..loadCart(),
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