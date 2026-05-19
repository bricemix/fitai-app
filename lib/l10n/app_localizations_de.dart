import 'app_localizations.dart';



class AppLocalizationsDe extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Startseite';

  @override String get navScan => 'Scannen';

  @override String get navCoach => 'KI-Coach';

  @override String get navProgress => 'Fortschritt';

  @override String get navProfile => 'Profil';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Dein KI-Ernährungscoach';

  @override String get sessionExpired => 'Sitzung beendet';

  @override String get reconnect => 'Erneut anmelden';

  @override String get cancel => 'Abbrechen';

  @override String get confirm => 'Bestätigen';

  @override String get save => 'Speichern';

  @override String get retry => 'Erneut versuchen';

  @override String get loading => 'Laden…';

  @override String get error => 'Fehler';

  @override String get later => 'Später';

  @override String get quit => 'Beenden';

  @override String get close => 'Schließen';

  @override String get back => 'Zurück';

  @override String get refresh => 'Aktualisieren';

  @override String get next => 'Weiter';

  @override String get skip => 'Überspringen';

  @override String get accept => 'Akzeptieren';

  @override String get refuse => 'Ablehnen';

  @override String get yes => 'Ja';

  @override String get no => 'Nein';

  @override String get optional => 'Optional';

  @override String get recommended => 'Empfohlen';

  @override String get popular => 'Beliebt';



  // ── Auth ────────────────────────────────────────────────────────────────────

  @override String get signIn => 'Anmelden';

  @override String get createAccount => 'Konto erstellen';

  @override String get email => 'E-Mail';

  @override String get emailHint => 'deine@email.de';

  @override String get emailRequired => 'E-Mail erforderlich';

  @override String get emailInvalid => 'Ungültige E-Mail-Adresse';

  @override String get password => 'Passwort';

  @override String get passwordHint => '••••••••';

  @override String get passwordRequired => 'Passwort erforderlich';

  @override String get passwordMin8 => 'Mindestens 8 Zeichen';

  @override String get confirmPassword => 'Passwort bestätigen';

  @override String get passwordMismatch => 'Passwörter stimmen nicht überein';

  @override String get firstName => 'Vor- / Nachname';

  @override String get firstNameHint => 'Max Mustermann';

  @override String get firstNameRequired => 'Name erforderlich (min. 2 Zeichen)';

  @override String get phone => 'Telefon (optional)';

  @override String get phoneHint => '+49 151 00 000 000';

  @override String get country => 'Land';

  @override String get chooseCountry => 'Land wählen';

  @override String get searchCountry => 'Land suchen…';

  @override String get currency => 'Bevorzugte Währung';

  @override String get chooseCurrency => 'Währung wählen';

  @override String get searchCurrency => 'Suchen — EUR, Dollar, Franc…';

  @override String get loginButton => 'Anmelden';

  @override String get registerButton => 'Mein Konto erstellen';

  @override String get mustAcceptPrivacy => 'Bitte akzeptieren Sie die Datenschutzrichtlinie';

  @override String get iAcceptThe => 'Ich akzeptiere die ';

  @override String get privacyPolicyLink => 'Datenschutzrichtlinie und AGB';

  @override String get verifyEmailTitle => 'E-Mail bestätigen';

  @override String get verifyEmailDesc => 'Wir haben einen 6-stelligen Code gesendet an';

  @override String get verifyCode => 'Code bestätigen';

  @override String get resendCode => 'Code erneut senden';

  @override String get skipForNow => 'Zurück';

  @override String get checkSpam => 'Prüfen Sie auch Ihren Spam-Ordner, falls Sie die E-Mail nicht sehen.';



  // ── Dashboard ───────────────────────────────────────────────────────────────

  @override String helloUser(String name) => 'Hallo, $name';

  @override String get today => 'Heute';

  @override String get goal => 'Ziel';

  @override String get planning => 'Plan';

  @override String get kcalPerDay => 'kcal / Tag';

  @override String get progression => 'Fortschritt';

  @override String get last7Days => 'Letzte 7 Tage';

  @override String get todayMeals => 'Heutige Mahlzeiten';

  @override String get noMealsToday => 'Heute noch keine Mahlzeit erfasst.\nScanne deine nächste Mahlzeit!';

  @override String get missingMeasurements => 'Heutige Messungen fehlen';

  @override String get bodyMeasurementsHint => 'Gewicht, Taille, Bizeps…';

  @override String get measurementsDoneToday => 'Messungen heute eingetragen';

  @override String get proteins => 'Proteine';

  @override String get carbs => 'Kohlenhydrate';

  @override String get fats => 'Fette';



  // ── Scan ────────────────────────────────────────────────────────────────────

  @override String get analyzeMeal => 'Mahlzeit analysieren';

  @override String get scanSubtitle => 'Mach ein Foto deiner Mahlzeit für eine vollständige Nährwertanalyse';

  @override String get loginRequired => 'Anmeldung erforderlich — bitte melde dich an';

  @override String get mealSaved => 'Mahlzeit gespeichert';

  @override String get takePhoto => 'Foto aufnehmen';

  @override String get chooseGallery => 'Aus Galerie wählen';

  @override String get addPhoto => 'Foto hinzufügen';

  @override String get photoHint => 'Mach oder importiere ein Foto deiner Mahlzeit';

  @override String get adjustPortion => 'Portion anpassen';

  @override String get precisions => 'Details (optional)';

  @override String get precisionsHint => 'Beschreibe deine Mahlzeit für eine bessere Analyse';

  @override String get precisionsPlaceholder => 'Z. B. gegrilltes Hühnchen mit weißem Reis und Gemüse…';

  @override String get analyzing => 'Analyse läuft…';

  @override String get aiIdentification => 'KI-Identifikation';

  @override String portionEstimated(int grams) => 'Geschätzte Portion: $grams g';

  @override String get healthScore => 'Gesundheitsbewertung';

  @override String get micronutrients => 'Mikronährstoffe';

  @override String get tip => 'Tipp';

  @override String get iWillEat => 'Ich werde essen';

  @override String get reanalyze => 'Erneut analysieren';

  @override String get newPhoto => 'Neues Foto';

  @override String get confirmEat => 'Verzehr bestätigen?';

  @override String get confirmEatButton => 'Ja, das habe ich gegessen';

  @override String get fibers => 'Ballaststoffe';

  @override String get entirePlate => 'Ganzer Teller';

  @override String get halfPortion => 'Halbe Portion';



  // ── Coach ───────────────────────────────────────────────────────────────────

  @override String get coachTitle => 'KI-Coach';

  @override String get coachSubtitle => 'Dein persönlicher Ernährungsassistent';

  @override String get chatTab => 'Chat';

  @override String get dishesTab => 'Gerichte';

  @override String get planningTab => 'Planung';

  @override String planningRequired(String plan) => '$plan-Plan erforderlich';

  @override String get whatYouGet => 'Was du bekommst';

  @override String get aiDishes => 'Personalisierte KI-Gerichte';

  @override String get personalizedRecipes => 'Rezepte angepasst an dein Profil und deine Ernährung';

  @override String get dietOptions9 => '9 Ernährungsoptionen verfügbar';

  @override String get exactIngredients => 'Gewogene Zutaten & berechnete Makros';

  @override String get dailyUpdate => 'Täglich aktualisiert';

  @override String get planningTitle => 'Ernährungsplan';

  @override String get planningDescription => 'Ein KI-generierter 7-Tage-Plan nach deinem Ziel';

  @override String get caloricTarget => 'Kalorienziel';

  @override String get adaptedToGoal => 'An dein Ziel angepasst';

  @override String get dailyTips => 'Tägliche Tipps';

  @override String upgradePlan(String plan) => 'Auf $plan upgraden';

  @override String get continueFreePlan => 'Mit kostenlosem Plan fortfahren';

  @override String get dietRegime => 'Ernährungstyp';

  @override String generateRegime(String diet) => '$diet-Gerichte generieren';

  @override String generatingRegime(String diet) => '$diet-Gerichte werden generiert…';

  @override String get aiAdaptation => 'KI-Anpassung';

  @override String get ingredients => 'Zutaten';

  @override String get breakfast => 'Frühstück';

  @override String get lunch => 'Mittagessen';

  @override String get dinner => 'Abendessen';

  @override String get weekPlanning => 'Wochenplan';

  @override String get generatingPlanning => 'Plan wird generiert…';

  @override String get dayDetail => 'Tagesdetails';

  @override String get regenerate => 'Neu generieren';

  @override String get noPlanning => 'Kein Plan generiert';

  @override String get pressToRegenerate => 'Tippe, um deinen Plan zu generieren';

  @override String todayKcalInfo(int kcal, int remaining) => '$kcal kcal heute · $remaining übrig';

  @override String get noMessagesYet => 'Noch keine Nachrichten';

  @override String get typingMessage => 'Nachricht eingeben…';

  @override String coachWelcome(String name) => 'Hallo $name! Ich bin dein KI-Ernährungscoach. Wie kann ich dir helfen?';



  // ── Settings ────────────────────────────────────────────────────────────────

  @override String get myAccount => 'Mein Konto';

  @override String get logout => 'Abmelden';

  @override String get logoutConfirm => 'Möchtest du dich wirklich abmelden?';

  @override String get logoutCancel => 'Abbrechen';

  @override String get logoutConfirmButton => 'Abmelden';

  @override String get userLabel => 'Benutzer';

  @override String get information => 'Informationen';

  @override String get name => 'Name';

  @override String get emailLabel => 'E-Mail';

  @override String get phoneLabel => 'Telefon';

  @override String get countryLabel => 'Land';

  @override String get subscription => 'Abonnement';

  @override String get freeLabel => 'Kostenlos';

  @override String get loggingOut => 'Abmelden…';

  @override String get language => 'Sprache';

  @override String get chooseLanguage => 'Sprache wählen';



  // ── Profile ─────────────────────────────────────────────────────────────────

  @override String get myProfile => 'Mein Profil';

  @override String get bmi => 'BMI';

  @override String get bmiUnderweight => 'Untergewicht';

  @override String get bmiNormal => 'Normal';

  @override String get bmiOverweight => 'Übergewicht';

  @override String get bmiObese => 'Fettleibigkeit';

  @override String get objective => 'Ziel';

  @override String kcalPerDayValue(int v) => '$v kcal/Tag';

  @override String get identity => 'Identität';

  @override String get gender => 'Geschlecht';

  @override String get male => 'Männlich';

  @override String get female => 'Weiblich';

  @override String get age => 'Alter';

  @override String get weight => 'Gewicht (kg)';

  @override String get height => 'Größe (cm)';

  @override String get bodyMeasurements => 'Körpermaße';

  @override String get bodyMeasurementsHintProfile => 'Optional — um deinen Fortschritt zu verfolgen';

  @override String get waist => 'Taillenumfang (cm)';

  @override String get biceps => 'Bizeps (cm)';

  @override String get belly => 'Bauchumfang (cm)';

  @override String get weightGoal => 'Ziel';

  @override String get loseWeight => 'Abnehmen';

  @override String get gainMass => 'Muskeln aufbauen';

  @override String get maintain => 'Gewicht halten';

  @override String get eatHealthy => 'Gesund ernähren';

  @override String get lossRhythm => 'Abnehmtempo';

  @override String get gainRhythm => 'Zunahmetempo';

  @override String get soft => 'Sanft';

  @override String get moderate => 'Moderat';

  @override String get sustained => 'Konsequent';

  @override String get intense => 'Intensiv';

  @override String get lean => 'Lean';

  @override String get aggressive => 'Aggressiv';

  @override String get aggressiveWarning => 'Aggressives Tempo — kann zu Muskelverlust führen. Konsultiere einen Fachmann.';

  @override String get activityLevel => 'Aktivitätslevel';

  @override String get saveProfile => 'Profil speichern';

  @override String get goPremium => 'Premium werden';

  @override String get appInfo => 'App-Informationen';

  @override String get version => 'Version';



  // ── Onboarding ──────────────────────────────────────────────────────────────

  @override String get configureProfile => 'Mein Profil einrichten →';

  @override String get profileTitle => 'Dein Profil';

  @override String get profileSubtitle => 'Diese Informationen werden zur Berechnung deines Kalorienbedarfs verwendet.';

  @override String get yourFirstName => 'Dein Vorname';

  @override String get firstNameEx => 'Z. B.: Marie';

  @override String get genderLabel => 'Geschlecht';

  @override String get goalLabel => 'Dein Ziel';

  @override String get goalQuestion => 'Was ist dein Hauptziel?';

  @override String get rhythmLabel => 'Gewünschtes Tempo (kg/Woche)';

  @override String get bodyMeasurementsLabel => 'Körpermaße (optional)';

  @override String get activityDiet => 'Aktivität & Ernährung';

  @override String get activityLevelLabel => 'Aktivitätslevel';

  @override String get dietLabel => 'Ernährungspräferenzen (optional)';

  @override String get welcome => 'Willkommen bei DietVision';

  @override String get welcomeSubtitle => "Dein KI-gestützter Ernährungs- & Fitness-Coach.\nAnalysiere deine Mahlzeiten, verfolge deine Makros und erreiche deine Ziele.";

  @override String get createProfile => 'Mein Profil erstellen';

  @override String get continueButton => 'Weiter →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Erreiche deine Ziele\nschneller mit Premium';

  @override String get paywallSubtitle => "Alles, was du brauchst, in einer App.";

  @override String get choosePlan => 'Wähle deinen Plan';

  @override String get unlimitedScan => 'Unbegrenzte KI-Scans';

  @override String get featureSubScan => 'Jede Mahlzeit in 3 Sekunden analysieren';

  @override String get personalizedCoach => 'Personalisierter KI-Coach';

  @override String get featureSubCoach => 'Ratschläge passend zu deinem Profil';

  @override String get nutritionPlanning => 'Ernährungsplanung';

  @override String get featureSubPlanning => '7-Tage-Plan von der KI erstellt';

  @override String get customRecipes => 'Individuelle Rezepte';

  @override String get featureSubRecipes => 'Gewogene Zutaten & berechnete Makros';

  @override String get progressTracking => 'Fortschrittsverfolgung';

  @override String get featureSubProgress => 'Kurven & Langzeittrends';

  @override String get dailyReminders => 'Tägliche Erinnerungen';

  @override String get featureSubReminders => 'Morgens motiviert starten';

  @override String get perMonth   => '/ Monat';
  @override String get perYear    => '/ Jahr';
  @override String get perQuarter => '/ Quartal';
  @override String get per6Months => '/ 6 Mon.';

  @override String get rating => '4,8 / 5 — Über 2.000 Nutzer';

  @override String get freeTrial => 'Kostenlose Testphase';

  @override String get continueFreePlanLabel => 'Mit kostenlosem Plan fortfahren';

  @override String get noCommitment => 'Keine Bindung · Jederzeit kündbar';

  @override String get accountRequired => 'Konto erforderlich';

  @override String get accountRequiredDesc => "Erstelle in 30 Sekunden ein kostenloses Konto.\n\nDu kannst deinen Plan direkt danach auswählen.";

  @override String get createAccountButton => 'Konto erstellen';

  @override String get premiumMonthly => 'Premium Monatlich';

  @override String get premiumYearly => 'Premium Jährlich';

  @override String get save40 => '40% SPAREN';



  // ── Progress ─────────────────────────────────────────────────────────────────

  @override String get progressTitle => 'Fortschritt';

  @override String mealsAndEntries(int meals, int entries) => '$meals Mahlzeiten · $entries Einträge';

  @override String get measurementsOk => 'Messungen OK';

  @override String get todayLabel => 'Heute';

  @override String get mealsTab => 'Mahlzeiten';

  @override String get bodyTab => 'Körper';

  @override String get todayMeasurements => 'Heutige Messungen';

  @override String get fillAvailable => 'Fülle die verfügbaren Felder aus';

  @override String get noMeasurements => 'Keine Messungen';

  @override String get addFirstMeasures => 'Füge deine ersten Messungen hinzu';

  @override String get lastMeasurements => 'Letzte Messungen';

  @override String get projectionGoal => 'Zielprojektion';

  @override String get onTrack => 'Im Plan';

  @override String get late => 'Verzögert';

  @override String get wrongDirection => 'Falsche Richtung';

  @override String get accomplished => 'Erreicht';

  @override String get estimatedDate => 'Geschätztes Datum';

  @override String get currentRhythm => 'Aktuelles Tempo';

  @override String get reverseTrend => 'Trend umkehren';

  @override String get stable => 'Stabil';

  @override String get in1Week => 'In 1 Woche';

  @override String inXWeeks(int n) => 'In $n Wochen';

  @override String get goalReached => 'Ziel erreicht!';

  @override String get weightGoingWrong => 'Das Gewicht entwickelt sich in die falsche Richtung';

  @override String get noMeals => 'Keine Mahlzeiten';

  @override String get scanFirst => 'Scanne deine erste Mahlzeit, um loszulegen';

  @override String get fullHistory => 'Vollständiger Verlauf';

  @override String get saveMeasurements => 'Messungen speichern';



  // ── Consent ─────────────────────────────────────────────────────────────────

  @override String get beforeStart => 'Bevor du beginnst';

  @override String get privacyTitle => 'Datenschutzerklärung & Nutzungsbedingungen';

  @override String get rgpdLabel => 'DSGVO';

  @override String get officialDoc => '↗ Offizielles Dokument';

  @override String get scrollToAccept => 'Lies bis zum Ende, um zu akzeptieren';

  @override String get dataCollected => 'Erhobene Daten';

  @override String get legalBasis => 'Rechtsgrundlage der Verarbeitung';

  @override String get purposes => 'Zwecke der Verarbeitung';

  @override String get subprocessors => 'Auftragsverarbeiter & Übermittlungen';

  @override String get retention => 'Speicherdauer';

  @override String get yourRights => 'Deine Rechte (DSGVO)';

  @override String get security => 'Sicherheit';

  @override String get controller => 'Verantwortlicher';

  @override String get iAccept => "Ich habe die Datenschutzerklärung und Nutzungsbedingungen von DietVision gelesen und akzeptiert. Ich stimme der Verarbeitung meiner Gesundheitsdaten zu Ernährungscoaching-Zwecken zu.";

  @override String get refuseButton => 'Ablehnen';

  @override String get acceptButton => 'Akzeptieren und fortfahren';

  @override String get scrollToBottom => 'Scrolle bis zum Ende, um die Annahme zu aktivieren';

  @override String get leaveApp => 'App verlassen';

  @override String get leaveAppDesc => "Ohne die Datenschutzerklärung zu akzeptieren, kannst du DietVision nicht nutzen. Möchtest du die App verlassen?";

  @override String get youReachedEnd => 'Du hast das Ende des Dokuments erreicht';



  // ── Splash ──────────────────────────────────────────────────────────────────

  @override String get tagline => 'ESSEN · SCANNEN · FORTSCHREITEN';



  // ── Subscription ────────────────────────────────────────────────────────────

  @override String get premiumTitle => 'Premium';

  @override String get goPremiumButton => 'Premium werden';

  @override String get premiumDesc => 'Alle Funktionen freischalten';

  @override String get paymentReady => 'Deine sichere Zahlung ist bereit.';

  @override String get paymentMethods => 'Visa, Mastercard, Apple Pay akzeptiert. Ein Promo-Code-Feld ist auf der Zahlungsseite verfügbar.';

  @override String get promoCode => 'Hast du einen Promo-Code? Gib ihn direkt auf der Stripe-Zahlungsseite ein.';

  @override String get payNow => 'Jetzt bezahlen';

  @override String get openingBrowser => 'Schließe deine Zahlung im Browser ab und komme dann zurück.';

  @override String get iHavePaid => 'Ich habe bezahlt — Bestätigen';

  @override String get reopenPayment => 'Zahlungsseite erneut öffnen';

  @override String get securedByStripe => 'Gesichert durch Stripe · TLS 256-bit';

  @override String get subscriptionActive => 'Abonnement aktiviert!';

  @override String get subscriptionActiveDesc => 'Dein Abonnement ist aktiv.\nGenieße alle Funktionen ohne Einschränkungen!';

  @override String get start => 'Loslegen';

  @override String get noPlanAvailable => 'Kein Plan verfügbar.';

  @override String get securityNote => 'Gesichert durch Stripe · TLS 256-bit';

  @override String savePercent(int p) => '$p% SPAREN';

  @override String get notAvailableYet => "Dieser Plan ist noch nicht verfügbar.";

  @override String cannotOpenBrowser(String e) => "Browser kann nicht geöffnet werden: $e";

  @override String get paymentUnconfirmed => 'Zahlung nicht bestätigt — wenn du gerade bezahlt hast, warte ein paar Sekunden und versuche es erneut.';

  @override String subscribePlan(String price) => 'Loslegen — $price';

  @override String get comingSoon => 'Demnächst verfügbar';

  @override String get cannotLoadPlans => 'Pläne können nicht geladen werden';



  // ── Diets ───────────────────────────────────────────────────────────────────

  @override String get dietOmnivore => 'Omnivor';

  @override String get dietHalal => 'Halal';

  @override String get dietVegetarian => 'Vegetarisch';

  @override String get dietVegan => 'Vegan';

  @override String get dietKeto => 'Keto';

  @override String get dietMediterranean => 'Mediterran';

  @override String get dietGlutenFree => 'Glutenfrei';

  @override String get dietPaleo => 'Paleo';

  @override String get dietDairy => 'Laktosefrei';

  @override String get dietHighProtein => 'Eiweißreich';

  @override String get dietLowCalorie => 'Kalorienarm';



  // ── Coach extras ─────────────────────────────────────────────────────────────

  @override String get dietFromProfile => 'Diät aus Ihrem Profil';

  @override String get generating => 'Wird generiert…';

  @override String get actualize => 'Aktualisieren';

  @override String get typing => 'Tippt…';

  @override String generateDishes(String diet) => '$diet-Gerichte';

  @override String get generateDishesDesc => 'Die KI erstellt 3 maßgeschneiderte Rezepte\npassend zu Ihrem Profil, verbleibenden Kalorien\nund der gewählten Diät.';

  @override String planAvailableWith(String plan) => 'Verfügbar mit dem $plan-Plan';

  @override String get planAvailableWithProOrPremium => 'Verfügbar mit dem Pro- oder Premium-Plan';

  @override String get currentPlanLabel => 'Aktueller Plan';

  @override String get freePlanLabel => 'Kostenlos';



  // ── Day names (short) ────────────────────────────────────────────────────────

  @override String get dayMon => 'Mo';

  @override String get dayTue => 'Di';

  @override String get dayWed => 'Mi';

  @override String get dayThu => 'Do';

  @override String get dayFri => 'Fr';

  @override String get daySat => 'Sa';

  @override String get daySun => 'So';



  // ── Day names (full) ─────────────────────────────────────────────────────────

  @override String get dayMonFull => 'Montag';

  @override String get dayTueFull => 'Dienstag';

  @override String get dayWedFull => 'Mittwoch';

  @override String get dayThuFull => 'Donnerstag';

  @override String get dayFriFull => 'Freitag';

  @override String get daySatFull => 'Samstag';

  @override String get daySunFull => 'Sonntag';



  // ── Chat suggestions ─────────────────────────────────────────────────────────

  @override String get suggestion1 => 'Schlage einen Ernährungsplan für morgen vor';

  @override String get suggestion2 => 'Welche Lebensmittel für den Muskelaufbau?';

  @override String get suggestion3 => 'Meine wöchentliche Ernährungsbilanz';

  @override String get suggestion4 => 'Beste Post-Workout-Snacks';



  // ── Body measurements extras ──────────────────────────────────────────────────

  @override String get chest => 'Brustumfang';

  @override String get hips => 'Hüftumfang';

  @override String get thighs => 'Oberschenkelumfang';



  // ── Activity levels ─────────────────────────────────────────────────────────

  @override String get activitySedentary => 'Sitzend';

  @override String get activityLight => 'Leicht (1-2 T./Wo.)';

  @override String get activityModerate => 'Moderat (3-4 T./Wo.)';

  @override String get activityActive => 'Aktiv (5-6 T./Wo.)';

  @override String get activityVeryActive => 'Sehr aktiv';



  // ── Dashboard extras ─────────────────────────────────────────────────────────

  @override String get kcalRemaining => 'kcal übrig';

  @override String get kcalExceeded => 'kcal zu viel';



  // ── Subscription gate ─────────────────────────────────────────────────────────

  @override String get trialExpiredTitle => 'Ihre Testphase ist abgelaufen';

  @override String get trialExpiredSubtitle => 'Abonnieren Sie, um DietVision weiter zu nutzen und alle Funktionen freizuschalten.';

  @override String get alreadyPaidCheck => 'Bereits bezahlt? Abonnement prüfen';

  @override String get noActiveSubscription => 'Kein aktives Abonnement gefunden.';

  @override String get checkingSubscription => 'Wird geprüft…';



  // ── Plan card labels ──────────────────────────────────────────────────────────

  @override String get yourCurrentPlan => 'IHR AKTUELLER PLAN';

  @override String get trialExpiredToday => 'Testphase heute abgelaufen';

  @override String trialExpiredDaysAgo(int days) => 'Testphase vor $days Tag(en) abgelaufen';

  @override String trialDaysRemaining(int days) => days == 1 ? 'Testphase: noch 1 Tag â³' : 'Testphase: noch $days Tage â³';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Monatlich';

  @override String get billingQuarterly => '3 Monate';

  @override String get billingSemiAnnual => '6 Monate';

  @override String get billingYearly => 'Jährlich';

  @override String get bestOffer => 'ðŸ† Bestes Angebot';

  @override String savingPerMonth(String amt) => '-$amt/Mo.';

  @override String perDay(String amt) => '$amt/Tag';

  @override String get lessThanCoffee => 'Weniger als ein Kaffee ☕';

  @override String get guarantee30Days => '30 Tage Geld-zurück-Garantie';

  @override String get specialOffer => 'ðŸŽ SONDERANGEBOT';

  @override String offerExpiresIn(int h, int m) => 'Läuft in ${h}h ${m}min ab';

  @override String get trialSummaryTitle => 'Was Sie erreicht haben';

  @override String mealsScannedCount(int n) => '$n Mahlzeiten gescannt';

  @override String get scanUpsellTitle => 'Analyse abgeschlossen! 🎉';

  @override String get scanUpsellBody => 'Upgrade auf Pro für unbegrenzte Scans und personalisierte KI-Empfehlungen.';

  @override String get upgradeNow => 'Pläne ansehen';

  @override String get notNow => 'Nicht jetzt';

  @override String annualSavingsBanner(String amt) => 'ðŸŽ Sparen Sie $amt mit Jahresabo';

  @override String get trialNotifJ7 => 'Noch 7 Tage Testphase';

  @override String get trialNotifJ7Body => 'Genießen Sie noch 7 Tage — dann wählen Sie Ihren Plan.';

  @override String get trialNotifJ3 => 'Nur noch 3 Tage!';

  @override String get trialNotifJ3Body => 'Sonderangebot: -40% auf Jahresabo. Jetzt zugreifen!';

  @override String get trialNotifJ1 => 'Letzter Testtag 🔔';

  @override String get trialNotifJ1Body => 'Ihre Testphase läuft morgen ab. Verlieren Sie Ihren Fortschritt nicht!';



  // ── Payment verification ───────────────────────────────────────────────────────

  @override String get verifyingPayment => 'Zahlung wird überprüft…';

  @override String get stepPaymentConfirmed => 'Zahlung bestätigt ✓';

  @override String get stepServerNotified => 'Server benachrichtigt ✓';

  @override String get stepInvoiceSent => 'Rechnung per E-Mail gesendet ✓';

  @override String get paymentVerifiedTitle => 'Abonnement aktiviert!';

  @override String get paymentVerifiedDesc => 'Ihr Abonnement ist jetzt aktiv. Eine Rechnung wurde an Ihre E-Mail-Adresse gesendet. Genießen Sie alle Funktionen!';

  @override String get serverNotYetNotified => 'Der Server hat die Bestätigung noch nicht erhalten. Warten Sie einige Sekunden und versuchen Sie es erneut.';

  @override String get retryVerification => 'Überprüfung wiederholen';

  @override String webhookPolling(int attempt, int max) => 'Server wird geprüft… Versuch $attempt/$max';

  @override String get webhookNotReceived => 'Der Server hat den Stripe-Webhook nach mehreren Versuchen nicht erhalten.';

  @override String get webhookReceived => 'Stripe-Webhook empfangen und verarbeitet ✓';


  // -- Password strength & forgot password
  @override String get passwordNeedsUppercase => 'Muss mindestens einen Großbuchstaben enthalten';
  @override String get passwordNeedsNumberOrSymbol => 'Muss mindestens eine Ziffer oder ein Sonderzeichen enthalten';
  @override String get forgotPassword => 'Passwort vergessen?';
  @override String get forgotPasswordTitle => 'Passwort vergessen';
  @override String get forgotPasswordDesc => 'Geben Sie Ihre E-Mail-Adresse ein. Wir senden Ihnen einen 6-stelligen Code zum Zurücksetzen Ihres Passworts.';
  @override String get sendResetCode => 'Code senden';
  @override String get resetPasswordTitle => 'Neues Passwort';
  @override String get resetPasswordDesc => 'Geben Sie den per E-Mail erhaltenen Code ein und wählen Sie ein neues Passwort.';
  @override String get newPassword => 'Neues Passwort';
  @override String get resetPassword => 'Passwort zurücksetzen';
  @override String get passwordResetSuccess => 'Passwort zurückgesetzt!';
  @override String get passwordResetSuccessDesc => 'Ihr Passwort wurde erfolgreich geändert. Sie können sich jetzt anmelden.';
}



