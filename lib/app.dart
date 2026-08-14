import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/api/api_client.dart';
import 'core/routing/app_router.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';

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
      child: MaterialApp.router(
        title: 'E-Commerce',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
