import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/payment_service.dart';
import '../services/currency_service.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'subscription_screen.dart';

class PaywallScreen extends StatefulWidget {
  final VoidCallback onContinue;
  const PaywallScreen({super.key, required this.onContinue});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen>
    with TickerProviderStateMixin {
  AppColors get c => AppTheme.of(context);

  // ── PageView ───────────────────────────────────────────────────────────────
  final _pageCtrl  = PageController();
  int _currentPage = 0;

  // ── Animations ────────────────────────────────────────────────────────────
  late final AnimationController _glowCtrl;
  late final AnimationController _heroCtrl;
  late final AnimationController _staggerCtrl;
  late final AnimationController _ctaCtrl;

  late final Animation<double> _glowPulse;
  late final Animation<double> _heroFade;
  late final Animation<Offset>  _heroSlide;
  late final List<Animation<double>> _featureFades;
  late final List<Animation<Offset>>  _featureSlides;
  late final Animation<double> _ctaShimmer;

  // ── Données ───────────────────────────────────────────────────────────────
  List<Plan> _plans        = [];
  int _selectedIndex       = 0;
  bool _loadingPlans       = false;
  String? _plansError;
  bool _checkoutLoading    = false;
  AppCurrency _currency    = CurrencyService.defaultCurrency;
  String? _lastLocale;

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

    // Glow pulse (boucle)
    _glowCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _glowPulse = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );

    // Hero fade + slide (page 1)
    _heroCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _heroFade  = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOutCubic));

    // Stagger features (page 2)
    _staggerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _featureFades = List.generate(6, (i) {
      final start = i * 0.12;
      final end   = (start + 0.35).clamp(0.0, 1.0);
      return CurvedAnimation(parent: _staggerCtrl, curve: Interval(start, end, curve: Curves.easeOut));
    });
    _featureSlides = List.generate(6, (i) {
      final start = i * 0.12;
      final end   = (start + 0.35).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.22), end: Offset.zero).animate(
        CurvedAnimation(parent: _staggerCtrl, curve: Interval(start, end, curve: Curves.easeOut)),
      );
    });

    // CTA shimmer (boucle)
    _ctaCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat();
    _ctaShimmer = CurvedAnimation(parent: _ctaCtrl, curve: Curves.easeInOut);

    _heroCtrl.forward();
    _loadCurrency();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    if (_lastLocale != locale) {
      _lastLocale = locale;
      _fetchPlans(locale);
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _glowCtrl.dispose();
    _heroCtrl.dispose();
    _staggerCtrl.dispose();
    _ctaCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans([String locale = 'en']) async {
    setState(() { _loadingPlans = true; _plansError = null; });
    try {
      final plans = await PaymentService.fetchPlans(locale: locale);
      if (mounted) setState(() { _plans = plans; _loadingPlans = false; });
    } catch (e) {
      if (mounted) setState(() { _loadingPlans = false; _plansError = e.toString(); });
    }
  }

  Future<void> _loadCurrency() async {
    final c = await CurrencyService.load();
    if (mounted) setState(() => _currency = c);
  }

  // ── Navigation pages ─────────────────────────────────────────────────────
  void _nextPage() {
    if (_currentPage < 2) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 480),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goToSubscription();
    }
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    if (page == 1 && _staggerCtrl.isDismissed) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _staggerCtrl.forward();
      });
    }
  }

  // ── Abonnement ───────────────────────────────────────────────────────────
  Future<void> _goToSubscription() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;

    if (!loggedIn) {
      final l10n = AppLocalizations.of(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(children: [
            Icon(Icons.lock_rounded, color: c.accent, size: 20),
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
                backgroundColor: c.accent,
                foregroundColor: c.bg,
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

    final monthlyPlans = _plans.where((p) => p.billingFrequency == 'monthly').take(3).toList();
    final displayPlans = monthlyPlans.isNotEmpty ? monthlyPlans : _plans.take(3).toList();

    if (displayPlans.isEmpty) {
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()))
          .then((_) => widget.onContinue());
      return;
    }

    final safeIdx     = _selectedIndex.clamp(0, displayPlans.length - 1);
    final selectedPlan = displayPlans[safeIdx];

    if (!selectedPlan.stripeAvailable) {
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()))
          .then((_) => widget.onContinue());
      return;
    }

    setState(() => _checkoutLoading = true);
    try {
      final result = await PaymentService.createCheckout(
        selectedPlan,
        locale: Localizations.localeOf(context).languageCode,
      );
      if (!mounted) return;
      setState(() => _checkoutLoading = false);

      showModalBottomSheet(
        context: context,
        backgroundColor: c.surface,
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
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);

    final monthlyPlans = _plans.where((p) => p.billingFrequency == 'monthly').take(3).toList();
    final displayPlans = monthlyPlans.isNotEmpty ? monthlyPlans : _plans.take(3).toList();
    final safeIdx      = _selectedIndex.clamp(0, displayPlans.isEmpty ? 0 : displayPlans.length - 1);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [

            // ── Barre supérieure ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 16, 0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SvgPicture.asset('assets/logo/dietvision-icon.svg', height: 26),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w800),
                      children: [
                        TextSpan(text: 'Diet',   style: TextStyle(color: c.text)),
                        TextSpan(text: 'Vision', style: TextStyle(color: c.accent)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // ── Sélecteur de langue ──────────────────────────────────
                  _LangButton(),
                  const SizedBox(width: 8),
                  // Indicateur "1 / 3"
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: c.border),
                    ),
                    child: Text(
                      '${_currentPage + 1} / 3',
                      style: TextStyle(
                          fontSize: 12, color: c.muted, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: widget.onContinue,
                    style: TextButton.styleFrom(
                        foregroundColor: c.muted,
                        padding: const EdgeInsets.symmetric(horizontal: 8)),
                    child: Text(l10n.skip, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),

            // ── Dots de progression ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final active = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width:  active ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? c.accent : c.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            // ── Pages ────────────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: [

                  // Page 1 — Bienvenue
                  _WelcomePage(
                    glowPulse: _glowPulse,
                    heroFade:  _heroFade,
                    heroSlide: _heroSlide,
                    l10n: l10n,
                  ),

                  // Page 2 — Fonctionnalités
                  _FeaturesPage(
                    featureFades:  _featureFades,
                    featureSlides: _featureSlides,
                    featureIcons:  _featureIcons,
                    featureLabel:  (i) => _featureLabel(l10n, i),
                    featureSub:    (i) => _featureSub(l10n, i),
                    l10n: l10n,
                  ),

                  // Page 3 — Plans
                  _PlansPage(
                    loadingPlans:  _loadingPlans,
                    plansError:    _plansError,
                    plans:         displayPlans,
                    selectedIndex: safeIdx,
                    currency:      _currency,
                    onSelect:      (i) => setState(() => _selectedIndex = i),
                    onContinue:    widget.onContinue,
                    onSeePlans:    _goToSubscription,
                    onRetry:       _fetchPlans,
                    l10n: l10n,
                  ),
                ],
              ),
            ),

            // ── Barre CTA sticky ─────────────────────────────────────────────
            _BottomBar(
              currentPage:   _currentPage,
              plans:         displayPlans,
              selectedIndex: safeIdx,
              currency:      _currency,
              shimmer:       _ctaShimmer,
              loading:       _checkoutLoading,
              onNext:        _nextPage,
              onSkip:        widget.onContinue,
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }

  String _featureLabel(AppLocalizations l, int i) => [
    l.unlimitedScan,    l.personalizedCoach, l.nutritionPlanning,
    l.customRecipes,    l.progressTracking,  l.dailyReminders,
  ][i];

  String _featureSub(AppLocalizations l, int i) => [
    l.featureSubScan,     l.featureSubCoach,     l.featureSubPlanning,
    l.featureSubRecipes,  l.featureSubProgress,  l.featureSubReminders,
  ][i];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Page 1 — Bienvenue (Hero plein écran)
// ═══════════════════════════════════════════════════════════════════════════════

class _WelcomePage extends StatelessWidget {
  final Animation<double> glowPulse;
  final Animation<double> heroFade;
  final Animation<Offset>  heroSlide;
  final AppLocalizations l10n;

  const _WelcomePage({
    required this.glowPulse,
    required this.heroFade,
    required this.heroSlide,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return FadeTransition(
      opacity: heroFade,
      child: SlideTransition(
        position: heroSlide,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // ── Icône hero avec glow pulsé ──────────────────────────────
                AnimatedBuilder(
                  animation: glowPulse,
                  builder: (_, child) => Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.accent.withAlpha(16),
                      border: Border.all(
                        color: c.accent.withAlpha((glowPulse.value * 80).round()),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: c.accent.withAlpha((glowPulse.value * 100).round()),
                          blurRadius: 55 * glowPulse.value,
                          spreadRadius: 8 * glowPulse.value,
                        ),
                        BoxShadow(
                          color: c.accent.withAlpha((glowPulse.value * 35).round()),
                          blurRadius: 90 * glowPulse.value,
                          spreadRadius: 18 * glowPulse.value,
                        ),
                      ],
                    ),
                    child: child,
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: SvgPicture.asset(
                        'assets/logo/dietvision-icon.svg',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 44),

                // ── Titre ───────────────────────────────────────────────────
                Text(
                  l10n.welcomeTo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: c.text,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'DietVision',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: c.accent,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Sous-titre ───────────────────────────────────────────────
                Text(
                  l10n.welcomeSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: c.muted,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 36),

                // ── 3 chips fonctionnalités ──────────────────────────────────
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _MiniChip(icon: Icons.document_scanner_rounded, label: l10n.chipMealScan),
                    _MiniChip(icon: Icons.analytics_rounded,        label: l10n.chipMacroTracking),
                    _MiniChip(icon: Icons.smart_toy_rounded,         label: l10n.chipAiCoach),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Badge essai gratuit ──────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [c.accent.withAlpha(36), c.accent.withAlpha(18)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: c.accent.withAlpha(80)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, size: 15, color: c.accent),
                      const SizedBox(width: 6),
                      Text(
                        l10n.freeTrial,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700, color: c.accent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Mini chip
class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MiniChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c.accent),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: c.text, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Page 2 — Fonctionnalités
// ═══════════════════════════════════════════════════════════════════════════════

class _FeaturesPage extends StatelessWidget {
  final List<Animation<double>> featureFades;
  final List<Animation<Offset>>  featureSlides;
  final List<IconData> featureIcons;
  final String Function(int) featureLabel;
  final String Function(int) featureSub;
  final AppLocalizations l10n;

  const _FeaturesPage({
    required this.featureFades,
    required this.featureSlides,
    required this.featureIcons,
    required this.featureLabel,
    required this.featureSub,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── En-tête ────────────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              style: TextStyle(
                  fontFamily: 'Syne', fontSize: 26, fontWeight: FontWeight.w800,
                  color: c.text, height: 1.2),
              children: [
                TextSpan(text: l10n.paywallFeaturesPrefix),
                TextSpan(text: l10n.paywallFeaturesHighlight, style: TextStyle(color: c.accent)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paywallFeaturesSubtitle,
            style: TextStyle(fontSize: 14, color: c.muted, height: 1.5),
          ),
          const SizedBox(height: 22),

          // ── Grille 2×3 staggerée ───────────────────────────────────────────
          ...List.generate(3, (row) {
            final a = row * 2;
            final b = a + 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: FadeTransition(
                      opacity: featureFades[a],
                      child: SlideTransition(
                        position: featureSlides[a],
                        child: _FeatureTile(
                          icon:  featureIcons[a],
                          label: featureLabel(a),
                          sub:   featureSub(a),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (b < 6)
                    Expanded(
                      child: FadeTransition(
                        opacity: featureFades[b],
                        child: SlideTransition(
                          position: featureSlides[b],
                          child: _FeatureTile(
                            icon:  featureIcons[b],
                            label: featureLabel(b),
                            sub:   featureSub(b),
                          ),
                        ),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
            );
          }),
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
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: c.accent.withAlpha(22),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: c.accent, size: 18),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13, color: c.text)),
          const SizedBox(height: 3),
          Text(sub,
              style: TextStyle(
                  fontSize: 11, color: c.muted, height: 1.35)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Page 3 — Plans
// ═══════════════════════════════════════════════════════════════════════════════

class _PlansPage extends StatelessWidget {
  final bool loadingPlans;
  final String? plansError;
  final List<Plan> plans;
  final int selectedIndex;
  final AppCurrency currency;
  final ValueChanged<int> onSelect;
  final VoidCallback onContinue;
  final VoidCallback onSeePlans;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _PlansPage({
    required this.loadingPlans,
    this.plansError,
    required this.plans,
    required this.selectedIndex,
    required this.currency,
    required this.onSelect,
    required this.onContinue,
    required this.onSeePlans,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── En-tête ────────────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              style: TextStyle(
                  fontFamily: 'Syne', fontSize: 26, fontWeight: FontWeight.w800,
                  color: c.text, height: 1.2),
              children: [
                TextSpan(text: l10n.paywallPlanPrefix),
                TextSpan(text: l10n.paywallPlanHighlight,
                    style: TextStyle(color: c.accent)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paywallPlanSubtitle,
            style: TextStyle(fontSize: 14, color: c.muted, height: 1.5),
          ),
          const SizedBox(height: 22),

          // ── Plans ──────────────────────────────────────────────────────────
          if (loadingPlans)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (plans.isEmpty && plansError != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(Icons.wifi_off_rounded, color: c.muted, size: 36),
                    const SizedBox(height: 10),
                    Text(l10n.cannotLoadPlans,
                        style: TextStyle(color: c.muted, fontSize: 14)),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(l10n.retry),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: c.accent,
                        side: BorderSide(color: c.accent),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (plans.isEmpty)
            _StaticPlans(
              onContinue: onContinue,
              onSeePlans: onSeePlans,
              currency:   currency,
            )
          else
            _AnimatedPlanList(
              plans:         plans,
              selectedIndex: selectedIndex,
              currency:      currency,
              onSelect:      onSelect,
              l10n:          l10n,
            ),

          const SizedBox(height: 16),

          // ── Avis ───────────────────────────────────────────────────────────
          _TestimonialCard(l10n: l10n),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Barre inférieure CTA
// ═══════════════════════════════════════════════════════════════════════════════

class _BottomBar extends StatelessWidget {
  final int currentPage;
  final List<Plan> plans;
  final int selectedIndex;
  final AppCurrency currency;
  final Animation<double> shimmer;
  final bool loading;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final AppLocalizations l10n;

  const _BottomBar({
    required this.currentPage,
    required this.plans,
    required this.selectedIndex,
    required this.currency,
    required this.shimmer,
    required this.loading,
    required this.onNext,
    required this.onSkip,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final isLastPage   = currentPage == 2;
    final selectedPlan = plans.isNotEmpty ? plans[selectedIndex] : null;

    // Libellé du bouton selon la page
    Widget buttonContent() {
      if (loading) {
        return const SizedBox(
          width: 22, height: 22,
          child: CircularProgressIndicator(color: Color(0xFF0A0A0F), strokeWidth: 2.5),
        );
      }
      if (isLastPage) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium_rounded, size: 18, color: Color(0xFF0A0A0F)),
            const SizedBox(width: 8),
            Text(
              selectedPlan != null
                  ? l10n.subscribePlan(selectedPlan.displayPrice(currency))
                  : l10n.goPremiumButton,
              style: const TextStyle(
                  fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF0A0A0F)),
            ),
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.next,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF0A0A0F))),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_rounded, size: 18, color: Color(0xFF0A0A0F)),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: c.bg,
        border: Border(top: BorderSide(color: c.border)),
        boxShadow: [
          BoxShadow(color: c.bg, blurRadius: 20, offset: Offset(0, -10)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Bouton principal avec shimmer ────────────────────────────────
          AnimatedBuilder(
            animation: shimmer,
            builder: (_, child) {
              return SizedBox(
                width: double.infinity,
                height: 54,
                child: Stack(
                  children: [
                    // Bouton
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: loading ? null : onNext,
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
                                  ? [c.accent.withAlpha(80), c.accent.withAlpha(60)]
                                  : [Color(0xFF5EE87A), c.accent, Color(0xFF3CB86E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: buttonContent(),
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
                            offset: Offset((shimmer.value * 2 - 0.5) * 300, 0),
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

          // ── Lien "Continuer avec la version gratuite" ────────────────────
          GestureDetector(
            onTap: onSkip,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                l10n.continueFreePlanLabel,
                style: TextStyle(
                  fontSize: 13, color: c.muted,
                  decoration: TextDecoration.underline,
                  decorationColor: c.muted,
                ),
              ),
            ),
          ),

          if (isLastPage) ...[
            const SizedBox(height: 3),
            Text(
              l10n.noCommitment,
              style: TextStyle(fontSize: 10, color: c.muted.withAlpha(140)),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Animated Plan List
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
      case 'yearly':      return l10n.perYear;
      case 'quarterly':   return l10n.perQuarter;
      case 'semi_annual': return l10n.per6Months;
      default:            return l10n.perMonth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
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
      children: List.generate(plans.length, (i) {
        final plan     = plans[i];
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
                color: selected ? c.accent.withAlpha(18) : c.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? c.accent
                      : isBest
                          ? const Color(0xFFFFD700).withAlpha(100)
                          : c.border,
                  width: selected ? 1.8 : 1,
                ),
                boxShadow: selected ? [
                  BoxShadow(
                    color: c.accent.withAlpha(35),
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
                      decoration: BoxDecoration(
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
                            l10n.bestOffer.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black, fontSize: 10,
                              fontWeight: FontWeight.w900, letterSpacing: 0.8,
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
                        // Bouton radio
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected ? c.accent : c.muted,
                              width: 2,
                            ),
                            color: selected ? c.accent : Colors.transparent,
                            boxShadow: selected ? [
                              BoxShadow(color: c.accent.withAlpha(80), blurRadius: 6),
                            ] : null,
                          ),
                          child: selected
                              ? Icon(Icons.check, size: 13, color: c.bg)
                              : null,
                        ),
                        const SizedBox(width: 14),

                        // Infos plan
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(plan.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800, fontSize: 15, color: c.text)),
                                if (savings != null) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withAlpha(40),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text('-$savings%',
                                        style: TextStyle(
                                            color: Colors.greenAccent, fontSize: 10,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                ],
                              ]),
                              if (plan.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(plan.description,
                                      style: TextStyle(fontSize: 12, color: c.muted)),
                                ),
                              if (dailyStr != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(l10n.perDay('≈ $dailyStr'),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: selected ? c.accent : c.muted,
                                          fontWeight: FontWeight.w600)),
                                ),
                            ],
                          ),
                        ),

                        // Prix
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(plan.displayPrice(currency),
                                style: TextStyle(
                                    fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w900,
                                    color: selected ? c.accent : c.text, height: 1)),
                            const SizedBox(height: 2),
                            Text(_freqBadge(plan),
                                style: TextStyle(fontSize: 11, color: c.muted)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Features (visible si sélectionné)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    child: selected && plan.features.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: c.border, height: 1),
                                const SizedBox(height: 12),
                                ...plan.features.take(4).map((f) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(children: [
                                    Icon(Icons.check_circle_rounded,
                                        color: c.accent, size: 14),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(f,
                                        style: TextStyle(color: c.text, fontSize: 12))),
                                  ]),
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
    final c = AppTheme.of(context);
    return Column(
      children: [
        _StaticPlanCard(
          name: l10n.premiumMonthly,
          priceUsdCents: 499,
          period: l10n.perMonth,
          badge: null,
          currency: currency,
          features: [l10n.proScanFeature, l10n.proChatFeature, l10n.nutritionPlanning],
        ),
        const SizedBox(height: 10),
        _StaticPlanCard(
          name: l10n.premiumYearly,
          priceUsdCents: 299,
          period: l10n.perMonth,
          badge: l10n.save40,
          currency: currency,
          features: [l10n.premiumScanFeature, l10n.premiumChatFeature, l10n.nutritionPlanning],
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
    final c = AppTheme.of(context);
    final highlighted = badge != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted ? c.accent.withAlpha(14) : c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? c.accent : c.border,
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
                  Text(name,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                          color: c.accent, borderRadius: BorderRadius.circular(5)),
                      child: Text(badge!,
                          style: TextStyle(
                              fontSize: 9, fontWeight: FontWeight.w800, color: c.bg)),
                    ),
                  ],
                ]),
                const SizedBox(height: 4),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Row(children: [
                    Icon(Icons.check_circle_rounded, size: 12, color: c.accent),
                    const SizedBox(width: 5),
                    Text(f, style: TextStyle(fontSize: 11, color: c.muted)),
                  ]),
                )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(CurrencyService.format(priceUsdCents, currency),
                  style: TextStyle(
                      fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w800,
                      color: c.accent)),
              Text(period, style: TextStyle(fontSize: 11, color: c.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Bouton langue (réutilisable dans le top bar)
// ═══════════════════════════════════════════════════════════════════════════════

class _LangButton extends StatelessWidget {
  const _LangButton();

  void _showPicker(BuildContext context) {
    final c = AppTheme.of(context);
    final localeProvider = context.read<LocaleProvider>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx);
              return Text(l10n.chooseLanguage,
                  style: const TextStyle(
                      fontFamily: 'Syne', fontSize: 17, fontWeight: FontWeight.w700));
            }),
            const SizedBox(height: 14),
            ...LocaleProvider.supportedLanguages.map((lang) {
              final isSelected = localeProvider.locale.languageCode == lang.$1;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(lang.$3, style: TextStyle(fontSize: 26)),
                title: Text(lang.$2,
                    style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                        color: isSelected ? c.accent : c.text)),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: c.accent, size: 20)
                    : null,
                onTap: () {
                  localeProvider.setLocale(Locale(lang.$1));
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final c = AppTheme.of(context);
    final currentLang = LocaleProvider.supportedLanguages.firstWhere(
      (l) => l.$1 == localeProvider.locale.languageCode,
      orElse: () => LocaleProvider.supportedLanguages.first,
    );
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentLang.$3, style: TextStyle(fontSize: 15)),
            const SizedBox(width: 4),
            Text(currentLang.$1.toUpperCase(),
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700, color: c.muted)),
            const SizedBox(width: 2),
            Icon(Icons.expand_more, size: 13, color: c.muted),
          ],
        ),
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
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
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
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: c.text)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.accent.withAlpha(40), c.accent.withAlpha(20)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.accent.withAlpha(80)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 13, color: c.accent),
                const SizedBox(width: 5),
                Text(l10n.freeTrial,
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: c.accent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
