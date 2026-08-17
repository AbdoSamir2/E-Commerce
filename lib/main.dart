import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/api/api_client.dart';
import 'core/observer/app_bloc_observer.dart';
import 'core/storage/local_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  final localStorageService = LocalStorageService(SharedPreferencesAsync());
  final apiClient = ApiClient();

  runApp(
    EcommerceApp(
      apiClient: apiClient,
      localStorageService: localStorageService,
    ),
  );
}
