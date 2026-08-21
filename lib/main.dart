import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
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

  // Firebase has no Linux desktop support, so skip init there and let the rest
  // of the app run normally. Every other platform initializes as before.
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.linux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

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
