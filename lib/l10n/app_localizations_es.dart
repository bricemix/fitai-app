import 'app_localizations.dart';



class AppLocalizationsEs extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Inicio';

  @override String get navScan => 'Escáner';

  @override String get navCoach => 'Diet Coach';

  @override String get navProgress => 'Progreso';

  @override String get navProfile => 'Perfil';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Tu coach de nutrición con IA';

  @override String get sessionExpired => 'Sesión terminada';

  @override String get reconnect => 'Volver a iniciar sesión';

  @override String get cancel => 'Cancelar';

  @override String get confirm => 'Confirmar';

  @override String get save   => 'Guardar';
  @override String get change => 'Cambiar';

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

  @override String get birthDate      => 'Fecha de nacimiento';
  @override String get birthDateHint  => 'DD/MM/AAAA';
  @override String get underageTitle  => 'Acceso limitado';
  @override String get underageBody   => 'DietVision está destinado a personas mayores de 15 años.\n\nSi tienes menos de 15 años, el uso de esta aplicación requiere el consentimiento de un padre o tutor legal.\n\nPide a un adulto que cree una cuenta y te acompañe en el seguimiento de tu nutrición.';
  @override String get underageButton => 'Entendido';



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

  @override String get measurementsDoneToday        => 'Medidas registradas hoy';
  @override String get bodyMeasurementsSubtitle     => 'Peso · Cintura · Bíceps';
  @override String get syncedLabel                  => 'Datos actualizados';
  @override String get stayFocused                  => '¡Mantente enfocado, cada acción cuenta!';
  @override String get dailyProgress                => 'Progreso\ndiario';

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

  @override String get camera => 'Cámara';
  @override String get gallery => 'Galería';
  @override String get photoTipsTitle => 'CONSEJOS FOTO';
  @override String get tipFramePlate => 'Encuadrar el plato';
  @override String get tipGoodLight => 'Buena iluminación';
  @override String get tipTopView => 'Vista desde arriba';
  @override String get tipVisibleFood => 'Alimento visible';
  @override String get tipFullPlate => 'Plato completo';
  @override String get tipNoFlash => 'Sin flash';

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

  // Scan — text tab
  @override String get scanTabPhoto        => 'Foto';
  @override String get scanTabText         => 'Texto';
  @override String get scanTextSubtitle    => 'Agrega una foto o describe tu comida para obtener su análisis nutricional';
  @override String get describeMeal        => 'Describir una comida';
  @override String get describeMealHint    => '¿Olvidaste la foto? Describe tu comida e indica una porción aproximada.';
  @override String get mealNameLabel       => 'Nombre de la comida';
  @override String get mealNamePlaceholder => 'Ej: Arroz, pollo, verduras, salsa';
  @override String get portionQtyLabel     => 'Porción / cantidad';
  @override String get portionQtyPlaceholder => 'Ej: 1 plato, 250 g, 2 piezas';
  @override String get mealTypeLabel       => 'Tipo de comida';
  @override String get precisionTip        => 'Consejo: cuanto más precisa sea tu descripción, mejor será la estimación.';
  @override String get switchToPhoto       => 'Tomar una foto en su lugar';
  @override String get forgotPhotoTip      => '¿Olvidaste la foto? Usa la pestaña de texto para agregar la comida más tarde.';

  // ── Coach ───────────────────────────────────────────────────────────────────

  @override String get coachTitle => 'Diet Coach';

  @override String get coachSubtitle => 'Tu asistente de nutrición personal';

  @override String get chatTab => 'Chat';

  @override String get dishesTab => 'Platos';
  @override String get dishesPlanRequired => 'Las recomendaciones de platos IA están disponibles desde el plan Pro.';
  @override String get dishesLimitReached => 'Límite diario de platos recomendados alcanzado. Vuelve mañana o mejora tu plan.';

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
  @override String get restrictionVegetarian => 'Vegetariano';
  @override String get restrictionVegan      => 'Vegano';
  @override String get restrictionGlutenFree => 'Sin gluten';
  @override String get restrictionLactoseFree=> 'Sin lactosa';
  @override String get restrictionHalal      => 'Halal';
  @override String get restrictionKeto       => 'Keto';

  @override String get welcome => 'Bienvenido a DietVision';

  @override String get welcomeSubtitle => "Tu coach de nutrición y fitness impulsado por IA.\nAnaliza tus comidas, sigue tus macros y alcanza tus objetivos.";

  @override String get createProfile => 'Crear mi perfil';

  @override String get continueButton => 'Continuar →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Alcanza tus objetivos\nmás rápido con Premium';

  @override String get paywallSubtitle => "Todo lo que necesitas, en una sola app.";

  @override String get chipMealScan       => 'Escanear comida';
  @override String get chipMacroTracking  => 'Seguimiento macros';
  @override String get chipAiCoach        => 'Coach IA';
  @override String get paywallFeaturesPrefix    => 'Todo lo que\nnecesitas para ';
  @override String get paywallFeaturesHighlight => 'triunfar';
  @override String get paywallFeaturesSubtitle  => 'Herramientas inteligentes para alcanzar tus objetivos nutricionales.';
  @override String get paywallPlanPrefix    => 'Elige\ntu ';
  @override String get paywallPlanHighlight => 'plan';
  @override String get paywallPlanSubtitle  => 'Empieza tu prueba gratuita. Cancela cuando quieras.';

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
  @override String get kcalExceeded  => 'kcal en exceso';
  @override String get kcalOver      => 'kcal de más';

  // ── Context Day Card ─────────────────────────────────────────────────────────
  @override String get protLow       => 'bajas';
  @override String get protModerate  => 'moderadas';
  @override String get protGood      => 'buenas';
  @override String get goalWeightLoss => 'pérdida de peso';
  @override String get goalMassGain  => 'ganancia muscular';
  @override String get goalMaintain  => 'mantenimiento';
  @override String get labelProteins => 'Proteínas';
  @override String get labelGoal     => 'Objetivo:';
  @override String get labelDiet     => 'Régimen:';
  @override String ctxDescSurplus(int surplus) => 'Tienes un exceso de +$surplus kcal. Puedo sugerirte platos más ligeros para equilibrar tu día.';
  @override String get ctxDescLowProt => 'Tu ingesta de proteínas es baja. Puedo ayudarte a reequilibrar tus macros.';
  @override String get ctxDescDefault => 'Puedo ayudarte a construir tu día según las calorías restantes y tu objetivo.';

  // ── Smart Actions labels ──────────────────────────────────────────────────────
  @override String get smartBuildDay        => 'Construye mi día';
  @override String smartBuildDaySub(int k)  => 'con $k kcal restantes';
  @override String smartSurplusTitle(int k)  => 'Exceso +$k kcal';
  @override String get smartSurplusSub      => '¿Cómo equilibrar?';
  @override String get smart3Dishes         => 'Dame 3 platos';
  @override String get smart3DishesSub      => 'ricos en proteínas';
  @override String get smartAnalyzeBilan    => 'Analiza mi balance';
  @override String get smartAnalyzeBilanSub => 'nutricional de la semana';
  @override String get smartPrepareDinner   => 'Prepara mi cena';
  @override String get smartPrepareDinnerSub => 'de esta noche';

  // ── Pro gate ─────────────────────────────────────────────────────────────────
  @override String get gateDishesAdaptedRecipes    => 'Recetas adaptadas\na tu perfil\ny régimen';
  @override String get gateDishes9Diets            => '9 regímenes\nalimenticios\ndisponibles';
  @override String get gateDishesWeighedIngredients => 'Ingredientes pesados\n& macros\ncalculados';
  @override String get gateDishesUpdatedDaily      => 'Actualizado\ncada día';
  @override String get tableHeaderFeatures         => 'Funcionalidades';
  @override String get tableRowPersonalizedDishes  => 'Platos IA personalizados';
  @override String get tableRowAdaptedRecipes      => 'Recetas adaptadas a tu perfil';
  @override String get tableRowWeighedIngredients  => 'Ingredientes pesados & macros calculados';
  @override String get tableRowUpdatedDaily        => 'Actualizado diariamente';

  // ── Premium gate ─────────────────────────────────────────────────────────────
  @override String get gatePlanningWeekPlan    => 'Plan de 7 días\ngenerado por IA\nsegún tu objetivo';
  @override String get gatePlanningCaloricGoal => 'Objetivo calórico\ny macros\ncalculados';
  @override String get gatePlanningAdapted     => 'Adaptado a\ntu objetivo';
  @override String get gatePlanningDailyTips   => 'Consejos diarios\n& seguimiento inteligente';
  @override String get planStarterSubtitle     => 'Funciones básicas';
  @override String get planProSubtitle         => 'Recetas & regímenes IA';
  @override String get planPremiumSubtitle     => 'Planificación nutricional IA';
  @override String get planIncluded            => 'Incluido';
  @override String get planNotIncluded         => 'Planificación no incluida';

  // ── Quick tips ────────────────────────────────────────────────────────────────
  @override String get tipScanFirstMeal  => 'Empieza escaneando tu primera comida para que pueda analizar tus macros del día.';
  @override String get tipIncreaseProtein => 'Prioridad hoy: aumenta tus proteínas en la próxima comida.';
  @override String tipCaloriesAvailable(int pct) => 'Todavía tienes $pct% de tus calorías disponibles. ¡Piensa en tu próxima comida!';
  @override String get tipCaloriesExceeded => 'Objetivo calórico superado. Esta noche apuesta por alimentos ligeros y ricos en fibra.';
  @override String get tipKeepGoing       => '¡Sigue así! Tu día está bien equilibrado — mantén el rumbo.';
  @override String get newChat => 'Nueva conversación';
  @override String get clearChatTitle => '¿Borrar conversación?';
  @override String get clearChatConfirm => 'El historial del chat se eliminará permanentemente.';
  @override String get clearChatConfirmBtn => 'Borrar';
  @override String promptCreatePlanSurplus(int surplus, String diet) => "Estoy con +$surplus kcal de superávit hoy. Ayúdame a equilibrar el resto de mi día con mi dieta $diet.";
  @override String promptCreatePlanNormal(int remaining, String diet) => "Crea mi plan alimentario para hoy con $remaining kcal restantes y mi dieta $diet.";
  @override String get promptFixMacros => "Analiza y corrige mis macros de hoy. Dame consejos concretos para equilibrar proteínas, carbohidratos y grasas.";
  @override String get promptAnalyzeProgress => "Analiza mi progreso nutricional semanal y dame 3 consejos personalizados para mejorar.";
  @override String promptSurplusBalance(int surplus, int tdee) => "Tengo +$surplus kcal de superávit hoy (objetivo: $tdee kcal/día). Dame consejos para equilibrar mi día y limitar los efectos del superávit.";
  @override String promptBuildDay(int remaining, String diet) => "Crea un plan de comidas completo para hoy con $remaining kcal restantes, adaptado a mi dieta $diet y mis objetivos.";
  @override String prompt3Dishes(String diet) => "Sugiere 3 platos ricos en proteínas (mínimo 30g por plato) adaptados a mi dieta $diet.";
  @override String get promptAnalyzeBilan => "Analiza mi balance nutricional semanal y dame consejos concretos para mejorar.";
  @override String promptDinnerSurplus(int surplus, int tdee, String diet) => "Tengo +$surplus kcal de superávit hoy (objetivo: $tdee kcal/día). Sugiere una cena ligera para esta noche adaptada a mi dieta $diet.";
  @override String promptDinnerNormal(int remaining, String diet) => "Sugiere una cena para esta noche que corresponda a mis $remaining kcal restantes y mi dieta $diet.";



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
  @override String get statusActive => 'Activo';
  @override String get statusInactive => 'Inactivo';
  @override String get verifiedFromServer => 'Verificado desde el servidor';
  @override String get localCache => 'Caché local';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Mensual';

  @override String get billingQuarterly => '3 meses';

  @override String get billingSemiAnnual => '6 meses';

  @override String get billingYearly => 'Anual';

  @override String get bestOffer => 'Mejor oferta';

  @override String savingPerMonth(String amt) => '-$amt/mes';

  @override String perDay(String amt) => '$amt/día';

  @override String get lessThanCoffee => 'Menos que un café ☕';

  @override String get guarantee30Days => 'Garantía de devolución 30 días';

  @override String get specialOffer => 'OFERTA ESPECIAL';

  @override String offerExpiresIn(int h, int m) => 'Expira en ${h}h ${m}min';

  @override String get trialSummaryTitle => 'Lo que ha logrado';

  @override String mealsScannedCount(int n) => '$n comidas escaneadas';

  @override String get scanUpsellTitle => '¡Análisis listo! 🎉';

  @override String get scanUpsellBody => 'Actualiza a Pro para análisis ilimitados y recomendaciones de IA personalizadas.';

  @override String get upgradeNow => 'Desbloquear más';

  @override String get notNow => 'Mañana está bien';

  @override String get limitReachedTitle => '¡Gran progreso hoy!';
  @override String limitReachedBody(String type, int limit) => type == 'chat'
      ? 'Has usado tus $limit mensajes gratuitos de hoy. Vuelve mañana para seguir gratis, o pasa a Pro para continuar ahora.'
      : 'Has usado tus $limit análisis gratuitos de hoy. Vuelve mañana para seguir gratis, o pasa a Pro para continuar ahora.';
  @override String limitUsedPill(int used, int total, String type) => type == 'chat'
      ? '$used / $total mensajes usados'
      : '$used / $total análisis usados';
  @override String get proScanFeature     => '50 análisis IA / día';
  @override String get proChatFeature     => '100 mensajes coach IA / día';
  @override String get premiumScanFeature => '150 análisis IA / día';
  @override String get premiumChatFeature => '200 mensajes coach IA / día';
  @override String get withProLabel      => 'Con Pro';
  @override String get continueWithPro   => 'Continuar con Pro';
  @override String get comeBackTomorrow  => 'Volver mañana';
  @override String get limitProFeature1  => 'Más análisis con IA';
  @override String get limitProFeature2  => 'Platos IA personalizados';
  @override String get limitProFeature3  => 'Consejos de nutrición avanzados';
  @override String get limitProFeature4  => 'Seguimiento más completo';

  @override String annualSavingsBanner(String amt) => 'Ahorre $amt con el anual';

  @override String get trialNotifJ7 => 'Quedan 7 días de prueba';

  @override String get trialNotifJ7Body => 'Disfruta 7 días más — luego elige tu plan.';

  @override String get trialNotifJ3 => '¡Solo quedan 3 días!';

  @override String get trialNotifJ3Body => 'Oferta especial: -40% en plan anual. ¡Aprovéchalo ahora!';

  @override String get trialNotifJ1 => 'Último día de prueba 🔔';

  @override String get trialNotifJ1Body => 'Tu prueba expira mañana. ¡No pierdas tu progreso!';



  // ── Weekly details sheet ─────────────────────────────────────────────────────

  @override String get weeklyDetails => 'Detalles de la semana';
  @override String get weeklySummaryTitle => 'Resumen semanal';
  @override String get avgKcalPerDay => 'Promedio';
  @override String get targetKcalDay2 => 'Objetivo';
  @override String get differenceKcal => 'Diferencia';
  @override String proteinTargetReached(int done, int total) => 'Objetivo proteínas alcanzado: $done/$total días';
  @override String get statusOnTrack => 'En buen camino';
  @override String get statusAttention => 'Atención';
  @override String get statusOffTrack => 'Fuera del objetivo';
  @override String get statusNotStarted => 'Aún no comenzado';
  @override String get editThisDay => 'Editar este día';
  @override String get replaceMeals => 'Reemplazar comidas';
  @override String get copyThisDay => 'Copiar este día';
  @override String get balanceWeek => 'Equilibrar semana';
  @override String get insightAnalysisTitle => 'Análisis';
  @override String get insightWhyTitle => 'Por qué es importante';
  @override String get insightActionsTitle => 'Acciones sugeridas';
  @override String insightProteinAnalysis(int current, int target, int gap) =>
      'Tu objetivo de proteínas hoy es $target g.\nActualmente estás en $current g.\nTe faltan aproximadamente $gap g de proteínas.';
  @override String insightCaloriesAnalysis(int current, int target) =>
      'Has consumido $current kcal de tu objetivo de $target kcal.';
  @override String get insightWhyProtein => 'Alcanzar tu objetivo proteico ayuda a preservar la masa muscular, especialmente durante la pérdida de peso.';
  @override String get insightWhyCalories => 'Mantenerse cerca de tu objetivo calórico es el factor más importante para lograr tu meta de peso.';
  @override String get insightWhyWater => 'Una buena hidratación apoya tu metabolismo y reduce el hambre.';
  @override String get insightWhyCarbs => 'Gestionar el consumo de carbohidratos ayuda a estabilizar el azúcar en sangre.';
  @override String get insightWhyNoScan => 'Registrar tus comidas te ayuda a alcanzar tus objetivos diarios.';
  @override String get insightAction1Protein => 'Yogur griego + 2 huevos';
  @override String get insightAction1ProteinDetail => '280 kcal · 32 g proteínas';
  @override String get insightAction2Protein => 'Agregar 150 g de pollo a la cena';
  @override String get insightAction2ProteinDetail => '+240 kcal · +45 g proteínas';
  @override String get insightIgnoreToday => 'Ignorar por hoy';
  @override String get applySuggestion => 'Aplicar sugerencia';
  @override String get showAlternatives => 'Ver alternativas';
  @override String get remindMeLater => 'Recordarme más tarde';
  @override String get progressForecast => 'Previsión de progreso';
  @override String get projectionBasis => 'Esta proyección se basa en tu objetivo calórico, actividad estimada, ingesta de proteínas y consistencia actual.';
  @override String get conservativeScenario => 'Conservador';
  @override String get balancedScenario => 'Equilibrado';
  @override String get aggressiveScenario => 'Intensivo';
  @override String get scenarioEasyToKeep => 'Más fácil de mantener';
  @override String get scenarioRecommended => 'Recomendado';
  @override String get scenarioHarder => 'Más difícil — mayor riesgo de hambre';
  @override String get useBalancedPlan => 'Usar plan equilibrado';
  @override String get makeItEasierPlan => 'Facilitar';
  @override String get makeItFasterPlan => 'Acelerar';
  @override String get weekLabel => 'Semana';
  @override String get estimatedWeight => 'Peso estimado';
  @override String get weightEvolution => 'Cambio';
  @override String get todayWeightLabel => 'Hoy';

  // ── Planning tab ─────────────────────────────────────────────────────────────

  @override String get weeklyBalanceScore => 'PUNTUACIÓN SEMANAL';
  @override String get onTrackThisWeek => '¡Estás en el buen camino esta semana!';
  @override String get greatConsistency => '¡Excelente constancia. Sigue así!';
  @override String get goodProgressPlan => '¡Buen progreso, sigue adelante!';
  @override String get aFewMoreEfforts => 'Un poco más de esfuerzo y lo lograrás.';
  @override String get stayConsistentPlan => 'Mantén la constancia esta semana.';
  @override String get tryHitTargets => 'Intenta alcanzar tus objetivos diarios.';
  @override String get buildYourRoutine => '¡Empieza a construir tu rutina!';
  @override String get everyStepCounts => 'Cada paso cuenta. ¡Tú puedes!';
  @override String todayKcalRemainingLabel(int n) => 'Hoy: $n kcal restantes';
  @override String get viewDetails => 'Ver detalles';
  @override String get todayChecklist => 'Lista del día';
  @override String completedOfTotal(int done, int total) => '$done/$total completados';
  @override String get checkHitCalorie => 'Alcanzar objetivo calórico';
  @override String get checkScan2Meals => 'Escanear 2 comidas';
  @override String get checkProteinGoal => 'Objetivo de proteínas';
  @override String get checkWalk30 => 'Caminar 30 min';
  @override String get checkDrinkWater => 'Beber 2,5 L de agua';
  @override String get checkNoSugarAfter8pm => 'Evitar dulces después de las 20h';
  @override String get aiInsightTitle => 'Consejo IA';
  @override String get insightProteinLow => 'Las proteínas están un poco bajas hoy. Agrega un snack rico en proteínas esta noche.';
  @override String get insightCaloriesHigh => 'Te acercas a tu límite calórico. Elige una cena ligera esta noche.';
  @override String get insightLackWater => 'No olvides beber agua. Apunta a 2,5 L hoy.';
  @override String get insightTooManyCarbs => 'Ingesta de carbohidratos alta hoy. Equilibra con más proteínas y verduras.';
  @override String get insightNoScan => 'Ninguna comida escaneada hoy. Empieza a registrar para cumplir tu plan.';
  @override String get insightOnTrack => '¡Todo va genial hoy! Mantén el ritmo y sé constante.';
  @override String get weekProjectionTitle => 'Proyección 4 semanas';
  @override String get projectionSubtitle => 'Resultado estimado si sigues este plan';
  @override String get weightChangeLbl => 'Cambio de peso';
  @override String get musclePreservedLbl => 'Preservado';
  @override String get muscleGrowingLbl => 'Creciendo';
  @override String get muscleMaintainedLbl => 'Mantenido';
  @override String get energyStableLbl => 'Estable';
  @override String get adjustWeekBtn => 'Ajustar semana';
  @override String get adjustWeekSheetTitle => '¿Cómo quieres ajustar?';
  @override String get adjustLoseFaster => 'Quiero perder peso más rápido';
  @override String get adjustEasierPlan => 'Quiero un plan más sencillo';
  @override String get adjustMoreProtein => 'Quiero más proteínas';
  @override String get adjustFewerCarbs => 'Quiero menos carbohidratos';
  @override String get adjustCheaper => 'Quiero un plan más económico';
  @override String get adjustLocal => 'Quiero comidas locales';
  @override String get adjustFlexibleWeekend => 'Quiero un fin de semana más flexible';
  @override String get notificationsTooltip => 'Notificaciones';

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

  // ── Dishes tab extras ────────────────────────────────────────────────────────
  @override String get suggestionDuMoment  => 'Sugerencia del momento';
  @override String get personalizeLabel    => 'Personalizar sugerencias';
  @override String get mealObjectiveLabel  => 'Objetivo de la comida';
  @override String get chooseThisDish      => 'Elegir este plato';
  @override String get filterQuick         => 'Rápido';
  @override String get filterBudget        => 'Económico';
  @override String get filterLowKcal       => '< 600 kcal';
  @override String get filterLowCarb       => 'Bajo en carbohidratos';
  @override String get filterSnack         => 'Merienda';
  @override String get dishSelectedMsg     => '¡Plato seleccionado!';
  @override String get preparationBtn        => 'Preparación';
  @override String get dishRecipeLabel       => 'RECETA';
  @override String dishIngredientsSection(int n) => 'Ingredientes ($n)';
  @override String dishPrepStepsSection(int n)   => 'Pasos de preparación ($n)';
  @override String get trendRising           => '↑ Subiendo';
  @override String get trendFalling          => '↓ Bajando';
  @override String get totalTodayLabel       => 'Total hoy';
  @override String get mealsLoggedLabel      => 'Comidas';
  @override String get avgHealthScoreLabel   => 'Puntuación media';
  @override String get veryGood             => 'Muy bien';
  @override String get goodLabel            => 'Bien';
  @override String get fairLabel            => 'Regular';
  @override String kcalTargetValue(int n)   => 'Objetivo $n kcal';
  @override String get contextDayTitle       => 'Contexto del día';
  @override String get smartActionsTitle     => 'Acciones inteligentes';
  @override String get viewAll               => 'Ver todo';
  @override String get quickTipLabel         => 'Consejo rápido';
  @override String get actionCreatePlan      => 'Crear mi plan';
  @override String get actionFixMacros       => 'Corregir mis macros';
  @override String get actionAnalyzeProgress => 'Analizar mi progreso';



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

  // ── Dashboard — Today Score & Quick Actions ──────────────────────────────────
  @override String get todayScore => 'Puntuación de hoy';
  @override String get ofDailyGoal => 'del objetivo diario';
  @override String get scoreScanFirstMeal => 'Empieza fuerte — escanea tu primera comida para ver tus insights.';
  @override String get addFoodLabel => 'Agregar';
  @override String get askCoachLabel => 'Preguntar';
  @override String get dailyNutrition => 'Nutrición diaria';
  @override String get consumed => 'Consumido';
  @override String get nextMilestone => 'Siguiente hito';
  @override String get completedFraction => 'hechas';

  // ── Dashboard — Today Mission & AI Reco ──────────────────────────────────────
  @override String get readyToCrush => '¿Listo para alcanzar tus objetivos?';
  @override String get notifications => 'Notificaciones';
  @override String get todayMission => 'Misión del día';
  @override String get seeDailyPlan => 'Ver mi plan del día';
  @override String get completeDailyMeasures => 'Completar medidas del día';
  @override String get dailyCheckIn => 'Check-in diario';
  @override String get toComplete => 'Por completar';
  @override String get completeNow => 'Completar ahora';
  @override String get checkInDone => '¡Check-in completado!';
  @override String get dataUpToDate => 'Datos actualizados. La proyección IA es más precisa.';
  @override String get aiRecommendation => 'Recomendación IA';
  @override String get viewMore => 'Ver más';
  @override String get viewDishes => 'Ver platos';
  @override String get scanMeal => 'Escanear comida';
  @override String get adjustToday => 'Ajustar hoy';
  @override String get aiRecNoScan => 'Ninguna comida escaneada hoy. Empieza a registrar para seguir tu plan.';
  @override String get aiRecProteinLow => 'Tu ingesta de proteínas es baja. Añade un alimento rico en proteínas en tu próxima comida.';
  @override String get aiRecCaloriesHigh => 'Estás cerca de tu límite calórico. Elige una cena ligera esta noche.';
  @override String get aiRecOnTrack => '¡Estás en el buen camino! Todo se ve genial hoy. Sigue así.';
  @override String get objectifQuotidien => 'Objetivo diario';

  // ── Gate PRO ─────────────────────────────────────────────────────────────────
  @override String get proGateBannerTitle  => 'Se requiere el plan Pro';
  @override String get proGateBannerSub    => 'Desbloquea platos IA personalizados';
  @override String get proGateChip         => 'Pro requerido';
  @override String get proGateHeroTitle    => 'Platos IA personalizados';
  @override String get proGateHeroAvail    => 'Disponible con el plan Pro o Premium';
  @override String get proGateHeroDesc     => 'Recibe cada día comidas pensadas para ti, adaptadas a tus objetivos.';
  @override String get proGateCta         => 'Desbloquear mis platos IA';
  @override String get cancelAnytime       => 'Cancelación en cualquier momento';
  @override String get freeTrialDays       => '7 días de prueba gratuita';

  @override String get manageSubscription     => 'Gestionar mi suscripción';
  @override String get manageSubscriptionDesc => 'Cancelar, cambiar método de pago o ver facturas desde el portal de Stripe.';
  @override String get openingPortal          => 'Abriendo portal…';
  @override String get portalError            => 'No se pudo abrir el portal. Inténtelo de nuevo.';

  // ── Dashboard i18n ──────────────────────────────────────────────────────────
  @override String get todoLabel => 'POR HACER';
  @override String get doneLabel => '✓ HECHO';
  @override String get milestoneLabel => 'HITO';
  @override String inDaysLabel(int n) => 'en $n días';
  @override String completedFractionLabel(int done, int total) => '$done / $total completadas';
  @override String kcalConsumedLabel(int kcal, int protein) => '$kcal kcal consumidas · ${protein}g proteínas';
  @override String get averageLabel => 'Promedio';
  @override String get priorityLabel => 'Prioridad: ';
  @override String get aiRecPriorityProtein => 'añade una comida rica en proteínas en el próximo escaneo.';

  // ── Coach screen i18n ────────────────────────────────────────────────────────
  @override String get planningNutritional => 'Planificación nutricional';
  @override String get macroCalories => 'Calorías';
  @override String get macroProtein => 'Proteínas';
  @override String get macroCarbs => 'Hidratos';
  @override String get macroFat => 'Grasas';
  @override String get percentReached => '% alcanzado';
  @override String get exceeded => 'superado';
  @override String get remaining => 'restantes';

  // ── Onboarding i18n ─────────────────────────────────────────────────────────
  @override String get kgPerWeek => 'kg/sem';

  // ── Gate PREMIUM ──────────────────────────────────────────────────────────────
  @override String get premiumGateBannerTitle  => 'Se requiere el plan Premium';
  @override String get premiumGateBannerSub    => 'Desbloquea tu planificación nutricional personalizada';
  @override String get premiumGateHeroAvail    => 'Disponible con el plan Premium';
  @override String get premiumGateHeroDesc     => 'Un plan de 7 días generado por IA, adaptado a tus objetivos y rutina diaria.';
  @override String get premiumGatePreviewTitle => 'Vista previa de tu futuro plan';
  @override String get premiumGatePreviewLock  => 'Desbloquea el plan completo y personalizado';
  @override String get premiumGateCta         => 'Activar mi plan Premium';

  // ── Dishes tab ────────────────────────────────────────────────────────────────
  @override String dishesResultCount(int n) => '$n resultados';
  @override String get seeDetails   => 'Ver detalles';
  @override String get dayBilan     => 'Resumen del día';
  @override String get dayMeals     => 'Comidas del día';
  @override String get previewHint  => 'Vista previa — Genera para ver tus platos personalizados';
  @override String stepLabel(int n) => 'Paso $n';
  @override String get pillSubExcess => 'de exceso';
  @override String get pillSubRemaining => 'restantes';
  @override String get pillSubDiet => 'Dieta';
  @override String dishCountPillValue(int count) => '$count plato${count > 1 ? 's' : ''}';
  @override String get pillSubToGenerate => 'a generar';
  @override String filterCountPillValue(int count) => '$count filtro${count > 1 ? 's' : ''}';
  @override String pillSubActive(int count) => 'activo${count > 1 ? 's' : ''}';
  @override String smartSummaryDescSurplus(int surplus, int count) =>
      'Has superado tu objetivo en +$surplus kcal. La IA sugiere $count plato${count > 1 ? 's' : ''} ligero${count > 1 ? 's' : ''} para equilibrar tu día.';
  @override String smartSummaryDescNormal(int count, String diet) =>
      'La IA te sugerirá $count plato${count > 1 ? 's' : ''} $diet adaptados a tus calorías restantes y tu objetivo nutricional.';
  @override String get orContinueWith => 'O continuar con';
  @override String get socialAuthError => 'Error de autenticación social';

  // ── Network / Error dialogs ──────────────────────────────────────────────────
  @override String get noConnectionTitle        => 'Sin conexión';
  @override String get noConnectionBody         => 'Comprueba tu conexión a Internet e inténtalo de nuevo.';
  @override String get serverErrorTitle         => 'Error del servidor';
  @override String get serverErrorBody          => 'Se ha producido un error en el servidor. Vuelve a intentarlo en un momento.';
  @override String get timeoutErrorTitle        => 'Conexión demasiado lenta';
  @override String get timeoutErrorBody         => 'La solicitud ha caducado. Comprueba tu red e inténtalo de nuevo.';
  @override String get checkoutUnavailableTitle => 'Pago no disponible';
  @override String get checkoutUnavailableBody  => 'No se puede iniciar el pago. Comprueba tu conexión e inténtalo de nuevo.';
  @override String get sessionExpiredDialogTitle => 'Sesión caducada';
  @override String get sessionExpiredDialogBody  => 'Tu sesión ha caducado. Vuelve a iniciar sesión para continuar.';

  // ── Onboarding welcome step ───────────────────────────────────────────────
  @override String get welcomeTo => 'Bienvenido a';
  @override String get onboardingIntro => 'Para comenzar, configuraremos\ntu perfil para ';
  @override String get onboardingPersonalize => 'personalizar tu experiencia.';
  @override String get infoCardTitle => 'Tu información';
  @override String get infoCardSubtitle => 'Edad, sexo, talla, peso';
  @override String get measuresCardTitle => 'Tus medidas';
  @override String get measuresCardSubtitle => 'Cintura, caderas, bíceps…';
  @override String get objectivesCardTitle => 'Tus objetivos';
  @override String get objectivesCardSubtitle => 'Perder peso, ganar masa o mantenerse';
  @override String get aiNoteText => 'Esto solo toma unos momentos y permite que la IA sugiera ';
  @override String get aiNoteHighlight => 'recomendaciones personalizadas.';
  @override String get nextStepLabel => 'Siguiente paso: ingresa tus datos';
}



