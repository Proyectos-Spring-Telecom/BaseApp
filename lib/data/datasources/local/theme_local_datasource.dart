import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

abstract class ThemeLocalDataSource {
  Future<void> saveThemeMode(ThemeMode mode);
  ThemeMode getThemeMode();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences _prefs;

  ThemeLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(AppConstants.themeKey, mode.name);
  }

  @override
  ThemeMode getThemeMode() {
    final value = _prefs.getString(AppConstants.themeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
