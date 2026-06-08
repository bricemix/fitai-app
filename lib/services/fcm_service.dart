import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import 'auth_service.dart';

/// Handler des messages reçus quand l'app est en arrière-plan / tuée.
/// Doit être une fonction top-level annotée vm:entry-point.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Les notifications de type "notification" sont affichées automatiquement par
  // le système dans la barre de statut. Rien à faire ici pour l'affichage.
}

/// Service de notifications push distantes (Firebase Cloud Messaging).
class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'dietvision_push';
  static const String _channelName = 'Notifications DietVision';

  static bool _appInitialized = false;

  /// À appeler au démarrage de l'app (dans main, avant runApp).
  static Future<void> initApp() async {
    if (_appInitialized) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    _appInitialized = true;
  }

  /// À appeler quand l'utilisateur est authentifié (login / démarrage connecté).
  /// Demande la permission, récupère le token FCM et l'envoie au backend.
  static Future<void> registerDevice() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true, badge: true, sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      // iOS : s'assurer que l'APNs token est prêt avant getToken (no-op Android)
      if (Platform.isIOS) {
        await _messaging.getAPNSToken();
      }

      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await _sendTokenToBackend(token);
      }

      // Token renouvelé → on resynchronise avec le backend
      _messaging.onTokenRefresh.listen(_sendTokenToBackend);

      // Messages reçus app au premier plan → affichage local
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    } catch (_) {
      // Ne jamais bloquer l'app pour une erreur de notif
    }
  }

  /// Envoie / met à jour le token de l'appareil côté serveur.
  static Future<void> _sendTokenToBackend(String token) async {
    try {
      final headers = await AuthService.authHeaders();
      await http
          .post(
            Uri.parse('${AuthService.baseUrl}/device_tokens'),
            headers: headers,
            body: jsonEncode({
              'token': token,
              'platform': Platform.isIOS ? 'ios' : 'android',
            }),
          )
          .timeout(const Duration(seconds: 15));
    } catch (_) {
      // silencieux : sera retenté au prochain onTokenRefresh / démarrage
    }
  }

  /// Supprime le token côté serveur (à appeler à la déconnexion).
  static Future<void> unregisterDevice() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;
      final headers = await AuthService.authHeaders();
      await http
          .delete(
            Uri.parse('${AuthService.baseUrl}/device_tokens'),
            headers: headers,
            body: jsonEncode({'token': token}),
          )
          .timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  /// Affiche une notification locale quand un push arrive app au premier plan
  /// (Android n'affiche pas automatiquement les notifs en foreground).
  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notif = message.notification;
    if (notif == null) return;
    const androidDetails = AndroidNotificationDetails(
      _channelId, _channelName,
      channelDescription: 'Notifications push DietVision',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    await _local.show(
      notif.hashCode,
      notif.title,
      notif.body,
      const NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
