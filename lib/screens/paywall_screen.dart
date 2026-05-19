import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme.dart';
import '../services/payment_service.dart';
import '../services/currency_service.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';
import 'subscription_screen.dart';

class PaywallScreen extends StatefulWidget {
  final VoidCallback onContinue;
  const PaywallScreen({super.key, required this.onContinue});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen>
    with TickerProviderStateMixin {
  // ── Animations ────────────────────────────────────────────────────────────────
  late final AnimationController _heroCtrl;
  late final AnimationController _staggerCtrl;
  late final AnimationController _ctaCtrl;      // shimmer bouton
  late final AnimationController _glowCtrl;     // pulse icône hero

  late final Animation<double> _heroFade;
  late final Animation<Offset>  _heroSlide;
  late final List<Animation<double>> _featureFades;
  late final List<Animation<Offset>>  _featureSlides;
  late final Animation<double> _ctaShimmer;
  late final Animation<double> _glowPulse;

  // ── Données ───────────────────────────────────────────────────────────────────
  List<Plan> _plans        = [];
  int _selectedIndex       = 0;
  bool _loadingPlans       = false;
  bool _checkoutLoading    = false;   // true pendant createCheckout()
  AppCurrency _currency    = CurrencyService.defaultCurrency;

  static const _featureIcons = [
    Icons.document_scanner_rounded,
    Icons.smart_toy_rounded,
    Icons.calendar_month_rounded,
    Icons.restaurant_menu_rounded,
    Icons.analytics_rounded,
    Icons.notifications_active_rounded,
  ];

  @override
  void initState() {
    super.initState();

    // Hero fade+slide
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _heroFade  = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, -0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));

    // Stagger features (6 tuiles × 80 ms de décalage)
    _staggerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _featureFades  = List.generate(6, (i) {
      final start = i * 0.12;
      final end   = (start + 0.35).clamp(0.0, 1.0);
      return CurvedAnimation(parent: _staggerCtrl, curve: Interval(start, end, curve: Curves.easeOut));
    });
    _featureSlides = List.generate(6, (i) {
      final start = i * 0.12;
      final end   = (start + 0.35).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
        CurvedAnimation(parent: _staggerCtrl, curve: Interval(start, end, curve: Curves.easeOut)),
      );
    });

    // CTA shimmer (boucle)
    _ctaCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat();
    _ctaShimmer = CurvedAnimation(parent: _ctaCtrl, curve: Curves.easeInOut);

    // Glow pulse (boucle)
    _glowCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
    _glowPulse = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );

    // Lancer les animations d'entrée
    _heroCtrl.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _staggerCtrl.forward();
    });

    _fetchPlans();
    _loadCurrency();
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _staggerCtrl.dispose();
    _ctaCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    setState(() => _loadingPlans = true);
    try {
      final plans = await PaymentService.fetchPlans();
      if (mounted) setState(() { _plans = plans; _loadingPlans = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingPlans = false);
    }
  }

  Future<void> _loadCurrency() async {
    final c = await CurrencyService.load();
    if (mounted) setState(() => _currency = c);
  }

  // ── Achat direct depuis le paywall ───────────────────────────────────────────
  // Si l'user est connecté ET a un plan sélectionné → checkout direct (0 écran intermédiaire).
  // Sinon → SubscriptionScreen (pour sélectionner un plan ou se connecter).
  Future<void> _goToSubscription() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;

    if (!loggedIn) {
      // Pas connecté → expliquer + rediriger vers inscription
      final l10n = AppLocalizations.of(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(children: [
            const Icon(Icons.lock_rounded, color: AppTheme.accent, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.accountRequired,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800))),
          ]),
          content: Text(l10n.accountRequiredDesc,
              style: const TextStyle(color: Color(0xFF94A3B8), height: 1.5, fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel, style: const TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () { Navigator.pop(context); widget.onContinue(); },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.bg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(l10n.createAccountButton,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      );
      return;
    }

    // Récupérer le plan sélectionné (filtré mensuel, max 3)
    final monthlyPlans = _plans.where((p) => p.billingFrequency == 'monthly').take(3).toList();
    final displayPlans = monthlyPlans.isNotEmpty ? monthlyPlans : _plans.take(3).toList();

    if (displayPlans.isEmpty) {
      // Pas de plans disponibles → SubscriptionScreen classique
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()))
          .then((_) => widget.onContinue());
      return;
    }

    final safeIdx     = _selectedIndex.clamp(0, displayPlans.length - 1);
    final selectedPlan = displayPlans[safeIdx];

    // Plan non Stripe → SubscriptionScreen pour voir les autres options
    if (!selectedPlan.stripeAvailable) {
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()))
          .then((_) => widget.onContinue());
      return;
    }

    // ── Checkout direct ───────────────────────────────────────────────────────
    // Afficher un indicateur de chargement sur le CTA
    setState(() => _checkoutLoading = true);
    try {
      final result = await PaymentService.createCheckout(selectedPlan);
      if (!mounted) return;
      setState(() => _checkoutLoading = false);

      // Afficher directement le bottom sheet de paiement
      showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        isScrollControlled: true,
        builder: (_) => CheckoutSheet(
          plan:        selectedPlan,
          checkoutUrl: result.checkoutUrl,
          sessionId:   result.sessionId,
          currency:    _currency,
          onSubscribed: widget.onContinue,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _checkoutLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red.shade800),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header minimaliste ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SvgPicture.asset('assets/logo/dietvision-icon.svg', height: 26),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w800),
                      children: [
                        TextSpan(text: 'Diet',    style: TextStyle(color: AppTheme.text)),
                        TextSpan(text: 'Vision',  style: TextStyle(color: AppTheme.accent)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onContinue,
                    style: TextButton.styleFrom(foregroundColor: AppTheme.muted),
                    child: Text(l10n.skip, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),

            // ── Corps scrollable ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Hero animé ───────────────────────────────────────────
                    FadeTransition(
                      opacity: _heroFade,
                      child: SlideTransition(
                        position: _heroSlide,
                        child: _HeroHeader(glowPulse: _glowPulse, l10n: l10n),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // ── Features en grille staggerée ─────────────────────────
                    ...List.generate((6 / 2).ceil(), (row) {
                      final a = row * 2;
                      final b = a + 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(child: FadeTransition(
                              opacity: _featureFades[a],
                              child: SlideTransition(
                                position: _featureSlides[a],
                                child: _FeatureTile(
                                  icon: _featureIcons[a],
                                  label: _featureLabel(l10n, a),
                                  sub:   _featureSub(l10n, a),
                                ),
                              ),
                            )),
                            const SizedBox(width: 10),
                            if (b < 6)
                              Expanded(child: FadeTransition(
                                opacity: _featureFades[b],
                                child: SlideTransition(
                                  position: _featureSlides[b],
                                  child: _FeatureTile(
                                    icon: _featureIcons[b],
                                    label: _featureLabel(l10n, b),
                                    sub:   _featureSub(l10n, b),
                                  ),
                                ),
                              ))
                            else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 22),

                    // ── Plans ────────────────────────────────────────────────
                    if (_loadingPlans)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: CircularProgressIndicator(color: AppTheme.accent),
                        ),
                      )
                    else if (_plans.isEmpty)
                      _StaticPlans(
                        onContinue: widget.onContinue,
                        onSeePlans: _goToSubscription,
                        currency: _currency,
                      )
                    else ...[
                      // Afficher seulement les plans mensuels (max 3)
                      // pour garder le paywall concis → subscription_screen pour le reste
                      Builder(builder: (ctx) {
                        final monthlyPlans = _plans
                            .where((p) => p.billingFrequency == 'monthly')
                            .take(3)
                            .toList();
                        final displayPlans = monthlyPlans.isNotEmpty ? monthlyPlans : _plans.take(3).toList();
                        // Réindexer la sélection si hors bornes
                        final safeIdx = _selectedIndex.clamp(0, displayPlans.length - 1);
                        return _AnimatedPlanList(
                          plans: displayPlans,
                          selectedIndex: safeIdx,
                          currency: _currency,
                          onSelect: (i) => setState(() => _selectedIndex = i),
                          l10n: l10n,
                        );
                      }),
                    ],

                    const SizedBox(height: 14),

                    // ── Avis ─────────────────────────────────────────────────
                    _TestimonialCard(l10n: l10n),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── CTA sticky — utilise les mêmes plans filtrés ─────────────────
            Builder(builder: (ctx) {
              final monthlyPlans = _plans
                  .where((p) => p.billingFrequency == 'monthly')
                  .take(3)
                  .toList();
              final displayPlans = monthlyPlans.isNotEmpty ? monthlyPlans : _plans.take(3).toList();
              final safeIdx      = _selectedIndex.clamp(0, displayPlans.isEmpty ? 0 : displayPlans.length - 1);
              return _AnimatedCta(
                plans: displayPlans,
                selectedIndex: safeIdx,
                currency: _currency,
                shimmer: _ctaShimmer,
                loading: _checkoutLoading,
                onSubscribe: _plans.isNotEmpty ? _goToSubscription : widget.onContinue,
                onSkip: widget.onContinue,
                l10n: l10n,
              );
            }),
          ],
        ),
      ),
    );
  }

  String _featureLabel(AppLocalizations l, int i) => [
    l.unlimitedScan, l.personalizedCoach, l.nutritionPlanning,
    l.customRecipes, l.progressTracking,  l.dailyReminders,
  ][i];

  String _featureSub(AppLocalizations l, int i) => [
    l.featureSubScan, l.featureSubCoach, l.featureSubPlanning,
    l.featureSubRecipes, l.featureSubProgress, l.featureSubReminders,
  ][i];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Hero Header
// ═══════════════════════════════════════════════════════════════════════════════

class _HeroHeader extends StatelessWidget {
  final Animation<double> glowPulse;
  final AppLocalizations l10n;
  const _HeroHeader({required this.glowPulse, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.accent.withAlpha(22),
            AppTheme.surface.withAlpha(255),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icône avec glow pulsé
          AnimatedBuilder(
            animation: glowPulse,
            builder: (_, child) => Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accent.withAlpha(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withAlpha((glowPulse.value * 80).round()),
                    blurRadius: 18 * glowPulse.value,
                    spreadRadius: 2 * glowPulse.value,
                  ),
                ],
              ),
              child: child,
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                color: AppTheme.accent, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.paywallTitle,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.paywallSubtitle,
                  style: const TextStyle(fontSize: 13, color: AppTheme.muted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Feature Tile
// ═══════════════════════════════════════════════════════════════════════════════

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  const _FeatureTile({required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.accent, size: 18),
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 3),
          Text(sub, style: const TextStyle(fontSize: 11, color: AppTheme.muted, height: 1.3)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Animated Plan List (style subscription_screen)
// ═══════════════════════════════════════════════════════════════════════════════

class _AnimatedPlanList extends StatelessWidget {
  final List<Plan> plans;
  final int selectedIndex;
  final AppCurrency currency;
  final ValueChanged<int> onSelect;
  final AppLocalizations l10n;

  const _AnimatedPlanList({
    required this.plans,
    required this.selectedIndex,
    required this.currency,
    required this.onSelect,
    required this.l10n,
  });

  // Savings vs monthly plan
  int? _savings(Plan p) {
    if (p.billingFrequency == 'monthly') return null;
    final monthly = plans.firstWhere(
      (x) => x.billingFrequency == 'monthly',
      orElse: () => p,
    );
    if (monthly == p) return null;
    final mPrice = monthly.rawAmount(currency);
    if (mPrice <= 0) return null;
    final months = p.billingFrequency == 'yearly' ? 12 : p.billingFrequency == 'quarterly' ? 3 : 6;
    final equiv  = p.rawAmount(currency) / months;
    final saving = ((mPrice - equiv) / mPrice * 100).round();
    return saving > 0 ? saving : null;
  }

  String _freqBadge(Plan p) {
    switch (p.billingFrequency) {
      case 'yearly':      return '/ an';
      case 'quarterly':   return '/ trim.';
      case 'semi_annual': return '/ 6 mois';
      default:            return '/ mois';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bestIdx = (() {
      int idx = 0, best = 0;
      for (int i = 0; i < plans.length; i++) {
        final s = _savings(plans[i]) ?? 0;
        if (s > best) { best = s; idx = i; }
      }
      return best > 0 ? idx : -1;
    })();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.choosePlan.toUpperCase(),
          style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700,
            color: AppTheme.muted, letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),

        ...List.generate(plans.length, (i) {
          final plan = plans[i];
          final selected = i == selectedIndex;
          final isBest   = i == bestIdx;
          final savings  = _savings(plan);
          final daily    = plan.dailyCost(currency);
          final dailyStr = daily > 0
              ? (daily < 1.0
                  ? '${(daily * 100).toStringAsFixed(0)} c${currency.symbol}'
                  : '${daily.toStringAsFixed(2)} ${currency.symbol}')
              : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.accent.withAlpha(18)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? AppTheme.accent
                        : isBest
                            ? const Color(0xFFFFD700).withAlpha(100)
                            : AppTheme.border,
                    width: selected ? 1.8 : 1,
                  ),
                  boxShadow: selected ? [
                    BoxShadow(
                      color: AppTheme.accent.withAlpha(35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bannière "Meilleure offre"
                    if (isBest)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                          ),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bolt_rounded, color: Colors.black, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              l10n.save40.replaceAll('%', '').contains('ÉCONOMISEZ')
                                  ? 'MEILLEURE OFFRE'
                                  : 'BEST OFFER',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Radio
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected ? AppTheme.accent : AppTheme.muted,
                                width: 2,
                              ),
                              color: selected ? AppTheme.accent : Colors.transparent,
                              boxShadow: selected ? [
                                BoxShadow(color: AppTheme.accent.withAlpha(80), blurRadius: 6),
                              ] : null,
                            ),
                            child: selected
                                ? const Icon(Icons.check, size: 13, color: AppTheme.bg)
                                : null,
                          ),
                          const SizedBox(width: 14),

                          // Infos plan
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      plan.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        color: selected ? AppTheme.text : AppTheme.text,
                                      ),
                                    ),
                                    if (savings != null) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withAlpha(40),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          '-$savings%',
                                          style: const TextStyle(
                                            color: Colors.greenAccent,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (plan.description.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      plan.description,
                                      style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                                    ),
                                  ),
                                if (dailyStr != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      '≈ $dailyStr / jour',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: selected ? AppTheme.accent : AppTheme.muted,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Prix + fréquence
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                plan.displayPrice(currency),
                                style: TextStyle(
                                  fontFamily: 'Syne',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: selected ? AppTheme.accent : AppTheme.text,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _freqBadge(plan),
                                style: const TextStyle(fontSize: 11, color: AppTheme.muted),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Features list (visible seulement si sélectionné)
                    AnimatedSize(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      child: selected && plan.features.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(color: AppTheme.border, height: 1),
                                  const SizedBox(height: 12),
                                  ...plan.features.take(4).map((f) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle_rounded,
                                            color: AppTheme.accent, size: 14),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(f,
                                              style: const TextStyle(
                                                  color: AppTheme.text, fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Plans statiques (fallback API indisponible)
// ═══════════════════════════════════════════════════════════════════════════════

class _StaticPlans extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onSeePlans;
  final AppCurrency currency;
  const _StaticPlans({required this.onContinue, required this.onSeePlans, required this.currency});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _StaticPlanCard(
          name: l10n.premiumMonthly,
          priceUsdCents: 499,
          period: l10n.perMonth,
          badge: null,
          currency: currency,
          features: [l10n.unlimitedScan, l10n.personalizedCoach, l10n.nutritionPlanning],
        ),
        const SizedBox(height: 10),
        _StaticPlanCard(
          name: l10n.premiumYearly,
          priceUsdCents: 299,
          period: l10n.perMonth,
          badge: l10n.save40,
          currency: currency,
          features: [l10n.unlimitedScan, l10n.personalizedCoach, l10n.nutritionPlanning],
        ),
      ],
    );
  }
}

class _StaticPlanCard extends StatelessWidget {
  final String name, period;
  final int priceUsdCents;
  final String? badge;
  final AppCurrency currency;
  final List<String> features;
  const _StaticPlanCard({
    required this.name, required this.priceUsdCents,
    required this.period, required this.currency,
    this.badge, required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final highlighted = badge != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted ? AppTheme.accent.withAlpha(14) : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? AppTheme.accent : AppTheme.border,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppTheme.accent, borderRadius: BorderRadius.circular(5)),
                      child: Text(badge!,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.bg)),
                    ),
                  ],
                ]),
                const SizedBox(height: 4),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Row(children: [
                    const Icon(Icons.check_circle_rounded, size: 12, color: AppTheme.accent),
                    const SizedBox(width: 5),
                    Text(f, style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                  ]),
                )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(CurrencyService.format(priceUsdCents, currency),
                  style: const TextStyle(
                      fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w800,
                      color: AppTheme.accent)),
              Text(period, style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Testimonial Card
// ═══════════════════════════════════════════════════════════════════════════════

class _TestimonialCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _TestimonialCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          // Étoiles + note
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 15),
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 15),
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 15),
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 15),
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 15),
              ]),
              const SizedBox(height: 4),
              Text(l10n.rating,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.text)),
            ],
          ),
          const Spacer(),
          // Pill Essai gratuit
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accent.withAlpha(40), AppTheme.accent.withAlpha(20)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accent.withAlpha(80)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, size: 13, color: AppTheme.accent),
                const SizedBox(width: 5),
                Text(l10n.freeTrial,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.accent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Animated CTA (bouton avec shimmer)
// ═══════════════════════════════════════════════════════════════════════════════

class _AnimatedCta extends StatelessWidget {
  final List<Plan> plans;
  final int selectedIndex;
  final AppCurrency currency;
  final Animation<double> shimmer;
  final bool loading;
  final VoidCallback onSubscribe;
  final VoidCallback onSkip;
  final AppLocalizations l10n;

  const _AnimatedCta({
    required this.plans, required this.selectedIndex, required this.currency,
    required this.shimmer, required this.onSubscribe, required this.onSkip,
    required this.l10n, this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasPlan     = plans.isNotEmpty;
    final selectedPlan = hasPlan ? plans[selectedIndex] : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: AppTheme.bg,
        border: const Border(top: BorderSide(color: AppTheme.border)),
        boxShadow: [
          BoxShadow(color: AppTheme.bg, blurRadius: 20, offset: const Offset(0, -10)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton CTA avec shimmer
          AnimatedBuilder(
            animation: shimmer,
            builder: (_, child) {
              // Calcul position du reflet (0→1 en boucle)
              final shimmerX = shimmer.value;
              return SizedBox(
                width: double.infinity,
                height: 54,
                child: Stack(
                  children: [
                    // Bouton de base
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: loading ? null : onSubscribe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: loading
                                  ? [AppTheme.accent.withAlpha(80), AppTheme.accent.withAlpha(60)]
                                  : const [Color(0xFF5EE87A), AppTheme.accent, Color(0xFF3CB86E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: loading
                                ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(
                                        color: Color(0xFF0A0A0F), strokeWidth: 2.5),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.workspace_premium_rounded,
                                          size: 18, color: Color(0xFF0A0A0F)),
                                      const SizedBox(width: 8),
                                      Text(
                                        selectedPlan != null
                                            ? l10n.subscribePlan(selectedPlan.displayPrice(currency))
                                            : l10n.goPremiumButton,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15,
                                          color: Color(0xFF0A0A0F),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),

                    // Reflet shimmer
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: IgnorePointer(
                          child: Transform.translate(
                            offset: Offset((shimmerX * 2 - 0.5) * 300, 0),
                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withAlpha(0),
                                    Colors.white.withAlpha(35),
                                    Colors.white.withAlpha(0),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 10),
          GestureDetector(
            onTap: onSkip,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                l10n.continueFreePlanLabel,
                style: const TextStyle(
                  fontSize: 13, color: AppTheme.muted,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.muted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            l10n.noCommitment,
            style: TextStyle(fontSize: 10, color: AppTheme.muted.withAlpha(140)),
          ),
        ],
      ),
    );
  }
}
