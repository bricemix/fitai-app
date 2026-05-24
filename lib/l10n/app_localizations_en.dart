import 'app_localizations.dart';



class AppLocalizationsEn extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Home';

  @override String get navScan => 'Scan';

  @override String get navCoach => 'Diet Coach';

  @override String get navProgress => 'Progress';

  @override String get navProfile => 'Profile';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Your AI nutrition coach';

  @override String get sessionExpired => 'Session ended';

  @override String get reconnect => 'Sign back in';

  @override String get cancel => 'Cancel';

  @override String get confirm => 'Confirm';

  @override String get save   => 'Save';
  @override String get change => 'Change';

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

  @override String get birthDate      => 'Date of birth';
  @override String get birthDateHint  => 'DD/MM/YYYY';
  @override String get underageTitle  => 'Access restricted';
  @override String get underageBody   => 'DietVision is for people aged 15 and over.\n\nIf you are under 15, using this app requires the consent of a parent or legal guardian.\n\nAsk an adult to create an account and support you in tracking your nutrition.';
  @override String get underageButton => 'I understand';

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

  @override String get measurementsDoneToday        => "Measurements logged today";
  @override String get bodyMeasurementsSubtitle     => 'Weight · Waist · Biceps';
  @override String get syncedLabel                  => 'Data up to date';
  @override String get stayFocused                  => 'Stay focused, every action counts!';
  @override String get dailyProgress                => 'Daily\nprogress';

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

  @override String get camera => 'Camera';
  @override String get gallery => 'Gallery';
  @override String get photoTipsTitle => 'PHOTO TIPS';
  @override String get tipFramePlate => 'Frame the plate';
  @override String get tipGoodLight => 'Good lighting';
  @override String get tipTopView => 'Top view';
  @override String get tipVisibleFood => 'Visible food';
  @override String get tipFullPlate => 'Full plate';
  @override String get tipNoFlash => 'Avoid flash';

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

  @override String get coachTitle => 'Diet Coach';

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
  @override String get restrictionVegetarian => 'Vegetarian';
  @override String get restrictionVegan      => 'Vegan';
  @override String get restrictionGlutenFree => 'Gluten-free';
  @override String get restrictionLactoseFree=> 'Lactose-free';
  @override String get restrictionHalal      => 'Halal';
  @override String get restrictionKeto       => 'Keto';

  @override String get welcome => 'Welcome to DietVision';

  @override String get welcomeSubtitle => "Your AI-powered nutrition & fitness coach.\nAnalyze your meals, track your macros and reach your goals.";

  @override String get createProfile => 'Create my profile';

  @override String get continueButton => 'Continue →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Reach your goals\nfaster with Premium';

  @override String get paywallSubtitle => "Everything you need, in one app.";

  @override String get chipMealScan       => 'Meal Scan';
  @override String get chipMacroTracking  => 'Macro tracking';
  @override String get chipAiCoach        => 'AI Coach';
  @override String get paywallFeaturesPrefix    => 'Everything you need\nto ';
  @override String get paywallFeaturesHighlight => 'succeed';
  @override String get paywallFeaturesSubtitle  => 'Smart tools to reach your nutrition goals.';
  @override String get paywallPlanPrefix    => 'Choose\nyour ';
  @override String get paywallPlanHighlight => 'plan';
  @override String get paywallPlanSubtitle  => 'Start your free trial. Cancel anytime.';

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
  @override String get kcalExceeded  => 'kcal over goal';
  @override String get kcalOver      => 'kcal over';

  // ── Context Day Card ─────────────────────────────────────────────────────────
  @override String get protLow       => 'low';
  @override String get protModerate  => 'moderate';
  @override String get protGood      => 'good';
  @override String get goalWeightLoss => 'weight loss';
  @override String get goalMassGain  => 'mass gain';
  @override String get goalMaintain  => 'maintenance';
  @override String get labelProteins => 'Proteins';
  @override String get labelGoal     => 'Goal:';
  @override String get labelDiet     => 'Diet:';
  @override String ctxDescSurplus(int surplus) => 'You are +$surplus kcal over budget. I can suggest lighter dishes to balance your day.';
  @override String get ctxDescLowProt => 'Your protein intake is low. I can help you rebalance your macros.';
  @override String get ctxDescDefault => 'I can help you build your day based on your remaining calories and goal.';

  // ── Smart Actions labels ──────────────────────────────────────────────────────
  @override String get smartBuildDay        => 'Build my day';
  @override String smartBuildDaySub(int k)  => 'with $k kcal left';
  @override String smartSurplusTitle(int k)  => 'Surplus +$k kcal';
  @override String get smartSurplusSub      => 'How to balance?';
  @override String get smart3Dishes         => 'Give me 3 dishes';
  @override String get smart3DishesSub      => 'high in protein';
  @override String get smartAnalyzeBilan    => 'Analyze my summary';
  @override String get smartAnalyzeBilanSub => 'weekly nutrition';
  @override String get smartPrepareDinner   => 'Prepare my dinner';
  @override String get smartPrepareDinnerSub => 'for tonight';

  // ── Pro gate ─────────────────────────────────────────────────────────────────
  @override String get gateDishesAdaptedRecipes    => 'Recipes adapted\nto your profile\n& diet';
  @override String get gateDishes9Diets            => '9 dietary\nregimes\navailable';
  @override String get gateDishesWeighedIngredients => 'Weighed ingredients\n& macros\ncalculated';
  @override String get gateDishesUpdatedDaily      => 'Updated\nevery day';
  @override String get tableHeaderFeatures         => 'Features';
  @override String get tableRowPersonalizedDishes  => 'Personalized AI dishes';
  @override String get tableRowAdaptedRecipes      => 'Recipes adapted to your profile';
  @override String get tableRowWeighedIngredients  => 'Weighed ingredients & macros';
  @override String get tableRowUpdatedDaily        => 'Updated daily';

  // ── Premium gate ─────────────────────────────────────────────────────────────
  @override String get gatePlanningWeekPlan    => '7-day AI plan\ngenerated by AI\nbased on your goal';
  @override String get gatePlanningCaloricGoal => 'Caloric goal\n& macros\ncalculated';
  @override String get gatePlanningAdapted     => 'Adapted to\nyour goal';
  @override String get gatePlanningDailyTips   => 'Daily tips\n& smart tracking';
  @override String get planStarterSubtitle     => 'Basic features';
  @override String get planProSubtitle         => 'AI recipes & diets';
  @override String get planPremiumSubtitle     => 'AI nutrition planning';
  @override String get planIncluded            => 'Included';
  @override String get planNotIncluded         => 'Planning not included';

  // ── Quick tips ────────────────────────────────────────────────────────────────
  @override String get tipScanFirstMeal  => 'Start by scanning your first meal so I can analyze your daily macros.';
  @override String get tipIncreaseProtein => 'Priority today: increase your protein at the next meal.';
  @override String tipCaloriesAvailable(int pct) => 'You still have $pct% of your calories available. Think about your next meal!';
  @override String get tipCaloriesExceeded => 'Caloric goal exceeded. Focus on light, fiber-rich foods tonight.';
  @override String get tipKeepGoing       => 'Keep it up! Your day is well balanced — stay on track.';
  @override String get newChat => 'New conversation';
  @override String get clearChatTitle => 'Clear conversation?';
  @override String get clearChatConfirm => 'The chat history will be permanently deleted.';
  @override String get clearChatConfirmBtn => 'Clear';
  @override String promptCreatePlanSurplus(int surplus, String diet) => "I'm +$surplus kcal over my goal today. Help me balance the rest of my day with my $diet diet.";
  @override String promptCreatePlanNormal(int remaining, String diet) => "Create my meal plan for today with $remaining kcal remaining and my $diet diet.";
  @override String get promptFixMacros => "Analyze and fix my macros for today. Give me concrete advice to balance proteins, carbs, and fats.";
  @override String get promptAnalyzeProgress => "Analyze my weekly nutritional progress and give me 3 personalized tips to improve.";
  @override String promptSurplusBalance(int surplus, int tdee) => "I'm +$surplus kcal over my goal today (target: $tdee kcal/day). Give me advice to balance my day and limit the effects of the surplus.";
  @override String promptBuildDay(int remaining, String diet) => "Build me a complete meal plan for today with $remaining kcal remaining, adapted to my $diet diet and my goals.";
  @override String prompt3Dishes(String diet) => "Suggest 3 protein-rich dishes (minimum 30g per dish) adapted to my $diet diet.";
  @override String get promptAnalyzeBilan => "Analyze my weekly nutritional balance and give me concrete advice to improve.";
  @override String promptDinnerSurplus(int surplus, int tdee, String diet) => "I'm +$surplus kcal over my goal today (target: $tdee kcal/day). Suggest a light dinner for tonight adapted to my $diet diet.";
  @override String promptDinnerNormal(int remaining, String diet) => "Suggest a dinner for tonight that fits my $remaining kcal remaining and my $diet diet.";



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

  @override String trialDaysRemaining(int days) => days == 1 ? 'Trial: 1 day left ' : 'Trial: $days days left ';
  @override String get statusActive => 'Active';
  @override String get statusInactive => 'Inactive';
  @override String get verifiedFromServer => 'Verified from server';
  @override String get localCache => 'Local cache';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Monthly';

  @override String get billingQuarterly => '3 months';

  @override String get billingSemiAnnual => '6 months';

  @override String get billingYearly => 'Annual';

  @override String get bestOffer => 'Best offer';

  @override String savingPerMonth(String amt) => '-$amt/mo';

  @override String perDay(String amt) => '$amt/day';

  @override String get lessThanCoffee => 'Less than a coffee ☕';

  @override String get guarantee30Days => '30-day money-back guarantee';

  @override String get specialOffer => 'SPECIAL OFFER';

  @override String offerExpiresIn(int h, int m) => 'Expires in ${h}h ${m}min';

  @override String get trialSummaryTitle => 'What you\'ve accomplished';

  @override String mealsScannedCount(int n) => '$n meals scanned';

  @override String get scanUpsellTitle => 'Analysis done! 🎉';

  @override String get scanUpsellBody => 'Upgrade to Pro for unlimited scans and personalized AI recommendations.';

  @override String get upgradeNow => 'See plans';

  @override String get notNow => 'Not now';

  @override String annualSavingsBanner(String amt) => 'Save $amt with annual';

  @override String get trialNotifJ7 => '7 days left in trial';

  @override String get trialNotifJ7Body => 'Enjoy 7 more days — then choose your plan.';

  @override String get trialNotifJ3 => 'Only 3 days left!';

  @override String get trialNotifJ3Body => 'Special offer: -40% on annual plan. Grab it now!';

  @override String get trialNotifJ1 => 'Last day of trial 🔔';

  @override String get trialNotifJ1Body => 'Your trial expires tomorrow. Don\'t lose your progress!';



  // ── Weekly details sheet ─────────────────────────────────────────────────────

  @override String get weeklyDetails => 'Weekly Details';
  @override String get weeklySummaryTitle => 'Weekly Summary';
  @override String get avgKcalPerDay => 'Average';
  @override String get targetKcalDay2 => 'Target';
  @override String get differenceKcal => 'Difference';
  @override String proteinTargetReached(int done, int total) => 'Protein target reached: $done/$total days';
  @override String get statusOnTrack => 'On track';
  @override String get statusAttention => 'Attention';
  @override String get statusOffTrack => 'Off track';
  @override String get statusNotStarted => 'Not started';
  @override String get editThisDay => 'Edit this day';
  @override String get replaceMeals => 'Replace meals';
  @override String get copyThisDay => 'Copy this day';
  @override String get balanceWeek => 'Balance week';

  // ── AI Insight sheet ──────────────────────────────────────────────────────────

  @override String get insightAnalysisTitle => 'Analysis';
  @override String get insightWhyTitle => 'Why it matters';
  @override String get insightActionsTitle => 'Suggested actions';
  @override String insightProteinAnalysis(int current, int target, int gap) =>
      'Your protein goal today is $target g.\nYou are currently at $current g.\nYou are missing about $gap g of protein.';
  @override String insightCaloriesAnalysis(int current, int target) =>
      'You have consumed $current kcal out of your $target kcal goal.';
  @override String get insightWhyProtein => 'Reaching your protein goal helps preserve muscle mass, especially during weight loss. It also keeps you feeling full longer.';
  @override String get insightWhyCalories => 'Staying close to your calorie target is the most important factor for achieving your weight goal consistently.';
  @override String get insightWhyWater => 'Good hydration supports your metabolism, reduces hunger, and helps your body process nutrients more efficiently.';
  @override String get insightWhyCarbs => 'Managing carbohydrate intake helps stabilize blood sugar and optimize energy levels throughout the day.';
  @override String get insightWhyNoScan => 'Tracking your meals helps you stay aware of your intake and makes it easier to hit your daily targets.';
  @override String get insightAction1Protein => 'Greek yogurt + 2 eggs';
  @override String get insightAction1ProteinDetail => '280 kcal · 32 g protein';
  @override String get insightAction2Protein => 'Add 150 g chicken breast to dinner';
  @override String get insightAction2ProteinDetail => '+240 kcal · +45 g protein';
  @override String get insightIgnoreToday => 'Ignore for today';
  @override String get applySuggestion => 'Apply suggestion';
  @override String get showAlternatives => 'Show alternatives';
  @override String get remindMeLater => 'Remind me later';

  // ── Progress forecast sheet ───────────────────────────────────────────────────

  @override String get progressForecast => 'Progress Forecast';
  @override String get projectionBasis => 'This projection is based on your calorie goal, estimated activity, protein intake and current consistency.';
  @override String get conservativeScenario => 'Conservative';
  @override String get balancedScenario => 'Balanced';
  @override String get aggressiveScenario => 'Aggressive';
  @override String get scenarioEasyToKeep => 'Easier to maintain';
  @override String get scenarioRecommended => 'Recommended';
  @override String get scenarioHarder => 'More challenging — higher hunger risk';
  @override String get useBalancedPlan => 'Use balanced plan';
  @override String get makeItEasierPlan => 'Make it easier';
  @override String get makeItFasterPlan => 'Make it faster';
  @override String get weekLabel => 'Week';
  @override String get estimatedWeight => 'Est. weight';
  @override String get weightEvolution => 'Change';
  @override String get todayWeightLabel => 'Today';

  // ── Planning tab ─────────────────────────────────────────────────────────────

  @override String get weeklyBalanceScore => 'WEEKLY BALANCE SCORE';
  @override String get onTrackThisWeek => "You're on track this week!";
  @override String get greatConsistency => 'Great consistency. Keep going!';
  @override String get goodProgressPlan => 'Good progress, keep it up!';
  @override String get aFewMoreEfforts => "A few more efforts and you'll nail it.";
  @override String get stayConsistentPlan => 'Stay consistent this week.';
  @override String get tryHitTargets => 'Try to hit your targets daily.';
  @override String get buildYourRoutine => 'Start building your routine!';
  @override String get everyStepCounts => 'Every step counts. You got this!';
  @override String todayKcalRemainingLabel(int n) => 'Today: $n kcal remaining';
  @override String get viewDetails => 'View details';
  @override String get todayChecklist => 'Today checklist';
  @override String completedOfTotal(int done, int total) => '$done/$total completed';
  @override String get checkHitCalorie => 'Hit calorie target';
  @override String get checkScan2Meals => 'Scan 2 meals';
  @override String get checkProteinGoal => 'Reach protein goal';
  @override String get checkWalk30 => 'Walk 30 min';
  @override String get checkDrinkWater => 'Drink 2.5 L water';
  @override String get checkNoSugarAfter8pm => 'Avoid sugary snack after 8pm';
  @override String get aiInsightTitle => 'AI Insight';
  @override String get insightProteinLow => 'Protein is slightly low today. Add a high-protein snack tonight to stay on target.';
  @override String get insightCaloriesHigh => "You're close to your calorie limit. Choose a light dinner tonight.";
  @override String get insightLackWater => "Don't forget to drink water. Aim for 2.5 L today to stay hydrated.";
  @override String get insightTooManyCarbs => 'Carb intake is high today. Balance with more protein and vegetables.';
  @override String get insightNoScan => 'No meal scanned yet today. Start tracking to stay on plan.';
  @override String get insightOnTrack => 'Everything looks great today. Keep up the good work and stay consistent!';
  @override String get weekProjectionTitle => '4-week projection';
  @override String get projectionSubtitle => 'Estimated result if you follow this plan';
  @override String get weightChangeLbl => 'Weight change';
  @override String get musclePreservedLbl => 'Preserved';
  @override String get muscleGrowingLbl => 'Growing';
  @override String get muscleMaintainedLbl => 'Maintained';
  @override String get energyStableLbl => 'Stable';
  @override String get adjustWeekBtn => 'Adjust week';
  @override String get adjustWeekSheetTitle => 'How would you like to adjust?';
  @override String get adjustLoseFaster => 'I want to lose weight faster';
  @override String get adjustEasierPlan => 'I want an easier plan';
  @override String get adjustMoreProtein => 'I want more protein';
  @override String get adjustFewerCarbs => 'I want fewer carbs';
  @override String get adjustCheaper => 'I want a cheaper meal plan';
  @override String get adjustLocal => 'I want local meals';
  @override String get adjustFlexibleWeekend => 'I want a more flexible weekend';
  @override String get notificationsTooltip => 'Notifications';

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

  // ── Dishes tab extras ────────────────────────────────────────────────────────
  @override String get suggestionDuMoment  => 'Smart suggestion';
  @override String get personalizeLabel    => 'Personalize your suggestions';
  @override String get mealObjectiveLabel  => 'Meal objective';
  @override String get chooseThisDish      => 'Choose this dish';
  @override String get filterQuick         => 'Quick';
  @override String get filterBudget        => 'Budget';
  @override String get filterLowKcal       => '< 600 kcal';
  @override String get filterLowCarb       => 'Low carb';
  @override String get filterSnack         => 'Snack';
  @override String get dishSelectedMsg     => 'Dish selected!';
  @override String get preparationBtn        => 'Preparation';
  @override String get contextDayTitle       => "Today's context";
  @override String get smartActionsTitle     => 'Smart actions';
  @override String get viewAll               => 'View all';
  @override String get quickTipLabel         => 'Quick tip';
  @override String get actionCreatePlan      => 'Build my plan';
  @override String get actionFixMacros       => 'Fix my macros';
  @override String get actionAnalyzeProgress => 'Analyze my progress';


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

  // ── Dashboard — Today Mission & AI Reco ──────────────────────────────────────
  @override String get readyToCrush => 'Ready to crush your goals?';
  @override String get notifications => 'Notifications';
  @override String get todayMission => 'Mission of the day';
  @override String get seeDailyPlan => 'See my daily plan';
  @override String get completeDailyMeasures => 'Complete daily measurements';
  @override String get dailyCheckIn => 'Daily check-in';
  @override String get toComplete => 'To complete';
  @override String get completeNow => 'Complete now';
  @override String get checkInDone => 'Check-in done!';
  @override String get dataUpToDate => 'Data up to date. AI projection is more precise.';
  @override String get aiRecommendation => 'AI Recommendation';
  @override String get viewMore => 'View more';
  @override String get viewDishes => 'View dishes';
  @override String get scanMeal => 'Scan meal';
  @override String get adjustToday => 'Adjust today';
  @override String get aiRecNoScan => 'No meal scanned yet. Start tracking to stay on plan.';
  @override String get aiRecProteinLow => 'Protein intake is low. Add a protein-rich food at your next meal.';
  @override String get aiRecCaloriesHigh => "You're close to your calorie limit. Choose a light dinner tonight.";
  @override String get aiRecOnTrack => "You're on track! Everything looks great today. Keep it up.";
  @override String get objectifQuotidien => 'Daily Goal';

  // ── Gate PRO ─────────────────────────────────────────────────────────────────
  @override String get proGateBannerTitle  => 'Pro Plan required';
  @override String get proGateBannerSub    => 'Unlock AI-personalised dishes';
  @override String get proGateChip         => 'Pro required';
  @override String get proGateHeroTitle    => 'AI-personalised dishes';
  @override String get proGateHeroAvail    => 'Available with the Pro or Premium plan';
  @override String get proGateHeroDesc     => 'Get daily meals crafted for you, tailored to your goals and preferences.';
  @override String get proGateCta         => 'Unlock my AI dishes';
  @override String get cancelAnytime       => 'Cancel anytime';
  @override String get freeTrialDays       => '7-day free trial';

  // ── Gate PREMIUM ──────────────────────────────────────────────────────────────
  @override String get premiumGateBannerTitle  => 'Premium Plan required';
  @override String get premiumGateBannerSub    => 'Unlock your personalised nutrition plan';
  @override String get premiumGateHeroAvail    => 'Available with the Premium plan';
  @override String get premiumGateHeroDesc     => 'A 7-day AI-generated plan, tailored to your goals and daily routine.';
  @override String get premiumGatePreviewTitle => 'Preview of your future plan';
  @override String get premiumGatePreviewLock  => 'Unlock the full personalised plan';
  @override String get premiumGateCta         => 'Activate my Premium plan';

  // ── Dishes tab ────────────────────────────────────────────────────────────────
  @override String dishesResultCount(int n) => '$n results';
  @override String get seeDetails   => 'See details';
  @override String get dayBilan     => 'Today\'s summary';
  @override String get dayMeals     => 'Today\'s meals';
  @override String get previewHint  => 'Preview — Generate to see your personalised dishes';
  @override String stepLabel(int n) => 'Step $n';
  @override String get orContinueWith => 'Or continue with';
  @override String get socialAuthError => 'Social authentication error';

  // ── Onboarding welcome step ───────────────────────────────────────────────
  @override String get welcomeTo => 'Welcome to';
  @override String get onboardingIntro => 'To get started, we\'ll configure\nyour profile to ';
  @override String get onboardingPersonalize => 'personalize your experience.';
  @override String get infoCardTitle => 'Your information';
  @override String get infoCardSubtitle => 'Age, gender, height, weight';
  @override String get measuresCardTitle => 'Your measurements';
  @override String get measuresCardSubtitle => 'Waist, hips, biceps…';
  @override String get objectivesCardTitle => 'Your goals';
  @override String get objectivesCardSubtitle => 'Weight loss, muscle gain or maintenance';
  @override String get aiNoteText => 'This takes just a few moments and lets the AI suggest ';
  @override String get aiNoteHighlight => 'personalized recommendations.';
  @override String get nextStepLabel => 'Next step: enter your data';
}



