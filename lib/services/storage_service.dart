import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';
import '../models/meal.dart';
import '../models/body_entry.dart';
import '../models/planning.dart';

class StorageService {
  static const _profileKey      = 'fitai_profile';
  static const _mealsKey        = 'fitai_meals';
  static const _bodyEntriesKey  = 'fitai_body_entries';
  static const _planningKey     = 'fitai_planning';
  static const _dishesKey       = 'fitai_dishes';
  static const _firstOpenKey    = 'fitai_first_open_done';

  // ── Première ouverture (paywall) ──────────────────────────────────────────

  /// Retourne true si c'est la toute première ouverture de l'app.
  static Future<bool> isFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_firstOpenKey) ?? false);
  }

  static Future<void> markFirstOpenDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstOpenKey, true);
  }

  // ── Profile ──────────────────────────────────────────────────────────────────

  static Future<UserProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null) return null;
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  static Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }

  // ── Meals ─────────────────────────────────────────────────────────────────────

  static Future<List<Meal>> loadMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_mealsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Meal.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> saveMeals(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mealsKey, jsonEncode(meals.map((m) => m.toJson()).toList()));
  }

  // ── Body entries ──────────────────────────────────────────────────────────────

  static Future<List<BodyEntry>> loadBodyEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_bodyEntriesKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => BodyEntry.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  static Future<void> saveBodyEntries(List<BodyEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bodyEntriesKey, jsonEncode(entries.map((e) => e.toJson()).toList()));
  }

  static Future<BodyEntry?> todayBodyEntry() async {
    final entries = await loadBodyEntries();
    try {
      return entries.lastWhere((e) => e.isToday);
    } catch (_) {
      return null;
    }
  }

  // ── Planning hebdomadaire ─────────────────────────────────────────────────────

  static Future<List<DayPlan>> loadPlanning() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_planningKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => DayPlan.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> savePlanning(List<DayPlan> plans) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_planningKey, jsonEncode(plans.map((p) => p.toJson()).toList()));
  }

  static Future<DayPlan?> todayPlan() async {
    final plans = await loadPlanning();
    final today = DayPlan.todayKey();
    try {
      return plans.firstWhere((p) => p.date == today);
    } catch (_) {
      return null;
    }
  }

  // ── Dish recommendations ──────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> loadDishes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dishesKey);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveDishes(List<Map<String, dynamic>> dishes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dishesKey, jsonEncode(dishes));
  }
}
