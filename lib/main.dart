import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/observer/app_bloc_observer.dart';
import 'core/storage/local_storage_service.dart';
import 'firebase_options.dart';

bool get _firebaseIsSupportedOnThisPlatform =>
    kIsWeb || defaultTargetPlatform != TargetPlatform.linux;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_firebaseIsSupportedOnThisPlatform) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Bloc.observer = const AppBlocObserver();

  final localStorageService = LocalStorageService(SharedPreferencesAsync());

  runApp(EcommerceApp(localStorageService: localStorageService));
}
