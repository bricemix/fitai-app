import 'app_localizations.dart';



// Português Brasileiro (pt-BR)

class AppLocalizationsPt extends AppLocalizations {

  // ── Navigation ──────────────────────────────────────────────────────────────

  @override String get navHome => 'Início';

  @override String get navScan => 'Escanear';

  @override String get navCoach => 'Diet Coach';

  @override String get navProgress => 'Progresso';

  @override String get navProfile => 'Perfil';



  // ── App général ─────────────────────────────────────────────────────────────

  @override String get appName => 'DietVision';

  @override String get appSubtitle => 'Seu coach de nutrição com IA';

  @override String get sessionExpired => 'Sessão encerrada';

  @override String get reconnect => 'Fazer login novamente';

  @override String get cancel => 'Cancelar';

  @override String get confirm => 'Confirmar';

  @override String get save   => 'Salvar';
  @override String get change => 'Alterar';

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

  @override String get birthDate      => 'Data de nascimento';
  @override String get birthDateHint  => 'DD/MM/AAAA';
  @override String get underageTitle  => 'Acesso restrito';
  @override String get underageBody   => 'O DietVision é destinado a pessoas com 15 anos ou mais.\n\nSe tiveres menos de 15 anos, a utilização desta aplicação requer o consentimento de um pai ou tutor legal.\n\nPede a um adulto que crie uma conta e te acompanhe no acompanhamento da tua nutrição.';
  @override String get underageButton => 'Entendi';



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

  @override String get measurementsDoneToday        => 'Medidas registradas hoje';
  @override String get bodyMeasurementsSubtitle     => 'Peso · Cintura · Bíceps';
  @override String get syncedLabel                  => 'Dados atualizados';
  @override String get stayFocused                  => 'Mantém o foco, cada ação conta!';
  @override String get dailyProgress                => 'Progresso\ndiário';

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

  @override String get camera => 'Câmera';
  @override String get gallery => 'Galeria';
  @override String get photoTipsTitle => 'DICAS DE FOTO';
  @override String get tipFramePlate => 'Enquadrar o prato';
  @override String get tipGoodLight => 'Boa iluminação';
  @override String get tipTopView => 'Vista de cima';
  @override String get tipVisibleFood => 'Alimento visível';
  @override String get tipFullPlate => 'Prato completo';
  @override String get tipNoFlash => 'Sem flash';

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

  @override String get coachTitle => 'Diet Coach';

  @override String get coachSubtitle => 'Seu assistente de nutrição pessoal';

  @override String get chatTab => 'Chat';

  @override String get dishesTab => 'Pratos';
  @override String get dishesPlanRequired => 'As recomendações de pratos por IA estão disponíveis a partir do plano Pro.';
  @override String get dishesLimitReached => 'Limite diário de pratos recomendados atingido. Volte amanhã ou mude de plano.';

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
  @override String get restrictionVegetarian => 'Vegetariano';
  @override String get restrictionVegan      => 'Vegan';
  @override String get restrictionGlutenFree => 'Sem glúten';
  @override String get restrictionLactoseFree=> 'Sem lactose';
  @override String get restrictionHalal      => 'Halal';
  @override String get restrictionKeto       => 'Keto';

  @override String get welcome => 'Bem-vindo ao DietVision';

  @override String get welcomeSubtitle => "Seu coach de nutrição e fitness com IA.\nAnalise suas refeições, acompanhe seus macros e alcance seus objetivos.";

  @override String get createProfile => 'Criar meu perfil';

  @override String get continueButton => 'Continuar →';



  // ── Paywall ─────────────────────────────────────────────────────────────────

  @override String get paywallTitle => 'Alcance seus objetivos\nmais rápido com Premium';

  @override String get paywallSubtitle => "Tudo o que você precisa, em um só app.";

  @override String get chipMealScan       => 'Scan refeição';
  @override String get chipMacroTracking  => 'Rastreio macros';
  @override String get chipAiCoach        => 'Coach IA';
  @override String get paywallFeaturesPrefix    => 'Tudo o que\nprecisas para ';
  @override String get paywallFeaturesHighlight => 'ter sucesso';
  @override String get paywallFeaturesSubtitle  => 'Ferramentas inteligentes para atingir os teus objetivos nutricionais.';
  @override String get paywallPlanPrefix    => 'Escolhe\no teu ';
  @override String get paywallPlanHighlight => 'plano';
  @override String get paywallPlanSubtitle  => 'Começa o teu período de teste gratuito. Cancela a qualquer momento.';

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

  @override String get perMonth   => '/ mes';
  @override String get perYear    => '/ ano';
  @override String get perQuarter => '/ trim.';
  @override String get per6Months => '/ 6 meses';

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
  @override String get kcalExceeded  => 'kcal em excesso';
  @override String get kcalOver      => 'kcal a mais';

  // ── Context Day Card ─────────────────────────────────────────────────────────
  @override String get protLow       => 'baixas';
  @override String get protModerate  => 'moderadas';
  @override String get protGood      => 'boas';
  @override String get goalWeightLoss => 'perda de peso';
  @override String get goalMassGain  => 'ganho de massa';
  @override String get goalMaintain  => 'manutenção';
  @override String get labelProteins => 'Proteínas';
  @override String get labelGoal     => 'Objetivo:';
  @override String get labelDiet     => 'Dieta:';
  @override String ctxDescSurplus(int surplus) => 'Você está com +$surplus kcal em excesso. Posso sugerir pratos mais leves para equilibrar o seu dia.';
  @override String get ctxDescLowProt => 'Sua ingestão de proteínas está baixa. Posso ajudá-lo a reequilibrar suas macros.';
  @override String get ctxDescDefault => 'Posso ajudá-lo a construir o seu dia com base nas calorias restantes e no seu objetivo.';

  // ── Smart Actions labels ──────────────────────────────────────────────────────
  @override String get smartBuildDay        => 'Construa meu dia';
  @override String smartBuildDaySub(int k)  => 'com $k kcal restantes';
  @override String smartSurplusTitle(int k)  => 'Excesso +$k kcal';
  @override String get smartSurplusSub      => 'Como equilibrar?';
  @override String get smart3Dishes         => 'Me dê 3 pratos';
  @override String get smart3DishesSub      => 'ricos em proteínas';
  @override String get smartAnalyzeBilan    => 'Analise meu balanço';
  @override String get smartAnalyzeBilanSub => 'nutricional da semana';
  @override String get smartPrepareDinner   => 'Prepare meu jantar';
  @override String get smartPrepareDinnerSub => 'de hoje à noite';

  // ── Pro gate ─────────────────────────────────────────────────────────────────
  @override String get gateDishesAdaptedRecipes    => 'Receitas adaptadas\nao seu perfil\ne dieta';
  @override String get gateDishes9Diets            => '9 regimes\nalimentares\ndisponíveis';
  @override String get gateDishesWeighedIngredients => 'Ingredientes pesados\n& macros\ncalculados';
  @override String get gateDishesUpdatedDaily      => 'Atualizado\ndiariamente';
  @override String get tableHeaderFeatures         => 'Funcionalidades';
  @override String get tableRowPersonalizedDishes  => 'Pratos IA personalizados';
  @override String get tableRowAdaptedRecipes      => 'Receitas adaptadas ao seu perfil';
  @override String get tableRowWeighedIngredients  => 'Ingredientes pesados & macros calculados';
  @override String get tableRowUpdatedDaily        => 'Atualizado diariamente';

  // ── Premium gate ─────────────────────────────────────────────────────────────
  @override String get gatePlanningWeekPlan    => 'Plano de 7 dias\ngerado por IA\nsegundo o seu objetivo';
  @override String get gatePlanningCaloricGoal => 'Objetivo calórico\ne macros\ncalculados';
  @override String get gatePlanningAdapted     => 'Adaptado ao\nseu objetivo';
  @override String get gatePlanningDailyTips   => 'Dicas diárias\n& acompanhamento inteligente';
  @override String get planStarterSubtitle     => 'Funções básicas';
  @override String get planProSubtitle         => 'Receitas & dietas IA';
  @override String get planPremiumSubtitle     => 'Planejamento nutricional IA';
  @override String get planIncluded            => 'Incluído';
  @override String get planNotIncluded         => 'Planejamento não incluído';

  // ── Quick tips ────────────────────────────────────────────────────────────────
  @override String get tipScanFirstMeal  => 'Comece digitalizando sua primeira refeição para que eu possa analisar suas macros do dia.';
  @override String get tipIncreaseProtein => 'Prioridade hoje: aumente suas proteínas na próxima refeição.';
  @override String tipCaloriesAvailable(int pct) => 'Você ainda tem $pct% de suas calorias disponíveis. Pense na sua próxima refeição!';
  @override String get tipCaloriesExceeded => 'Objetivo calórico excedido. Esta noite aposte em alimentos leves e ricos em fibras.';
  @override String get tipKeepGoing       => 'Continue assim! Seu dia está bem equilibrado — mantenha o rumo.';
  @override String get newChat => 'Nova conversa';
  @override String get clearChatTitle => 'Limpar conversa?';
  @override String get clearChatConfirm => 'O histórico do chat será excluído permanentemente.';
  @override String get clearChatConfirmBtn => 'Limpar';
  @override String promptCreatePlanSurplus(int surplus, String diet) => "Estou com +$surplus kcal de superávit hoje. Ajude-me a equilibrar o resto do meu dia com minha dieta $diet.";
  @override String promptCreatePlanNormal(int remaining, String diet) => "Crie meu plano alimentar para hoje com $remaining kcal restantes e minha dieta $diet.";
  @override String get promptFixMacros => "Analise e corrija meus macros de hoje. Dê-me conselhos concretos para equilibrar proteínas, carboidratos e gorduras.";
  @override String get promptAnalyzeProgress => "Analise meu progresso nutricional semanal e dê-me 3 dicas personalizadas para melhorar.";
  @override String promptSurplusBalance(int surplus, int tdee) => "Estou com +$surplus kcal de superávit hoje (objetivo: $tdee kcal/dia). Dê-me conselhos para equilibrar meu dia e limitar os efeitos do superávit.";
  @override String promptBuildDay(int remaining, String diet) => "Crie um plano de refeições completo para hoje com $remaining kcal restantes, adaptado à minha dieta $diet e aos meus objetivos.";
  @override String prompt3Dishes(String diet) => "Sugira 3 pratos ricos em proteínas (mínimo 30g por prato) adaptados à minha dieta $diet.";
  @override String get promptAnalyzeBilan => "Analise meu balanço nutricional semanal e dê-me conselhos concretos para melhorar.";
  @override String promptDinnerSurplus(int surplus, int tdee, String diet) => "Estou com +$surplus kcal de superávit hoje (objetivo: $tdee kcal/dia). Sugira uma refeição leve para esta noite adaptada à minha dieta $diet.";
  @override String promptDinnerNormal(int remaining, String diet) => "Sugira uma refeição para esta noite que corresponda às minhas $remaining kcal restantes e à minha dieta $diet.";



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

  @override String trialDaysRemaining(int days) => days == 1 ? 'Teste: 1 dia restante ' : 'Teste: $days dias restantes ';
  @override String get statusActive => 'Ativo';
  @override String get statusInactive => 'Inativo';
  @override String get verifiedFromServer => 'Verificado do servidor';
  @override String get localCache => 'Cache local';



  // ── Billing frequency labels ──────────────────────────────────────────────────

  @override String get billingMonthly => 'Mensal';

  @override String get billingQuarterly => '3 meses';

  @override String get billingSemiAnnual => '6 meses';

  @override String get billingYearly => 'Anual';

  @override String get bestOffer => 'Melhor oferta';

  @override String savingPerMonth(String amt) => '-$amt/mês';

  @override String perDay(String amt) => '$amt/dia';

  @override String get lessThanCoffee => 'Menos que um café ☕';

  @override String get guarantee30Days => 'Garantia de 30 dias';

  @override String get specialOffer => 'OFERTA ESPECIAL';

  @override String offerExpiresIn(int h, int m) => 'Expira em ${h}h ${m}min';

  @override String get trialSummaryTitle => 'O que você conquistou';

  @override String mealsScannedCount(int n) => '$n refeições escaneadas';

  @override String get scanUpsellTitle => 'Análise concluída! 🎉';

  @override String get scanUpsellBody => 'Atualize para o Pro para análises ilimitadas e recomendações de IA personalizadas.';

  @override String get upgradeNow => 'Ver planos';

  @override String get notNow => 'Agora não';

  @override String annualSavingsBanner(String amt) => 'Economize $amt com o anual';

  @override String get trialNotifJ7 => 'Ainda 7 dias de teste';

  @override String get trialNotifJ7Body => 'Aproveite mais 7 dias — depois escolha seu plano.';

  @override String get trialNotifJ3 => 'Apenas 3 dias restantes!';

  @override String get trialNotifJ3Body => 'Oferta especial: -40% no plano anual. Aproveite agora!';

  @override String get trialNotifJ1 => 'Último dia de teste 🔔';

  @override String get trialNotifJ1Body => 'Seu teste expira amanhã. Não perca seu progresso!';



  // ── Weekly details sheet ─────────────────────────────────────────────────────

  @override String get weeklyDetails => 'Detalhes da semana';
  @override String get weeklySummaryTitle => 'Resumo semanal';
  @override String get avgKcalPerDay => 'Média';
  @override String get targetKcalDay2 => 'Meta';
  @override String get differenceKcal => 'Diferença';
  @override String proteinTargetReached(int done, int total) => 'Meta de proteínas alcançada: $done/$total dias';
  @override String get statusOnTrack => 'No caminho certo';
  @override String get statusAttention => 'Atenção';
  @override String get statusOffTrack => 'Fora da meta';
  @override String get statusNotStarted => 'Ainda não iniciado';
  @override String get editThisDay => 'Editar este dia';
  @override String get replaceMeals => 'Substituir refeições';
  @override String get copyThisDay => 'Copiar este dia';
  @override String get balanceWeek => 'Equilibrar semana';
  @override String get insightAnalysisTitle => 'Análise';
  @override String get insightWhyTitle => 'Por que é importante';
  @override String get insightActionsTitle => 'Ações sugeridas';
  @override String insightProteinAnalysis(int current, int target, int gap) =>
      'Sua meta de proteínas hoje é $target g.\nVocê está atualmente em $current g.\nFaltam cerca de $gap g de proteínas.';
  @override String insightCaloriesAnalysis(int current, int target) =>
      'Você consumiu $current kcal do seu objetivo de $target kcal.';
  @override String get insightWhyProtein => 'Atingir sua meta de proteínas ajuda a preservar a massa muscular, especialmente durante a perda de peso.';
  @override String get insightWhyCalories => 'Manter-se próximo da sua meta calórica é o fator mais importante para atingir seu objetivo de peso.';
  @override String get insightWhyWater => 'Uma boa hidratação apoia seu metabolismo e reduz a fome.';
  @override String get insightWhyCarbs => 'Gerenciar a ingestão de carboidratos ajuda a estabilizar o açúcar no sangue.';
  @override String get insightWhyNoScan => 'Registrar suas refeições ajuda a atingir seus objetivos diários.';
  @override String get insightAction1Protein => 'Iogurte grego + 2 ovos';
  @override String get insightAction1ProteinDetail => '280 kcal · 32 g proteínas';
  @override String get insightAction2Protein => 'Adicionar 150 g de frango ao jantar';
  @override String get insightAction2ProteinDetail => '+240 kcal · +45 g proteínas';
  @override String get insightIgnoreToday => 'Ignorar por hoje';
  @override String get applySuggestion => 'Aplicar sugestão';
  @override String get showAlternatives => 'Ver alternativas';
  @override String get remindMeLater => 'Lembrar mais tarde';
  @override String get progressForecast => 'Previsão de progresso';
  @override String get projectionBasis => 'Esta projeção é baseada na sua meta calórica, atividade estimada, ingestão de proteínas e consistência atual.';
  @override String get conservativeScenario => 'Conservador';
  @override String get balancedScenario => 'Equilibrado';
  @override String get aggressiveScenario => 'Intensivo';
  @override String get scenarioEasyToKeep => 'Mais fácil de manter';
  @override String get scenarioRecommended => 'Recomendado';
  @override String get scenarioHarder => 'Mais difícil — maior risco de fome';
  @override String get useBalancedPlan => 'Usar plano equilibrado';
  @override String get makeItEasierPlan => 'Facilitar';
  @override String get makeItFasterPlan => 'Acelerar';
  @override String get weekLabel => 'Semana';
  @override String get estimatedWeight => 'Peso estimado';
  @override String get weightEvolution => 'Variação';
  @override String get todayWeightLabel => 'Hoje';

  // ── Planning tab ─────────────────────────────────────────────────────────────

  @override String get weeklyBalanceScore => 'PONTUAÇÃO SEMANAL';
  @override String get onTrackThisWeek => 'Você está no caminho certo esta semana!';
  @override String get greatConsistency => 'Ótima consistência. Continue assim!';
  @override String get goodProgressPlan => 'Bom progresso, continue!';
  @override String get aFewMoreEfforts => 'Mais alguns esforços e você conseguirá.';
  @override String get stayConsistentPlan => 'Mantenha a consistência esta semana.';
  @override String get tryHitTargets => 'Tente alcançar seus objetivos diários.';
  @override String get buildYourRoutine => 'Comece a construir sua rotina!';
  @override String get everyStepCounts => 'Cada passo conta. Você consegue!';
  @override String todayKcalRemainingLabel(int n) => 'Hoje: $n kcal restantes';
  @override String get viewDetails => 'Ver detalhes';
  @override String get todayChecklist => 'Lista de hoje';
  @override String completedOfTotal(int done, int total) => '$done/$total concluídos';
  @override String get checkHitCalorie => 'Atingir meta calórica';
  @override String get checkScan2Meals => 'Escanear 2 refeições';
  @override String get checkProteinGoal => 'Meta de proteínas';
  @override String get checkWalk30 => 'Caminhar 30 min';
  @override String get checkDrinkWater => 'Beber 2,5 L de água';
  @override String get checkNoSugarAfter8pm => 'Evitar açúcar após as 20h';
  @override String get aiInsightTitle => 'Dica da IA';
  @override String get insightProteinLow => 'A ingestão de proteínas está um pouco baixa hoje. Adicione um lanche rico em proteínas esta noite.';
  @override String get insightCaloriesHigh => 'Você está próximo do seu limite calórico. Escolha um jantar leve esta noite.';
  @override String get insightLackWater => 'Não se esqueça de beber água. Tente tomar 2,5 L hoje.';
  @override String get insightTooManyCarbs => 'Ingestão de carboidratos alta hoje. Equilibre com mais proteínas e vegetais.';
  @override String get insightNoScan => 'Nenhuma refeição escaneada hoje. Comece a rastrear para seguir o plano.';
  @override String get insightOnTrack => 'Tudo está ótimo hoje. Continue assim e mantenha a consistência!';
  @override String get weekProjectionTitle => 'Projeção 4 semanas';
  @override String get projectionSubtitle => 'Resultado estimado se você seguir este plano';
  @override String get weightChangeLbl => 'Variação de peso';
  @override String get musclePreservedLbl => 'Preservado';
  @override String get muscleGrowingLbl => 'Crescendo';
  @override String get muscleMaintainedLbl => 'Mantido';
  @override String get energyStableLbl => 'Estável';
  @override String get adjustWeekBtn => 'Ajustar semana';
  @override String get adjustWeekSheetTitle => 'Como você quer ajustar?';
  @override String get adjustLoseFaster => 'Quero perder peso mais rápido';
  @override String get adjustEasierPlan => 'Quero um plano mais fácil';
  @override String get adjustMoreProtein => 'Quero mais proteínas';
  @override String get adjustFewerCarbs => 'Quero menos carboidratos';
  @override String get adjustCheaper => 'Quero um plano mais barato';
  @override String get adjustLocal => 'Quero refeições locais';
  @override String get adjustFlexibleWeekend => 'Quero um fim de semana mais flexível';
  @override String get notificationsTooltip => 'Notificações';

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

  // ── Dishes tab extras ────────────────────────────────────────────────────────
  @override String get suggestionDuMoment  => 'Sugestão do momento';
  @override String get personalizeLabel    => 'Personalizar sugestões';
  @override String get mealObjectiveLabel  => 'Objetivo da refeição';
  @override String get chooseThisDish      => 'Escolher este prato';
  @override String get filterQuick         => 'Rápido';
  @override String get filterBudget        => 'Económico';
  @override String get filterLowKcal       => '< 600 kcal';
  @override String get filterLowCarb       => 'Baixo em carboidratos';
  @override String get filterSnack         => 'Lanche';
  @override String get dishSelectedMsg     => 'Prato selecionado!';
  @override String get preparationBtn        => 'Preparação';
  @override String get contextDayTitle       => 'Contexto do dia';
  @override String get smartActionsTitle     => 'Ações inteligentes';
  @override String get viewAll               => 'Ver tudo';
  @override String get quickTipLabel         => 'Dica rápida';
  @override String get actionCreatePlan      => 'Criar meu plano';
  @override String get actionFixMacros       => 'Corrigir meus macros';
  @override String get actionAnalyzeProgress => 'Analisar meu progresso';



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

  // ── Dashboard — Today Mission & AI Reco ──────────────────────────────────────
  @override String get readyToCrush => 'Pronto para atingir seus objetivos?';
  @override String get notifications => 'Notificações';
  @override String get todayMission => 'Missão do dia';
  @override String get seeDailyPlan => 'Ver meu plano do dia';
  @override String get completeDailyMeasures => 'Completar medidas diárias';
  @override String get dailyCheckIn => 'Check-in diário';
  @override String get toComplete => 'A completar';
  @override String get completeNow => 'Completar agora';
  @override String get checkInDone => 'Check-in concluído!';
  @override String get dataUpToDate => 'Dados atualizados. A projeção IA é mais precisa.';
  @override String get aiRecommendation => 'Recomendação IA';
  @override String get viewMore => 'Ver mais';
  @override String get viewDishes => 'Ver pratos';
  @override String get scanMeal => 'Escanear refeição';
  @override String get adjustToday => 'Ajustar hoje';
  @override String get aiRecNoScan => 'Nenhuma refeição escaneada hoje. Comece a registrar para seguir seu plano.';
  @override String get aiRecProteinLow => 'Sua ingestão de proteínas está baixa. Adicione um alimento rico em proteínas na próxima refeição.';
  @override String get aiRecCaloriesHigh => 'Você está próximo do seu limite calórico. Escolha um jantar leve esta noite.';
  @override String get aiRecOnTrack => 'Você está no caminho certo! Tudo parece ótimo hoje. Continue assim.';
  @override String get objectifQuotidien => 'Meta diária';

  // ── Gate PRO ─────────────────────────────────────────────────────────────────
  @override String get proGateBannerTitle  => 'Plano Pro necessário';
  @override String get proGateBannerSub    => 'Desbloqueie pratos IA personalizados';
  @override String get proGateChip         => 'Pro necessário';
  @override String get proGateHeroTitle    => 'Pratos IA personalizados';
  @override String get proGateHeroAvail    => 'Disponível com o plano Pro ou Premium';
  @override String get proGateHeroDesc     => 'Receba diariamente refeições pensadas para você, adaptadas aos seus objetivos.';
  @override String get proGateCta         => 'Desbloquear meus pratos IA';
  @override String get cancelAnytime       => 'Cancelamento a qualquer momento';
  @override String get freeTrialDays       => '7 dias de avaliação gratuita';

  // ── Gate PREMIUM ──────────────────────────────────────────────────────────────
  @override String get premiumGateBannerTitle  => 'Plano Premium necessário';
  @override String get premiumGateBannerSub    => 'Desbloqueie seu planejamento nutricional personalizado';
  @override String get premiumGateHeroAvail    => 'Disponível com o plano Premium';
  @override String get premiumGateHeroDesc     => 'Um plano de 7 dias gerado por IA, adaptado aos seus objetivos e rotina diária.';
  @override String get premiumGatePreviewTitle => 'Pré-visualização do seu futuro plano';
  @override String get premiumGatePreviewLock  => 'Desbloqueie o plano completo e personalizado';
  @override String get premiumGateCta         => 'Ativar meu plano Premium';

  // ── Dishes tab ────────────────────────────────────────────────────────────────
  @override String dishesResultCount(int n) => '$n resultados';
  @override String get seeDetails   => 'Ver detalhes';
  @override String get dayBilan     => 'Resumo do dia';
  @override String get dayMeals     => 'Refeições do dia';
  @override String get previewHint  => 'Pré-visualização — Gere para ver seus pratos personalizados';
  @override String stepLabel(int n) => 'Passo $n';
  @override String get orContinueWith => 'Ou continuar com';
  @override String get socialAuthError => 'Erro de autenticação social';

  // ── Onboarding welcome step ───────────────────────────────────────────────
  @override String get welcomeTo => 'Bem-vindo ao';
  @override String get onboardingIntro => 'Para começar, vamos configurar\nseu perfil para ';
  @override String get onboardingPersonalize => 'personalizar sua experiência.';
  @override String get infoCardTitle => 'Suas informações';
  @override String get infoCardSubtitle => 'Idade, sexo, altura, peso';
  @override String get measuresCardTitle => 'Suas medidas';
  @override String get measuresCardSubtitle => 'Cintura, quadris, bíceps…';
  @override String get objectivesCardTitle => 'Seus objetivos';
  @override String get objectivesCardSubtitle => 'Perda de peso, ganho de massa ou manutenção';
  @override String get aiNoteText => 'Isso leva apenas alguns instantes e permite que a IA sugira ';
  @override String get aiNoteHighlight => 'recomendações personalizadas.';
  @override String get nextStepLabel => 'Próximo passo: inserir seus dados';
}



