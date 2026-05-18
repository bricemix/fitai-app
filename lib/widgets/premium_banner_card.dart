import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../screens/subscription_screen.dart';

/// Bannière animée "Go Premium" — partagée entre DashboardScreen et ProfileScreen.
/// Affiche un glow pulsé, un compteur d'essai si [trialEndsAt] est défini,
/// et navigue vers SubscriptionScreen au tap.
class PremiumBannerCard extends StatefulWidget {
  final DateTime? trialEndsAt;
  const PremiumBannerCard({super.key, this.trialEndsAt});

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

  String? _trialLabel(AppLocalizations l10n) {
    if (widget.trialEndsAt == null) return null;
    final diff = widget.trialEndsAt!.difference(DateTime.now());
    if (diff.isNegative) return null;
    final days = diff.inDays;
    if (days == 0) return l10n.trialExpiredToday;
    return l10n.trialDaysRemaining(days);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final trialLabel = _trialLabel(l10n);

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
                        AppTheme.accent.withAlpha(60),
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
                color: AppTheme.accent
                    .withAlpha((80 + (glow * 100).round()).clamp(0, 255)),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent
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
                    color: AppTheme.accent
                        .withAlpha((30 + (_glowAnim.value * 40).round())),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    color: AppTheme.accent,
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
                      l10n.goPremiumButton,
                      style: const TextStyle(
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
                        style: const TextStyle(
                            color: AppTheme.muted, fontSize: 12),
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
                    color: AppTheme.accent.withAlpha(
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
