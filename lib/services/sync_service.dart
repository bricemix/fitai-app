import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile.dart';
import '../models/body_entry.dart';
import '../models/meal.dart';
import '../models/planning.dart';
import 'auth_service.dart';
import 'currency_service.dart';
import 'storage_service.dart';

/// Gère la synchronisation bidirectionnelle entre l'app et le serveur.
/// Toutes les méthodes sont silencieuses (catch(_){}) : un échec réseau
/// ne bloque jamais l'utilisateur.
class SyncService {
  static String get _base => AuthService.baseUrl;

  // ── Upload ────────────────────────────────────────────────────────────────

  static Future<void> uploadProfile(UserProfile profile) async {
    await _put('/user/profile', profile.toJson());
  }

  static Future<void> uploadBodyEntries(List<BodyEntry> entries) async {
    await _put('/user/body_entries', {
      'body_entries': entries.map((e) => e.toJson()).toList(),
    });
  }

  static Future<void> uploadPlanning(List<DayPlan> plans) async {
    await _put('/user/planning', {
      'planning': plans.map((p) => p.toJson()).toList(),
    });
  }

  static Future<void> uploadMeals(List<Meal> meals) async {
    await _put('/user/meals', {
      'meals': meals.map((m) => m.toJson()).toList(),
    });
  }

  /// Upload the daily missions history to the server.
  /// [missions] is a map of {dateISO: {water, walk, nosugar, ...}}
  static Future<void> uploadMissions(Map<String, dynamic> missions) async {
    await _put('/user/missions', {'missions': missions});
  }

  // ── Download (au login) ───────────────────────────────────────────────────

  /// Récupère toutes les données utilisateur depuis le serveur et les stocke
  /// localement. Retourne true si au moins le profil a été récupéré.
  static Future<bool> downloadAll() async {
    bool gotProfile = false;
    await Future.wait([
      _downloadProfile().then((ok) { if (ok) gotProfile = true; }),
      _downloadBodyEntries(),
      _downloadPlanning(),
      _downloadMeals(),
    ]);
    return gotProfile;
  }

  /// Télécharge uniquement le profil FitAI depuis le serveur.
  /// Retourne true si un profil a été trouvé et sauvegardé.
  static Future<bool> downloadProfile() => _downloadProfile();

  // ── Privé ─────────────────────────────────────────────────────────────────

  static Future<bool> _downloadProfile() async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http
          .get(Uri.parse('$_base/user/fitai'), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final raw = data['fitai_profile'];
        if (raw is Map<String, dynamic> && raw.isNotEmpty) {
          final profile = UserProfile.fromJson(raw);
          await StorageService.saveProfile(profile);
          // Restaure la devise préférée depuis le profil serveur
          if (profile.currencyCode.isNotEmpty) {
            final currency = CurrencyService.currencies.firstWhere(
              (c) => c.code == profile.currencyCode,
              orElse: () => CurrencyService.defaultCurrency,
            );
            await CurrencyService.save(currency);
          }
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  static Future<void> _downloadBodyEntries() async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http
          .get(Uri.parse('$_base/user/body_entries'), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final raw = data['body_entries'];
        if (raw is List && raw.isNotEmpty) {
          final entries = raw
              .map((e) => BodyEntry.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
          // Merge : on garde les entrées locales plus récentes que celles du serveur
          final local = await StorageService.loadBodyEntries();
          final merged = _mergeEntries(serverEntries: entries, localEntries: local);
          await StorageService.saveBodyEntries(merged);
        }
      }
    } catch (_) {}
  }

  static Future<void> _downloadPlanning() async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http
          .get(Uri.parse('$_base/user/planning'), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final raw = data['planning'];
        if (raw is List && raw.isNotEmpty) {
          final plans = raw
              .map((e) => DayPlan.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
          await StorageService.savePlanning(plans);
        }
      }
    } catch (_) {}
  }

  static Future<void> _downloadMeals() async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http
          .get(Uri.parse('$_base/user/meals'), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final raw = data['meals'];
        if (raw is List && raw.isNotEmpty) {
          final serverMeals = raw
              .map((e) => Meal.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
          // Merge : union par date+heure, les locales priment (plus récentes)
          final localMeals = await StorageService.loadMeals();
          final merged = _mergeMeals(serverMeals: serverMeals, localMeals: localMeals);
          await StorageService.saveMeals(merged);
        }
      }
    } catch (_) {}
  }

  // ── Merge logique ─────────────────────────────────────────────────────────

  /// Fusionne entrées serveur + locales : pour un même jour, on garde
  /// celle avec le plus d'informations (non nulle).
  static List<BodyEntry> _mergeEntries({
    required List<BodyEntry> serverEntries,
    required List<BodyEntry> localEntries,
  }) {
    final map = <String, BodyEntry>{};
    // Serveur en base
    for (final e in serverEntries) {
      map[e.date] = e;
    }
    // Local écrase si plus récent / non vide
    for (final e in localEntries) {
      if (!map.containsKey(e.date)) {
        map[e.date] = e;
      } else {
        // Garde la locale si elle a un poids défini (c'est la plus récente sur l'appareil)
        if (e.weight != null) map[e.date] = e;
      }
    }
    final result = map.values.toList();
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  /// Fusionne repas serveur + locaux : union par (date ISO + nom du plat).
  /// Les repas locaux priment sur les serveur en cas de doublon exact.
  static List<Meal> _mergeMeals({
    required List<Meal> serverMeals,
    required List<Meal> localMeals,
  }) {
    // Clé = date ISO complète + nom normalisé
    String key(Meal m) => '${m.date}|${m.result.name.toLowerCase().trim()}';

    final map = <String, Meal>{};
    for (final m in serverMeals) {
      map[key(m)] = m;
    }
    // Local écrase serveur (appareil courant = vérité)
    for (final m in localMeals) {
      map[key(m)] = m;
    }
    final result = map.values.toList();
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  // ── Helpers HTTP ──────────────────────────────────────────────────────────

  static Future<void> _put(String path, Map<String, dynamic> body) async {
    try {
      final headers = await AuthService.authHeaders();
      await http
          .put(
            Uri.parse('$_base$path'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));
    } catch (_) {}
  }
}
