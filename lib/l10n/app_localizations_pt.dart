import 'app_localizations.dart';



// Português Brasileiro (pt-BR)

class AppLocalizationsPt extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Início';

  @override String get navScan => 'Escanear';

  @override String get navCoach => 'Coach IA';

  @override String get navProgress => 'Progresso';

  @override String get navProfile => 'Perfil';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Seu coach de nutrição com IA';

  @override String get sessionExpired => 'Sessão encerrada';

  @override String get reconnect => 'Fazer login novamente';

  @override String get cancel => 'Cancelar';

  @override String get confirm => 'Confirmar';

  @override String get save => 'Salvar';

  @override String get retry => 'Tentar novamente';

  @override String get loading => 'Carregando…';

  @override String get error => 'Erro';

  @override String get later => 'Mais tarde';

  @override String get quit => 'Sair';

  @override String get close => 'Fechar';

  @override String get back => 'Voltar';

  @override String get refresh => 'Atualizar';

  @override String get next => 'Próximo';

  @override String get skip => 'Pular';

  @override String get accept => 'Aceitar';

  @override String get refuse => 'Recusar';

  @override String get yes => 'Sim';

  @override String get no => 'Não';

  @override String get optional => 'Opcional';

  @override String get recommended => 'Recomendado';

  @override String get popular => 'Popular';



  // ── Auth ────────────────────────────────────────────────────────────────────

  @override String get signIn => 'Entrar';

  @override String get createAccount => 'Criar conta';

  @override String get email => 'E-mail';

  @override String get emailHint => 'seu@email.com';

  @override String get emailRequired => 'E-mail obrigatório';

  @override String get emailInvalid => 'E-mail inválido';

  @override String get password => 'Senha';

  @override String get passwordHint => '••••••••';

  @override String get passwordRequired => 'Senha obrigatória';

  @override String get passwordMin8 => 'Mínimo de 8 caracteres';

  @override String get confirmPassword => 'Confirmar senha';

  @override String get passwordMismatch => 'As senhas não coincidem';

  @override String get firstName => 'Nome / Sobrenome';

  @override String get firstNameHint => 'João Silva';

  @override String get firstNameRequired => 'Nome obrigatório (mín. 2 caracteres)';

  @override String get phone => 'Telefone (opcional)';

  @override String get phoneHint => '+55 11 9 0000-0000';

  @override String get country => 'País';

  @override String get chooseCountry => 'Escolher um país';

  @override String get searchCountry => 'Buscar um país…';

  @override String get currency => 'Moeda preferida';

  @override String get chooseCurrency => 'Escolher moeda';

  @override String get searchCurrency => 'Buscar — BRL, Dólar, Euro…';

  @override String get loginButton => 'Entrar';

  @override String get registerButton => 'Criar minha conta';

  @override String get mustAcceptPrivacy => 'Por favor aceite a política de privacidade';

  @override String get iAcceptThe => 'Aceito a ';

  @override String get privacyPolicyLink => 'política de privacidade e termos';



  // ── Dashboard ───────────────────────────────────────────────────────────────

  @override String helloUser(String name) => 'Olá, $name';

  @override String get today => 'Hoje';

  @override String get goal => 'Meta';

  @override String get planning => 'plano';

  @override String get kcalPerDay => 'kcal / dia';

  @override String get progression => 'Progresso';

  @override String get last7Days => 'Últimos 7 dias';

  @override String get todayMeals => 'Refeições de hoje';

  @override String get noMealsToday => 'Nenhuma refeição registrada hoje.\nEscanear sua próxima refeição!';

  @override String get missingMeasurements => 'Medidas de hoje faltando';

  @override String get bodyMeasurementsHint => 'Peso, cintura, bíceps…';

  @override String get measurementsDoneToday => 'Medidas registradas hoje';

  @override String get proteins => 'Proteínas';

  @override String get carbs => 'Carboidratos';

  @override String get fats => 'Gorduras';



  // ── Scan ────────────────────────────────────────────────────────────────────

  @override String get analyzeMeal => 'Analisar uma refeição';

  @override String get scanSubtitle => 'Tire uma foto da sua refeição para obter a análise nutricional completa';

  @override String get loginRequired => 'Login necessário — por favor, faça login';

  @override String get mealSaved => 'Refeição salva';

  @override String get takePhoto => 'Tirar uma foto';

  @override String get chooseGallery => 'Escolher da galeria';

  @override String get addPhoto => 'Adicionar foto';

  @override String get photoHint => 'Tire ou importe uma foto da sua refeição';

  @override String get adjustPortion => 'Ajustar porção';

  @override String get precisions => 'Detalhes (opcional)';

  @override String get precisionsHint => 'Descreva sua refeição para melhorar a análise';

  @override String get precisionsPlaceholder => 'Ex: frango grelhado com arroz branco e legumes…';

  @override String get analyzing => 'Analisando…';

  @override String get aiIdentification => 'Identificação por IA';

  @override String portionEstimated(int grams) => 'Porção estimada: $grams g';

  @override String get healthScore => 'Pontuação de saúde';

  @override String get micronutrients => 'Micronutrientes';

  @override String get tip => 'Dica';

  @override String get iWillEat => 'Vou comer';

  @override String get reanalyze => 'Reanalisar';

  @override String get newPhoto => 'Nova foto';

  @override String get confirmEat => 'Confirmar consumo?';

  @override String get confirmEatButton => 'Sim, comi isso';

  @override String get fibers => 'Fibras';

  @override String get entirePlate => 'Prato inteiro';

  @override String get halfPortion => 'Meia porção';



  // ── Coach ───────────────────────────────────────────────────────────────────

  @override String get coachTitle => 'Coach IA';

  @override String get coachSubtitle => 'Seu assistente de nutrição pessoal';

  @override String get chatTab => 'Chat';

  @override String get dishesTab => 'Pratos';

  @override String get planningTab => 'Planejamento';

  @override String planningRequired(String plan) => 'Plano $plan necessário';

  @override String get whatYouGet => 'O que você recebe';

  @override String get aiDishes => 'Pratos personalizados com IA';

  @override String get personalizedRecipes => 'Receitas adaptadas ao seu perfil e dieta';

  @override String get dietOptions9 => '9 opções de dieta disponíveis';

  @override String get exactIngredients => 'Ingredientes pesados e macros calculados';

  @override String get dailyUpdate => 'Atualizado todos os dias';

  @override String get planningTitle => 'Plano nutricional';

  @override String get planningDescription => 'Um plano de 7 dias gerado pela IA conforme seu objetivo';

  @override String get caloricTarget => 'Meta calórica';

  @override String get adaptedToGoal => 'Adaptado ao seu objetivo';

  @override String get dailyTips => 'Dicas diárias';

  @override String upgradePlan(String plan) => 'Evoluir para $plan';

  @override String get continueFreePlan => 'Continuar com o plano gratuito';

  @override String get dietRegime => 'Tipo de dieta';

  @override String generateRegime(String diet) => 'Gerar pratos $diet';

  @override String generatingRegime(String diet) => 'Gerando pratos $diet…';

  @override String get aiAdaptation => 'Adaptação por IA';

  @override String get ingredients => 'Ingredientes';

  @override String get breakfast => 'Café da manhã';

  @override String get lunch => 'Almoço';

  @override String get dinner => 'Jantar';

  @override String get weekPlanning => 'Planejamento semanal';

  @override String get generatingPlanning => 'Gerando plano…';

  @override String get dayDetail => 'Detalhe do dia';

  @override String get regenerate => 'Regenerar';

  @override String get noPlanning => 'Nenhum plano gerado';

  @override String get pressToRegenerate => 'Toque para gerar seu plano';

  @override String todayKcalInfo(int kcal, int remaining) => '$kcal kcal hoje · $remaining restantes';

  @override String get noMessagesYet => 'Nenhuma mensagem ainda';

  @override String get typingMessage => 'Digite uma mensagem…';

  @override String coachWelcome(String name) => 'Olá $name! Sou seu coach de nutrição com IA. Como posso te ajudar?';



  // ── Settings ────────────────────────────────────────────────────────────────

  @override String get myAccount => 'Minha conta';

  @override String get logout => 'Sair';

  @override String get logoutConfirm => 'Tem certeza que deseja sair?';

  @override String get logoutCancel => 'Cancelar';

  @override String get logoutConfirmButton => 'Sair';

  @override String get userLabel => 'Usuário';

  @override String get information => 'Informações';

  @override String get name => 'Nome';

  @override String get emailLabel => 'E-mail';

  @override String get phoneLabel => 'Telefone';

  @override String get countryLabel => 'País';

  @override String get subscription => 'Assinatura';

  @override String get freeLabel => 'Gratuito';

  @override String get loggingOut => 'Saindo…';

  @override String get language => 'Idioma';

  @override String get chooseLanguage => 'Escolher idioma';



  // ── Profile ─────────────────────────────────────────────────────────────────

  @override String get myProfile => 'Meu perfil';

  @override String get bmi => 'IMC';

  @override String get bmiUnderweight => 'Abaixo do peso';

  @override String get bmiNormal => 'Normal';

  @override String get bmiOverweight => 'Sobrepeso';

  @override String get bmiObese => 'Obesidade';

  @override String get objective => 'Objetivo';

  @override String kcalPerDayValue(int v) => '$v kcal/dia';

  @override String get identity => 'Identidade';

  @override String get gender => 'Gênero';

  @override String get male => 'Masculino';

  @override String get female => 'Feminino';

  @override String get age => 'Idade';

  @override String get weight => 'Peso (kg)';

  @override String get height => 'Altura (cm)';

  @override String get bodyMeasurements => 'Medidas corporais';

  @override String get bodyMeasurementsHintProfile => 'Opcional — para acompanhar seu progresso';

  @override String get waist => 'Cintura (cm)';

  @override String get biceps => 'Bíceps (cm)';

  @override String get belly => 'Abdômen (cm)';

  @override String get weightGoal => 'Objetivo';

  @override String get loseWeight => 'Perder peso';

  @override String get gainMass => 'Ganhar músculo';

  @override String get maintain => 'Manter';

  @override String get eatHealthy => 'Comer saudável';

  @override String get lossRhythm => 'Ritmo de perda';

  @override String get gainRhythm => 'Ritmo de ganho';

  @override String get soft => 'Suave';

  @override String get moderate => 'Moderado';

  @override String get sustained => 'Sustentado';

  @override String get intense => 'Intenso';

  @override String get lean => 'Lean';

  @override String get aggressive => 'Agressivo';

  @override String get aggressiveWarning => 'Ritmo agressivo — pode causar perda muscular. Consulte um profissional.';

  @override String get activityLevel => 'Nível de atividade';

  @override String get saveProfile => 'Salvar perfil';

  @override String get goPremium => 'Ser Premium';

  @override String get appInfo => 'Informações do app';

  @override String get version => 'Versão';



  // ── Onboarding ──────────────────────────────────────────────────────────────

  @override String get configureProfile => 'Configurar meu perfil →';

  @override String get profileTitle => 'Seu perfil';

  @override String get profileSubtitle => 'Essas informações são usadas para calcular suas necessidades calóricas.';

  @override String get yourFirstName => 'Seu nome';

  @override String get firstNameEx => 'Ex: Maria';

  @override String get genderLabel => 'Gênero';

  @override String get goalLabel => 'Seu objetivo';

  @override String get goalQuestion => 'Qual é seu objetivo principal?';

  @override String get rhythmLabel => 'Ritmo desejado (kg/semana)';

  @override String get bodyMeasurementsLabel => 'Medidas corporais (opcional)';

  @override String get activityDiet => 'Atividade e dieta';

  @override String get activityLevelLabel => 'Nível de atividade';

  @override String get dietLabel => 'Preferências alimentares (opcional)';

  @override String get welcome => 'Bem-vindo ao DietVision';

  @override String get welcomeSubtitle => "Seu coach de nutrição e fitness com IA.\nAnalise suas refeições, acompanhe seus macros e alcance seus objetivos.";

  @override String get createProfile => 'Criar meu perfil';

  @override String get continueButton => 'Continuar →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Alcance seus objetivos\nmais rápido com Premium';

  @override String get paywallSubtitle => "Tudo o que você precisa, em um só app.";

  @override String get choosePlan => 'Escolha seu plano';

  @override String get unlimitedScan => 'Scan IA ilimitado';

  @override String get featureSubScan => 'Analise qualquer refeicao em 3 segundos';

  @override String get personalizedCoach => 'Coach IA personalizado';

  @override String get featureSubCoach => 'Conselhos adaptados ao seu perfil';

  @override String get nutritionPlanning => 'Planejamento nutricional';

  @override String get featureSubPlanning => 'Plano de 7 dias gerado pela IA';

  @override String get customRecipes => 'Receitas personalizadas';

  @override String get featureSubRecipes => 'Ingredientes pesados e macros calculados';

  @override String get progressTracking => 'Acompanhamento de progresso';

  @override String get featureSubProgress => 'Graficos e tendencias de longo prazo';

  @override String get dailyReminders => 'Lembretes diários';

  @override String get featureSubReminders => 'Motivacao todas as manhas';

  @override String get perMonth => '/ mes';

  @override String get rating => '4,8 / 5 — Mais de 2.000 usuários';

  @override String get freeTrial => 'Teste gratuito';

  @override String get continueFreePlanLabel => 'Continuar com o plano gratuito';

  @override String get noCommitment => 'Sem compromisso · Cancele quando quiser';

  @override String get accountRequired => 'Conta necessária';

  @override String get accountRequiredDesc => "Para assinar, crie uma conta gratuita em 30 segundos.\n\nVocê poderá escolher seu plano logo em seguida.";

  @override String get createAccountButton => 'Criar uma conta';

  @override String get premiumMonthly => 'Premium Mensal';

  @override String get premiumYearly => 'Premium Anual';

  @override String get save40 => 'ECONOMIZE 40%';



  // ── Progress ─────────────────────────────────────────────────────────────────

  @override String get progressTitle => 'Progresso';

  @override String mealsAndEntries(int meals, int entries) => '$meals refeições · $entries medidas';

  @override String get measurementsOk => 'Medidas OK';

  @override String get todayLabel => 'Hoje';

  @override String get mealsTab => 'Refeições';

  @override String get bodyTab => 'Corpo';

  @override String get todayMeasurements => 'Medidas de hoje';

  @override String get fillAvailable => 'Preencha os campos disponíveis';

  @override String get noMeasurements => 'Sem medidas';

  @override String get addFirstMeasures => 'Adicione suas primeiras medidas';

  @override String get lastMeasurements => 'Últimas medidas';

  @override String get projectionGoal => 'Projeção para o objetivo';

  @override String get onTrack => 'No caminho certo';

  @override String get late => 'Atrasado';

  @override String get wrongDirection => 'Direção errada';

  @override String get accomplished => 'Conquistado';

  @override String get estimatedDate => 'Data estimada';

  @override String get currentRhythm => 'Ritmo atual';

  @override String get reverseTrend => 'Inverter tendência';

  @override String get stable => 'Estável';

  @override String get in1Week => 'Em 1 semana';

  @override String inXWeeks(int n) => 'Em $n semanas';

  @override String get goalReached => 'Objetivo alcançado!';

  @override String get weightGoingWrong => 'O peso está indo na direção errada';

  @override String get noMeals => 'Sem refeições';

  @override String get scanFirst => 'Escaneie sua primeira refeição para começar';

  @override String get fullHistory => 'Histórico completo';

  @override String get saveMeasurements => 'Salvar medidas';



  // ── Consent ─────────────────────────────────────────────────────────────────

  @override String get beforeStart => 'Antes de começar';

  @override String get privacyTitle => 'Política de privacidade e Termos de uso';

  @override String get rgpdLabel => 'LGPD';

  @override String get officialDoc => '↗ Documento oficial';

  @override String get scrollToAccept => 'Leia até o final para aceitar';

  @override String get dataCollected => 'Dados coletados';

  @override String get legalBasis => 'Base legal do tratamento';

  @override String get purposes => 'Finalidades do tratamento';

  @override String get subprocessors => 'Suboperadores e transferências';

  @override String get retention => 'Período de retenção';

  @override String get yourRights => 'Seus direitos (LGPD)';

  @override String get security => 'Segurança';

  @override String get controller => 'Controlador de dados';

  @override String get iAccept => "Li e aceito a política de privacidade e os termos de uso do DietVision. Consinto com o tratamento dos meus dados de saúde para fins de coaching nutricional.";

  @override String get refuseButton => 'Recusar';

  @override String get acceptButton => 'Aceitar e continuar';

  @override String get scrollToBottom => 'Role até o final para ativar a aceitação';

  @override String get leaveApp => 'Sair do app';

  @override String get leaveAppDesc => "Sem aceitar a política de privacidade, você não pode usar o DietVision. Deseja sair do app?";

  @override String get youReachedEnd => 'Você chegou ao final do documento';



  // ── Splash ──────────────────────────────────────────────────────────────────

  @override String get tagline => 'COMA · ESCANEIE · PROGRIDA';



  // ── Subscription ────────────────────────────────────────────────────────────

  @override String get premiumTitle => 'Premium';

  @override String get goPremiumButton => 'Ser Premium';

  @override String get premiumDesc => 'Desbloqueie todas as funcionalidades';

  @override String get paymentReady => 'Seu pagamento seguro está pronto.';

  @override String get paymentMethods => 'Visa, Mastercard, Apple Pay aceitos. Um campo de código promocional está disponível na página de pagamento.';

  @override String get promoCode => 'Tem um código promocional? Digite-o diretamente na página de pagamento do Stripe.';

  @override String get payNow => 'Pagar agora';

  @override String get openingBrowser => 'Finalize seu pagamento no navegador e volte aqui.';

  @override String get iHavePaid => 'Paguei — Confirmar';

  @override String get reopenPayment => 'Reabrir página de pagamento';

  @override String get securedByStripe => 'Pagamento seguro Stripe · TLS 256-bit';

  @override String get subscriptionActive => 'Assinatura ativada!';

  @override String get subscriptionActiveDesc => 'Sua assinatura está ativa.\nAproveite todas as funcionalidades sem restrições!';

  @override String get start => 'Começar';

  @override String get noPlanAvailable => 'Nenhum plano disponível.';

  @override String get securityNote => 'Pagamento seguro Stripe · TLS 256-bit';

  @override String savePercent(int p) => 'ECONOMIZE $p%';

  @override String get notAvailableYet => "Este plano ainda não está disponível.";

  @override String cannotOpenBrowser(String e) => "Não é possível abrir o navegador: $e";

  @override String get paymentUnconfirmed => 'Pagamento não confirmado — se você acabou de pagar, aguarde alguns segundos e tente novamente.';

  @override String subscribePlan(String price) => 'Começar — $price';

  @override String get comingSoon => 'Em breve';

  @override String get cannotLoadPlans => 'Não é possível carregar os planos';



  // ── Diets ───────────────────────────────────────────────────────────────────

  @override String get dietOmnivore => 'Onívoro';

  @override String get dietHalal => 'Halal';

  @override String get dietVegetarian => 'Vegetariano';

  @override String get dietVegan => 'Vegano';

  @override String get dietKeto => 'Keto';

  @override String get dietMediterranean => 'Mediterrâneo';

  @override String get dietGlutenFree => 'Sem glúten';

  @override String get dietPaleo => 'Paleo';

  @override String get dietDairy => 'Sem lactose';

  @override String get dietHighProtein => 'Rico em proteínas';

  @override String get dietLowCalorie => 'Baixo em calorias';



  // ── Coach extras ─────────────────────────────────────────────────────────────

  @override String get dietFromProfile => 'Dieta do seu perfil';

  @override String get generating => 'Gerando…';

  @override String get actualize => 'Atualizar';

  @override String get typing => 'Digitando…';

  @override String generateDishes(String diet) => 'Pratos $diet';

  @override String get generateDishesDesc => 'A IA gera 3 receitas personalizadas adaptadas\nao seu perfil, calorias restantes\ne dieta selecionada.';

  @override String planAvailableWith(String plan) => 'Disponível com o plano $plan';

  @override String get planAvailableWithProOrPremium => 'Disponível com o plano Pro ou Premium';

  @override String get currentPlanLabel => 'Plano atual';

  @override String get freePlanLabel => 'Gratuito';



  // ── Day names (short) ────────────────────────────────────────────────────────

  @override String get dayMon => 'Seg';

  @override String get dayTue => 'Ter';

  @override String get dayWed => 'Qua';

  @override String get dayThu => 'Qui';

  @override String get dayFri => 'Sex';

  @override String get daySat => 'Sáb';

  @override String get daySun => 'Dom';



  // ── Day names (full) ─────────────────────────────────────────────────────────

  @override String get dayMonFull => 'Segunda';

  @override String get dayTueFull => 'Terça';

  @override String get dayWedFull => 'Quarta';

  @override String get dayThuFull => 'Quinta';

  @override String get dayFriFull => 'Sexta';

  @override String get daySatFull => 'Sábado';

  @override String get daySunFull => 'Domingo';



  // ── Chat suggestions ─────────────────────────────────────────────────────────

  @override String get suggestion1 => 'Sugira um plano de refeições para amanhã';

  @override String get suggestion2 => 'Quais alimentos para ganhar massa muscular?';

  @override String get suggestion3 => 'Meu resumo nutricional semanal';

  @override String get suggestion4 => 'Melhores lanches pós-treino';



  // ── Body measurements extras ──────────────────────────────────────────────────

  @override String get chest => 'Peito';

  @override String get hips => 'Quadril';

  @override String get thighs => 'Coxas';



  // ── Activity levels ─────────────────────────────────────────────────────────

  @override String get activitySedentary => 'Sedentário';

  @override String get activityLight => 'Leve (1-2 dias/sem)';

  @override String get activityModerate => 'Moderado (3-4 dias/sem)';

  @override String get activityActive => 'Ativo (5-6 dias/sem)';

  @override String get activityVeryActive => 'Muito ativo';



  // ── Dashboard extras ─────────────────────────────────────────────────────────

  @override String get kcalRemaining => 'kcal restantes';

  @override String get kcalExceeded => 'kcal em excesso';



  // ── Subscription gate ─────────────────────────────────────────────────────────

  @override String get trialExpiredTitle => 'Seu período de teste expirou';

  @override String get trialExpiredSubtitle => 'Assine para continuar usando o DietVision e acessar todos os recursos.';

  @override String get alreadyPaidCheck => 'Já pagou? Verificar minha assinatura';

  @override String get noActiveSubscription => 'Nenhuma assinatura ativa encontrada.';

  @override String get checkingSubscription => 'Verificando…';



  // ── Plan card labels ──────────────────────────────────────────────────────────

  @override String get yourCurrentPlan => 'SEU PLANO ATUAL';

  @override String get trialExpiredToday => 'Teste expirado hoje';

  @override String trialExpiredDaysAgo(int days) => 'Teste expirado há $days dia(s)';

  @override String trialDaysRemaining(int days) => days == 1 ? 'Teste: 1 dia restante â³' : 'Teste: $days dias restantes â³';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Mensal';

  @override String get billingQuarterly => '3 meses';

  @override String get billingSemiAnnual => '6 meses';

  @override String get billingYearly => 'Anual';

  @override String get bestOffer => 'ðŸ† Melhor oferta';

  @override String savingPerMonth(String amt) => '-$amt/mês';

  @override String perDay(String amt) => '$amt/dia';

  @override String get lessThanCoffee => 'Menos que um café ☕';

  @override String get guarantee30Days => 'Garantia de 30 dias';

  @override String get specialOffer => 'ðŸŽ OFERTA ESPECIAL';

  @override String offerExpiresIn(int h, int m) => 'Expira em ${h}h ${m}min';

  @override String get trialSummaryTitle => 'O que você conquistou';

  @override String mealsScannedCount(int n) => '$n refeições escaneadas';

  @override String get scanUpsellTitle => 'Análise concluída! 🎉';

  @override String get scanUpsellBody => 'Atualize para o Pro para análises ilimitadas e recomendações de IA personalizadas.';

  @override String get upgradeNow => 'Ver planos';

  @override String get notNow => 'Agora não';

  @override String annualSavingsBanner(String amt) => 'ðŸŽ Economize $amt com o anual';

  @override String get trialNotifJ7 => 'Ainda 7 dias de teste';

  @override String get trialNotifJ7Body => 'Aproveite mais 7 dias — depois escolha seu plano.';

  @override String get trialNotifJ3 => 'Apenas 3 dias restantes!';

  @override String get trialNotifJ3Body => 'Oferta especial: -40% no plano anual. Aproveite agora!';

  @override String get trialNotifJ1 => 'Último dia de teste 🔔';

  @override String get trialNotifJ1Body => 'Seu teste expira amanhã. Não perca seu progresso!';



  // ── Payment verification ───────────────────────────────────────────────────────

  @override String get verifyingPayment => 'Verificando pagamento…';

  @override String get stepPaymentConfirmed => 'Pagamento confirmado ✓';

  @override String get stepServerNotified => 'Servidor notificado ✓';

  @override String get stepInvoiceSent => 'Fatura enviada por email ✓';

  @override String get paymentVerifiedTitle => 'Assinatura ativada!';

  @override String get paymentVerifiedDesc => 'Sua assinatura está ativa. Uma fatura foi enviada para o seu email. Aproveite todos os recursos!';

  @override String get serverNotYetNotified => 'O servidor ainda não recebeu a confirmação. Aguarde alguns segundos e tente novamente.';

  @override String get retryVerification => 'Tentar verificação novamente';

  @override String webhookPolling(int attempt, int max) => 'Verificando servidor… tentativa $attempt/$max';

  @override String get webhookNotReceived => 'O servidor não recebeu o webhook do Stripe após várias tentativas.';

  @override String get webhookReceived => 'Webhook do Stripe recebido e processado ✓';



  // -- Email verification

  @override String get verifyEmailTitle => 'Verifique seu e-mail';

  @override String get verifyEmailDesc => 'Enviamos um código de 6 dígitos para';

  @override String get verifyCode => 'Verificar código';

  @override String get resendCode => 'Reenviar código';

  @override String get skipForNow => 'Voltar';

  @override String get checkSpam => 'Verifique também sua pasta de spam se não encontrar o e-mail.';


  // -- Password strength & forgot password
  @override String get passwordNeedsUppercase => 'Deve conter pelo menos uma letra maiúscula';
  @override String get passwordNeedsNumberOrSymbol => 'Deve conter pelo menos um número ou caractere especial';
  @override String get forgotPassword => 'Esqueceu a senha?';
  @override String get forgotPasswordTitle => 'Senha esquecida';
  @override String get forgotPasswordDesc => 'Digite seu endereço de e-mail. Enviaremos um código de 6 dígitos para redefinir sua senha.';
  @override String get sendResetCode => 'Enviar código';
  @override String get resetPasswordTitle => 'Nova senha';
  @override String get resetPasswordDesc => 'Digite o código recebido por e-mail e escolha uma nova senha.';
  @override String get newPassword => 'Nova senha';
  @override String get resetPassword => 'Redefinir senha';
  @override String get passwordResetSuccess => 'Senha redefinida!';
  @override String get passwordResetSuccessDesc => 'Sua senha foi alterada com sucesso. Você pode fazer login agora.';
}



