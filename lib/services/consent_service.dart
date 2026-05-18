import 'package:shared_preferences/shared_preferences.dart';

class ConsentService {
  static const _consentKey = 'dv_consent_accepted';
  static const _consentVersionKey = 'dv_consent_version';

  /// Current policy version — bump this string to force re-acceptance on update.
  static const currentVersion = '1.0';

  /// Returns true if the user has already accepted the current policy version.
  static Future<bool> hasAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool(_consentKey) ?? false;
    final version = prefs.getString(_consentVersionKey) ?? '';
    return accepted && version == currentVersion;
  }

  /// Persist acceptance with current date and policy version.
  static Future<void> accept() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, true);
    await prefs.setString(_consentVersionKey, currentVersion);
    await prefs.setString(
      'dv_consent_date',
      DateTime.now().toIso8601String(),
    );
  }

  /// Wipe consent (e.g. for testing or on user request).
  static Future<void> revoke() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_consentKey);
    await prefs.remove(_consentVersionKey);
    await prefs.remove('dv_consent_date');
  }
}
