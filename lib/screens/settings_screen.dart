import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import '../services/storage_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

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
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l.logout,
              style: const TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w700)),
          content: Text(
            l.logoutConfirm,
            style: const TextStyle(color: AppTheme.muted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.logoutCancel,
                  style: const TextStyle(color: AppTheme.muted)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.logoutConfirmButton,
                  style: const TextStyle(color: AppTheme.accent3)),
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
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface,
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
                style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
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
                        color:
                            isSelected ? AppTheme.accent : AppTheme.text)),
                trailing: isSelected
                    ? const Icon(Icons.check_circle,
                        color: AppTheme.accent, size: 20)
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
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final currentLang = LocaleProvider.supportedLanguages.firstWhere(
      (l) => l.$1 == localeProvider.locale.languageCode,
      orElse: () => LocaleProvider.supportedLanguages.first,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.muted),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.myAccount),
        actions: [
          if (_refreshingPlan)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accent),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppTheme.muted, size: 20),
              tooltip: l10n.refresh,
              onPressed: _refreshFromServer,
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.accent))
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
                          style: const TextStyle(
                              color: AppTheme.muted, fontSize: 13),
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
                        color: AppTheme.surface2,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          Text(currentLang.$3,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(currentLang.$2,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const Icon(Icons.expand_more,
                              color: AppTheme.muted, size: 20),
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
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppTheme.accent3))
                          : const Icon(Icons.logout_rounded,
                              color: AppTheme.accent3, size: 18),
                      label: Text(
                          _loggingOut ? l10n.loggingOut : l10n.logout,
                          style: const TextStyle(color: AppTheme.accent3)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: AppTheme.accent3.withAlpha(128)),
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
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.accent.withAlpha(24),
        border: Border.all(color: AppTheme.accent.withAlpha(80), width: 2),
      ),
      child: Center(
        child: Text(
          _initials,
          style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.accent),
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
  Color _color(String p) {
    switch (p) {
      case 'premium': return AppTheme.accent;
      case 'pro':     return const Color(0xFFAB82FF);
      case 'starter': return AppTheme.accent2;
      default:        return AppTheme.muted;
    }
  }

  IconData _icon(String p) {
    switch (p) {
      case 'premium': return Icons.star_rounded;
      case 'pro':     return Icons.workspace_premium_rounded;
      case 'starter': return Icons.rocket_launch_rounded;
      default:        return Icons.person_outline_rounded;
    }
  }

  String _label(String p, AppLocalizations l10n) {
    switch (p) {
      case 'premium': return 'Premium';
      case 'pro':     return 'Pro';
      case 'starter': return 'Starter';
      default:        return l10n.freeLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawPlan = (plan ?? 'free').toLowerCase();
    final color   = _color(rawPlan);
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
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.muted,
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
                      ? AppTheme.accent.withAlpha(24)
                      : AppTheme.accent3.withAlpha(24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      size: 12,
                      color: isActive ? AppTheme.accent : AppTheme.accent3,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? 'Actif' : 'Inactif',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive ? AppTheme.accent : AppTheme.accent3,
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
                    ? AppTheme.accent.withAlpha(14)
                    : AppTheme.accent3.withAlpha(14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.hourglass_top_rounded,
                    size: 14,
                    color: trialDays > 3 ? AppTheme.accent : AppTheme.accent3,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    trialDays == 0
                        ? 'Essai expiré'
                        : trialDays == 1
                            ? 'Essai : 1 jour restant'
                            : 'Essai : $trialDays jours restants',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: trialDays > 3 ? AppTheme.accent : AppTheme.accent3,
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
                    ? AppTheme.accent.withAlpha(180)
                    : AppTheme.muted,
              ),
              const SizedBox(width: 4),
              Text(
                serverRefreshed ? 'Vérifié depuis le serveur' : 'Cache local',
                style: TextStyle(
                  fontSize: 11,
                  color: serverRefreshed
                      ? AppTheme.accent.withAlpha(180)
                      : AppTheme.muted,
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
    return Text(text,
        style: const TextStyle(
            fontSize: 11,
            color: AppTheme.muted,
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(color: AppTheme.muted, fontSize: 13)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
