import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../providers/locale_provider.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import '../theme.dart';
import 'settings_screen.dart';
import 'subscription_screen.dart';
import '../l10n/app_localizations.dart';
import '../widgets/premium_banner_card.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final void Function(UserProfile) onUpdate;
  final VoidCallback onLogout;
  /// 'free' | 'starter' | 'pro' | 'premium' — affiche le banner si 'free'
  final String userPlan;
  final DateTime? trialEndsAt;
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onUpdate,
    required this.onLogout,
    this.userPlan = 'free',
    this.trialEndsAt,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name, _age, _weight, _height, _goal, _activity, _gender;
  late String _waistCm, _bicepsCm, _bellyCm;
  late double _goalKgPerWeek;
  String? _toast;

  List<String> _goals(AppLocalizations l) => [
    l.loseWeight,
    l.gainMass,
    l.maintain,
    l.eatHealthy,
  ];
  List<String> _activities(AppLocalizations l) => [
    l.activitySedentary,
    l.activityLight,
    l.activityModerate,
    l.activityActive,
    l.activityVeryActive,
  ];

  // kg/week options per goal
  static const _lossOptions = [-0.25, -0.5, -0.75, -1.0];
  static const _gainOptions = [0.1, 0.25, 0.5];

  @override
  void initState() {
    super.initState();
    _name          = widget.profile.name;
    _age           = widget.profile.age;
    _gender        = widget.profile.gender;
    _weight        = widget.profile.weight;
    _height        = widget.profile.height;
    _goal          = widget.profile.goal;
    _activity      = widget.profile.activity;
    _waistCm       = widget.profile.waistCm;
    _bicepsCm      = widget.profile.bicepsCm;
    _bellyCm       = widget.profile.bellyCm;
    _goalKgPerWeek = widget.profile.goalKgPerWeek;
  }

  Future<void> _save(AppLocalizations l) async {
    final updated = widget.profile.copyWith(
      name:          _name,
      age:           _age,
      gender:        _gender,
      weight:        _weight,
      height:        _height,
      goal:          _goal,
      activity:      _activity,
      waistCm:       _waistCm,
      bicepsCm:      _bicepsCm,
      bellyCm:       _bellyCm,
      goalKgPerWeek: _goalKgPerWeek,
    );
    await StorageService.saveProfile(updated);
    // Sync to server in background
    _syncToServer(updated);
    widget.onUpdate(updated);
    _showToast(l.saveProfile);
  }

  Future<void> _syncToServer(UserProfile p) => SyncService.uploadProfile(p);

  void _showToast(String msg) {
    setState(() => _toast = msg);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  List<double> _kgOptions(AppLocalizations l) {
    if (_goal == l.loseWeight) return _lossOptions;
    if (_goal == l.gainMass) return _gainOptions;
    return [];
  }

  String _kgLabel(double v, AppLocalizations l) {
    if (_goal == l.loseWeight) {
      final labels = <double, String>{-0.25: l.soft, -0.5: l.moderate, -0.75: l.sustained, -1.0: l.intense};
      return labels[v] ?? '${v.abs()} kg/sem';
    }
    final labels = <double, String>{0.1: l.lean, 0.25: l.moderate, 0.5: l.aggressive};
    return labels[v] ?? '+$v kg/sem';
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);
    final bmi = widget.profile.bmi;
    final bmiStr = bmi == 0 ? '—' : bmi.toStringAsFixed(1);
    final bmiLabel = bmi == 0
        ? ''
        : bmi < 18.5
            ? l10n.bmiUnderweight
            : bmi < 25
                ? l10n.bmiNormal
                : bmi < 30
                    ? l10n.bmiOverweight
                    : l10n.bmiObese;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(l10n.myProfile, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 14),

              // ── Banner upgrade (free ou starter en trial) ─────────────────
              if (widget.userPlan == 'free' || widget.userPlan == 'starter') ...[
                PremiumBannerCard(
                  trialEndsAt: widget.trialEndsAt,
                  currentPlan: widget.userPlan,
                ),
                const SizedBox(height: 16),
              ],

              // BMI + stats card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.surface, Color(0xFF1a1a30)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.bmi, style: const TextStyle(fontSize: 12, color: AppTheme.muted, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                          Text(bmiStr, style: const TextStyle(fontFamily: 'Syne', fontSize: 48, fontWeight: FontWeight.w800, color: AppTheme.accent, height: 1)),
                          Text(bmiLabel, style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(l10n.objective, style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
                        const SizedBox(height: 2),
                        Text(
                          _goal.isEmpty ? '—' : _goal,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        Text('${widget.profile.tdee.round()} kcal/j', style: const TextStyle(fontSize: 12, color: AppTheme.accent)),
                        const SizedBox(height: 2),
                        Text(_activity, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Section: Identité ─────────────────────────────────────────
              _sectionTitle(l10n.identity.toUpperCase()),
              const SizedBox(height: 10),

              // Gender buttons
              Text(l10n.gender.toUpperCase(), style: const TextStyle(fontSize: 11, color: AppTheme.muted, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _GenderButton(label: l10n.male, icon: Icons.male_rounded, selected: _gender == 'homme', onTap: () => setState(() => _gender = 'homme')),
                  const SizedBox(width: 10),
                  _GenderButton(label: l10n.female, icon: Icons.female_rounded, selected: _gender == 'femme', onTap: () => setState(() => _gender = 'femme')),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: _field(l10n.yourFirstName, _name, (v) => _name = v)),
                  const SizedBox(width: 10),
                  Expanded(child: _field(l10n.age, _age, (v) => _age = v, numeric: true)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _field(l10n.weight, _weight, (v) => _weight = v, numeric: true)),
                  const SizedBox(width: 10),
                  Expanded(child: _field(l10n.height, _height, (v) => _height = v, numeric: true)),
                ],
              ),
              const SizedBox(height: 20),

              // ── Section: Mesures corporelles ──────────────────────────────
              _sectionTitle(l10n.bodyMeasurementsLabel.toUpperCase()),
              const SizedBox(height: 4),
              Text(l10n.bodyMeasurementsHintProfile, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _field(l10n.waist, _waistCm, (v) => _waistCm = v, numeric: true, hint: 'ex: 80')),
                  const SizedBox(width: 10),
                  Expanded(child: _field(l10n.biceps, _bicepsCm, (v) => _bicepsCm = v, numeric: true, hint: 'ex: 35')),
                ],
              ),
              const SizedBox(height: 10),
              _field(l10n.belly, _bellyCm, (v) => _bellyCm = v, numeric: true, hint: 'ex: 90'),
              const SizedBox(height: 20),

              // ── Section: Objectif ─────────────────────────────────────────
              _sectionTitle(l10n.goalLabel.toUpperCase()),
              const SizedBox(height: 10),
              _dropdownField(l10n.objective, _goal, _goals(l10n), (v) {
                setState(() {
                  _goal = v!;
                  _goalKgPerWeek = 0;
                });
              }),

              // kg/week selector
              if (_kgOptions(l10n).isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  _goal == l10n.loseWeight ? l10n.lossRhythm : l10n.gainRhythm,
                  style: const TextStyle(fontSize: 11, color: AppTheme.muted, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _kgOptions(l10n).map((v) {
                    final sel = _goalKgPerWeek == v;
                    final kcalDelta = (v * 7700 / 7).abs().round();
                    return GestureDetector(
                      onTap: () => setState(() => _goalKgPerWeek = v),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: sel ? AppTheme.accent : AppTheme.surface2,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: sel ? AppTheme.accent : AppTheme.border),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _kgLabel(v, l10n),
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: sel ? AppTheme.bg : AppTheme.text),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${v.abs()} kg/sem',
                              style: TextStyle(fontSize: 11, color: sel ? AppTheme.bg.withAlpha(180) : AppTheme.muted),
                            ),
                            Text(
                              '${_goal == l10n.loseWeight ? "-" : "+"}$kcalDelta kcal/j',
                              style: TextStyle(fontSize: 10, color: sel ? AppTheme.bg.withAlpha(150) : AppTheme.muted),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (_goalKgPerWeek != 0 && !widget.profile.copyWith(goalKgPerWeek: _goalKgPerWeek, goal: _goal).isGoalRealistic) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.withAlpha(80)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.aggressiveWarning,
                            style: const TextStyle(fontSize: 12, color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 14),
              _dropdownField(l10n.activityLevel, _activity, _activities(l10n), (v) => setState(() => _activity = v!)),
              const SizedBox(height: 20),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _save(l10n),
                  child: Text(l10n.saveProfile),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(onLogout: widget.onLogout))),
                  icon: const Icon(Icons.manage_accounts_rounded, size: 18),
                  label: Text(l10n.myAccount),
                ),
              ),
              const SizedBox(height: 24),

              // App info
              Text(l10n.appInfo.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.muted, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              ...[
                (l10n.version, '1.0.0'),
              ].map((r) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.border))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(r.$1, style: const TextStyle(color: AppTheme.muted, fontSize: 14)),
                        Text(r.$2, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      ],
                    ),
                  )),
              const SizedBox(height: 30),
            ],
          ),
        ),

        // Toast
        if (_toast != null)
          Positioned(
            top: 20, left: 0, right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(100)),
                child: Text(_toast!, style: const TextStyle(color: AppTheme.bg, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.muted, letterSpacing: 0.5));

  Widget _field(String label, String initial, void Function(String) onChanged, {bool numeric = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 11, color: AppTheme.muted, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initial,
          keyboardType: numeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(hintText: hint),
          style: const TextStyle(color: AppTheme.text),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _dropdownField(String label, String value, List<String> options, void Function(String?) onChanged) {
    final safeValue = options.contains(value) ? value : options.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 11, color: AppTheme.muted, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: safeValue,
          dropdownColor: AppTheme.surface,
          decoration: const InputDecoration(),
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _GenderButton({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppTheme.accent : AppTheme.surface2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? AppTheme.accent : AppTheme.border, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: selected ? AppTheme.bg : AppTheme.muted),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: selected ? AppTheme.bg : AppTheme.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
