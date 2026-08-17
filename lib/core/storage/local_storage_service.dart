import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

class LocalStorageService {
  const LocalStorageService(this._preferences);
  final SharedPreferencesAsync _preferences;
  Future<void> saveString(String key, String value) {
    return _preferences.setString(key, value);
  }

  Future<String?> getString(String key) {
    return _preferences.getString(key);
  }

  Future<void> saveBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  Future<bool?> getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<void> saveJson(String key, Object value) {
    return _preferences.setString(key, jsonEncode(value));
  }

  Future<dynamic> getJson(String key) async {
    final value = await _preferences.getString(key);
    if (value == null) {
      return null;
    }

    try {
      return jsonDecode(value);
    } on FormatException {
      return null;
    }
  }

  Future<bool> containsKey(String key) {
    return _preferences.containsKey(key);
  }

  Future<void> remove(String key) {
    return _preferences.remove(key);
  }

  Future<void> clearAppData() {
    return _preferences.clear(allowList: StorageKeys.appKeys);
  }
}
