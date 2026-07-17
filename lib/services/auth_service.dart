import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthResult {
  final bool success;
  final String? token;
  final Map<String, dynamic>? user;
  final String? error;

  const AuthResult({required this.success, this.token, this.user, this.error});
}

class AuthService {
  static const String baseUrl = 'https://api.diet-vision.com/api/v1';
  static const _tokenKey = 'dv_jwt_token';
  static const _userKey  = 'dv_user';

  static const _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── Session unique : notifier global ─────────────────────────────────────
  // Lorsque le serveur répond SESSION_INVALIDATED (autre appareil connecté),
  // on peuple ce ValueNotifier avec le message d'erreur.
  // Le widget racine (_AppLoaderState) écoute ce notifier et déconnecte l'utilisateur.

  static final ValueNotifier<String?> sessionInvalidated = ValueNotifier(null);

  /// À appeler sur chaque réponse 401 reçue depuis l'API.
  /// Retourne true si la session a été invalidée (autre appareil).
  static Future<bool> handleUnauthorized(http.Response response) async {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['code'] == 'SESSION_INVALIDATED') {
        await clearSession();
        sessionInvalidated.value =
            body['error'] as String? ??
            'Votre compte a été connecté sur un autre appareil.';
        return true;
      }
    } catch (_) {}
    return false;
  }

  // ── Token ──────────────────────────────────────────────────────────────────

  static Future<String?> getToken() async {
    return _secure.read(key: _tokenKey);
  }

  static Future<void> saveToken(String token) async {
    await _secure.write(key: _tokenKey, value: token);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── User cache ─────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> getCachedUser() async {
    final raw = await _secure.read(key: _userKey);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> _saveUser(Map<String, dynamic> user) async {
    await _secure.write(key: _userKey, value: jsonEncode(user));
  }

  /// Met à jour le cache utilisateur (appelé après refresh depuis le serveur).
  static Future<void> cacheUser(Map<String, dynamic> user) => _saveUser(user);

  // ── Session ────────────────────────────────────────────────────────────────

  static Future<void> clearSession() async {
    await _secure.delete(key: _tokenKey);
    await _secure.delete(key: _userKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fitai_profile');
    await prefs.remove('fitai_meals');
    await prefs.remove('fitai_body_entries');
    await prefs.remove('fitai_planning');
    await prefs.remove('fitai_dishes');
    await prefs.remove('dv_gate_offer_start');
    // Note: fitai_first_open_done, dv_consent_* et fitai_currency sont conservés
    // car ils sont liés à l'appareil, pas à l'utilisateur.
  }

  // ── Auth calls ─────────────────────────────────────────────────────────────

  static Future<AuthResult> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email.trim(), 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final token = data['token'] as String;
        final user  = data['user'] as Map<String, dynamic>;
        await saveToken(token);
        await _saveUser(user);
        return AuthResult(success: true, token: token, user: user);
      } else {
        // Code stable → l'UI affiche un message localisé (langue de l'app)
        return const AuthResult(success: false, error: 'INVALID_CREDENTIALS');
      }
    } catch (_) {
      return const AuthResult(success: false, error: 'SERVER_UNREACHABLE');
    }
  }

  static Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? country,
    String? age,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name':     name.trim(),
              'email':    email.trim(),
              'password': password,
              if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
              'country':  country,
              if (age != null && age.trim().isNotEmpty) 'age': int.tryParse(age.trim()),
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        final token = data['token'] as String;
        final user  = data['user'] as Map<String, dynamic>;
        await saveToken(token);
        await _saveUser(user);
        return AuthResult(success: true, token: token, user: user);
      } else {
        final error = data['error'] ?? data['message'] ?? 'Error creating account';
        return AuthResult(success: false, error: error.toString());
      }
    } catch (_) {
      return const AuthResult(
          success: false, error: 'SERVER_UNREACHABLE');
    }
  }

  // ── Email verification ─────────────────────────────────────────────────────

  /// Demande l'envoi d'un nouveau code de vérification à [email].
  static Future<AuthResult> sendVerificationCode(String email) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/auth/send_verification'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email.trim()}),
          )
          .timeout(const Duration(seconds: 15));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        return AuthResult(success: true, error: null);
      } else if (res.statusCode == 429) {
        return AuthResult(success: false, error: data['error'] ?? 'Please wait before resending');
      } else {
        return AuthResult(success: false, error: data['error'] ?? 'Error sending code');
      }
    } catch (_) {
      return const AuthResult(success: false, error: 'SERVER_UNREACHABLE');
    }
  }

  /// Vérifie le code [code] pour l'adresse [email].
  /// Retourne success:true + user mis à jour si ok.
  static Future<AuthResult> verifyEmail(String email, String code) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/auth/verify_email'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email.trim(), 'code': code.trim()}),
          )
          .timeout(const Duration(seconds: 15));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        final user = data['user'] as Map<String, dynamic>?;
        if (user != null) await _saveUser(user);
        return AuthResult(success: true, user: user);
      } else {
        return AuthResult(success: false, error: data['error'] ?? 'Invalid code');
      }
    } catch (_) {
      return const AuthResult(success: false, error: 'SERVER_UNREACHABLE');
    }
  }

  // ── Password reset ─────────────────────────────────────────────────────────

  /// Demande l'envoi d'un code de réinitialisation à [email].
  static Future<AuthResult> forgotPassword(String email) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/auth/forgot_password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email.trim()}),
          )
          .timeout(const Duration(seconds: 15));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        return AuthResult(success: true, error: null);
      } else if (res.statusCode == 429) {
        return AuthResult(success: false, error: data['error'] ?? 'Please wait');
      } else {
        return AuthResult(success: false, error: data['error'] ?? 'Error sending code');
      }
    } catch (_) {
      return const AuthResult(success: false, error: 'SERVER_UNREACHABLE');
    }
  }

  /// Réinitialise le mot de passe avec le code reçu par email.
  static Future<AuthResult> resetPassword(String email, String token, String newPassword) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/auth/reset_password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email':    email.trim(),
              'token':    token.trim(),
              'password': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 15));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        return AuthResult(success: true, error: null);
      } else {
        return AuthResult(success: false, error: data['error'] ?? 'Invalid or expired code');
      }
    } catch (_) {
      return const AuthResult(success: false, error: 'SERVER_UNREACHABLE');
    }
  }

  // ── Social login ───────────────────────────────────────────────────────────

  /// Authentification via fournisseur social (google | facebook | apple).
  /// [provider] : "google" | "facebook" | "apple"
  /// [token]    : idToken (Google/Apple) ou accessToken (Facebook)
  static Future<AuthResult> socialLogin({
    required String provider,
    required String token,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/social'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'provider': provider, 'token': token}),
          )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final jwtToken = data['token'] as String;
        final user     = data['user'] as Map<String, dynamic>;
        await saveToken(jwtToken);
        await _saveUser(user);
        return AuthResult(success: true, token: jwtToken, user: user);
      } else {
        final error = data['error'] ?? data['message'] ?? 'Social auth failed';
        return AuthResult(success: false, error: error.toString());
      }
    } catch (_) {
      return const AuthResult(success: false, error: 'SERVER_UNREACHABLE');
    }
  }

  /// Appel API de logout : invalide le session_token côté serveur.
  static Future<void> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        await http
            .delete(
              Uri.parse('$baseUrl/auth/logout'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 10));
      }
    } catch (_) {
      // On déconnecte localement même si le serveur est injoignable
    } finally {
      await clearSession();
    }
  }

  // ── Auth headers helper ────────────────────────────────────────────────────

  static Future<Map<String, String>> authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
