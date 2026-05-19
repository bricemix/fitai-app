import 'app_localizations.dart';



class AppLocalizationsEs extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Inicio';

  @override String get navScan => 'Escáner';

  @override String get navCoach => 'Coach IA';

  @override String get navProgress => 'Progreso';

  @override String get navProfile => 'Perfil';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Tu coach de nutrición con IA';

  @override String get sessionExpired => 'Sesión terminada';

  @override String get reconnect => 'Volver a iniciar sesión';

  @override String get cancel => 'Cancelar';

  @override String get confirm => 'Confirmar';

  @override String get save => 'Guardar';

  @override String get retry => 'Reintentar';

  @override String get loading => 'Cargando…';

  @override String get error => 'Error';

  @override String get later => 'Más tarde';

  @override String get quit => 'Salir';

  @override String get close => 'Cerrar';

  @override String get back => 'Volver';

  @override String get refresh => 'Actualizar';

  @override String get next => 'Siguiente';

  @override String get skip => 'Omitir';

  @override String get accept => 'Aceptar';

  @override String get refuse => 'Rechazar';

  @override String get yes => 'Sí';

  @override String get no => 'No';

  @override String get optional => 'Opcional';

  @override String get recommended => 'Recomendado';

  @override String get popular => 'Popular';



  // ── Auth ────────────────────────────────────────────────────────────────────

  @override String get signIn => 'Iniciar sesión';

  @override String get createAccount => 'Crear cuenta';

  @override String get email => 'Correo electrónico';

  @override String get emailHint => 'tu@correo.com';

  @override String get emailRequired => 'El correo es obligatorio';

  @override String get emailInvalid => 'Correo electrónico inválido';

  @override String get password => 'Contraseña';

  @override String get passwordHint => '••••••••';

  @override String get passwordRequired => 'La contraseña es obligatoria';

  @override String get passwordMin8 => 'Mínimo 8 caracteres';

  @override String get confirmPassword => 'Confirmar contraseña';

  @override String get passwordMismatch => 'Las contraseñas no coinciden';

  @override String get firstName => 'Nombre / Apellido';

  @override String get firstNameHint => 'Juan García';

  @override String get firstNameRequired => 'Nombre requerido (mín. 2 caracteres)';

  @override String get phone => 'Teléfono (opcional)';

  @override String get phoneHint => '+57 310 000 0000';

  @override String get country => 'País';

  @override String get chooseCountry => 'Elegir un país';

  @override String get searchCountry => 'Buscar un país…';

  @override String get currency => 'Moneda preferida';

  @override String get chooseCurrency => 'Elegir moneda';

  @override String get searchCurrency => 'Buscar — EUR, Dólar, Peso…';

  @override String get loginButton => 'Iniciar sesión';

  @override String get registerButton => 'Crear mi cuenta';

  @override String get mustAcceptPrivacy => 'Por favor acepta la política de privacidad';

  @override String get iAcceptThe => 'Acepto la ';

  @override String get privacyPolicyLink => 'política de privacidad y términos';



  // ── Dashboard ───────────────────────────────────────────────────────────────

  @override String helloUser(String name) => 'Hola, $name';

  @override String get today => 'Hoy';

  @override String get goal => 'Objetivo';

  @override String get planning => 'plan';

  @override String get kcalPerDay => 'kcal / día';

  @override String get progression => 'Progreso';

  @override String get last7Days => 'Últimos 7 días';

  @override String get todayMeals => 'Comidas de hoy';

  @override String get noMealsToday => 'No has registrado comidas hoy.\n¡Escanea tu próxima comida!';

  @override String get missingMeasurements => 'Faltan las medidas de hoy';

  @override String get bodyMeasurementsHint => 'Peso, cintura, bíceps…';

  @override String get measurementsDoneToday => 'Medidas registradas hoy';

  @override String get proteins => 'Proteínas';

  @override String get carbs => 'Carbohidratos';

  @override String get fats => 'Grasas';



  // ── Scan ────────────────────────────────────────────────────────────────────

  @override String get analyzeMeal => 'Analizar una comida';

  @override String get scanSubtitle => 'Toma una foto de tu comida para obtener su análisis nutricional completo';

  @override String get loginRequired => 'Se requiere iniciar sesión';

  @override String get mealSaved => 'Comida guardada';

  @override String get takePhoto => 'Tomar una foto';

  @override String get chooseGallery => 'Elegir de la galería';

  @override String get addPhoto => 'Agregar foto';

  @override String get photoHint => 'Toma o importa una foto de tu comida';

  @override String get adjustPortion => 'Ajustar porción';

  @override String get precisions => 'Detalles (opcional)';

  @override String get precisionsHint => 'Describe tu comida para mejorar el análisis';

  @override String get precisionsPlaceholder => 'Ej: pollo a la parrilla con arroz blanco y verduras…';

  @override String get analyzing => 'Analizando…';

  @override String get aiIdentification => 'Identificación IA';

  @override String portionEstimated(int grams) => 'Porción estimada: $grams g';

  @override String get healthScore => 'Puntaje de salud';

  @override String get micronutrients => 'Micronutrientes';

  @override String get tip => 'Consejo';

  @override String get iWillEat => 'Voy a comer';

  @override String get reanalyze => 'Reanalizar';

  @override String get newPhoto => 'Nueva foto';

  @override String get confirmEat => '¿Confirmar consumo?';

  @override String get confirmEatButton => 'Sí, comí esto';

  @override String get fibers => 'Fibra';

  @override String get entirePlate => 'Plato completo';

  @override String get halfPortion => 'Media porción';



  // ── Coach ───────────────────────────────────────────────────────────────────

  @override String get coachTitle => 'Coach IA';

  @override String get coachSubtitle => 'Tu asistente de nutrición personal';

  @override String get chatTab => 'Chat';

  @override String get dishesTab => 'Platos';

  @override String get planningTab => 'Plan';

  @override String planningRequired(String plan) => 'Plan $plan requerido';

  @override String get whatYouGet => 'Lo que obtienes';

  @override String get aiDishes => 'Platos IA personalizados';

  @override String get personalizedRecipes => 'Recetas adaptadas a tu perfil y dieta';

  @override String get dietOptions9 => '9 opciones de dieta disponibles';

  @override String get exactIngredients => 'Ingredientes pesados y macros calculados';

  @override String get dailyUpdate => 'Actualizado cada día';

  @override String get planningTitle => 'Plan nutricional';

  @override String get planningDescription => 'Un plan de 7 días generado por IA según tu objetivo';

  @override String get caloricTarget => 'Objetivo calórico';

  @override String get adaptedToGoal => 'Adaptado a tu objetivo';

  @override String get dailyTips => 'Consejos diarios';

  @override String upgradePlan(String plan) => 'Mejorar a $plan';

  @override String get continueFreePlan => 'Continuar con el plan gratuito';

  @override String get dietRegime => 'Tipo de dieta';

  @override String generateRegime(String diet) => 'Generar platos $diet';

  @override String generatingRegime(String diet) => 'Generando platos $diet…';

  @override String get aiAdaptation => 'Adaptación IA';

  @override String get ingredients => 'Ingredientes';

  @override String get breakfast => 'Desayuno';

  @override String get lunch => 'Almuerzo';

  @override String get dinner => 'Cena';

  @override String get weekPlanning => 'Plan semanal';

  @override String get generatingPlanning => 'Generando plan…';

  @override String get dayDetail => 'Detalle del día';

  @override String get regenerate => 'Regenerar';

  @override String get noPlanning => 'Sin plan generado';

  @override String get pressToRegenerate => 'Toca para generar tu plan';

  @override String todayKcalInfo(int kcal, int remaining) => '$kcal kcal hoy · $remaining restantes';

  @override String get noMessagesYet => 'Sin mensajes aún';

  @override String get typingMessage => 'Escribe un mensaje…';

  @override String coachWelcome(String name) => '¡Hola $name! Soy tu coach de nutrición con IA. ¿Cómo puedo ayudarte?';



  // ── Settings ────────────────────────────────────────────────────────────────

  @override String get myAccount => 'Mi cuenta';

  @override String get logout => 'Cerrar sesión';

  @override String get logoutConfirm => '¿Realmente quieres cerrar sesión?';

  @override String get logoutCancel => 'Cancelar';

  @override String get logoutConfirmButton => 'Cerrar sesión';

  @override String get userLabel => 'Usuario';

  @override String get information => 'Información';

  @override String get name => 'Nombre';

  @override String get emailLabel => 'Correo';

  @override String get phoneLabel => 'Teléfono';

  @override String get countryLabel => 'País';

  @override String get subscription => 'Suscripción';

  @override String get freeLabel => 'Gratuito';

  @override String get loggingOut => 'Cerrando sesión…';

  @override String get language => 'Idioma';

  @override String get chooseLanguage => 'Elegir idioma';



  // ── Profile ─────────────────────────────────────────────────────────────────

  @override String get myProfile => 'Mi perfil';

  @override String get bmi => 'IMC';

  @override String get bmiUnderweight => 'Bajo peso';

  @override String get bmiNormal => 'Normal';

  @override String get bmiOverweight => 'Sobrepeso';

  @override String get bmiObese => 'Obesidad';

  @override String get objective => 'Objetivo';

  @override String kcalPerDayValue(int v) => '$v kcal/día';

  @override String get identity => 'Identidad';

  @override String get gender => 'Género';

  @override String get male => 'Hombre';

  @override String get female => 'Mujer';

  @override String get age => 'Edad';

  @override String get weight => 'Peso (kg)';

  @override String get height => 'Altura (cm)';

  @override String get bodyMeasurements => 'Medidas corporales';

  @override String get bodyMeasurementsHintProfile => 'Opcional — para seguir tu progreso';

  @override String get waist => 'Cintura (cm)';

  @override String get biceps => 'Bíceps (cm)';

  @override String get belly => 'Abdomen (cm)';

  @override String get weightGoal => 'Objetivo';

  @override String get loseWeight => 'Perder peso';

  @override String get gainMass => 'Ganar músculo';

  @override String get maintain => 'Mantener';

  @override String get eatHealthy => 'Comer saludable';

  @override String get lossRhythm => 'Ritmo de pérdida';

  @override String get gainRhythm => 'Ritmo de ganancia';

  @override String get soft => 'Suave';

  @override String get moderate => 'Moderado';

  @override String get sustained => 'Sostenido';

  @override String get intense => 'Intenso';

  @override String get lean => 'Lean';

  @override String get aggressive => 'Agresivo';

  @override String get aggressiveWarning => 'Ritmo agresivo — puede causar pérdida muscular. Consulta a un profesional.';

  @override String get activityLevel => 'Nivel de actividad';

  @override String get saveProfile => 'Guardar perfil';

  @override String get goPremium => 'Ser Premium';

  @override String get appInfo => 'Info de la app';

  @override String get version => 'Versión';



  // ── Onboarding ──────────────────────────────────────────────────────────────

  @override String get configureProfile => 'Configurar mi perfil →';

  @override String get profileTitle => 'Tu perfil';

  @override String get profileSubtitle => 'Esta información se usa para calcular tus necesidades calóricas.';

  @override String get yourFirstName => 'Tu nombre';

  @override String get firstNameEx => 'Ej: María';

  @override String get genderLabel => 'Género';

  @override String get goalLabel => 'Tu objetivo';

  @override String get goalQuestion => '¿Cuál es tu objetivo principal?';

  @override String get rhythmLabel => 'Ritmo deseado (kg/semana)';

  @override String get bodyMeasurementsLabel => 'Medidas corporales (opcional)';

  @override String get activityDiet => 'Actividad y dieta';

  @override String get activityLevelLabel => 'Nivel de actividad';

  @override String get dietLabel => 'Preferencias alimentarias (opcional)';

  @override String get welcome => 'Bienvenido a DietVision';

  @override String get welcomeSubtitle => "Tu coach de nutrición y fitness impulsado por IA.\nAnaliza tus comidas, sigue tus macros y alcanza tus objetivos.";

  @override String get createProfile => 'Crear mi perfil';

  @override String get continueButton => 'Continuar →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Alcanza tus objetivos\nmás rápido con Premium';

  @override String get paywallSubtitle => "Todo lo que necesitas, en una sola app.";

  @override String get choosePlan => 'Elige tu plan';

  @override String get unlimitedScan => 'Escáner IA ilimitado';

  @override String get featureSubScan => 'Analiza cualquier comida en 3 segundos';

  @override String get personalizedCoach => 'Coach IA personalizado';

  @override String get featureSubCoach => 'Consejos adaptados a tu perfil';

  @override String get nutritionPlanning => 'Plan nutricional';

  @override String get featureSubPlanning => 'Plan de 7 días generado por IA';

  @override String get customRecipes => 'Recetas a medida';

  @override String get featureSubRecipes => 'Ingredientes pesados y macros calculados';

  @override String get progressTracking => 'Seguimiento de progreso';

  @override String get featureSubProgress => 'Curvas y tendencias a largo plazo';

  @override String get dailyReminders => 'Recordatorios diarios';

  @override String get featureSubReminders => 'Motivacion cada manana';

  @override String get perMonth   => '/ mes';
  @override String get perYear    => '/ ano';
  @override String get perQuarter => '/ trim.';
  @override String get per6Months => '/ 6 meses';

  @override String get rating => '4.8 / 5 — Más de 2.000 usuarios';

  @override String get freeTrial => 'Prueba gratuita';

  @override String get continueFreePlanLabel => 'Continuar con el plan gratuito';

  @override String get noCommitment => 'Sin compromiso · Cancela cuando quieras';

  @override String get accountRequired => 'Cuenta requerida';

  @override String get accountRequiredDesc => "Para suscribirte, crea una cuenta gratuita en 30 segundos.\n\nPodrás elegir tu plan justo después.";

  @override String get createAccountButton => 'Crear una cuenta';

  @override String get premiumMonthly => 'Premium Mensual';

  @override String get premiumYearly => 'Premium Anual';

  @override String get save40 => 'AHORRA 40%';



  // ── Progress ─────────────────────────────────────────────────────────────────

  @override String get progressTitle => 'Progreso';

  @override String mealsAndEntries(int meals, int entries) => '$meals comidas · $entries medidas';

  @override String get measurementsOk => 'Medidas OK';

  @override String get todayLabel => 'Hoy';

  @override String get mealsTab => 'Comidas';

  @override String get bodyTab => 'Cuerpo';

  @override String get todayMeasurements => 'Medidas de hoy';

  @override String get fillAvailable => 'Completa los campos disponibles';

  @override String get noMeasurements => 'Sin medidas';

  @override String get addFirstMeasures => 'Agrega tus primeras medidas';

  @override String get lastMeasurements => 'Últimas medidas';

  @override String get projectionGoal => 'Proyección hacia el objetivo';

  @override String get onTrack => 'En camino';

  @override String get late => 'Retrasado';

  @override String get wrongDirection => 'Dirección equivocada';

  @override String get accomplished => 'Logrado';

  @override String get estimatedDate => 'Fecha estimada';

  @override String get currentRhythm => 'Ritmo actual';

  @override String get reverseTrend => 'Invertir tendencia';

  @override String get stable => 'Estable';

  @override String get in1Week => 'En 1 semana';

  @override String inXWeeks(int n) => 'En $n semanas';

  @override String get goalReached => '¡Objetivo alcanzado!';

  @override String get weightGoingWrong => 'El peso va en la dirección equivocada';

  @override String get noMeals => 'Sin comidas';

  @override String get scanFirst => 'Escanea tu primera comida para empezar';

  @override String get fullHistory => 'Historial completo';

  @override String get saveMeasurements => 'Guardar medidas';



  // ── Consent ─────────────────────────────────────────────────────────────────

  @override String get beforeStart => 'Antes de comenzar';

  @override String get privacyTitle => 'Política de privacidad y Términos de uso';

  @override String get rgpdLabel => 'RGPD';

  @override String get officialDoc => '↗ Documento oficial';

  @override String get scrollToAccept => 'Lee hasta el final para aceptar';

  @override String get dataCollected => 'Datos recopilados';

  @override String get legalBasis => 'Base legal del tratamiento';

  @override String get purposes => 'Finalidades del tratamiento';

  @override String get subprocessors => 'Subencargados y transferencias';

  @override String get retention => 'Período de conservación';

  @override String get yourRights => 'Tus derechos (RGPD)';

  @override String get security => 'Seguridad';

  @override String get controller => 'Responsable del tratamiento';

  @override String get iAccept => "He leído y acepto la política de privacidad y los términos de uso de DietVision. Doy mi consentimiento para el tratamiento de mis datos de salud con fines de coaching nutricional.";

  @override String get refuseButton => 'Rechazar';

  @override String get acceptButton => 'Aceptar y continuar';

  @override String get scrollToBottom => 'Desplázate hasta el final para activar la aceptación';

  @override String get leaveApp => 'Salir de la app';

  @override String get leaveAppDesc => "Sin aceptar la política de privacidad, no puedes usar DietVision. ¿Quieres salir de la app?";

  @override String get youReachedEnd => 'Has llegado al final del documento';



  // ── Splash ──────────────────────────────────────────────────────────────────

  @override String get tagline => 'COME · ESCANEA · PROGRESA';



  // ── Subscription ────────────────────────────────────────────────────────────

  @override String get premiumTitle => 'Premium';

  @override String get goPremiumButton => 'Ser Premium';

  @override String get premiumDesc => 'Desbloquea todas las funciones';

  @override String get paymentReady => 'Tu pago seguro está listo.';

  @override String get paymentMethods => 'Visa, Mastercard, Apple Pay aceptados. Hay un campo para código promocional en la página de pago.';

  @override String get promoCode => '¿Tienes un código promocional? Ingrésalo directamente en la página de pago de Stripe.';

  @override String get payNow => 'Pagar ahora';

  @override String get openingBrowser => 'Finaliza tu pago en el navegador y regresa aquí.';

  @override String get iHavePaid => 'Pagué — Confirmar';

  @override String get reopenPayment => 'Reabrir página de pago';

  @override String get securedByStripe => 'Pago seguro Stripe · TLS 256-bit';

  @override String get subscriptionActive => '¡Suscripción activada!';

  @override String get subscriptionActiveDesc => 'Tu suscripción está activa.\n¡Disfruta de todas las funciones sin restricciones!';

  @override String get start => 'Comenzar';

  @override String get noPlanAvailable => 'No hay planes disponibles.';

  @override String get securityNote => 'Pago seguro Stripe · TLS 256-bit';

  @override String savePercent(int p) => 'AHORRA $p%';

  @override String get notAvailableYet => "Este plan aún no está disponible.";

  @override String cannotOpenBrowser(String e) => "No se puede abrir el navegador: $e";

  @override String get paymentUnconfirmed => 'Pago no confirmado — si acabas de pagar, espera unos segundos y vuelve a intentarlo.';

  @override String subscribePlan(String price) => 'Comenzar — $price';

  @override String get comingSoon => 'Próximamente';

  @override String get cannotLoadPlans => 'No se pueden cargar los planes';



  // ── Diets ───────────────────────────────────────────────────────────────────

  @override String get dietOmnivore => 'Omnívoro';

  @override String get dietHalal => 'Halal';

  @override String get dietVegetarian => 'Vegetariano';

  @override String get dietVegan => 'Vegano';

  @override String get dietKeto => 'Keto';

  @override String get dietMediterranean => 'Mediterráneo';

  @override String get dietGlutenFree => 'Sin gluten';

  @override String get dietPaleo => 'Paleo';

  @override String get dietDairy => 'Sin lactosa';

  @override String get dietHighProtein => 'Rico en proteínas';

  @override String get dietLowCalorie => 'Bajo en calorías';



  // ── Coach extras ─────────────────────────────────────────────────────────────

  @override String get dietFromProfile => 'Dieta de tu perfil';

  @override String get generating => 'Generando…';

  @override String get actualize => 'Actualizar';

  @override String get typing => 'Escribiendo…';

  @override String generateDishes(String diet) => 'Platos $diet';

  @override String get generateDishesDesc => 'La IA genera 3 recetas personalizadas adaptadas\na tu perfil, calorías restantes\ny dieta seleccionada.';

  @override String planAvailableWith(String plan) => 'Disponible con el plan $plan';

  @override String get planAvailableWithProOrPremium => 'Disponible con el plan Pro o Premium';

  @override String get currentPlanLabel => 'Plan actual';

  @override String get freePlanLabel => 'Gratuito';



  // ── Day names (short) ────────────────────────────────────────────────────────

  @override String get dayMon => 'Lun';

  @override String get dayTue => 'Mar';

  @override String get dayWed => 'Mié';

  @override String get dayThu => 'Jue';

  @override String get dayFri => 'Vie';

  @override String get daySat => 'Sáb';

  @override String get daySun => 'Dom';



  // ── Day names (full) ─────────────────────────────────────────────────────────

  @override String get dayMonFull => 'Lunes';

  @override String get dayTueFull => 'Martes';

  @override String get dayWedFull => 'Miércoles';

  @override String get dayThuFull => 'Jueves';

  @override String get dayFriFull => 'Viernes';

  @override String get daySatFull => 'Sábado';

  @override String get daySunFull => 'Domingo';



  // ── Chat suggestions ─────────────────────────────────────────────────────────

  @override String get suggestion1 => 'Sugiere un plan de comidas para mañana';

  @override String get suggestion2 => '¿Qué alimentos para ganar masa muscular?';

  @override String get suggestion3 => 'Mi resumen nutricional semanal';

  @override String get suggestion4 => 'Mejores snacks post-entrenamiento';



  // ── Body measurements extras ──────────────────────────────────────────────────

  @override String get chest => 'Pecho';

  @override String get hips => 'Caderas';

  @override String get thighs => 'Muslos';



  // ── Activity levels ─────────────────────────────────────────────────────────

  @override String get activitySedentary => 'Sedentario';

  @override String get activityLight => 'Ligero (1-2 días/sem)';

  @override String get activityModerate => 'Moderado (3-4 días/sem)';

  @override String get activityActive => 'Activo (5-6 días/sem)';

  @override String get activityVeryActive => 'Muy activo';



  // ── Dashboard extras ─────────────────────────────────────────────────────────

  @override String get kcalRemaining => 'kcal restantes';

  @override String get kcalExceeded => 'kcal en exceso';



  // ── Subscription gate ─────────────────────────────────────────────────────────

  @override String get trialExpiredTitle => 'Tu prueba ha expirado';

  @override String get trialExpiredSubtitle => 'Suscríbete para seguir usando DietVision y acceder a todas las funcionalidades.';

  @override String get alreadyPaidCheck => '¿Ya pagaste? Verificar mi suscripción';

  @override String get noActiveSubscription => 'No se encontró ninguna suscripción activa.';

  @override String get checkingSubscription => 'Verificando…';



  // ── Plan card labels ──────────────────────────────────────────────────────────

  @override String get yourCurrentPlan => 'TU PLAN ACTUAL';

  @override String get trialExpiredToday => 'Prueba expirada hoy';

  @override String trialExpiredDaysAgo(int days) => 'Prueba expirada hace $days día(s)';

  @override String trialDaysRemaining(int days) => days == 1 ? 'Prueba: 1 día restante ' : 'Prueba: $days días restantes ';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Mensual';

  @override String get billingQuarterly => '3 meses';

  @override String get billingSemiAnnual => '6 meses';

  @override String get billingYearly => 'Anual';

  @override String get bestOffer => 'ðŸ† Mejor oferta';

  @override String savingPerMonth(String amt) => '-$amt/mes';

  @override String perDay(String amt) => '$amt/día';

  @override String get lessThanCoffee => 'Menos que un café ☕';

  @override String get guarantee30Days => 'Garantía de devolución 30 días';

  @override String get specialOffer => 'ðŸŽ OFERTA ESPECIAL';

  @override String offerExpiresIn(int h, int m) => 'Expira en ${h}h ${m}min';

  @override String get trialSummaryTitle => 'Lo que ha logrado';

  @override String mealsScannedCount(int n) => '$n comidas escaneadas';

  @override String get scanUpsellTitle => '¡Análisis listo! 🎉';

  @override String get scanUpsellBody => 'Actualiza a Pro para análisis ilimitados y recomendaciones de IA personalizadas.';

  @override String get upgradeNow => 'Ver planes';

  @override String get notNow => 'Ahora no';

  @override String annualSavingsBanner(String amt) => 'ðŸŽ Ahorre $amt con el anual';

  @override String get trialNotifJ7 => 'Quedan 7 días de prueba';

  @override String get trialNotifJ7Body => 'Disfruta 7 días más — luego elige tu plan.';

  @override String get trialNotifJ3 => '¡Solo quedan 3 días!';

  @override String get trialNotifJ3Body => 'Oferta especial: -40% en plan anual. ¡Aprovéchalo ahora!';

  @override String get trialNotifJ1 => 'Último día de prueba 🔔';

  @override String get trialNotifJ1Body => 'Tu prueba expira mañana. ¡No pierdas tu progreso!';



  // ── Payment verification ───────────────────────────────────────────────────────

  @override String get verifyingPayment => 'Verificando el pago…';

  @override String get stepPaymentConfirmed => 'Pago confirmado ✓';

  @override String get stepServerNotified => 'Servidor notificado ✓';

  @override String get stepInvoiceSent => 'Factura enviada por email ✓';

  @override String get paymentVerifiedTitle => '¡Suscripción activada!';

  @override String get paymentVerifiedDesc => 'Tu suscripción está activa. Se ha enviado una factura a tu correo electrónico. ¡Disfruta de todas las funcionalidades!';

  @override String get serverNotYetNotified => 'El servidor aún no ha recibido la confirmación. Espera unos segundos e inténtalo de nuevo.';

  @override String get retryVerification => 'Reintentar verificación';

  @override String webhookPolling(int attempt, int max) => 'Verificando servidor… intento $attempt/$max';

  @override String get webhookNotReceived => 'El servidor no recibió el webhook de Stripe después de varios intentos.';

  @override String get webhookReceived => 'Webhook de Stripe recibido y procesado ✓';



  // -- Email verification

  @override String get verifyEmailTitle => 'Verifica tu correo';

  @override String get verifyEmailDesc => 'Te enviamos un código de 6 dígitos a';

  @override String get verifyCode => 'Verificar código';

  @override String get resendCode => 'Reenviar código';

  @override String get skipForNow => 'Volver';

  @override String get checkSpam => 'Revisa también tu carpeta de spam si no ves el correo.';


  // -- Password strength & forgot password
  @override String get passwordNeedsUppercase => 'Debe contener al menos una letra mayúscula';
  @override String get passwordNeedsNumberOrSymbol => 'Debe contener al menos un número o carácter especial';
  @override String get forgotPassword => '¿Olvidaste tu contraseña?';
  @override String get forgotPasswordTitle => 'Contraseña olvidada';
  @override String get forgotPasswordDesc => 'Ingresa tu dirección de correo. Te enviaremos un código de 6 dígitos para restablecer tu contraseña.';
  @override String get sendResetCode => 'Enviar código';
  @override String get resetPasswordTitle => 'Nueva contraseña';
  @override String get resetPasswordDesc => 'Ingresa el código recibido por correo y elige una nueva contraseña.';
  @override String get newPassword => 'Nueva contraseña';
  @override String get resetPassword => 'Restablecer contraseña';
  @override String get passwordResetSuccess => '¡Contraseña restablecida!';
  @override String get passwordResetSuccessDesc => 'Tu contraseña ha sido cambiada exitosamente. Ahora puedes iniciar sesión.';
}



