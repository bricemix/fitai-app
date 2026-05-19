import 'app_localizations.dart';



class AppLocalizationsEn extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Home';

  @override String get navScan => 'Scan';

  @override String get navCoach => 'AI Coach';

  @override String get navProgress => 'Progress';

  @override String get navProfile => 'Profile';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Your AI nutrition coach';

  @override String get sessionExpired => 'Session ended';

  @override String get reconnect => 'Sign back in';

  @override String get cancel => 'Cancel';

  @override String get confirm => 'Confirm';

  @override String get save => 'Save';

  @override String get retry => 'Retry';

  @override String get loading => 'Loading…';

  @override String get error => 'Error';

  @override String get later => 'Later';

  @override String get quit => 'Quit';

  @override String get close => 'Close';

  @override String get back => 'Back';

  @override String get refresh => 'Refresh';

  @override String get next => 'Next';

  @override String get skip => 'Skip';

  @override String get accept => 'Accept';

  @override String get refuse => 'Decline';

  @override String get yes => 'Yes';

  @override String get no => 'No';

  @override String get optional => 'Optional';

  @override String get recommended => 'Recommended';

  @override String get popular => 'Popular';



  // ── Auth ────────────────────────────────────────────────────────────────────

  @override String get signIn => 'Sign In';

  @override String get createAccount => 'Create Account';

  @override String get email => 'Email';

  @override String get emailHint => 'your@email.com';

  @override String get emailRequired => 'Email is required';

  @override String get emailInvalid => 'Invalid email address';

  @override String get password => 'Password';

  @override String get passwordHint => '••••••••';

  @override String get passwordRequired => 'Password is required';

  @override String get passwordMin8 => 'Minimum 8 characters';

  @override String get confirmPassword => 'Confirm Password';

  @override String get passwordMismatch => 'Passwords do not match';

  @override String get firstName => 'First / Last Name';

  @override String get firstNameHint => 'John Smith';

  @override String get firstNameRequired => 'Name required (min. 2 characters)';

  @override String get phone => 'Phone (optional)';

  @override String get phoneHint => '+1 555 000 0000';

  @override String get country => 'Country';

  @override String get chooseCountry => 'Choose a country';

  @override String get searchCountry => 'Search country…';

  @override String get currency => 'Preferred currency';

  @override String get chooseCurrency => 'Choose currency';

  @override String get searchCurrency => 'Search — EUR, Dollar, Franc…';

  @override String get loginButton => 'Sign In';

  @override String get registerButton => 'Create my account';

  @override String get mustAcceptPrivacy => 'Please accept the privacy policy to continue';

  @override String get iAcceptThe => 'I accept the ';

  @override String get privacyPolicyLink => 'privacy policy and terms';

  @override String get verifyEmailTitle => 'Verify your email';

  @override String get verifyEmailDesc => 'We sent a 6-digit code to';

  @override String get verifyCode => 'Verify code';

  @override String get resendCode => 'Resend code';

  @override String get skipForNow => 'Go back';

  @override String get checkSpam => 'Also check your spam folder if you don\'t see the email.';



  // ── Dashboard ───────────────────────────────────────────────────────────────

  @override String helloUser(String name) => 'Hello, $name';

  @override String get today => 'Today';

  @override String get goal => 'Goal';

  @override String get planning => 'plan';

  @override String get kcalPerDay => 'kcal / day';

  @override String get progression => 'Progress';

  @override String get last7Days => 'Last 7 days';

  @override String get todayMeals => "Today's meals";

  @override String get noMealsToday => "No meals logged today.\nScan your next meal!";

  @override String get missingMeasurements => "Today's measurements missing";

  @override String get bodyMeasurementsHint => 'Weight, waist, biceps…';

  @override String get measurementsDoneToday => "Measurements logged today";

  @override String get proteins => 'Proteins';

  @override String get carbs => 'Carbs';

  @override String get fats => 'Fats';



  // ── Scan ────────────────────────────────────────────────────────────────────

  @override String get analyzeMeal => 'Analyze a meal';

  @override String get scanSubtitle => 'Take a photo of your meal to get a full nutritional breakdown';

  @override String get loginRequired => 'Login required — please sign in';

  @override String get mealSaved => 'Meal saved';

  @override String get takePhoto => 'Take a photo';

  @override String get chooseGallery => 'Choose from gallery';

  @override String get addPhoto => 'Add a photo';

  @override String get photoHint => 'Take or import a photo of your meal';

  @override String get adjustPortion => 'Adjust portion';

  @override String get precisions => 'Details (optional)';

  @override String get precisionsHint => 'Describe your meal to improve the analysis';

  @override String get precisionsPlaceholder => 'E.g. grilled chicken with white rice and vegetables…';

  @override String get analyzing => 'Analyzing…';

  @override String get aiIdentification => 'AI Identification';

  @override String portionEstimated(int grams) => 'Estimated portion: $grams g';

  @override String get healthScore => 'Health score';

  @override String get micronutrients => 'Micronutrients';

  @override String get tip => 'Tip';

  @override String get iWillEat => 'I will eat';

  @override String get reanalyze => 'Re-analyze';

  @override String get newPhoto => 'New photo';

  @override String get confirmEat => 'Confirm consumption?';

  @override String get confirmEatButton => "Yes, I ate this";

  @override String get fibers => 'Fiber';

  @override String get entirePlate => 'Entire plate';

  @override String get halfPortion => 'Half portion';



  // ── Coach ───────────────────────────────────────────────────────────────────

  @override String get coachTitle => 'AI Coach';

  @override String get coachSubtitle => 'Your personal nutrition assistant';

  @override String get chatTab => 'Chat';

  @override String get dishesTab => 'Dishes';

  @override String get planningTab => 'Planning';

  @override String planningRequired(String plan) => '$plan plan required';

  @override String get whatYouGet => 'What you get';

  @override String get aiDishes => 'Personalized AI dishes';

  @override String get personalizedRecipes => 'Recipes tailored to your profile and diet';

  @override String get dietOptions9 => '9 diet options available';

  @override String get exactIngredients => 'Weighed ingredients & calculated macros';

  @override String get dailyUpdate => 'Updated every day';

  @override String get planningTitle => 'Nutrition plan';

  @override String get planningDescription => 'A 7-day AI-generated plan based on your goal';

  @override String get caloricTarget => 'Caloric target';

  @override String get adaptedToGoal => 'Adapted to your goal';

  @override String get dailyTips => 'Daily tips';

  @override String upgradePlan(String plan) => 'Upgrade to $plan';

  @override String get continueFreePlan => 'Continue with free plan';

  @override String get dietRegime => 'Diet type';

  @override String generateRegime(String diet) => 'Generate $diet dishes';

  @override String generatingRegime(String diet) => 'Generating $diet dishes…';

  @override String get aiAdaptation => 'AI adaptation';

  @override String get ingredients => 'Ingredients';

  @override String get breakfast => 'Breakfast';

  @override String get lunch => 'Lunch';

  @override String get dinner => 'Dinner';

  @override String get weekPlanning => 'Weekly plan';

  @override String get generatingPlanning => 'Generating plan…';

  @override String get dayDetail => "Day's detail";

  @override String get regenerate => 'Regenerate';

  @override String get noPlanning => 'No plan generated';

  @override String get pressToRegenerate => 'Tap to generate your plan';

  @override String todayKcalInfo(int kcal, int remaining) => '$kcal kcal today · $remaining remaining';

  @override String get noMessagesYet => 'No messages yet';

  @override String get typingMessage => 'Type a message…';

  @override String coachWelcome(String name) => 'Hello $name! I am your AI nutrition coach. How can I help you?';



  // ── Settings ────────────────────────────────────────────────────────────────

  @override String get myAccount => 'My account';

  @override String get logout => 'Sign out';

  @override String get logoutConfirm => 'Are you sure you want to sign out?';

  @override String get logoutCancel => 'Cancel';

  @override String get logoutConfirmButton => 'Sign out';

  @override String get userLabel => 'User';

  @override String get information => 'Information';

  @override String get name => 'Name';

  @override String get emailLabel => 'Email';

  @override String get phoneLabel => 'Phone';

  @override String get countryLabel => 'Country';

  @override String get subscription => 'Subscription';

  @override String get freeLabel => 'Free';

  @override String get loggingOut => 'Signing out…';

  @override String get language => 'Language';

  @override String get chooseLanguage => 'Choose language';



  // ── Profile ─────────────────────────────────────────────────────────────────

  @override String get myProfile => 'My profile';

  @override String get bmi => 'BMI';

  @override String get bmiUnderweight => 'Underweight';

  @override String get bmiNormal => 'Normal';

  @override String get bmiOverweight => 'Overweight';

  @override String get bmiObese => 'Obese';

  @override String get objective => 'Objective';

  @override String kcalPerDayValue(int v) => '$v kcal/day';

  @override String get identity => 'Identity';

  @override String get gender => 'Gender';

  @override String get male => 'Male';

  @override String get female => 'Female';

  @override String get age => 'Age';

  @override String get weight => 'Weight (kg)';

  @override String get height => 'Height (cm)';

  @override String get bodyMeasurements => 'Body measurements';

  @override String get bodyMeasurementsHintProfile => 'Optional — to track your progress';

  @override String get waist => 'Waist (cm)';

  @override String get biceps => 'Biceps (cm)';

  @override String get belly => 'Belly (cm)';

  @override String get weightGoal => 'Goal';

  @override String get loseWeight => 'Lose weight';

  @override String get gainMass => 'Gain muscle';

  @override String get maintain => 'Maintain';

  @override String get eatHealthy => 'Eat healthy';

  @override String get lossRhythm => 'Loss rate';

  @override String get gainRhythm => 'Gain rate';

  @override String get soft => 'Gentle';

  @override String get moderate => 'Moderate';

  @override String get sustained => 'Sustained';

  @override String get intense => 'Intense';

  @override String get lean => 'Lean';

  @override String get aggressive => 'Aggressive';

  @override String get aggressiveWarning => 'Aggressive pace — may cause muscle loss. Consult a professional.';

  @override String get activityLevel => 'Activity level';

  @override String get saveProfile => 'Save profile';

  @override String get goPremium => 'Go Premium';

  @override String get appInfo => 'App info';

  @override String get version => 'Version';



  // ── Onboarding ──────────────────────────────────────────────────────────────

  @override String get configureProfile => 'Set up my profile →';

  @override String get profileTitle => 'Your profile';

  @override String get profileSubtitle => 'This information is used to calculate your caloric needs.';

  @override String get yourFirstName => 'Your first name';

  @override String get firstNameEx => 'Ex: Marie';

  @override String get genderLabel => 'Gender';

  @override String get goalLabel => 'Your goal';

  @override String get goalQuestion => 'What is your primary goal?';

  @override String get rhythmLabel => 'Desired pace (kg/week)';

  @override String get bodyMeasurementsLabel => 'Body measurements (optional)';

  @override String get activityDiet => 'Activity & diet';

  @override String get activityLevelLabel => 'Activity level';

  @override String get dietLabel => 'Dietary preferences (optional)';

  @override String get welcome => 'Welcome to DietVision';

  @override String get welcomeSubtitle => "Your AI-powered nutrition & fitness coach.\nAnalyze your meals, track your macros and reach your goals.";

  @override String get createProfile => 'Create my profile';

  @override String get continueButton => 'Continue →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Reach your goals\nfaster with Premium';

  @override String get paywallSubtitle => "Everything you need, in one app.";

  @override String get choosePlan => 'Choose your plan';

  @override String get unlimitedScan => 'Unlimited AI Scan';

  @override String get featureSubScan => 'Analyze any meal in 3 seconds';

  @override String get personalizedCoach => 'Personalized AI Coach';

  @override String get featureSubCoach => 'Advice tailored to your profile';

  @override String get nutritionPlanning => 'Nutrition planning';

  @override String get featureSubPlanning => '7-day plan generated by AI';

  @override String get customRecipes => 'Custom recipes';

  @override String get featureSubRecipes => 'Weighed ingredients & calculated macros';

  @override String get progressTracking => 'Progress tracking';

  @override String get featureSubProgress => 'Charts & long-term trends';

  @override String get dailyReminders => 'Daily reminders';

  @override String get featureSubReminders => 'Morning motivation every day';

  @override String get perMonth   => '/ month';
  @override String get perYear    => '/ year';
  @override String get perQuarter => '/ qtr.';
  @override String get per6Months => '/ 6 mo.';

  @override String get rating => '4.8 / 5 — Over 2,000 users';

  @override String get freeTrial => 'Free trial';

  @override String get continueFreePlanLabel => 'Continue with free plan';

  @override String get noCommitment => 'No commitment · Cancel anytime';

  @override String get accountRequired => 'Account required';

  @override String get accountRequiredDesc => "To subscribe, create a free account in 30 seconds.\n\nYou can choose your plan right after.";

  @override String get createAccountButton => 'Create an account';

  @override String get premiumMonthly => 'Premium Monthly';

  @override String get premiumYearly => 'Premium Yearly';

  @override String get save40 => 'SAVE 40%';



  // ── Progress ─────────────────────────────────────────────────────────────────

  @override String get progressTitle => 'Progress';

  @override String mealsAndEntries(int meals, int entries) => '$meals meals · $entries entries';

  @override String get measurementsOk => 'Measurements OK';

  @override String get todayLabel => 'Today';

  @override String get mealsTab => 'Meals';

  @override String get bodyTab => 'Body';

  @override String get todayMeasurements => "Today's measurements";

  @override String get fillAvailable => 'Fill in the available fields';

  @override String get noMeasurements => 'No measurements';

  @override String get addFirstMeasures => 'Add your first measurements';

  @override String get lastMeasurements => 'Last measurements';

  @override String get projectionGoal => 'Goal projection';

  @override String get onTrack => 'On track';

  @override String get late => 'Behind schedule';

  @override String get wrongDirection => 'Wrong direction';

  @override String get accomplished => 'Accomplished';

  @override String get estimatedDate => 'Estimated date';

  @override String get currentRhythm => 'Current pace';

  @override String get reverseTrend => 'Reverse trend';

  @override String get stable => 'Stable';

  @override String get in1Week => 'In 1 week';

  @override String inXWeeks(int n) => 'In $n weeks';

  @override String get goalReached => 'Goal reached!';

  @override String get weightGoingWrong => 'Weight is moving in the wrong direction';

  @override String get noMeals => 'No meals';

  @override String get scanFirst => 'Scan your first meal to get started';

  @override String get fullHistory => 'Full history';

  @override String get saveMeasurements => 'Save measurements';



  // ── Consent ─────────────────────────────────────────────────────────────────

  @override String get beforeStart => 'Before you begin';

  @override String get privacyTitle => 'Privacy Policy & Terms of Use';

  @override String get rgpdLabel => 'GDPR';

  @override String get officialDoc => '↗ Official document';

  @override String get scrollToAccept => 'Read to the bottom to accept';

  @override String get dataCollected => 'Data collected';

  @override String get legalBasis => 'Legal basis for processing';

  @override String get purposes => 'Purposes of processing';

  @override String get subprocessors => 'Sub-processors & transfers';

  @override String get retention => 'Retention period';

  @override String get yourRights => 'Your rights (GDPR)';

  @override String get security => 'Security';

  @override String get controller => 'Data controller';

  @override String get iAccept => "I have read and accept DietVision's privacy policy and terms of use. I consent to the processing of my health data for nutritional coaching purposes.";

  @override String get refuseButton => 'Decline';

  @override String get acceptButton => 'Accept and continue';

  @override String get scrollToBottom => 'Scroll to the bottom to enable acceptance';

  @override String get leaveApp => 'Leave the app';

  @override String get leaveAppDesc => "Without accepting the privacy policy, you cannot use DietVision. Do you want to leave the app?";

  @override String get youReachedEnd => 'You have reached the end of the document';



  // ── Splash ──────────────────────────────────────────────────────────────────

  @override String get tagline => 'EAT · SCAN · PROGRESS';



  // ── Subscription ────────────────────────────────────────────────────────────

  @override String get premiumTitle => 'Premium';

  @override String get goPremiumButton => 'Go Premium';

  @override String get premiumDesc => 'Unlock all features';

  @override String get paymentReady => 'Your secure payment is ready.';

  @override String get paymentMethods => 'Visa, Mastercard, Apple Pay accepted. A promo code field is available on the payment page.';

  @override String get promoCode => 'Have a promo code? Enter it directly on the Stripe payment page.';

  @override String get payNow => 'Pay now';

  @override String get openingBrowser => 'Complete your payment in the browser, then come back here.';

  @override String get iHavePaid => "I've paid — Confirm";

  @override String get reopenPayment => 'Reopen payment page';

  @override String get securedByStripe => 'Secured by Stripe · TLS 256-bit';

  @override String get subscriptionActive => 'Subscription activated!';

  @override String get subscriptionActiveDesc => 'Your subscription is active.\nEnjoy all features without any restrictions!';

  @override String get start => 'Get started';

  @override String get noPlanAvailable => 'No plan available.';

  @override String get securityNote => 'Secured by Stripe · TLS 256-bit';

  @override String savePercent(int p) => 'SAVE $p%';

  @override String get notAvailableYet => "This plan is not yet available.";

  @override String cannotOpenBrowser(String e) => "Cannot open browser: $e";

  @override String get paymentUnconfirmed => 'Payment not confirmed — if you just paid, wait a few seconds and try again.';

  @override String subscribePlan(String price) => 'Get started — $price';

  @override String get comingSoon => 'Coming soon';

  @override String get cannotLoadPlans => 'Cannot load plans';



  // ── Diets ───────────────────────────────────────────────────────────────────

  @override String get dietOmnivore => 'Omnivore';

  @override String get dietHalal => 'Halal';

  @override String get dietVegetarian => 'Vegetarian';

  @override String get dietVegan => 'Vegan';

  @override String get dietKeto => 'Keto';

  @override String get dietMediterranean => 'Mediterranean';

  @override String get dietGlutenFree => 'Gluten-free';

  @override String get dietPaleo => 'Paleo';

  @override String get dietDairy => 'Dairy-free';

  @override String get dietHighProtein => 'High protein';

  @override String get dietLowCalorie => 'Low calorie';



  // ── Coach extras ─────────────────────────────────────────────────────────────

  @override String get dietFromProfile => 'Diet from your profile';

  @override String get generating => 'Generating…';

  @override String get actualize => 'Refresh';

  @override String get typing => 'Typing…';

  @override String generateDishes(String diet) => '$diet dishes';

  @override String get generateDishesDesc => 'AI generates 3 custom recipes adapted\nto your profile, remaining calories\nand selected diet.';

  @override String planAvailableWith(String plan) => 'Available with the $plan plan';

  @override String get planAvailableWithProOrPremium => 'Available with the Pro or Premium plan';

  @override String get currentPlanLabel => 'Current plan';

  @override String get freePlanLabel => 'Free';



  // ── Day names (short) ────────────────────────────────────────────────────────

  @override String get dayMon => 'Mon';

  @override String get dayTue => 'Tue';

  @override String get dayWed => 'Wed';

  @override String get dayThu => 'Thu';

  @override String get dayFri => 'Fri';

  @override String get daySat => 'Sat';

  @override String get daySun => 'Sun';



  // ── Day names (full) ─────────────────────────────────────────────────────────

  @override String get dayMonFull => 'Monday';

  @override String get dayTueFull => 'Tuesday';

  @override String get dayWedFull => 'Wednesday';

  @override String get dayThuFull => 'Thursday';

  @override String get dayFriFull => 'Friday';

  @override String get daySatFull => 'Saturday';

  @override String get daySunFull => 'Sunday';



  // ── Chat suggestions ─────────────────────────────────────────────────────────

  @override String get suggestion1 => 'Suggest a meal plan for tomorrow';

  @override String get suggestion2 => 'What foods for muscle gain?';

  @override String get suggestion3 => 'My weekly nutritional summary';

  @override String get suggestion4 => 'Best post-workout snacks';



  // ── Body measurements extras ──────────────────────────────────────────────────

  @override String get chest => 'Chest';

  @override String get hips => 'Hips';

  @override String get thighs => 'Thighs';



  // ── Activity levels ─────────────────────────────────────────────────────────

  @override String get activitySedentary => 'Sedentary';

  @override String get activityLight => 'Light (1-2 days/wk)';

  @override String get activityModerate => 'Moderate (3-4 days/wk)';

  @override String get activityActive => 'Active (5-6 days/wk)';

  @override String get activityVeryActive => 'Very active';



  // ── Dashboard extras ─────────────────────────────────────────────────────────

  @override String get kcalRemaining => 'kcal remaining';

  @override String get kcalExceeded => 'kcal over goal';



  // ── Subscription gate ─────────────────────────────────────────────────────────

  @override String get trialExpiredTitle => 'Your trial has expired';

  @override String get trialExpiredSubtitle => 'Subscribe to keep using DietVision and unlock all features.';

  @override String get alreadyPaidCheck => 'Already paid? Check my subscription';

  @override String get noActiveSubscription => 'No active subscription found.';

  @override String get checkingSubscription => 'Checking…';



  // ── Plan card labels ──────────────────────────────────────────────────────────

  @override String get yourCurrentPlan => 'YOUR CURRENT PLAN';

  @override String get trialExpiredToday => 'Trial expired today';

  @override String trialExpiredDaysAgo(int days) => 'Trial expired $days day(s) ago';

  @override String trialDaysRemaining(int days) => days == 1 ? 'Trial: 1 day left â³' : 'Trial: $days days left â³';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Monthly';

  @override String get billingQuarterly => '3 months';

  @override String get billingSemiAnnual => '6 months';

  @override String get billingYearly => 'Annual';

  @override String get bestOffer => 'ðŸ† Best offer';

  @override String savingPerMonth(String amt) => '-$amt/mo';

  @override String perDay(String amt) => '$amt/day';

  @override String get lessThanCoffee => 'Less than a coffee ☕';

  @override String get guarantee30Days => '30-day money-back guarantee';

  @override String get specialOffer => 'ðŸŽ SPECIAL OFFER';

  @override String offerExpiresIn(int h, int m) => 'Expires in ${h}h ${m}min';

  @override String get trialSummaryTitle => 'What you\'ve accomplished';

  @override String mealsScannedCount(int n) => '$n meals scanned';

  @override String get scanUpsellTitle => 'Analysis done! 🎉';

  @override String get scanUpsellBody => 'Upgrade to Pro for unlimited scans and personalized AI recommendations.';

  @override String get upgradeNow => 'See plans';

  @override String get notNow => 'Not now';

  @override String annualSavingsBanner(String amt) => 'ðŸŽ Save $amt with annual';

  @override String get trialNotifJ7 => '7 days left in trial';

  @override String get trialNotifJ7Body => 'Enjoy 7 more days — then choose your plan.';

  @override String get trialNotifJ3 => 'Only 3 days left!';

  @override String get trialNotifJ3Body => 'Special offer: -40% on annual plan. Grab it now!';

  @override String get trialNotifJ1 => 'Last day of trial 🔔';

  @override String get trialNotifJ1Body => 'Your trial expires tomorrow. Don\'t lose your progress!';



  // ── Payment verification ───────────────────────────────────────────────────────

  @override String get verifyingPayment => 'Verifying payment…';

  @override String get stepPaymentConfirmed => 'Payment confirmed ✓';

  @override String get stepServerNotified => 'Server notified ✓';

  @override String get stepInvoiceSent => 'Invoice sent by email ✓';

  @override String get paymentVerifiedTitle => 'Subscription activated!';

  @override String get paymentVerifiedDesc => 'Your subscription is now active. An invoice has been sent to your email address. Enjoy all features!';

  @override String get serverNotYetNotified => 'The server has not yet received confirmation. Wait a few seconds and try again.';

  @override String get retryVerification => 'Retry verification';

  @override String webhookPolling(int attempt, int max) => 'Checking server… attempt $attempt/$max';

  @override String get webhookNotReceived => 'The server did not receive the Stripe webhook after several attempts.';

  @override String get webhookReceived => 'Stripe webhook received and processed ✓';


  // -- Password strength & forgot password
  @override String get passwordNeedsUppercase => 'Must contain at least one uppercase letter';
  @override String get passwordNeedsNumberOrSymbol => 'Must contain at least one digit or special character';
  @override String get forgotPassword => 'Forgot password?';
  @override String get forgotPasswordTitle => 'Forgot password';
  @override String get forgotPasswordDesc => 'Enter your email address. We will send you a 6-digit code to reset your password.';
  @override String get sendResetCode => 'Send code';
  @override String get resetPasswordTitle => 'New password';
  @override String get resetPasswordDesc => 'Enter the code received by email and choose a new password.';
  @override String get newPassword => 'New password';
  @override String get resetPassword => 'Reset password';
  @override String get passwordResetSuccess => 'Password reset!';
  @override String get passwordResetSuccessDesc => 'Your password has been changed successfully. You can now log in.';
}



