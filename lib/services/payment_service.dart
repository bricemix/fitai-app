import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'currency_service.dart';

class Plan {
  final int id;
  final String slug;
  final String name;
  final String description;
  final int priceAriary;
  final int priceUsdCents;
  final String billingFrequency;
  final String frequencyLabel;
  final List<String> features;
  final String? badge;
  final String? stripePriceId;
  /// Prix natifs par code devise : { "USD": 499, "EUR": 459, "XOF": 3025, … }
  /// Convention identique au formulaire admin :
  ///   - Petites devises (USD/EUR…) → centimes
  ///   - Grandes devises (XOF/NGN…) → unités entières
  final Map<String, int> prices;

  const Plan({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.priceAriary,
    required this.priceUsdCents,
    required this.billingFrequency,
    required this.frequencyLabel,
    required this.features,
    this.badge,
    this.stripePriceId,
    this.prices = const {},
  });

  factory Plan.fromJson(Map<String, dynamic> j) {
    var prices = _parsePrices(j['prices']);
    final usdCents = j['price_usd_cents'] as int? ?? 0;

    // Fallback : si prices['EUR'] absent mais l'API retourne un price_eur_cents
    // différent de price_usd_cents → c'est un vrai prix EUR (pas juste le fallback USD).
    if (!prices.containsKey('EUR')) {
      final eurCents = j['price_eur_cents'] as int? ?? 0;
      if (eurCents > 0 && eurCents != usdCents) {
        prices = {...prices, 'EUR': eurCents};
      }
    }

    // Fallback : si prices['USD'] absent, utiliser price_usd_cents (champ legacy).
    if (!prices.containsKey('USD') && usdCents > 0) {
      prices = {...prices, 'USD': usdCents};
    }

    return Plan(
      id:               j['id'] as int,
      slug:             j['slug'] as String,
      name:             j['name'] as String,
      description:      j['description'] as String? ?? '',
      priceAriary:      j['price_ariary'] as int? ?? 0,
      priceUsdCents:    usdCents,
      billingFrequency: j['billing_frequency'] as String? ?? 'monthly',
      frequencyLabel:   j['frequency_label'] as String? ?? '',
      features:         List<String>.from(j['features'] as List? ?? []),
      badge:            j['badge'] as String?,
      stripePriceId:    j['stripe_price_id'] as String?,
      prices:           prices,
    );
  }

  static Map<String, int> _parsePrices(dynamic raw) {
    if (raw is! Map) return const {};
    return Map<String, int>.fromEntries(
      raw.entries
          .where((e) => (e.value as num? ?? 0) > 0)
          .map((e) => MapEntry(e.key as String, (e.value as num).toInt())),
    );
  }

  // ── Helpers prix ─────────────────────────────────────────────────────────

  /// True si le plan est configurable pour le paiement Stripe.
  /// On vérifie seulement le Stripe Price ID — le prix peut être en EUR, USD ou autre.
  bool get stripeAvailable => stripePriceId?.isNotEmpty ?? false;

  /// Retourne le prix formaté dans la devise choisie par l'utilisateur.
  ///   1. Prix natif exact pour cette devise (défini sur le serveur).
  ///   2. Prix EUR → converti dans la devise cible.
  ///   3. Prix USD cents → converti (ancien système, fallback).
  ///   4. "Gratuit" si aucun prix n'est défini.
  String displayPrice(AppCurrency currency) {
    // 1. Prix natif pour la devise du user
    final native = prices[currency.code] ?? 0;
    if (native > 0) return CurrencyService.formatNative(native, currency);

    // 2. Prix EUR → conversion vers la devise du user
    final eurCents = prices['EUR'] ?? 0;
    if (eurCents > 0) return CurrencyService.formatEurCents(eurCents, currency);

    // 3. Fallback : price_usd_cents (ancien champ)
    if (priceUsdCents > 0) return CurrencyService.format(priceUsdCents, currency);

    return 'Gratuit';
  }

  String get priceUsdFormatted {
    if (priceUsdCents == 0) return '';
    return '\$${(priceUsdCents / 100.0).toStringAsFixed(2)}';
  }

  /// Économies en % vs le tarif mensuel équivalent.
  /// Retourne null si pas applicable (plan mensuel ou pas de prix EUR).
  int? get savingsPercent {
    final eurCents = prices['EUR'] ?? priceUsdCents;
    if (eurCents <= 0) return null;
    int? monthlyEquiv;
    int months;
    switch (billingFrequency) {
      case 'quarterly':   months = 3;  monthlyEquiv = (eurCents / 3).round();  break;
      case 'semi_annual': months = 6;  monthlyEquiv = (eurCents / 6).round();  break;
      case 'yearly':      months = 12; monthlyEquiv = (eurCents / 12).round(); break;
      default: return null;
    }
    final fullPrice = monthlyEquiv * months;
    if (fullPrice <= 0 || eurCents >= fullPrice) return null;
    return (((fullPrice - eurCents) / fullPrice) * 100).round();
  }

  /// Label de fréquence avec économie : "Annuel · -37%"
  String get frequencyLabelWithSavings {
    final s = savingsPercent;
    if (s != null && s > 0) return '$frequencyLabel · -$s%';
    return frequencyLabel;
  }

  /// Retourne le montant brut (double) dans la devise pour calculer le coût journalier.
  double rawAmount(AppCurrency currency) {
    final native = prices[currency.code] ?? 0;
    if (native > 0) {
      return currency.rateFromUsd < 5.0 ? native / 100.0 : native.toDouble();
    }
    final eurCents = prices['EUR'] ?? 0;
    if (eurCents > 0) {
      const eurRate = 0.92;
      final usd = (eurCents / 100.0) / eurRate;
      return usd * currency.rateFromUsd;
    }
    if (priceUsdCents > 0) return (priceUsdCents / 100.0) * currency.rateFromUsd;
    return 0;
  }

  int get daysInPeriod {
    switch (billingFrequency) {
      case 'quarterly':   return 90;
      case 'semi_annual': return 180;
      case 'yearly':      return 365;
      default:            return 30;
    }
  }

  double dailyCost(AppCurrency currency) {
    final total = rawAmount(currency);
    if (total <= 0) return 0;
    return total / daysInPeriod;
  }

  String get priceAriaryFormatted {
    final s = priceAriary.toString();
    final parts = <String>[];
    for (var i = s.length; i > 0; i -= 3) {
      parts.insert(0, s.substring(i < 3 ? 0 : i - 3, i));
    }
    return '${parts.join(' ')} Ar';
  }
}

class SubscribeResult {
  final String checkoutUrl;
  final String sessionId;
  SubscribeResult({required this.checkoutUrl, required this.sessionId});
}

/// Résultat de la vérification POST /payments/verify
class VerifyResult {
  final bool paid;
  final String plan;            // plan actuel après vérification
  final bool webhookReceived;   // true si le webhook a mis à jour le plan
  final bool invoiceSent;       // true si la facture Stripe a été envoyée
  final bool emailSent;         // true si l'email de bienvenue a été envoyé

  const VerifyResult({
    required this.paid,
    required this.plan,
    required this.webhookReceived,
    required this.invoiceSent,
    required this.emailSent,
  });

  bool get subscriptionActive => paid && plan != 'free';

  factory VerifyResult.fromJson(Map<String, dynamic> j) => VerifyResult(
        paid:            j['paid'] as bool? ?? false,
        plan:            SubscriptionStatus.normalizePlan(j['plan'] as String? ?? 'free'),
        webhookReceived: j['webhook_received'] as bool? ?? false,
        invoiceSent:     j['invoice_sent'] as bool? ?? false,
        emailSent:       j['email_sent'] as bool? ?? false,
      );
}

// ── Statut d'abonnement ───────────────────────────────────────────────────────

class SubscriptionStatus {
  final String plan;              // 'free' | 'starter' | 'pro' | 'premium'
  final bool isActive;            // abonnement actuellement actif côté serveur
  final DateTime? trialEndsAt;    // date fin du trial (null = pas de trial)
  final DateTime? subscriptionEndsAt; // date fin d'abo payant

  const SubscriptionStatus({
    required this.plan,
    required this.isActive,
    this.trialEndsAt,
    this.subscriptionEndsAt,
  });

  /// Normalise un slug de plan en niveau de plan standard.
  /// "starter_12m" → "starter", "premium-annual" → "premium", etc.
  static String normalizePlan(String raw) {
    final p = raw.toLowerCase().trim();
    if (p.isEmpty || p == 'free') return 'free';
    if (p.contains('premium')) return 'premium';
    if (p.startsWith('pro'))    return 'pro';
    if (p.startsWith('starter')) return 'starter';
    return p;
  }

  /// Parse intelligemment les champs retournés par /auth/me.
  /// Compatible avec plusieurs conventions de nommage backend.
  factory SubscriptionStatus.fromJson(Map<String, dynamic> data) {
    final raw  = data['plan'] as String? ?? 'free';
    final plan = normalizePlan(raw);

    // ── is_active : plusieurs noms possibles ──────────────────────────────
    bool isActive = plan != 'free'; // par défaut : plan payant = actif
    for (final key in ['is_active', 'subscription_active', 'active', 'is_subscribed']) {
      if (data.containsKey(key) && data[key] is bool) {
        isActive = data[key] as bool;
        break;
      }
    }

    // ── trial_ends_at : plusieurs noms possibles ──────────────────────────
    DateTime? trialEndsAt;
    for (final key in ['trial_ends_at', 'trial_end', 'trial_expiry', 'trial_expires_at', 'trial_end_date']) {
      final val = data[key];
      if (val != null) {
        try { trialEndsAt = DateTime.parse(val.toString()).toLocal(); } catch (_) {}
        break;
      }
    }

    // ── subscription_ends_at : plusieurs noms possibles ───────────────────
    DateTime? subscriptionEndsAt;
    for (final key in ['subscription_ends_at', 'subscription_end', 'expires_at', 'current_period_end', 'subscription_expiry']) {
      final val = data[key];
      if (val != null) {
        try { subscriptionEndsAt = DateTime.parse(val.toString()).toLocal(); } catch (_) {}
        break;
      }
    }

    return SubscriptionStatus(
      plan: plan,
      isActive: isActive,
      trialEndsAt: trialEndsAt,
      subscriptionEndsAt: subscriptionEndsAt,
    );
  }

  /// Le trial est expiré (date connue ET passée).
  bool get trialExpired =>
      trialEndsAt != null && DateTime.now().isAfter(trialEndsAt!);

  /// L'abonnement payant est expiré.
  bool get subscriptionExpired =>
      subscriptionEndsAt != null && DateTime.now().isAfter(subscriptionEndsAt!);

  /// Jours restants avant expiration du trial (null si pas de trial).
  int? get trialDaysRemaining {
    if (trialEndsAt == null) return null;
    final diff = trialEndsAt!.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  /// True → l'utilisateur doit souscrire pour accéder à l'app.
  ///
  /// Règles :
  ///  • Plan payant actif (starter/pro/premium + isActive) → accès autorisé.
  ///  • Pro/Premium inactif → paiement direct requis (pas de période d'essai).
  ///  • Starter inactif avec subscriptionEndsAt connu → abonnement expiré → paiement.
  ///  • Free/Starter en trial : bloquer seulement si le trial est explicitement expiré.
  ///  • Pas d'info trial → ne pas bloquer (conservateur).
  bool get needsPayment {
    // Plan payant et actif (trial Starter compte comme actif) → accès autorisé
    if (plan != 'free' && isActive) return false;
    // Pro/Premium sans abonnement actif → paiement direct requis (pas de trial)
    if ((plan == 'pro' || plan == 'premium') && !isActive) return true;
    // Starter dont l'abonnement est connu et expiré → paiement requis
    if (plan == 'starter' && !isActive && subscriptionEndsAt != null) return true;
    // Free/Starter en trial expiré → paiement requis
    if (trialExpired) return true;
    // Pas d'info → ne pas bloquer
    return false;
  }

  bool get isPaidPlan => plan != 'free';

  @override
  String toString() =>
      'SubscriptionStatus(plan=$plan, active=$isActive, trialEndsAt=$trialEndsAt, needsPayment=$needsPayment)';
}

class PaymentService {
  static const _base = 'https://api.diet-vision.com/api/v1';

  // ── Fetch plans ──────────────────────────────────────────────────────────────

  static Future<List<Plan>> fetchPlans() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/plans'))
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) throw Exception('Failed to load plans');
      final List data = jsonDecode(res.body) as List;
      return data.map((j) => Plan.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Unable to reach the server');
    }
  }

  // ── Créer session Stripe Checkout ────────────────────────────────────────────

  /// Retourne l'URL Stripe Checkout à ouvrir dans le navigateur.
  static Future<SubscribeResult> createCheckout(Plan plan) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Non authentifié');

    final res = await http.post(
      Uri.parse('$_base/payments/subscribe'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'plan_id': plan.id}),
    );

    if (res.statusCode == 401) {
      await AuthService.handleUnauthorized(res);
      throw Exception('Session expirée — veuillez vous reconnecter.');
    }
    if (res.statusCode != 201) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      throw Exception(body['error'] ?? 'Erreur serveur (${res.statusCode})');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return SubscribeResult(
      checkoutUrl: data['checkout_url'] as String,
      sessionId:   data['session_id']   as String,
    );
  }

  // ── Vérifier l'abonnement actuel ─────────────────────────────────────────────

  static Future<String?> fetchCurrentPlan() async {
    final status = await fetchSubscriptionStatus();
    return status?.plan;
  }

  /// Récupère le statut complet de l'abonnement depuis /auth/me.
  /// Met aussi à jour le cache utilisateur local avec les données fraîches.
  static Future<SubscriptionStatus?> fetchSubscriptionStatus() async {
    final token = await AuthService.getToken();
    if (token == null) return null;
    try {
      final res = await http
          .get(
            Uri.parse('$_base/auth/me'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      // Mettre à jour le cache local avec les données fraîches
      await AuthService.cacheUser(data);
      return SubscriptionStatus.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  // ── Polling webhook Stripe ────────────────────────────────────────────────────
  //
  // Appelle GET /payments/webhook-status?session_id=xxx
  //
  // Réponse attendue :
  // { "received": true, "processed": true, "plan": "starter", "received_at": "2024-..." }
  //
  // Retourne true dès que le serveur confirme avoir reçu et traité le webhook.
  // Lance jusqu'à [maxAttempts] requêtes avec [interval] entre chaque.
  // Le callback [onAttempt] est appelé à chaque tentative (pour mettre à jour l'UI).
  static Future<bool> checkWebhookReceived(
    String sessionId, {
    int maxAttempts = 5,
    Duration interval = const Duration(seconds: 3),
    void Function(int attempt, int max)? onAttempt,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    for (var i = 0; i < maxAttempts; i++) {
      if (i > 0) await Future.delayed(interval);
      onAttempt?.call(i + 1, maxAttempts);

      try {
        final res = await http
            .get(
              Uri.parse('$_base/payments/webhook-status?session_id=${Uri.encodeComponent(sessionId)}'),
              headers: {'Authorization': 'Bearer $token'},
            )
            .timeout(const Duration(seconds: 10));

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          final received  = data['received']  as bool? ?? false;
          final processed = data['processed'] as bool? ?? false;
          if (received && processed) return true;
        }
      } catch (_) {
        // Réseau instable → on continue les tentatives
      }
    }
    return false;
  }

  // ── Vérification checkout Stripe ─────────────────────────────────────────────
  //
  // Appelle POST /payments/verify { session_id }
  // Le backend vérifie :
  //   1. Que la session Stripe est bien payée (stripe.checkout.sessions.retrieve)
  //   2. Que le webhook a mis à jour le plan (sinon le fait manuellement = fallback)
  //   3. Envoie la facture si pas encore envoyée
  //   4. Envoie l'email de bienvenue si pas encore envoyé
  //
  // Réponse attendue :
  // {
  //   "paid": true,
  //   "plan": "starter",          // plan mis à jour
  //   "webhook_received": true,   // webhook traité avant ou pendant cet appel
  //   "invoice_sent": true,       // facture Stripe envoyée par email
  //   "email_sent": true          // email de bienvenue envoyé
  // }
  //
  // Retourne null en cas d'erreur réseau.
  static Future<VerifyResult?> verifyCheckout(String sessionId) async {
    final token = await AuthService.getToken();
    if (token == null) return null;
    try {
      final res = await http
          .post(
            Uri.parse('$_base/payments/verify'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'session_id': sessionId}),
          )
          .timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      // Mettre à jour le cache local avec les données fraîches si le serveur les retourne
      if (data['user'] is Map) {
        await AuthService.cacheUser(data['user'] as Map<String, dynamic>);
      }
      return VerifyResult.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  // ── Historique ───────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> fetchHistory() async {
    final token = await AuthService.getToken();
    if (token == null) return [];
    try {
      final res = await http
          .get(
            Uri.parse('$_base/payments'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) return [];
      return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
    } catch (_) {
      return [];
    }
  }
}
