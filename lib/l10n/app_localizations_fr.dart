import 'app_localizations.dart';



class AppLocalizationsFr extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Accueil';

  @override String get navScan => 'Scanner';

  @override String get navCoach => 'Diet Coach';

  @override String get navProgress => 'Progrès';

  @override String get navProfile => 'Profil';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Votre coach nutrition IA';

  @override String get sessionExpired => 'Session terminée';

  @override String get reconnect => 'Se reconnecter';

  @override String get cancel => 'Annuler';

  @override String get confirm => 'Confirmer';

  @override String get save   => 'Enregistrer';
  @override String get change => 'Changer';

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

  @override String get birthDate         => 'Date de naissance';
  @override String get birthDateHint     => 'JJ/MM/AAAA';
  @override String get underageTitle     => 'Accès limité';
  @override String get underageBody      => 'DietVision est réservé aux personnes âgées de 15 ans et plus.\n\nSi tu as moins de 15 ans, l\'utilisation de cette application nécessite le consentement d\'un parent ou tuteur légal.\n\nDemande à un adulte de créer un compte et de t\'accompagner dans ton suivi nutritionnel.';
  @override String get underageButton    => 'J\'ai compris';



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

  @override String get measurementsDoneToday        => "Mesures enregistrées aujourd'hui";
  @override String get bodyMeasurementsSubtitle     => 'Poids · Tour de taille · Biceps';
  @override String get syncedLabel                  => 'Données à jour';
  @override String get stayFocused                  => 'Reste focus, chaque action compte !';
  @override String get dailyProgress                => 'Progression\ndu jour';

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

  @override String get camera => 'Caméra';
  @override String get gallery => 'Galerie';
  @override String get photoTipsTitle => 'CONSEILS PHOTO';
  @override String get tipFramePlate => 'Cadrer l\'assiette';
  @override String get tipGoodLight => 'Bonne lumière';
  @override String get tipTopView => 'Vue du dessus';
  @override String get tipVisibleFood => 'Aliment visible';
  @override String get tipFullPlate => 'Tout le plat';
  @override String get tipNoFlash => 'Éviter le flash';

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

  // Scan — text tab
  @override String get scanTabPhoto        => 'Photo';
  @override String get scanTabText         => 'Texte';
  @override String get scanTextSubtitle    => 'Ajoutez une photo ou décrivez votre repas pour obtenir son analyse nutritionnelle';
  @override String get describeMeal        => 'Décrire un repas';
  @override String get describeMealHint    => 'Vous avez oublié la photo ? Décrivez votre repas et indiquez une portion approximative.';
  @override String get mealNameLabel       => 'Nom du repas';
  @override String get mealNamePlaceholder => 'Ex : Riz, poulet, légumes, sauce';
  @override String get portionQtyLabel     => 'Portion / quantité';
  @override String get portionQtyPlaceholder => 'Ex : 1 assiette, 250 g, 2 morceaux';
  @override String get mealTypeLabel       => 'Type de repas';
  @override String get precisionTip        => 'Astuce : plus votre description est précise, meilleure sera l\'estimation.';
  @override String get switchToPhoto       => 'Prendre une photo à la place';
  @override String get forgotPhotoTip      => 'Vous avez oublié la photo ? Utilisez l\'onglet Texte pour ajouter le repas plus tard.';

  @override String get entirePlate =>'Assiette entière';

  @override String get halfPortion => 'Demi-portion';



  // ── Coach ───────────────────────────────────────────────────────────────────

  @override String get coachTitle => 'Diet Coach';

  @override String get coachSubtitle => 'Votre assistant nutrition personnel';

  @override String get chatTab => 'Chat';

  @override String get dishesTab => 'Plats';
  @override String get dishesPlanRequired => 'Les plats recommandés sont disponibles à partir du plan Pro.';
  @override String get dishesLimitReached => 'Limite de plats atteinte pour aujourd\'hui. Revenez demain ou passez au plan supérieur.';

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
  @override String get restrictionVegetarian => 'Végétarien';
  @override String get restrictionVegan      => 'Vegan';
  @override String get restrictionGlutenFree => 'Sans gluten';
  @override String get restrictionLactoseFree=> 'Sans lactose';
  @override String get restrictionHalal      => 'Halal';
  @override String get restrictionKeto       => 'Keto';

  @override String get welcome => 'Bienvenue sur DietVision';

  @override String get welcomeSubtitle => "Votre coach nutrition & fitness alimenté par l'IA.\nAnalysez vos repas, suivez vos macros et atteignez vos objectifs.";

  @override String get createProfile => 'Créer mon profil';

  @override String get continueButton => 'Continuer →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Atteignez vos objectifs\nplus vite avec Premium';

  @override String get paywallSubtitle => "Tout ce dont vous avez besoin, dans une seule app.";

  @override String get chipMealScan       => 'Scan repas';
  @override String get chipMacroTracking  => 'Suivi macros';
  @override String get chipAiCoach        => 'Coach IA';
  @override String get paywallFeaturesPrefix    => 'Tout ce dont\nvous avez besoin\npour ';
  @override String get paywallFeaturesHighlight => 'réussir';
  @override String get paywallFeaturesSubtitle  => 'Des outils intelligents pour atteindre vos objectifs nutritionnels.';
  @override String get paywallPlanPrefix    => 'Choisissez\nvotre ';
  @override String get paywallPlanHighlight => 'plan';
  @override String get paywallPlanSubtitle  => 'Commencez votre essai gratuit. Annulable à tout moment.';

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

  @override String get perMonth   => '/ mois';
  @override String get perYear    => '/ an';
  @override String get perQuarter => '/ trim.';
  @override String get per6Months => '/ 6 mois';

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
  @override String get kcalExceeded  => 'kcal en excès';
  @override String get kcalOver      => 'kcal de trop';

  // ── Context Day Card ─────────────────────────────────────────────────────────
  @override String get protLow       => 'faibles';
  @override String get protModerate  => 'modérées';
  @override String get protGood      => 'bonnes';
  @override String get goalWeightLoss => 'perte de poids';
  @override String get goalMassGain  => 'prise de masse';
  @override String get goalMaintain  => 'maintien';
  @override String get labelProteins => 'Protéines';
  @override String get labelGoal     => 'Objectif :';
  @override String get labelDiet     => 'Régime :';
  @override String ctxDescSurplus(int surplus) => 'Vous êtes en surplus de +$surplus kcal. Je peux vous proposer des plats légers pour équilibrer votre journée.';
  @override String get ctxDescLowProt => 'Votre apport en protéines est faible. Je peux vous aider à rééquilibrer vos macros.';
  @override String get ctxDescDefault => 'Je peux vous aider à construire votre journée selon vos calories restantes et votre objectif.';

  // ── Smart Actions labels ──────────────────────────────────────────────────────
  @override String get smartBuildDay        => 'Construis ma journée';
  @override String smartBuildDaySub(int k)  => 'avec $k kcal restantes';
  @override String smartSurplusTitle(int k)  => 'Surplus +$k kcal';
  @override String get smartSurplusSub      => 'Comment équilibrer ?';
  @override String get smart3Dishes         => 'Donne-moi 3 plats';
  @override String get smart3DishesSub      => 'riches en protéines';
  @override String get smartAnalyzeBilan    => 'Analyse mon bilan';
  @override String get smartAnalyzeBilanSub => 'nutritionnel de la semaine';
  @override String get smartPrepareDinner   => 'Prépare mon dîner';
  @override String get smartPrepareDinnerSub => 'de ce soir';

  // ── Pro gate ─────────────────────────────────────────────────────────────────
  @override String get gateDishesAdaptedRecipes    => 'Recettes adaptées\nà votre profil\net régime';
  @override String get gateDishes9Diets            => '9 régimes\nalimentaires\ndisponibles';
  @override String get gateDishesWeighedIngredients => 'Ingrédients pesés\n& macros\ncalculés';
  @override String get gateDishesUpdatedDaily      => 'Mis à jour\nchaque jour';
  @override String get tableHeaderFeatures         => 'Fonctionnalités';
  @override String get tableRowPersonalizedDishes  => 'Plats IA personnalisés';
  @override String get tableRowAdaptedRecipes      => 'Recettes adaptées à votre profil';
  @override String get tableRowWeighedIngredients  => 'Ingrédients pesés & macros calculés';
  @override String get tableRowUpdatedDaily        => 'Mis à jour chaque jour';

  // ── Premium gate ─────────────────────────────────────────────────────────────
  @override String get gatePlanningWeekPlan    => 'Un plan sur 7 jours\ngénéré par l\'IA\nselon votre objectif';
  @override String get gatePlanningCaloricGoal => 'Objectif calorique\net macros\ncalculés';
  @override String get gatePlanningAdapted     => 'Adapté à\nvotre objectif';
  @override String get gatePlanningDailyTips   => 'Conseils quotidiens\n& suivi intelligent';
  @override String get planStarterSubtitle     => 'Fonctions de base';
  @override String get planProSubtitle         => 'Recettes & régimes IA';
  @override String get planPremiumSubtitle     => 'Planning nutritionnel IA';
  @override String get planIncluded            => 'Inclus';
  @override String get planNotIncluded         => 'Planning non inclus';

  // ── Quick tips ────────────────────────────────────────────────────────────────
  @override String get tipScanFirstMeal  => 'Commencez par scanner votre premier repas pour que je puisse analyser vos macros du jour.';
  @override String get tipIncreaseProtein => 'Priorité aujourd\'hui : augmenter vos protéines au prochain repas.';
  @override String tipCaloriesAvailable(int pct) => 'Vous avez encore $pct% de vos calories disponibles. Pensez à votre prochain repas !';
  @override String get tipCaloriesExceeded => 'Objectif calorique dépassé. Misez sur des aliments légers et riches en fibres ce soir.';
  @override String get tipKeepGoing       => 'Continuez sur cette lancée ! Votre journée est bien équilibrée — gardez le cap.';
  @override String get newChat => 'Nouvelle conversation';
  @override String get clearChatTitle => 'Effacer la conversation ?';
  @override String get clearChatConfirm => 'L\'historique du chat sera supprimé définitivement.';
  @override String get clearChatConfirmBtn => 'Effacer';
  @override String promptCreatePlanSurplus(int surplus, String diet) => "Je suis en surplus de +$surplus kcal aujourd'hui. Aide-moi à équilibrer le reste de ma journée avec mon régime $diet.";
  @override String promptCreatePlanNormal(int remaining, String diet) => "Crée mon plan alimentaire pour aujourd'hui avec $remaining kcal restantes et mon régime $diet.";
  @override String get promptFixMacros => "Analyse et corrige mes macros d'aujourd'hui. Donne-moi des conseils concrets pour équilibrer protéines, glucides et lipides.";
  @override String get promptAnalyzeProgress => "Analyse mes progrès nutritionnels de la semaine et donne-moi 3 conseils personnalisés pour m'améliorer.";
  @override String promptSurplusBalance(int surplus, int tdee) => "Je suis en surplus de +$surplus kcal aujourd'hui (objectif $tdee kcal/jour). Donne-moi des conseils pour équilibrer ma journée et limiter les effets du surplus.";
  @override String promptBuildDay(int remaining, String diet) => "Construis-moi un plan de repas complet pour aujourd'hui avec $remaining kcal restantes, adapté à mon régime $diet et à mes objectifs.";
  @override String prompt3Dishes(String diet) => "Propose-moi 3 plats riches en protéines (minimum 30g par plat) adaptés à mon régime $diet.";
  @override String get promptAnalyzeBilan => "Analyse mon bilan nutritionnel de la semaine et donne-moi des conseils concrets pour m'améliorer.";
  @override String promptDinnerSurplus(int surplus, int tdee, String diet) => "Je suis en surplus de +$surplus kcal aujourd'hui (objectif $tdee kcal/jour). Propose-moi un repas léger pour ce soir adapté à mon régime $diet.";
  @override String promptDinnerNormal(int remaining, String diet) => "Propose-moi un repas pour ce soir qui correspond à mes $remaining kcal restantes et à mon régime $diet.";

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

  @override String trialDaysRemaining(int days) => days == 1 ? 'Essai : encore 1 jour ' : 'Essai : encore $days jours ';
  @override String get statusActive => 'Actif';
  @override String get statusInactive => 'Inactif';
  @override String get verifiedFromServer => 'Vérifié depuis le serveur';
  @override String get localCache => 'Cache local';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Mensuel';

  @override String get billingQuarterly => '3 mois';

  @override String get billingSemiAnnual => '6 mois';

  @override String get billingYearly => 'Annuel';

  @override String get bestOffer => 'Meilleure offre';

  @override String savingPerMonth(String amt) => '-$amt/mois';

  @override String perDay(String amt) => '$amt/jour';

  @override String get lessThanCoffee => 'Moins qu\'un café ☕';

  @override String get guarantee30Days => 'Satisfait ou remboursé 30 jours';

  @override String get specialOffer => 'OFFRE SPÉCIALE';

  @override String offerExpiresIn(int h, int m) => 'Expire dans ${h}h ${m}min';

  @override String get trialSummaryTitle => 'Ce que vous avez accompli';

  @override String mealsScannedCount(int n) => '$n repas scannés';

  @override String get scanUpsellTitle => 'Analyse réussie ! 🎉';

  @override String get scanUpsellBody => 'Passez au plan Pro pour des analyses illimitées et des recommandations IA personnalisées.';

  @override String get upgradeNow => 'Débloquer l\'accès';

  @override String get notNow => 'Demain, c\'est bien';

  @override String get limitReachedTitle => 'Belle progression aujourd\'hui !';
  @override String limitReachedBody(String type, int limit) => type == 'chat'
      ? 'Vous avez utilisé vos $limit messages gratuits aujourd\'hui. Revenez demain pour continuer gratuitement, ou passez en Pro pour continuer maintenant.'
      : 'Vous avez utilisé vos $limit analyses gratuites aujourd\'hui. Revenez demain pour continuer gratuitement, ou passez en Pro pour continuer maintenant.';
  @override String limitUsedPill(int used, int total, String type) => type == 'chat'
      ? '$used / $total messages utilisés'
      : '$used / $total analyses utilisées';
  @override String get proScanFeature     => '50 scans photo IA / jour';
  @override String get proChatFeature     => '100 échanges coach IA / jour';
  @override String get premiumScanFeature => '150 scans photo IA / jour';
  @override String get premiumChatFeature => '200 échanges coach IA / jour';
  @override String get withProLabel      => 'Avec Pro';
  @override String get continueWithPro   => 'Continuer avec Pro';
  @override String get comeBackTomorrow  => 'Revenir demain';
  @override String get limitProFeature1  => 'Plus d\'analyses IA';
  @override String get limitProFeature2  => 'Plats IA personnalisés';
  @override String get limitProFeature3  => 'Conseils nutrition avancés';
  @override String get limitProFeature4  => 'Suivi plus complet';

  @override String annualSavingsBanner(String amt) => 'Économisez $amt avec l\'annuel';

  @override String get trialNotifJ7 => 'Encore 7 jours d\'essai';

  @override String get trialNotifJ7Body => 'Profitez-en encore 7 jours — ensuite choisissez le plan qui vous convient.';

  @override String get trialNotifJ3 => 'Plus que 3 jours !';

  @override String get trialNotifJ3Body => 'Offre spéciale : -40% sur l\'abonnement annuel. À saisir maintenant !';

  @override String get trialNotifJ1 => 'Dernier jour d\'essai 🔔';

  @override String get trialNotifJ1Body => 'Votre essai expire demain. Ne perdez pas votre progression !';



  // ── Weekly details sheet ─────────────────────────────────────────────────────

  @override String get weeklyDetails => 'Détails de la semaine';
  @override String get weeklySummaryTitle => 'Résumé hebdomadaire';
  @override String get avgKcalPerDay => 'Moyenne';
  @override String get targetKcalDay2 => 'Objectif';
  @override String get differenceKcal => 'Écart';
  @override String proteinTargetReached(int done, int total) => 'Objectif protéines atteint : $done/$total jours';
  @override String get statusOnTrack => 'En bonne voie';
  @override String get statusAttention => 'Attention';
  @override String get statusOffTrack => 'Hors objectif';
  @override String get statusNotStarted => 'Pas encore commencé';
  @override String get editThisDay => 'Modifier ce jour';
  @override String get replaceMeals => 'Remplacer les repas';
  @override String get copyThisDay => 'Copier ce jour';
  @override String get balanceWeek => 'Équilibrer la semaine';

  // ── AI Insight sheet ──────────────────────────────────────────────────────────

  @override String get insightAnalysisTitle => 'Analyse';
  @override String get insightWhyTitle => 'Pourquoi c\'est important';
  @override String get insightActionsTitle => 'Actions suggérées';
  @override String insightProteinAnalysis(int current, int target, int gap) =>
      'Votre objectif protéines aujourd\'hui est de $target g.\nVous êtes actuellement à $current g.\nIl vous manque environ $gap g de protéines.';
  @override String insightCaloriesAnalysis(int current, int target) =>
      'Vous avez consommé $current kcal sur votre objectif de $target kcal.';
  @override String get insightWhyProtein => 'Atteindre votre objectif protéines aide à préserver la masse musculaire, surtout pendant une perte de poids. Cela vous aide aussi à rester rassasié plus longtemps.';
  @override String get insightWhyCalories => 'Rester proche de votre objectif calorique est le facteur le plus important pour atteindre votre objectif de poids de manière régulière.';
  @override String get insightWhyWater => 'Une bonne hydratation soutient votre métabolisme, réduit la faim et aide votre corps à traiter les nutriments plus efficacement.';
  @override String get insightWhyCarbs => 'Gérer l\'apport en glucides aide à stabiliser la glycémie et à optimiser les niveaux d\'énergie tout au long de la journée.';
  @override String get insightWhyNoScan => 'Suivre vos repas vous aide à rester conscient de votre apport et facilite l\'atteinte de vos objectifs quotidiens.';
  @override String get insightAction1Protein => 'Yaourt grec + 2 œufs';
  @override String get insightAction1ProteinDetail => '280 kcal · 32 g protéines';
  @override String get insightAction2Protein => 'Ajouter 150 g de poulet au dîner';
  @override String get insightAction2ProteinDetail => '+240 kcal · +45 g protéines';
  @override String get insightIgnoreToday => 'Ignorer pour aujourd\'hui';
  @override String get applySuggestion => 'Appliquer la suggestion';
  @override String get showAlternatives => 'Voir les alternatives';
  @override String get remindMeLater => 'Me rappeler plus tard';

  // ── Progress forecast sheet ───────────────────────────────────────────────────

  @override String get progressForecast => 'Prévision de progression';
  @override String get projectionBasis => 'Cette projection est basée sur votre objectif calorique, votre activité estimée, votre apport en protéines et votre régularité actuelle.';
  @override String get conservativeScenario => 'Conservateur';
  @override String get balancedScenario => 'Équilibré';
  @override String get aggressiveScenario => 'Intensif';
  @override String get scenarioEasyToKeep => 'Plus facile à tenir';
  @override String get scenarioRecommended => 'Recommandé';
  @override String get scenarioHarder => 'Plus difficile — risque de faim élevé';
  @override String get useBalancedPlan => 'Utiliser le plan équilibré';
  @override String get makeItEasierPlan => 'Rendre plus facile';
  @override String get makeItFasterPlan => 'Accélérer';
  @override String get weekLabel => 'Semaine';
  @override String get estimatedWeight => 'Poids estimé';
  @override String get weightEvolution => 'Évolution';
  @override String get todayWeightLabel => 'Aujourd\'hui';

  // ── Planning tab ─────────────────────────────────────────────────────────────

  @override String get weeklyBalanceScore => 'SCORE HEBDOMADAIRE';
  @override String get onTrackThisWeek => 'Vous êtes sur la bonne voie !';
  @override String get greatConsistency => 'Excellente régularité. Continuez !';
  @override String get goodProgressPlan => 'Bonne progression, continuez !';
  @override String get aFewMoreEfforts => 'Encore quelques efforts et vous y serez.';
  @override String get stayConsistentPlan => 'Restez régulier cette semaine.';
  @override String get tryHitTargets => 'Essayez d\'atteindre vos objectifs quotidiens.';
  @override String get buildYourRoutine => 'Commencez à construire votre routine !';
  @override String get everyStepCounts => 'Chaque effort compte. Vous pouvez le faire !';
  @override String todayKcalRemainingLabel(int n) => 'Aujourd\'hui : $n kcal restantes';
  @override String get viewDetails => 'Voir les détails';
  @override String get todayChecklist => 'Checklist du jour';
  @override String completedOfTotal(int done, int total) => '$done/$total complétés';
  @override String get checkHitCalorie => 'Atteindre l\'objectif calorique';
  @override String get checkScan2Meals => 'Scanner 2 repas';
  @override String get checkProteinGoal => 'Objectif protéines atteint';
  @override String get checkWalk30 => 'Marcher 30 min';
  @override String get checkDrinkWater => 'Boire 2,5 L d\'eau';
  @override String get checkNoSugarAfter8pm => 'Pas de sucre après 20h';
  @override String get aiInsightTitle => 'Conseil IA';
  @override String get insightProteinLow => 'Les protéines sont légèrement insuffisantes aujourd\'hui. Ajoutez une collation riche en protéines ce soir.';
  @override String get insightCaloriesHigh => 'Vous approchez de votre limite calorique. Choisissez un dîner léger ce soir.';
  @override String get insightLackWater => 'N\'oubliez pas de boire de l\'eau. Visez 2,5 L aujourd\'hui.';
  @override String get insightTooManyCarbs => 'Apport en glucides élevé aujourd\'hui. Équilibrez avec plus de protéines et légumes.';
  @override String get insightNoScan => 'Aucun repas scanné aujourd\'hui. Commencez à tracker pour rester dans votre plan.';
  @override String get insightOnTrack => 'Tout va bien aujourd\'hui. Continuez ainsi et restez régulier !';
  @override String get weekProjectionTitle => 'Projection 4 semaines';
  @override String get projectionSubtitle => 'Résultat estimé si vous suivez ce plan';
  @override String get weightChangeLbl => 'Variation de poids';
  @override String get musclePreservedLbl => 'Préservé';
  @override String get muscleGrowingLbl => 'En croissance';
  @override String get muscleMaintainedLbl => 'Maintenu';
  @override String get energyStableLbl => 'Stable';
  @override String get adjustWeekBtn => 'Ajuster la semaine';
  @override String get adjustWeekSheetTitle => 'Comment souhaitez-vous ajuster ?';
  @override String get adjustLoseFaster => 'Je veux perdre du poids plus vite';
  @override String get adjustEasierPlan => 'Je veux un plan plus simple';
  @override String get adjustMoreProtein => 'Je veux plus de protéines';
  @override String get adjustFewerCarbs => 'Je veux moins de glucides';
  @override String get adjustCheaper => 'Je veux un plan moins cher';
  @override String get adjustLocal => 'Je veux des repas locaux';
  @override String get adjustFlexibleWeekend => 'Je veux un week-end plus flexible';
  @override String get notificationsTooltip => 'Notifications';

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

  // ── Dishes tab extras ────────────────────────────────────────────────────────
  @override String get suggestionDuMoment  => 'Suggestion du moment';
  @override String get personalizeLabel    => 'Personnaliser vos suggestions';
  @override String get mealObjectiveLabel  => 'Objectif du repas';
  @override String get chooseThisDish      => 'Choisir ce plat';
  @override String get filterQuick         => 'Rapide';
  @override String get filterBudget        => 'Petit budget';
  @override String get filterLowKcal       => '< 600 kcal';
  @override String get filterLowCarb       => 'Faible en glucides';
  @override String get filterSnack         => 'Collation';
  @override String get dishSelectedMsg     => 'Plat sélectionné !';
  @override String get preparationBtn        => 'Préparation';
  @override String get dishRecipeLabel       => 'RECETTE';
  @override String dishIngredientsSection(int n) => 'Ingrédients ($n)';
  @override String dishPrepStepsSection(int n)   => 'Étapes de préparation ($n)';
  @override String get trendRising           => '↑ En hausse';
  @override String get trendFalling          => '↓ En baisse';
  @override String get totalTodayLabel       => "Total aujourd'hui";
  @override String get mealsLoggedLabel      => 'Repas enregistrés';
  @override String get avgHealthScoreLabel   => 'Score santé moyen';
  @override String get veryGood             => 'Très bien';
  @override String get goodLabel            => 'Bien';
  @override String get fairLabel            => 'Passable';
  @override String kcalTargetValue(int n)   => 'Objectif $n kcal';
  @override String get contextDayTitle       => 'Contexte du jour';
  @override String get smartActionsTitle     => 'Actions intelligentes';
  @override String get viewAll               => 'Tout voir';
  @override String get quickTipLabel         => 'Conseil rapide';
  @override String get actionCreatePlan      => 'Créer mon plan';
  @override String get actionFixMacros       => 'Corriger mes macros';
  @override String get actionAnalyzeProgress => 'Analyser mes progrès';



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

  // ── Dashboard — Today Score & Quick Actions ──────────────────────────────────
  @override String get todayScore => 'Score du jour';
  @override String get ofDailyGoal => 'de l\'objectif';
  @override String get scoreScanFirstMeal => 'Lance-toi — scanne ton premier repas pour débloquer tes insights du jour.';
  @override String get addFoodLabel => 'Ajouter';
  @override String get askCoachLabel => 'Demander';
  @override String get dailyNutrition => 'Nutrition du jour';
  @override String get consumed => 'Consommé';
  @override String get nextMilestone => 'Prochain palier';
  @override String get completedFraction => 'faites';

  // ── Dashboard — Today Mission & AI Reco ──────────────────────────────────────
  @override String get readyToCrush => 'Prêt à crush tes objectifs ?';
  @override String get notifications => 'Notifications';
  @override String get todayMission => 'Mission du jour';
  @override String get seeDailyPlan => 'Voir mon plan du jour';
  @override String get completeDailyMeasures => 'Compléter les mesures du jour';
  @override String get dailyCheckIn => 'Check-in quotidien';
  @override String get toComplete => 'À compléter';
  @override String get completeNow => 'Compléter maintenant';
  @override String get checkInDone => 'Check-in complété !';
  @override String get dataUpToDate => 'Données à jour. La projection IA est plus précise.';
  @override String get aiRecommendation => 'Recommandation IA';
  @override String get viewMore => 'Voir plus';
  @override String get viewDishes => 'Voir plats';
  @override String get scanMeal => 'Scanner repas';
  @override String get adjustToday => "Ajuster aujourd'hui";
  @override String get aiRecNoScan => "Aucun repas scanné aujourd'hui. Commence le tracking pour rester dans ton plan.";
  @override String get aiRecProteinLow => 'Tes protéines sont basses. Ajoute un aliment riche en protéines à ton prochain repas.';
  @override String get aiRecCaloriesHigh => 'Tu approches ta limite calorique. Prévois un dîner léger ce soir.';
  @override String get aiRecOnTrack => "Tu es dans les clous ! Tout est parfait aujourd'hui. Continue comme ça.";
  @override String get objectifQuotidien => 'Objectif quotidien';

  // ── Gate PRO ─────────────────────────────────────────────────────────────────
  @override String get proGateBannerTitle  => 'Plan Pro requis';
  @override String get proGateBannerSub    => 'Débloquez des plats IA personnalisés';
  @override String get proGateChip         => 'Pro requis';
  @override String get proGateHeroTitle    => 'Plats IA personnalisés';
  @override String get proGateHeroAvail    => 'Disponible avec le plan Pro ou Premium';
  @override String get proGateHeroDesc     => 'Recevez chaque jour des repas pensés pour vous, adaptés à vos objectifs.';
  @override String get proGateCta         => 'Débloquer mes plats IA';
  @override String get cancelAnytime       => 'Annulation à tout moment';
  @override String get freeTrialDays       => 'Essai gratuit 7 jours';

  @override String get manageSubscription     => 'Gérer mon abonnement';
  @override String get manageSubscriptionDesc => 'Annuler, changer de carte, voir vos factures via le portail Stripe.';
  @override String get openingPortal          => 'Ouverture du portail…';
  @override String get portalError            => "Impossible d'ouvrir le portail. Réessayez.";

  // ── Dashboard i18n (tâches planning, milestone, compteurs) ──────────────────
  @override String get todoLabel => 'À FAIRE';
  @override String get doneLabel => '✓ FAIT';
  @override String get milestoneLabel => 'PALIER';
  @override String inDaysLabel(int n) => 'dans $n jours';
  @override String completedFractionLabel(int done, int total) => '$done / $total complétées';
  @override String kcalConsumedLabel(int kcal, int protein) => '$kcal kcal consommées · ${protein}g protéines';
  @override String get averageLabel => 'Moyenne';
  @override String get priorityLabel => 'Priorité : ';
  @override String get aiRecPriorityProtein => 'ajoute un repas riche en protéines au prochain scan.';

  // ── Coach screen i18n ────────────────────────────────────────────────────────
  @override String get planningNutritional => 'Planning nutritionnel';
  @override String get macroCalories => 'Calories';
  @override String get macroProtein => 'Protéines';
  @override String get macroCarbs => 'Glucides';
  @override String get macroFat => 'Lipides';
  @override String get percentReached => '% atteint';
  @override String get exceeded => 'dépassé';
  @override String get remaining => 'restants';

  // ── Onboarding i18n ─────────────────────────────────────────────────────────
  @override String get kgPerWeek => 'kg/sem';

  // ── Gate PREMIUM ──────────────────────────────────────────────────────────────
  @override String get premiumGateBannerTitle  => 'Plan Premium requis';
  @override String get premiumGateBannerSub    => 'Débloquez le planning nutritionnel personnalisé';
  @override String get premiumGateHeroAvail    => 'Disponible avec le plan Premium';
  @override String get premiumGateHeroDesc     => 'Un plan sur 7 jours généré par l\'IA, adapté à vos objectifs et à votre quotidien.';
  @override String get premiumGatePreviewTitle => 'Aperçu de votre futur planning';
  @override String get premiumGatePreviewLock  => 'Débloquez le planning complet et personnalisé';
  @override String get premiumGateCta         => 'Activer mon planning Premium';

  // ── Dishes tab ────────────────────────────────────────────────────────────────
  @override String dishesResultCount(int n) => '$n résultats';
  @override String get seeDetails   => 'Voir détails';
  @override String get dayBilan     => 'Bilan du jour';
  @override String get dayMeals     => 'Repas du jour';
  @override String get previewHint  => 'Aperçu — Génère pour voir tes plats personnalisés';
  @override String stepLabel(int n) => 'Étape $n';
  @override String get pillSubExcess => 'de trop';
  @override String get pillSubRemaining => 'restantes';
  @override String get pillSubDiet => 'Régime';
  @override String dishCountPillValue(int count) => '$count plat${count > 1 ? 's' : ''}';
  @override String get pillSubToGenerate => 'à générer';
  @override String filterCountPillValue(int count) => '$count filtre${count > 1 ? 's' : ''}';
  @override String pillSubActive(int count) => 'actif${count > 1 ? 's' : ''}';
  @override String smartSummaryDescSurplus(int surplus, int count) =>
      'Vous avez dépassé votre objectif de +$surplus kcal. L\'IA vous suggère $count plat${count > 1 ? 's' : ''} léger${count > 1 ? 's' : ''} pour équilibrer votre journée.';
  @override String smartSummaryDescNormal(int count, String diet) =>
      'L\'IA va vous proposer $count plat${count > 1 ? 's' : ''} $diet adaptés à vos calories restantes et à votre objectif nutritionnel.';
  @override String get orContinueWith => 'Ou continuer avec';
  @override String get socialAuthError => 'Erreur d\'authentification sociale';

  // ── Network / Error dialogs ──────────────────────────────────────────────────
  @override String get noConnectionTitle        => 'Pas de connexion';
  @override String get noConnectionBody         => 'Vérifiez votre connexion Internet et réessayez.';
  @override String get serverErrorTitle         => 'Erreur serveur';
  @override String get serverErrorBody          => 'Une erreur est survenue côté serveur. Réessayez dans quelques instants.';
  @override String get timeoutErrorTitle        => 'Connexion trop lente';
  @override String get timeoutErrorBody         => 'La requête a expiré. Vérifiez votre réseau et réessayez.';
  @override String get checkoutUnavailableTitle => 'Paiement indisponible';
  @override String get checkoutUnavailableBody  => 'Impossible de lancer le paiement. Vérifiez votre connexion et réessayez.';
  @override String get sessionExpiredDialogTitle => 'Session expirée';
  @override String get sessionExpiredDialogBody  => 'Votre session a expiré. Reconnectez-vous pour continuer.';

  // ── Onboarding welcome step ───────────────────────────────────────────────
  @override String get welcomeTo => 'Bienvenue sur';
  @override String get onboardingIntro => 'Avant de commencer, nous allons configurer\nvotre profil pour ';
  @override String get onboardingPersonalize => 'personnaliser votre expérience.';
  @override String get infoCardTitle => 'Vos informations';
  @override String get infoCardSubtitle => 'Âge, sexe, taille, poids';
  @override String get measuresCardTitle => 'Vos mesures';
  @override String get measuresCardSubtitle => 'Tour de taille, hanches, biceps…';
  @override String get objectivesCardTitle => 'Vos objectifs';
  @override String get objectivesCardSubtitle => 'Perte de poids, prise de masse ou maintien';
  @override String get aiNoteText => 'Cela ne prend que quelques instants et permet à l\'IA de vous proposer des ';
  @override String get aiNoteHighlight => 'recommandations adaptées.';
  @override String get nextStepLabel => 'Étape suivante : saisie de vos données';
}



