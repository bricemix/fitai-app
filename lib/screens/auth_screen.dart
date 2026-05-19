import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'consent_screen.dart';
import 'forgot_password_screen.dart';

// ── Comprehensive country list (code, flag, name in French) ───────────────────
const _kAllCountries = [
  // ── Afrique francophone (en tête) ─────────────────────────────────────────
  ('CI', '🇨🇮', 'Côte d\'Ivoire'),
  ('SN', '🇸🇳', 'Sénégal'),
  ('CM', '🇨🇲', 'Cameroun'),
  ('ML', '🇲🇱', 'Mali'),
  ('BF', '🇧🇫', 'Burkina Faso'),
  ('TG', '🇹🇬', 'Togo'),
  ('BJ', '🇧🇯', 'Bénin'),
  ('GN', '🇬🇳', 'Guinée'),
  ('NE', '🇳🇪', 'Niger'),
  ('CD', '🇨🇩', 'RD Congo'),
  ('CG', '🇨🇬', 'Congo'),
  ('GA', '🇬🇦', 'Gabon'),
  ('GQ', '🇬🇶', 'Guinée équatoriale'),
  ('CF', '🇨🇫', 'République centrafricaine'),
  ('TD', '🇹🇩', 'Tchad'),
  ('MG', '🇲🇬', 'Madagascar'),
  ('MR', '🇲🇷', 'Mauritanie'),
  ('GW', '🇬🇼', 'Guinée-Bissau'),
  ('CV', '🇨🇻', 'Cap-Vert'),
  ('KM', '🇰🇲', 'Comores'),
  ('DJ', '🇩🇯', 'Djibouti'),
  ('SC', '🇸🇨', 'Seychelles'),
  ('MU', '🇲🇺', 'Maurice'),
  ('ST', '🇸🇹', 'São Tomé-et-Príncipe'),
  ('RW', '🇷🇼', 'Rwanda'),
  ('BI', '🇧🇮', 'Burundi'),
  // ── Reste Afrique ─────────────────────────────────────────────────────────
  ('DZ', '🇩🇿', 'Algérie'),
  ('AO', '🇦🇴', 'Angola'),
  ('BW', '🇧🇼', 'Botswana'),
  ('EG', '🇪🇬', 'Égypte'),
  ('ER', '🇪🇷', 'Érythrée'),
  ('ET', '🇪🇹', 'Éthiopie'),
  ('GM', '🇬🇲', 'Gambie'),
  ('GH', '🇬🇭', 'Ghana'),
  ('KE', '🇰🇪', 'Kenya'),
  ('LS', '🇱🇸', 'Lesotho'),
  ('LR', '🇱🇷', 'Libéria'),
  ('LY', '🇱🇾', 'Libye'),
  ('MA', '🇲🇦', 'Maroc'),
  ('MW', '🇲🇼', 'Malawi'),
  ('MZ', '🇲🇿', 'Mozambique'),
  ('NA', '🇳🇦', 'Namibie'),
  ('NG', '🇳🇬', 'Nigeria'),
  ('SD', '🇸🇩', 'Soudan'),
  ('SL', '🇸🇱', 'Sierra Leone'),
  ('SO', '🇸🇴', 'Somalie'),
  ('SS', '🇸🇸', 'Soudan du Sud'),
  ('SZ', '🇸🇿', 'Eswatini'),
  ('TN', '🇹🇳', 'Tunisie'),
  ('TZ', '🇹🇿', 'Tanzanie'),
  ('UG', '🇺🇬', 'Ouganda'),
  ('ZA', '🇿🇦', 'Afrique du Sud'),
  ('ZM', '🇿🇲', 'Zambie'),
  ('ZW', '🇿🇼', 'Zimbabwe'),
  // ── Europe ────────────────────────────────────────────────────────────────
  ('AL', '🇦🇱', 'Albanie'),
  ('AD', '🇦🇩', 'Andorre'),
  ('AT', '🇦🇹', 'Autriche'),
  ('AZ', '🇦🇿', 'Azerbaïdjan'),
  ('BY', '🇧🇾', 'Biélorussie'),
  ('BE', '🇧🇪', 'Belgique'),
  ('BA', '🇧🇦', 'Bosnie-Herzégovine'),
  ('BG', '🇧🇬', 'Bulgarie'),
  ('HR', '🇭🇷', 'Croatie'),
  ('CY', '🇨🇾', 'Chypre'),
  ('CZ', '🇨🇿', 'Tchéquie'),
  ('DK', '🇩🇰', 'Danemark'),
  ('EE', '🇪🇪', 'Estonie'),
  ('FI', '🇫🇮', 'Finlande'),
  ('FR', '🇫🇷', 'France'),
  ('GE', '🇬🇪', 'Géorgie'),
  ('DE', '🇩🇪', 'Allemagne'),
  ('GR', '🇬🇷', 'Grèce'),
  ('HU', '🇭🇺', 'Hongrie'),
  ('IS', '🇮🇸', 'Islande'),
  ('IE', '🇮🇪', 'Irlande'),
  ('IT', '🇮🇹', 'Italie'),
  ('XK', '🇽🇰', 'Kosovo'),
  ('LV', '🇱🇻', 'Lettonie'),
  ('LI', '🇱🇮', 'Liechtenstein'),
  ('LT', '🇱🇹', 'Lituanie'),
  ('LU', '🇱🇺', 'Luxembourg'),
  ('MT', '🇲🇹', 'Malte'),
  ('MD', '🇲🇩', 'Moldavie'),
  ('MC', '🇲🇨', 'Monaco'),
  ('ME', '🇲🇪', 'Monténégro'),
  ('NL', '🇳🇱', 'Pays-Bas'),
  ('MK', '🇲🇰', 'Macédoine du Nord'),
  ('NO', '🇳🇴', 'Norvège'),
  ('PL', '🇵🇱', 'Pologne'),
  ('PT', '🇵🇹', 'Portugal'),
  ('RO', '🇷🇴', 'Roumanie'),
  ('RU', '🇷🇺', 'Russie'),
  ('SM', '🇸🇲', 'Saint-Marin'),
  ('RS', '🇷🇸', 'Serbie'),
  ('SK', '🇸🇰', 'Slovaquie'),
  ('SI', '🇸🇮', 'Slovénie'),
  ('ES', '🇪🇸', 'Espagne'),
  ('SE', '🇸🇪', 'Suède'),
  ('CH', '🇨🇭', 'Suisse'),
  ('TR', '🇹🇷', 'Turquie'),
  ('UA', '🇺🇦', 'Ukraine'),
  ('GB', '🇬🇧', 'Royaume-Uni'),
  ('VA', '🇻🇦', 'Vatican'),
  // ── Amériques ─────────────────────────────────────────────────────────────
  ('AG', '🇦🇬', 'Antigua-et-Barbuda'),
  ('AR', '🇦🇷', 'Argentine'),
  ('BS', '🇧🇸', 'Bahamas'),
  ('BB', '🇧🇧', 'Barbade'),
  ('BZ', '🇧🇿', 'Belize'),
  ('BO', '🇧🇴', 'Bolivie'),
  ('BR', '🇧🇷', 'Brésil'),
  ('CA', '🇨🇦', 'Canada'),
  ('CL', '🇨🇱', 'Chili'),
  ('CO', '🇨🇴', 'Colombie'),
  ('CR', '🇨🇷', 'Costa Rica'),
  ('CU', '🇨🇺', 'Cuba'),
  ('DM', '🇩🇲', 'Dominique'),
  ('DO', '🇩🇴', 'République dominicaine'),
  ('EC', '🇪🇨', 'Équateur'),
  ('SV', '🇸🇻', 'Salvador'),
  ('GD', '🇬🇩', 'Grenade'),
  ('GT', '🇬🇹', 'Guatemala'),
  ('GY', '🇬🇾', 'Guyana'),
  ('HT', '🇭🇹', 'Haïti'),
  ('HN', '🇭🇳', 'Honduras'),
  ('JM', '🇯🇲', 'Jamaïque'),
  ('MX', '🇲🇽', 'Mexique'),
  ('NI', '🇳🇮', 'Nicaragua'),
  ('PA', '🇵🇦', 'Panama'),
  ('PY', '🇵🇾', 'Paraguay'),
  ('PE', '🇵🇪', 'Pérou'),
  ('KN', '🇰🇳', 'Saint-Kitts-et-Nevis'),
  ('LC', '🇱🇨', 'Sainte-Lucie'),
  ('VC', '🇻🇨', 'Saint-Vincent-et-les-Grenadines'),
  ('SR', '🇸🇷', 'Suriname'),
  ('TT', '🇹🇹', 'Trinité-et-Tobago'),
  ('US', '🇺🇸', 'États-Unis'),
  ('UY', '🇺🇾', 'Uruguay'),
  ('VE', '🇻🇪', 'Venezuela'),
  // ── Asie & Moyen-Orient ───────────────────────────────────────────────────
  ('AF', '🇦🇫', 'Afghanistan'),
  ('AM', '🇦🇲', 'Arménie'),
  ('SA', '🇸🇦', 'Arabie saoudite'),
  ('AE', '🇦🇪', 'Émirats arabes unis'),
  ('BD', '🇧🇩', 'Bangladesh'),
  ('BH', '🇧🇭', 'Bahreïn'),
  ('BT', '🇧🇹', 'Bhoutan'),
  ('BN', '🇧🇳', 'Brunéi'),
  ('KH', '🇰🇭', 'Cambodge'),
  ('CN', '🇨🇳', 'Chine'),
  ('KP', '🇰🇵', 'Corée du Nord'),
  ('KR', '🇰🇷', 'Corée du Sud'),
  ('IN', '🇮🇳', 'Inde'),
  ('ID', '🇮🇩', 'Indonésie'),
  ('IQ', '🇮🇶', 'Irak'),
  ('IR', '🇮🇷', 'Iran'),
  ('IL', '🇮🇱', 'Israël'),
  ('JP', '🇯🇵', 'Japon'),
  ('JO', '🇯🇴', 'Jordanie'),
  ('KZ', '🇰🇿', 'Kazakhstan'),
  ('KW', '🇰🇼', 'Koweït'),
  ('KG', '🇰🇬', 'Kirghizistan'),
  ('LA', '🇱🇦', 'Laos'),
  ('LB', '🇱🇧', 'Liban'),
  ('MY', '🇲🇾', 'Malaisie'),
  ('MV', '🇲🇻', 'Maldives'),
  ('MN', '🇲🇳', 'Mongolie'),
  ('MM', '🇲🇲', 'Myanmar'),
  ('NP', '🇳🇵', 'Népal'),
  ('OM', '🇴🇲', 'Oman'),
  ('PK', '🇵🇰', 'Pakistan'),
  ('PS', '🇵🇸', 'Palestine'),
  ('PH', '🇵🇭', 'Philippines'),
  ('QA', '🇶🇦', 'Qatar'),
  ('SG', '🇸🇬', 'Singapour'),
  ('LK', '🇱🇰', 'Sri Lanka'),
  ('SY', '🇸🇾', 'Syrie'),
  ('TW', '🇹🇼', 'Taïwan'),
  ('TJ', '🇹🇯', 'Tadjikistan'),
  ('TH', '🇹🇭', 'Thaïlande'),
  ('TL', '🇹🇱', 'Timor oriental'),
  ('TM', '🇹🇲', 'Turkménistan'),
  ('UZ', '🇺🇿', 'Ouzbékistan'),
  ('VN', '🇻🇳', 'Viêt Nam'),
  ('YE', '🇾🇪', 'Yémen'),
  // ── Océanie ───────────────────────────────────────────────────────────────
  ('AU', '🇦🇺', 'Australie'),
  ('FJ', '🇫🇯', 'Fidji'),
  ('KI', '🇰🇮', 'Kiribati'),
  ('MH', '🇲🇭', 'Îles Marshall'),
  ('FM', '🇫🇲', 'Micronésie'),
  ('NR', '🇳🇷', 'Nauru'),
  ('NZ', '🇳🇿', 'Nouvelle-Zélande'),
  ('PW', '🇵🇼', 'Palaos'),
  ('PG', '🇵🇬', 'Papouasie-Nouvelle-Guinée'),
  ('WS', '🇼🇸', 'Samoa'),
  ('SB', '🇸🇧', 'Îles Salomon'),
  ('TO', '🇹🇴', 'Tonga'),
  ('TV', '🇹🇻', 'Tuvalu'),
  ('VU', '🇻🇺', 'Vanuatu'),
];

class AuthScreen extends StatefulWidget {
  /// Called after a successful login or registration.
  /// [isNewAccount] is true when the user just registered (needs onboarding).
  final void Function(bool isNewAccount) onAuthenticated;

  const AuthScreen({super.key, required this.onAuthenticated});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _showLanguagePicker(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx);
              return Text(l10n.chooseLanguage,
                  style: const TextStyle(fontFamily: 'Syne', fontSize: 17, fontWeight: FontWeight.w700));
            }),
            const SizedBox(height: 14),
            ...LocaleProvider.supportedLanguages.map((lang) {
              final isSelected = localeProvider.locale.languageCode == lang.$1;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(lang.$3, style: const TextStyle(fontSize: 26)),
                title: Text(lang.$2,
                    style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                        color: isSelected ? AppTheme.accent : AppTheme.text)),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppTheme.accent, size: 20)
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
    final currentLang = LocaleProvider.supportedLanguages.firstWhere(
      (l) => l.$1 == localeProvider.locale.languageCode,
      orElse: () => LocaleProvider.supportedLanguages.first,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // ── Language selector (top right) ──────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _showLanguagePicker(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currentLang.$3, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text(currentLang.$1.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.muted)),
                        const SizedBox(width: 4),
                        const Icon(Icons.expand_more, size: 14, color: AppTheme.muted),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Logo ───────────────────────────────────────────────────────
              _DietVisionLogo(),
              const SizedBox(height: 32),

              // ── Tab bar ────────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Builder(builder: (ctx) {
                  final l10n = AppLocalizations.of(ctx);
                  return TabBar(
                    controller: _tab,
                    indicator: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: AppTheme.bg,
                    unselectedLabelColor: AppTheme.muted,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
                    tabs: [
                      Tab(text: l10n.signIn),
                      Tab(text: l10n.createAccount),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 24),

              // ── Forms ──────────────────────────────────────────────────────
              IndexedStack(
                index: _tab.index,
                children: [
                  _LoginForm(onSuccess: () => widget.onAuthenticated(false)),
                  _RegisterForm(onSuccess: () => widget.onAuthenticated(true)),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Logo ───────────────────────────────────────────────────────────────────────

class _DietVisionLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SvgPicture.asset(
            'assets/logo/dietvision-icon.svg',
            width: 80,
            height: 80,
          ),
        ),
        const SizedBox(height: 14),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Diet',
                style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.text),
              ),
              TextSpan(
                text: 'Vision',
                style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.accent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Builder(builder: (ctx) {
          final l10n = AppLocalizations.of(ctx);
          return Text(
            l10n.appSubtitle,
            style: const TextStyle(fontSize: 13, color: AppTheme.muted),
          );
        }),
      ],
    );
  }
}

// ── Login Form ─────────────────────────────────────────────────────────────────

class _LoginForm extends StatefulWidget {
  final VoidCallback onSuccess;
  const _LoginForm({required this.onSuccess});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    final result = await AuthService.login(_emailCtrl.text, _passCtrl.text);

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      widget.onSuccess();
    } else {
      setState(() => _error = result.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_error != null) _ErrorBanner(_error!),

          _Label(l10n.email.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              hintText: l10n.emailHint,
              prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.muted, size: 18),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.emailRequired;
              if (!v.contains('@')) return l10n.emailInvalid;
              return null;
            },
          ),
          const SizedBox(height: 16),

          _Label(l10n.password.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              hintText: l10n.passwordHint,
              prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.muted, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppTheme.muted,
                    size: 18),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.passwordRequired;
              return null;
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.forgotPassword,
                style: const TextStyle(color: AppTheme.muted, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: AppTheme.bg, strokeWidth: 2))
                  : Text(l10n.loginButton),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Register Form ──────────────────────────────────────────────────────────────

class _RegisterForm extends StatefulWidget {
  final VoidCallback onSuccess;
  const _RegisterForm({required this.onSuccess});

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // Default: États-Unis
  String _countryCode = 'US';
  String _countryFlag = '🇺🇸';
  String _countryName = 'États-Unis';

  // Default: Dollar US
  AppCurrency _currency = CurrencyService.currencies.firstWhere((c) => c.code == 'USD');

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  bool _consentChecked = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _ageCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _openCountryPicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _CountryPickerSheet(
        selectedCode: _countryCode,
        onSelect: (code, flag, name) {
          setState(() {
            _countryCode = code;
            _countryFlag = flag;
            _countryName = name;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _openCurrencyPicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _CurrencyPickerSheet(
        selected: _currency,
        onSelect: (c) async {
          setState(() => _currency = c);
          await CurrencyService.save(c); // persisté dès le choix
          if (ctx.mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_consentChecked) {
      setState(() => _error = AppLocalizations.of(context).mustAcceptPrivacy);
      return;
    }
    setState(() { _loading = true; _error = null; });

    final email = _emailCtrl.text.trim();
    final result = await AuthService.register(
      name: _nameCtrl.text,
      email: email,
      password: _passCtrl.text,
      phone: _phoneCtrl.text,
      country: _countryCode,
      age: _ageCtrl.text.trim().isNotEmpty ? _ageCtrl.text.trim() : null,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      // Laisser main.dart gérer la gate de vérification e-mail
      widget.onSuccess();
    } else {
      setState(() => _error = result.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_error != null) _ErrorBanner(_error!),

          // Name
          _Label(l10n.firstName.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameCtrl,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              hintText: l10n.firstNameHint,
              prefixIcon: const Icon(Icons.person_outline, color: AppTheme.muted, size: 18),
            ),
            validator: (v) {
              if (v == null || v.trim().length < 2) return l10n.firstNameRequired;
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Age
          _Label(l10n.age.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _ageCtrl,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              hintText: '25',
              prefixIcon: const Icon(Icons.cake_outlined, color: AppTheme.muted, size: 18),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null; // facultatif
              final n = int.tryParse(v.trim());
              if (n == null || n < 10 || n > 120) return l10n.error;
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Email
          _Label(l10n.email.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              hintText: l10n.emailHint,
              prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.muted, size: 18),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.emailRequired;
              if (!v.contains('@') || !v.contains('.')) return l10n.emailInvalid;
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Phone (optional)
          _Label(l10n.phone.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              hintText: l10n.phoneHint,
              prefixIcon: const Icon(Icons.phone_outlined, color: AppTheme.muted, size: 18),
            ),
          ),
          const SizedBox(height: 14),

          // Country — tappable selector
          _Label(l10n.country.toUpperCase()),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _openCountryPicker,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.public_outlined, color: AppTheme.muted, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    '$_countryFlag  $_countryName',
                    style: const TextStyle(color: AppTheme.text, fontSize: 14),
                  ),
                  const Spacer(),
                  const Icon(Icons.expand_more, color: AppTheme.muted, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Currency — tappable selector
          _Label(l10n.currency.toUpperCase()),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _openCurrencyPicker,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.currency_exchange_rounded, color: AppTheme.muted, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    '${_currency.flag}  ${_currency.name}',
                    style: const TextStyle(color: AppTheme.text, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withAlpha(28),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _currency.code,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.accent),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.expand_more, color: AppTheme.muted, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Password
          _Label(l10n.password.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscurePass,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              hintText: l10n.passwordHint,
              prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.muted, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppTheme.muted,
                    size: 18),
                onPressed: () => setState(() => _obscurePass = !_obscurePass),
              ),
            ),
            onChanged: (_) => setState(() {}),
            validator: (v) {
              if (v == null || v.length < 8) return l10n.passwordMin8;
              if (!v.contains(RegExp(r'[A-Z]'))) return l10n.passwordNeedsUppercase;
              if (!v.contains(RegExp(r'[\d!@#$%^&*()\-_=+\[\]{};:,.<>/?\\|~]')))
                return l10n.passwordNeedsNumberOrSymbol;
              return null;
            },
          ),
          _PasswordStrengthHint(password: _passCtrl.text),
          const SizedBox(height: 14),

          // Confirm password
          _Label(l10n.confirmPassword.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _confirmCtrl,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              hintText: l10n.passwordHint,
              prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.muted, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppTheme.muted,
                    size: 18),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (v) {
              if (v != _passCtrl.text) return l10n.passwordMismatch;
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Checkbox RGPD
          GestureDetector(
            onTap: () => setState(() => _consentChecked = !_consentChecked),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color: _consentChecked ? AppTheme.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _consentChecked ? AppTheme.accent : AppTheme.muted,
                      width: 2,
                    ),
                  ),
                  child: _consentChecked
                      ? const Icon(Icons.check, size: 14, color: AppTheme.bg)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: AppTheme.muted, height: 1.4),
                      children: [
                        TextSpan(text: l10n.iAcceptThe),
                        TextSpan(
                          text: l10n.privacyPolicyLink,
                          style: const TextStyle(
                            color: AppTheme.accent,
                            decoration: TextDecoration.underline,
                            decorationColor: AppTheme.accent,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConsentScreen(onAccepted: () => Navigator.pop(context)),
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: AppTheme.bg, strokeWidth: 2))
                  : Text(l10n.registerButton),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Password Strength Hint ────────────────────────────────────────────────────

class _PasswordStrengthHint extends StatelessWidget {
  final String password;
  const _PasswordStrengthHint({required this.password});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasLength  = password.length >= 8;
    final hasUpper   = password.contains(RegExp(r'[A-Z]'));
    final hasNumSym  = password.contains(RegExp(r'[\d!@#$%^&*()\-_=+\[\]{};:,.<>/?\\|~]'));

    if (password.isEmpty) return const SizedBox.shrink();

    Widget row(bool ok, String text) => Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 14,
            color: ok ? AppTheme.accent : AppTheme.muted,
          ),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 12, color: ok ? AppTheme.accent : AppTheme.muted)),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row(hasLength, l10n.passwordMin8),
          row(hasUpper,  l10n.passwordNeedsUppercase),
          row(hasNumSym, l10n.passwordNeedsNumberOrSymbol),
        ],
      ),
    );
  }
}

// ── Country Picker Sheet ───────────────────────────────────────────────────────

class _CountryPickerSheet extends StatefulWidget {
  final String selectedCode;
  final void Function(String code, String flag, String name) onSelect;

  const _CountryPickerSheet({
    required this.selectedCode,
    required this.onSelect,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchCtrl = TextEditingController();
  late List<(String, String, String)> _filtered;

  @override
  void initState() {
    super.initState();
    // Tri alphabétique par nom de pays
    _filtered = List.from(_kAllCountries)..sort((a, b) => a.$3.compareTo(b.$3));
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(_kAllCountries)..sort((a, b) => a.$3.compareTo(b.$3));
      } else {
        _filtered = (_kAllCountries
            .where((c) =>
                c.$3.toLowerCase().contains(q) ||
                c.$1.toLowerCase().contains(q))
            .toList())
          ..sort((a, b) => a.$3.compareTo(b.$3));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            // Title
            Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      l10n.chooseCountry,
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),

            // Search field
            Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: false,
                  style: const TextStyle(color: AppTheme.text, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.searchCountry,
                    prefixIcon: const Icon(Icons.search, color: AppTheme.muted, size: 18),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppTheme.muted, size: 16),
                            onPressed: () {
                              _searchCtrl.clear();
                            },
                          )
                        : null,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),

            // Divider
            const Divider(color: AppTheme.border, height: 1),

            // Country list
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: _filtered.length,
                itemBuilder: (ctx, i) {
                  final country = _filtered[i];
                  final isSelected = country.$1 == widget.selectedCode;
                  return InkWell(
                    onTap: () => widget.onSelect(country.$1, country.$2, country.$3),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 13),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.accent.withAlpha(18)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Text(country.$2,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              country.$3,
                              style: TextStyle(
                                color: isSelected
                                    ? AppTheme.accent
                                    : AppTheme.text,
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle,
                                color: AppTheme.accent, size: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Currency Picker Sheet ──────────────────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final AppCurrency selected;
  final void Function(AppCurrency) onSelect;

  const _CurrencyPickerSheet({required this.selected, required this.onSelect});

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  final _searchCtrl = TextEditingController();
  late List<AppCurrency> _filtered;

  @override
  void initState() {
    super.initState();
    // Tri alphabétique par nom de devise
    _filtered = List.from(CurrencyService.currencies)..sort((a, b) => a.name.compareTo(b.name));
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(CurrencyService.currencies)..sort((a, b) => a.name.compareTo(b.name));
      } else {
        _filtered = (CurrencyService.currencies
            .where((c) =>
                c.name.toLowerCase().contains(q) ||
                c.code.toLowerCase().contains(q) ||
                c.symbol.toLowerCase().contains(q))
            .toList())
          ..sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 14),
            Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.currency_exchange_rounded, color: AppTheme.accent, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.chooseCurrency,
                        style: const TextStyle(color: AppTheme.text, fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: false,
                  style: const TextStyle(color: AppTheme.text, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.searchCurrency,
                    prefixIcon: const Icon(Icons.search, color: AppTheme.muted, size: 18),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppTheme.muted, size: 16),
                            onPressed: _searchCtrl.clear,
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            const Divider(color: AppTheme.border, height: 1),
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: _filtered.length,
                itemBuilder: (ctx, i) {
                  final c = _filtered[i];
                  final isSelected = c.code == widget.selected.code;
                  return InkWell(
                    onTap: () => widget.onSelect(c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accent.withAlpha(15) : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Text(c.flag, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? AppTheme.accent : AppTheme.text,
                                    )),
                                Text(c.code,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected ? AppTheme.accent.withAlpha(180) : AppTheme.muted,
                                    )),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyService.format(499, c),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppTheme.accent : AppTheme.muted,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppTheme.accent, size: 18)
                          else
                            const SizedBox(width: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 11,
          color: AppTheme.muted,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.accent3.withAlpha(18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent3.withAlpha(64)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.accent3, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: const TextStyle(fontSize: 13, color: AppTheme.accent3)),
          ),
        ],
      ),
    );
  }
}
