import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../models/profile.dart';
import '../providers/locale_provider.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

// ── Public entry point ────────────────────────────────────────────────────────

void showProgressForecastSheet(
  BuildContext context, {
  required UserProfile profile,
  VoidCallback? onBalanced,
  VoidCallback? onEasier,
  VoidCallback? onFaster,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) => _ProgressForecastSheet(
        profile: profile,
        scrollController: ctrl,
        onBalanced: onBalanced,
        onEasier: onEasier,
        onFaster: onFaster,
      ),
    ),
  );
}

// ── Scenario definition ───────────────────────────────────────────────────────

class _Scenario {
  final String label;
  final String tag;
  final Color color;
  final double weeklyKgPerWeek; // negative = loss
  const _Scenario({
    required this.label,
    required this.tag,
    required this.color,
    required this.weeklyKgPerWeek,
  });
}

// ── Main sheet widget ─────────────────────────────────────────────────────────

class _ProgressForecastSheet extends StatefulWidget {
  final UserProfile profile;
  final ScrollController scrollController;
  final VoidCallback? onBalanced;
  final VoidCallback? onEasier;
  final VoidCallback? onFaster;

  const _ProgressForecastSheet({
    required this.profile,
    required this.scrollController,
    this.onBalanced,
    this.onEasier,
    this.onFaster,
  });

  @override
  State<_ProgressForecastSheet> createState() => _ProgressForecastSheetState();
}

class _ProgressForecastSheetState extends State<_ProgressForecastSheet> {
  int _selectedScenario = 1; // 0 = conservative, 1 = balanced, 2 = aggressive

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);
    final currentWeight = double.tryParse(widget.profile.weight) ?? 70.0;
    final goalKg = widget.profile.goalKgPerWeek;

    final scenarios = [
      _Scenario(
        label: l10n.conservativeScenario,
        tag: l10n.scenarioEasyToKeep,
        color: const Color(0xFF6BCB77),
        weeklyKgPerWeek: goalKg * 0.5,
      ),
      _Scenario(
        label: l10n.balancedScenario,
        tag: l10n.scenarioRecommended,
        color: c.accent,
        weeklyKgPerWeek: goalKg,
      ),
      _Scenario(
        label: l10n.aggressiveScenario,
        tag: l10n.scenarioHarder,
        color: const Color(0xFFFF6B6B),
        weeklyKgPerWeek: goalKg * 1.5,
      ),
    ];

    final selected = scenarios[_selectedScenario];

    // Build 8-week projection
    final weeks = List.generate(9, (i) {
      final w = currentWeight + selected.weeklyKgPerWeek * i;
      return w.clamp(30.0, 300.0);
    });

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [

                // ── Header ───────────────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: c.accent.withAlpha(20),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.trending_up_rounded, color: c.accent, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.progressForecast,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: c.text)),
                          Text(l10n.projectionBasis,
                              style: TextStyle(fontSize: 12, color: c.muted)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: c.surface2,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.close_rounded, size: 18, color: c.muted),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Scenario selector tabs ────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: c.surface2,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.border),
                  ),
                  child: Row(
                    children: List.generate(3, (i) {
                      final s = scenarios[i];
                      final isSelected = _selectedScenario == i;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedScenario = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? s.color.withAlpha(30) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(color: s.color.withAlpha(100))
                                  : Border.all(color: Colors.transparent),
                            ),
                            child: Column(
                              children: [
                                Text(s.label,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? s.color : c.muted,
                                    )),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected ? s.color.withAlpha(25) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(s.tag,
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isSelected ? s.color : c.muted.withAlpha(150),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Chart ─────────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                  decoration: BoxDecoration(
                    color: c.surface2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: c.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.weightEvolution,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c.text)),
                      const SizedBox(height: 4),
                      Text(l10n.todayWeightLabel + ': ${currentWeight.toStringAsFixed(1)} kg',
                          style: TextStyle(fontSize: 11, color: c.muted)),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 120,
                        child: CustomPaint(
                          size: const Size(double.infinity, 120),
                          painter: _ForecastPainter(
                            weights: weeks,
                            color: selected.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Week labels row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(9, (i) => Text(
                          i == 0 ? 'Today' : 'W$i',
                          style: TextStyle(fontSize: 9, color: c.muted),
                        )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Week-by-week table ────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: c.surface2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: c.border),
                  ),
                  child: Column(
                    children: [
                      // Table header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(l10n.weekLabel,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.muted)),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(l10n.estimatedWeight,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.muted)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Δ',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.muted)),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: c.border, height: 1),
                      ...List.generate(8, (i) {
                        final isEven = i.isEven;
                        final w = weeks[i + 1];
                        final delta = w - currentWeight;
                        final sign = delta >= 0 ? '+' : '';
                        final isToday = i == 0;
                        return Container(
                          color: isEven ? Colors.transparent : c.surface.withAlpha(80),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${l10n.weekLabel} ${i + 1}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                    color: isToday ? selected.color : c.text,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${w.toStringAsFixed(1)} kg',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isToday ? selected.color : c.text,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '$sign${delta.toStringAsFixed(1)} kg',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: delta < 0
                                        ? const Color(0xFF6BCB77)
                                        : delta > 0
                                            ? const Color(0xFF4DA1FF)
                                            : c.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Action buttons ────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onBalanced?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.accent,
                      foregroundColor: c.bg,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.balance_rounded, size: 18),
                    label: Text(
                      l10n.useBalancedPlan,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onEasier?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6BCB77),
                          side: BorderSide(color: c.border),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.sentiment_satisfied_alt_rounded, size: 16),
                        label: Text(l10n.makeItEasierPlan,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onFaster?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF6B6B),
                          side: BorderSide(color: c.border),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.rocket_launch_rounded, size: 16),
                        label: Text(l10n.makeItFasterPlan,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Forecast chart painter ────────────────────────────────────────────────────

class _ForecastPainter extends CustomPainter {
  final List<double> weights;
  final Color color;
  const _ForecastPainter({required this.weights, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.length < 2) return;

    final minW = weights.reduce(math.min);
    final maxW = weights.reduce(math.max);
    final range = (maxW - minW).abs().clamp(0.5, double.infinity);

    double xOf(int i) => size.width * i / (weights.length - 1);
    double yOf(double w) {
      final norm = (w - minW) / range;
      // Flip: lower weight = higher on chart if losing
      return size.height - norm * size.height * 0.8 - size.height * 0.1;
    }

    final path = Path();
    path.moveTo(xOf(0), yOf(weights[0]));
    for (int i = 1; i < weights.length; i++) {
      final x0 = xOf(i - 1);
      final y0 = yOf(weights[i - 1]);
      final x1 = xOf(i);
      final y1 = yOf(weights[i]);
      final cpx = (x0 + x1) / 2;
      path.cubicTo(cpx, y0, cpx, y1, x1, y1);
    }

    // Fill under curve
    final fillPath = Path.from(path);
    fillPath.lineTo(xOf(weights.length - 1), size.height);
    fillPath.lineTo(xOf(0), size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withAlpha(60), color.withAlpha(5)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    // Line
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dots at each week
    for (int i = 0; i < weights.length; i++) {
      canvas.drawCircle(
        Offset(xOf(i), yOf(weights[i])),
        i == 0 ? 5.0 : 3.5,
        Paint()..color = i == 0 ? Colors.white : color,
      );
      if (i == 0) {
        canvas.drawCircle(
          Offset(xOf(i), yOf(weights[i])),
          3.0,
          Paint()..color = color,
        );
      }
    }

    // Weight labels on first and last point
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (final idx in [0, weights.length - 1]) {
      textPainter.text = TextSpan(
        text: '${weights[idx].toStringAsFixed(1)}',
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          xOf(idx) - textPainter.width / 2,
          yOf(weights[idx]) - textPainter.height - 6,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_ForecastPainter old) =>
      old.weights != weights || old.color != color;
}
