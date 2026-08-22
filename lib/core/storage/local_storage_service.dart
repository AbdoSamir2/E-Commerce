import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  const LocalStorageService(this._preferences);

  final SharedPreferencesAsync _preferences;

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

  Future<void> remove(String key) {
    return _preferences.remove(key);
  }
}
