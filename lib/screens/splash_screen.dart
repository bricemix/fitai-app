import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // Contrôleur principal (séquence complète)
  late AnimationController _ctrl;

  // ── Logo ──────────────────────────────────────────────────────────────────
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  // ── Anneaux d'onde (ping sonar) ───────────────────────────────────────────
  late Animation<double> _ring1Scale;
  late Animation<double> _ring1Opacity;
  late Animation<double> _ring2Scale;
  late Animation<double> _ring2Opacity;

  // ── Glow de fond ──────────────────────────────────────────────────────────
  late Animation<double> _glowFade;
  late Animation<double> _glowScale;

  // ── Texte ─────────────────────────────────────────────────────────────────
  late Animation<double>  _titleFade;
  late Animation<Offset>  _titleSlide;
  late Animation<double>  _taglineFade;

  // ── Fade-out final ────────────────────────────────────────────────────────
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    // Immersive mode pendant le splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // ── Logo : bounce élastique ────────────────────────────────────────────
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.30, curve: Curves.elasticOut),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.18, curve: Curves.easeOut),
      ),
    );

    // ── Anneau 1 : démarre au pic du logo ──────────────────────────────────
    _ring1Scale = Tween<double>(begin: 0.6, end: 2.8).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOut),
      ),
    );
    _ring1Opacity = Tween<double>(begin: 0.55, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.22, 0.60, curve: Curves.easeOut),
      ),
    );

    // ── Anneau 2 : décalé ─────────────────────────────────────────────────
    _ring2Scale = Tween<double>(begin: 0.6, end: 2.8).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.30, 0.72, curve: Curves.easeOut),
      ),
    );
    _ring2Opacity = Tween<double>(begin: 0.35, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.32, 0.72, curve: Curves.easeOut),
      ),
    );

    // ── Glow radial ────────────────────────────────────────────────────────
    _glowFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.10, 0.40, curve: Curves.easeOut),
      ),
    );
    _glowScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    // ── Titre slide-up ─────────────────────────────────────────────────────
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.30, 0.50, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end:   Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.28, 0.52, curve: Curves.easeOut),
      ),
    );

    // ── Tagline ────────────────────────────────────────────────────────────
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.44, 0.60, curve: Curves.easeOut),
      ),
    );

    // ── Fade-out global ────────────────────────────────────────────────────
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.82, 1.0, curve: Curves.easeInCubic),
      ),
    );

    _ctrl.forward();
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        widget.onDone();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: c.bg,
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Opacity(
          opacity: _fadeOut.value,
          child: SizedBox.expand(
            child: Stack(
              alignment: Alignment.center,
              children: [

                // ── Glow radial de fond ──────────────────────────────────
                Opacity(
                  opacity: _glowFade.value,
                  child: Transform.scale(
                    scale: _glowScale.value,
                    child: Container(
                      width: size.width * 0.85,
                      height: size.width * 0.85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            c.accent.withAlpha(45),
                            c.accent.withAlpha(12),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.42, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Anneau d'onde 1 ──────────────────────────────────────
                Opacity(
                  opacity: _ring1Opacity.value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: _ring1Scale.value,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c.accent,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Anneau d'onde 2 ──────────────────────────────────────
                Opacity(
                  opacity: _ring2Opacity.value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: _ring2Scale.value,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c.accent,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Logo centré (même centre que les anneaux) ─────────────
                FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SvgPicture.asset(
                        'assets/logo/dietvision-icon.svg',
                        width: 117,
                        height: 117,
                      ),
                    ),
                  ),
                ),

                // ── Titre + tagline sous le logo ──────────────────────────
                Positioned(
                  bottom: 0,
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Espace logo (117) + gap (28) + décalage bas (10) pour pousser le texte sous le logo
                      const SizedBox(height: 117 + 28 + 10),

                      // Titre "DietVision" slide-up
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                fontFamily: 'Syne',
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                                height: 1.0,
                              ),
                              children: [
                                TextSpan(text: 'Diet', style: TextStyle(color: c.text)),
                                TextSpan(text: 'Vision', style: TextStyle(color: c.accent)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Tagline (slogan)
                      FadeTransition(
                        opacity: _taglineFade,
                        child: Builder(builder: (ctx) {
                          final l10n = AppLocalizations.of(ctx);
                          return Text(
                            l10n.tagline,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: c.muted.withAlpha(160),
                              letterSpacing: 3.0,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // ── Indicateur de chargement en bas ──────────────────────
                Positioned(
                  bottom: 52,
                  child: FadeTransition(
                    opacity: _taglineFade,
                    child: _LoadingDots(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 3 points clignotants (loader) ─────────────────────────────────────────────

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Chaque point pulse avec un décalage
            final delay = i / 3.0;
            final t = ((_ctrl.value - delay) % 1.0 + 1.0) % 1.0;
            final opacity = (0.2 + 0.8 * (1.0 - (t * 2 - 1).abs().clamp(0.0, 1.0)));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.accent,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
