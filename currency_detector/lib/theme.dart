import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeModel() {
    _loadThemePreference();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveThemePreference();
    notifyListeners();
  }

  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = (prefs.getBool('isDarkTheme') ?? false);
    notifyListeners();
  }

  void _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
  }
}
