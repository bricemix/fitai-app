import 'dart:convert';
import 'dart:io';
import '../services/chat_sync_service.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../providers/locale_provider.dart';
import '../models/meal.dart';
import '../models/planning.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/limit_dialog.dart';
import 'subscription_screen.dart';
import 'weekly_details_sheet.dart';
import 'ai_insight_sheet.dart';
import 'progress_forecast_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/mission_sync_service.dart';

// ── Hiérarchie des plans ─────────────────────────────────────────────────────
// free / starter → Chat uniquement
// pro            → Chat + Plats
// premium        → Chat + Plats + Planning
// vip            → Chat + Plats + Planning (illimité)

bool _canAccessDishes(String plan) =>
    plan == 'pro' || plan == 'premium' || plan == 'vip';

bool _canAccessPlanning(String plan) =>
    plan == 'premium' || plan == 'vip';

class CoachScreen extends StatefulWidget {
  final UserProfile profile;
  final List<Meal> meals;
  final String userPlan;
  final VoidCallback? onPlanChanged;
  final ValueNotifier<int>? openPlanningTrigger;
  const CoachScreen({
    super.key,
    required this.profile,
    required this.meals,
    this.userPlan = 'free',
    this.onPlanChanged,
    this.openPlanningTrigger,
  });

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    widget.openPlanningTrigger?.addListener(_onPlanningTrigger);
  }

  void _onPlanningTrigger() {
    // Switch to Planning tab (index 2)
    if (_tabController.index != 2) {
      _tabController.animateTo(2);
    }
  }

  @override
  void dispose() {
    widget.openPlanningTrigger?.removeListener(_onPlanningTrigger);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: c.accent.withAlpha(60), blurRadius: 12, spreadRadius: 2),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset('assets/images/visi.png', fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.coachTitle, style: Theme.of(context).textTheme.headlineMedium),
                        Text(l10n.coachSubtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: c.surface2,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: c.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: c.bg,
                  unselectedLabelColor: c.muted,
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(Icons.workspace_premium_rounded,
                                    size: 11, color: c.accent),
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
                  ? _PlanningTab(profile: widget.profile, meals: widget.meals)
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

class _PlanGate extends StatefulWidget {
  final String requiredPlan; // 'Pro' | 'Premium'
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

  @override
  State<_PlanGate> createState() => _PlanGateState();
}

class _PlanGateState extends State<_PlanGate> {
  final _pageCtrl = PageController(viewportFraction: 0.85);
  int _previewPage = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Color _color(BuildContext context) =>
      widget.requiredPlan == 'Premium' ? AppTheme.of(context).accent : Colors.orangeAccent;

  String get _currentPlanLabel =>
      widget.currentPlan.isEmpty || widget.currentPlan == 'free'
          ? 'Starter'
          : widget.currentPlan[0].toUpperCase() + widget.currentPlan.substring(1);

  void _goSubscribe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => SubscriptionScreen(onSubscribed: widget.onPlanChanged)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return widget.requiredPlan == 'Pro'
        ? _buildProGate(context)
        : _buildPremiumGate(context);
  }

  // ══════════════════════════════════════════════════════════════════
  // PAGE PRO — Plats IA personnalisés (orange)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildProGate(BuildContext context) {
    final c = AppTheme.of(context);
    final color = Colors.orangeAccent;
    final l10n  = AppLocalizations.of(context);

    // 3 plats de prévisualisation
    final previews = [
      _GatePreviewDish(name: 'Saumon citronné\n& quinoa',   kcal: 582, p: 38, g: 54, l: 22, imagePath: 'assets/images/saumon.png'),
      _GatePreviewDish(name: 'Poulet teriyaki\n& riz',       kcal: 612, p: 42, g: 60, l: 18, imagePath: 'assets/images/poulet_brocolis.png'),
      _GatePreviewDish(name: 'Pancakes banane\navoine',       kcal: 456, p: 18, g: 62, l: 12, imagePath: 'assets/images/pancake.png'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Bandeau ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withAlpha(80)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.workspace_premium_rounded, color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.proGateBannerTitle,
                            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(l10n.proGateBannerSub,
                            style: TextStyle(color: color.withAlpha(180), fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withAlpha(100)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_rounded, size: 12, color: color),
                        const SizedBox(width: 4),
                        Text(l10n.proGateChip, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Hero card PRO ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color.withAlpha(50)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image + texte
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100, height: 100,
                          child: Image.asset(
                            'assets/images/lock_pro.webp',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.proGateHeroTitle,
                                  style: TextStyle(fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w900, color: c.text, height: 1.2)),
                              const SizedBox(height: 4),
                              Text(l10n.proGateHeroAvail,
                                  style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Text(l10n.proGateHeroDesc,
                                  style: TextStyle(fontSize: 12, color: c.muted, height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge PRO
                  Padding(
                    padding: const EdgeInsets.only(left: 18, bottom: 14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.workspace_premium_rounded, size: 12, color: Color(0xFF0A0A0F)),
                          SizedBox(width: 5),
                          Text('PRO',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF0A0A0F), letterSpacing: 1)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Preview cards (PageView) ──────────────────────────────────
          SizedBox(
            height: 190,
            child: PageView.builder(
              controller: _pageCtrl,
              onPageChanged: (p) => setState(() => _previewPage = p),
              itemCount: previews.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _GatePreviewDishCard(dish: previews[i], color: color),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(previews.length, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _previewPage == i ? 18 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _previewPage == i ? color : color.withAlpha(60),
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
          const SizedBox(height: 24),

          // ── Ce que vous obtenez ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.whatYouGet,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _GateBenefit(icon: Icons.person_rounded,       label: l10n.gateDishesAdaptedRecipes,     color: color),
                      _GateBenefit(icon: Icons.eco_rounded,           label: l10n.gateDishes9Diets,             color: color),
                      _GateBenefit(icon: Icons.monitor_weight_rounded, label: l10n.gateDishesWeighedIngredients, color: color),
                      _GateBenefit(icon: Icons.refresh_rounded,       label: l10n.gateDishesUpdatedDaily,        color: color),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Tableau comparatif ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _ComparisonTable(
              highlightCol: 1, // Pro
              accentColor: color,
              headers: [l10n.tableHeaderFeatures, 'Starter', 'Pro', 'Premium'],
              recommended: 'Pro',
              recommendedLabel: l10n.recommended,
              rows: [
                [l10n.tableRowPersonalizedDishes,   false, true, true],
                [l10n.tableRowAdaptedRecipes,        false, true, true],
                [l10n.tableRowWeighedIngredients,    false, true, true],
                [l10n.tableRowUpdatedDaily,          false, true, true],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Plan actuel ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: c.muted),
                  const SizedBox(width: 8),
                  Text('${l10n.currentPlanLabel} : ', style: TextStyle(fontSize: 13, color: c.muted)),
                  Text(_currentPlanLabel,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, size: 18, color: c.muted),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── CTA ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => _goSubscribe(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: const Color(0xFF0A0A0F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.workspace_premium_rounded, size: 20),
                label: Text(l10n.proGateCta,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Footer ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_rounded, size: 12, color: color.withAlpha(160)),
              const SizedBox(width: 4),
              Text(l10n.freeTrialDays, style: TextStyle(fontSize: 11, color: color.withAlpha(160))),
              Text('  •  ', style: TextStyle(fontSize: 11, color: c.muted.withAlpha(100))),
              Icon(Icons.verified_rounded, size: 12, color: c.muted.withAlpha(140)),
              const SizedBox(width: 4),
              Text(l10n.noCommitment.split(' · ').first, style: TextStyle(fontSize: 11, color: c.muted)),
              Text('  •  ', style: TextStyle(fontSize: 11, color: c.muted.withAlpha(100))),
              Icon(Icons.cancel_rounded, size: 12, color: c.muted.withAlpha(140)),
              const SizedBox(width: 4),
              Text(l10n.cancelAnytime, style: TextStyle(fontSize: 11, color: c.muted)),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // PAGE PREMIUM — Planning nutritionnel (vert)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildPremiumGate(BuildContext context) {
    final c = AppTheme.of(context);
    final color = c.accent;
    final l10n  = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Bandeau ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: color.withAlpha(18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withAlpha(70)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.lock_rounded, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.premiumGateBannerTitle,
                          style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(l10n.premiumGateBannerSub,
                          style: TextStyle(color: color.withAlpha(180), fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: color, size: 14),
                    const SizedBox(height: 2),
                    Icon(Icons.auto_awesome_rounded, color: color.withAlpha(120), size: 10),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Hero card avec preview flou ───────────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withAlpha(50)),
            ),
            child: Column(
              children: [
                // En-tête hero
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      // Image cadenas Premium 3D
                      SizedBox(
                        width: 100, height: 100,
                        child: Image.asset(
                          'assets/images/lock_premium.webp',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.planningNutritional,
                                style: TextStyle(fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w900, color: c.text, height: 1.2)),
                            const SizedBox(height: 4),
                            Text(l10n.premiumGateHeroAvail,
                                style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text(l10n.premiumGateHeroDesc,
                                style: TextStyle(fontSize: 12, color: c.muted, height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge PREMIUM
                Padding(
                  padding: const EdgeInsets.only(left: 18, bottom: 14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.workspace_premium_rounded, size: 12, color: Color(0xFF0A0A0F)),
                        SizedBox(width: 5),
                        Text('PREMIUM',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF0A0A0F), letterSpacing: 1)),
                      ],
                    ),
                  ),
                ),

                // Preview flou
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          width: double.infinity,
                          color: c.surface2,
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Mini header
                              Row(
                                children: [
                                  Icon(Icons.auto_awesome_rounded, size: 13, color: color),
                                  const SizedBox(width: 6),
                                  Text(l10n.premiumGatePreviewTitle,
                                      style: TextStyle(fontSize: 12, color: c.muted, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Semaine
                              Row(
                                children: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'].map((d) {
                                  final isToday = d == 'Mer';
                                  return Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        color: isToday ? color : c.surface,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(d,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: isToday ? Color(0xFF0A0A0F) : c.muted,
                                          )),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              // Repas du jour
                              ...[('Petit-déjeuner', true), ('Déjeuner', true), ('Collation', false), ('Dîner', false)].map((r) =>
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      Icon(Icons.restaurant_rounded, size: 13, color: color.withAlpha(160)),
                                      const SizedBox(width: 8),
                                      Text(r.$1, style: TextStyle(fontSize: 12, color: c.text)),
                                      const Spacer(),
                                      if (r.$2)
                                        Icon(Icons.check_circle_rounded, size: 14, color: color)
                                      else
                                        Container(
                                          width: 14, height: 14,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: c.border),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Macros preview
                              Row(
                                children: [
                                  _GateMacroChip(label: l10n.macroCalories, value: '1 920 kcal/j', color: color),
                                  const SizedBox(width: 6),
                                  _GateMacroChip(label: l10n.macroProtein, value: '142 g/j', color: color),
                                  const SizedBox(width: 6),
                                  _GateMacroChip(label: l10n.macroCarbs, value: '210 g/j', color: color),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Overlay avec verrou centré
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                        child: Container(
                          color: Colors.black.withAlpha(90),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_rounded, size: 32, color: color),
                              const SizedBox(height: 8),
                              Text(l10n.premiumGatePreviewLock,
                                  style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Ce que vous obtenez ───────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.whatYouGet,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _GateBenefit(icon: Icons.calendar_today_rounded,          label: l10n.gatePlanningWeekPlan,    color: color),
                    _GateBenefit(icon: Icons.local_fire_department_rounded,    label: l10n.gatePlanningCaloricGoal, color: color),
                    _GateBenefit(icon: Icons.track_changes_rounded,            label: l10n.gatePlanningAdapted,     color: color),
                    _GateBenefit(icon: Icons.analytics_rounded,                label: l10n.gatePlanningDailyTips,   color: color),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Plan actuel ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16, color: c.muted),
                const SizedBox(width: 8),
                Text('${l10n.currentPlanLabel} : ', style: TextStyle(fontSize: 13, color: c.muted)),
                Text(_currentPlanLabel,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── 3 plan cards ──────────────────────────────────────────────
          Row(
            children: [
              Expanded(child: _PlanMiniCard(
                name: 'Starter',
                subtitle: l10n.planStarterSubtitle,
                hasPlanning: false,
                isHighlighted: false,
                color: color,
                planIncluded: l10n.planIncluded,
                planNotIncluded: l10n.planNotIncluded,
              )),
              const SizedBox(width: 8),
              Expanded(child: _PlanMiniCard(
                name: 'Pro',
                subtitle: l10n.planProSubtitle,
                hasPlanning: false,
                isHighlighted: false,
                color: color,
                planIncluded: l10n.planIncluded,
                planNotIncluded: l10n.planNotIncluded,
              )),
              const SizedBox(width: 8),
              Expanded(child: _PlanMiniCard(
                name: 'Premium',
                subtitle: l10n.planPremiumSubtitle,
                hasPlanning: true,
                isHighlighted: true,
                color: color,
                planIncluded: l10n.planIncluded,
                planNotIncluded: l10n.planNotIncluded,
              )),
            ],
          ),
          const SizedBox(height: 20),

          // ── CTA ───────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => _goSubscribe(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: const Color(0xFF0A0A0F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.workspace_premium_rounded, size: 20),
              label: Text(l10n.premiumGateCta,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 12),

          // ── Footer ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_rounded, size: 12, color: color.withAlpha(180)),
              const SizedBox(width: 4),
              Text(l10n.freeTrialDays, style: TextStyle(fontSize: 11, color: color.withAlpha(180))),
              Text('  •  ', style: TextStyle(fontSize: 11, color: c.muted.withAlpha(100))),
              Icon(Icons.cancel_rounded, size: 12, color: c.muted),
              const SizedBox(width: 4),
              Text(l10n.cancelAnytime, style: TextStyle(fontSize: 11, color: c.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Helpers visuels pour les gates ───────────────────────────────────────────

class _GatePreviewDish {
  final String name;
  final int kcal, p, g, l;
  final String imagePath;
  const _GatePreviewDish({required this.name, required this.kcal, required this.p, required this.g, required this.l, required this.imagePath});
}

class _GatePreviewDishCard extends StatelessWidget {
  final _GatePreviewDish dish;
  final Color color;
  const _GatePreviewDishCard({required this.dish, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Stack(
      children: [
        // Photo de fond
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox.expand(
            child: Image.asset(
              dish.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1A0A),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
        // Dégradé sombre en bas pour lisibilité du texte
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.35, 1.0],
                colors: [Colors.transparent, Color(0xDD000000)],
              ),
            ),
          ),
        ),
        // Texte
        Positioned(
          left: 14, right: 14, bottom: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(dish.name,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.white, height: 1.2)),
              const SizedBox(height: 4),
              Text('${dish.kcal} kcal',
                  style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(200))),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('P ${dish.p}g', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
                  Text('  •  ', style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(120))),
                  Text('G ${dish.g}g', style: const TextStyle(fontSize: 11, color: Colors.white)),
                  Text('  •  ', style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(120))),
                  Text('L ${dish.l}g', style: const TextStyle(fontSize: 11, color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
        // Icône cadenas
        Positioned(
          top: 10, right: 10,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(160),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_rounded, size: 14, color: color),
          ),
        ),
      ],
    );
  }
}

class _GateBenefit extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _GateBenefit({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: c.muted, height: 1.35)),
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  final int highlightCol;
  final Color accentColor;
  final List<String> headers;
  final String recommended;
  final String recommendedLabel;
  final List<List<dynamic>> rows; // [label, bool, bool, bool]
  const _ComparisonTable({
    required this.highlightCol, required this.accentColor,
    required this.headers, required this.recommended,
    required this.recommendedLabel, required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 8),
            child: Row(
              children: List.generate(headers.length, (i) {
                if (i == 0) {
                  return Expanded(flex: 3,
                    child: Text(headers[i], style: TextStyle(fontSize: 12, color: c.muted, fontWeight: FontWeight.w700)));
                }
                final isHL = (i - 1) == (highlightCol - 1);
                return Expanded(
                  flex: 2,
                  child: Container(
                    margin: i == highlightCol ? const EdgeInsets.symmetric(horizontal: 2) : EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: isHL ? BoxDecoration(
                      color: accentColor.withAlpha(22),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      border: Border.all(color: accentColor.withAlpha(80)),
                    ) : null,
                    child: Column(
                      children: [
                        Text(headers[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w800,
                              color: isHL ? accentColor : c.text,
                            )),
                        if (isHL) ...[
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star_rounded, size: 10, color: accentColor),
                              const SizedBox(width: 2),
                              Text(recommendedLabel,
                                  style: TextStyle(fontSize: 9, color: accentColor, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Divider(height: 1, color: c.border),
          // Data rows
          ...rows.asMap().entries.map((e) {
            final i = e.key;
            final row = e.value;
            final isLast = i == rows.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
                  child: Row(
                    children: [
                      // Feature icon + label
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Icon(_featureIcon(i), size: 14, color: c.muted),
                            const SizedBox(width: 8),
                            Expanded(child: Text(row[0] as String,
                                style: TextStyle(fontSize: 11, color: c.text))),
                          ],
                        ),
                      ),
                      // Columns
                      ...List.generate(3, (ci) {
                        final val = row[ci + 1] as bool;
                        final isHL = ci == (highlightCol - 1);
                        return Expanded(
                          flex: 2,
                          child: Container(
                            decoration: isHL ? BoxDecoration(
                              color: accentColor.withAlpha(14),
                              border: Border.symmetric(
                                vertical: BorderSide(color: accentColor.withAlpha(60)),
                                horizontal: isLast
                                    ? BorderSide(color: accentColor.withAlpha(60))
                                    : BorderSide.none,
                              ),
                              borderRadius: isLast
                                  ? const BorderRadius.vertical(bottom: Radius.circular(10))
                                  : null,
                            ) : null,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Center(
                              child: val
                                  ? Icon(Icons.check_circle_rounded,
                                      size: 18,
                                      color: ci == 2 ? const Color(0xFF818CF8) : accentColor)
                                  : Text('—', style: TextStyle(fontSize: 14, color: c.muted)),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                if (!isLast) Divider(height: 1, color: c.border),
              ],
            );
          }),
        ],
      ),
    );
  }

  IconData _featureIcon(int i) {
    const icons = [
      Icons.restaurant_menu_rounded,
      Icons.person_rounded,
      Icons.monitor_weight_rounded,
      Icons.calendar_month_rounded,
    ];
    return i < icons.length ? icons[i] : Icons.check_rounded;
  }
}

class _PlanMiniCard extends StatelessWidget {
  final String name, subtitle;
  final bool hasPlanning, isHighlighted;
  final Color color;
  final String planIncluded;
  final String planNotIncluded;
  const _PlanMiniCard({
    required this.name, required this.subtitle,
    required this.hasPlanning, required this.isHighlighted, required this.color,
    required this.planIncluded, required this.planNotIncluded,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? color.withAlpha(18) : c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlighted ? color : c.border,
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: isHighlighted ? color : c.text,
                  )),
              if (isHighlighted) ...[
                const Spacer(),
                Icon(Icons.workspace_premium_rounded, size: 14, color: color),
              ] else ...[
                const Spacer(),
                Container(width: 8, height: 8,
                    decoration: BoxDecoration(color: c.muted.withAlpha(80), shape: BoxShape.circle)),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 10, color: c.muted, height: 1.3)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                hasPlanning ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 13,
                color: hasPlanning ? color : const Color(0xFFEF4444),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hasPlanning ? planIncluded : planNotIncluded,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: hasPlanning ? color : const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GateMacroChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _GateMacroChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: color.withAlpha(14),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: 9, color: color.withAlpha(200))),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c.text)),
          ],
        ),
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
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final msgs = await ChatSyncService.loadHistory();
    if (msgs.isEmpty) return;
    if (mounted) {
      setState(() {
        _messages.addAll(msgs.map(_Message.fromJson));
        _welcomeAdded = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  Future<void> _clearHistory() async {
    await ChatSyncService.clearHistory();
    if (mounted) {
      setState(() {
        _messages.clear();
        _welcomeAdded = false;
      });
    }
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

    // Exclure les messages de bienvenue (display-only) et les messages système.
    // L'historique doit toujours commencer par un message 'user'.
    final history = _messages
        .where((m) => m.role != 'system' && !m.isWelcome)
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();

    // Repas du jour pour enrichir le contexte IA
    final todayMeals = widget.meals.where((m) => m.isToday).toList();

    try {
      final reply = await AiService.askCoach(
        history,
        widget.profile,
        todayMeals: todayMeals,
      );

      if (mounted) {
        setState(() {
          _messages.add(_Message(role: 'assistant', content: reply));
          _loading = false;
        });
        ChatSyncService.saveExchange(text, reply).catchError((_) {});
        _scrollToBottom();
      }
    } on AiLimitException catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        showLimitDialog(context, e);
      }
    } on AiException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          if (e.message == 'SESSION_INVALIDATED') return;
          _messages.add(_Message(role: 'assistant', content: e.message));
        });
        _scrollToBottom();
      }
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

  // ── Voir détails : bottom sheet bilan du jour ──────────────────────────────
  void _showDayDetailSheet(BuildContext context) {
    final c    = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final todayMeals   = widget.meals.where((m) => m.isToday).toList();
    final todayKcal    = todayMeals.fold(0, (s, m) => s + m.result.calories);
    final todayProtein = todayMeals.fold(0.0, (s, m) => s + m.result.protein);
    final todayCarbs   = todayMeals.fold(0.0, (s, m) => s + m.result.carbs);
    final todayFat     = todayMeals.fold(0.0, (s, m) => s + m.result.fat);
    final targetKcal   = widget.profile.tdee.round();
    final targetProt   = (double.tryParse(widget.profile.weight) ?? 70.0) * 1.6;
    final targetCarbs  = widget.profile.targetCarbs.toDouble();
    final targetFat    = widget.profile.targetFat.toDouble();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, sc) => Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: c.accent.withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.today_rounded, size: 18, color: c.accent),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context).dayBilan,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: c.text)),
                        Text(
                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: TextStyle(fontSize: 12, color: c.muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: c.border, height: 1),
              Expanded(
                child: ListView(
                  controller: sc,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    // ── Calories ─────────────────────────────────────────
                    _DetailSection(
                      label: l10n.macroCalories,
                      current: todayKcal.toDouble(),
                      target: targetKcal.toDouble(),
                      unit: 'kcal',
                      color: c.accent,
                      icon: Icons.local_fire_department_rounded,
                    ),
                    const SizedBox(height: 14),
                    // ── Macros ────────────────────────────────────────────
                    _DetailSection(
                      label: l10n.macroProtein,
                      current: todayProtein,
                      target: targetProt,
                      unit: 'g',
                      color: const Color(0xFF4DA1FF),
                      icon: Icons.fitness_center_rounded,
                    ),
                    const SizedBox(height: 10),
                    _DetailSection(
                      label: l10n.macroCarbs,
                      current: todayCarbs,
                      target: targetCarbs,
                      unit: 'g',
                      color: const Color(0xFFFFB347),
                      icon: Icons.grain_rounded,
                    ),
                    const SizedBox(height: 10),
                    _DetailSection(
                      label: l10n.macroFat,
                      current: todayFat,
                      target: targetFat,
                      unit: 'g',
                      color: const Color(0xFFE879F9),
                      icon: Icons.water_drop_rounded,
                    ),
                    const SizedBox(height: 20),
                    // ── Repas du jour ─────────────────────────────────────
                    Text(AppLocalizations.of(context).dayMeals,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: c.text)),
                    const SizedBox(height: 10),
                    if (todayMeals.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: c.surface2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.no_food_rounded, size: 18, color: c.muted),
                            const SizedBox(width: 10),
                            Text(AppLocalizations.of(context)!.noMealsToday,
                                style: TextStyle(fontSize: 13, color: c.muted)),
                          ],
                        ),
                      )
                    else
                      ...todayMeals.map((m) => _MealDetailTile(meal: m)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    // ── Compute context data ────────────────────────────────────────────────
    final todayMeals    = widget.meals.where((m) => m.isToday).toList();
    final todayKcal     = todayMeals.fold(0, (s, m) => s + m.result.calories);
    final rawRemaining  = widget.profile.tdee.round() - todayKcal;
    final chatInSurplus = rawRemaining < 0;
    final chatSurplus   = chatInSurplus ? -rawRemaining : 0;
    final remaining     = rawRemaining.clamp(0, 9999);
    final todayProtein  = todayMeals.fold(0.0, (s, m) => s + m.result.protein);
    final targetProt    = (double.tryParse(widget.profile.weight) ?? 70.0) * 1.6;
    final dietKey       = _dietFromProfile(widget.profile);
    final dietLabel     = _buildDietOptions(l10n)
        .firstWhere((d) => d.key == dietKey, orElse: () => _buildDietOptions(l10n).first)
        .label;

    final tdee = widget.profile.tdee.round();

    // ── Welcome message (lazy init) ─────────────────────────────────────────
    if (!_welcomeAdded) {
      _welcomeAdded = true;
      _messages.add(_Message(
        role: 'assistant',
        isWelcome: true, // jamais envoyé à l'API — affichage uniquement
        content: l10n.coachWelcome(widget.profile.name),
        actions: [
          _MsgAction(
            label: l10n.actionCreatePlan,
            prompt: chatInSurplus
                ? l10n.promptCreatePlanSurplus(chatSurplus, dietLabel)
                : l10n.promptCreatePlanNormal(remaining, dietLabel),
            icon: Icons.calendar_today_rounded, color: c.accent,
          ),
          _MsgAction(label: l10n.actionFixMacros,       prompt: l10n.promptFixMacros,        icon: Icons.pie_chart_rounded,   color: const Color(0xFF4DA1FF)),
          _MsgAction(label: l10n.actionAnalyzeProgress, prompt: l10n.promptAnalyzeProgress,  icon: Icons.trending_up_rounded, color: const Color(0xFF6BCB77)),
        ],
      ));
    }

    // ── Dynamic smart actions ───────────────────────────────────────────────
    final smartActions = [
      if (chatInSurplus)
        _SmartAction(icon: Icons.warning_amber_rounded, color: const Color(0xFFFF6B6B),
            line1: l10n.smartSurplusTitle(chatSurplus), line2: l10n.smartSurplusSub,
            prompt: l10n.promptSurplusBalance(chatSurplus, tdee))
      else
        _SmartAction(icon: Icons.local_fire_department_rounded, color: c.accent,
            line1: l10n.smartBuildDay, line2: l10n.smartBuildDaySub(remaining),
            prompt: l10n.promptBuildDay(remaining, dietLabel)),
      _SmartAction(icon: Icons.fitness_center_rounded, color: const Color(0xFFE879F9),
          line1: l10n.smart3Dishes,       line2: l10n.smart3DishesSub,
          prompt: l10n.prompt3Dishes(dietLabel)),
      _SmartAction(icon: Icons.bar_chart_rounded, color: const Color(0xFF4DA1FF),
          line1: l10n.smartAnalyzeBilan,  line2: l10n.smartAnalyzeBilanSub,
          prompt: l10n.promptAnalyzeBilan),
      _SmartAction(icon: Icons.dinner_dining_rounded, color: const Color(0xFFFFB347),
          line1: l10n.smartPrepareDinner, line2: l10n.smartPrepareDinnerSub,
          prompt: chatInSurplus
              ? l10n.promptDinnerSurplus(chatSurplus, tdee, dietLabel)
              : l10n.promptDinnerNormal(remaining, dietLabel)),
    ];

    final showSuggestions = _messages.length == 1;

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            children: [
              // ── Contexte du jour (toujours visible) ──────────────────────
              _ContextDayCard(
                remaining: remaining,
                todayKcal: todayKcal,
                todayProtein: todayProtein,
                targetProtein: targetProt,
                profile: widget.profile,
                dietLabel: dietLabel,
                l10n: l10n,
                onViewDetails: () => _showDayDetailSheet(context),
              ),
              const SizedBox(height: 14),

              if (showSuggestions) ...[
                // ── Actions intelligentes ─────────────────────────────────
                Row(
                  children: [
                    Text(l10n.smartActionsTitle,
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: c.text)),
                    const Spacer(),
                    Text(l10n.viewAll,
                        style: TextStyle(fontSize: 12, color: c.accent, fontWeight: FontWeight.w600)),
                    Icon(Icons.chevron_right_rounded, size: 14, color: c.accent),
                  ],
                ),
                const SizedBox(height: 10),
                // 2×2 grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.1,
                  children: smartActions.map((a) => _SmartActionCard(action: a, onTap: () => _send(a.prompt))).toList(),
                ),
                const SizedBox(height: 14),
                // ── Conseil rapide ────────────────────────────────────────
                _QuickTipCard(
                  todayProtein: todayProtein,
                  targetProtein: targetProt,
                  remaining: remaining,
                  tdee: widget.profile.tdee.round(),
                  hasMeals: todayMeals.isNotEmpty,
                  l10n: l10n,
                ),
                const SizedBox(height: 14),
              ],

              // ── Bouton effacer l'historique ───────────────────────────
              if (!showSuggestions && _messages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: c.border)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: c.surface2,
                              title: Text(l10n.clearChatTitle, style: TextStyle(color: c.text, fontWeight: FontWeight.w800)),
                              content: Text(l10n.clearChatConfirm, style: TextStyle(color: c.muted)),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel, style: TextStyle(color: c.muted))),
                                TextButton(onPressed: () => Navigator.pop(ctx, true),  child: Text(l10n.clearChatConfirmBtn, style: TextStyle(color: c.accent3))),
                              ],
                            ),
                          );
                          if (confirm == true) _clearHistory();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: c.surface2,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: c.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete_sweep_rounded, size: 12, color: c.muted),
                              const SizedBox(width: 4),
                              Text(l10n.newChat, style: TextStyle(fontSize: 11, color: c.muted)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Divider(color: c.border)),
                    ],
                  ),
                ),

              // ── Messages ──────────────────────────────────────────────
              ..._messages.map((m) => _BubbleRow(message: m, onActionTap: (p) => _send(p))),
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
  final Set<String> _activeFilters = {};
  int _dishCount = 3;
  String _mealType = ''; // '' = tous
  String _cachedLocale = ''; // locale utilisée pour générer les plats en cache

  static const _dishesLocaleKey = 'fitai_dishes_locale';

  @override
  void initState() {
    super.initState();
    _selectedDiet = _dietFromProfile(widget.profile);
    _loadCached();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Détecter un changement de langue et invalider le cache si nécessaire
    final currentLocale = Localizations.localeOf(context).languageCode;
    if (_cachedLocale.isNotEmpty && _cachedLocale != currentLocale) {
      // Langue changée → vider les plats en cache et recharger
      setState(() {
        _dishes = [];
        _loaded  = false;
        _error   = null;
      });
      _invalidateDishesCache(currentLocale);
    }
    _cachedLocale = currentLocale;
  }

  Future<void> _invalidateDishesCache(String newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dishesLocaleKey, newLocale);
    await StorageService.saveDishes([]);
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _loadCached() async {
    final prefs     = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_dishesLocaleKey) ?? '';
    final currentLocale = mounted
        ? Localizations.localeOf(context).languageCode
        : savedLocale;

    // Cache invalide si la locale ne correspond pas
    if (savedLocale.isNotEmpty && savedLocale != currentLocale) {
      await prefs.setString(_dishesLocaleKey, currentLocale);
      await StorageService.saveDishes([]);
      if (mounted) setState(() => _loaded = true);
      return;
    }

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
          // Sauvegarder la locale courante avec les plats pour invalidation future
          final prefs = await SharedPreferences.getInstance();
          final locale = Localizations.localeOf(context).languageCode;
          await prefs.setString(_dishesLocaleKey, locale);
          await StorageService.saveDishes(result.map((d) => d.toJson()).toList());
        }
      }
    } on AiLimitException catch (e) {
      // Même pop-up premium que le chat/scan quand le quota est épuisé
      if (mounted) {
        setState(() { _loading = false; _loaded = true; });
        showLimitDialog(context, e);
      }
    } catch (e) {
      if (mounted) {
        final msg = e.toString();
        String friendlyError;
        if (msg.contains('DISHES_PLAN_REQUIRED')) {
          friendlyError = AppLocalizations.of(context).dishesPlanRequired;
        } else if (msg.contains('DISHES_LIMIT_REACHED')) {
          friendlyError = AppLocalizations.of(context).dishesLimitReached;
        } else if (msg.contains('SESSION_INVALIDATED')) {
          friendlyError = AppLocalizations.of(context).sessionExpired;
        } else {
          friendlyError = msg;
        }
        setState(() { _loading = false; _loaded = true; _error = friendlyError; });
      }
    }
  }

  void _selectDiet(String diet) {
    final c = AppTheme.of(context);
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

  List<_QuickFilterData> _buildQuickFilters(AppLocalizations l10n) {
    final c = AppTheme.of(context);
    return [
      _QuickFilterData('high-protein', l10n.dietHighProtein, Icons.fitness_center_rounded, const Color(0xFFE879F9)),
      _QuickFilterData('quick',        l10n.filterQuick,    Icons.bolt_rounded,            const Color(0xFFFFB347)),
      _QuickFilterData('budget',       l10n.filterBudget,   Icons.attach_money_rounded,    const Color(0xFF6BCB77)),
      _QuickFilterData('local',        'Local',             Icons.place_rounded,           const Color(0xFF4DA1FF)),
      _QuickFilterData('low-carb',     l10n.filterLowCarb,  Icons.trending_down_rounded,   const Color(0xFF38BDF8)),
      _QuickFilterData('gluten-free',  l10n.dietGlutenFree, Icons.no_food_rounded,         const Color(0xFFFF8A65)),
      _QuickFilterData('low-kcal',     l10n.filterLowKcal,  Icons.water_drop_rounded,      c.muted),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final dietOptions = _buildDietOptions(l10n);
    final todayKcal   = widget.meals.where((m) => m.isToday).fold(0, (s, m) => s + m.result.calories);
    final rawRemaining = widget.profile.tdee.round() - todayKcal;
    final inSurplus   = rawRemaining < 0;
    final surplus     = inSurplus ? -rawRemaining : 0;
    final remaining   = rawRemaining.clamp(0, 9999);
    final selectedOpt = dietOptions.firstWhere((d) => d.key == _selectedDiet, orElse: () => dietOptions.first);
    final quickFilters = _buildQuickFilters(l10n);

    // Meal type chips
    final mealTypes = [
      (key: 'breakfast', label: l10n.breakfast, icon: Icons.wb_sunny_rounded),
      (key: 'lunch',     label: l10n.lunch,     icon: Icons.wb_cloudy_rounded),
      (key: 'dinner',    label: l10n.dinner,    icon: Icons.nightlight_round),
      (key: 'snack',     label: l10n.filterSnack, icon: Icons.cookie_rounded),
    ];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── 1. Smart Summary Card ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SmartSummaryCard(
                  todayKcal: todayKcal,
                  remaining: remaining,
                  surplus: surplus,
                  inSurplus: inSurplus,
                  dietLabel: selectedOpt.label,
                  dietColor: selectedOpt.color,
                  dishCount: _dishCount,
                  activeFiltersCount: _activeFilters.length,
                  loading: _loading,
                  hasResults: _dishes.isNotEmpty,
                  onGenerate: _fetch,
                  onDishCountChanged: (n) => setState(() => _dishCount = n),
                  l10n: l10n,
                ),
              ),
              const SizedBox(height: 20),

              // ── 2. "Personnaliser vos suggestions" ───────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.tune_rounded, size: 15, color: c.muted),
                    const SizedBox(width: 6),
                    Text(l10n.personalizeLabel,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: c.text)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── 3. Régime chips ──────────────────────────────────────────
              SizedBox(
                height: 40,
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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: selected ? opt.color : c.surface,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: selected ? opt.color : c.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(opt.icon, size: 13, color: selected ? c.bg : opt.color),
                            const SizedBox(width: 5),
                            Text(opt.label,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                    color: selected ? c.bg : c.muted)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Régime pré-sélectionné depuis profil
              if (_dietFromProfile(widget.profile) != 'omnivore')
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 11, color: selectedOpt.color),
                      const SizedBox(width: 5),
                      Text(l10n.dietFromProfile, style: TextStyle(fontSize: 10, color: selectedOpt.color)),
                    ],
                  ),
                ),
              const SizedBox(height: 12),

              // ── 4. Quick filter chips ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: quickFilters.map((f) {
                    final active = _activeFilters.contains(f.key);
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (active) _activeFilters.remove(f.key);
                        else _activeFilters.add(f.key);
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: active ? f.color.withAlpha(30) : c.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: active ? f.color : c.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(f.icon, size: 13, color: active ? f.color : c.muted),
                            const SizedBox(width: 5),
                            Text(f.label,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                    color: active ? f.color : c.muted)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // ── 5. Meal type chips ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.mealObjectiveLabel,
                        style: TextStyle(fontSize: 11, color: c.muted, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: mealTypes.map((mt) {
                        final active = _mealType == mt.key;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _mealType = active ? '' : mt.key;
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: active ? c.accent.withAlpha(25) : c.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: active ? c.accent : c.border),
                                ),
                                child: Column(
                                  children: [
                                    Icon(mt.icon, size: 16,
                                        color: active ? c.accent : c.muted),
                                    const SizedBox(height: 3),
                                    Text(mt.label,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                                            color: active ? c.accent : c.muted),
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── 6. Section header plats ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(selectedOpt.icon, size: 15, color: selectedOpt.color),
                    const SizedBox(width: 6),
                    Text(l10n.generateDishes(selectedOpt.label),
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    const Spacer(),
                    if (_dishes.isNotEmpty) ...[
                      Text(AppLocalizations.of(context).dishesResultCount(_dishes.length),
                          style: TextStyle(fontSize: 12, color: c.muted)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _loading ? null : _fetch,
                        child: _loading
                            ? SizedBox(width: 14, height: 14,
                                child: CircularProgressIndicator(color: c.accent, strokeWidth: 2))
                            : Icon(Icons.refresh_rounded, size: 16, color: c.accent),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),

        // ── Content ───────────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          sliver: SliverToBoxAdapter(
            child: _loading && _dishes.isEmpty
                ? _LoadingDishes(diet: _selectedDiet, dietLabel: selectedOpt.label, color: selectedOpt.color)
                : _error != null
                    ? _ErrorCard(message: _error!, onRetry: _fetch)
                    : _dishes.isEmpty && _loaded
                        ? _PreviewDishCards(
                            diet: _selectedDiet,
                            dietLabel: selectedOpt.label,
                            dietColor: selectedOpt.color,
                            onGenerate: _fetch,
                            loading: _loading,
                          )
                        : Column(
                            children: [
                              ..._dishes.map((d) => _DishCard(dish: d)),
                              if (_loading)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(child: CircularProgressIndicator(color: c.accent, strokeWidth: 2)),
                                ),
                            ],
                          ),
          ),
        ),
      ],
    );
  }
}

class _DishCard extends StatefulWidget {
  final DishRecommendation dish;
  final bool isPreview;
  final VoidCallback? onChoose;
  const _DishCard({required this.dish, this.isPreview = false, this.onChoose});

  @override
  State<_DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<_DishCard> {
  bool _expanded = false;

  Color _typeColor(AppColors c) {
    final t = widget.dish.type.toLowerCase();
    if (t == 'breakfast' || t.contains('petit-déj')) return const Color(0xFFFFB347);
    if (t == 'lunch'     || t == 'déjeuner')         return const Color(0xFF6BCB77);
    if (t == 'dinner'    || t == 'dîner')             return const Color(0xFF4DA1FF);
    return c.accent;
  }

  IconData get _typeIcon {
    final t = widget.dish.type.toLowerCase();
    if (t == 'breakfast' || t.contains('petit-déj')) return Icons.wb_sunny_rounded;
    if (t == 'lunch'     || t == 'déjeuner')         return Icons.wb_cloudy_rounded;
    if (t == 'dinner'    || t == 'dîner')             return Icons.nightlight_round;
    return Icons.cookie_rounded;
  }

  String _localizedType(AppLocalizations l10n) {
    final t = widget.dish.type.toLowerCase();
    if (t == 'breakfast' || t.contains('petit-déj')) return l10n.breakfast;
    if (t == 'lunch'     || t == 'déjeuner')         return l10n.lunch;
    if (t == 'dinner'    || t == 'dîner')             return l10n.dinner;
    return widget.dish.type;
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final dish = widget.dish;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.isPreview
            ? c.accent.withAlpha(40)
            : c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _typeColor(c).withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_typeIcon, color: _typeColor(c), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dish.name,
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          Text(_localizedType(l10n),
                              style: TextStyle(fontSize: 12, color: _typeColor(c))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: c.accent.withAlpha(22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${dish.calories} kcal',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: c.accent)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Macros ──────────────────────────────────────
                Row(
                  children: [
                    _MacroBadge(label: 'P', value: dish.protein, color: const Color(0xFF6BCB77)),
                    const SizedBox(width: 8),
                    _MacroBadge(label: 'G', value: dish.carbs,   color: const Color(0xFF4DA1FF)),
                    const SizedBox(width: 8),
                    _MacroBadge(label: 'L', value: dish.fat,     color: const Color(0xFFFFB347)),
                  ],
                ),

                // ── Description (toujours visible) ──────────────
                if (dish.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(dish.description,
                      style: TextStyle(fontSize: 12, color: c.muted, height: 1.4),
                      maxLines: _expanded ? null : 2,
                      overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis),
                ],

                // ── Ingrédients (expandable) ────────────────────
                if (_expanded && dish.ingredients.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Divider(color: c.border, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.format_list_bulleted_rounded, size: 13, color: c.muted),
                      const SizedBox(width: 6),
                      Text(l10n.ingredients,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                              color: c.muted, letterSpacing: 0.3)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: dish.ingredients.map((ing) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: c.surface2,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: c.border),
                      ),
                      child: Text('${ing.name}  ${ing.weightG}g',
                          style: TextStyle(fontSize: 12, color: c.text)),
                    )).toList(),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── Action buttons ──────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.border)),
            ),
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Row(
              children: [
                // Voir détails
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: c.surface2,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: c.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_expanded ? Icons.expand_less_rounded : Icons.info_outline_rounded,
                              size: 15, color: c.muted),
                          const SizedBox(width: 5),
                          Text(l10n.viewDetails,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.muted)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Préparation
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: widget.isPreview
                        ? widget.onChoose  // génère les vrais plats
                        : () => showPreparationSheet(context, dish: widget.dish),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: widget.isPreview
                            ? c.accent.withAlpha(30)
                            : c.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.isPreview
                                ? Icons.auto_awesome_rounded
                                : Icons.menu_book_rounded,
                            size: 15,
                            color: widget.isPreview ? c.accent : c.bg,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.isPreview ? l10n.generating : l10n.preparationBtn,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: widget.isPreview ? c.accent : c.bg,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    final c = AppTheme.of(context);
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

class _CheckItem {
  final String label;
  final IconData icon;
  const _CheckItem({required this.label, required this.icon});
}

class _PlanningTab extends StatefulWidget {
  final UserProfile profile;
  final List<Meal> meals;
  const _PlanningTab({required this.profile, required this.meals});

  @override
  State<_PlanningTab> createState() => _PlanningTabState();
}

class _PlanningTabState extends State<_PlanningTab> {
  List<DayPlan> _plans = [];
  bool _loading = false;
  List<bool> _checklistDone = List.filled(6, false);
  bool _checklistInit = false;

  // Shared key with dashboard missions (same SharedPreferences namespace)
  static String get _todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadCached();
    _loadManualMissions(); // sync with home missions
  }

  /// Load manual mission states from SharedPreferences (shared with home screen)
  /// Index mapping: [3]=walk, [4]=water, [5]=nosugar
  Future<void> _loadManualMissions() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _todayKey;
    if (mounted) {
      setState(() {
        _checklistDone[3] = prefs.getBool('miss_walk_$key')    ?? false;
        _checklistDone[4] = prefs.getBool('miss_water_$key')   ?? false;
        _checklistDone[5] = prefs.getBool('miss_nosugar_$key') ?? false;
      });
    }
  }

  /// Persist a manual mission toggle (shared with home screen)
  Future<void> _saveManualMission(int index, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _todayKey;
    if (index == 3) await prefs.setBool('miss_walk_$key',    value);
    if (index == 4) await prefs.setBool('miss_water_$key',   value);
    if (index == 5) await prefs.setBool('miss_nosugar_$key', value);
  }

  void _initChecklist() {
    if (_checklistInit) return;
    _checklistInit = true;
    final todayMeals = widget.meals.where((m) => m.isToday).toList();
    final todayKcal    = todayMeals.fold(0, (s, m) => s + m.result.calories);
    final todayProtein = todayMeals.fold(0.0, (s, m) => s + m.result.protein);
    final todayPlan = _plans.firstWhere(
      (p) => p.isToday,
      orElse: () => _plans.isNotEmpty ? _plans.first : DayPlan(date: DayPlan.todayKey(), targetKcal: 2000, targetProtein: 120),
    );
    // Only update auto-detected items [0,1,2]; manual items [3,4,5] are
    // already loaded from SharedPreferences by _loadManualMissions()
    _checklistDone = [
      todayKcal    >= todayPlan.targetKcal    * 0.9,  // [0] Hit calorie target (auto)
      todayMeals.length >= 2,                          // [1] Scan 2 meals (auto)
      todayProtein >= todayPlan.targetProtein * 0.9,  // [2] Reach protein goal (auto)
      _checklistDone[3],  // [3] Walk 30 min (manual — preserved from SharedPrefs)
      _checklistDone[4],  // [4] Drink water  (manual — preserved from SharedPrefs)
      _checklistDone[5],  // [5] No sugar     (manual — preserved from SharedPrefs)
    ];
  }

  Future<void> _loadCached() async {
    final cached = await StorageService.loadPlanning();
    if (cached.isNotEmpty && mounted) {
      setState(() { _plans = cached; });
    } else {
      _generate();
    }
  }

  Future<void> _generate() async {
    if (_loading) return;
    setState(() { _loading = true; _checklistInit = false; });
    final plans = await AiService.generateWeeklyPlan(widget.profile);
    if (mounted) {
      setState(() { _plans = plans; _loading = false; });
      await StorageService.savePlanning(plans);
      _syncPlanningToServer(plans);
    }
  }

  Future<void> _syncPlanningToServer(List<DayPlan> plans) =>
      SyncService.uploadPlanning(plans);

  void _showAdjustSheet(BuildContext context, AppLocalizations l10n) {
    final c = AppTheme.of(context);
    final options = [
      (Icons.trending_down_rounded,  l10n.adjustLoseFaster),
      (Icons.sentiment_satisfied_rounded, l10n.adjustEasierPlan),
      (Icons.fitness_center_rounded, l10n.adjustMoreProtein),
      (Icons.grain_rounded,          l10n.adjustFewerCarbs),
      (Icons.attach_money_rounded,   l10n.adjustCheaper),
      (Icons.place_rounded,          l10n.adjustLocal),
      (Icons.weekend_rounded,        l10n.adjustFlexibleWeekend),
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Color(0xFF12121f),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(l10n.adjustWeekSheetTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: c.text)),
            const SizedBox(height: 16),
            ...options.map((opt) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: c.accent.withAlpha(18), borderRadius: BorderRadius.circular(10)),
                child: Icon(opt.$1, color: c.accent, size: 20),
              ),
              title: Text(opt.$2, style: TextStyle(fontSize: 14, color: c.text)),
              trailing: Icon(Icons.chevron_right_rounded, color: c.muted, size: 20),
              onTap: () {
                Navigator.pop(context);
                _generateWithPreference(opt.$2);
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _generateWithPreference(String preference) async {
    if (_loading) return;
    setState(() { _loading = true; _checklistInit = false; });
    final plans = await AiService.generateWeeklyPlan(widget.profile, preference: preference);
    if (mounted) {
      setState(() { _plans = plans; _loading = false; });
      await StorageService.savePlanning(plans);
      _syncPlanningToServer(plans);
    }
  }

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
    } catch (_) { return dateStr; }
  }

  int get _weeklyScore {
    if (_plans.isEmpty) return 0;
    final base      = (_plans.length / 7 * 70).round();
    final checklist = _checklistInit ? (_checklistDone.where((v) => v).length / 6 * 30).round() : 0;
    return (base + checklist).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final dayNamesShort = [l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu, l10n.dayFri, l10n.daySat, l10n.daySun];
    final today = DayPlan.todayKey();

    _initChecklist();

    final todayMeals = widget.meals.where((m) => m.isToday).toList();
    final todayKcal  = todayMeals.fold(0, (s, m) => s + m.result.calories);
    final todayPlan  = _plans.firstWhere(
      (p) => p.isToday,
      orElse: () => _plans.isNotEmpty ? _plans.first : DayPlan(date: today, targetKcal: widget.profile.tdee.round()),
    );
    final remaining = (todayPlan.targetKcal - todayKcal).clamp(0, 9999);

    final checkItems = [
      _CheckItem(label: l10n.checkHitCalorie,       icon: Icons.local_fire_department_rounded),
      _CheckItem(label: l10n.checkScan2Meals,        icon: Icons.document_scanner_rounded),
      _CheckItem(label: l10n.checkProteinGoal,       icon: Icons.fitness_center_rounded),
      _CheckItem(label: l10n.checkWalk30,            icon: Icons.directions_walk_rounded),
      _CheckItem(label: l10n.checkDrinkWater,        icon: Icons.water_drop_rounded),
      _CheckItem(label: l10n.checkNoSugarAfter8pm,   icon: Icons.no_food_rounded),
    ];
    final completedCount = _checklistDone.where((v) => v).length;

    // Dynamic AI insight based on today's data
    final todayProtein2 = todayMeals.fold(0.0, (s, m) => s + m.result.protein);
    final todayCarbs    = todayMeals.fold(0.0, (s, m) => s + m.result.carbs);
    String insightText;
    InsightType insightType;
    if (todayMeals.isEmpty) {
      insightText = l10n.insightNoScan;
      insightType = InsightType.noScan;
    } else if (todayKcal > todayPlan.targetKcal * 0.95) {
      insightText = l10n.insightCaloriesHigh;
      insightType = InsightType.caloriesHigh;
    } else if (todayProtein2 < todayPlan.targetProtein * 0.7) {
      insightText = l10n.insightProteinLow;
      insightType = InsightType.proteinLow;
    } else if (todayCarbs > todayPlan.targetCarbs * 1.2) {
      insightText = l10n.insightTooManyCarbs;
      insightType = InsightType.carbsHigh;
    } else {
      insightText = (_plans.firstWhere((p) => p.isToday, orElse: () =>
          DayPlan(date: today, targetKcal: 2000)).note?.isNotEmpty ?? false)
          ? _plans.firstWhere((p) => p.isToday).note!
          : l10n.insightOnTrack;
      insightType = InsightType.onTrack;
    }

    final weeklyGoal  = widget.profile.goalKgPerWeek;
    final projWeight  = weeklyGoal * 4;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Weekly Balance Score ──────────────────────────────────────
          _WeeklyScoreCard(score: _weeklyScore, remaining: remaining, loading: _loading, l10n: l10n),
          const SizedBox(height: 16),

          // ── 2. Weekly plan strip ─────────────────────────────────────────
          _WeeklyStripCard(
            plans: _plans, dayNames: dayNamesShort,
            today: today, loading: _loading, formatDate: _formatDate, l10n: l10n,
            onViewDetails: () => showWeeklyDetailsSheet(
              context,
              plans: _plans,
              meals: widget.meals,
              profile: widget.profile,
              onBalanceWeek: () => _generateWithPreference('balance the week'),
            ),
          ),
          const SizedBox(height: 16),

          // ── 3. Today checklist ───────────────────────────────────────────
          _TodayChecklist(
            items: checkItems, done: _checklistDone,
            completedCount: completedCount,
            l10n: l10n,
            onToggle: (i) {
              final newValue = !_checklistDone[i];
              setState(() => _checklistDone[i] = newValue);
              // Persist manual items — synced with home missions
              _saveManualMission(i, newValue);
              // Sync full snapshot to server
              MissionSyncService.syncToday(
                autoStates: {
                  'calorie': _checklistDone[0],
                  'scan':    _checklistDone[1],
                  'protein': _checklistDone[2],
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // ── 4. AI Insight ────────────────────────────────────────────────
          _AiInsightCard(
            insight: insightText,
            l10n: l10n,
            onTap: () => showAiInsightSheet(
              context,
              type: insightType,
              currentKcal: todayKcal,
              targetKcal: todayPlan.targetKcal,
              currentProtein: todayProtein2.round(),
              targetProtein: todayPlan.targetProtein,
              onApply: () => _generateWithPreference('optimize for ${insightType.name}'),
              onAlternatives: () => _showAdjustSheet(context, l10n),
            ),
          ),
          const SizedBox(height: 16),

          // ── 5. 4-week projection ─────────────────────────────────────────
          _ProjectionCard(
            weightChange: projWeight,
            l10n: l10n,
            onTap: () => showProgressForecastSheet(
              context,
              profile: widget.profile,
              onBalanced: () => _generateWithPreference('balanced'),
              onEasier: () => _generateWithPreference('easy sustainable'),
              onFaster: () => _generateWithPreference('aggressive fast results'),
            ),
          ),
          const SizedBox(height: 20),

          // ── 6. Buttons ───────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAdjustSheet(context, l10n),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.accent,
                foregroundColor: c.bg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: Text(l10n.adjustWeekBtn, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _loading ? null : _generate,
              style: OutlinedButton.styleFrom(
                foregroundColor: c.muted,
                side: BorderSide(color: c.border),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: _loading
                  ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: c.accent, strokeWidth: 2))
                  : const Icon(Icons.refresh_rounded, size: 18),
              label: Text(_loading ? l10n.generating : l10n.regenerate,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Weekly Score Card ─────────────────────────────────────────────────────────

class _WeeklyScoreCard extends StatelessWidget {
  final int score;
  final int remaining;
  final bool loading;
  final AppLocalizations l10n;
  const _WeeklyScoreCard({required this.score, required this.remaining, required this.loading, required this.l10n});

  String _headline() {
    if (score >= 80) return l10n.onTrackThisWeek;
    if (score >= 60) return l10n.goodProgressPlan;
    if (score >= 40) return l10n.stayConsistentPlan;
    return l10n.buildYourRoutine;
  }

  String _subtitle() {
    if (score >= 80) return l10n.greatConsistency;
    if (score >= 60) return l10n.aFewMoreEfforts;
    if (score >= 40) return l10n.tryHitTargets;
    return l10n.everyStepCounts;
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF0d0d1a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.accent.withAlpha(40)),
      ),
      child: Row(
        children: [
          // Circular score
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(88, 88),
                  painter: _ArcPainter(progress: score / 100),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loading ? '…' : '$score',
                      style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w900,
                        color: c.accent, height: 1,
                      ),
                    ),
                    Text('/100', style: TextStyle(fontSize: 11, color: c.muted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.weeklyBalanceScore,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                      color: c.accent, letterSpacing: 1.2),
                ),
                const SizedBox(height: 4),
                Text(_headline(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: c.text)),
                const SizedBox(height: 2),
                Text(_subtitle(),
                    style: TextStyle(fontSize: 12, color: c.muted)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.surface2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department_rounded, size: 14, color: c.accent),
                      const SizedBox(width: 6),
                      Text(l10n.todayKcalRemainingLabel(remaining),
                          style: TextStyle(fontSize: 12, color: c.muted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  const _ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final rect   = Rect.fromCircle(center: center, radius: radius);

    // Track
    canvas.drawArc(rect, -2.4, 4.8, false,
      Paint()
        ..color = const Color(0xFF2a2a3a)
        ..strokeWidth = 7
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress
    if (progress > 0) {
      canvas.drawArc(rect, -2.4, 4.8 * progress, false,
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF9DFF00), Color(0xFFC8FF00)],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = 7
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

// ── Weekly Strip Card ─────────────────────────────────────────────────────────

class _WeeklyStripCard extends StatelessWidget {
  final List<DayPlan> plans;
  final List<String> dayNames;
  final String today;
  final bool loading;
  final String Function(String) formatDate;
  final AppLocalizations l10n;
  final VoidCallback? onViewDetails;
  const _WeeklyStripCard({
    required this.plans, required this.dayNames, required this.today,
    required this.loading, required this.formatDate, required this.l10n,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, size: 16, color: c.text),
              const SizedBox(width: 8),
              Text(l10n.weekPlanning, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const Spacer(),
              GestureDetector(
                onTap: onViewDetails,
                child: Row(
                  children: [
                    Text(l10n.viewDetails, style: TextStyle(fontSize: 12, color: c.accent, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 2),
                    Icon(Icons.chevron_right_rounded, size: 16, color: c.accent),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (loading && plans.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator(color: c.accent, strokeWidth: 2)),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final plan = plans.length > i ? plans[i] : null;
                final isToday = plan?.date == today;
                return _DayCell(
                  dayShort: dayNames[i],
                  date: plan != null ? formatDate(plan.date) : '—',
                  kcal: plan?.targetKcal,
                  isToday: isToday,
                );
              }),
            ),
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
    final c = AppTheme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 42,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        color: isToday ? c.accent : c.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isToday ? c.accent : c.border),
      ),
      child: Column(
        children: [
          Text(dayShort,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: isToday ? c.bg : c.muted)),
          const SizedBox(height: 3),
          Text(date,
              style: TextStyle(fontSize: 9, color: isToday ? c.bg.withAlpha(200) : c.muted)),
          const SizedBox(height: 5),
          Text(kcal != null ? '$kcal' : '—',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                  color: isToday ? c.bg : c.text)),
          if (kcal != null)
            Text('kcal',
                style: TextStyle(fontSize: 8, color: isToday ? c.bg.withAlpha(150) : c.muted)),
        ],
      ),
    );
  }
}

// ── Today Checklist ───────────────────────────────────────────────────────────

class _TodayChecklist extends StatelessWidget {
  final List<_CheckItem> items;
  final List<bool> done;
  final int completedCount;
  final void Function(int) onToggle;
  final AppLocalizations l10n;
  const _TodayChecklist({
    required this.items, required this.done,
    required this.completedCount, required this.onToggle, required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final total = items.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.todayChecklist,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const Spacer(),
              Text(l10n.completedOfTotal(completedCount, total),
                  style: TextStyle(fontSize: 12, color: c.accent, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completedCount / total,
              backgroundColor: c.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(c.accent),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 14),
          // 2-column grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              final isDone = done[i];
              return GestureDetector(
                onTap: () => onToggle(i),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isDone ? c.accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDone ? c.accent : c.border,
                          width: 1.5,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check_rounded, size: 14, color: Color(0xFF0A0A0F))
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDone ? c.muted : c.text,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          decorationColor: c.muted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── AI Insight Card ───────────────────────────────────────────────────────────

class _AiInsightCard extends StatelessWidget {
  final String insight;
  final AppLocalizations l10n;
  final VoidCallback? onTap;
  const _AiInsightCard({required this.insight, required this.l10n, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.accent.withAlpha(18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.psychology_rounded, color: c.accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.aiInsightTitle,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: c.accent)),
                const SizedBox(height: 4),
                Text(insight,
                    style: TextStyle(fontSize: 13, color: c.text, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: c.muted, size: 20),
        ],
      ),
      ),
    );
  }
}

// ── 4-week Projection Card ────────────────────────────────────────────────────

class _ProjectionCard extends StatelessWidget {
  final double weightChange;
  final AppLocalizations l10n;
  final VoidCallback? onTap;
  const _ProjectionCard({required this.weightChange, required this.l10n, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final isLoss  = weightChange < 0;
    final isGain  = weightChange > 0;
    final sign    = isGain ? '+' : '';
    final kgLabel = '$sign${weightChange.abs().toStringAsFixed(1)} kg';

    String muscleLabel;
    if (isLoss) {
      muscleLabel = l10n.musclePreservedLbl;
    } else if (isGain) {
      muscleLabel = l10n.muscleGrowingLbl;
    } else {
      muscleLabel = l10n.muscleMaintainedLbl;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.weekProjectionTitle,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 2),
          Text(l10n.projectionSubtitle,
              style: TextStyle(fontSize: 12, color: c.muted)),
          const SizedBox(height: 14),
          // Mini trend line
          SizedBox(
            height: 50,
            child: CustomPaint(
              size: const Size(double.infinity, 50),
              painter: _TrendPainter(isGain: isGain),
            ),
          ),
          const SizedBox(height: 14),
          // Metric chips
          Row(
            children: [
              _ProjectionChip(
                icon: Icons.monitor_weight_outlined,
                value: kgLabel,
                label: l10n.weightChangeLbl,
                color: isLoss ? Color(0xFF6BCB77) : isGain ? Color(0xFF4DA1FF) : c.muted,
              ),
              const SizedBox(width: 10),
              _ProjectionChip(
                icon: Icons.fitness_center_rounded,
                value: 'Muscle',
                label: muscleLabel,
                color: const Color(0xFF6BCB77),
              ),
              const SizedBox(width: 10),
              _ProjectionChip(
                icon: Icons.bolt_rounded,
                value: l10n.energyStableLbl,
                label: 'Energy',
                color: c.accent,
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

class _ProjectionChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _ProjectionChip({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: c.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: c.muted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final bool isGain;
  const _TrendPainter({required this.isGain});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final points = isGain
        ? [0.0, 0.85, 0.15, 0.7, 0.35, 0.55, 0.55, 0.4, 0.75, 0.2, 1.0, 0.05]
        : [0.0, 0.15, 0.2, 0.3, 0.4, 0.45, 0.6, 0.55, 0.8, 0.35, 1.0, 0.1];

    final path = Path();
    for (int i = 0; i < points.length; i += 2) {
      final x = points[i] * size.width;
      final y = points[i + 1] * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = points[i - 2] * size.width;
        final prevY = points[i - 1] * size.height;
        final cpX = (prevX + x) / 2;
        path.cubicTo(cpX, prevY, cpX, y, x, y);
      }
    }

    // Gradient fill under the curve
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          colors: [AppTheme.accent.withAlpha(50), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(path, paint);

    // End dot
    final endX = points[points.length - 2] * size.width;
    final endY = points[points.length - 1] * size.height;
    canvas.drawCircle(Offset(endX, endY), 5, Paint()..color = AppTheme.accent);
    canvas.drawCircle(Offset(endX, endY), 3, Paint()..color = const Color(0xFF0A0A0F));
  }

  @override
  bool shouldRepaint(_TrendPainter old) => old.isGain != isGain;
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _MsgAction {
  final String label;
  final String prompt;
  final IconData icon;
  final Color color;
  const _MsgAction({required this.label, required this.prompt, required this.icon, required this.color});
}

class _Message {
  final String role;
  final String content;
  final List<_MsgAction>? actions;
  /// Si true : message d'affichage uniquement — jamais envoyé à l'API.
  final bool isWelcome;
  const _Message({
    required this.role,
    required this.content,
    this.actions,
    this.isWelcome = false,
  });

  Map<String, dynamic> toJson() => {'role': role, 'content': content};

  factory _Message.fromJson(Map<String, dynamic> j) => _Message(
        role: j['role'] as String,
        content: j['content'] as String,
      );
}

class _BubbleRow extends StatelessWidget {
  final _Message message;
  final void Function(String)? onActionTap;
  const _BubbleRow({required this.message, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final isUser = message.role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser)
                Container(
                  width: 30, height: 30,
                  margin: const EdgeInsets.only(right: 8, bottom: 2),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/visi.png',
                    fit: BoxFit.cover,
                  ),
                ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? c.accent : c.surface,
                    border: isUser ? null : Border.all(color: c.border),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(fontSize: 14, height: 1.5, color: isUser ? c.bg : c.text),
                  ),
                ),
              ),
            ],
          ),
          // Action chips (only for AI messages)
          if (!isUser && message.actions != null && message.actions!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 38),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.actions!.map((a) => GestureDetector(
                  onTap: () => onActionTap?.call(a.prompt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: a.color.withAlpha(15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: a.color.withAlpha(60)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(a.icon, size: 14, color: a.color),
                        const SizedBox(width: 6),
                        Text(a.label,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: a.color)),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: c.surface2,
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
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: c.accent, strokeWidth: 2)),
                const SizedBox(width: 8),
                Text(l10n.typing, style: TextStyle(color: c.muted, fontSize: 13)),
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
    final c = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 14, color: c.muted),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 13, color: c.text)),
          ],
        ),
      ),
    );
  }
}

// ── Context Day Card ──────────────────────────────────────────────────────────

class _ContextDayCard extends StatelessWidget {
  final int remaining; // 0 when in surplus (clamped)
  final int todayKcal;
  final double todayProtein;
  final double targetProtein;
  final UserProfile profile;
  final String dietLabel;
  final AppLocalizations l10n;
  final VoidCallback? onViewDetails;

  const _ContextDayCard({
    required this.remaining, required this.todayKcal,
    required this.todayProtein, required this.targetProtein,
    required this.profile, required this.dietLabel, required this.l10n,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    // Protein status
    final String protStatus;
    final Color protColor;
    if (todayKcal == 0) {
      protStatus = '—';
      protColor  = c.muted;
    } else if (todayProtein < targetProtein * 0.5) {
      protStatus = l10n.protLow;
      protColor  = const Color(0xFFFFB347);
    } else if (todayProtein < targetProtein * 0.85) {
      protStatus = l10n.protModerate;
      protColor  = const Color(0xFF4DA1FF);
    } else {
      protStatus = l10n.protGood;
      protColor  = const Color(0xFF6BCB77);
    }

    // Goal label
    final goalLabel = profile.goalKgPerWeek < 0
        ? l10n.goalWeightLoss
        : profile.goalKgPerWeek > 0
            ? l10n.goalMassGain
            : l10n.goalMaintain;
    final goalColor = profile.goalKgPerWeek < 0
        ? const Color(0xFF6BCB77)
        : profile.goalKgPerWeek > 0
            ? const Color(0xFFE879F9)
            : const Color(0xFF4DA1FF);

    // Détection surplus
    final tdee       = profile.tdee.round();
    final surplus    = todayKcal > tdee ? todayKcal - tdee : 0;
    final inSurplus  = surplus > 0;

    // AI intro text
    final desc = inSurplus
        ? l10n.ctxDescSurplus(surplus)
        : todayProtein < targetProtein * 0.5 && todayKcal > 0
            ? l10n.ctxDescLowProt
            : l10n.ctxDescDefault;

    final metrics = [
      if (inSurplus)
        _CtxMetric(icon: Icons.warning_amber_rounded, color: const Color(0xFFFF6B6B),
            value: '+$surplus', sub: l10n.kcalOver, subColor: const Color(0xFFFF6B6B))
      else
        _CtxMetric(icon: Icons.local_fire_department_rounded, color: c.accent,
            value: '$remaining', sub: l10n.kcalRemaining),
      _CtxMetric(icon: Icons.show_chart_rounded, color: protColor,
          value: l10n.labelProteins, sub: protStatus, subColor: protColor),
      _CtxMetric(icon: Icons.gps_fixed_rounded, color: goalColor,
          value: l10n.labelGoal, sub: goalLabel, subColor: goalColor),
      _CtxMetric(icon: Icons.eco_rounded, color: const Color(0xFF6BCB77),
          value: l10n.labelDiet, sub: dietLabel, subColor: const Color(0xFF6BCB77)),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: c.accent.withAlpha(18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.sensors_rounded, size: 15, color: c.accent),
              ),
              const SizedBox(width: 8),
              Text(l10n.contextDayTitle,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: c.text)),
              const Spacer(),
              GestureDetector(
                onTap: onViewDetails,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: onViewDetails != null
                        ? c.accent.withAlpha(18)
                        : c.surface2,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: onViewDetails != null ? c.accent.withAlpha(60) : c.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppLocalizations.of(context).seeDetails,
                          style: TextStyle(
                            fontSize: 11,
                            color: onViewDetails != null ? c.accent : c.muted,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, size: 13,
                          color: onViewDetails != null ? c.accent : c.muted),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4 metrics
          Row(
            children: metrics.map((m) => Expanded(
              child: Column(
                children: [
                  Icon(m.icon, size: 20, color: m.color),
                  const SizedBox(height: 5),
                  Text(m.value,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                          color: (m.subColor != null || m.color == c.accent) ? m.color : c.text),
                      textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(m.sub,
                      style: TextStyle(fontSize: 11, color: m.subColor ?? c.muted,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),

          // Description AI
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.surface2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset('assets/images/visi.png', width: 18, height: 18, fit: BoxFit.cover),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(desc,
                      style: TextStyle(fontSize: 12, color: c.muted, height: 1.4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CtxMetric {
  final IconData icon;
  final Color color;
  final String value;
  final String sub;
  final Color? subColor;
  const _CtxMetric({required this.icon, required this.color, required this.value, required this.sub, this.subColor});
}

// ── Bilan du jour — widgets du bottom sheet ────────────────────────────────────

class _DetailSection extends StatelessWidget {
  final String label;
  final double current;
  final double target;
  final String unit;
  final Color color;
  final IconData icon;
  const _DetailSection({
    required this.label, required this.current, required this.target,
    required this.unit, required this.color, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final c    = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final pct = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final over = current > target;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: over ? color.withAlpha(80) : c.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c.text)),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${current.round()}',
                      style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800,
                        color: over ? const Color(0xFFFF6B6B) : color,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${target.round()} $unit',
                      style: TextStyle(fontSize: 12, color: c.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 7,
              backgroundColor: c.border,
              valueColor: AlwaysStoppedAnimation(over ? const Color(0xFFFF6B6B) : color),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(pct * 100).round()}${l10n.percentReached}',
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
              if (over)
                Text('+${(current - target).round()} $unit ${l10n.exceeded}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFFFF6B6B), fontWeight: FontWeight.w600))
              else
                Text('${(target - current).round()} $unit ${l10n.remaining}',
                    style: TextStyle(fontSize: 11, color: c.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildMealThumb(Meal meal) {
  final file = meal.imagePath != null ? File(meal.imagePath!) : null;
  if (file != null && file.existsSync()) {
    return Image.file(file, fit: BoxFit.cover);
  }
  if (meal.thumbnailBase64 != null && meal.thumbnailBase64!.isNotEmpty) {
    try {
      return Image.memory(base64Decode(meal.thumbnailBase64!), fit: BoxFit.cover);
    } catch (_) {}
  }
  return const Icon(Icons.restaurant_rounded, size: 18, color: Color(0xFFc8ff5a));
}

class _MealDetailTile extends StatelessWidget {
  final Meal meal;
  const _MealDetailTile({required this.meal});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final r = meal.result;
    // Heure extraite depuis la date ISO
    final dt = DateTime.parse(meal.date);
    final hour = '${dt.hour.toString().padLeft(2, '0')}h${dt.minute.toString().padLeft(2, '0')}';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: c.accent.withAlpha(18),
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.hardEdge,
            child: _buildMealThumb(meal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c.text),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text('P${r.protein.round()}g · G${r.carbs.round()}g · L${r.fat.round()}g',
                    style: TextStyle(fontSize: 11, color: c.muted)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${r.calories} kcal',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: c.accent)),
              const SizedBox(height: 2),
              Text(hour,
                  style: TextStyle(fontSize: 11, color: c.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Smart Actions ─────────────────────────────────────────────────────────────

class _SmartAction {
  final IconData icon;
  final Color color;
  final String line1;
  final String line2;
  final String prompt;
  const _SmartAction({required this.icon, required this.color, required this.line1, required this.line2, required this.prompt});
}

class _SmartActionCard extends StatelessWidget {
  final _SmartAction action;
  final VoidCallback onTap;
  const _SmartActionCard({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: action.color.withAlpha(18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(action.icon, size: 17, color: action.color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(action.line1,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.text),
                      overflow: TextOverflow.ellipsis),
                  Text(action.line2,
                      style: TextStyle(fontSize: 11, color: action.color, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 14, color: c.muted),
          ],
        ),
      ),
    );
  }
}

// ── Quick Tip Card ────────────────────────────────────────────────────────────

class _QuickTipCard extends StatelessWidget {
  final double todayProtein;
  final double targetProtein;
  final int remaining;
  final int tdee;
  final bool hasMeals;
  final AppLocalizations l10n;

  const _QuickTipCard({
    required this.todayProtein, required this.targetProtein,
    required this.remaining, required this.tdee,
    required this.hasMeals, required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    // Compute tip text + emoji
    final String tip;
    final String emoji;
    if (!hasMeals) {
      tip   = l10n.tipScanFirstMeal;
      emoji = '📷';
    } else if (todayProtein < targetProtein * 0.5) {
      tip   = l10n.tipIncreaseProtein;
      emoji = '💪';
    } else if (remaining > tdee * 0.6) {
      tip   = l10n.tipCaloriesAvailable(((remaining / tdee) * 100).round());
      emoji = '🔥';
    } else if (remaining < 0) {
      tip   = l10n.tipCaloriesExceeded;
      emoji = '⚠️';
    } else {
      tip   = l10n.tipKeepGoing;
      emoji = '✅';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.accent.withAlpha(18), c.surface],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.accent.withAlpha(40)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: c.accent.withAlpha(18),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lightbulb_rounded, size: 20, color: c.accent),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.quickTipLabel,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                        color: c.accent, letterSpacing: 0.5)),
                const SizedBox(height: 3),
                Text(tip, style: TextStyle(fontSize: 12, color: c.text, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Decorative emoji
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: c.surface2,
              shape: BoxShape.circle,
              border: Border.all(color: c.border),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
        ],
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
    final c = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          CircularProgressIndicator(color: color, strokeWidth: 3),
          const SizedBox(height: 16),
          Text(l10n.generatingRegime(dietLabel),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 4),
          Text(l10n.aiAdaptation,
              style: TextStyle(color: c.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── Preparation sheet ─────────────────────────────────────────────────────────

int _prepMinutes(DishRecommendation dish) {
  final d = dish.description.toLowerCase();
  final n = dish.name.toLowerCase();
  if (d.contains('mijoté') || d.contains('tajine') || d.contains('curry') || d.contains('dahl') ||
      d.contains('dhal') || d.contains('simmered') || d.contains('tagine')) return 35;
  if (d.contains('rôti') || d.contains('four') || d.contains('enfourner') ||
      d.contains('roast') || d.contains('baked') || d.contains('oven')) return 30;
  if (d.contains('rapide') || n.contains('bowl') || n.contains('salade') ||
      n.contains('salad') || d.contains('quick') || d.contains('raw')) return 15;
  if (dish.type.contains('breakfast') || dish.type.contains('petit-déj')) return 10;
  return 20;
}

List<String> _generateSteps(DishRecommendation dish, {String locale = 'fr'}) {
  final steps = <String>[];
  final d = dish.description.toLowerCase();
  final n = dish.name.toLowerCase();
  final hasIngr = dish.ingredients.isNotEmpty;
  final isFr = locale == 'fr';

  // ── Mise en place / Prep ───────────────────────────────────────────
  if (hasIngr) {
    final list = dish.ingredients.take(5).map((i) => i.name).join(', ');
    steps.add(isFr
        ? '🧾 Rassemblez et préparez tous les ingrédients : $list.'
        : '🧾 Gather and prepare all ingredients: $list.');
  } else {
    steps.add(isFr
        ? '🧾 Rassemblez et préparez tous les ingrédients nécessaires.'
        : '🧾 Gather and prepare all necessary ingredients.');
  }

  // ── Grains / legumes ───────────────────────────────────────────────
  if (d.contains('quinoa')) {
    steps.add(isFr
        ? '🌾 Rincez le quinoa, puis faites-le cuire dans 2× son volume d\'eau bouillante salée pendant 12–15 min. Égouttez et réservez.'
        : '🌾 Rinse the quinoa, then cook in 2× its volume of salted boiling water for 12–15 min. Drain and set aside.');
  } else if (d.contains('riz') || d.contains('rice')) {
    steps.add(isFr
        ? '🌾 Faites cuire le riz selon les instructions (environ 12 min dans l\'eau bouillante salée). Égouttez et réservez.'
        : '🌾 Cook the rice per package instructions (approx. 12 min in salted boiling water). Drain and set aside.');
  } else if (d.contains('boulgour') || d.contains('couscous') || d.contains('bulgur')) {
    steps.add(isFr
        ? '🌾 Versez de l\'eau bouillante salée sur le boulgour/couscous, couvrez et laissez gonfler 10 min. Égrainez à la fourchette.'
        : '🌾 Pour salted boiling water over the bulgur/couscous, cover and let swell for 10 min. Fluff with a fork.');
  } else if (d.contains('lentilles') || d.contains('pois chiches') || d.contains('pois cassés') ||
             d.contains('lentil') || d.contains('chickpea') || d.contains('split pea')) {
    steps.add(isFr
        ? '🫘 Rincez les légumineuses. Faites-les cuire dans l\'eau bouillante 20–25 min jusqu\'à tendreté. Égouttez.'
        : '🫘 Rinse the legumes. Cook in boiling water for 20–25 min until tender. Drain.');
  }

  // ── Main cooking method ────────────────────────────────────────────
  if (d.contains('mijoté') || d.contains('curry') || d.contains('dahl') || d.contains('dhal') ||
      d.contains('tajine') || d.contains('harira') || d.contains('simmered') || d.contains('tagine')) {
    steps.add(isFr
        ? '🫕 Dans une casserole, faites chauffer un filet d\'huile à feu moyen. Faites revenir les épices et aromates 2 min.'
        : '🫕 In a saucepan, heat a drizzle of oil over medium heat. Sauté the spices and aromatics for 2 min.');
    steps.add(isFr
        ? '🫕 Ajoutez les ingrédients principaux, mélangez bien, couvrez et laissez mijoter 20–25 min à feu doux.'
        : '🫕 Add the main ingredients, stir well, cover and simmer on low heat for 20–25 min.');
  } else if (d.contains('rôti') || d.contains('four') || d.contains('roast') || d.contains('baked') || d.contains('oven')) {
    steps.add(isFr
        ? '🔥 Préchauffez le four à 190°C (chaleur tournante).'
        : '🔥 Preheat the oven to 190°C / 375°F (fan).');
    steps.add(isFr
        ? '🔥 Disposez les ingrédients sur une plaque huilée. Enfournez 20–25 min jusqu\'à belle coloration.'
        : '🔥 Arrange the ingredients on a greased tray. Roast for 20–25 min until golden.');
  } else if (d.contains('vapeur') || d.contains('steamed') || d.contains('steam')) {
    steps.add(isFr
        ? '♨️ Faites cuire les légumes à la vapeur 8–10 min : ils doivent rester légèrement croquants.'
        : '♨️ Steam the vegetables for 8–10 min: they should remain slightly crunchy.');
  } else if (d.contains('sauté') || d.contains('poêle') || d.contains('grillé') || d.contains('mariné') ||
             d.contains('stir-fry') || d.contains('grilled') || d.contains('sautéed') || d.contains('pan')) {
    steps.add(isFr
        ? '🍳 Chauffez une poêle (ou grill) à feu vif avec un filet d\'huile d\'olive.'
        : '🍳 Heat a pan (or grill) over high heat with a drizzle of olive oil.');
    steps.add(isFr
        ? '🍳 Faites saisir la protéine principale 3–4 min par face jusqu\'à coloration. Baissez à feu moyen et poursuivez 5 min.'
        : '🍳 Sear the main protein 3–4 min per side until golden. Reduce to medium heat and cook 5 min more.');
  } else if (d.contains('poché') || d.contains('poached')) {
    steps.add(isFr
        ? '♨️ Pochez ou cuisez à la vapeur les ingrédients principaux 8–12 min.'
        : '♨️ Poach or steam the main ingredients for 8–12 min.');
  } else if (d.contains('cru') || d.contains('raw') || n.contains('salade') || n.contains('salad') || n.contains('bowl')) {
    steps.add(isFr
        ? '🥗 Pas de cuisson nécessaire pour ce plat — veillez simplement à bien rincer et sécher les ingrédients frais.'
        : '🥗 No cooking required — simply rinse and dry all fresh ingredients well.');
  } else {
    steps.add(isFr
        ? '🍳 Faites chauffer une poêle à feu moyen avec un filet d\'huile. Cuisez les ingrédients principaux 8–12 min en remuant régulièrement.'
        : '🍳 Heat a pan over medium heat with a drizzle of oil. Cook the main ingredients for 8–12 min, stirring regularly.');
  }

  // ── Side vegetables ────────────────────────────────────────────────
  if (d.contains('brocolis') || d.contains('épinards') || d.contains('haricots') || d.contains('courgette') ||
      d.contains('broccoli') || d.contains('spinach') || d.contains('green bean') || d.contains('zucchini')) {
    steps.add(isFr
        ? '🥦 Pendant ce temps, faites sauter les légumes d\'accompagnement à la poêle 4–5 min avec sel, poivre et ail. Réservez.'
        : '🥦 Meanwhile, sauté the side vegetables in a pan for 4–5 min with salt, pepper and garlic. Set aside.');
  }

  // ── Sauce / seasoning ─────────────────────────────────────────────
  if (d.contains('tahini')) {
    steps.add(isFr
        ? '🧄 Préparez la sauce tahini : mélangez le tahini avec le jus de citron, une gousse d\'ail pressée et 2 c. à soupe d\'eau. Ajustez la consistance.'
        : '🧄 Make the tahini sauce: mix tahini with lemon juice, 1 crushed garlic clove and 2 tbsp water. Adjust consistency.');
  } else if (d.contains('vinaigrette') || d.contains('sauce') || d.contains('dressing')) {
    steps.add(isFr
        ? '🫙 Préparez la sauce : mélangez les ingrédients liquides avec les épices. Goûtez et ajustez.'
        : '🫙 Make the sauce/dressing: mix the liquid ingredients with the spices. Taste and adjust.');
  } else {
    steps.add(isFr
        ? '🧂 Assaisonnez avec sel, poivre, et les épices de votre choix. Ajoutez un filet de citron si souhaité.'
        : '🧂 Season with salt, pepper, and your preferred spices. Add a squeeze of lemon if desired.');
  }

  // ── Plating ────────────────────────────────────────────────────────
  if (n.contains('bowl') || n.contains('salade') || n.contains('salad')) {
    steps.add(isFr
        ? '🥣 Disposez harmonieusement les différentes préparations dans un bol : céréales en base, protéine et légumes par-dessus, sauce en filet.'
        : '🥣 Arrange the components in a bowl: grains as the base, protein and vegetables on top, drizzle the sauce.');
  } else if (dish.type.contains('dinner') || dish.type.contains('dîner')) {
    steps.add(isFr
        ? '🍽️ Dressez le plat dans une assiette chaude. Garnissez d\'herbes fraîches (persil, coriandre ou basilic).'
        : '🍽️ Plate on a warm dish. Garnish with fresh herbs (parsley, coriander or basil).');
  } else {
    steps.add(isFr
        ? '🍽️ Dressez dans l\'assiette et servez immédiatement pendant que c\'est chaud.'
        : '🍽️ Plate and serve immediately while hot.');
  }

  steps.add(isFr ? '✅ C\'est prêt — bon appétit !' : '✅ Ready — enjoy your meal!');
  return steps;
}

void showPreparationSheet(BuildContext context, {required DishRecommendation dish}) {
  final c       = AppTheme.of(context);
  final l10n    = AppLocalizations.of(context)!;
  final locale  = Localizations.localeOf(context).languageCode;
  final steps   = dish.steps.isNotEmpty ? dish.steps : _generateSteps(dish, locale: locale);
  final minutes = _prepMinutes(dish);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: Color(0xFF12121f),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // ── Handle ─────────────────────────────────────────────────────
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: c.accent.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(l10n.dishRecipeLabel,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                                      color: c.accent, letterSpacing: 1.4)),
                            ),
                            const SizedBox(height: 6),
                            Text(dish.name,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
                                    color: c.text, height: 1.2)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Calories badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: c.accent.withAlpha(18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: c.accent.withAlpha(50)),
                        ),
                        child: Column(
                          children: [
                            Text('${dish.calories}',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
                                    color: c.accent)),
                            Text('kcal',
                                style: TextStyle(fontSize: 10, color: c.muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Info row: time + macros
                  Row(
                    children: [
                      _PrepChip(icon: Icons.schedule_rounded, label: '$minutes min',
                          color: const Color(0xFFFFB347)),
                      const SizedBox(width: 8),
                      _PrepChip(icon: Icons.fitness_center_rounded, label: 'P ${dish.protein}g',
                          color: const Color(0xFF6BCB77)),
                      const SizedBox(width: 8),
                      _PrepChip(icon: Icons.grain_rounded, label: 'G ${dish.carbs}g',
                          color: const Color(0xFF4DA1FF)),
                      const SizedBox(width: 8),
                      _PrepChip(icon: Icons.water_drop_rounded, label: 'L ${dish.fat}g',
                          color: const Color(0xFFFFB347)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Divider(color: c.border, height: 24),

            // ── Scrollable content ─────────────────────────────────────────
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                children: [

                  // Ingrédients (si disponibles)
                  if (dish.ingredients.isNotEmpty) ...[
                    _PrepSectionTitle(icon: Icons.format_list_bulleted_rounded,
                        label: l10n.dishIngredientsSection(dish.ingredients.length)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: dish.ingredients.map((ing) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: c.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(ing.name,
                                style: TextStyle(fontSize: 13, color: c.text,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: c.accent.withAlpha(18),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('${ing.weightG}g',
                                  style: TextStyle(fontSize: 11,
                                      fontWeight: FontWeight.w700, color: c.accent)),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Étapes de préparation
                  _PrepSectionTitle(icon: Icons.menu_book_rounded,
                      label: l10n.dishPrepStepsSection(steps.length)),
                  const SizedBox(height: 14),
                  ...steps.asMap().entries.map((e) {
                    final idx   = e.key;
                    final step  = e.value;
                    final isLast = idx == steps.length - 1;
                    // Séparer l'emoji du texte
                    final emoji = step.isNotEmpty && step.codeUnitAt(0) > 127
                        ? step.characters.first
                        : '•';
                    final text  = step.contains(' ') ? step.substring(step.indexOf(' ') + 1) : step;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline
                            Column(
                              children: [
                                Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(
                                    color: isLast
                                        ? c.accent.withAlpha(25)
                                        : c.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isLast ? c.accent : c.border,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(emoji,
                                      style: TextStyle(fontSize: 16)),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      color: c.border,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            // Step content
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8, bottom: isLast ? 0 : 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppLocalizations.of(context).stepLabel(idx + 1),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: isLast ? c.accent : c.muted,
                                          letterSpacing: 1.1,
                                        )),
                                    const SizedBox(height: 3),
                                    Text(text,
                                        style: TextStyle(
                                            fontSize: 13, color: c.text, height: 1.5)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PrepChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _PrepChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _PrepSectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PrepSectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Row(
      children: [
        Icon(icon, size: 15, color: c.accent),
        const SizedBox(width: 7),
        Text(label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                color: c.text, letterSpacing: 0.3)),
      ],
    );
  }
}

// ── Quick filter data ─────────────────────────────────────────────────────────

class _QuickFilterData {
  final String key;
  final String label;
  final IconData icon;
  final Color color;
  const _QuickFilterData(this.key, this.label, this.icon, this.color);
}

// ── Smart Summary Card ────────────────────────────────────────────────────────

class _SmartSummaryCard extends StatelessWidget {
  final int todayKcal;
  final int remaining;
  final int surplus;
  final bool inSurplus;
  final String dietLabel;
  final Color dietColor;
  final int dishCount;
  final int activeFiltersCount;
  final bool loading;
  final bool hasResults;
  final VoidCallback onGenerate;
  final void Function(int) onDishCountChanged;
  final AppLocalizations l10n;

  const _SmartSummaryCard({
    required this.todayKcal,
    required this.remaining,
    required this.surplus,
    required this.inSurplus,
    required this.dietLabel,
    required this.dietColor,
    required this.dishCount,
    required this.activeFiltersCount,
    required this.loading,
    required this.hasResults,
    required this.onGenerate,
    required this.onDishCountChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    const surplusColor = Color(0xFFFF6B6B);

    final pills = <({IconData icon, String value, String sub, Color color})>[
      if (inSurplus)
        (icon: Icons.warning_amber_rounded, value: '+$surplus kcal', sub: l10n.pillSubExcess, color: surplusColor)
      else
        (icon: Icons.local_fire_department_rounded, value: '$remaining kcal', sub: l10n.pillSubRemaining, color: c.accent),
      (icon: Icons.grass_rounded,           value: dietLabel,                  sub: l10n.pillSubDiet,                              color: dietColor),
      (icon: Icons.restaurant_menu_rounded, value: l10n.dishCountPillValue(dishCount), sub: l10n.pillSubToGenerate,               color: const Color(0xFF4DA1FF)),
      if (activeFiltersCount > 0)
        (icon: Icons.tune_rounded, value: l10n.filterCountPillValue(activeFiltersCount), sub: l10n.pillSubActive(activeFiltersCount), color: const Color(0xFFFFB347)),
    ];

    final description = inSurplus
        ? l10n.smartSummaryDescSurplus(surplus, dishCount)
        : l10n.smartSummaryDescNormal(dishCount, dietLabel);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [dietColor.withAlpha(22), c.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dietColor.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 16, color: dietColor),
              const SizedBox(width: 7),
              Text(l10n.suggestionDuMoment,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: dietColor)),
              const Spacer(),
              // Dish count selector
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: c.surface2,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [1, 2, 3].map((n) {
                    final selected = n == dishCount;
                    return GestureDetector(
                      onTap: () => onDishCountChanged(n),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 28,
                        height: 26,
                        decoration: BoxDecoration(
                          color: selected ? dietColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.center,
                        child: Text('$n',
                            style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w800,
                              color: selected ? c.bg : c.muted,
                            )),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Metric pills grid ─────────────────────────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pills.map((p) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: p.color.withAlpha(18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: p.color.withAlpha(50)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(p.icon, size: 14, color: p.color),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.value,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: p.color)),
                      Text(p.sub,
                          style: TextStyle(fontSize: 10, color: c.muted)),
                    ],
                  ),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),

          // ── Description ───────────────────────────────────────────────
          Text(description,
              style: TextStyle(fontSize: 12, color: c.muted, height: 1.5)),
          const SizedBox(height: 14),

          // ── CTA button ────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: loading ? null : onGenerate,
              style: ElevatedButton.styleFrom(
                backgroundColor: dietColor,
                foregroundColor: c.bg,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: loading
                  ? SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: c.bg))
                  : const Icon(Icons.auto_awesome_rounded, size: 18),
              label: Text(
                loading
                    ? l10n.generating
                    : hasResults
                        ? l10n.actualize
                        : l10n.generateRegime(dietLabel),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Preview Dish Cards (static, avant génération) ────────────────────────────

List<DishRecommendation> _previewDishesForDiet(String diet, {String locale = 'fr'}) {
  const _empty = <DishIngredient>[];
  final isFr = locale == 'fr';
  switch (diet) {
    case 'vegan':
      return isFr ? const [
        DishRecommendation(name: 'Bowl vegan protéiné',        type: 'lunch',  calories: 520, protein: 28, carbs: 70, fat: 16, description: 'Quinoa, pois chiches rôtis, edamame, patate douce, avocat, tahini.', ingredients: _empty),
        DishRecommendation(name: 'Curry de lentilles & riz',   type: 'dinner', calories: 580, protein: 26, carbs: 78, fat: 18, description: 'Red lentils simmered in coconut milk, spinach, brown rice, coriander.', ingredients: _empty),
        DishRecommendation(name: 'Tofu sauté légumes quinoa',  type: 'lunch',  calories: 490, protein: 30, carbs: 60, fat: 14, description: 'Marinated tofu, broccoli, peppers, carrots, quinoa, soy sauce.', ingredients: _empty),
      ] : const [
        DishRecommendation(name: 'Protein vegan bowl',         type: 'lunch',  calories: 520, protein: 28, carbs: 70, fat: 16, description: 'Quinoa, roasted chickpeas, edamame, sweet potato, avocado, tahini.', ingredients: _empty),
        DishRecommendation(name: 'Red lentil curry & rice',    type: 'dinner', calories: 580, protein: 26, carbs: 78, fat: 18, description: 'Red lentils simmered in coconut milk, spinach, brown rice, coriander.', ingredients: _empty),
        DishRecommendation(name: 'Stir-fried tofu & quinoa',   type: 'lunch',  calories: 490, protein: 30, carbs: 60, fat: 14, description: 'Marinated tofu, broccoli, peppers, carrots, quinoa, soy sauce.', ingredients: _empty),
      ];
    case 'vegetarian':
      return isFr ? const [
        DishRecommendation(name: 'Omelette aux herbes',        type: 'breakfast', calories: 340, protein: 24, carbs: 12, fat: 22, description: 'Œufs fermiers, fines herbes, épinards, fromage de brebis.', ingredients: _empty),
        DishRecommendation(name: 'Buddha bowl méditerranéen',  type: 'lunch',     calories: 510, protein: 22, carbs: 64, fat: 18, description: 'Pois chiches rôtis, feta, tomates cerises, courgettes grillées, riz.', ingredients: _empty),
        DishRecommendation(name: 'Dahl de pois cassés',        type: 'dinner',    calories: 430, protein: 20, carbs: 58, fat: 12, description: 'Pois cassés mijotés aux épices, riz basmati, yaourt nature.', ingredients: _empty),
      ] : const [
        DishRecommendation(name: 'Herb omelette',              type: 'breakfast', calories: 340, protein: 24, carbs: 12, fat: 22, description: 'Farm eggs, fresh herbs, spinach, sheep cheese.', ingredients: _empty),
        DishRecommendation(name: 'Mediterranean buddha bowl',  type: 'lunch',     calories: 510, protein: 22, carbs: 64, fat: 18, description: 'Roasted chickpeas, feta, cherry tomatoes, grilled courgette, rice.', ingredients: _empty),
        DishRecommendation(name: 'Split pea dhal',             type: 'dinner',    calories: 430, protein: 20, carbs: 58, fat: 12, description: 'Split peas simmered with spices, basmati rice, plain yogurt.', ingredients: _empty),
      ];
    case 'keto':
      return isFr ? const [
        DishRecommendation(name: 'Saumon avocat & œufs',       type: 'breakfast', calories: 480, protein: 36, carbs: 4,  fat: 34, description: 'Saumon fumé, œufs pochés, avocat, citron, câpres.', ingredients: _empty),
        DishRecommendation(name: 'Poulet rôti & légumes',       type: 'lunch',     calories: 520, protein: 42, carbs: 8,  fat: 32, description: 'Cuisse de poulet rôtie, brocolis, courgettes à l\'huile d\'olive.', ingredients: _empty),
        DishRecommendation(name: 'Steak & asperges grillées',   type: 'dinner',    calories: 560, protein: 48, carbs: 6,  fat: 36, description: 'Entrecôte, asperges, beurre maître d\'hôtel, herbes fraîches.', ingredients: _empty),
      ] : const [
        DishRecommendation(name: 'Salmon avocado & eggs',      type: 'breakfast', calories: 480, protein: 36, carbs: 4,  fat: 34, description: 'Smoked salmon, poached eggs, avocado, lemon, capers.', ingredients: _empty),
        DishRecommendation(name: 'Roast chicken & vegetables', type: 'lunch',     calories: 520, protein: 42, carbs: 8,  fat: 32, description: 'Roasted chicken thigh, broccoli, courgette with olive oil.', ingredients: _empty),
        DishRecommendation(name: 'Steak & grilled asparagus',  type: 'dinner',    calories: 560, protein: 48, carbs: 6,  fat: 36, description: 'Ribeye steak, asparagus, herb butter, fresh herbs.', ingredients: _empty),
      ];
    case 'halal':
      return isFr ? const [
        DishRecommendation(name: 'Poulet mariné & tabboulé',   type: 'lunch',  calories: 490, protein: 38, carbs: 50, fat: 14, description: 'Filet de poulet halal grillé, tabboulé au persil et boulgour.', ingredients: _empty),
        DishRecommendation(name: 'Tajine d\'agneau léger',      type: 'dinner', calories: 560, protein: 36, carbs: 48, fat: 20, description: 'Épaule d\'agneau halal, couscous, légumes fondants, épices douces.', ingredients: _empty),
        DishRecommendation(name: 'Soupe harira & galette',      type: 'lunch',  calories: 380, protein: 22, carbs: 54, fat: 10, description: 'Harira aux pois chiches, lentilles, tomates, galette de pain.', ingredients: _empty),
      ] : const [
        DishRecommendation(name: 'Marinated halal chicken & tabbouleh', type: 'lunch',  calories: 490, protein: 38, carbs: 50, fat: 14, description: 'Grilled halal chicken fillet, parsley tabbouleh and bulgur wheat.', ingredients: _empty),
        DishRecommendation(name: 'Light lamb tagine',           type: 'dinner', calories: 560, protein: 36, carbs: 48, fat: 20, description: 'Halal lamb shoulder, couscous, tender vegetables, mild spices.', ingredients: _empty),
        DishRecommendation(name: 'Harira soup & flatbread',     type: 'lunch',  calories: 380, protein: 22, carbs: 54, fat: 10, description: 'Chickpea harira, lentils, tomatoes, flatbread.', ingredients: _empty),
      ];
    case 'high-protein':
      return isFr ? const [
        DishRecommendation(name: 'Blanc de poulet & edamame',  type: 'lunch',  calories: 440, protein: 52, carbs: 28, fat: 12, description: 'Blanc de poulet vapeur, edamame, brocolis, sauce gingembre.', ingredients: _empty),
        DishRecommendation(name: 'Omelette protéinée',         type: 'breakfast', calories: 360, protein: 40, carbs: 8,  fat: 18, description: 'Œufs entiers + blancs, jambon blanc, cottage cheese, épinards.', ingredients: _empty),
        DishRecommendation(name: 'Thon & patate douce',        type: 'dinner', calories: 460, protein: 44, carbs: 42, fat: 10, description: 'Thon en conserve, patate douce rôtie, haricots verts, citron.', ingredients: _empty),
      ] : const [
        DishRecommendation(name: 'Steamed chicken & edamame',  type: 'lunch',  calories: 440, protein: 52, carbs: 28, fat: 12, description: 'Steamed chicken breast, edamame, broccoli, ginger sauce.', ingredients: _empty),
        DishRecommendation(name: 'Protein omelette',           type: 'breakfast', calories: 360, protein: 40, carbs: 8,  fat: 18, description: 'Whole eggs + egg whites, ham, cottage cheese, spinach.', ingredients: _empty),
        DishRecommendation(name: 'Tuna & sweet potato',        type: 'dinner', calories: 460, protein: 44, carbs: 42, fat: 10, description: 'Canned tuna, roasted sweet potato, green beans, lemon.', ingredients: _empty),
      ];
    default: // omnivore + others
      return isFr ? const [
        DishRecommendation(name: 'Poulet grillé & quinoa',     type: 'lunch',  calories: 510, protein: 40, carbs: 52, fat: 12, description: 'Blanc de poulet, quinoa aux herbes, haricots verts, vinaigrette légère.', ingredients: _empty),
        DishRecommendation(name: 'Saumon & légumes rôtis',     type: 'dinner', calories: 490, protein: 36, carbs: 30, fat: 22, description: 'Pavé de saumon, patate douce, brocolis, courgettes, huile d\'olive.', ingredients: _empty),
        DishRecommendation(name: 'Salade César au poulet',     type: 'lunch',  calories: 420, protein: 34, carbs: 28, fat: 18, description: 'Poulet rôti, laitue romaine, parmesan, croûtons, sauce légère.', ingredients: _empty),
      ] : const [
        DishRecommendation(name: 'Grilled chicken & quinoa',   type: 'lunch',  calories: 510, protein: 40, carbs: 52, fat: 12, description: 'Chicken breast, herb quinoa, green beans, light vinaigrette.', ingredients: _empty),
        DishRecommendation(name: 'Salmon & roasted vegetables',type: 'dinner', calories: 490, protein: 36, carbs: 30, fat: 22, description: 'Salmon fillet, sweet potato, broccoli, courgette, olive oil.', ingredients: _empty),
        DishRecommendation(name: 'Caesar salad with chicken',  type: 'lunch',  calories: 420, protein: 34, carbs: 28, fat: 18, description: 'Roast chicken, romaine lettuce, parmesan, croutons, light dressing.', ingredients: _empty),
      ];
  }
}

class _PreviewDishCards extends StatelessWidget {
  final String diet;
  final String dietLabel;
  final Color dietColor;
  final VoidCallback onGenerate;
  final bool loading;
  const _PreviewDishCards({
    required this.diet, required this.dietLabel, required this.dietColor,
    required this.onGenerate, required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final previews = _previewDishesForDiet(diet, locale: locale);
    return Column(
      children: [
        // Preview badge
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: dietColor.withAlpha(18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: dietColor.withAlpha(60)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility_outlined, size: 12, color: dietColor),
                    const SizedBox(width: 5),
                    Text(AppLocalizations.of(context).previewHint,
                        style: TextStyle(fontSize: 11, color: dietColor, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        ...previews.map((d) => _DishCard(dish: d, isPreview: true, onChoose: onGenerate)),
      ],
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
    final c = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.accent3.withAlpha(80)),
      ),
      child: Column(
        children: [
          Icon(Icons.wifi_off_rounded, color: c.muted, size: 36),
          const SizedBox(height: 12),
          Text(l10n.error,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 6),
          Text(message,
              style: TextStyle(color: c.muted, fontSize: 12),
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
    final c = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      color: c.bg,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: l10n.typingMessage),
              style: TextStyle(color: c.text),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.arrow_upward, color: c.bg),
            ),
          ),
        ],
      ),
    );
  }
}
