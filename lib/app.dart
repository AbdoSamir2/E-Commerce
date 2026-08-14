import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/api/api_client.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'features/catalog/home_screen.dart'; // تأكد من صحة مسار شاشتك هنا

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({
    required this.apiClient,
    required this.localStorageService,
    super.key,
  });

  final ApiClient apiClient;
  final LocalStorageService localStorageService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>.value(value: apiClient),
        RepositoryProvider<LocalStorageService>.value(
          value: localStorageService,
        ),
      ],
      child: BlocProvider(
        create: (context) => ThemeCubit(),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDark = state is DarkThemeState;

            return MaterialApp(
              title: 'E-Commerce',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

              // تجربة الشاشة مباشرة هنا
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
