import 'app_localizations.dart';



class AppLocalizationsDe extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Startseite';

  @override String get navScan => 'Scannen';

  @override String get navCoach => 'Diet Coach';

  @override String get navProgress => 'Fortschritt';

  @override String get navProfile => 'Profil';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Dein KI-Ernährungscoach';

  @override String get sessionExpired => 'Sitzung beendet';

  @override String get reconnect => 'Erneut anmelden';

  @override String get cancel => 'Abbrechen';

  @override String get confirm => 'Bestätigen';

  @override String get save   => 'Speichern';
  @override String get change => 'Ändern';

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

  @override String get birthDate      => 'Geburtsdatum';
  @override String get birthDateHint  => 'TT.MM.JJJJ';
  @override String get underageTitle  => 'Zugang beschränkt';
  @override String get underageBody   => 'DietVision ist für Personen ab 15 Jahren bestimmt.\n\nWenn du jünger als 15 Jahre bist, ist die Nutzung dieser App nur mit Zustimmung eines Elternteils oder gesetzlichen Vormunds gestattet.\n\nBitte einen Erwachsenen, ein Konto zu erstellen und dich bei deiner Ernährungsverfolgung zu begleiten.';
  @override String get underageButton => 'Verstanden';

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

  @override String get measurementsDoneToday        => 'Messungen heute eingetragen';
  @override String get bodyMeasurementsSubtitle     => 'Gewicht · Taille · Bizeps';
  @override String get syncedLabel                  => 'Daten aktuell';
  @override String get stayFocused                  => 'Bleib dran, jede Aktion zählt!';
  @override String get dailyProgress                => 'Tages-\nfortschritt';

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

  @override String get camera => 'Kamera';
  @override String get gallery => 'Galerie';
  @override String get photoTipsTitle => 'FOTO-TIPPS';
  @override String get tipFramePlate => 'Teller einrahmen';
  @override String get tipGoodLight => 'Gutes Licht';
  @override String get tipTopView => 'Draufsicht';
  @override String get tipVisibleFood => 'Lebensmittel sichtbar';
  @override String get tipFullPlate => 'Ganzes Gericht';
  @override String get tipNoFlash => 'Kein Blitz';

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

  @override String get coachTitle => 'Diet Coach';

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
  @override String get restrictionVegetarian => 'Vegetarisch';
  @override String get restrictionVegan      => 'Vegan';
  @override String get restrictionGlutenFree => 'Glutenfrei';
  @override String get restrictionLactoseFree=> 'Laktosefrei';
  @override String get restrictionHalal      => 'Halal';
  @override String get restrictionKeto       => 'Keto';

  @override String get welcome => 'Willkommen bei DietVision';

  @override String get welcomeSubtitle => "Dein KI-gestützter Ernährungs- & Fitness-Coach.\nAnalysiere deine Mahlzeiten, verfolge deine Makros und erreiche deine Ziele.";

  @override String get createProfile => 'Mein Profil erstellen';

  @override String get continueButton => 'Weiter →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Erreiche deine Ziele\nschneller mit Premium';

  @override String get paywallSubtitle => "Alles, was du brauchst, in einer App.";

  @override String get chipMealScan       => 'Mahlzeit-Scan';
  @override String get chipMacroTracking  => 'Makro-Tracking';
  @override String get chipAiCoach        => 'KI-Coach';
  @override String get paywallFeaturesPrefix    => 'Alles, was du\nbrauchst, um zu ';
  @override String get paywallFeaturesHighlight => 'erreichen';
  @override String get paywallFeaturesSubtitle  => 'Intelligente Tools, um deine Ernährungsziele zu erreichen.';
  @override String get paywallPlanPrefix    => 'Wähle\ndeinen ';
  @override String get paywallPlanHighlight => 'Plan';
  @override String get paywallPlanSubtitle  => 'Starte deine kostenlose Testphase. Jederzeit kündbar.';

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
  @override String get kcalExceeded  => 'kcal zu viel';
  @override String get kcalOver      => 'kcal zu viel';

  // ── Context Day Card ─────────────────────────────────────────────────────────
  @override String get protLow       => 'niedrig';
  @override String get protModerate  => 'moderat';
  @override String get protGood      => 'gut';
  @override String get goalWeightLoss => 'Gewichtsverlust';
  @override String get goalMassGain  => 'Masseaufbau';
  @override String get goalMaintain  => 'Erhaltung';
  @override String get labelProteins => 'Proteine';
  @override String get labelGoal     => 'Ziel:';
  @override String get labelDiet     => 'Ernährung:';
  @override String ctxDescSurplus(int surplus) => 'Du hast +$surplus kcal zu viel. Ich kann leichtere Gerichte vorschlagen, um deinen Tag auszugleichen.';
  @override String get ctxDescLowProt => 'Deine Proteinzufuhr ist niedrig. Ich kann dir helfen, deine Makros neu auszubalancieren.';
  @override String get ctxDescDefault => 'Ich kann dir helfen, deinen Tag basierend auf deinen verbleibenden Kalorien und deinem Ziel zu gestalten.';

  // ── Smart Actions labels ──────────────────────────────────────────────────────
  @override String get smartBuildDay        => 'Meinen Tag planen';
  @override String smartBuildDaySub(int k)  => 'mit $k kcal übrig';
  @override String smartSurplusTitle(int k)  => 'Überschuss +$k kcal';
  @override String get smartSurplusSub      => 'Wie ausgleichen?';
  @override String get smart3Dishes         => '3 Gerichte vorschlagen';
  @override String get smart3DishesSub      => 'proteinreich';
  @override String get smartAnalyzeBilan    => 'Meine Bilanz analysieren';
  @override String get smartAnalyzeBilanSub => 'Ernährung der Woche';
  @override String get smartPrepareDinner   => 'Abendessen vorbereiten';
  @override String get smartPrepareDinnerSub => 'für heute Abend';

  // ── Pro gate ─────────────────────────────────────────────────────────────────
  @override String get gateDishesAdaptedRecipes    => 'Rezepte angepasst\nan dein Profil\n& Ernährung';
  @override String get gateDishes9Diets            => '9 Ernährungs-\nformen\nverfügbar';
  @override String get gateDishesWeighedIngredients => 'Gewogene Zutaten\n& Makros\nberechnet';
  @override String get gateDishesUpdatedDaily      => 'Täglich\naktualisiert';
  @override String get tableHeaderFeatures         => 'Funktionen';
  @override String get tableRowPersonalizedDishes  => 'Personalisierte KI-Gerichte';
  @override String get tableRowAdaptedRecipes      => 'Rezepte an dein Profil angepasst';
  @override String get tableRowWeighedIngredients  => 'Gewogene Zutaten & Makros';
  @override String get tableRowUpdatedDaily        => 'Täglich aktualisiert';

  // ── Premium gate ─────────────────────────────────────────────────────────────
  @override String get gatePlanningWeekPlan    => '7-Tage KI-Plan\nnach deinem Ziel\ngeneriert';
  @override String get gatePlanningCaloricGoal => 'Kalorienziel\n& Makros\nberechnet';
  @override String get gatePlanningAdapted     => 'Angepasst an\ndein Ziel';
  @override String get gatePlanningDailyTips   => 'Tägliche Tipps\n& intelligentes Tracking';
  @override String get planStarterSubtitle     => 'Basisfunktionen';
  @override String get planProSubtitle         => 'KI-Rezepte & Ernährungen';
  @override String get planPremiumSubtitle     => 'KI-Ernährungsplanung';
  @override String get planIncluded            => 'Inklusive';
  @override String get planNotIncluded         => 'Planung nicht enthalten';

  // ── Quick tips ────────────────────────────────────────────────────────────────
  @override String get tipScanFirstMeal  => 'Scanne zuerst deine erste Mahlzeit, damit ich deine Tagesmakros analysieren kann.';
  @override String get tipIncreaseProtein => 'Priorität heute: Erhöhe deine Proteinzufuhr bei der nächsten Mahlzeit.';
  @override String tipCaloriesAvailable(int pct) => 'Du hast noch $pct% deiner Kalorien verfügbar. Denk an deine nächste Mahlzeit!';
  @override String get tipCaloriesExceeded => 'Kalorienziel überschritten. Setz heute Abend auf leichte, ballaststoffreiche Lebensmittel.';
  @override String get tipKeepGoing       => 'Weiter so! Dein Tag ist gut ausgewogen — bleib auf Kurs.';
  @override String get newChat => 'Neues Gespräch';
  @override String get clearChatTitle => 'Gespräch löschen?';
  @override String get clearChatConfirm => 'Der Chat-Verlauf wird dauerhaft gelöscht.';
  @override String get clearChatConfirmBtn => 'Löschen';
  @override String promptCreatePlanSurplus(int surplus, String diet) => "Ich habe heute +$surplus kcal zu viel. Hilf mir, den Rest meines Tages mit meiner $diet-Diät auszugleichen.";
  @override String promptCreatePlanNormal(int remaining, String diet) => "Erstelle meinen Ernährungsplan für heute mit $remaining verbleibenden kcal und meiner $diet-Diät.";
  @override String get promptFixMacros => "Analysiere und korrigiere meine heutigen Makros. Gib mir konkrete Ratschläge, um Proteine, Kohlenhydrate und Fette auszugleichen.";
  @override String get promptAnalyzeProgress => "Analysiere meine wöchentlichen Ernährungsfortschritte und gib mir 3 personalisierte Tipps zur Verbesserung.";
  @override String promptSurplusBalance(int surplus, int tdee) => "Ich habe heute +$surplus kcal zu viel (Ziel: $tdee kcal/Tag). Gib mir Ratschläge, um meinen Tag auszugleichen und die Auswirkungen des Überschusses zu begrenzen.";
  @override String promptBuildDay(int remaining, String diet) => "Erstelle mir einen vollständigen Mahlzeitenplan für heute mit $remaining verbleibenden kcal, angepasst an meine $diet-Diät und meine Ziele.";
  @override String prompt3Dishes(String diet) => "Schlage mir 3 proteinreiche Gerichte vor (mindestens 30g pro Gericht), angepasst an meine $diet-Diät.";
  @override String get promptAnalyzeBilan => "Analysiere meine wöchentliche Ernährungsbilanz und gib mir konkrete Ratschläge zur Verbesserung.";
  @override String promptDinnerSurplus(int surplus, int tdee, String diet) => "Ich habe heute +$surplus kcal zu viel (Ziel: $tdee kcal/Tag). Schlage mir ein leichtes Abendessen für heute Abend vor, angepasst an meine $diet-Diät.";
  @override String promptDinnerNormal(int remaining, String diet) => "Schlage mir ein Abendessen für heute Abend vor, das zu meinen $remaining verbleibenden kcal und meiner $diet-Diät passt.";



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

  @override String trialDaysRemaining(int days) => days == 1 ? 'Testphase: noch 1 Tag ' : 'Testphase: noch $days Tage ';
  @override String get statusActive => 'Aktiv';
  @override String get statusInactive => 'Inaktiv';
  @override String get verifiedFromServer => 'Vom Server verifiziert';
  @override String get localCache => 'Lokaler Cache';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Monatlich';

  @override String get billingQuarterly => '3 Monate';

  @override String get billingSemiAnnual => '6 Monate';

  @override String get billingYearly => 'Jährlich';

  @override String get bestOffer => 'Bestes Angebot';

  @override String savingPerMonth(String amt) => '-$amt/Mo.';

  @override String perDay(String amt) => '$amt/Tag';

  @override String get lessThanCoffee => 'Weniger als ein Kaffee ☕';

  @override String get guarantee30Days => '30 Tage Geld-zurück-Garantie';

  @override String get specialOffer => 'SONDERANGEBOT';

  @override String offerExpiresIn(int h, int m) => 'Läuft in ${h}h ${m}min ab';

  @override String get trialSummaryTitle => 'Was Sie erreicht haben';

  @override String mealsScannedCount(int n) => '$n Mahlzeiten gescannt';

  @override String get scanUpsellTitle => 'Analyse abgeschlossen! 🎉';

  @override String get scanUpsellBody => 'Upgrade auf Pro für unbegrenzte Scans und personalisierte KI-Empfehlungen.';

  @override String get upgradeNow => 'Pläne ansehen';

  @override String get notNow => 'Nicht jetzt';

  @override String annualSavingsBanner(String amt) => 'Sparen Sie $amt mit Jahresabo';

  @override String get trialNotifJ7 => 'Noch 7 Tage Testphase';

  @override String get trialNotifJ7Body => 'Genießen Sie noch 7 Tage — dann wählen Sie Ihren Plan.';

  @override String get trialNotifJ3 => 'Nur noch 3 Tage!';

  @override String get trialNotifJ3Body => 'Sonderangebot: -40% auf Jahresabo. Jetzt zugreifen!';

  @override String get trialNotifJ1 => 'Letzter Testtag 🔔';

  @override String get trialNotifJ1Body => 'Ihre Testphase läuft morgen ab. Verlieren Sie Ihren Fortschritt nicht!';



  // ── Weekly details sheet ─────────────────────────────────────────────────────

  @override String get weeklyDetails => 'Wochendetails';
  @override String get weeklySummaryTitle => 'Wochenzusammenfassung';
  @override String get avgKcalPerDay => 'Durchschnitt';
  @override String get targetKcalDay2 => 'Ziel';
  @override String get differenceKcal => 'Differenz';
  @override String proteinTargetReached(int done, int total) => 'Proteinziel erreicht: $done/$total Tage';
  @override String get statusOnTrack => 'Auf Kurs';
  @override String get statusAttention => 'Achtung';
  @override String get statusOffTrack => 'Vom Kurs abgekommen';
  @override String get statusNotStarted => 'Noch nicht begonnen';
  @override String get editThisDay => 'Diesen Tag bearbeiten';
  @override String get replaceMeals => 'Mahlzeiten ersetzen';
  @override String get copyThisDay => 'Diesen Tag kopieren';
  @override String get balanceWeek => 'Woche ausbalancieren';
  @override String get insightAnalysisTitle => 'Analyse';
  @override String get insightWhyTitle => 'Warum es wichtig ist';
  @override String get insightActionsTitle => 'Vorgeschlagene Maßnahmen';
  @override String insightProteinAnalysis(int current, int target, int gap) =>
      'Ihr heutiges Proteinziel ist $target g.\nSie sind aktuell bei $current g.\nEs fehlen noch etwa $gap g Protein.';
  @override String insightCaloriesAnalysis(int current, int target) =>
      'Sie haben $current kcal von Ihrem $target kcal Ziel verbraucht.';
  @override String get insightWhyProtein => 'Das Erreichen Ihres Proteinziels hilft, Muskelmasse zu erhalten, besonders beim Abnehmen. Es sättigt Sie auch länger.';
  @override String get insightWhyCalories => 'Nahe am Kalorienziel zu bleiben ist der wichtigste Faktor für Ihr Gewichtsziel.';
  @override String get insightWhyWater => 'Gute Flüssigkeitszufuhr unterstützt den Stoffwechsel und reduziert Hunger.';
  @override String get insightWhyCarbs => 'Das Management der Kohlenhydratzufuhr stabilisiert den Blutzucker.';
  @override String get insightWhyNoScan => 'Das Erfassen Ihrer Mahlzeiten hilft Ihnen, Ihre täglichen Ziele zu erreichen.';
  @override String get insightAction1Protein => 'Griechischer Joghurt + 2 Eier';
  @override String get insightAction1ProteinDetail => '280 kcal · 32 g Protein';
  @override String get insightAction2Protein => '150 g Hähnchenbrust zum Abendessen hinzufügen';
  @override String get insightAction2ProteinDetail => '+240 kcal · +45 g Protein';
  @override String get insightIgnoreToday => 'Heute ignorieren';
  @override String get applySuggestion => 'Vorschlag anwenden';
  @override String get showAlternatives => 'Alternativen anzeigen';
  @override String get remindMeLater => 'Später erinnern';
  @override String get progressForecast => 'Fortschrittsprognose';
  @override String get projectionBasis => 'Diese Prognose basiert auf Ihrem Kalorienziel, geschätzter Aktivität, Proteinaufnahme und aktueller Regelmäßigkeit.';
  @override String get conservativeScenario => 'Konservativ';
  @override String get balancedScenario => 'Ausgewogen';
  @override String get aggressiveScenario => 'Intensiv';
  @override String get scenarioEasyToKeep => 'Einfacher durchzuhalten';
  @override String get scenarioRecommended => 'Empfohlen';
  @override String get scenarioHarder => 'Schwieriger — höheres Hungerrisiko';
  @override String get useBalancedPlan => 'Ausgewogenen Plan verwenden';
  @override String get makeItEasierPlan => 'Erleichtern';
  @override String get makeItFasterPlan => 'Beschleunigen';
  @override String get weekLabel => 'Woche';
  @override String get estimatedWeight => 'Geschätztes Gewicht';
  @override String get weightEvolution => 'Veränderung';
  @override String get todayWeightLabel => 'Heute';

  // ── Planning tab ─────────────────────────────────────────────────────────────

  @override String get weeklyBalanceScore => 'WÖCHENTLICHER SCORE';
  @override String get onTrackThisWeek => 'Sie sind auf dem richtigen Weg!';
  @override String get greatConsistency => 'Tolle Regelmäßigkeit. Weiter so!';
  @override String get goodProgressPlan => 'Guter Fortschritt, weiter so!';
  @override String get aFewMoreEfforts => 'Noch ein paar Anstrengungen und Sie schaffen es.';
  @override String get stayConsistentPlan => 'Bleiben Sie diese Woche konsequent.';
  @override String get tryHitTargets => 'Versuchen Sie, Ihre täglichen Ziele zu erreichen.';
  @override String get buildYourRoutine => 'Beginnen Sie, Ihre Routine aufzubauen!';
  @override String get everyStepCounts => 'Jeder Schritt zählt. Sie schaffen das!';
  @override String todayKcalRemainingLabel(int n) => 'Heute: $n kcal übrig';
  @override String get viewDetails => 'Details anzeigen';
  @override String get todayChecklist => 'Heutige Checkliste';
  @override String completedOfTotal(int done, int total) => '$done/$total erledigt';
  @override String get checkHitCalorie => 'Kalorienziel erreichen';
  @override String get checkScan2Meals => '2 Mahlzeiten scannen';
  @override String get checkProteinGoal => 'Proteinziel erreichen';
  @override String get checkWalk30 => '30 Min. gehen';
  @override String get checkDrinkWater => '2,5 L Wasser trinken';
  @override String get checkNoSugarAfter8pm => 'Kein Zucker nach 20 Uhr';
  @override String get aiInsightTitle => 'KI-Einblick';
  @override String get insightProteinLow => 'Die Proteinzufuhr ist heute etwas niedrig. Fügen Sie heute Abend einen eiweißreichen Snack hinzu.';
  @override String get insightCaloriesHigh => 'Sie nähern sich Ihrem Kalorienlimit. Wählen Sie heute Abend ein leichtes Abendessen.';
  @override String get insightLackWater => 'Vergessen Sie nicht, Wasser zu trinken. Ziel: 2,5 L heute.';
  @override String get insightTooManyCarbs => 'Kohlenhydrataufnahme heute hoch. Ausgleichen mit mehr Protein und Gemüse.';
  @override String get insightNoScan => 'Heute noch keine Mahlzeit gescannt. Beginnen Sie zu tracken.';
  @override String get insightOnTrack => 'Heute läuft alles super. Weiter so und bleiben Sie konsequent!';
  @override String get weekProjectionTitle => '4-Wochen-Prognose';
  @override String get projectionSubtitle => 'Geschätztes Ergebnis, wenn Sie diesem Plan folgen';
  @override String get weightChangeLbl => 'Gewichtsveränderung';
  @override String get musclePreservedLbl => 'Erhalten';
  @override String get muscleGrowingLbl => 'Wachsend';
  @override String get muscleMaintainedLbl => 'Gehalten';
  @override String get energyStableLbl => 'Stabil';
  @override String get adjustWeekBtn => 'Woche anpassen';
  @override String get adjustWeekSheetTitle => 'Wie möchten Sie anpassen?';
  @override String get adjustLoseFaster => 'Ich möchte schneller abnehmen';
  @override String get adjustEasierPlan => 'Ich möchte einen einfacheren Plan';
  @override String get adjustMoreProtein => 'Ich möchte mehr Protein';
  @override String get adjustFewerCarbs => 'Ich möchte weniger Kohlenhydrate';
  @override String get adjustCheaper => 'Ich möchte einen günstigeren Plan';
  @override String get adjustLocal => 'Ich möchte lokale Mahlzeiten';
  @override String get adjustFlexibleWeekend => 'Ich möchte ein flexibleres Wochenende';
  @override String get notificationsTooltip => 'Benachrichtigungen';

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

  // ── Dishes tab extras ────────────────────────────────────────────────────────
  @override String get suggestionDuMoment  => 'Aktuelle Empfehlung';
  @override String get personalizeLabel    => 'Vorschläge anpassen';
  @override String get mealObjectiveLabel  => 'Mahlzeitziel';
  @override String get chooseThisDish      => 'Dieses Gericht wählen';
  @override String get filterQuick         => 'Schnell';
  @override String get filterBudget        => 'Günstig';
  @override String get filterLowKcal       => '< 600 kcal';
  @override String get filterLowCarb       => 'Wenig Kohlenhydrate';
  @override String get filterSnack         => 'Snack';
  @override String get dishSelectedMsg     => 'Gericht ausgewählt!';
  @override String get preparationBtn        => 'Zubereitung';
  @override String get contextDayTitle       => 'Tageskontext';
  @override String get smartActionsTitle     => 'Intelligente Aktionen';
  @override String get viewAll               => 'Alle anzeigen';
  @override String get quickTipLabel         => 'Schnelltipp';
  @override String get actionCreatePlan      => 'Plan erstellen';
  @override String get actionFixMacros       => 'Makros korrigieren';
  @override String get actionAnalyzeProgress => 'Fortschritt analysieren';


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

  // ── Dashboard — Today Mission & AI Reco ──────────────────────────────────────
  @override String get readyToCrush => 'Bereit, deine Ziele zu erreichen?';
  @override String get notifications => 'Benachrichtigungen';
  @override String get todayMission => 'Mission des Tages';
  @override String get seeDailyPlan => 'Meinen Tagesplan ansehen';
  @override String get completeDailyMeasures => 'Tägliche Messungen vervollständigen';
  @override String get dailyCheckIn => 'Tägliches Check-in';
  @override String get toComplete => 'Zu erledigen';
  @override String get completeNow => 'Jetzt abschließen';
  @override String get checkInDone => 'Check-in abgeschlossen!';
  @override String get dataUpToDate => 'Daten aktuell. KI-Projektion ist präziser.';
  @override String get aiRecommendation => 'KI-Empfehlung';
  @override String get viewMore => 'Mehr sehen';
  @override String get viewDishes => 'Gerichte ansehen';
  @override String get scanMeal => 'Mahlzeit scannen';
  @override String get adjustToday => 'Heute anpassen';
  @override String get aiRecNoScan => 'Noch keine Mahlzeit gescannt. Starte das Tracking, um deinen Plan einzuhalten.';
  @override String get aiRecProteinLow => 'Dein Proteinanteil ist niedrig. Füge bei der nächsten Mahlzeit proteinreiches Essen hinzu.';
  @override String get aiRecCaloriesHigh => 'Du näherst dich deinem Kalorienlimit. Wähle heute Abend ein leichtes Abendessen.';
  @override String get aiRecOnTrack => 'Du liegst auf Kurs! Alles sieht heute großartig aus. Weiter so.';
  @override String get objectifQuotidien => 'Tagesziel';

  // ── Gate PRO ─────────────────────────────────────────────────────────────────
  @override String get proGateBannerTitle  => 'Pro-Plan erforderlich';
  @override String get proGateBannerSub    => 'KI-personalisierte Gerichte freischalten';
  @override String get proGateChip         => 'Pro erforderlich';
  @override String get proGateHeroTitle    => 'KI-personalisierte Gerichte';
  @override String get proGateHeroAvail    => 'Verfügbar mit dem Pro- oder Premium-Plan';
  @override String get proGateHeroDesc     => 'Erhalte täglich Mahlzeiten, die auf deine Ziele und Vorlieben zugeschnitten sind.';
  @override String get proGateCta         => 'Meine KI-Gerichte freischalten';
  @override String get cancelAnytime       => 'Jederzeit kündbar';
  @override String get freeTrialDays       => '7 Tage kostenlos testen';

  // ── Gate PREMIUM ──────────────────────────────────────────────────────────────
  @override String get premiumGateBannerTitle  => 'Premium-Plan erforderlich';
  @override String get premiumGateBannerSub    => 'Deinen personalisierten Ernährungsplan freischalten';
  @override String get premiumGateHeroAvail    => 'Verfügbar mit dem Premium-Plan';
  @override String get premiumGateHeroDesc     => 'Ein 7-Tage-KI-Plan, angepasst an deine Ziele und deinen Alltag.';
  @override String get premiumGatePreviewTitle => 'Vorschau deines zukünftigen Plans';
  @override String get premiumGatePreviewLock  => 'Den vollständigen personalisierten Plan freischalten';
  @override String get premiumGateCta         => 'Meinen Premium-Plan aktivieren';

  // ── Dishes tab ────────────────────────────────────────────────────────────────
  @override String dishesResultCount(int n) => '$n Ergebnisse';
  @override String get seeDetails   => 'Details anzeigen';
  @override String get dayBilan     => 'Tagesbilanz';
  @override String get dayMeals     => 'Heutige Mahlzeiten';
  @override String get previewHint  => 'Vorschau — Generiere, um deine personalisierten Gerichte zu sehen';
  @override String stepLabel(int n) => 'Schritt $n';
  @override String get orContinueWith => 'Oder fortfahren mit';
  @override String get socialAuthError => 'Fehler bei der sozialen Authentifizierung';

  // ── Onboarding welcome step ───────────────────────────────────────────────
  @override String get welcomeTo => 'Willkommen bei';
  @override String get onboardingIntro => 'Bevor wir beginnen, richten wir\nIhr Profil ein, um ';
  @override String get onboardingPersonalize => 'Ihr Erlebnis zu personalisieren.';
  @override String get infoCardTitle => 'Ihre Informationen';
  @override String get infoCardSubtitle => 'Alter, Geschlecht, Größe, Gewicht';
  @override String get measuresCardTitle => 'Ihre Maße';
  @override String get measuresCardSubtitle => 'Taille, Hüften, Bizeps…';
  @override String get objectivesCardTitle => 'Ihre Ziele';
  @override String get objectivesCardSubtitle => 'Gewicht verlieren, Muskeln aufbauen oder halten';
  @override String get aiNoteText => 'Das dauert nur wenige Augenblicke und ermöglicht der KI, ';
  @override String get aiNoteHighlight => 'personalisierte Empfehlungen zu geben.';
  @override String get nextStepLabel => 'Nächster Schritt: Daten eingeben';
}



