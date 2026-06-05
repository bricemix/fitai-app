import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';
import 'sync_service.dart';

/// Reads today's mission state from SharedPreferences, builds a snapshot,
/// saves it to local history and uploads it to the server.
///
/// Called whenever a mission is toggled (from Dashboard or Coach/Planning).
class MissionSyncService {
  static String get _todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// Collect today's mission state, persist locally and sync to server.
  ///
  /// [autoStates] — computed states for auto-detected items:
  ///   {'scan': bool, 'protein': bool, 'calorie': bool}
  /// [slots] — which 5 slots were shown today on the home screen
  static Future<void> syncToday({
    Map<String, bool> autoStates = const {},
    List<String> slots = const [],
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final date = _todayKey;

    // Read manual toggles from SharedPreferences
    final water   = prefs.getBool('miss_water_$date')   ?? false;
    final walk    = prefs.getBool('miss_walk_$date')    ?? false;
    final nosugar = prefs.getBool('miss_nosugar_$date') ?? false;
    final calorie = autoStates['calorie'] ?? (prefs.getBool('miss_calorie_$date') ?? false);

    final snapshot = {
      'water':   water,
      'walk':    walk,
      'nosugar': nosugar,
      'calorie': calorie,
      'scan':    autoStates['scan']    ?? false,
      'protein': autoStates['protein'] ?? false,
      'slots':   slots,
      'completed': [water, walk, nosugar, calorie,
                    autoStates['scan'] ?? false,
                    autoStates['protein'] ?? false]
          .where((v) => v)
          .length,
      'total':     6,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // 1. Save locally (history)
    await StorageService.saveMissionsHistory({date: snapshot});

    // 2. Upload to server (silent — never blocks UI)
    SyncService.uploadMissions({date: snapshot});
  }
}
