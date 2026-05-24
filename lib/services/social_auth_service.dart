import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SocialAuthResult — résultat d'une authentification sociale
// ─────────────────────────────────────────────────────────────────────────────
class SocialAuthResult {
  final bool success;
  final String? provider;  // "google" | "facebook" | "apple"
  final String? token;
  final String? name;
  final String? email;
  final String? error;

  const SocialAuthResult({
    required this.success,
    this.provider,
    this.token,
    this.name,
    this.email,
    this.error,
  });

  const SocialAuthResult.cancelled()
      : success = false,
        provider = null,
        token = null,
        name = null,
        email = null,
        error = 'cancelled';

  const SocialAuthResult.error(String msg)
      : success = false,
        provider = null,
        token = null,
        name = null,
        email = null,
        error = msg;
}

// ─────────────────────────────────────────────────────────────────────────────
// SocialAuthService
// ─────────────────────────────────────────────────────────────────────────────
class SocialAuthService {
  // ── CONFIGURATION ─────────────────────────────────────────────────────────
  // Renseigner ces valeurs depuis vos dashboards développeurs :
  // Google : https://console.cloud.google.com/ → APIs & Services → Credentials
  // Facebook: https://developers.facebook.com/ → My Apps → Your App
  // Apple   : https://developer.apple.com/ → Certificates, Identifiers & Profiles

  /// Web Client ID Google (OAuth 2.0 → Web application)
  /// → Remplacer par votre vrai ID sur https://console.cloud.google.com/
  static const _googleWebClientId =
      'VOTRE_WEB_CLIENT_ID.apps.googleusercontent.com';

  static bool get _googleConfigured =>
      !_googleWebClientId.startsWith('VOTRE_');

  // ── Google ─────────────────────────────────────────────────────────────────

  static final _googleSignIn = GoogleSignIn(
    serverClientId: _googleWebClientId,
    scopes: ['email', 'profile'],
  );

  static Future<SocialAuthResult> signInWithGoogle() async {
    if (!_googleConfigured) {
      return const SocialAuthResult.error(
        'Google Sign-In non configuré.\n'
        'Ajoutez votre Web Client ID dans social_auth_service.dart',
      );
    }
    try {
      // Force le sélecteur de compte à chaque fois
      await _googleSignIn.signOut();
      final account = await _googleSignIn.signIn();

      if (account == null) return const SocialAuthResult.cancelled();

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        return const SocialAuthResult.error(
          'Google: impossible d\'obtenir le token. '
          'Vérifiez votre Web Client ID.',
        );
      }

      return SocialAuthResult(
        success: true,
        provider: 'google',
        token: idToken,
        name: account.displayName ?? '',
        email: account.email,
      );
    } catch (e) {
      if (e.toString().contains('sign_in_canceled') ||
          e.toString().contains('network_error')) {
        return const SocialAuthResult.cancelled();
      }
      debugPrint('Google Sign-In error: $e');
      return SocialAuthResult.error('Google: ${e.toString()}');
    }
  }

  // ── Facebook ───────────────────────────────────────────────────────────────

  static Future<SocialAuthResult> signInWithFacebook() async {
    try {
      await FacebookAuth.instance.logOut();
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.cancelled) {
        return const SocialAuthResult.cancelled();
      }
      if (result.status != LoginStatus.success) {
        return SocialAuthResult.error(
          'Facebook: ${result.message ?? 'Connexion échouée'}',
        );
      }

      final accessToken = result.accessToken?.tokenString;
      if (accessToken == null) {
        return const SocialAuthResult.error('Facebook: pas de token');
      }

      // Récupérer les données utilisateur
      final userData = await FacebookAuth.instance.getUserData(
        fields: 'name,email',
      );

      return SocialAuthResult(
        success: true,
        provider: 'facebook',
        token: accessToken,
        name: userData['name'] as String? ?? '',
        email: userData['email'] as String? ?? '',
      );
    } catch (e) {
      debugPrint('Facebook Sign-In error: $e');
      return SocialAuthResult.error('Facebook: ${e.toString()}');
    }
  }

  // ── Apple ──────────────────────────────────────────────────────────────────
  // Sign in with Apple n'est disponible que sur iOS/macOS.

  static bool get isAppleAvailable => Platform.isIOS || Platform.isMacOS;

  static Future<SocialAuthResult> signInWithApple() async {
    if (!isAppleAvailable) {
      return const SocialAuthResult.error(
        'Sign in with Apple n\'est disponible que sur iOS',
      );
    }
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null) {
        return const SocialAuthResult.error('Apple: pas d\'identity token');
      }

      // Apple ne retourne le nom qu'à la première connexion
      final name = [
        credential.givenName,
        credential.familyName,
      ].where((s) => s != null && s.isNotEmpty).join(' ');

      return SocialAuthResult(
        success: true,
        provider: 'apple',
        token: identityToken,
        name: name.isNotEmpty ? name : null,
        email: credential.email ?? '',
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return const SocialAuthResult.cancelled();
      }
      return SocialAuthResult.error('Apple: ${e.message}');
    } catch (e) {
      debugPrint('Apple Sign-In error: $e');
      return SocialAuthResult.error('Apple: ${e.toString()}');
    }
  }
}
