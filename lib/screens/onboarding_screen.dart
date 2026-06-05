import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import '../services/currency_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class OnboardingScreen extends StatefulWidget {
  final void Function(UserProfile) onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  AppColors get c => AppTheme.of(context);

  int _step = 0; // 0=welcome, 1=identité, 2=objectif, 3=activité

  // Step 1 — identité
  String _name     = '';
  String _age      = '';
  String _gender   = 'homme';
  String _weight   = '';
  String _height   = '';
  String _waistCm  = '';
  String _bicepsCm = '';
  String _bellyCm  = '';

  // Step 2 — objectif
  String _goal          = '';
  double _goalKgPerWeek = 0; // sera calculé selon le goal

  // Step 3 — activité
  String _activity     = '';  // set lazily in build() from l10n
  List<String> _restrictions = [];

  // Clés canoniques (stockées dans le profil, indépendantes de la langue)
  static const _restrictionKeys = [
    'vegetarian', 'vegan', 'gluten_free', 'lactose_free', 'halal', 'keto',
  ];

  List<String> _restrictionLabels(AppLocalizations l) => [
    l.restrictionVegetarian, l.restrictionVegan, l.restrictionGlutenFree,
    l.restrictionLactoseFree, l.restrictionHalal, l.restrictionKeto,
  ];

  // Options kg/semaine selon le goal (computed in build via l10n)
  List<(double kg, String label, String detail)> _kgOptions(AppLocalizations l10n) {
    if (_goal == l10n.loseWeight) {
      return [
        (-0.25, l10n.soft,      '-250 kcal/j'),
        (-0.5,  l10n.moderate,  '-500 kcal/j'),
        (-0.75, l10n.sustained, '-750 kcal/j'),
        (-1.0,  l10n.intense,   '-1000 kcal/j'),
      ];
    } else if (_goal == l10n.gainMass) {
      return [
        (0.1,  l10n.lean,       '+100 kcal/j'),
        (0.25, l10n.moderate,   '+250 kcal/j'),
        (0.5,  l10n.aggressive, '+500 kcal/j'),
      ];
    }
    return [];
  }

  bool _canNext(AppLocalizations l10n) {
    switch (_step) {
      case 0: return true;
      case 1: return _name.isNotEmpty && _weight.isNotEmpty && _height.isNotEmpty;
      case 2: return _goal.isNotEmpty && (_kgOptions(l10n).isEmpty || _goalKgPerWeek != 0);
      case 3: return true;
      default: return false;
    }
  }

  void _next() async {
    if (_step == 3) {
      // Récupère la devise choisie à l'inscription (ou défaut XOF)
      final currency = await CurrencyService.load();
      final profile = UserProfile(
        name:           _name,
        age:            _age,
        gender:         _gender,
        weight:         _weight,
        height:         _height,
        goal:           _goal,
        activity:       _activity,
        restrictions:   _restrictions,
        waistCm:        _waistCm,
        bicepsCm:       _bicepsCm,
        bellyCm:        _bellyCm,
        goalKgPerWeek:  _goalKgPerWeek,
        currencyCode:   currency.code,
      );
      await StorageService.saveProfile(profile);
      // Sync immédiat vers le serveur — indispensable pour retrouver
      // le profil après déconnexion/réinstallation.
      SyncService.uploadProfile(profile);
      widget.onDone(profile);
    } else {
      setState(() => _step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Force rebuild quand la locale change (nécessaire pour mettre à jour
    // tous les textes du screen, pas seulement les widgets enfants qui
    // regardent LocaleProvider indépendamment)
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    // Initialize default activity lazily from l10n
    if (_activity.isEmpty) _activity = l10n.activityModerate;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_step > 0) _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStep(l10n),
              ),
            ),
            if (_step > 0) _buildNextButton(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _step--),
            child: Icon(Icons.arrow_back_ios, size: 20, color: c.muted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: List.generate(3, (i) => Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  height: 4,
                  decoration: BoxDecoration(
                    color: _step > i ? c.accent : c.surface2,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(AppLocalizations l10n) {
    switch (_step) {
      case 0: return _buildWelcome(l10n);
      case 1: return _buildIdentity(l10n);
      case 2: return _buildGoal(l10n);
      case 3: return _buildActivity(l10n);
      default: return const SizedBox();
    }
  }

  // ── Step 0: Welcome ──────────────────────────────────────────────────────────

  Widget _buildWelcome(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [

          // ── Bouton langue (haut à droite) ──────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: _OnboardingLangButton(),
          ),
          const SizedBox(height: 16),

          // ── Logo avec glow ─────────────────────────────────────────────────
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.accent.withAlpha(16),
              border: Border.all(color: c.accent.withAlpha(60), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: c.accent.withAlpha(70),
                  blurRadius: 40,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SvgPicture.asset(
                  'assets/logo/dietvision-icon.svg',
                  width: 66,
                  height: 66,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Titre ──────────────────────────────────────────────────────────
          Text(
            l10n.welcomeTo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: c.text,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'DietVision',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: c.accent,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 14),

          // ── Sous-titre ─────────────────────────────────────────────────────
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14, color: c.muted, height: 1.55),
              children: [
                TextSpan(text: l10n.onboardingIntro),
                TextSpan(
                  text: l10n.onboardingPersonalize,
                  style: TextStyle(color: c.accent, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── 3 cartes d'info ────────────────────────────────────────────────
          _WelcomeInfoCard(
            icon: Icons.person_rounded,
            title: l10n.infoCardTitle,
            subtitle: l10n.infoCardSubtitle,
          ),
          const SizedBox(height: 10),
          _WelcomeInfoCard(
            icon: Icons.straighten_rounded,
            title: l10n.measuresCardTitle,
            subtitle: l10n.measuresCardSubtitle,
          ),
          const SizedBox(height: 10),
          _WelcomeInfoCard(
            icon: Icons.track_changes_rounded,
            title: l10n.objectivesCardTitle,
            subtitle: l10n.objectivesCardSubtitle,
          ),
          const SizedBox(height: 14),

          // ── Note IA ────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: c.accent.withAlpha(12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.accent.withAlpha(40)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.verified_rounded, size: 16, color: c.accent),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: c.muted, height: 1.5),
                      children: [
                        TextSpan(text: l10n.aiNoteText),
                        TextSpan(
                          text: l10n.aiNoteHighlight,
                          style: TextStyle(color: c.accent, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Bouton CTA ─────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _step = 1),
              child: Text(l10n.configureProfile),
            ),
          ),
          const SizedBox(height: 14),

          // ── Footer ─────────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.nextStepLabel,
                style: TextStyle(fontSize: 12, color: c.muted),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, size: 16, color: c.muted),
            ],
          ),
        ],
      ),
    );
  }

  // ── Step 1: Identité + mesures ───────────────────────────────────────────────

  Widget _buildIdentity(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(l10n.profileTitle, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(l10n.profileSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.muted)),
        const SizedBox(height: 20),

        _inputField(l10n.yourFirstName, hint: l10n.firstNameEx, onChanged: (v) => setState(() => _name = v)),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: _inputField(l10n.age, hint: '25', numeric: true, onChanged: (v) => setState(() => _age = v))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label(l10n.genderLabel),
                Row(children: [
                  Expanded(child: _GenderButton(label: l10n.male, icon: Icons.male_rounded, selected: _gender == 'homme', onTap: () => setState(() => _gender = 'homme'))),
                  const SizedBox(width: 6),
                  Expanded(child: _GenderButton(label: l10n.female, icon: Icons.female_rounded, selected: _gender == 'femme', onTap: () => setState(() => _gender = 'femme'))),
                ]),
              ],
            ),
          ),
        ]),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: _inputField(l10n.weight, hint: '70', numeric: true, onChanged: (v) => setState(() => _weight = v))),
          const SizedBox(width: 12),
          Expanded(child: _inputField(l10n.height, hint: '175', numeric: true, onChanged: (v) => setState(() => _height = v))),
        ]),
        const SizedBox(height: 16),

        _label(l10n.bodyMeasurementsLabel),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _inputField(l10n.waist, hint: 'cm', numeric: true, onChanged: (v) => setState(() => _waistCm = v))),
          const SizedBox(width: 12),
          Expanded(child: _inputField(l10n.biceps, hint: 'cm', numeric: true, onChanged: (v) => setState(() => _bicepsCm = v))),
          const SizedBox(width: 12),
          Expanded(child: _inputField(l10n.belly, hint: 'cm', numeric: true, onChanged: (v) => setState(() => _bellyCm = v))),
        ]),
        const SizedBox(height: 20),
      ],
    );
  }

  // ── Step 2: Objectif ─────────────────────────────────────────────────────────

  Widget _buildGoal(AppLocalizations l10n) {
    final goals = [l10n.loseWeight, l10n.gainMass, l10n.maintain, l10n.eatHealthy];
    final options = _kgOptions(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(l10n.goalLabel, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l10n.goalQuestion,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.muted)),
        const SizedBox(height: 16),

        ...goals.map((g) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _SelectTile(
            label: g,
            selected: _goal == g,
            onTap: () => setState(() {
              _goal = g;
              _goalKgPerWeek = 0; // réinitialiser
            }),
          ),
        )),

        // Sous-sélection kg/semaine pour perte/masse
        if (options.isNotEmpty) ...[
          const SizedBox(height: 8),
          _label(l10n.rhythmLabel),
          const SizedBox(height: 8),
          ...options.map((opt) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => setState(() => _goalKgPerWeek = opt.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _goalKgPerWeek == opt.$1 ? c.accent.withAlpha(20) : c.surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _goalKgPerWeek == opt.$1 ? c.accent : c.border,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(opt.$2, style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _goalKgPerWeek == opt.$1 ? c.accent : c.text,
                          )),
                          Text('${opt.$1.abs().toStringAsFixed(2)} ${l10n.kgPerWeek}',
                              style: TextStyle(fontSize: 12, color: c.muted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: c.accent.withAlpha(20),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(opt.$3,
                          style: TextStyle(fontSize: 12, color: c.accent, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          )),

          // Avertissement si rythme > 0.75 kg/semaine pour perte
          if (_goal == l10n.loseWeight && _goalKgPerWeek <= -0.75)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c.accent3.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.accent3.withAlpha(80)),
              ),
              child: Row(children: [
                Icon(Icons.info_outline_rounded, size: 16, color: c.accent3),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  l10n.aggressiveWarning,
                  style: TextStyle(fontSize: 12, color: c.accent3),
                )),
              ]),
            ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  // ── Step 3: Activité & régime ────────────────────────────────────────────────

  Widget _buildActivity(AppLocalizations l10n) {
    final activities = [
      l10n.activitySedentary,
      l10n.activityLight,
      l10n.activityModerate,
      l10n.activityActive,
      l10n.activityVeryActive,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(l10n.activityDiet, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        _label(l10n.activityLevelLabel),
        const SizedBox(height: 8),
        ...activities.map((a) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _SelectTile(
            label: a,
            selected: _activity == a,
            onTap: () => setState(() => _activity = a),
          ),
        )),
        const SizedBox(height: 16),
        _label(l10n.dietLabel),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_restrictionKeys.length, (i) {
            final key   = _restrictionKeys[i];
            final label = _restrictionLabels(l10n)[i];
            return _Chip(
              label: label,
              selected: _restrictions.contains(key),
              onTap: () => setState(() {
                if (_restrictions.contains(key)) {
                  _restrictions = List.from(_restrictions)..remove(key);
                } else {
                  _restrictions = List.from(_restrictions)..add(key);
                }
              }),
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ── Next button ──────────────────────────────────────────────────────────────

  Widget _buildNextButton(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _canNext(l10n) ? _next : null,
          child: Text(_step == 3 ? l10n.createProfile : l10n.continueButton),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Widget _inputField(String label, {String hint = '', bool numeric = false, required void Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        TextFormField(
          keyboardType: numeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: c.muted)),
          style: TextStyle(color: c.text),
          onChanged: onChanged,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text.toUpperCase(),
        style: TextStyle(fontSize: 11, color: c.muted, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
  );
}

// ── Bouton langue onboarding ──────────────────────────────────────────────────
class _OnboardingLangButton extends StatelessWidget {
  const _OnboardingLangButton();

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

// ── Welcome info card ─────────────────────────────────────────────────────────
class _WelcomeInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _WelcomeInfoCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.accent.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: c.accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14, color: c.text)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: c.muted)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 18, color: c.muted),
        ],
      ),
    );
  }
}

// ── Gender button ─────────────────────────────────────────────────────────────
class _GenderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _GenderButton({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? c.accent : c.surface2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? c.accent : c.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? c.bg : c.muted),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: selected ? c.bg : c.muted, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ── Select tile ───────────────────────────────────────────────────────────────
class _SelectTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SelectTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? c.accent : c.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? c.accent : c.border),
        ),
        child: Text(label, style: TextStyle(
          color: selected ? c.bg : c.text,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 14,
        )),
      ),
    );
  }
}

// ── Chip ──────────────────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c.accent : c.surface2,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: selected ? c.accent : c.border),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12,
          color: selected ? c.bg : c.text,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        )),
      ),
    );
  }
}
