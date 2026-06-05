import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/profile.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import '../widgets/error_dialog.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/premium_banner_card.dart';
// ignore: unused_import
import 'subscription_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final void Function(UserProfile) onUpdate;
  final VoidCallback onLogout;
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

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tab;

  // ── Profile fields ─────────────────────────────────────────────────────────
  late String _name, _age, _weight, _height, _goal, _activity, _gender;
  late String _waistCm, _bicepsCm, _bellyCm;
  late double _goalKgPerWeek;
  String? _toast;
  bool _openingPortal = false;

  // ── Account data (loaded from cache + server) ──────────────────────────────
  Map<String, dynamic>? _user;
  SubscriptionStatus? _subscriptionStatus;
  bool _loadingAccount = true;
  bool _refreshingPlan = false;
  bool _loggingOut = false;

  // ── Options ────────────────────────────────────────────────────────────────
  List<String> _goals(AppLocalizations l) =>
      [l.loseWeight, l.gainMass, l.maintain, l.eatHealthy];
  List<String> _activities(AppLocalizations l) => [
        l.activitySedentary,
        l.activityLight,
        l.activityModerate,
        l.activityActive,
        l.activityVeryActive,
      ];

  static const _lossOptions = [-0.25, -0.5, -0.75, -1.0];
  static const _gainOptions = [0.1, 0.25, 0.5];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
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
    _loadAccount();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ── Account loading ────────────────────────────────────────────────────────
  Future<void> _loadAccount() async {
    final user = await AuthService.getCachedUser();
    if (mounted) setState(() { _user = user; _loadingAccount = false; });
    await _refreshFromServer();
  }

  Future<void> _refreshFromServer() async {
    if (!mounted) return;
    setState(() => _refreshingPlan = true);
    final status = await PaymentService.fetchSubscriptionStatus();
    if (!mounted) return;
    final fresh = await AuthService.getCachedUser();
    setState(() {
      _subscriptionStatus = status;
      if (fresh != null) _user = fresh;
      _refreshingPlan = false;
    });
  }

  // ── Save profile ───────────────────────────────────────────────────────────
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
    SyncService.uploadProfile(updated);
    widget.onUpdate(updated);
    _showToast(l.saveProfile);
  }

  Future<void> _openPortal(AppLocalizations l10n) async {
    setState(() => _openingPortal = true);
    try {
      final locale = Localizations.localeOf(context).languageCode;
      final url = await PaymentService.fetchPortalUrl(locale: locale);
      if (!mounted) return;
      final launched =
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (!launched && mounted) _showToast(l10n.portalError);
    } catch (e) {
      if (mounted) ErrorDialog.showForException(context, e);
    } finally {
      if (mounted) setState(() => _openingPortal = false);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx);
        final dc = AppTheme.of(ctx);
        return AlertDialog(
          backgroundColor: dc.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l.logout,
              style: TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w700, color: dc.text)),
          content: Text(l.logoutConfirm, style: TextStyle(color: dc.muted)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.logoutCancel, style: TextStyle(color: dc.muted))),
            TextButton(onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.logoutConfirmButton, style: TextStyle(color: dc.accent3))),
          ],
        );
      },
    );
    if (confirmed != true) return;
    setState(() => _loggingOut = true);
    await AuthService.logout();
    await StorageService.clearProfile();
    if (!mounted) return;
    widget.onLogout();
  }

  void _showLanguagePicker() {
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.read<LocaleProvider>();
    final dc = AppTheme.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: dc.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.chooseLanguage,
                style: TextStyle(fontFamily: 'Syne', fontSize: 17,
                    fontWeight: FontWeight.w700, color: dc.text)),
            const SizedBox(height: 14),
            ...LocaleProvider.supportedLanguages.map((lang) {
              final sel = localeProvider.locale.languageCode == lang.$1;
              return ListTile(
                leading: Text(lang.$3, style: const TextStyle(fontSize: 22)),
                title: Text(lang.$2,
                    style: TextStyle(
                        fontWeight: sel ? FontWeight.w700 : FontWeight.normal,
                        color: sel ? dc.accent : dc.text)),
                trailing: sel ? Icon(Icons.check_circle, color: dc.accent, size: 20) : null,
                onTap: () { localeProvider.setLocale(Locale(lang.$1)); Navigator.pop(context); },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showToast(String msg) {
    setState(() => _toast = msg);
    Future.delayed(const Duration(milliseconds: 2200), () {
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
      return {-0.25: l.soft, -0.5: l.moderate, -0.75: l.sustained, -1.0: l.intense}[v]
          ?? '${v.abs()} kg/sem';
    }
    return {0.1: l.lean, 0.25: l.moderate, 0.5: l.aggressive}[v] ?? '+$v kg/sem';
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.myProfile,
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 2),
                        Text(l10n.profileSubtitle,
                            style: TextStyle(color: c.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Tab bar ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 42,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: c.surface2,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.border),
                ),
                child: TabBar(
                  controller: _tab,
                  indicator: BoxDecoration(
                    color: c.accent,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: c.bg,
                  unselectedLabelColor: c.muted,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 12),
                  unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_rounded, size: 14),
                          const SizedBox(width: 5),
                          Text(l10n.myProfile),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.manage_accounts_rounded, size: 14),
                          const SizedBox(width: 5),
                          Text(l10n.myAccount),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.flag_rounded, size: 14),
                          const SizedBox(width: 5),
                          Text(l10n.objective),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),

            // ── Tab views ───────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _ProfileTab(state: this, l10n: l10n),
                  _AccountTab(state: this, l10n: l10n),
                  _GoalTab(state: this, l10n: l10n),
                ],
              ),
            ),
          ],
        ),

        // Toast
        if (_toast != null)
          Positioned(
            top: 20, left: 0, right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: c.accent, borderRadius: BorderRadius.circular(100)),
                child: Text(_toast!,
                    style: TextStyle(
                        color: c.bg, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1 — PROFILE
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  final _ProfileScreenState state;
  final AppLocalizations l10n;
  const _ProfileTab({required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final bmi = state.widget.profile.bmi;
    final bmiStr = bmi == 0 ? '—' : bmi.toStringAsFixed(1);
    final bmiColor = bmi == 0
        ? c.muted
        : bmi < 18.5
            ? const Color(0xFF60A5FA)   // blue-400
            : bmi < 25
                ? const Color(0xFF34D399) // emerald-400
                : bmi < 30
                    ? const Color(0xFFFBBF24) // amber-400
                    : const Color(0xFFF97316); // orange-500 (pas rouge vif)
    final bmiLabel = bmi == 0
        ? ''
        : bmi < 18.5
            ? l10n.bmiUnderweight
            : bmi < 25
                ? l10n.bmiNormal
                : bmi < 30
                    ? l10n.bmiOverweight
                    : l10n.bmiObese;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── BMI card (full width) ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.bmi,
                          style: TextStyle(fontSize: 11, color: c.muted,
                              fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      Text(bmiStr,
                          style: TextStyle(fontFamily: 'Syne', fontSize: 34,
                              fontWeight: FontWeight.w800, color: bmiColor, height: 1.1)),
                      if (bmiLabel.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: bmiColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(bmiLabel,
                              style: TextStyle(fontSize: 11, color: bmiColor,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ),
                // Mini stats
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _MiniStat(Icons.local_fire_department_rounded,
                        '${state.widget.profile.tdee.round()} kcal', c.accent),
                    const SizedBox(height: 6),
                    _MiniStat(Icons.bolt_rounded,
                        state._activity.split(' ').first, c.muted),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Upgrade banner ─────────────────────────────────────────────────
          if (state.widget.userPlan == 'free' || state.widget.userPlan == 'starter') ...[
            PremiumBannerCard(
              trialEndsAt: state.widget.trialEndsAt,
              currentPlan: state.widget.userPlan,
            ),
            const SizedBox(height: 16),
          ],

          // ── Gender ─────────────────────────────────────────────────────────
          _SectionHeader(Icons.wc_rounded, l10n.gender, c),
          const SizedBox(height: 8),
          Row(
            children: [
              _GenderChip(
                label: l10n.male,
                emoji: '♂',
                selected: state._gender == 'homme',
                // ignore: invalid_use_of_protected_member
                onTap: () => state.setState(() => state._gender = 'homme'),
                c: c,
              ),
              const SizedBox(width: 10),
              _GenderChip(
                label: l10n.female,
                emoji: '♀',
                selected: state._gender == 'femme',
                // ignore: invalid_use_of_protected_member
                onTap: () => state.setState(() => state._gender = 'femme'),
                c: c,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Name + Age ─────────────────────────────────────────────────────
          _SectionHeader(Icons.badge_rounded, l10n.identity, c),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _IconField(
                  icon: Icons.person_outline_rounded,
                  iconColor: const Color(0xFF7B8CFF),
                  label: l10n.yourFirstName,
                  initial: state._name,
                  onChanged: (v) => state._name = v,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _IconField(
                  icon: Icons.cake_rounded,
                  iconColor: const Color(0xFFFF9F7B),
                  label: l10n.age,
                  initial: state._age,
                  onChanged: (v) => state._age = v,
                  numeric: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Weight + Height ────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _IconField(
                  icon: Icons.monitor_weight_outlined,
                  iconColor: const Color(0xFF7EC8E3),
                  label: l10n.weight,
                  initial: state._weight,
                  onChanged: (v) => state._weight = v,
                  numeric: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _IconField(
                  icon: Icons.straighten_rounded,
                  iconColor: const Color(0xFFA78BFA),
                  label: l10n.height,
                  initial: state._height,
                  onChanged: (v) => state._height = v,
                  numeric: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Body measurements ──────────────────────────────────────────────
          _SectionHeader(Icons.accessibility_new_rounded, l10n.bodyMeasurementsLabel, c),
          const SizedBox(height: 4),
          Text(l10n.bodyMeasurementsHintProfile,
              style: TextStyle(fontSize: 12, color: c.muted)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _IconField(
                  icon: Icons.radio_button_checked_rounded,
                  iconColor: const Color(0xFFFF7BAC),
                  label: l10n.waist,
                  initial: state._waistCm,
                  onChanged: (v) => state._waistCm = v,
                  numeric: true,
                  hint: 'ex: 80',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _IconField(
                  icon: Icons.fitness_center_rounded,
                  iconColor: const Color(0xFF4ADE80),
                  label: l10n.biceps,
                  initial: state._bicepsCm,
                  onChanged: (v) => state._bicepsCm = v,
                  numeric: true,
                  hint: 'ex: 35',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _IconField(
            icon: Icons.airline_seat_recline_normal_rounded,
            iconColor: const Color(0xFFFBBF24),
            label: l10n.belly,
            initial: state._bellyCm,
            onChanged: (v) => state._bellyCm = v,
            numeric: true,
            hint: 'ex: 90',
          ),
          const SizedBox(height: 24),

          // ── Save ───────────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => state._save(l10n),
              icon: const Icon(Icons.save_rounded, size: 18),
              label: Text(l10n.saveProfile),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2 — ACCOUNT
// ─────────────────────────────────────────────────────────────────────────────

class _AccountTab extends StatelessWidget {
  final _ProfileScreenState state;
  final AppLocalizations l10n;
  const _AccountTab({required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final currentLang = LocaleProvider.supportedLanguages.firstWhere(
      (l) => l.$1 == localeProvider.locale.languageCode,
      orElse: () => LocaleProvider.supportedLanguages.first,
    );
    final user = state._user;
    final planStr = state._subscriptionStatus?.plan
        ?? user?['plan'] as String?
        ?? user?['subscription_plan'] as String?
        ?? 'free';
    final isPremium = planStr != 'free' && planStr != 'starter';

    if (state._loadingAccount) {
      return Center(child: CircularProgressIndicator(color: c.accent));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar + name ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.surface, Color(0xFF1a1a30)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.surface2,
                    border: Border.all(color: c.border, width: 2),
                  ),
                  child: Icon(Icons.person_rounded, size: 32, color: c.muted),
                ),
                const SizedBox(height: 12),
                Text(
                  user?['name'] as String? ?? l10n.userLabel,
                  style: const TextStyle(fontFamily: 'Syne', fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(user?['email'] as String? ?? '',
                    style: TextStyle(color: c.muted, fontSize: 13)),
                const SizedBox(height: 12),
                // Plan badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPremium ? c.accent.withAlpha(25) : c.surface2,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isPremium ? c.accent.withAlpha(80) : c.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPremium ? Icons.workspace_premium_rounded : Icons.lock_outline_rounded,
                        size: 14,
                        color: isPremium ? c.accent : c.muted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        planStr.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isPremium ? c.accent : c.muted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Subscription management ────────────────────────────────────────
          if (state.widget.userPlan == 'free' || state.widget.userPlan == 'starter') ...[
            PremiumBannerCard(
                trialEndsAt: state.widget.trialEndsAt,
                currentPlan: state.widget.userPlan),
            const SizedBox(height: 16),
          ] else ...[
            _AccountRow(
              icon: Icons.credit_card_rounded,
              iconColor: const Color(0xFF7B8CFF),
              label: l10n.manageSubscription,
              subtitle: l10n.manageSubscriptionDesc,
              trailing: state._openingPortal
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: c.accent),
                    )
                  : Icon(Icons.open_in_new_rounded, color: c.muted, size: 16),
              onTap: state._openingPortal
                  ? null
                  : () => state._openPortal(l10n),
            ),
            const SizedBox(height: 10),
          ],

          // ── Settings rows ──────────────────────────────────────────────────
          _SectionHeader(Icons.settings_rounded, 'PARAMÈTRES', c),
          const SizedBox(height: 10),

          _AccountRow(
            icon: Icons.translate_rounded,
            iconColor: const Color(0xFF4ADE80),
            label: l10n.language,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentLang.$3, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(currentLang.$2,
                    style: TextStyle(color: c.muted, fontSize: 13)),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, color: c.muted, size: 18),
              ],
            ),
            onTap: state._showLanguagePicker,
          ),
          const SizedBox(height: 10),

          _AccountRow(
            icon: themeProvider.isDark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            iconColor: const Color(0xFFFBBF24),
            label: themeProvider.isDark
                ? (Localizations.localeOf(context).languageCode == 'fr' ? 'Mode sombre' : 'Dark mode')
                : (Localizations.localeOf(context).languageCode == 'fr' ? 'Mode clair' : 'Light mode'),
            trailing: Switch.adaptive(
              value: !themeProvider.isDark,
              activeTrackColor: c.accent,
              onChanged: (_) => themeProvider.toggle(),
            ),
            onTap: () => themeProvider.toggle(),
          ),
          const SizedBox(height: 20),

          // ── Account details ────────────────────────────────────────────────
          _SectionHeader(Icons.info_outline_rounded, l10n.information.toUpperCase(), c),
          const SizedBox(height: 10),
          _AccountRow(
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF7B8CFF),
            label: l10n.name,
            trailing: Text(user?['name'] as String? ?? '—',
                style: TextStyle(color: c.muted, fontSize: 13)),
          ),
          const SizedBox(height: 8),
          _AccountRow(
            icon: Icons.email_outlined,
            iconColor: const Color(0xFF60A5FA),
            label: l10n.emailLabel,
            trailing: Text(user?['email'] as String? ?? '—',
                style: TextStyle(color: c.muted, fontSize: 13)),
          ),
          if ((user?['phone'] as String?)?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            _AccountRow(
              icon: Icons.phone_outlined,
              iconColor: const Color(0xFF4ADE80),
              label: l10n.phoneLabel,
              trailing: Text(user!['phone'] as String,
                  style: TextStyle(color: c.muted, fontSize: 13)),
            ),
          ],
          const SizedBox(height: 24),

          // ── Refresh + Logout ───────────────────────────────────────────────
          _AccountRow(
            icon: Icons.refresh_rounded,
            iconColor: c.muted,
            label: l10n.refresh,
            trailing: state._refreshingPlan
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: c.accent),
                  )
                : Icon(Icons.chevron_right_rounded, color: c.muted, size: 18),
            onTap: state._refreshingPlan ? null : state._refreshFromServer,
          ),
          const SizedBox(height: 10),

          _AccountRow(
            icon: Icons.logout_rounded,
            iconColor: const Color(0xFFE57373),
            label: l10n.logout,
            labelColor: const Color(0xFFE57373),
            trailing: state._loggingOut
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child:
                        CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE57373)),
                  )
                : null,
            onTap: state._loggingOut ? null : state._logout,
          ),
          const SizedBox(height: 24),

          // ── App info ───────────────────────────────────────────────────────
          Center(
            child: Text('DietVision · v1.0.0+29',
                style: TextStyle(fontSize: 11, color: c.muted)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3 — GOAL & PLAN
// ─────────────────────────────────────────────────────────────────────────────

class _GoalTab extends StatelessWidget {
  final _ProfileScreenState state;
  final AppLocalizations l10n;
  const _GoalTab({required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final goalOptions = state._goals(l10n);
    final activityOptions = state._activities(l10n);
    final kgOpts = state._kgOptions(l10n);
    final targetKcal = state.widget.profile.tdee.round();
    final kcalDelta = state._goalKgPerWeek != 0
        ? (state._goalKgPerWeek * 7700 / 7).round().abs()
        : 0;
    final netKcal = state._goalKgPerWeek < 0
        ? targetKcal - kcalDelta
        : state._goalKgPerWeek > 0
            ? targetKcal + kcalDelta
            : targetKcal;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Summary card ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.surface, Color(0xFF1a1a30)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: c.accent.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_goalIcon(state._goal, l10n), color: c.accent, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.goalLabel,
                          style: TextStyle(fontSize: 11, color: c.muted,
                              fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      Text(state._goal.isEmpty ? '—' : state._goal,
                          style: const TextStyle(fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(state._activity,
                          style: TextStyle(fontSize: 12, color: c.muted)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$netKcal kcal',
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w800, color: c.accent,
                            fontFamily: 'Syne')),
                    Text('/ jour', style: TextStyle(fontSize: 11, color: c.muted)),
                    if (state._goalKgPerWeek != 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${state._goalKgPerWeek < 0 ? "-" : "+"}${kcalDelta} kcal/j',
                        style: TextStyle(fontSize: 11,
                            color: state._goalKgPerWeek < 0
                                ? Colors.orange
                                : const Color(0xFF4ADE80)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── 1. Objective ───────────────────────────────────────────────────
          _SectionHeader(Icons.gps_fixed_rounded, '1. ${l10n.objective}', c),
          const SizedBox(height: 10),
          _GoalSelector(
            options: goalOptions,
            selected: state._goal,
            // ignore: invalid_use_of_protected_member
            onSelect: (v) => state.setState(() {
              state._goal = v;
              state._goalKgPerWeek = 0;
            }),
            c: c,
            l10n: l10n,
          ),
          const SizedBox(height: 20),

          // ── 2. Rate ────────────────────────────────────────────────────────
          if (kgOpts.isNotEmpty) ...[
            _SectionHeader(
              Icons.speed_rounded,
              '2. ${state._goal == l10n.loseWeight ? l10n.lossRhythm : l10n.gainRhythm}',
              c,
            ),
            const SizedBox(height: 10),
            _RateCards(
              options: kgOpts,
              selected: state._goalKgPerWeek,
              // ignore: invalid_use_of_protected_member
              onSelect: (v) => state.setState(() => state._goalKgPerWeek = v),
              isLoss: state._goal == l10n.loseWeight,
              kgLabel: (v) => state._kgLabel(v, l10n),
              c: c,
            ),
            // Warning
            if (state._goalKgPerWeek != 0 &&
                !state.widget.profile
                    .copyWith(goalKgPerWeek: state._goalKgPerWeek, goal: state._goal)
                    .isGoalRealistic) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l10n.aggressiveWarning,
                          style: const TextStyle(fontSize: 12, color: Colors.orange)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],

          // ── 3. Activity level ──────────────────────────────────────────────
          _SectionHeader(Icons.directions_run_rounded, '3. ${l10n.activityLevel}', c),
          const SizedBox(height: 10),
          _ActivitySelector(
            options: activityOptions,
            selected: state._activity,
            // ignore: invalid_use_of_protected_member
            onSelect: (v) => state.setState(() => state._activity = v),
            c: c,
          ),
          const SizedBox(height: 24),

          // ── Save ───────────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => state._save(l10n),
              icon: const Icon(Icons.save_rounded, size: 18),
              label: Text(l10n.saveProfile),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  IconData _goalIcon(String goal, AppLocalizations l) {
    if (goal == l.loseWeight) return Icons.trending_down_rounded;
    if (goal == l.gainMass) return Icons.trending_up_rounded;
    if (goal == l.maintain) return Icons.balance_rounded;
    return Icons.restaurant_menu_rounded;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────


class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MiniStat(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      );
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppColors c;
  const _SectionHeader(this.icon, this.label, this.c);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 14, color: c.muted),
          const SizedBox(width: 6),
          Text(label.toUpperCase(),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: c.muted, letterSpacing: 0.5)),
        ],
      );
}

class _IconField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String initial;
  final void Function(String) onChanged;
  final bool numeric;
  final String? hint;
  const _IconField({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.initial,
    required this.onChanged,
    this.numeric = false,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 13, color: iconColor),
            ),
            const SizedBox(width: 6),
            Text(label.toUpperCase(),
                style: TextStyle(fontSize: 10, color: c.muted,
                    fontWeight: FontWeight.w600, letterSpacing: 0.4)),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: initial,
          keyboardType: numeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(hintText: hint),
          style: TextStyle(color: c.text),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;
  final AppColors c;
  const _GenderChip(
      {required this.label, required this.emoji, required this.selected,
      required this.onTap, required this.c});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? c.accent : c.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: selected ? c.accent : c.border, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji,
                    style: TextStyle(fontSize: 18,
                        color: selected ? c.bg : c.muted)),
                const SizedBox(width: 8),
                Text(label,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14,
                        color: selected ? c.bg : c.muted)),
              ],
            ),
          ),
        ),
      );
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color? labelColor;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _AccountRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.labelColor,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(22),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: labelColor ?? c.text)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: TextStyle(fontSize: 11, color: c.muted, height: 1.4)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _GoalSelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final void Function(String) onSelect;
  final AppColors c;
  final AppLocalizations l10n;
  const _GoalSelector({required this.options, required this.selected,
      required this.onSelect, required this.c, required this.l10n});

  IconData _icon(String g) {
    if (g == l10n.loseWeight) return Icons.trending_down_rounded;
    if (g == l10n.gainMass)   return Icons.trending_up_rounded;
    if (g == l10n.maintain)   return Icons.balance_rounded;
    return Icons.restaurant_menu_rounded;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: options.map((opt) {
          final sel = selected == opt;
          return GestureDetector(
            onTap: () => onSelect(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: sel ? c.accent.withAlpha(20) : c.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: sel ? c.accent : c.border, width: sel ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: sel ? c.accent.withAlpha(30) : c.surface2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_icon(opt),
                        color: sel ? c.accent : c.muted, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(opt,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: sel ? c.accent : c.text)),
                  ),
                  if (sel)
                    Icon(Icons.check_circle_rounded, color: c.accent, size: 20),
                ],
              ),
            ),
          );
        }).toList(),
      );
}

class _RateCards extends StatelessWidget {
  final List<double> options;
  final double selected;
  final void Function(double) onSelect;
  final bool isLoss;
  final String Function(double) kgLabel;
  final AppColors c;
  const _RateCards({
    required this.options, required this.selected, required this.onSelect,
    required this.isLoss, required this.kgLabel, required this.c,
  });

  static const _rateIcons = [
    Icons.signal_cellular_alt_1_bar_rounded,
    Icons.signal_cellular_alt_2_bar_rounded,
    Icons.signal_cellular_alt_rounded,
    Icons.local_fire_department_rounded,
  ];

  @override
  Widget build(BuildContext context) => Row(
        children: List.generate(options.length, (i) {
          final v = options[i];
          final sel = selected == v;
          final kcalD = (v * 7700 / 7).round().abs();
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: EdgeInsets.only(right: i < options.length - 1 ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                decoration: BoxDecoration(
                  color: sel ? c.accent.withAlpha(20) : c.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: sel ? c.accent : c.border,
                      width: sel ? 1.5 : 1),
                ),
                child: Column(
                  children: [
                    if (sel)
                      Icon(Icons.check_circle_rounded, color: c.accent, size: 16)
                    else
                      Icon(
                        i < _rateIcons.length ? _rateIcons[i] : Icons.speed_rounded,
                        color: c.muted, size: 16,
                      ),
                    const SizedBox(height: 6),
                    Text(kgLabel(v),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12,
                            color: sel ? c.accent : c.text)),
                    const SizedBox(height: 2),
                    Text('${v.abs()} kg/sem',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: c.muted)),
                    Text('${isLoss ? "-" : "+"}$kcalD kcal/j',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: c.muted)),
                  ],
                ),
              ),
            ),
          );
        }),
      );
}

class _ActivitySelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final void Function(String) onSelect;
  final AppColors c;
  const _ActivitySelector({required this.options, required this.selected,
      required this.onSelect, required this.c});

  static const _icons = [
    Icons.weekend_rounded,
    Icons.directions_walk_rounded,
    Icons.directions_bike_rounded,
    Icons.directions_run_rounded,
    Icons.sports_gymnastics_rounded,
  ];

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(options.length, (i) {
          final opt = options[i];
          final sel = selected == opt;
          return GestureDetector(
            onTap: () => onSelect(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: sel ? c.accent.withAlpha(20) : c.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: sel ? c.accent : c.border,
                    width: sel ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Icon(i < _icons.length ? _icons[i] : Icons.sports_rounded,
                      color: sel ? c.accent : c.muted, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(opt,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                            color: sel ? c.accent : c.text)),
                  ),
                  if (sel)
                    Icon(Icons.check_circle_rounded, color: c.accent, size: 18),
                ],
              ),
            ),
          );
        }),
      );
}
