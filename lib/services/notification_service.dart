import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _channelId   = 'dietvision_daily';
  static const _channelName = 'Encouragements quotidiens';

  static const _messages = [
    'Chaque repas sain est un pas vers ton objectif !',
    'Tu es plus fort(e) que tu ne le penses. Continue !',
    'N\'oublie pas de logger ton repas d\'aujourd\'hui.',
    'Hydrate-toi ! 2L d\'eau par jour minimum.',
    'Un petit effort aujourd\'hui, un grand résultat demain.',
    'Bravo pour hier ! Garde ce rythme aujourd\'hui.',
    'Ton corps te remercie pour chaque bon repas.',
    'Pense à tes mesures de la semaine !',
    'La régularité bat l\'intensité. Tu es sur la bonne voie.',
    'Scan ton prochain repas pour rester dans ton objectif.',
    'Tu fais déjà partie des meilleurs ! Continue ainsi.',
    'La nutrition, c\'est 80% du résultat. Tu y es !',
    'Rappel : log ton dîner ce soir pour suivre tes macros.',
    'Objectif du jour : atteindre ton quota de protéines !',
    'Belle journée pour un repas équilibré. Tu gères !',
  ];

  static Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios     = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  /// Demander la permission (Android 13+)
  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    return true;
  }

  /// Programmer une notification quotidienne à une heure donnée
  static Future<void> scheduleDailyMotivation({int hour = 8, int minute = 0}) async {
    await init();

    const androidDetails = AndroidNotificationDetails(
      _channelId, _channelName,
      channelDescription: 'Messages d\'encouragement quotidiens',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Annuler l'ancienne
    await _plugin.cancel(1);

    // Programmer la nouvelle
    final now  = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final msgIndex = scheduled.day % _messages.length;

    await _plugin.zonedSchedule(
      1,
      'DietVision',
      _messages[msgIndex],
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // répète chaque jour
    );
  }

  /// Notification immédiate (test ou événement)
  static Future<void> showNow(String title, String body) async {
    await init();
    const androidDetails = AndroidNotificationDetails(
      _channelId, _channelName,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    await _plugin.show(0, title, body,
        const NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails()));
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── Notifications trial ───────────────────────────────────────────────────────

  static const _channelIdTrial   = 'dietvision_trial';
  static const _channelNameTrial = 'Rappels abonnement';

  static const _trialNotifJ7Id = 10;
  static const _trialNotifJ3Id = 11;
  static const _trialNotifJ1Id = 12;

  static const _trialNotifications = [
    (id: _trialNotifJ7Id, daysBefore: 7,  title: 'Encore 7 jours d\'essai',   body: 'Profitez-en encore 7 jours — ensuite choisissez le plan qui vous convient.'),
    (id: _trialNotifJ3Id, daysBefore: 3,  title: 'Plus que 3 jours !',         body: 'Offre spéciale : -40% sur l\'abonnement annuel. À saisir maintenant !'),
    (id: _trialNotifJ1Id, daysBefore: 1,  title: 'Dernier jour d\'essai 🔔',   body: 'Votre essai expire demain. Ne perdez pas votre progression !'),
  ];

  /// Programme les 3 notifications de rappel avant expiration du trial.
  static Future<void> scheduleTrialExpiryNotifications(DateTime trialEndsAt) async {
    await init();

    const androidDetails = AndroidNotificationDetails(
      _channelIdTrial, _channelNameTrial,
      channelDescription: 'Rappels avant expiration de l\'essai',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    for (final notif in _trialNotifications) {
      final scheduledDate = trialEndsAt.subtract(Duration(days: notif.daysBefore));
      // On ne programme que si la date est dans le futur
      if (scheduledDate.isAfter(DateTime.now())) {
        final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
        await _plugin.zonedSchedule(
          notif.id,
          notif.title,
          notif.body,
          tzDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  /// Annule les 3 notifications de rappel trial.
  static Future<void> cancelTrialNotifications() async {
    await _plugin.cancel(_trialNotifJ7Id);
    await _plugin.cancel(_trialNotifJ3Id);
    await _plugin.cancel(_trialNotifJ1Id);
  }
}
