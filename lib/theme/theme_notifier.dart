// lib/theme/theme_notifier.dart
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    // If you want to cycle through system -> light -> dark:
    // if (_themeMode == ThemeMode.system) {
    //   _themeMode = ThemeMode.light;
    // } else if (_themeMode == ThemeMode.light) {
    //   _themeMode = ThemeMode.dark;
    // } else {
    //   _themeMode = ThemeMode.system;
    // }
    notifyListeners(); // Notify all listening widgets to rebuild
  }

  // You can also add a method to set a specific theme
  void setTheme(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}
