import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('fr');
  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale') ?? 'fr';
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  static const supportedLanguages = [
    ('fr', 'Français', '🇫🇷'),
    ('en', 'English', '🇬🇧'),
    ('de', 'Deutsch', '🇩🇪'),
    ('es', 'Español', '🇪🇸'),
    ('pt', 'Português', '🇧🇷'),
  ];
}
