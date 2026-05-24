import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../screens/subscription_screen.dart';

/// Bannière animée "Go Premium" — partagée entre DashboardScreen et ProfileScreen.
/// Affiche un glow pulsé, un compteur d'essai Starter si [trialEndsAt] est défini,
/// et navigue vers SubscriptionScreen au tap.
/// [currentPlan] : 'free' | 'starter' — détermine le titre affiché.
class PremiumBannerCard extends StatefulWidget {
  final DateTime? trialEndsAt;
  final String currentPlan;
  const PremiumBannerCard({
    super.key,
    this.trialEndsAt,
    this.currentPlan = 'free',
  });

  @override
  State<PremiumBannerCard> createState() => _PremiumBannerCardState();
}

class _PremiumBannerCardState extends State<PremiumBannerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Retourne le label du compteur d'essai Starter (null si pas de trial actif).
  String? _trialLabel(AppLocalizations l10n) {
    if (widget.trialEndsAt == null) return null;
    final diff = widget.trialEndsAt!.difference(DateTime.now());
    if (diff.isNegative) return null;
    final days = diff.inDays;
    if (days == 0) return l10n.trialExpiredToday;
    return l10n.trialDaysRemaining(days);
  }

  /// Titre principal selon le contexte :
  ///  - Trial Starter actif       → "Essai Starter · X jours restants"
  ///  - Starter sans trial        → "Passer à Pro ou Premium"
  ///  - Free sans trial           → texte Go Premium standard
  String _mainTitle(AppLocalizations l10n, String? trialLabel) {
    if (widget.currentPlan == 'starter') {
      return trialLabel != null
          ? 'Essai Starter'
          : l10n.goPremiumButton;
    }
    return l10n.goPremiumButton;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final trialLabel = _trialLabel(l10n);
    final mainTitle  = _mainTitle(l10n, trialLabel);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
      ),
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, child) {
          final glow = _glowAnim.value;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1A2A1A),
                  Color.lerp(
                        const Color(0xFF1A2A1A),
                        c.accent.withAlpha(60),
                        glow * 0.5,
                      ) ??
                      const Color(0xFF1A2A1A),
                  const Color(0xFF0A1A0A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: c.accent
                    .withAlpha((80 + (glow * 100).round()).clamp(0, 255)),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: c.accent
                      .withAlpha((30 + (glow * 60).round()).clamp(0, 255)),
                  blurRadius: 12 + glow * 8,
                  spreadRadius: glow * 2,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icône pulsée
              AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, __) => Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: c.accent
                        .withAlpha((30 + (_glowAnim.value * 40).round())),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.rocket_launch_rounded,
                    color: c.accent,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (trialLabel != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined,
                              color: Colors.orangeAccent, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            trialLabel,
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.premiumDesc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: c.muted, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Flèche pulsée
              AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, __) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.accent.withAlpha(
                        (180 + (_glowAnim.value * 75).round()).clamp(0, 255)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '→',
                    style: TextStyle(
                      color: Color(0xFF0A0A0F),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
