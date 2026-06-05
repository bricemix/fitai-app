import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/ai_service.dart';
import '../theme.dart';
import '../screens/subscription_screen.dart';

void showLimitDialog(BuildContext context, AiLimitException e) {
  final l10n = AppLocalizations.of(context);
  final c = AppTheme.of(context);

  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 52, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ProBadge(accent: c.accent),
                  const SizedBox(height: 16),
                  Text(
                    l10n.limitReachedTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: c.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: c.accent.withAlpha(80)),
                      borderRadius: BorderRadius.circular(20),
                      color: c.accent.withAlpha(12),
                    ),
                    child: Text(
                      l10n.limitUsedPill(e.used, e.limit, e.type),
                      style: TextStyle(
                        color: c.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.limitReachedBody(e.type, e.limit),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: c.muted, fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  _ProFeaturesBox(l10n: l10n, c: c),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => const SubscriptionScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                      label: Text(
                        l10n.continueWithPro,
                        style: const TextStyle(
                          fontFamily: 'Syne',
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.accent,
                        foregroundColor: c.bg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      l10n.comeBackTomorrow,
                      style: TextStyle(
                        color: c.muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.surface2,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded, color: c.muted, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── PRO badge (pentagon + crown + "PRO" chip) ─────────────────────────────────

class _ProBadge extends StatelessWidget {
  final Color accent;
  const _ProBadge({required this.accent});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD060);
    return SizedBox(
      width: 84,
      height: 94,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipPath(
            clipper: _PentagonClipper(),
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0x30FFD060), Color(0x18FFB020)],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: gold,
                  size: 40,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'PRO',
                style: TextStyle(
                  color: const Color(0xFF0a0a0f),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PentagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const sides = 5;
    const startAngle = -math.pi / 2;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = startAngle + (2 * math.pi * i / sides);
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ── Pro features box ──────────────────────────────────────────────────────────

class _ProFeaturesBox extends StatelessWidget {
  final AppLocalizations l10n;
  final AppColors c;
  const _ProFeaturesBox({required this.l10n, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                l10n.withProLabel,
                style: TextStyle(
                  color: c.accent,
                  fontFamily: 'Syne',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _FeatureRow(icon: Icons.auto_awesome_rounded,   label: l10n.limitProFeature1, c: c),
          _FeatureRow(icon: Icons.lunch_dining_rounded,   label: l10n.limitProFeature2, c: c),
          _FeatureRow(icon: Icons.spa_rounded,            label: l10n.limitProFeature3, c: c),
          _FeatureRow(icon: Icons.bar_chart_rounded,      label: l10n.limitProFeature4, c: c),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppColors c;
  const _FeatureRow({required this.icon, required this.label, required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: c.muted, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: c.text, fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
