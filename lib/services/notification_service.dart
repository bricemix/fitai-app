import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _channelId   = 'dietvision_daily';
  static const _channelName = 'Daily encouragements';

  // ── Messages par langue ───────────────────────────────────────────────────────

  static const _messagesFr = [
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

  static const _messagesEn = [
    'Every healthy meal is a step toward your goal!',
    'You are stronger than you think. Keep going!',
    'Don\'t forget to log today\'s meal.',
    'Stay hydrated! At least 2L of water per day.',
    'Small effort today, big results tomorrow.',
    'Great job yesterday! Keep that pace today.',
    'Your body thanks you for every good meal.',
    'Remember to take your weekly measurements!',
    'Consistency beats intensity. You\'re on the right track.',
    'Scan your next meal to stay on target.',
    'You\'re already among the best! Keep it up.',
    'Nutrition is 80% of the result. You\'ve got this!',
    'Reminder: log your dinner tonight to track your macros.',
    'Goal for today: hit your protein quota!',
    'Great day for a balanced meal. You\'ve got this!',
  ];

  static const _messagesDe = [
    'Jede gesunde Mahlzeit ist ein Schritt zu deinem Ziel!',
    'Du bist stärker, als du denkst. Weiter so!',
    'Vergiss nicht, deine heutige Mahlzeit zu protokollieren.',
    'Bleib hydratisiert! Mindestens 2L Wasser pro Tag.',
    'Kleine Anstrengung heute, große Ergebnisse morgen.',
    'Super gestern! Behalte dieses Tempo heute bei.',
    'Dein Körper dankt dir für jede gute Mahlzeit.',
    'Denk an deine Wochenmessungen!',
    'Beständigkeit schlägt Intensität. Du bist auf dem richtigen Weg.',
    'Scanne deine nächste Mahlzeit, um auf Kurs zu bleiben.',
    'Du gehörst schon zu den Besten! Mach weiter so.',
    'Ernährung ist 80% des Ergebnisses. Du schaffst das!',
    'Erinnerung: Protokolliere heute Abend dein Abendessen.',
    'Ziel für heute: dein Proteinziel erreichen!',
    'Toller Tag für eine ausgewogene Mahlzeit. Du schaffst das!',
  ];

  static const _messagesEs = [
    'Cada comida saludable es un paso hacia tu objetivo.',
    'Eres mas fuerte de lo que crees. Sigue adelante!',
    'No olvides registrar tu comida de hoy.',
    'Mantente hidratado! Al menos 2L de agua al dia.',
    'Pequeno esfuerzo hoy, grandes resultados manana.',
    'Excelente ayer! Mantien ese ritmo hoy.',
    'Tu cuerpo te agradece cada buena comida.',
    'Recuerda tomar tus medidas de la semana!',
    'La constancia supera a la intensidad. Vas por buen camino.',
    'Escanea tu proxima comida para mantenerte en el objetivo.',
    'Ya eres de los mejores! Sigue asi.',
    'La nutricion es el 80% del resultado. Lo tienes!',
    'Recuerda: registra tu cena esta noche para seguir tus macros.',
    'Objetivo del dia: alcanzar tu cuota de proteinas!',
    'Gran dia para una comida equilibrada. Lo tienes!',
  ];

  static const _messagesPt = [
    'Cada refeicao saudavel e um passo rumo ao seu objetivo!',
    'Voce e mais forte do que pensa. Continue!',
    'Nao esqueca de registrar sua refeicao de hoje.',
    'Mantenha-se hidratado! Pelo menos 2L de agua por dia.',
    'Pequeno esforco hoje, grandes resultados amanha.',
    'Otimo ontem! Mantenha esse ritmo hoje.',
    'Seu corpo agradece por cada boa refeicao.',
    'Lembre-se de fazer suas medicoes semanais!',
    'Consistencia supera intensidade. Voce esta no caminho certo.',
    'Escaneie sua proxima refeicao para manter o objetivo.',
    'Voce ja esta entre os melhores! Continue assim.',
    'A nutricao e 80% do resultado. Voce consegue!',
    'Lembrete: registre seu jantar hoje a noite para acompanhar as macros.',
    'Objetivo do dia: atingir sua cota de proteinas!',
    'Otimo dia para uma refeicao equilibrada. Voce consegue!',
  ];

  static List<String> _messagesForLocale(String locale) {
    switch (locale) {
      case 'en': return _messagesEn;
      case 'de': return _messagesDe;
      case 'es': return _messagesEs;
      case 'pt': return _messagesPt;
      default:   return _messagesFr;
    }
  }

  // ── Textes notifications trial par langue ────────────────────────────────────

  static Map<String, List<(int id, int daysBefore, String title, String body)>>
      _trialNotifsByLocale = {
    'fr': [
      (_trialNotifJ7Id, 7, 'Encore 7 jours d\'essai',  'Profitez-en encore 7 jours — ensuite choisissez le plan qui vous convient.'),
      (_trialNotifJ3Id, 3, 'Plus que 3 jours !',        'Offre spéciale : -40% sur l\'abonnement annuel. À saisir maintenant !'),
      (_trialNotifJ1Id, 1, 'Dernier jour d\'essai 🔔',  'Votre essai expire demain. Ne perdez pas votre progression !'),
    ],
    'en': [
      (_trialNotifJ7Id, 7, '7 days left in your trial', 'Make the most of your 7 remaining days — then choose the plan that fits you.'),
      (_trialNotifJ3Id, 3, 'Only 3 days left!',         'Special offer: -40% on the annual plan. Grab it now!'),
      (_trialNotifJ1Id, 1, 'Last trial day 🔔',          'Your trial expires tomorrow. Don\'t lose your progress!'),
    ],
    'de': [
      (_trialNotifJ7Id, 7, 'Noch 7 Testtage',           'Nutze die verbleibenden 7 Tage – dann wähle den passenden Plan.'),
      (_trialNotifJ3Id, 3, 'Noch 3 Tage!',              'Sonderangebot: -40% auf das Jahresabo. Jetzt zugreifen!'),
      (_trialNotifJ1Id, 1, 'Letzter Testtag 🔔',         'Dein Test läuft morgen ab. Verliere deinen Fortschritt nicht!'),
    ],
    'es': [
      (_trialNotifJ7Id, 7, 'Quedan 7 dias de prueba',   'Aprovecha los 7 dias restantes y luego elige el plan que mejor te convenga.'),
      (_trialNotifJ3Id, 3, 'Solo quedan 3 dias!',        'Oferta especial: -40% en el plan anual. Aprovechala ahora!'),
      (_trialNotifJ1Id, 1, 'Ultimo dia de prueba 🔔',    'Tu prueba expira manana. No pierdas tu progreso!'),
    ],
    'pt': [
      (_trialNotifJ7Id, 7, 'Ainda 7 dias de teste',     'Aproveite os 7 dias restantes e escolha o plano ideal para voce.'),
      (_trialNotifJ3Id, 3, 'Restam apenas 3 dias!',      'Oferta especial: -40% no plano anual. Aproveite agora!'),
      (_trialNotifJ1Id, 1, 'Ultimo dia de teste 🔔',     'Seu teste expira amanha. Nao perca seu progresso!'),
    ],
  };

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

  /// Retourne la locale sauvegardée (ou 'fr' par défaut).
  static Future<String> _getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('locale') ?? 'fr';
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
    final locale   = await _getLocale();
    final messages = _messagesForLocale(locale);

    const androidDetails = AndroidNotificationDetails(
      _channelId, _channelName,
      channelDescription: 'Daily motivation messages',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.cancel(1);

    final now  = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final msgIndex = scheduled.day % messages.length;

    await _plugin.zonedSchedule(
      1,
      'DietVision',
      messages[msgIndex],
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
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
  static const _channelNameTrial = 'Subscription reminders';

  static const _trialNotifJ7Id = 10;
  static const _trialNotifJ3Id = 11;
  static const _trialNotifJ1Id = 12;

  /// Programme les 3 notifications de rappel avant expiration du trial (localisées).
  static Future<void> scheduleTrialExpiryNotifications(DateTime trialEndsAt) async {
    await init();
    final locale    = await _getLocale();
    final notifList = _trialNotifsByLocale[locale] ?? _trialNotifsByLocale['fr']!;

    const androidDetails = AndroidNotificationDetails(
      _channelIdTrial, _channelNameTrial,
      channelDescription: 'Reminders before trial expiry',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    for (final notif in notifList) {
      final (id, daysBefore, title, body) = notif;
      final scheduledDate = trialEndsAt.subtract(Duration(days: daysBefore));
      if (scheduledDate.isAfter(DateTime.now())) {
        final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
        await _plugin.zonedSchedule(
          id,
          title,
          body,
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
