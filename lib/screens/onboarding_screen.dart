import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/profile.dart';
import '../services/storage_service.dart';
import '../services/currency_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final void Function(UserProfile) onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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

  static const _restrictionsList = [
    'Végétarien', 'Vegan', 'Sans gluten', 'Sans lactose', 'Halal', 'Keto',
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
      widget.onDone(profile);
    } else {
      setState(() => _step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            child: const Icon(Icons.arrow_back_ios, size: 20, color: AppTheme.muted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: List.generate(3, (i) => Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  height: 4,
                  decoration: BoxDecoration(
                    color: _step > i ? AppTheme.accent : AppTheme.surface2,
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
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.8),
              radius: 1.2,
              colors: [AppTheme.accent.withAlpha(51), Colors.transparent],
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(27),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accent.withAlpha(18),
                  border: Border.all(color: AppTheme.accent.withAlpha(50), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: SvgPicture.asset(
                    'assets/logo/dietvision-icon.svg',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.welcome,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.muted, height: 1.5),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => _step = 1),
                  child: Text(l10n.configureProfile),
                ),
              ),
            ],
          ),
        ),
      ],
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.muted)),
        const SizedBox(height: 20),

        _inputField(l10n.yourFirstName, hint: l10n.firstNameEx, onChanged: (v) => _name = v),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: _inputField(l10n.age, hint: '25', numeric: true, onChanged: (v) => _age = v)),
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
          Expanded(child: _inputField(l10n.weight, hint: '70', numeric: true, onChanged: (v) => _weight = v)),
          const SizedBox(width: 12),
          Expanded(child: _inputField(l10n.height, hint: '175', numeric: true, onChanged: (v) => _height = v)),
        ]),
        const SizedBox(height: 16),

        _label(l10n.bodyMeasurementsLabel),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _inputField(l10n.waist, hint: 'cm', numeric: true, onChanged: (v) => _waistCm = v)),
          const SizedBox(width: 12),
          Expanded(child: _inputField(l10n.biceps, hint: 'cm', numeric: true, onChanged: (v) => _bicepsCm = v)),
          const SizedBox(width: 12),
          Expanded(child: _inputField(l10n.belly, hint: 'cm', numeric: true, onChanged: (v) => _bellyCm = v)),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.muted)),
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
                  color: _goalKgPerWeek == opt.$1 ? AppTheme.accent.withAlpha(20) : AppTheme.surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _goalKgPerWeek == opt.$1 ? AppTheme.accent : AppTheme.border,
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
                            color: _goalKgPerWeek == opt.$1 ? AppTheme.accent : AppTheme.text,
                          )),
                          Text('${opt.$1.abs().toStringAsFixed(2)} kg/semaine',
                              style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withAlpha(20),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(opt.$3,
                          style: const TextStyle(fontSize: 12, color: AppTheme.accent, fontWeight: FontWeight.w600)),
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
                color: AppTheme.accent3.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.accent3.withAlpha(80)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.accent3),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  l10n.aggressiveWarning,
                  style: const TextStyle(fontSize: 12, color: AppTheme.accent3),
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
          children: _restrictionsList.map((r) => _Chip(
            label: r,
            selected: _restrictions.contains(r),
            onTap: () => setState(() {
              if (_restrictions.contains(r)) {
                _restrictions = List.from(_restrictions)..remove(r);
              } else {
                _restrictions = List.from(_restrictions)..add(r);
              }
            }),
          )).toList(),
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
          decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: AppTheme.muted)),
          style: const TextStyle(color: AppTheme.text),
          onChanged: onChanged,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text.toUpperCase(),
        style: const TextStyle(fontSize: 11, color: AppTheme.muted, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
  );
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : AppTheme.surface2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppTheme.accent : AppTheme.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? AppTheme.bg : AppTheme.muted),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: selected ? AppTheme.bg : AppTheme.muted, fontWeight: FontWeight.w600)),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : AppTheme.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppTheme.accent : AppTheme.border),
        ),
        child: Text(label, style: TextStyle(
          color: selected ? AppTheme.bg : AppTheme.text,
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : AppTheme.surface2,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: selected ? AppTheme.accent : AppTheme.border),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12,
          color: selected ? AppTheme.bg : AppTheme.text,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        )),
      ),
    );
  }
}
