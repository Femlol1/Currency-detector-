import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ThemeModel is a ChangeNotifier that allows its listeners to react to changes in the theme of the app.
class ThemeModel extends ChangeNotifier {
  // A private variable that stores whether the app is currently using a dark theme.
  bool _isDarkTheme = false;

  // A getter to allow other parts of the app to read the current theme.
  bool get isDarkTheme => _isDarkTheme;

  // The constructor for ThemeModel loads the theme preference from shared preferences upon instantiation.
  ThemeModel() {
    _loadThemePreference();
  }

  // Toggles the current theme between dark and light, and saves the new preference to shared preferences.
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveThemePreference();
    // Notifies all listeners about the theme change.
    notifyListeners();
  }

  // Loads the theme preference from shared preferences. If no preference is found, defaults to light theme.
  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = (prefs.getBool('isDarkTheme') ?? false);
    // Notifies all listeners about the theme change.
    notifyListeners();
  }

  // Saves the current theme preference to shared preferences.
  void _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
  }
}

// TextSizeModel is a ChangeNotifier that allows its listeners to react to changes in the text size of the app.
class TextSizeModel extends ChangeNotifier {
  // A private variable that stores the current text size, defaults to 16.0.
  double _textSize = 26.0;

  // A getter to allow other parts of the app to read the current text size.
  double get textSize => _textSize;

  // Sets the text size and notifies all listeners about the change.
  void setTextSize(double newSize) {
    _textSize = newSize;
    // Notifies listeners about the text size change.
    notifyListeners();
  }
}

class LanguageModel extends ChangeNotifier {
  Locale _language = Locale('en');

  Locale get language => _language;

  void setLanguage(Locale locale) {
    _language = locale;
    notifyListeners();
  }
}

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Hello',
      // more strings...
    },
    'es': {
      'title': 'Hola',
      // more strings...
    },
  };

  String? get title {
    return _localizedValues[locale.languageCode]!['title'];
  }
  // define more getters...
}
