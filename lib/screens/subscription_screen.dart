import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/locale_provider.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import '../services/currency_service.dart';
import '../l10n/app_localizations.dart';

class SubscriptionScreen extends StatefulWidget {
  /// Appelé après confirmation du paiement, avant fermeture de l'écran.
  final VoidCallback? onSubscribed;
  const SubscriptionScreen({super.key, this.onSubscribed});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  List<Plan> _plans = [];
  bool _loading = true;
  String? _error;
  int? _processingPlanId;
  AppCurrency _currency = CurrencyService.defaultCurrency;
  String? _currentPlan; // plan actuellement souscrit ('free'|'starter'|'pro'|'premium')
  String? _lastLocale;

  @override
  void initState() {
    super.initState();
    _loadCurrency();
    _loadCurrentPlan();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    if (_lastLocale != locale) {
      _lastLocale = locale;
      _loadPlans(locale);
    }
  }

  /// Charge le plan depuis le cache local puis rafraîchit depuis le serveur.
  Future<void> _loadCurrentPlan() async {
    // 1. Cache immédiat
    final cached = await AuthService.getCachedUser();
    final localPlan = cached?['plan'] as String?
        ?? cached?['subscription_plan'] as String?
        ?? 'free';
    if (mounted) setState(() => _currentPlan = localPlan.toLowerCase());

    // 2. Refresh serveur
    final status = await PaymentService.fetchSubscriptionStatus();
    if (status != null && mounted) {
      setState(() => _currentPlan = status.plan.toLowerCase());
    }
  }

  Future<void> _loadPlans([String locale = 'en']) async {
    setState(() { _loading = true; _error = null; });
    try {
      final plans = await PaymentService.fetchPlans(locale: locale);
      if (mounted) setState(() { _plans = plans; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _loadCurrency() async {
    final c = await CurrencyService.load();
    if (mounted) setState(() => _currency = c);
  }

  Future<void> _onSubscribe(Plan plan) async {
    if (!plan.stripeAvailable) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        _snack(l10n.notAvailableYet, error: true);
      }
      return;
    }
    setState(() => _processingPlanId = plan.id);
    try {
      final result = await PaymentService.createCheckout(
        plan,
        locale: Localizations.localeOf(context).languageCode,
      );
      if (!mounted) return;
      setState(() => _processingPlanId = null);
      _showCheckoutSheet(plan, result);
    } catch (e) {
      if (mounted) {
        setState(() => _processingPlanId = null);
        _snack(e.toString(), error: true);
      }
    }
  }

  // Async : attend que CheckoutSheet retourne true (paiement confirmé)
  // puis ferme aussi SubscriptionScreen pour revenir directement à l'écran appelant.
  Future<void> _showCheckoutSheet(Plan plan, SubscribeResult result) async {
    final paid = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) => CheckoutSheet(
        plan: plan,
        checkoutUrl: result.checkoutUrl,
        sessionId: result.sessionId,
        currency: _currency,
        onSubscribed: widget.onSubscribed,
      ),
    );
    // Si le paiement a été confirmé → fermer aussi SubscriptionScreen
    // pour revenir directement à CoachScreen / HomeShell.
    if (paid == true && mounted) {
      Navigator.pop(context);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red.shade800 : AppTheme.surface,
    ));
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        title: Text(l10n.premiumTitle,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accent))
          : _error != null
              ? _ErrorView(error: _error!, onRetry: _loadPlans)
              : _PlanList(
                  plans: _plans,
                  processingPlanId: _processingPlanId,
                  currency: _currency,
                  currentPlan: _currentPlan,
                  onSubscribe: _onSubscribe,
                ),
    );
  }
}

// ── Checkout Bottom Sheet ─────────────────────────────────────────────────────
// Public pour permettre de l'appeler directement depuis le paywall screen.

class CheckoutSheet extends StatefulWidget {
  final Plan plan;
  final String checkoutUrl;
  final String sessionId;
  final AppCurrency currency;
  final VoidCallback? onSubscribed;
  const CheckoutSheet({
    super.key,
    required this.plan,
    required this.checkoutUrl,
    required this.sessionId,
    required this.currency,
    this.onSubscribed,
  });

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  bool _opened   = false;
  bool _checking = false;

  // Étapes de vérification (null = en attente, false = échec, true = ok)
  bool? _stepPayment;
  bool? _stepServer;
  bool? _stepInvoice;

  // Polling webhook
  int  _webhookAttempt = 0;
  static const _webhookMaxAttempts = 5;

  Future<void> _openStripe() async {
    final uri = Uri.parse(widget.checkoutUrl);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (launched && mounted) {
        setState(() => _opened = true);
      } else if (mounted) {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        if (mounted) setState(() => _opened = true);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.cannotOpenBrowser(e.toString()))),
        );
      }
    }
  }

  Future<void> _confirmPayment() async {
    setState(() {
      _checking        = true;
      _stepPayment     = null;
      _stepServer      = null;
      _stepInvoice     = null;
      _webhookAttempt  = 0;
    });

    // ── Étape 1 : vérifier le paiement Stripe via /payments/verify ────────
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final verify = await PaymentService.verifyCheckout(widget.sessionId);
    if (!mounted) return;

    // Erreur réseau totale → fallback /auth/me
    if (verify == null) {
      final plan = await PaymentService.fetchCurrentPlan();
      if (!mounted) return;
      setState(() => _checking = false);
      if (plan != null && plan != 'free') {
        _showSuccessDialog(invoiceSent: false, emailSent: false);
      } else {
        _snack(AppLocalizations.of(context).paymentUnconfirmed, retry: true);
      }
      return;
    }

    // Marquer l'étape paiement
    setState(() => _stepPayment = verify.paid);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    if (!verify.paid) {
      setState(() => _checking = false);
      _snack(AppLocalizations.of(context).paymentUnconfirmed, retry: false);
      return;
    }

    // ── Étape 2 : polling webhook ─────────────────────────────────────────
    // Si le webhook était déjà reçu lors du /verify, on le confirme direct.
    // Sinon on interroge GET /payments/webhook-status toutes les 3 s (max 5×).
    bool webhookOk = verify.webhookReceived;

    if (!webhookOk) {
      webhookOk = await PaymentService.checkWebhookReceived(
        widget.sessionId,
        maxAttempts: _webhookMaxAttempts,
        interval: const Duration(seconds: 3),
        onAttempt: (attempt, max) {
          if (mounted) setState(() => _webhookAttempt = attempt);
        },
      );
      if (!mounted) return;
    }

    // Si le webhook n'est pas encore reçu mais que Stripe a confirmé le paiement,
    // on accorde l'accès immédiatement. Le webhook arrivera en différé côté serveur.
    setState(() => _stepServer = true); // best-effort : Stripe a confirmé
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // ── Étape 3 : facture ─────────────────────────────────────────────────
    setState(() => _stepInvoice = verify.invoiceSent);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    setState(() => _checking = false);
    // Ne pas pop le sheet ici — le dialog gère lui-même la fermeture de la feuille.
    _showSuccessDialog(invoiceSent: verify.invoiceSent, emailSent: verify.emailSent);
  }

  void _snack(String msg, {required bool retry}) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 5),
      action: retry
          ? SnackBarAction(
              label: l10n.retryVerification,
              textColor: AppTheme.accent,
              onPressed: _confirmPayment,
            )
          : null,
    ));
  }

  void _showSuccessDialog({required bool invoiceSent, required bool emailSent}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Builder(builder: (ctx) {
          final l10n = AppLocalizations.of(ctx);
          return Row(
            children: [
              const Icon(Icons.workspace_premium_rounded, color: AppTheme.accent, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l10n.paymentVerifiedTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ],
          );
        }),
        content: Builder(builder: (ctx) {
          final l10n = AppLocalizations.of(ctx);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.paymentVerifiedDesc,
                  style: const TextStyle(color: AppTheme.muted, height: 1.5, fontSize: 13)),
              const SizedBox(height: 16),
              // Récapitulatif des étapes
              _VerifyStepRow(
                icon: Icons.check_circle_rounded,
                color: AppTheme.accent,
                label: l10n.stepPaymentConfirmed,
              ),
              const SizedBox(height: 8),
              _VerifyStepRow(
                icon: Icons.check_circle_rounded,
                color: AppTheme.accent,
                label: l10n.stepServerNotified,
              ),
              const SizedBox(height: 8),
              _VerifyStepRow(
                icon: invoiceSent
                    ? Icons.check_circle_rounded
                    : Icons.info_outline_rounded,
                color: invoiceSent ? AppTheme.accent : AppTheme.muted,
                label: l10n.stepInvoiceSent,
              ),
            ],
          );
        }),
        actions: [
          Builder(builder: (ctx) {
            final l10n = AppLocalizations.of(ctx);
            return ElevatedButton(
              onPressed: () {
                // Déclencher le rafraîchissement du plan AVANT de fermer les écrans
                // pour que CoachScreen ait déjà le nouveau plan quand il redevient visible.
                widget.onSubscribed?.call();
                final nav = Navigator.of(ctx);
                nav.pop();        // 1er pop = ferme le dialog
                nav.pop(true);    // 2e pop = ferme CheckoutSheet en retournant true
                                  // → SubscriptionScreen voit le résultat et se ferme aussi
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.bg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.start,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Plan info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: AppTheme.accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.plan.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16)),
                    Text(
                      '${widget.plan.displayPrice(widget.currency)} · ${widget.plan.frequencyLabel}',
                      style: const TextStyle(color: AppTheme.muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Step 1
          if (!_opened) ...[
            Text(
              l10n.paymentReady,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.paymentMethods,
              style: const TextStyle(color: AppTheme.muted, height: 1.5, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Rappel code promo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.accent.withAlpha(40)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer_rounded, color: AppTheme.accent, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.promoCode,
                      style: const TextStyle(color: AppTheme.accent, fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openStripe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: const Color(0xFF0A0A0F),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.lock_rounded, size: 18),
                label: Text(l10n.payNow,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
          ] else ...[
            // Step 2 — après ouverture du navigateur
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accent.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.open_in_browser_rounded, color: AppTheme.accent, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.openingBrowser,
                      style: const TextStyle(color: AppTheme.accent, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Étapes de vérification (visibles pendant _checking) ─────────
            if (_checking) ...[
              // Étape 1 : paiement Stripe
              _VerifyStepRow(
                icon: _stepPayment == null
                    ? Icons.radio_button_unchecked
                    : (_stepPayment! ? Icons.check_circle_rounded : Icons.cancel_rounded),
                color: _stepPayment == null
                    ? AppTheme.muted
                    : (_stepPayment! ? AppTheme.accent : Colors.redAccent),
                label: l10n.stepPaymentConfirmed,
                loading: _stepPayment == null,
              ),
              const SizedBox(height: 10),

              // Étape 2 : webhook serveur (avec compteur de tentatives)
              _VerifyStepRow(
                icon: _stepServer == null
                    ? Icons.radio_button_unchecked
                    : (_stepServer! ? Icons.check_circle_rounded : Icons.cancel_rounded),
                color: _stepServer == null
                    ? AppTheme.muted
                    : (_stepServer! ? AppTheme.accent : Colors.orangeAccent),
                label: (_stepServer == null && _stepPayment == true && _webhookAttempt > 0)
                    ? l10n.webhookPolling(_webhookAttempt, _webhookMaxAttempts)
                    : (_stepServer == true
                        ? l10n.webhookReceived
                        : l10n.stepServerNotified),
                loading: _stepPayment == true && _stepServer == null,
              ),
              const SizedBox(height: 10),

              // Étape 3 : facture
              _VerifyStepRow(
                icon: _stepInvoice == null
                    ? Icons.radio_button_unchecked
                    : (_stepInvoice! ? Icons.check_circle_rounded : Icons.info_outline_rounded),
                color: _stepInvoice == null
                    ? AppTheme.muted
                    : (_stepInvoice! ? AppTheme.accent : AppTheme.muted),
                label: l10n.stepInvoiceSent,
                loading: _stepServer == true && _stepInvoice == null,
              ),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checking ? null : _confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: const Color(0xFF0A0A0F),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _checking
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 16, width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0A0A0F)),
                          ),
                          const SizedBox(width: 10),
                          Text(l10n.verifyingPayment,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        ],
                      )
                    : Text(l10n.iHavePaid,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: _checking ? null : _openStripe,
                child: Text(l10n.reopenPayment,
                    style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
              ),
            ),
          ],

          // Security note
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 13, color: AppTheme.muted),
              const SizedBox(width: 5),
              Text(l10n.securedByStripe,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Plan List ─────────────────────────────────────────────────────────────────
// Regroupe les plans par nom de base et affiche un sélecteur de durée dans
// chaque card (1 mois / 3 mois / 12 mois).

class _PlanList extends StatelessWidget {
  final List<Plan> plans;
  final int? processingPlanId;
  final AppCurrency currency;
  final String? currentPlan;
  final void Function(Plan) onSubscribe;
  const _PlanList({required this.plans, required this.processingPlanId, required this.currency, this.currentPlan, required this.onSubscribe});

  /// Retourne le nom de base d'un plan (sans suffixe de fréquence).
  String _baseName(Plan p) {
    // On normalise par le nom (les plans d'une même famille ont le même nom de base
    // e.g. "Starter", "Pro" — la fréquence est portée par billingFrequency).
    // Fallback : slugs peuvent être 'starter_monthly', 'starter_quarterly', etc.
    return p.name
        .replaceAll(RegExp(r'\s*(mensuel|monthly|trimestriel|quarterly|annuel|annual|yearly)\s*', caseSensitive: false), '')
        .trim();
  }

  /// Groupes ordonnés de plans (par première apparition du nom de base).
  List<List<Plan>> _groupedPlans() {
    final order = <String>[];
    final map = <String, List<Plan>>{};
    for (final p in plans) {
      final base = _baseName(p);
      if (!map.containsKey(base)) {
        order.add(base);
        map[base] = [];
      }
      map[base]!.add(p);
    }
    // Trier les plans de chaque groupe par fréquence (monthly → quarterly → yearly)
    const freqOrder = ['monthly', 'quarterly', 'semi_annual', 'yearly'];
    for (final g in map.values) {
      g.sort((a, b) => freqOrder.indexOf(a.billingFrequency)
          .compareTo(freqOrder.indexOf(b.billingFrequency)));
    }
    return order.map((k) => map[k]!).toList();
  }

  /// Bannière économies annuelles (monthly × 12 vs yearly total).
  String? _annualSavingsBanner(AppLocalizations l10n) {
    final monthlyPlans = plans.where((p) => p.billingFrequency == 'monthly').toList();
    final yearlyPlans  = plans.where((p) => p.billingFrequency == 'yearly').toList();
    if (monthlyPlans.isEmpty || yearlyPlans.isEmpty) return null;
    final monthly = monthlyPlans.first;
    final yearly  = yearlyPlans.first;
    final monthlyTotal = monthly.rawAmount(currency) * 12;
    final yearlyTotal  = yearly.rawAmount(currency);
    if (monthlyTotal <= 0 || yearlyTotal <= 0) return null;
    final saving = monthlyTotal - yearlyTotal;
    if (saving <= 0) return null;
    final savingStr = saving >= 10
        ? '${saving.round()}${currency.symbol}'
        : '${saving.toStringAsFixed(0)}${currency.symbol}';
    return l10n.annualSavingsBanner(savingStr);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (plans.isEmpty) {
      return Center(
          child: Text(l10n.noPlanAvailable, style: const TextStyle(color: AppTheme.muted)));
    }

    final groups = _groupedPlans();
    final savingsBanner = _annualSavingsBanner(l10n);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.goPremiumButton,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            l10n.premiumDesc,
            style: const TextStyle(color: AppTheme.muted, height: 1.5),
          ),
          const SizedBox(height: 20),

          // ── Bannière économies annuelles ──────────────────────────────────
          if (savingsBanner != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.greenAccent.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.savings_rounded, color: Colors.greenAccent, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      savingsBanner,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Cartes groupées (1 card par famille de plan) ──────────────────
          ...groups.map((group) => _PlanGroupCard(
            plans: group,
            processingPlanId: processingPlanId,
            currency: currency,
            currentPlan: currentPlan,
            onSubscribe: onSubscribe,
          )),

          const SizedBox(height: 16),

          // ── Footer garantie ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.greenAccent.withAlpha(50)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Colors.greenAccent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.guarantee30Days,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Security note ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline_rounded, color: AppTheme.muted, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.securityNote,
                    style: const TextStyle(color: AppTheme.muted, fontSize: 12, height: 1.5),
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

// ── Plan Group Card ───────────────────────────────────────────────────────────
// Affiche un groupe de plans (même nom, durées différentes) avec un sélecteur
// de durée (pills) et le prix / bouton d'abonnement correspondants.

class _PlanGroupCard extends StatefulWidget {
  final List<Plan> plans; // même famille, triés monthly→quarterly→yearly
  final int? processingPlanId;
  final AppCurrency currency;
  final String? currentPlan;
  final void Function(Plan) onSubscribe;

  const _PlanGroupCard({
    required this.plans,
    required this.processingPlanId,
    required this.currency,
    this.currentPlan,
    required this.onSubscribe,
  });

  @override
  State<_PlanGroupCard> createState() => _PlanGroupCardState();
}

class _PlanGroupCardState extends State<_PlanGroupCard> {
  late int _selectedIdx;

  @override
  void initState() {
    super.initState();
    // Sélectionner par défaut le plan annuel (dernier) pour pousser le meilleur prix
    _selectedIdx = widget.plans.length > 1 ? widget.plans.length - 1 : 0;
  }

  Plan get _selectedPlan => widget.plans[_selectedIdx];

  String _freqLabel(String freq, AppLocalizations l10n) {
    switch (freq) {
      case 'quarterly':   return l10n.billingQuarterly;
      case 'semi_annual': return l10n.billingSemiAnnual;
      case 'yearly':      return l10n.billingYearly;
      default:            return l10n.billingMonthly;
    }
  }

  int _monthsForFreq(String freq) {
    switch (freq) {
      case 'quarterly':   return 3;
      case 'semi_annual': return 6;
      case 'yearly':      return 12;
      default:            return 1;
    }
  }

  /// Calcule (% économisé, économie mensuelle) en comparant au plan mensuel du groupe.
  /// Retourne null si c'est le plan mensuel lui-même ou si pas de référence.
  ({int pct, double savingPerMonth})? _realSavings(Plan p) {
    if (p.billingFrequency == 'monthly') return null;
    final monthly = widget.plans
        .where((x) => x.billingFrequency == 'monthly')
        .firstOrNull;
    if (monthly == null) return null;
    final monthlyPrice = monthly.rawAmount(widget.currency);
    if (monthlyPrice <= 0) return null;
    final months = _monthsForFreq(p.billingFrequency);
    final monthlyEquiv = p.rawAmount(widget.currency) / months;
    final saving = monthlyPrice - monthlyEquiv;
    if (saving <= 0) return null;
    final pct = ((saving / monthlyPrice) * 100).round();
    return (pct: pct, savingPerMonth: saving);
  }

  String _formatAmount(double amount) {
    if (amount < 1.0) return '${(amount * 100).toStringAsFixed(0)} c${widget.currency.symbol}';
    return '${amount.toStringAsFixed(2)} ${widget.currency.symbol}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final plan = _selectedPlan;
    final isCurrentPlan = widget.currentPlan != null &&
        plan.slug.toLowerCase() == widget.currentPlan!.toLowerCase();
    final isRecommended = plan.badge == 'recommended' && !isCurrentPlan;
    final isPopular     = plan.badge == 'popular'     && !isCurrentPlan;
    final isProcessing  = widget.processingPlanId == plan.id;
    final anyProcessing = widget.processingPlanId != null;

    return Opacity(
      opacity: isCurrentPlan ? 0.65 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isCurrentPlan ? AppTheme.surface2 : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentPlan
                ? AppTheme.border
                : isRecommended
                    ? AppTheme.accent.withAlpha(160)
                    : AppTheme.border,
            width: isRecommended ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Bannière top ──────────────────────────────────────────────────
            if (isCurrentPlan)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E2A1E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 13, color: AppTheme.accent),
                    const SizedBox(width: 6),
                    Text(l10n.yourCurrentPlan,
                        style: const TextStyle(
                            color: AppTheme.accent, fontSize: 11,
                            fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                  ],
                ),
              )
            else if (isRecommended || isPopular)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: isRecommended
                      ? AppTheme.accent.withAlpha(25)
                      : Colors.blue.withAlpha(25),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isRecommended
                          ? Icons.star_rounded
                          : Icons.local_fire_department_rounded,
                      size: 13,
                      color: isRecommended ? AppTheme.accent : Colors.blueAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isRecommended
                          ? l10n.recommended.toUpperCase()
                          : l10n.popular.toUpperCase(),
                      style: TextStyle(
                          color: isRecommended
                              ? AppTheme.accent
                              : Colors.blueAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
            if ((plan.savingsPercent ?? 0) > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: !(isRecommended || isPopular || isCurrentPlan)
                      ? const BorderRadius.vertical(top: Radius.circular(15))
                      : BorderRadius.zero,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.savings_rounded, size: 13, color: Colors.greenAccent),
                    const SizedBox(width: 6),
                    Text(l10n.savePercent(plan.savingsPercent ?? 0),
                        style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2)),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Nom du plan ────────────────────────────────────────────
                  Text(
                    // Nom de base sans fréquence
                    widget.plans.first.name
                        .replaceAll(RegExp(r'\s*(mensuel|monthly|trimestriel|quarterly|annuel|annual|yearly)\s*', caseSensitive: false), '')
                        .trim(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),

                  // ── Sélecteur de durée (pills) ─────────────────────────────
                  if (widget.plans.length > 1) ...[
                    // Calcul de la meilleure offre (pct max parmi les plans non-mensuel)
                    Builder(builder: (ctx) {
                      // Index de la meilleure offre
                      int bestIdx = -1;
                      int bestPct = 0;
                      for (int i = 0; i < widget.plans.length; i++) {
                        final s = _realSavings(widget.plans[i]);
                        if (s != null && s.pct > bestPct) {
                          bestPct = s.pct;
                          bestIdx = i;
                        }
                      }

                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(widget.plans.length, (i) {
                              final p      = widget.plans[i];
                              final sel    = i == _selectedIdx;
                              final isBest = i == bestIdx;
                              final savings = _realSavings(p);

                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedIdx = i),
                                  child: Column(
                                    children: [
                                      // Badge "Meilleure offre" au-dessus de la pill
                                      if (isBest)
                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 4),
                                          padding: const EdgeInsets.symmetric(vertical: 3),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                                            ),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            l10n.bestOffer,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        )
                                      else
                                        const SizedBox(height: 23), // alignement vertical

                                      // Pill principale
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        margin: EdgeInsets.only(
                                            right: i < widget.plans.length - 1 ? 6 : 0),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 4),
                                        decoration: BoxDecoration(
                                          color: sel
                                              ? AppTheme.accent.withAlpha(30)
                                              : isBest
                                                  ? const Color(0xFF2A2000)
                                                  : AppTheme.surface2,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: sel
                                                ? AppTheme.accent.withAlpha(180)
                                                : isBest
                                                    ? const Color(0xFFFFD700).withAlpha(120)
                                                    : AppTheme.border,
                                            width: sel || isBest ? 1.5 : 1,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            // Fréquence
                                            Text(
                                              _freqLabel(p.billingFrequency, l10n),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: sel
                                                    ? AppTheme.accent
                                                    : isBest
                                                        ? const Color(0xFFFFD700)
                                                        : AppTheme.muted,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            // Prix total
                                            Text(
                                              p.displayPrice(widget.currency),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: sel ? Colors.white : AppTheme.muted,
                                              ),
                                            ),
                                            if (savings != null) ...[
                                              const SizedBox(height: 4),
                                              // Badge % économie
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withAlpha(45),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  '-${savings.pct}%',
                                                  style: const TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              // Économie mensuelle
                                              Text(
                                                l10n.savingPerMonth(
                                                    _formatAmount(savings.savingPerMonth)),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.greenAccent.withAlpha(180),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      );
                    }),
                  ],

                  const SizedBox(height: 14),

                  // ── Prix principal ─────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        plan.displayPrice(widget.currency),
                        style: const TextStyle(
                            color: AppTheme.accent,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            height: 1),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          '/ ${plan.frequencyLabel.toLowerCase()}',
                          style: const TextStyle(color: AppTheme.muted, fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  // ── Coût journalier ────────────────────────────────────────
                  Builder(builder: (ctx) {
                    final l = AppLocalizations.of(ctx);
                    final daily = plan.dailyCost(widget.currency);
                    if (daily <= 0) return const SizedBox.shrink();
                    final dailyStr = daily < 1.0
                        ? '${(daily * 100).toStringAsFixed(0)} c${widget.currency.symbol}'
                        : '${daily.toStringAsFixed(2)} ${widget.currency.symbol}';
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.perDay(dailyStr),
                              style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                          if (widget.currency.rateFromUsd > 0 &&
                              (daily / widget.currency.rateFromUsd) < 0.50)
                            Text(l.lessThanCoffee,
                                style: const TextStyle(
                                    color: AppTheme.accent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  }),

                  if (plan.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(plan.description,
                        style: const TextStyle(
                            color: AppTheme.muted, fontSize: 13, height: 1.4)),
                  ],
                  if (plan.features.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    ...plan.features.map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: AppTheme.accent, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(f,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13))),
                            ],
                          ),
                        )),
                  ],
                  const SizedBox(height: 18),

                  // ── Bouton d'abonnement ────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: isCurrentPlan
                        ? OutlinedButton.icon(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppTheme.border),
                              disabledForegroundColor: AppTheme.muted,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: Text(l10n.currentPlanLabel,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15)),
                          )
                        : ElevatedButton(
                            onPressed: anyProcessing
                                ? null
                                : () => widget.onSubscribe(plan),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: plan.stripeAvailable
                                  ? AppTheme.accent
                                  : AppTheme.border,
                              foregroundColor: const Color(0xFF0A0A0F),
                              disabledBackgroundColor: AppTheme.border,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: isProcessing
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF0A0A0F)))
                                : Text(
                                    plan.stripeAvailable
                                        ? l10n.subscribePlan(plan.displayPrice(widget.currency))
                                        : l10n.comingSoon,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800, fontSize: 15)),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Verify Step Row ───────────────────────────────────────────────────────────

class _VerifyStepRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool loading;

  const _VerifyStepRow({
    required this.icon,
    required this.color,
    required this.label,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        loading
            ? const SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accent),
              )
            : Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

// ── Error View ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppTheme.muted, size: 48),
            const SizedBox(height: 16),
            Text(l10n.cannotLoadPlans,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(error,
                style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
