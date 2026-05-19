import 'package:flutter/material.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_en.dart';
import 'app_localizations_de.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('pt'),
  ];

  // ── Navigation ──────────────────────────────────────────────────────────────
  String get navHome;
  String get navScan;
  String get navCoach;
  String get navProgress;
  String get navProfile;

  // ── App général ─────────────────────────────────────────────────────────────
  String get appName;
  String get appSubtitle;
  String get sessionExpired;
  String get reconnect;
  String get cancel;
  String get confirm;
  String get save;
  String get retry;
  String get loading;
  String get error;
  String get later;
  String get quit;
  String get close;
  String get back;
  String get refresh;
  String get next;
  String get skip;
  String get accept;
  String get refuse;
  String get yes;
  String get no;
  String get optional;
  String get recommended;
  String get popular;

  // ── Auth ────────────────────────────────────────────────────────────────────
  String get signIn;
  String get createAccount;
  String get email;
  String get emailHint;
  String get emailRequired;
  String get emailInvalid;
  String get password;
  String get passwordHint;
  String get passwordRequired;
  String get passwordMin8;
  String get passwordNeedsUppercase;
  String get passwordNeedsNumberOrSymbol;
  String get confirmPassword;
  String get passwordMismatch;
  // Forgot password
  String get forgotPassword;
  String get forgotPasswordTitle;
  String get forgotPasswordDesc;
  String get sendResetCode;
  String get resetPasswordTitle;
  String get resetPasswordDesc;
  String get newPassword;
  String get resetPassword;
  String get passwordResetSuccess;
  String get passwordResetSuccessDesc;
  String get firstName;
  String get firstNameHint;
  String get firstNameRequired;
  String get phone;
  String get phoneHint;
  String get country;
  String get chooseCountry;
  String get searchCountry;
  String get currency;
  String get chooseCurrency;
  String get searchCurrency;
  String get loginButton;
  String get registerButton;
  String get mustAcceptPrivacy;
  String get iAcceptThe;
  String get privacyPolicyLink;

  // ── Email verification ───────────────────────────────────────────────────────
  String get verifyEmailTitle;
  String get verifyEmailDesc;
  String get verifyCode;
  String get resendCode;
  String get skipForNow;
  String get checkSpam;

  // ── Dashboard ───────────────────────────────────────────────────────────────
  String helloUser(String name);
  String get today;
  String get goal;
  String get planning;
  String get kcalPerDay;
  String get progression;
  String get last7Days;
  String get todayMeals;
  String get noMealsToday;
  String get missingMeasurements;
  String get bodyMeasurementsHint;
  String get measurementsDoneToday;
  String get proteins;
  String get carbs;
  String get fats;

  // ── Scan ────────────────────────────────────────────────────────────────────
  String get analyzeMeal;
  String get scanSubtitle;
  String get loginRequired;
  String get mealSaved;
  String get takePhoto;
  String get chooseGallery;
  String get addPhoto;
  String get photoHint;
  String get adjustPortion;
  String get precisions;
  String get precisionsHint;
  String get precisionsPlaceholder;
  String get analyzing;
  String get aiIdentification;
  String portionEstimated(int grams);
  String get healthScore;
  String get micronutrients;
  String get tip;
  String get iWillEat;
  String get reanalyze;
  String get newPhoto;
  String get confirmEat;
  String get confirmEatButton;
  String get fibers;
  String get entirePlate;
  String get halfPortion;

  // ── Coach ───────────────────────────────────────────────────────────────────
  String get coachTitle;
  String get coachSubtitle;
  String get chatTab;
  String get dishesTab;
  String get planningTab;
  String planningRequired(String plan);
  String get whatYouGet;
  String get aiDishes;
  String get personalizedRecipes;
  String get dietOptions9;
  String get exactIngredients;
  String get dailyUpdate;
  String get planningTitle;
  String get planningDescription;
  String get caloricTarget;
  String get adaptedToGoal;
  String get dailyTips;
  String upgradePlan(String plan);
  String get continueFreePlan;
  String get dietRegime;
  String generateRegime(String diet);
  String generatingRegime(String diet);
  String get aiAdaptation;
  String get ingredients;
  String get breakfast;
  String get lunch;
  String get dinner;
  String get weekPlanning;
  String get generatingPlanning;
  String get dayDetail;
  String get regenerate;
  String get noPlanning;
  String get pressToRegenerate;
  String todayKcalInfo(int kcal, int remaining);
  String get noMessagesYet;
  String get typingMessage;
  String coachWelcome(String name);

  // ── Settings ────────────────────────────────────────────────────────────────
  String get myAccount;
  String get logout;
  String get logoutConfirm;
  String get logoutCancel;
  String get logoutConfirmButton;
  String get userLabel;
  String get information;
  String get name;
  String get emailLabel;
  String get phoneLabel;
  String get countryLabel;
  String get subscription;
  String get freeLabel;
  String get loggingOut;
  String get language;
  String get chooseLanguage;

  // ── Profile ─────────────────────────────────────────────────────────────────
  String get myProfile;
  String get bmi;
  String get bmiUnderweight;
  String get bmiNormal;
  String get bmiOverweight;
  String get bmiObese;
  String get objective;
  String kcalPerDayValue(int v);
  String get identity;
  String get gender;
  String get male;
  String get female;
  String get age;
  String get weight;
  String get height;
  String get bodyMeasurements;
  String get bodyMeasurementsHintProfile;
  String get waist;
  String get biceps;
  String get belly;
  String get weightGoal;
  String get loseWeight;
  String get gainMass;
  String get maintain;
  String get eatHealthy;
  String get lossRhythm;
  String get gainRhythm;
  String get soft;
  String get moderate;
  String get sustained;
  String get intense;
  String get lean;
  String get aggressive;
  String get aggressiveWarning;
  String get activityLevel;
  String get saveProfile;
  String get goPremium;
  String get appInfo;
  String get version;

  // ── Onboarding ──────────────────────────────────────────────────────────────
  String get configureProfile;
  String get profileTitle;
  String get profileSubtitle;
  String get yourFirstName;
  String get firstNameEx;
  String get genderLabel;
  String get goalLabel;
  String get goalQuestion;
  String get rhythmLabel;
  String get bodyMeasurementsLabel;
  String get activityDiet;
  String get activityLevelLabel;
  String get dietLabel;
  String get welcome;
  String get welcomeSubtitle;
  String get createProfile;
  String get continueButton;

  // ── Paywall ─────────────────────────────────────────────────────────────────
  String get paywallTitle;
  String get paywallSubtitle;
  String get choosePlan;
  String get unlimitedScan;
  String get featureSubScan;
  String get personalizedCoach;
  String get featureSubCoach;
  String get nutritionPlanning;
  String get featureSubPlanning;
  String get customRecipes;
  String get featureSubRecipes;
  String get progressTracking;
  String get featureSubProgress;
  String get dailyReminders;
  String get featureSubReminders;
  String get perMonth;
  String get rating;
  String get freeTrial;
  String get continueFreePlanLabel;
  String get noCommitment;
  String get accountRequired;
  String get accountRequiredDesc;
  String get createAccountButton;
  String get premiumMonthly;
  String get premiumYearly;
  String get save40;

  // ── Progress ─────────────────────────────────────────────────────────────────
  String get progressTitle;
  String mealsAndEntries(int meals, int entries);
  String get measurementsOk;
  String get todayLabel;
  String get mealsTab;
  String get bodyTab;
  String get todayMeasurements;
  String get fillAvailable;
  String get noMeasurements;
  String get addFirstMeasures;
  String get lastMeasurements;
  String get projectionGoal;
  String get onTrack;
  String get late;
  String get wrongDirection;
  String get accomplished;
  String get estimatedDate;
  String get currentRhythm;
  String get reverseTrend;
  String get stable;
  String get in1Week;
  String inXWeeks(int n);
  String get goalReached;
  String get weightGoingWrong;
  String get noMeals;
  String get scanFirst;
  String get fullHistory;
  String get saveMeasurements;

  // ── Consent ─────────────────────────────────────────────────────────────────
  String get beforeStart;
  String get privacyTitle;
  String get rgpdLabel;
  String get officialDoc;
  String get scrollToAccept;
  String get dataCollected;
  String get legalBasis;
  String get purposes;
  String get subprocessors;
  String get retention;
  String get yourRights;
  String get security;
  String get controller;
  String get iAccept;
  String get refuseButton;
  String get acceptButton;
  String get scrollToBottom;
  String get leaveApp;
  String get leaveAppDesc;
  String get youReachedEnd;

  // ── Splash ──────────────────────────────────────────────────────────────────
  String get tagline;

  // ── Subscription ────────────────────────────────────────────────────────────
  String get premiumTitle;
  String get goPremiumButton;
  String get premiumDesc;
  String get paymentReady;
  String get paymentMethods;
  String get promoCode;
  String get payNow;
  String get openingBrowser;
  String get iHavePaid;
  String get reopenPayment;
  String get securedByStripe;
  String get subscriptionActive;
  String get subscriptionActiveDesc;
  String get start;
  String get noPlanAvailable;
  String get securityNote;
  String savePercent(int p);
  String get notAvailableYet;
  String cannotOpenBrowser(String e);
  String get paymentUnconfirmed;
  String subscribePlan(String price);
  String get comingSoon;
  String get cannotLoadPlans;

  // ── Diets ───────────────────────────────────────────────────────────────────
  String get dietOmnivore;
  String get dietHalal;
  String get dietVegetarian;
  String get dietVegan;
  String get dietKeto;
  String get dietMediterranean;
  String get dietGlutenFree;
  String get dietPaleo;
  String get dietDairy;
  String get dietHighProtein;
  String get dietLowCalorie;

  // ── Coach extras ─────────────────────────────────────────────────────────────
  String get dietFromProfile;
  String get generating;
  String get actualize;
  String get typing;
  String generateDishes(String diet);
  String get generateDishesDesc;
  String planAvailableWith(String plan);
  String get planAvailableWithProOrPremium;
  String get currentPlanLabel;
  String get freePlanLabel;

  // ── Day names (short) ────────────────────────────────────────────────────────
  String get dayMon;
  String get dayTue;
  String get dayWed;
  String get dayThu;
  String get dayFri;
  String get daySat;
  String get daySun;

  // ── Day names (full) ─────────────────────────────────────────────────────────
  String get dayMonFull;
  String get dayTueFull;
  String get dayWedFull;
  String get dayThuFull;
  String get dayFriFull;
  String get daySatFull;
  String get daySunFull;

  // ── Chat suggestions ─────────────────────────────────────────────────────────
  String get suggestion1;
  String get suggestion2;
  String get suggestion3;
  String get suggestion4;

  // ── Body measurements extras ──────────────────────────────────────────────────
  String get chest;
  String get hips;
  String get thighs;

  // ── Activity levels ─────────────────────────────────────────────────────────
  String get activitySedentary;
  String get activityLight;
  String get activityModerate;
  String get activityActive;
  String get activityVeryActive;

  // ── Dashboard extras ─────────────────────────────────────────────────────────
  String get kcalRemaining;
  String get kcalExceeded;

  // ── Subscription gate ─────────────────────────────────────────────────────────
  String get trialExpiredTitle;
  String get trialExpiredSubtitle;
  String get alreadyPaidCheck;
  String get noActiveSubscription;
  String get checkingSubscription;

  // ── Plan card labels ──────────────────────────────────────────────────────────
  String get yourCurrentPlan;
  String get trialExpiredToday;
  String trialExpiredDaysAgo(int days);
  String trialDaysRemaining(int days);

  // ── Billing frequency labels ──────────────────────────────────────────────────
  String get billingMonthly;
  String get billingQuarterly;
  String get billingSemiAnnual;
  String get billingYearly;
  String get bestOffer;
  String savingPerMonth(String amt);
  String perDay(String amt);
  String get lessThanCoffee;
  String get guarantee30Days;
  String get specialOffer;
  String offerExpiresIn(int h, int m);
  String get trialSummaryTitle;
  String mealsScannedCount(int n);
  String get scanUpsellTitle;
  String get scanUpsellBody;
  String get upgradeNow;
  String get notNow;
  String annualSavingsBanner(String amt);
  String get trialNotifJ7;
  String get trialNotifJ7Body;
  String get trialNotifJ3;
  String get trialNotifJ3Body;
  String get trialNotifJ1;
  String get trialNotifJ1Body;

  // ── Payment verification ───────────────────────────────────────────────────────
  String get verifyingPayment;
  String get stepPaymentConfirmed;
  String get stepServerNotified;
  String get stepInvoiceSent;
  String get paymentVerifiedTitle;
  String get paymentVerifiedDesc;
  String get serverNotYetNotified;
  String get retryVerification;
  String webhookPolling(int attempt, int max);   // "Tentative X/Y…"
  String get webhookNotReceived;                 // après N tentatives échouées
  String get webhookReceived;                    // quand webhook confirmé
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['fr', 'en', 'de', 'es', 'pt'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'de':
        return AppLocalizationsDe();
      case 'es':
        return AppLocalizationsEs();
      case 'pt':
        return AppLocalizationsPt();
      default:
        return AppLocalizationsFr();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
