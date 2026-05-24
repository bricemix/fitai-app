import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

/// Synchronise l'historique du chat coach avec le serveur.
/// Stratégie : local-first + sync serveur asynchrone.
class ChatSyncService {
  static const _kHistoryKey  = 'coach_chat_history';
  static const _kOldestIdKey = 'coach_chat_oldest_id';
  static const _loadLimit    = 100;
  static String get _base => AuthService.baseUrl;

  // ── Chargement ─────────────────────────────────────────────────────────────

  /// Tente de charger depuis le serveur, met à jour le cache local.
  /// Retourne la liste de messages (role, content) du plus ancien au plus récent.
  static Future<List<Map<String, String>>> loadHistory() async {
    // 1. Cache local immédiat
    final cached = await _loadLocal();

    // 2. Fetch serveur en arrière-plan
    _syncFromServer(cached);

    return cached;
  }

  static Future<List<Map<String, String>>> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kHistoryKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      return list.map((m) => {'role': m['role'] as String, 'content': m['content'] as String}).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _syncFromServer(List<Map<String, String>> current) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http
          .get(Uri.parse('$_base/chat/history'), headers: headers)
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) return;

      final list = (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
      if (list.isEmpty) {
        // Si le serveur est vide mais qu'on a du local → uploader le local
        if (current.isNotEmpty) await _uploadMessages(current, headers: headers);
        return;
      }

      final msgs = list
          .map((m) => {'role': m['role'] as String, 'content': m['content'] as String})
          .toList();

      // Sauvegarder localement la version serveur (source de vérité)
      await _saveLocal(msgs);

      // Stocker le dernier id connu pour la pagination future
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kOldestIdKey, (list.first['id'] as num).toInt());
    } catch (_) {}
  }

  // ── Sauvegarde ─────────────────────────────────────────────────────────────

  /// Sauvegarde un échange (user + assistant) localement ET sur le serveur.
  /// L'appel serveur est fire-and-forget — ne bloque pas l'UI.
  static Future<void> saveExchange(String userMsg, String assistantMsg) async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString(_kHistoryKey);
    final list  = raw != null && raw.isNotEmpty
        ? (jsonDecode(raw) as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];

    list.add({'role': 'user',      'content': userMsg});
    list.add({'role': 'assistant', 'content': assistantMsg});

    await prefs.setString(_kHistoryKey, jsonEncode(list));

    // Upload asynchrone
    _uploadMessages([
      {'role': 'user',      'content': userMsg},
      {'role': 'assistant', 'content': assistantMsg},
    ]).catchError((_) {});
  }

  static Future<void> _uploadMessages(
    List<Map<String, String>> messages, {
    Map<String, String>? headers,
  }) async {
    try {
      final h = headers ?? await AuthService.authHeaders();
      await http
          .post(
            Uri.parse('$_base/chat/messages'),
            headers: {...h, 'Content-Type': 'application/json'},
            body: jsonEncode({'messages': messages}),
          )
          .timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  // ── Suppression ────────────────────────────────────────────────────────────

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kHistoryKey);
    await prefs.remove(_kOldestIdKey);
    _deleteOnServer().catchError((_) {});
  }

  static Future<void> _deleteOnServer() async {
    try {
      final headers = await AuthService.authHeaders();
      await http
          .delete(Uri.parse('$_base/chat/history'), headers: headers)
          .timeout(const Duration(seconds: 10));
    } catch (_) {}
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static Future<void> _saveLocal(List<Map<String, String>> msgs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kHistoryKey, jsonEncode(msgs));
  }
}
