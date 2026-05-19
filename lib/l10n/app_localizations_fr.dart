import 'app_localizations.dart';



class AppLocalizationsFr extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Accueil';

  @override String get navScan => 'Scanner';

  @override String get navCoach => 'Coach IA';

  @override String get navProgress => 'Progrès';

  @override String get navProfile => 'Profil';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Votre coach nutrition IA';

  @override String get sessionExpired => 'Session terminée';

  @override String get reconnect => 'Se reconnecter';

  @override String get cancel => 'Annuler';

  @override String get confirm => 'Confirmer';

  @override String get save => 'Enregistrer';

  @override String get retry => 'Réessayer';

  @override String get loading => 'Chargement…';

  @override String get error => 'Erreur';

  @override String get later => 'Plus tard';

  @override String get quit => 'Quitter';

  @override String get close => 'Fermer';

  @override String get back => 'Retour';

  @override String get refresh => 'Actualiser';

  @override String get next => 'Suivant';

  @override String get skip => 'Passer';

  @override String get accept => 'Accepter';

  @override String get refuse => 'Refuser';

  @override String get yes => 'Oui';

  @override String get no => 'Non';

  @override String get optional => 'Optionnel';

  @override String get recommended => 'Recommandé';

  @override String get popular => 'Populaire';



  // ── Auth ────────────────────────────────────────────────────────────────────

  @override String get signIn => 'Connexion';

  @override String get createAccount => 'Créer un compte';

  @override String get email => 'Email';

  @override String get emailHint => 'votre@email.com';

  @override String get emailRequired => 'Email requis';

  @override String get emailInvalid => 'Email invalide';

  @override String get password => 'Mot de passe';

  @override String get passwordHint => '••••••••';

  @override String get passwordRequired => 'Mot de passe requis';

  @override String get passwordMin8 => 'Minimum 8 caractères';

  @override String get confirmPassword => 'Confirmer le mot de passe';

  @override String get passwordMismatch => 'Les mots de passe ne correspondent pas';

  @override String get firstName => 'Prénom / Nom';

  @override String get firstNameHint => 'Jean Dupont';

  @override String get firstNameRequired => 'Nom requis (min. 2 caractères)';

  @override String get phone => 'Téléphone (facultatif)';

  @override String get phoneHint => '+225 07 00 00 00 00';

  @override String get country => 'Pays';

  @override String get chooseCountry => 'Choisir un pays';

  @override String get searchCountry => 'Rechercher un pays…';

  @override String get currency => 'Devise préférée';

  @override String get chooseCurrency => 'Choisir une devise';

  @override String get searchCurrency => 'Rechercher — EUR, Dollar, Franc…';

  @override String get loginButton => 'Se connecter';

  @override String get registerButton => 'Créer mon compte';

  @override String get mustAcceptPrivacy => 'Veuillez accepter la politique de confidentialité pour continuer';

  @override String get iAcceptThe => 'J\'accepte la ';

  @override String get privacyPolicyLink => 'politique de confidentialité et les CGU';



  // ── Dashboard ───────────────────────────────────────────────────────────────

  @override String helloUser(String name) => 'Bonjour, $name';

  @override String get today => "Aujourd'hui";

  @override String get goal => 'Objectif';

  @override String get planning => 'planning';

  @override String get kcalPerDay => 'kcal / jour';

  @override String get progression => 'Progression';

  @override String get last7Days => '7 derniers jours';

  @override String get todayMeals => "Repas d'aujourd'hui";

  @override String get noMealsToday => "Aucun repas enregistré aujourd'hui.\nScannez votre prochain repas !";

  @override String get missingMeasurements => 'Mesures du jour manquantes';

  @override String get bodyMeasurementsHint => 'Poids, tour de taille, biceps…';

  @override String get measurementsDoneToday => "Mesures enregistrées aujourd'hui";

  @override String get proteins => 'Protéines';

  @override String get carbs => 'Glucides';

  @override String get fats => 'Lipides';



  // ── Scan ────────────────────────────────────────────────────────────────────

  @override String get analyzeMeal => 'Analyser un repas';

  @override String get scanSubtitle => 'Prenez une photo de votre repas pour obtenir son analyse nutritionnelle';

  @override String get loginRequired => 'Connexion requise — veuillez vous connecter';

  @override String get mealSaved => 'Repas enregistré';

  @override String get takePhoto => 'Prendre une photo';

  @override String get chooseGallery => 'Choisir depuis la galerie';

  @override String get addPhoto => 'Ajouter une photo';

  @override String get photoHint => 'Prenez ou importez une photo de votre repas';

  @override String get adjustPortion => 'Ajuster la portion';

  @override String get precisions => 'Précisions (optionnel)';

  @override String get precisionsHint => 'Décrivez votre repas pour améliorer l\'analyse';

  @override String get precisionsPlaceholder => 'Ex : poulet grillé avec riz blanc et légumes…';

  @override String get analyzing => 'Analyse en cours…';

  @override String get aiIdentification => 'Identification IA';

  @override String portionEstimated(int grams) => 'Portion estimée : $grams g';

  @override String get healthScore => 'Score santé';

  @override String get micronutrients => 'Micronutriments';

  @override String get tip => 'Conseil';

  @override String get iWillEat => 'Je vais manger';

  @override String get reanalyze => 'Réanalyser';

  @override String get newPhoto => 'Nouvelle photo';

  @override String get confirmEat => 'Confirmer la consommation ?';

  @override String get confirmEatButton => 'Oui, j\'ai mangé ça';

  @override String get fibers => 'Fibres';

  @override String get entirePlate => 'Assiette entière';

  @override String get halfPortion => 'Demi-portion';



  // ── Coach ───────────────────────────────────────────────────────────────────

  @override String get coachTitle => 'Coach IA';

  @override String get coachSubtitle => 'Votre assistant nutrition personnel';

  @override String get chatTab => 'Chat';

  @override String get dishesTab => 'Plats';

  @override String get planningTab => 'Planning';

  @override String planningRequired(String plan) => 'Plan $plan requis';

  @override String get whatYouGet => 'Ce que vous obtenez';

  @override String get aiDishes => 'Plats IA personnalisés';

  @override String get personalizedRecipes => 'Recettes adaptées à votre profil et régime';

  @override String get dietOptions9 => '9 régimes alimentaires disponibles';

  @override String get exactIngredients => 'Ingrédients pesés & macros calculés';

  @override String get dailyUpdate => 'Mis à jour chaque jour';

  @override String get planningTitle => 'Planning nutritionnel';

  @override String get planningDescription => 'Un plan sur 7 jours généré par l\'IA selon votre objectif';

  @override String get caloricTarget => 'Objectif calorique';

  @override String get adaptedToGoal => 'Adapté à votre objectif';

  @override String get dailyTips => 'Conseils quotidiens';

  @override String upgradePlan(String plan) => 'Passer en $plan';

  @override String get continueFreePlan => 'Continuer avec la version gratuite';

  @override String get dietRegime => 'Régime alimentaire';

  @override String generateRegime(String diet) => 'Générer des plats $diet';

  @override String generatingRegime(String diet) => 'Génération des plats $diet…';

  @override String get aiAdaptation => 'Adaptation IA';

  @override String get ingredients => 'Ingrédients';

  @override String get breakfast => 'Petit-déjeuner';

  @override String get lunch => 'Déjeuner';

  @override String get dinner => 'Dîner';

  @override String get weekPlanning => 'Planning de la semaine';

  @override String get generatingPlanning => 'Génération du planning…';

  @override String get dayDetail => 'Détail du jour';

  @override String get regenerate => 'Régénérer';

  @override String get noPlanning => 'Aucun planning généré';

  @override String get pressToRegenerate => 'Appuyez pour générer votre planning';

  @override String todayKcalInfo(int kcal, int remaining) => '$kcal kcal aujourd\'hui · $remaining restants';

  @override String get noMessagesYet => 'Aucun message pour l\'instant';

  @override String get typingMessage => 'Écrivez un message…';

  @override String coachWelcome(String name) => 'Bonjour $name ! Je suis votre coach nutrition IA. Comment puis-je vous aider ?';



  // ── Settings ────────────────────────────────────────────────────────────────

  @override String get myAccount => 'Mon compte';

  @override String get logout => 'Déconnexion';

  @override String get logoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override String get logoutCancel => 'Annuler';

  @override String get logoutConfirmButton => 'Déconnecter';

  @override String get userLabel => 'Utilisateur';

  @override String get information => 'Informations';

  @override String get name => 'Nom';

  @override String get emailLabel => 'Email';

  @override String get phoneLabel => 'Téléphone';

  @override String get countryLabel => 'Pays';

  @override String get subscription => 'Abonnement';

  @override String get freeLabel => 'Gratuit';

  @override String get loggingOut => 'Déconnexion…';

  @override String get language => 'Langue';

  @override String get chooseLanguage => 'Choisir la langue';



  // ── Profile ─────────────────────────────────────────────────────────────────

  @override String get myProfile => 'Mon profil';

  @override String get bmi => 'IMC';

  @override String get bmiUnderweight => 'Insuffisant';

  @override String get bmiNormal => 'Normal';

  @override String get bmiOverweight => 'Surpoids';

  @override String get bmiObese => 'Obésité';

  @override String get objective => 'Objectif';

  @override String kcalPerDayValue(int v) => '$v kcal/j';

  @override String get identity => 'Identité';

  @override String get gender => 'Sexe';

  @override String get male => 'Homme';

  @override String get female => 'Femme';

  @override String get age => 'Âge';

  @override String get weight => 'Poids (kg)';

  @override String get height => 'Taille (cm)';

  @override String get bodyMeasurements => 'Mesures corporelles';

  @override String get bodyMeasurementsHintProfile => 'Optionnel — pour suivre vos progrès';

  @override String get waist => 'Tour de taille (cm)';

  @override String get biceps => 'Biceps (cm)';

  @override String get belly => 'Tour de ventre (cm)';

  @override String get weightGoal => 'Objectif';

  @override String get loseWeight => 'Perdre du poids';

  @override String get gainMass => 'Prendre de la masse';

  @override String get maintain => 'Maintenir';

  @override String get eatHealthy => 'Manger sainement';

  @override String get lossRhythm => 'Rythme de perte';

  @override String get gainRhythm => 'Rythme de prise';

  @override String get soft => 'Doux';

  @override String get moderate => 'Modéré';

  @override String get sustained => 'Soutenu';

  @override String get intense => 'Intense';

  @override String get lean => 'Lean';

  @override String get aggressive => 'Agressif';

  @override String get aggressiveWarning => 'Rythme agressif — peut entraîner une perte musculaire. Consultez un professionnel.';

  @override String get activityLevel => "Niveau d'activité";

  @override String get saveProfile => 'Sauvegarder le profil';

  @override String get goPremium => 'Passer Premium';

  @override String get appInfo => 'Informations app';

  @override String get version => 'Version';



  // ── Onboarding ──────────────────────────────────────────────────────────────

  @override String get configureProfile => 'Configurer mon profil →';

  @override String get profileTitle => 'Votre profil';

  @override String get profileSubtitle => 'Ces informations permettent de calculer vos besoins caloriques.';

  @override String get yourFirstName => 'Votre prénom';

  @override String get firstNameEx => 'Ex: Marie';

  @override String get genderLabel => 'Genre';

  @override String get goalLabel => 'Votre objectif';

  @override String get goalQuestion => 'Quel est votre objectif principal ?';

  @override String get rhythmLabel => 'Rythme souhaité (kg/semaine)';

  @override String get bodyMeasurementsLabel => 'Mesures corporelles (optionnel)';

  @override String get activityDiet => 'Activité & régime';

  @override String get activityLevelLabel => "Niveau d'activité";

  @override String get dietLabel => 'Régimes alimentaires (optionnel)';

  @override String get welcome => 'Bienvenue sur DietVision';

  @override String get welcomeSubtitle => "Votre coach nutrition & fitness alimenté par l'IA.\nAnalysez vos repas, suivez vos macros et atteignez vos objectifs.";

  @override String get createProfile => 'Créer mon profil';

  @override String get continueButton => 'Continuer →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Atteignez vos objectifs\nplus vite avec Premium';

  @override String get paywallSubtitle => "Tout ce dont vous avez besoin, dans une seule app.";

  @override String get choosePlan => 'Choisissez votre plan';

  @override String get unlimitedScan => 'Scan IA illimité';

  @override String get featureSubScan => 'Analyse tout repas en 3 secondes';

  @override String get personalizedCoach => 'Coach IA personnalisé';

  @override String get featureSubCoach => 'Conseils adaptés à votre profil';

  @override String get nutritionPlanning => 'Planning nutritionnel';

  @override String get featureSubPlanning => '7 jours générés par l\'IA';

  @override String get customRecipes => 'Recettes sur mesure';

  @override String get featureSubRecipes => 'Ingrédients pesés & macros calculés';

  @override String get progressTracking => 'Suivi de progression';

  @override String get featureSubProgress => 'Courbes & tendances sur le long terme';

  @override String get dailyReminders => 'Rappels quotidiens';

  @override String get featureSubReminders => 'Motivation chaque matin';

  @override String get perMonth => '/ mois';

  @override String get rating => '4.8 / 5 — Plus de 2 000 utilisateurs';

  @override String get freeTrial => 'Essai gratuit';

  @override String get continueFreePlanLabel => 'Continuer avec la version gratuite';

  @override String get noCommitment => 'Sans engagement · Annulable à tout moment';

  @override String get accountRequired => 'Compte requis';

  @override String get accountRequiredDesc => "Pour vous abonner, créez un compte gratuit en 30 secondes.\n\nVous pourrez choisir votre plan juste après.";

  @override String get createAccountButton => 'Créer un compte';

  @override String get premiumMonthly => 'Premium Mensuel';

  @override String get premiumYearly => 'Premium Annuel';

  @override String get save40 => 'ÉCONOMISEZ 40%';



  // ── Progress ─────────────────────────────────────────────────────────────────

  @override String get progressTitle => 'Progression';

  @override String mealsAndEntries(int meals, int entries) => '$meals repas · $entries mesures';

  @override String get measurementsOk => 'Mesures OK';

  @override String get todayLabel => "Aujourd'hui";

  @override String get mealsTab => 'Repas';

  @override String get bodyTab => 'Corps';

  @override String get todayMeasurements => "Mesures du jour";

  @override String get fillAvailable => 'Remplissez les champs disponibles';

  @override String get noMeasurements => 'Aucune mesure';

  @override String get addFirstMeasures => 'Ajoutez vos premières mesures';

  @override String get lastMeasurements => 'Dernières mesures';

  @override String get projectionGoal => 'Projection vers l\'objectif';

  @override String get onTrack => 'En bonne voie';

  @override String get late => 'En retard';

  @override String get wrongDirection => 'Mauvaise direction';

  @override String get accomplished => 'Accompli';

  @override String get estimatedDate => 'Date estimée';

  @override String get currentRhythm => 'Rythme actuel';

  @override String get reverseTrend => 'Inverser la tendance';

  @override String get stable => 'Stable';

  @override String get in1Week => 'Dans 1 semaine';

  @override String inXWeeks(int n) => 'Dans $n semaines';

  @override String get goalReached => 'Objectif atteint !';

  @override String get weightGoingWrong => 'Le poids évolue dans le mauvais sens';

  @override String get noMeals => 'Aucun repas';

  @override String get scanFirst => 'Scannez votre premier repas pour commencer';

  @override String get fullHistory => 'Historique complet';

  @override String get saveMeasurements => 'Enregistrer les mesures';



  // ── Consent ─────────────────────────────────────────────────────────────────

  @override String get beforeStart => 'Avant de commencer';

  @override String get privacyTitle => 'Politique de confidentialité & CGU';

  @override String get rgpdLabel => 'RGPD';

  @override String get officialDoc => '↗ Document officiel';

  @override String get scrollToAccept => "Lisez jusqu'en bas pour accepter";

  @override String get dataCollected => 'Données collectées';

  @override String get legalBasis => 'Base légale du traitement';

  @override String get purposes => 'Finalités du traitement';

  @override String get subprocessors => 'Sous-traitants & transferts';

  @override String get retention => 'Durée de conservation';

  @override String get yourRights => 'Vos droits (RGPD)';

  @override String get security => 'Sécurité';

  @override String get controller => 'Responsable du traitement';

  @override String get iAccept => "J'ai lu et j'accepte la politique de confidentialité et les conditions générales d'utilisation de DietVision.";

  @override String get refuseButton => 'Refuser';

  @override String get acceptButton => 'Accepter et continuer';

  @override String get scrollToBottom => "Faites défiler jusqu'en bas pour activer l'acceptation";

  @override String get leaveApp => "Quitter l'application";

  @override String get leaveAppDesc => "Sans accepter la politique de confidentialité, vous ne pouvez pas utiliser DietVision. Voulez-vous quitter l'application ?";

  @override String get youReachedEnd => 'Vous avez atteint la fin du document';



  // ── Splash ──────────────────────────────────────────────────────────────────

  @override String get tagline => 'MANGE · SCANNE · PROGRESSE';



  // ── Subscription ────────────────────────────────────────────────────────────

  @override String get premiumTitle => 'Premium';

  @override String get goPremiumButton => 'Passer Premium';

  @override String get premiumDesc => 'Débloquez toutes les fonctionnalités';

  @override String get paymentReady => 'Votre paiement sécurisé est prêt.';

  @override String get paymentMethods => 'Visa, Mastercard, Apple Pay acceptés. Un champ code promo est disponible sur la page de paiement.';

  @override String get promoCode => 'Un code promo ? Saisissez-le directement sur la page de paiement Stripe.';

  @override String get payNow => 'Payer maintenant';

  @override String get openingBrowser => 'Finalisez votre paiement dans le navigateur, puis revenez ici.';

  @override String get iHavePaid => "J'ai payé — Confirmer";

  @override String get reopenPayment => 'Réouvrir la page de paiement';

  @override String get securedByStripe => 'Paiement sécurisé Stripe · TLS 256-bit';

  @override String get subscriptionActive => 'Abonnement activé !';

  @override String get subscriptionActiveDesc => 'Votre abonnement est actif.\nProfitez de toutes vos fonctionnalités sans restriction !';

  @override String get start => 'Commencer';

  @override String get noPlanAvailable => 'Aucun plan disponible.';

  @override String get securityNote => 'Paiement sécurisé Stripe · TLS 256-bit';

  @override String savePercent(int p) => 'ÉCONOMISEZ $p%';

  @override String get notAvailableYet => "Ce plan n'est pas encore disponible.";

  @override String cannotOpenBrowser(String e) => "Impossible d'ouvrir le navigateur : $e";

  @override String get paymentUnconfirmed => 'Paiement non confirmé — si vous venez de payer, attendez quelques secondes et réessayez.';

  @override String subscribePlan(String price) => 'Commencer — $price';

  @override String get comingSoon => 'Bientôt disponible';

  @override String get cannotLoadPlans => 'Impossible de charger les plans';



  // ── Diets ───────────────────────────────────────────────────────────────────

  @override String get dietOmnivore => 'Omnivore';

  @override String get dietHalal => 'Halal';

  @override String get dietVegetarian => 'Végétarien';

  @override String get dietVegan => 'Vegan';

  @override String get dietKeto => 'Kéto';

  @override String get dietMediterranean => 'Méditerranéen';

  @override String get dietGlutenFree => 'Sans gluten';

  @override String get dietPaleo => 'Paléo';

  @override String get dietDairy => 'Sans lactose';

  @override String get dietHighProtein => 'Riche en protéines';

  @override String get dietLowCalorie => 'Faible en calories';



  // ── Coach extras ─────────────────────────────────────────────────────────────

  @override String get dietFromProfile => 'Régime déduit de votre profil';

  @override String get generating => 'Génération…';

  @override String get actualize => 'Actualiser';

  @override String get typing => 'En train de répondre…';

  @override String generateDishes(String diet) => 'Plats $diet';

  @override String get generateDishesDesc => 'L\'IA génère 3 recettes sur-mesure adaptées\nà votre profil, vos calories restantes\net le régime sélectionné.';

  @override String planAvailableWith(String plan) => 'Disponible avec le plan $plan';

  @override String get planAvailableWithProOrPremium => 'Disponible avec le plan Pro ou Premium';

  @override String get currentPlanLabel => 'Plan actuel';

  @override String get freePlanLabel => 'Gratuit';



  // ── Day names (short) ────────────────────────────────────────────────────────

  @override String get dayMon => 'Lun';

  @override String get dayTue => 'Mar';

  @override String get dayWed => 'Mer';

  @override String get dayThu => 'Jeu';

  @override String get dayFri => 'Ven';

  @override String get daySat => 'Sam';

  @override String get daySun => 'Dim';



  // ── Day names (full) ─────────────────────────────────────────────────────────

  @override String get dayMonFull => 'Lundi';

  @override String get dayTueFull => 'Mardi';

  @override String get dayWedFull => 'Mercredi';

  @override String get dayThuFull => 'Jeudi';

  @override String get dayFriFull => 'Vendredi';

  @override String get daySatFull => 'Samedi';

  @override String get daySunFull => 'Dimanche';



  // ── Chat suggestions ─────────────────────────────────────────────────────────

  @override String get suggestion1 => 'Propose un plan repas pour demain';

  @override String get suggestion2 => 'Quels aliments pour prendre de la masse ?';

  @override String get suggestion3 => 'Mon bilan nutritionnel de la semaine';

  @override String get suggestion4 => 'Meilleurs snacks post-workout';



  // ── Body measurements extras ──────────────────────────────────────────────────

  @override String get chest => 'Tour de poitrine';

  @override String get hips => 'Tour de hanches';

  @override String get thighs => 'Tour de cuisse';



  // ── Activity levels ─────────────────────────────────────────────────────────

  @override String get activitySedentary => 'Sédentaire';

  @override String get activityLight => 'Léger (1-2j/sem)';

  @override String get activityModerate => 'Modéré (3-4j/sem)';

  @override String get activityActive => 'Actif (5-6j/sem)';

  @override String get activityVeryActive => 'Très actif';



  // ── Dashboard extras ─────────────────────────────────────────────────────────

  @override String get kcalRemaining => 'kcal restantes';

  @override String get kcalExceeded => 'kcal en excès';



  // ── Subscription gate ─────────────────────────────────────────────────────────

  @override String get trialExpiredTitle => 'Votre essai a expiré';

  @override String get trialExpiredSubtitle => 'Abonnez-vous pour continuer à utiliser DietVision et accéder à toutes les fonctionnalités.';

  @override String get alreadyPaidCheck => 'Déjà payé ? Vérifier mon abonnement';

  @override String get noActiveSubscription => 'Aucun abonnement actif trouvé.';

  @override String get checkingSubscription => 'Vérification en cours…';



  // ── Plan card labels ──────────────────────────────────────────────────────────

  @override String get yourCurrentPlan => 'VOTRE PLAN ACTUEL';

  @override String get trialExpiredToday => "Essai expiré aujourd'hui";

  @override String trialExpiredDaysAgo(int days) => 'Essai expiré il y a $days j.';

  @override String trialDaysRemaining(int days) => days == 1 ? 'Essai : encore 1 jour â³' : 'Essai : encore $days jours â³';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Mensuel';

  @override String get billingQuarterly => '3 mois';

  @override String get billingSemiAnnual => '6 mois';

  @override String get billingYearly => 'Annuel';

  @override String get bestOffer => 'ðŸ† Meilleure offre';

  @override String savingPerMonth(String amt) => '-$amt/mois';

  @override String perDay(String amt) => '$amt/jour';

  @override String get lessThanCoffee => 'Moins qu\'un café ☕';

  @override String get guarantee30Days => 'Satisfait ou remboursé 30 jours';

  @override String get specialOffer => 'ðŸŽ OFFRE SPÉCIALE';

  @override String offerExpiresIn(int h, int m) => 'Expire dans ${h}h ${m}min';

  @override String get trialSummaryTitle => 'Ce que vous avez accompli';

  @override String mealsScannedCount(int n) => '$n repas scannés';

  @override String get scanUpsellTitle => 'Analyse réussie ! 🎉';

  @override String get scanUpsellBody => 'Passez au plan Pro pour des analyses illimitées et des recommandations IA personnalisées.';

  @override String get upgradeNow => 'Voir les offres';

  @override String get notNow => 'Pas maintenant';

  @override String annualSavingsBanner(String amt) => 'ðŸŽ Économisez $amt avec l\'annuel';

  @override String get trialNotifJ7 => 'Encore 7 jours d\'essai';

  @override String get trialNotifJ7Body => 'Profitez-en encore 7 jours — ensuite choisissez le plan qui vous convient.';

  @override String get trialNotifJ3 => 'Plus que 3 jours !';

  @override String get trialNotifJ3Body => 'Offre spéciale : -40% sur l\'abonnement annuel. À saisir maintenant !';

  @override String get trialNotifJ1 => 'Dernier jour d\'essai 🔔';

  @override String get trialNotifJ1Body => 'Votre essai expire demain. Ne perdez pas votre progression !';



  // ── Payment verification ───────────────────────────────────────────────────────

  @override String get verifyingPayment => 'Vérification du paiement…';

  @override String get stepPaymentConfirmed => 'Paiement confirmé ✓';

  @override String get stepServerNotified => 'Serveur notifié ✓';

  @override String get stepInvoiceSent => 'Facture envoyée par email ✓';

  @override String get paymentVerifiedTitle => 'Abonnement activé !';

  @override String get paymentVerifiedDesc => 'Votre abonnement est actif. Une facture a été envoyée à votre adresse email. Profitez de toutes les fonctionnalités !';

  @override String get serverNotYetNotified => "Le serveur n'a pas encore reçu la confirmation. Patientez quelques secondes et réessayez.";

  @override String get retryVerification => 'Réessayer la vérification';

  @override String webhookPolling(int attempt, int max) => 'Vérification serveur… tentative $attempt/$max';

  @override String get webhookNotReceived => 'Le serveur n\'a pas reçu le webhook Stripe après plusieurs tentatives.';

  @override String get webhookReceived => 'Webhook Stripe reçu et traité ✓';



  // -- Email verification

  @override String get verifyEmailTitle => 'Vérifiez votre email';

  @override String get verifyEmailDesc => 'Nous avons envoyé un code à 6 chiffres à';

  @override String get verifyCode => 'Vérifier le code';

  @override String get resendCode => 'Renvoyer le code';

  @override String get skipForNow => "Revenir";

  @override String get checkSpam => "Vérifiez aussi vos spams si vous ne trouvez pas l'email.";


  // -- Password strength & forgot password
  @override String get passwordNeedsUppercase => 'Doit contenir au moins une majuscule';
  @override String get passwordNeedsNumberOrSymbol => 'Doit contenir au moins un chiffre ou caractère spécial';
  @override String get forgotPassword => 'Mot de passe oublié ?';
  @override String get forgotPasswordTitle => 'Mot de passe oublié';
  @override String get forgotPasswordDesc => 'Saisissez votre adresse email. Nous vous enverrons un code à 6 chiffres pour réinitialiser votre mot de passe.';
  @override String get sendResetCode => 'Envoyer le code';
  @override String get resetPasswordTitle => 'Nouveau mot de passe';
  @override String get resetPasswordDesc => 'Saisissez le code reçu par email et choisissez un nouveau mot de passe.';
  @override String get newPassword => 'Nouveau mot de passe';
  @override String get resetPassword => 'Réinitialiser le mot de passe';
  @override String get passwordResetSuccess => 'Mot de passe réinitialisé !';
  @override String get passwordResetSuccessDesc => 'Votre mot de passe a été modifié avec succès. Vous pouvez maintenant vous connecter.';
}



