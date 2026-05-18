import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme.dart';
import '../services/payment_service.dart';
import '../services/currency_service.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';
import 'subscription_screen.dart';

class PaywallScreen extends StatefulWidget {
  /// Appelé quand l'utilisateur continue (avec ou sans premium)
  final VoidCallback onContinue;
  const PaywallScreen({super.key, required this.onContinue});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  List<Plan> _plans = [];
  int _selectedIndex = 0;
  bool _loadingPlans = false;
  AppCurrency _currency = CurrencyService.defaultCurrency;

  static const _featureIcons = [
    Icons.document_scanner_rounded,
    Icons.smart_toy_rounded,
    Icons.calendar_month_rounded,
    Icons.restaurant_menu_rounded,
    Icons.analytics_rounded,
    Icons.notifications_active_rounded,
  ];

  static const _featureSubs = [
    'Analyse tout repas en 3 secondes',
    'Réponses adaptées à votre profil',
    '7 jours générés par l\'IA',
    'Ingrédients pesés & macros calculés',
    'Courbes & tendances sur le long terme',
    'Motivation chaque matin',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeIn  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    _fetchPlans();
    _loadCurrency();
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

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final features = [
      (icon: _featureIcons[0], label: l10n.unlimitedScan,       sub: _featureSubs[0]),
      (icon: _featureIcons[1], label: l10n.personalizedCoach,   sub: _featureSubs[1]),
      (icon: _featureIcons[2], label: l10n.nutritionPlanning,   sub: _featureSubs[2]),
      (icon: _featureIcons[3], label: l10n.customRecipes,       sub: _featureSubs[3]),
      (icon: _featureIcons[4], label: l10n.progressTracking,    sub: _featureSubs[4]),
      (icon: _featureIcons[5], label: l10n.dailyReminders,      sub: _featureSubs[5]),
    ];
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: SafeArea(
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SvgPicture.asset('assets/logo/dietvision-icon.svg', height: 28),
                      ),
                      const SizedBox(width: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w800),
                          children: [
                            TextSpan(text: 'Diet', style: TextStyle(color: AppTheme.text)),
                            TextSpan(text: 'Vision', style: TextStyle(color: AppTheme.accent)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Skip
                      TextButton(
                        onPressed: widget.onContinue,
                        style: TextButton.styleFrom(foregroundColor: AppTheme.muted),
                        child: Text(l10n.skip, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),

                // ── Scrollable body ──────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre
                        Text(
                          l10n.paywallTitle,
                          style: const TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            color: AppTheme.text,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.paywallSubtitle,
                          style: TextStyle(fontSize: 14, color: AppTheme.muted),
                        ),
                        const SizedBox(height: 22),

                        // ── Features grid ──────────────────────────────
                        ...List.generate((features.length / 2).ceil(), (row) {
                          final a = row * 2;
                          final b = a + 1;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(child: _FeatureTile(f: features[a])),
                                const SizedBox(width: 10),
                                if (b < features.length)
                                  Expanded(child: _FeatureTile(f: features[b]))
                                else
                                  const Expanded(child: SizedBox()),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 22),

                        // ── Plans ───────────────────────────────────────
                        if (_loadingPlans)
                          const Center(child: CircularProgressIndicator(color: AppTheme.accent))
                        else if (_plans.isEmpty)
                          // Plans statiques fallback si API indisponible
                          _StaticPlans(onContinue: widget.onContinue, onSeePlans: _goToSubscription, currency: _currency)
                        else ...[
                          Text(l10n.choosePlan,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.muted, letterSpacing: 1)),
                          const SizedBox(height: 10),
                          ...List.generate(_plans.length, (i) => _PlanTile(
                            plan: _plans[i],
                            selected: _selectedIndex == i,
                            currency: _currency,
                            onTap: () => setState(() => _selectedIndex = i),
                          )),
                        ],

                        const SizedBox(height: 12),

                        // ── Avis utilisateurs ───────────────────────────
                        _ReviewRow(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // ── Sticky bottom CTA ────────────────────────────────────
                _BottomCta(
                  plans: _plans,
                  selectedIndex: _selectedIndex,
                  currency: _currency,
                  onSubscribe: () {
                    if (_plans.isNotEmpty) {
                      _goToSubscription();
                    } else {
                      widget.onContinue();
                    }
                  },
                  onSkip: widget.onContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToSubscription() async {
    final loggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      // Utilisateur connecté → aller directement à l'écran d'abonnement
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
      ).then((_) => widget.onContinue());
    } else {
      // Pas encore connecté → expliquer qu'un compte est requis
      final l10n = AppLocalizations.of(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.lock_rounded, color: AppTheme.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.accountRequired,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          content: Text(
            l10n.accountRequiredDesc,
            style: const TextStyle(color: Color(0xFF94A3B8), height: 1.5, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel, style: const TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // ferme le dialog
                widget.onContinue();   // avance vers inscription/login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.bg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(l10n.createAccountButton, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      );
    }
  }
}

// ── Feature tile ──────────────────────────────────────────────────────────────

class _FeatureTile extends StatelessWidget {
  final ({IconData icon, String label, String sub}) f;
  const _FeatureTile({required this.f});

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
            child: Icon(f.icon, color: AppTheme.accent, size: 18),
          ),
          const SizedBox(height: 10),
          Text(f.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 3),
          Text(f.sub, style: const TextStyle(fontSize: 11, color: AppTheme.muted, height: 1.3)),
        ],
      ),
    );
  }
}

// ── Plan tile ─────────────────────────────────────────────────────────────────

class _PlanTile extends StatelessWidget {
  final Plan plan;
  final bool selected;
  final AppCurrency currency;
  final VoidCallback onTap;
  const _PlanTile({required this.plan, required this.selected, required this.currency, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent.withAlpha(18) : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppTheme.accent : AppTheme.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? AppTheme.accent : AppTheme.muted, width: 2),
                color: selected ? AppTheme.accent : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: AppTheme.bg)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(plan.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      if (plan.badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(plan.badge!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.bg)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(plan.description, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.displayPrice(currency),
                  style: const TextStyle(fontFamily: 'Syne', fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.accent),
                ),
                Text(
                  plan.frequencyLabel,
                  style: const TextStyle(fontSize: 11, color: AppTheme.muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Plans statiques (fallback) ────────────────────────────────────────────────

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
          period: '/ mois',
          badge: null,
          currency: currency,
          features: [l10n.unlimitedScan, l10n.personalizedCoach, l10n.nutritionPlanning],
        ),
        const SizedBox(height: 10),
        _StaticPlanCard(
          name: l10n.premiumYearly,
          priceUsdCents: 299,
          period: '/ mois',
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
    required this.name,
    required this.priceUsdCents,
    required this.period,
    required this.currency,
    this.badge,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badge != null ? AppTheme.accent : AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(5)),
                        child: Text(badge!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.bg)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 12, color: AppTheme.accent),
                      const SizedBox(width: 5),
                      Text(f, style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                    ],
                  ),
                )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyService.format(priceUsdCents, currency),
                style: const TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.accent),
              ),
              Text(period, style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Avis ──────────────────────────────────────────────────────────────────────

class _ReviewRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
                  Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
                  Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
                  Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
                  Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Text(l10n.rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.text)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(l10n.freeTrial, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.accent)),
          ),
        ],
      ),
    );
  }
}

// ── Bottom CTA ────────────────────────────────────────────────────────────────

class _BottomCta extends StatelessWidget {
  final List<Plan> plans;
  final int selectedIndex;
  final AppCurrency currency;
  final VoidCallback onSubscribe;
  final VoidCallback onSkip;
  const _BottomCta({required this.plans, required this.selectedIndex, required this.currency, required this.onSubscribe, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasPlan = plans.isNotEmpty;
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.bg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.workspace_premium_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    selectedPlan != null
                        ? l10n.subscribePlan(selectedPlan.displayPrice(currency))
                        : l10n.goPremiumButton,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onSkip,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                l10n.continueFreePlanLabel,
                style: const TextStyle(fontSize: 13, color: AppTheme.muted, decoration: TextDecoration.underline, decorationColor: AppTheme.muted),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.noCommitment,
            style: TextStyle(fontSize: 10, color: AppTheme.muted.withAlpha(140)),
          ),
        ],
      ),
    );
  }
}
