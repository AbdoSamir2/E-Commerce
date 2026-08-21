import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/api/api_client.dart';
import 'core/observer/app_bloc_observer.dart';
import 'core/storage/local_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
