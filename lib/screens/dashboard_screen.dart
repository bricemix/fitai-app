import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/profile.dart';
import '../models/meal.dart';
import '../models/body_entry.dart';
import '../models/planning.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import 'subscription_screen.dart';
import '../widgets/premium_banner_card.dart';

class DashboardScreen extends StatefulWidget {
  final UserProfile profile;
  final List<Meal> meals;
  final BodyEntry? todayBodyEntry;
  final DayPlan? todayPlan;
  final VoidCallback? onLogBody;
  final String userPlan;
  final DateTime? trialEndsAt;

  const DashboardScreen({
    super.key,
    required this.profile,
    required this.meals,
    this.todayBodyEntry,
    this.todayPlan,
    this.onLogBody,
    this.userPlan = 'free',
    this.trialEndsAt,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim  = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut));
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = widget.meals.where((m) => m.isToday).toList();
    final totalKcal = today.fold(0, (s, m) => s + m.result.calories);
    final totalProtein = today.fold(0.0, (s, m) => s + m.result.protein);
    final totalCarbs = today.fold(0.0, (s, m) => s + m.result.carbs);
    final totalFat = today.fold(0.0, (s, m) => s + m.result.fat);
    final target = widget.todayPlan?.targetKcal ?? widget.profile.tdee.round();
    final pct = (totalKcal / target).clamp(0.0, 1.0);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.helloUser(widget.profile.name),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppTheme.muted)),
                        Text(l10n.today,
                            style:
                                Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SvgPicture.asset(
                          'assets/logo/dietvision-icon.svg',
                          height: 22,
                        ),
                      ),
                      const SizedBox(width: 6),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5),
                          children: [
                            TextSpan(
                                text: 'Diet',
                                style: TextStyle(color: AppTheme.text)),
                            TextSpan(
                                text: 'Vision',
                                style: TextStyle(color: AppTheme.accent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Bannière upgrade (plan free ou starter en trial) ─────────
              if (widget.userPlan == 'free' || widget.userPlan == 'starter') ...[
                PremiumBannerCard(
                  trialEndsAt: widget.trialEndsAt,
                  currentPlan: widget.userPlan,
                ),
                const SizedBox(height: 12),
              ],

              // Body reminder card
              if (widget.todayBodyEntry == null)
                _BodyReminderCard(onTap: widget.onLogBody)
              else
                _BodyTodayCard(entry: widget.todayBodyEntry!),
              const SizedBox(height: 12),

              // ── Objectif dans X jours ──────────────────────────────────
              if (widget.profile.goalKgPerWeek != 0) ...[
                _GoalCountdownCard(profile: widget.profile),
                const SizedBox(height: 12),
              ],

              // Planning tip (if today has a note)
              if (widget.todayPlan?.note != null &&
                  widget.todayPlan!.note!.isNotEmpty) ...[
                _PlanningTipCard(note: widget.todayPlan!.note!),
                const SizedBox(height: 12),
              ],

              // Calorie ring card
              _CalorieCard(
                totalKcal: totalKcal,
                target: target,
                pct: pct,
                fromPlanning: widget.todayPlan != null,
              ),
              const SizedBox(height: 12),

              // Macros
              _MacroRow(
                protein: totalProtein,
                carbs: totalCarbs,
                fat: totalFat,
                weight: double.tryParse(widget.profile.weight) ?? 70,
                target: target.toDouble(),
              ),
              const SizedBox(height: 14),

              // Weekly chart
              _WeeklyChart(),
              const SizedBox(height: 14),

              // Today's meals
              if (today.isEmpty)
                _EmptyMeals()
              else
                _TodayMeals(meals: today),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Goal Countdown Card ───────────────────────────────────────────────────────
class _GoalCountdownCard extends StatefulWidget {
  final UserProfile profile;
  const _GoalCountdownCard({required this.profile});

  @override
  State<_GoalCountdownCard> createState() => _GoalCountdownCardState();
}

class _GoalCountdownCardState extends State<_GoalCountdownCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _scale;
  late final Animation<double>   _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    // Léger délai pour que la card apparaisse après le reste
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Jours pour atteindre le prochain palier de 1 kg (loss ou gain)
  int _daysToNextKg() {
    final kgPerDay = widget.profile.goalKgPerWeek.abs() / 7.0;
    if (kgPerDay <= 0) return 0;
    return (1.0 / kgPerDay).round().clamp(1, 365);
  }

  /// Date estimée du prochain palier
  String _milestoneDate(int days) {
    final date = DateTime.now().add(Duration(days: days));
    const months = [
      'jan', 'fév', 'mar', 'avr', 'mai', 'juin',
      'juil', 'aoû', 'sep', 'oct', 'nov', 'déc'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final isLoss = widget.profile.goalKgPerWeek < 0;
    final days   = _daysToNextKg();
    final date   = _milestoneDate(days);
    final kgLabel = isLoss ? '−1 kg' : '+1 kg';
    final color   = isLoss ? const Color(0xFF6BCB77) : const Color(0xFF4DA1FF);
    final icon    = isLoss ? Icons.trending_down_rounded : Icons.trending_up_rounded;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: _GoalCountdownPulse(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icône animée
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(width: 14),
                // Texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoss ? 'Prochain palier' : 'Prochain palier',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontFamily: 'Syne'),
                          children: [
                            TextSpan(
                              text: kgLabel,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                            const TextSpan(
                              text: '  dans ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.muted,
                              ),
                            ),
                            TextSpan(
                              text: '$days jours',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 13, color: AppTheme.muted),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: color,
                        fontFamily: 'Syne',
                      ),
                    ),
                    Text(
                      DateTime.now().year.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Container animé avec pulsation de la bordure
class _GoalCountdownPulse extends StatefulWidget {
  final Color color;
  final Widget child;
  const _GoalCountdownPulse({required this.color, required this.child});

  @override
  State<_GoalCountdownPulse> createState() => _GoalCountdownPulseState();
}

class _GoalCountdownPulseState extends State<_GoalCountdownPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double>   _glow;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.15, end: 0.45)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          color: widget.color.withAlpha(12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: widget.color.withOpacity(_glow.value),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(_glow.value * 0.4),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}

// ── Planning Tip ──────────────────────────────────────────────────────────────
class _PlanningTipCard extends StatelessWidget {
  final String note;
  const _PlanningTipCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accent.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withAlpha(50)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tips_and_updates_rounded,
              color: AppTheme.accent, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(note,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.text, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

// ── Pill ──────────────────────────────────────────────────────────────────────
class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accent.withAlpha(24),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(label,
          style: const TextStyle(
              color: AppTheme.accent,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    );
  }
}

// ── Calorie Card ──────────────────────────────────────────────────────────────
class _CalorieCard extends StatelessWidget {
  final int totalKcal;
  final int target;
  final double pct;
  final bool fromPlanning;
  const _CalorieCard(
      {required this.totalKcal,
      required this.target,
      required this.pct,
      this.fromPlanning = false});

  int get _remaining => target - totalKcal;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _RingPainter(progress: pct),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$totalKcal',
                        style: const TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.text)),
                    const Text('kcal',
                        style:
                            TextStyle(fontSize: 11, color: AppTheme.muted)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Builder(builder: (ctx) {
                      final l = AppLocalizations.of(ctx);
                      return Row(children: [
                        Text(l.goal,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.muted)),
                        if (fromPlanning) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(l.planning,
                                style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.accent,
                                    letterSpacing: 0.3)),
                          ),
                        ],
                      ]);
                    }),
                  ],
                ),
                Text('$target',
                    style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.text,
                        height: 1)),
                Builder(
                    builder: (ctx) => Text(
                        AppLocalizations.of(ctx).kcalPerDay,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.muted))),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                        builder: (ctx) => Text(
                            AppLocalizations.of(ctx).progression,
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.muted))),
                    Text('${(pct * 100).round()}%',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.accent)),
                  ],
                ),
                const SizedBox(height: 4),
                _ProgressBar(
                    value: pct,
                    color: pct > 0.9 ? AppTheme.accent3 : AppTheme.accent),
                const SizedBox(height: 8),
                Builder(builder: (ctx) {
                  final l = AppLocalizations.of(ctx);
                  final rem = _remaining;
                  final isOver = rem < 0;
                  final color = isOver ? AppTheme.accent3 : AppTheme.accent;
                  return Row(
                    children: [
                      Icon(
                        isOver
                            ? Icons.warning_amber_rounded
                            : Icons.arrow_circle_down_rounded,
                        size: 13,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOver
                            ? '${(-rem)} ${l.kcalExceeded}'
                            : '$rem ${l.kcalRemaining}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const stroke = 10.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    paint.color = AppTheme.surface2;
    canvas.drawCircle(center, radius, paint);

    paint.color = AppTheme.accent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ── Progress Bar ──────────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  const _ProgressBar({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: AppTheme.surface,
        valueColor: AlwaysStoppedAnimation(color),
        minHeight: 5,
      ),
    );
  }
}

// ── Macro Row ─────────────────────────────────────────────────────────────────
class _MacroRow extends StatelessWidget {
  final double protein, carbs, fat, weight, target;
  const _MacroRow(
      {required this.protein,
      required this.carbs,
      required this.fat,
      required this.weight,
      required this.target});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final macros = [
      (
        name: l10n.proteins,
        val: protein,
        color: AppTheme.accent2,
        pct: (protein / (weight * 1.8)).clamp(0.0, 1.0)
      ),
      (
        name: l10n.carbs,
        val: carbs,
        color: AppTheme.accent,
        pct: (carbs / (target * 0.5 / 4)).clamp(0.0, 1.0)
      ),
      (
        name: l10n.fats,
        val: fat,
        color: AppTheme.accent3,
        pct: (fat / (target * 0.3 / 9)).clamp(0.0, 1.0)
      ),
    ];

    return Row(
      children: macros
              .map((m) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: AppTheme.surface2,
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          Text('${m.val.round()}',
                              style: TextStyle(
                                  fontFamily: 'Syne',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: m.color)),
                          Text(m.name,
                              style: const TextStyle(
                                  fontSize: 11, color: AppTheme.muted),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          _ProgressBar(value: m.pct, color: m.color),
                        ],
                      ),
                    ),
                  ))
              .toList()
        ..last = Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                Text('${fat.round()}',
                    style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.accent3)),
                Builder(
                    builder: (ctx) => Text(AppLocalizations.of(ctx).fats,
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.muted),
                        textAlign: TextAlign.center)),
                const SizedBox(height: 8),
                _ProgressBar(
                    value: (fat / (target * 0.3 / 9)).clamp(0.0, 1.0),
                    color: AppTheme.accent3),
              ],
            ),
          ),
        ),
    );
  }
}

// ── Weekly Chart ──────────────────────────────────────────────────────────────
class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart();

  @override
  Widget build(BuildContext context) {
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final todayIdx = DateTime.now().weekday - 1;
    final rng = Random(42);
    final heights = List.generate(
        7, (i) => i == todayIdx ? 70.0 : 20.0 + rng.nextDouble() * 50);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
              builder: (ctx) => Text(AppLocalizations.of(ctx).last7Days,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600))),
          const SizedBox(height: 12),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                  7,
                  (i) => Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration:
                                  Duration(milliseconds: 400 + i * 60),
                              height: heights[i],
                              decoration: BoxDecoration(
                                color: i == todayIdx
                                    ? AppTheme.accent
                                    : AppTheme.accent.withAlpha(64),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6)),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(days[i],
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.muted)),
                          ],
                        ),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Today's Meals ─────────────────────────────────────────────────────────────
class _TodayMeals extends StatelessWidget {
  final List<Meal> meals;
  const _TodayMeals({required this.meals});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
              builder: (ctx) => Text(AppLocalizations.of(ctx).todayMeals,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600))),
          const SizedBox(height: 12),
          ...meals.reversed.take(3).map((m) => MealEntryTile(meal: m)),
        ],
      ),
    );
  }
}

class _EmptyMeals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.restaurant_outlined,
              size: 40, color: AppTheme.muted),
          const SizedBox(height: 10),
          Builder(
              builder: (ctx) => Text(
                    AppLocalizations.of(ctx).noMealsToday,
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.muted, height: 1.5),
                  )),
        ],
      ),
    );
  }
}

// ── Shared meal tile (also used in ProgressScreen) ────────────────────────────
class MealEntryTile extends StatelessWidget {
  final Meal meal;
  final bool showDate;
  const MealEntryTile(
      {super.key, required this.meal, this.showDate = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: meal.imagePath != null
                ? Image.file(File(meal.imagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.restaurant_rounded,
                            size: 24, color: AppTheme.muted)))
                : const Center(
                    child: Icon(Icons.restaurant_rounded,
                        size: 24, color: AppTheme.muted)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.result.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  showDate
                      ? _formatDate(meal.date)
                      : '${meal.result.protein.round()}g prot · ${meal.result.carbs.round()}g gl · ${meal.result.fat.round()}g lip',
                  style:
                      const TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
              ],
            ),
          ),
          Text(
            '${meal.result.calories}',
            style: const TextStyle(
                fontFamily: 'Syne',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.accent),
          ),
          const Text(' kcal',
              style: TextStyle(fontSize: 10, color: AppTheme.muted)),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    final d = DateTime.parse(iso);
    final months = [
      'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
      'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'
    ];
    return '${d.day} ${months[d.month - 1]} · ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}

// ── Body reminder (not logged today) ─────────────────────────────────────────
class _BodyReminderCard extends StatelessWidget {
  final VoidCallback? onTap;
  const _BodyReminderCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.accent3.withAlpha(14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.accent3.withAlpha(64)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: AppTheme.accent3.withAlpha(32),
                  borderRadius: BorderRadius.circular(12)),
              child: const Center(
                  child: Icon(Icons.fitness_center_rounded,
                      size: 20, color: AppTheme.accent3)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Builder(
                builder: (ctx) {
                  final l = AppLocalizations.of(ctx);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.missingMeasurements,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(l.bodyMeasurementsHint,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.muted)),
                    ],
                  );
                },
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppTheme.accent3, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Body today summary ────────────────────────────────────────────────────────
class _BodyTodayCard extends StatelessWidget {
  final BodyEntry entry;
  const _BodyTodayCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    if (entry.weight != null)
      parts.add('Poids : ${entry.weight!.toStringAsFixed(1)} kg');
    if (entry.waist != null)
      parts.add('Taille : ${entry.waist!.toStringAsFixed(1)} cm');
    if (entry.biceps != null)
      parts.add('Biceps : ${entry.biceps!.toStringAsFixed(1)} cm');
    if (entry.chest != null)
      parts.add('Poitrine : ${entry.chest!.toStringAsFixed(1)} cm');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accent.withAlpha(14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withAlpha(48)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppTheme.accent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                    builder: (ctx) => Text(
                        AppLocalizations.of(ctx).measurementsDoneToday,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w600))),
                const SizedBox(height: 4),
                Text(parts.join('  ·  '),
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
