import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/meal.dart';
import '../models/planning.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import 'subscription_screen.dart';

// ── Hiérarchie des plans ─────────────────────────────────────────────────────
// free / starter → Chat uniquement
// pro            → Chat + Plats
// premium        → Chat + Plats + Planning

bool _canAccessDishes(String plan) =>
    plan == 'pro' || plan == 'premium';

bool _canAccessPlanning(String plan) =>
    plan == 'premium';

class CoachScreen extends StatefulWidget {
  final UserProfile profile;
  final List<Meal> meals;
  final String userPlan;
  final VoidCallback? onPlanChanged;
  const CoachScreen({super.key, required this.profile, required this.meals, this.userPlan = 'free', this.onPlanChanged});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.coachTitle, style: Theme.of(context).textTheme.headlineMedium),
              Text(l10n.coachSubtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.muted)),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: AppTheme.bg,
                  unselectedLabelColor: AppTheme.muted,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                          const SizedBox(width: 4),
                          Text(l10n.chatTab),
                        ],
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _canAccessDishes(widget.userPlan)
                                  ? Icons.restaurant_menu_rounded
                                  : Icons.lock_rounded,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(l10n.dishesTab),
                            if (!_canAccessDishes(widget.userPlan))
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.workspace_premium_rounded,
                                    size: 11, color: Colors.orangeAccent),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _canAccessPlanning(widget.userPlan)
                                  ? Icons.calendar_month_rounded
                                  : Icons.lock_rounded,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(l10n.planningTab),
                            if (!_canAccessPlanning(widget.userPlan))
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.workspace_premium_rounded,
                                    size: 11, color: AppTheme.accent),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _ChatTab(profile: widget.profile, meals: widget.meals),
              _canAccessDishes(widget.userPlan)
                  ? _DishesTab(profile: widget.profile, meals: widget.meals)
                  : _PlanGate(
                      requiredPlan: 'Pro',
                      currentPlan: widget.userPlan,
                      onPlanChanged: widget.onPlanChanged,
                      icon: Icons.restaurant_menu_rounded,
                      title: l10n.aiDishes,
                      perks: [
                        l10n.personalizedRecipes,
                        l10n.dietOptions9,
                        l10n.exactIngredients,
                        l10n.dailyUpdate,
                      ],
                    ),
              _canAccessPlanning(widget.userPlan)
                  ? _PlanningTab(profile: widget.profile)
                  : _PlanGate(
                      requiredPlan: 'Premium',
                      currentPlan: widget.userPlan,
                      onPlanChanged: widget.onPlanChanged,
                      icon: Icons.calendar_month_rounded,
                      title: l10n.planningTitle,
                      perks: [
                        l10n.planningDescription,
                        l10n.caloricTarget,
                        l10n.adaptedToGoal,
                        l10n.dailyTips,
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Plan Gate — écran affiché quand l'accès est restreint ────────────────────

class _PlanGate extends StatelessWidget {
  final String requiredPlan;   // 'Pro' | 'Premium'
  final String currentPlan;
  final IconData icon;
  final String title;
  final List<String> perks;
  final VoidCallback? onPlanChanged;

  const _PlanGate({
    required this.requiredPlan,
    required this.currentPlan,
    required this.icon,
    required this.title,
    required this.perks,
    this.onPlanChanged,
  });

  Color get _planColor =>
      requiredPlan == 'Premium' ? AppTheme.accent : Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPremium = requiredPlan == 'Premium';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        children: [
          // ── Bandeau "accès requis" ──────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _planColor.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _planColor.withAlpha(80)),
            ),
            child: Row(
              children: [
                Icon(Icons.workspace_premium_rounded, color: _planColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.planningRequired(requiredPlan),
                    style: TextStyle(color: _planColor, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Icône centrale ─────────────────────────────────────────────
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: _planColor.withAlpha(18),
                  shape: BoxShape.circle,
                  border: Border.all(color: _planColor.withAlpha(60), width: 1.5),
                ),
                child: Icon(icon, size: 40, color: _planColor),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: _planColor.withAlpha(80)),
                ),
                child: Icon(Icons.lock_rounded, size: 16, color: _planColor),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Titre ──────────────────────────────────────────────────────
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppTheme.text,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isPremium
                ? l10n.planAvailableWith('Premium')
                : l10n.planAvailableWithProOrPremium,
            style: TextStyle(fontSize: 13, color: _planColor, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // ── Liste des avantages ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.whatYouGet,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _planColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                ...perks.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 18, color: _planColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(p, style: const TextStyle(fontSize: 13, height: 1.4, color: AppTheme.text)),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Plan actuel ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.muted),
                const SizedBox(width: 8),
                Text(
                  '${l10n.currentPlanLabel} : ${currentPlan.isEmpty || currentPlan == 'free' ? l10n.freePlanLabel : currentPlan[0].toUpperCase() + currentPlan.substring(1)}',
                  style: const TextStyle(fontSize: 13, color: AppTheme.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── CTA ────────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubscriptionScreen(onSubscribed: onPlanChanged),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _planColor,
                foregroundColor: const Color(0xFF0A0A0F),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.workspace_premium_rounded, size: 20),
              label: Text(
                l10n.upgradePlan(requiredPlan),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.maybePop(context),
            child: Text(
              l10n.continueFreePlan,
              style: const TextStyle(color: AppTheme.muted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab 1 : Chat Coach ────────────────────────────────────────────────────────

class _ChatTab extends StatefulWidget {
  final UserProfile profile;
  final List<Meal> meals;
  const _ChatTab({required this.profile, required this.meals});

  @override
  State<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<_ChatTab> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Message> _messages = [];
  bool _loading = false;


  bool _welcomeAdded = false;

  @override
  void initState() {
    super.initState();
    // Welcome message is added lazily in build() once l10n context is available.
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send([String? override]) async {
    final text = override ?? _controller.text.trim();
    if (text.isEmpty || _loading) return;
    _controller.clear();

    setState(() {
      _messages.add(_Message(role: 'user', content: text));
      _loading = true;
    });
    _scrollToBottom();

    final history = _messages
        .where((m) => m.role != 'system')
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();

    final reply = await AiService.askCoach(history, widget.profile);

    if (mounted) {
      setState(() {
        _messages.add(_Message(role: 'assistant', content: reply));
        _loading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_welcomeAdded) {
      _welcomeAdded = true;
      _messages.add(_Message(
        role: 'assistant',
        content: l10n.coachWelcome(widget.profile.name),
      ));
    }
    final suggestions = [
      l10n.suggestion1,
      l10n.suggestion2,
      l10n.suggestion3,
      l10n.suggestion4,
    ];
    final showSuggestions = _messages.length == 1;
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            children: [
              if (showSuggestions) ...[
                ...suggestions.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _SuggestionTile(label: s, onTap: () => _send(s)),
                    )),
                const SizedBox(height: 8),
              ],
              ..._messages.map((m) => _BubbleRow(message: m)),
              if (_loading) _TypingBubble(),
            ],
          ),
        ),
        _InputBar(controller: _controller, onSend: _send),
      ],
    );
  }
}

// ── Tab 2 : Plats recommandés ─────────────────────────────────────────────────

class _DishesTab extends StatefulWidget {
  final UserProfile profile;
  final List<Meal> meals;
  const _DishesTab({required this.profile, required this.meals});

  @override
  State<_DishesTab> createState() => _DishesTabState();
}

// ── Définition des régimes disponibles ───────────────────────────────────────

class _DietOption {
  final String key;   // internal key used for state/AI
  final String label; // translated display label
  final IconData icon;
  final Color color;
  const _DietOption(this.key, this.label, this.icon, this.color);
}

List<_DietOption> _buildDietOptions(AppLocalizations l10n) => [
  _DietOption('omnivore',      l10n.dietOmnivore,     Icons.restaurant_rounded,     const Color(0xFF94A3B8)),
  _DietOption('halal',         l10n.dietHalal,        Icons.verified_rounded,       const Color(0xFF34D399)),
  _DietOption('vegetarian',    l10n.dietVegetarian,   Icons.eco_rounded,            const Color(0xFF6BCB77)),
  _DietOption('vegan',         l10n.dietVegan,        Icons.grass_rounded,          const Color(0xFF4ADE80)),
  _DietOption('keto',          l10n.dietKeto,         Icons.bolt_rounded,           const Color(0xFFFFB347)),
  _DietOption('gluten-free',   l10n.dietGlutenFree,   Icons.no_food_rounded,        const Color(0xFFFF8A65)),
  _DietOption('mediterranean', l10n.dietMediterranean, Icons.water_rounded,         const Color(0xFF4DA1FF)),
  _DietOption('high-protein',  l10n.dietHighProtein,  Icons.fitness_center_rounded, const Color(0xFFE879F9)),
  _DietOption('low-calorie',   l10n.dietLowCalorie,   Icons.trending_down_rounded,  const Color(0xFF38BDF8)),
  _DietOption('paleo',         l10n.dietPaleo,        Icons.forest_rounded,         const Color(0xFFA3E635)),
];

/// Déduit le régime initial (clé interne) depuis les restrictions du profil.
String _dietFromProfile(UserProfile profile) {
  final r = profile.restrictions.map((s) => s.toLowerCase()).join(' ');
  if (r.contains('végétalien') || r.contains('vegan'))              return 'vegan';
  if (r.contains('végétarien') || r.contains('vegetarian'))         return 'vegetarian';
  if (r.contains('halal'))                                          return 'halal';
  if (r.contains('keto') || r.contains('cétogène'))                 return 'keto';
  if (r.contains('sans gluten') || r.contains('gluten'))            return 'gluten-free';
  if (r.contains('méditerranéen') || r.contains('mediterranean'))   return 'mediterranean';
  if (r.contains('paléo') || r.contains('paleo'))                   return 'paleo';
  return 'omnivore';
}

// ── État du tab Plats ─────────────────────────────────────────────────────────

class _DishesTabState extends State<_DishesTab> {
  List<DishRecommendation> _dishes = [];
  bool _loading = false;
  bool _loaded  = false;
  String? _error;
  late String _selectedDiet;

  @override
  void initState() {
    super.initState();
    _selectedDiet = _dietFromProfile(widget.profile);
    _loadCached();
  }

  Future<void> _loadCached() async {
    final cached = await StorageService.loadDishes();
    if (cached.isNotEmpty && mounted) {
      setState(() {
        _dishes = cached.map((d) => DishRecommendation.fromJson(d)).toList();
        _loaded = true;
      });
    }
    if (mounted && !_loaded) setState(() => _loaded = true);
  }

  Future<void> _fetch() async {
    if (_loading) return;
    setState(() { _loading = true; _error = null; });
    try {
      final result = await AiService.getDishRecommendations(
        profile: widget.profile,
        todayMeals: widget.meals.where((m) => m.isToday).toList(),
        dietType: _selectedDiet,
      );
      if (mounted) {
        setState(() { _dishes = result; _loading = false; _loaded = true; });
        if (result.isNotEmpty) {
          await StorageService.saveDishes(result.map((d) => d.toJson()).toList());
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() { _loading = false; _loaded = true; _error = e.toString(); });
      }
    }
  }

  void _selectDiet(String diet) {
    if (_selectedDiet == diet) return;
    setState(() {
      _selectedDiet = diet;
      _dishes = [];        // vider les plats précédents
      _loaded = false;
      _error = null;
    });
    // Générer automatiquement avec le nouveau régime
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dietOptions = _buildDietOptions(l10n);
    final todayKcal = widget.meals.where((m) => m.isToday).fold(0, (s, m) => s + m.result.calories);
    final remaining = (widget.profile.tdee.round() - todayKcal).clamp(0, 9999);
    final selectedOpt = dietOptions.firstWhere((d) => d.key == _selectedDiet, orElse: () => dietOptions.first);

    return CustomScrollView(
      slivers: [
        // ── Filtres régimes (sticky en haut) ──────────────────────────────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bandeau calories
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withAlpha(18),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.accent.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: AppTheme.accent, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.todayKcalInfo(todayKcal, remaining),
                          style: const TextStyle(fontSize: 13, color: AppTheme.text),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Titre + badge régime actif
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(l10n.dietRegime, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const Spacer(),
                    if (_dishes.isNotEmpty)
                      TextButton.icon(
                        onPressed: _loading ? null : _fetch,
                        icon: _loading
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2))
                            : const Icon(Icons.refresh_rounded, size: 16, color: AppTheme.accent),
                        label: Text(_loading ? l10n.generating : l10n.actualize, style: const TextStyle(fontSize: 13, color: AppTheme.accent)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Chips de régime — scroll horizontal
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: dietOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final opt = dietOptions[i];
                    final selected = opt.key == _selectedDiet;
                    return GestureDetector(
                      onTap: () => _selectDiet(opt.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        decoration: BoxDecoration(
                          color: selected ? opt.color : AppTheme.surface,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: selected ? opt.color : AppTheme.border,
                            width: selected ? 0 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(opt.icon, size: 14, color: selected ? AppTheme.bg : opt.color),
                            const SizedBox(width: 6),
                            Text(
                              opt.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: selected ? AppTheme.bg : AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 6),

              // Indication régime pré-sélectionné depuis le profil
              if (_dietFromProfile(widget.profile) != 'omnivore')
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 12, color: selectedOpt.color),
                      const SizedBox(width: 5),
                      Text(
                        l10n.dietFromProfile,
                        style: TextStyle(fontSize: 11, color: selectedOpt.color),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(selectedOpt.icon, size: 16, color: selectedOpt.color),
                    const SizedBox(width: 6),
                    Text(l10n.generateDishes(selectedOpt.label), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),

        // ── États ─────────────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          sliver: SliverToBoxAdapter(
            child: _loading && _dishes.isEmpty
                ? _LoadingDishes(diet: _selectedDiet, dietLabel: selectedOpt.label, color: selectedOpt.color)
                : _error != null
                    ? _ErrorCard(message: _error!, onRetry: _fetch)
                    : _dishes.isEmpty && _loaded
                        ? _GenerateCta(loading: _loading, onGenerate: _fetch, diet: _selectedDiet, dietLabel: selectedOpt.label, color: selectedOpt.color, icon: selectedOpt.icon)
                        : Column(
                            children: [
                              ..._dishes.map((d) => _DishCard(dish: d)),
                              if (_loading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Center(child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2)),
                                ),
                            ],
                          ),
          ),
        ),
      ],
    );
  }
}

class _DishCard extends StatelessWidget {
  final DishRecommendation dish;
  const _DishCard({required this.dish});

  Color get _typeColor {
    final t = dish.type.toLowerCase();
    if (t == 'breakfast' || t.contains('petit-déj')) return const Color(0xFFFFB347);
    if (t == 'lunch'     || t == 'déjeuner')         return const Color(0xFF6BCB77);
    if (t == 'dinner'    || t == 'dîner')             return const Color(0xFF4DA1FF);
    return AppTheme.accent; // snack / other
  }

  IconData get _typeIcon {
    final t = dish.type.toLowerCase();
    if (t == 'breakfast' || t.contains('petit-déj')) return Icons.wb_sunny_rounded;
    if (t == 'lunch'     || t == 'déjeuner')         return Icons.wb_cloudy_rounded;
    if (t == 'dinner'    || t == 'dîner')             return Icons.nightlight_round;
    return Icons.cookie_rounded; // snack / other
  }

  String _localizedType(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = dish.type.toLowerCase();
    if (t == 'breakfast' || t.contains('petit-déj')) return l10n.breakfast;
    if (t == 'lunch'     || t == 'déjeuner')         return l10n.lunch;
    if (t == 'dinner'    || t == 'dîner')             return l10n.dinner;
    return dish.type; // snack or unknown → keep as-is
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _typeColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_typeIcon, color: _typeColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dish.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    Text(_localizedType(context), style: TextStyle(fontSize: 12, color: _typeColor)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${dish.calories} kcal', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.accent)),
              ),
            ],
          ),
          if (dish.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(dish.description, style: const TextStyle(fontSize: 13, color: AppTheme.muted, height: 1.4)),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _MacroBadge(label: 'P', value: dish.protein, color: const Color(0xFF6BCB77)),
              const SizedBox(width: 8),
              _MacroBadge(label: 'G', value: dish.carbs, color: const Color(0xFF4DA1FF)),
              const SizedBox(width: 8),
              _MacroBadge(label: 'L', value: dish.fat, color: const Color(0xFFFFB347)),
            ],
          ),

          // ── Ingrédients ──────────────────────────────────────
          if (dish.ingredients.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: AppTheme.border, height: 1),
            const SizedBox(height: 10),
            Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx);
              return Row(
                children: [
                  const Icon(Icons.format_list_bulleted_rounded, size: 13, color: AppTheme.muted),
                  const SizedBox(width: 6),
                  Text(l10n.ingredients, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.muted, letterSpacing: 0.3)),
                ],
              );
            }),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: dish.ingredients.map((ing) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  '${ing.name}  ${ing.weightG}g',
                  style: const TextStyle(fontSize: 12, color: AppTheme.text),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _MacroBadge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label: ${value}g', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

// ── Tab 3 : Planning hebdomadaire ─────────────────────────────────────────────

class _PlanningTab extends StatefulWidget {
  final UserProfile profile;
  const _PlanningTab({required this.profile});

  @override
  State<_PlanningTab> createState() => _PlanningTabState();
}

class _PlanningTabState extends State<_PlanningTab> {
  List<DayPlan> _plans = [];
  bool _loading = false;
  bool _loaded = false;


  @override
  void initState() {
    super.initState();
    _loadCached();
  }

  Future<void> _loadCached() async {
    final cached = await StorageService.loadPlanning();
    if (cached.isNotEmpty && mounted) {
      setState(() { _plans = cached; _loaded = true; });
    } else {
      _generate();
    }
  }

  Future<void> _generate() async {
    if (_loading) return;
    setState(() { _loading = true; });
    final plans = await AiService.generateWeeklyPlan(widget.profile);
    if (mounted) {
      setState(() {
        _plans = plans;
        _loading = false;
        _loaded = true;
      });
      await StorageService.savePlanning(plans);
      // Sync to server in background
      _syncPlanningToServer(plans);
    }
  }

  Future<void> _syncPlanningToServer(List<DayPlan> plans) =>
      SyncService.uploadPlanning(plans);

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dayNamesShort = [l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu, l10n.dayFri, l10n.daySat, l10n.daySun];
    final dayNamesFull = [l10n.dayMonFull, l10n.dayTueFull, l10n.dayWedFull, l10n.dayThuFull, l10n.dayFriFull, l10n.daySatFull, l10n.daySunFull];
    final today = DayPlan.todayKey();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week strip
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.surface, Color(0xFF1a1a30)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, color: AppTheme.accent, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.weekPlanning, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 14),
                if (_loading && !_loaded)
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(color: AppTheme.accent),
                        const SizedBox(height: 12),
                        Text(l10n.generatingPlanning, style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
                      ],
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) {
                      final plan = _plans.length > i ? _plans[i] : null;
                      final isToday = plan?.date == today;
                      return _DayCell(
                        dayShort: dayNamesShort[i],
                        date: plan != null ? _formatDate(plan.date) : '—',
                        kcal: plan?.targetKcal,
                        isToday: isToday,
                      );
                    }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.dayDetail, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              TextButton.icon(
                onPressed: _loading ? null : _generate,
                icon: _loading
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2))
                    : const Icon(Icons.auto_awesome_rounded, size: 16, color: AppTheme.accent),
                label: Text(_loading ? l10n.generating : l10n.regenerate, style: const TextStyle(fontSize: 13, color: AppTheme.accent)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_plans.isEmpty && _loaded)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 40, color: AppTheme.muted),
                    const SizedBox(height: 12),
                    Text(l10n.noPlanning, style: const TextStyle(color: AppTheme.muted)),
                    const SizedBox(height: 6),
                    Text(l10n.pressToRegenerate, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                  ],
                ),
              ),
            )
          else
            ...List.generate(_plans.length, (i) {
              final plan = _plans[i];
              final isToday = plan.date == today;
              return _DayPlanCard(
                plan: plan,
                dayName: i < dayNamesFull.length ? dayNamesFull[i] : '${l10n.dayDetail} ${i + 1}',
                isToday: isToday,
                dateFormatted: _formatDate(plan.date),
              );
            }),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final String dayShort;
  final String date;
  final int? kcal;
  final bool isToday;
  const _DayCell({required this.dayShort, required this.date, this.kcal, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 42,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: isToday ? AppTheme.accent : AppTheme.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isToday ? AppTheme.accent : AppTheme.border),
      ),
      child: Column(
        children: [
          Text(dayShort, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isToday ? AppTheme.bg : AppTheme.muted)),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(fontSize: 9, color: isToday ? AppTheme.bg.withAlpha(200) : AppTheme.muted)),
          const SizedBox(height: 4),
          if (kcal != null)
            Text('${kcal}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isToday ? AppTheme.bg : AppTheme.text))
          else
            Text('—', style: TextStyle(fontSize: 10, color: isToday ? AppTheme.bg.withAlpha(150) : AppTheme.muted)),
          if (kcal != null)
            Text('kcal', style: TextStyle(fontSize: 8, color: isToday ? AppTheme.bg.withAlpha(150) : AppTheme.muted)),
        ],
      ),
    );
  }
}

class _DayPlanCard extends StatelessWidget {
  final DayPlan plan;
  final String dayName;
  final String dateFormatted;
  final bool isToday;
  const _DayPlanCard({required this.plan, required this.dayName, required this.dateFormatted, required this.isToday});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isToday ? AppTheme.accent.withAlpha(15) : AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isToday ? AppTheme.accent.withAlpha(80) : AppTheme.border, width: isToday ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isToday)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(l10n.todayLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.bg)),
                ),
              Text(dayName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const Spacer(),
              Text(dateFormatted, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _PlanMacro(icon: Icons.local_fire_department_rounded, color: AppTheme.accent, value: '${plan.targetKcal}', unit: 'kcal'),
              const SizedBox(width: 10),
              _PlanMacro(icon: Icons.fitness_center_rounded, color: const Color(0xFF6BCB77), value: '${plan.targetProtein}g', unit: l10n.proteins),
              const SizedBox(width: 10),
              _PlanMacro(icon: Icons.grain_rounded, color: const Color(0xFF4DA1FF), value: '${plan.targetCarbs}g', unit: l10n.carbs),
              const SizedBox(width: 10),
              _PlanMacro(icon: Icons.water_drop_rounded, color: const Color(0xFFFFB347), value: '${plan.targetFat}g', unit: l10n.fats),
            ],
          ),
          if (plan.note != null && plan.note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.tips_and_updates_rounded, size: 14, color: AppTheme.muted),
                const SizedBox(width: 6),
                Expanded(child: Text(plan.note!, style: const TextStyle(fontSize: 12, color: AppTheme.muted, height: 1.4))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanMacro extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String unit;
  const _PlanMacro({required this.icon, required this.color, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
            Text(unit, style: const TextStyle(fontSize: 9, color: AppTheme.muted)),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _Message {
  final String role;
  final String content;
  const _Message({required this.role, required this.content});
}

class _BubbleRow extends StatelessWidget {
  final _Message message;
  const _BubbleRow({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser ? AppTheme.accent : AppTheme.accent.withAlpha(22),
              border: isUser ? null : Border.all(color: AppTheme.accent.withAlpha(60)),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
            ),
            child: Text(
              message.content,
              style: TextStyle(fontSize: 14, height: 1.5, color: isUser ? AppTheme.bg : AppTheme.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2)),
                const SizedBox(width: 8),
                Text(l10n.typing, style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestionTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: AppTheme.muted),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.text)),
          ],
        ),
      ),
    );
  }
}

// ── Generate CTA ─────────────────────────────────────────────────────────────

class _LoadingDishes extends StatelessWidget {
  final String diet;       // internal key
  final String dietLabel;  // translated label
  final Color color;
  const _LoadingDishes({required this.diet, required this.dietLabel, required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          CircularProgressIndicator(color: color, strokeWidth: 3),
          const SizedBox(height: 16),
          Text(l10n.generatingRegime(dietLabel),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 4),
          Text(l10n.aiAdaptation,
              style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _GenerateCta extends StatelessWidget {
  final bool loading;
  final VoidCallback onGenerate;
  final String diet;        // internal key
  final String dietLabel;   // translated label (passed from parent build)
  final Color color;
  final IconData icon;
  const _GenerateCta({required this.loading, required this.onGenerate, required this.diet, required this.dietLabel, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withAlpha(22),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 34, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.generateDishes(dietLabel),
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppTheme.text),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.generateDishesDesc,
            style: const TextStyle(color: AppTheme.muted, fontSize: 13, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: loading ? null : onGenerate,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: AppTheme.bg,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: loading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.bg))
                  : const Icon(Icons.auto_awesome_rounded, size: 18),
              label: Text(
                loading ? l10n.generatingRegime(dietLabel) : l10n.generateRegime(dietLabel),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error card ────────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent3.withAlpha(80)),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, color: AppTheme.muted, size: 36),
          const SizedBox(height: 12),
          Text(l10n.error,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 6),
          Text(message,
              style: const TextStyle(color: AppTheme.muted, fontSize: 12),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function([String?]) onSend;
  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      color: AppTheme.bg,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: l10n.typingMessage),
              style: const TextStyle(color: AppTheme.text),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_upward, color: AppTheme.bg),
            ),
          ),
        ],
      ),
    );
  }
}
