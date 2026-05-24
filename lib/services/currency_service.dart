import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCurrency {
  final String code;
  final String symbol;
  final String flag;
  final String name;
  /// Taux de conversion depuis USD (1 USD = rate unités de cette devise)
  final double rateFromUsd;

  const AppCurrency({
    required this.code,
    required this.symbol,
    required this.flag,
    required this.name,
    required this.rateFromUsd,
  });
}

class CurrencyService {
  static const _key = 'fitai_currency';

  static const currencies = [
    // ── Afrique (en tête) ─────────────────────────────────────────────────────
    AppCurrency(code: 'XOF', symbol: 'F CFA', flag: '🌍', name: 'Franc CFA (UEMOA)',     rateFromUsd: 603.0),
    AppCurrency(code: 'XAF', symbol: 'F CFA', flag: '🌍', name: 'Franc CFA (CEMAC)',     rateFromUsd: 603.0),
    AppCurrency(code: 'MGA', symbol: 'Ar',    flag: '🇲🇬', name: 'Ariary malgache',       rateFromUsd: 4550.0),
    AppCurrency(code: 'NGN', symbol: '₦',     flag: '🇳🇬', name: 'Naira nigérian',        rateFromUsd: 1550.0),
    AppCurrency(code: 'GHS', symbol: '₵',     flag: '🇬🇭', name: 'Cedi ghanéen',          rateFromUsd: 15.3),
    AppCurrency(code: 'KES', symbol: 'KSh',   flag: '🇰🇪', name: 'Shilling kenyan',       rateFromUsd: 129.0),
    AppCurrency(code: 'ZAR', symbol: 'R',     flag: '🇿🇦', name: 'Rand sud-africain',     rateFromUsd: 18.5),
    AppCurrency(code: 'TZS', symbol: 'TSh',   flag: '🇹🇿', name: 'Shilling tanzanien',    rateFromUsd: 2600.0),
    AppCurrency(code: 'UGX', symbol: 'USh',   flag: '🇺🇬', name: 'Shilling ougandais',    rateFromUsd: 3750.0),
    AppCurrency(code: 'RWF', symbol: 'RF',    flag: '🇷🇼', name: 'Franc rwandais',        rateFromUsd: 1300.0),
    AppCurrency(code: 'ETB', symbol: 'Br',    flag: '🇪🇹', name: 'Birr éthiopien',        rateFromUsd: 56.0),
    AppCurrency(code: 'EGP', symbol: 'E£',    flag: '🇪🇬', name: 'Livre égyptienne',      rateFromUsd: 48.0),
    AppCurrency(code: 'MAD', symbol: 'DH',    flag: '🇲🇦', name: 'Dirham marocain',       rateFromUsd: 9.95),
    AppCurrency(code: 'DZD', symbol: 'DA',    flag: '🇩🇿', name: 'Dinar algérien',        rateFromUsd: 134.0),
    AppCurrency(code: 'TND', symbol: 'DT',    flag: '🇹🇳', name: 'Dinar tunisien',        rateFromUsd: 3.1),
    AppCurrency(code: 'GNF', symbol: 'FG',    flag: '🇬🇳', name: 'Franc guinéen',         rateFromUsd: 8620.0),
    // ── Europe ────────────────────────────────────────────────────────────────
    AppCurrency(code: 'EUR', symbol: '€',     flag: '🇪🇺', name: 'Euro',                  rateFromUsd: 0.92),
    AppCurrency(code: 'GBP', symbol: '£',     flag: '🇬🇧', name: 'Livre sterling',        rateFromUsd: 0.79),
    AppCurrency(code: 'CHF', symbol: 'CHF',   flag: '🇨🇭', name: 'Franc suisse',          rateFromUsd: 0.90),
    AppCurrency(code: 'SEK', symbol: 'kr',    flag: '🇸🇪', name: 'Couronne suédoise',     rateFromUsd: 10.5),
    AppCurrency(code: 'NOK', symbol: 'kr',    flag: '🇳🇴', name: 'Couronne norvégienne',  rateFromUsd: 10.7),
    AppCurrency(code: 'DKK', symbol: 'kr',    flag: '🇩🇰', name: 'Couronne danoise',      rateFromUsd: 6.9),
    AppCurrency(code: 'PLN', symbol: 'zł',    flag: '🇵🇱', name: 'Zloty polonais',        rateFromUsd: 4.0),
    AppCurrency(code: 'TRY', symbol: '₺',     flag: '🇹🇷', name: 'Livre turque',          rateFromUsd: 32.0),
    AppCurrency(code: 'RUB', symbol: '₽',     flag: '🇷🇺', name: 'Rouble russe',          rateFromUsd: 91.0),
    // ── Amériques ─────────────────────────────────────────────────────────────
    AppCurrency(code: 'USD', symbol: '\$',    flag: '🇺🇸', name: 'Dollar US',             rateFromUsd: 1.0),
    AppCurrency(code: 'CAD', symbol: 'CA\$',  flag: '🇨🇦', name: 'Dollar canadien',       rateFromUsd: 1.36),
    AppCurrency(code: 'MXN', symbol: 'MX\$',  flag: '🇲🇽', name: 'Peso mexicain',         rateFromUsd: 17.0),
    AppCurrency(code: 'BRL', symbol: 'R\$',   flag: '🇧🇷', name: 'Real brésilien',        rateFromUsd: 5.05),
    AppCurrency(code: 'ARS', symbol: '\$',    flag: '🇦🇷', name: 'Peso argentin',         rateFromUsd: 900.0),
    AppCurrency(code: 'COP', symbol: 'COP\$', flag: '🇨🇴', name: 'Peso colombien',        rateFromUsd: 4000.0),
    AppCurrency(code: 'CLP', symbol: 'CLP\$', flag: '🇨🇱', name: 'Peso chilien',          rateFromUsd: 935.0),
    // ── Asie & Moyen-Orient ───────────────────────────────────────────────────
    AppCurrency(code: 'JPY', symbol: '¥',     flag: '🇯🇵', name: 'Yen japonais',          rateFromUsd: 150.0),
    AppCurrency(code: 'CNY', symbol: '¥',     flag: '🇨🇳', name: 'Yuan chinois',          rateFromUsd: 7.25),
    AppCurrency(code: 'KRW', symbol: '₩',     flag: '🇰🇷', name: 'Won sud-coréen',        rateFromUsd: 1350.0),
    AppCurrency(code: 'INR', symbol: '₹',     flag: '🇮🇳', name: 'Roupie indienne',       rateFromUsd: 83.5),
    AppCurrency(code: 'IDR', symbol: 'Rp',    flag: '🇮🇩', name: 'Roupiah indonésienne',  rateFromUsd: 16000.0),
    AppCurrency(code: 'THB', symbol: '฿',     flag: '🇹🇭', name: 'Baht thaïlandais',      rateFromUsd: 36.0),
    AppCurrency(code: 'SGD', symbol: 'S\$',   flag: '🇸🇬', name: 'Dollar singapourien',   rateFromUsd: 1.35),
    AppCurrency(code: 'HKD', symbol: 'HK\$',  flag: '🇭🇰', name: 'Dollar de Hong Kong',   rateFromUsd: 7.82),
    AppCurrency(code: 'AED', symbol: 'د.إ',   flag: '🇦🇪', name: 'Dirham émirati',        rateFromUsd: 3.67),
    AppCurrency(code: 'SAR', symbol: 'ر.س',   flag: '🇸🇦', name: 'Riyal saoudien',        rateFromUsd: 3.75),
    AppCurrency(code: 'QAR', symbol: 'ر.ق',   flag: '🇶🇦', name: 'Riyal qatari',          rateFromUsd: 3.64),
    AppCurrency(code: 'PKR', symbol: '₨',     flag: '🇵🇰', name: 'Roupie pakistanaise',   rateFromUsd: 278.0),
    AppCurrency(code: 'BDT', symbol: '৳',     flag: '🇧🇩', name: 'Taka bangladais',       rateFromUsd: 110.0),
    // ── Océanie ───────────────────────────────────────────────────────────────
    AppCurrency(code: 'AUD', symbol: 'A\$',   flag: '🇦🇺', name: 'Dollar australien',     rateFromUsd: 1.55),
    AppCurrency(code: 'NZD', symbol: 'NZ\$',  flag: '🇳🇿', name: 'Dollar néo-zélandais',  rateFromUsd: 1.65),
  ];

  /// Devise par défaut détectée depuis le pays de l'appareil.
  /// Retourne XOF pour l'Afrique francophone, la devise locale sinon.
  static AppCurrency detectFromLocale() {
    final country = WidgetsBinding.instance.platformDispatcher
        .locale.countryCode?.toUpperCase() ?? '';
    const xofCountries = {'CI','SN','ML','BF','TG','BJ','GN','NE','GW','CV','KM','ST'};
    const xafCountries = {'CM','CF','TD','CG','GQ','GA'};
    const eurCountries = {'FR','DE','ES','IT','PT','NL','BE','AT','FI','IE','LU','SK','SI','EE','LV','LT','MT','CY','GR'};
    const _countryToCurrency = {
      'MG': 'MGA', 'NG': 'NGN', 'GH': 'GHS', 'KE': 'KES', 'ZA': 'ZAR',
      'TZ': 'TZS', 'UG': 'UGX', 'RW': 'RWF', 'ET': 'ETB', 'EG': 'EGP',
      'MA': 'MAD', 'DZ': 'DZD', 'TN': 'TND', 'GN': 'GNF',
      'GB': 'GBP', 'CH': 'CHF', 'SE': 'SEK', 'NO': 'NOK', 'DK': 'DKK',
      'PL': 'PLN', 'TR': 'TRY', 'RU': 'RUB',
      'US': 'USD', 'CA': 'CAD', 'MX': 'MXN', 'BR': 'BRL',
      'AU': 'AUD', 'NZ': 'NZD', 'SG': 'SGD', 'JP': 'JPY', 'CN': 'CNY',
      'KR': 'KRW', 'IN': 'INR', 'ID': 'IDR', 'TH': 'THB',
      'AE': 'AED', 'SA': 'SAR', 'QA': 'QAR', 'PK': 'PKR', 'BD': 'BDT',
    };

    String code;
    if (xofCountries.contains(country)) {
      code = 'XOF';
    } else if (xafCountries.contains(country)) {
      code = 'XAF';
    } else if (eurCountries.contains(country)) {
      code = 'EUR';
    } else {
      code = _countryToCurrency[country] ?? 'XOF'; // XOF par défaut
    }
    return currencies.firstWhere((c) => c.code == code,
        orElse: () => currencies.first);
  }

  static AppCurrency get defaultCurrency => detectFromLocale();

  // ── Persistance ────────────────────────────────────────────────────────────

  static Future<AppCurrency> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null) return detectFromLocale();
    return currencies.firstWhere((c) => c.code == code,
        orElse: () => detectFromLocale());
  }

  static Future<void> save(AppCurrency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, currency.code);
  }

  // ── Conversion ─────────────────────────────────────────────────────────────

  /// Convertit un montant en cents USD → montant dans la devise cible.
  static double fromUsdCents(int usdCents, AppCurrency currency) {
    final usd = usdCents / 100.0;
    return usd * currency.rateFromUsd;
  }

  /// Formate un montant en **cents EUR** dans la devise cible.
  /// Utilisé quand le dashboard a un prix EUR mais pas de prix natif pour la devise du user.
  /// Conversion : EUR cents → USD cents (via rateFromUsd de l'EUR) → devise cible.
  static String formatEurCents(int eurCents, AppCurrency currency) {
    if (eurCents <= 0) return 'Gratuit';
    // Si la devise cible est EUR, afficher directement
    if (currency.code == 'EUR') return formatNative(eurCents, currency);
    // Récupérer le taux EUR depuis la liste (0.92 par défaut)
    final eurCurrency = currencies.firstWhere(
      (c) => c.code == 'EUR',
      orElse: () => const AppCurrency(code: 'EUR', symbol: '€', flag: '🇪🇺', name: 'Euro', rateFromUsd: 0.92),
    );
    // EUR → USD → devise cible
    final usdCents = (eurCents / eurCurrency.rateFromUsd).round();
    return format(usdCents, currency);
  }

  /// Formate un montant en cents USD dans la devise choisie.
  static String format(int usdCents, AppCurrency currency) {
    if (usdCents <= 0) return 'Gratuit';
    final amount = fromUsdCents(usdCents, currency);

    // Devises à faible taux (< 5) : afficher avec décimales
    // Devises à fort taux (≥ 5)   : arrondir + grouper les milliers
    if (currency.rateFromUsd < 5.0) {
      final formatted = amount.toStringAsFixed(2);
      return _place(formatted, currency);
    } else {
      final rounded = amount.round();
      // Groupement des milliers par espace fine
      final s = rounded.toString();
      final buf = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
        buf.write(s[i]);
      }
      return _place(buf.toString(), currency);
    }
  }

  /// Formate un prix natif **déjà dans la devise cible** (tel que défini sur le serveur).
  ///
  /// Convention (identique au formulaire admin) :
  ///   • Devises "petites" (rateFromUsd < 5 : USD, EUR, GBP, CHF, CAD…)
  ///     → valeur en centimes   — ex : 499  ➜  "$4.99"
  ///   • Devises "grandes"  (rateFromUsd ≥ 5 : XOF, NGN, MGA, KES…)
  ///     → valeur en unités entières — ex : 3025 ➜  "3 025 F CFA"
  ///
  /// Si [nativeAmount] ≤ 0, retourne 'Gratuit'.
  static String formatNative(int nativeAmount, AppCurrency currency) {
    if (nativeAmount <= 0) return 'Gratuit';
    if (currency.rateFromUsd < 5.0) {
      // Centimes → montant avec 2 décimales
      return _place((nativeAmount / 100.0).toStringAsFixed(2), currency);
    } else {
      // Unités entières → groupement milliers
      final s = nativeAmount.toString();
      final buf = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
        buf.write(s[i]);
      }
      return _place(buf.toString(), currency);
    }
  }

  /// Place le symbole selon la convention de la devise.
  static String _place(String amount, AppCurrency c) {
    switch (c.code) {
      case 'USD': return '\$$amount';
      case 'CAD': return 'CA\$$amount';
      case 'AUD': return 'A\$$amount';
      case 'NZD': return 'NZ\$$amount';
      case 'SGD': return 'S\$$amount';
      case 'HKD': return 'HK\$$amount';
      case 'BRL': return 'R\$$amount';
      case 'MXN': return 'MX\$$amount';
      case 'COP': return 'COP\$$amount';
      case 'CLP': return 'CLP\$$amount';
      case 'ARS': return '\$$amount';
      case 'EUR': return '$amount €';
      case 'GBP': return '£$amount';
      case 'JPY': return '¥$amount';
      case 'CNY': return '¥$amount';
      case 'KRW': return '₩$amount';
      case 'INR': return '₹$amount';
      case 'IDR': return 'Rp $amount';
      case 'THB': return '฿$amount';
      case 'PLN': return '$amount zł';
      case 'SEK':
      case 'NOK':
      case 'DKK': return '$amount kr';
      case 'CHF': return 'CHF $amount';
      case 'TRY': return '₺$amount';
      case 'RUB': return '₽$amount';
      case 'PKR':
      case 'BDT': return '${c.symbol}$amount';
      default: return '$amount ${c.symbol}';
    }
  }
}
