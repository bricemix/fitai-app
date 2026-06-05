import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import '../services/storage_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';

/// Account info screen — shown from the Profile tab.
/// Displays cached user data (name, email, plan) and a logout button.
class SettingsScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const SettingsScreen({super.key, required this.onLogout});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? _user;
  SubscriptionStatus? _subscriptionStatus;
  bool _loading = true;
  bool _refreshingPlan = false;
  bool _serverRefreshed = false; // true une fois les données reçues du serveur
  bool _loggingOut = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // 1. Cache local d'abord (affichage immédiat)
    final user = await AuthService.getCachedUser();
    if (mounted) setState(() { _user = user; _loading = false; });

    // 2. Refresh depuis le serveur en arrière-plan
    await _refreshFromServer();
  }

  Future<void> _refreshFromServer() async {
    setState(() => _refreshingPlan = true);
    final status = await PaymentService.fetchSubscriptionStatus();
    if (!mounted) return;
    // Le cache a été mis à jour par fetchSubscriptionStatus — relire
    final freshUser = await AuthService.getCachedUser();
    setState(() {
      _subscriptionStatus = status;
      if (freshUser != null) _user = freshUser;
      _refreshingPlan = false;
      _serverRefreshed = true;
    });
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
          content: Text(
            l.logoutConfirm,
            style: TextStyle(color: dc.muted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.logoutCancel,
                  style: TextStyle(color: dc.muted)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.logoutConfirmButton,
                  style: TextStyle(color: dc.accent3)),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    setState(() => _loggingOut = true);
    await AuthService.logout(); // invalide le session_token côté serveur
    await StorageService.clearProfile();
    if (!mounted) return;
    Navigator.pop(context); // close this screen first
    widget.onLogout();
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.read<LocaleProvider>();
    final dc = AppTheme.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: dc.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.chooseLanguage,
                style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: dc.text)),
            const SizedBox(height: 14),
            ...LocaleProvider.supportedLanguages.map((lang) {
              final isSelected =
                  localeProvider.locale.languageCode == lang.$1;
              return ListTile(
                leading: Text(lang.$3, style: const TextStyle(fontSize: 22)),
                title: Text(lang.$2,
                    style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                        color: isSelected ? dc.accent : dc.text)),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: dc.accent, size: 20)
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
    final c = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final themeProvider  = context.watch<ThemeProvider>();
    final currentLang = LocaleProvider.supportedLanguages.firstWhere(
      (l) => l.$1 == localeProvider.locale.languageCode,
      orElse: () => LocaleProvider.supportedLanguages.first,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: c.muted),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.myAccount),
        actions: [
          if (_refreshingPlan)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: c.accent),
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.refresh_rounded, color: c.muted, size: 20),
              tooltip: l10n.refresh,
              onPressed: _refreshFromServer,
            ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: c.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Avatar + name ──────────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        _Avatar(name: _user?['name'] as String? ?? '?'),
                        const SizedBox(height: 14),
                        Text(
                          _user?['name'] as String? ?? l10n.userLabel,
                          style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user?['email'] as String? ?? '',
                          style: TextStyle(color: c.muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Plan badge ─────────────────────────────────────────────
                  _PlanCard(
                    plan: _subscriptionStatus?.plan
                        ?? _user?['plan'] as String?
                        ?? _user?['subscription_plan'] as String?,
                    subscriptionStatus: _subscriptionStatus,
                    serverRefreshed: _serverRefreshed,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),

                  // ── Account details ────────────────────────────────────────
                  _SectionTitle(l10n.information.toUpperCase()),
                  const SizedBox(height: 10),
                  _InfoRow(l10n.name, _user?['name'] as String? ?? '—'),
                  _InfoRow(l10n.emailLabel, _user?['email'] as String? ?? '—'),
                  if ((_user?['phone'] as String?)?.isNotEmpty == true)
                    _InfoRow(l10n.phoneLabel, _user!['phone'] as String),
                  if ((_user?['country'] as String?)?.isNotEmpty == true)
                    _InfoRow(l10n.countryLabel, _user!['country'] as String),
                  const SizedBox(height: 28),

                  // ── Appearance (theme toggle) ──────────────────────────────
                  _SectionTitle('APPARENCE'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: c.surface2,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: c.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          themeProvider.isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          size: 20,
                          color: c.accent,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            themeProvider.isDark ? 'Mode sombre' : 'Mode clair',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: c.text,
                            ),
                          ),
                        ),
                        Switch.adaptive(
                          value: !themeProvider.isDark,
                          activeColor: c.accent,
                          onChanged: (_) => themeProvider.toggle(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Language picker ────────────────────────────────────────
                  _SectionTitle(l10n.language.toUpperCase()),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _showLanguagePicker(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: c.surface2,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: c.border),
                      ),
                      child: Row(
                        children: [
                          Text(currentLang.$3,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(currentLang.$2,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: c.text)),
                          ),
                          Icon(Icons.expand_more,
                              color: c.muted, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Logout ─────────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _loggingOut ? null : _logout,
                      icon: _loggingOut
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: c.accent3))
                          : Icon(Icons.logout_rounded,
                              color: c.accent3, size: 18),
                      label: Text(
                          _loggingOut ? l10n.loggingOut : l10n.logout,
                          style: TextStyle(color: c.accent3)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: c.accent3.withAlpha(128)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

// ── Widgets ────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  String get _initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.accent.withAlpha(24),
        border: Border.all(color: c.accent.withAlpha(80), width: 2),
      ),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: c.accent),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String? plan;
  final SubscriptionStatus? subscriptionStatus;
  final bool serverRefreshed;
  final AppLocalizations l10n;

  const _PlanCard({
    this.plan,
    this.subscriptionStatus,
    this.serverRefreshed = false,
    required this.l10n,
  });

  // ── Couleur selon le plan ────────────────────────────────────────────────
  Color _color(String p, AppColors c) {
    switch (p) {
      case 'vip':     return const Color(0xFFFFD700); // or
      case 'premium': return c.accent;
      case 'pro':     return const Color(0xFFAB82FF);
      case 'starter': return c.accent2;
      default:        return c.muted;
    }
  }

  IconData _icon(String p) {
    switch (p) {
      case 'vip':     return Icons.diamond_rounded;
      case 'premium': return Icons.star_rounded;
      case 'pro':     return Icons.workspace_premium_rounded;
      case 'starter': return Icons.rocket_launch_rounded;
      default:        return Icons.person_outline_rounded;
    }
  }

  String _label(String p, AppLocalizations l10n) {
    switch (p) {
      case 'vip':     return 'VIP 💎';
      case 'premium': return 'Premium';
      case 'pro':     return 'Pro';
      case 'starter': return 'Starter';
      default:        return l10n.freeLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final rawPlan = (plan ?? 'free').toLowerCase();
    final color   = _color(rawPlan, c);
    final icon    = _icon(rawPlan);
    final label   = _label(rawPlan, l10n);
    final isPaid  = rawPlan != 'free';

    final status = subscriptionStatus;
    final trialDays = status?.trialDaysRemaining;
    final isActive  = status?.isActive ?? isPaid;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(isPaid ? 18 : 0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(isPaid ? 80 : 40)),
        gradient: isPaid
            ? LinearGradient(
                colors: [color.withAlpha(25), color.withAlpha(8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icône plan
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),

              // Nom du plan + label abonnement
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.subscription.toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          color: c.muted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: TextStyle(
                          fontFamily: 'Syne',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: color),
                    ),
                  ],
                ),
              ),

              // Badge actif / inactif
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? c.accent.withAlpha(24)
                      : c.accent3.withAlpha(24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      size: 12,
                      color: isActive ? c.accent : c.accent3,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? l10n.statusActive : l10n.statusInactive,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive ? c.accent : c.accent3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Trial restant ──────────────────────────────────────────────
          if (trialDays != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: trialDays > 3
                    ? c.accent.withAlpha(14)
                    : c.accent3.withAlpha(14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.hourglass_top_rounded,
                    size: 14,
                    color: trialDays > 3 ? c.accent : c.accent3,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    trialDays == 0
                        ? l10n.trialExpiredToday
                        : l10n.trialDaysRemaining(trialDays),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: trialDays > 3 ? c.accent : c.accent3,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Indicateur source serveur ──────────────────────────────────
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                serverRefreshed ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                size: 12,
                color: serverRefreshed
                    ? c.accent.withAlpha(180)
                    : c.muted,
              ),
              const SizedBox(width: 4),
              Text(
                serverRefreshed ? l10n.verifiedFromServer : l10n.localCache,
                style: TextStyle(
                  fontSize: 11,
                  color: serverRefreshed
                      ? c.accent.withAlpha(180)
                      : c.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Text(text,
        style: TextStyle(
            fontSize: 11,
            color: c.muted,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5));
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: c.muted, fontSize: 13)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: c.text)),
          ),
        ],
      ),
    );
  }
}
