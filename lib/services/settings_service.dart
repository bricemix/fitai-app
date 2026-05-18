import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _modelKey = 'fitai_model';
  static const defaultModel = 'google/gemini-2.0-flash-001';

  static Future<String> getModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_modelKey) ?? defaultModel;
  }

  static Future<void> saveModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modelKey, model.trim());
  }
}
