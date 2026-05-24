import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../providers/locale_provider.dart';
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
  final VoidCallback? onGoToScan;
  final VoidCallback? onGoToCoach;
  final String userPlan;
  final DateTime? trialEndsAt;

  const DashboardScreen({
    super.key,
    required this.profile,
    required this.meals,
    this.todayBodyEntry,
    this.todayPlan,
    this.onLogBody,
    this.onGoToScan,
    this.onGoToCoach,
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

  // Manual mission toggles (others are computed from data)
  bool _missionWater = false;
  bool _missionWalk  = false;

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
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final today = widget.meals.where((m) => m.isToday).toList();
    final totalKcal    = today.fold(0, (s, m) => s + m.result.calories);
    final totalProtein = today.fold(0.0, (s, m) => s + m.result.protein);
    final totalCarbs   = today.fold(0.0, (s, m) => s + m.result.carbs);
    final totalFat     = today.fold(0.0, (s, m) => s + m.result.fat);
    final target       = widget.todayPlan?.targetKcal ?? widget.profile.tdee.round();
    final pct          = (totalKcal / target).clamp(0.0, 1.0);
    final targetProtein = widget.profile.targetProtein;

    // ── Mission states ───────────────────────────────────────────────────────
    final m1 = today.length >= 2;                              // Scan 2 meals
    final m2 = totalProtein >= targetProtein * 0.9;            // Protein goal
    final m3 = _missionWater;                                  // Water
    final m4 = _missionWalk;                                   // Walk
    final m5 = widget.todayBodyEntry != null;                  // Measurements
    final missions    = [m1, m2, m3, m4, m5];
    final doneCount   = missions.where((v) => v).length;
    final missionPct  = doneCount / missions.length;

    // ── AI Recommendation text ───────────────────────────────────────────────
    final String aiRecText;
    if (today.isEmpty) {
      aiRecText = l10n.aiRecNoScan;
    } else if (totalKcal > target * 0.95) {
      aiRecText = l10n.aiRecCaloriesHigh;
    } else if (totalProtein < targetProtein * 0.7) {
      aiRecText = '${l10n.aiRecProteinLow}\n'
          'Priorité : ajoute un repas riche en protéines au prochain scan.';
    } else {
      aiRecText = l10n.aiRecOnTrack;
    }

    final bool showAiProteinHighlight =
        today.isNotEmpty && totalProtein < targetProtein * 0.7;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ──────────────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${l10n.today} 👋",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          l10n.readyToCrush,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: c.muted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    tooltip: l10n.notifications,
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: c.surface2,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: c.border),
                          ),
                          child: Icon(Icons.notifications_outlined,
                              size: 20, color: c.muted),
                        ),
                        Positioned(
                          right: 8, top: 8,
                          child: Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: c.accent,
                              shape: BoxShape.circle,
                              border: Border.all(color: c.bg, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Upgrade banner ───────────────────────────────────────────────
              if (widget.userPlan == 'free' || widget.userPlan == 'starter') ...[
                PremiumBannerCard(
                  trialEndsAt: widget.trialEndsAt,
                  currentPlan: widget.userPlan,
                ),
                const SizedBox(height: 12),
              ],

              // ── Top row: Check-in card + Prochain palier ─────────────────────
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 140),
                        child: widget.todayBodyEntry == null
                            ? _CompactCheckInCard(onTap: widget.onLogBody, l10n: l10n)
                            : _CompactCheckInDoneCard(l10n: l10n),
                      ),
                    ),
                    if (widget.profile.goalKgPerWeek != 0) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 140),
                          child: _CompactGoalCard(profile: widget.profile),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── TODAY MISSION CARD ───────────────────────────────────────────
              _TodayMissionCard(
                l10n: l10n,
                missionPct: missionPct,
                doneCount: doneCount,
                total: missions.length,
                m1: m1, m2: m2, m3: m3, m4: m4, m5: m5,
                targetProtein: targetProtein,
                onToggleWater: () => setState(() => _missionWater = !_missionWater),
                onToggleWalk:  () => setState(() => _missionWalk  = !_missionWalk),
                onSeePlan: widget.onGoToCoach,
              ),
              const SizedBox(height: 14),

              // ── Calorie ring card ────────────────────────────────────────────
              _CalorieCard(
                totalKcal: totalKcal,
                target: target,
                pct: pct,
                fromPlanning: widget.todayPlan != null,
                l10n: l10n,
              ),
              const SizedBox(height: 12),

              // ── Macros row ───────────────────────────────────────────────────
              _MacroRow(
                protein: totalProtein,
                carbs: totalCarbs,
                fat: totalFat,
                weight: double.tryParse(widget.profile.weight) ?? 70,
                target: target.toDouble(),
              ),
              const SizedBox(height: 14),

              // ── AI Daily Recommendation ──────────────────────────────────────
              _AiRecommendationCard(
                l10n: l10n,
                text: aiRecText,
                showProteinHighlight: showAiProteinHighlight,
                currentKcal: totalKcal,
                targetKcal: target,
                currentProtein: totalProtein.round(),
                onViewDishes: widget.onGoToCoach,
                onScanMeal: widget.onGoToScan,
                onAdjustToday: widget.onGoToCoach,
              ),
              const SizedBox(height: 14),

              // ── Weekly chart ─────────────────────────────────────────────────
              _WeeklyChart(meals: widget.meals),
              const SizedBox(height: 14),

              // ── Today's meals ────────────────────────────────────────────────
              if (today.isNotEmpty) _TodayMeals(meals: today)
              else _EmptyMeals(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Compact Check-in Card (not done) ─────────────────────────────────────────

class _CompactCheckInCard extends StatelessWidget {
  final VoidCallback? onTap;
  final AppLocalizations l10n;
  const _CompactCheckInCard({required this.onTap, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [c.accent3.withAlpha(22), c.accent3.withAlpha(6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.accent3.withAlpha(80)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: c.accent3.withAlpha(40),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.swap_vert_rounded, size: 17, color: c.accent3),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: c.accent3.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5, height: 5,
                        decoration: BoxDecoration(
                          color: c.accent3,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text('À FAIRE',
                          style: TextStyle(
                            fontSize: 8, color: c.accent3,
                            fontWeight: FontWeight.w800, letterSpacing: 0.5,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Title
            Text(l10n.dailyCheckIn,
                style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w800, color: c.text,
                )),
            const SizedBox(height: 5),
            // Subtitle
            Text(l10n.bodyMeasurementsSubtitle,
                style: TextStyle(fontSize: 10, color: c.muted),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            // CTA row
            Row(
              children: [
                Text(l10n.toComplete,
                    style: TextStyle(
                      fontSize: 11, color: c.accent3, fontWeight: FontWeight.w700,
                    )),
                const Spacer(),
                Icon(Icons.arrow_forward_rounded, size: 13, color: c.accent3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Compact Check-in Done Card ────────────────────────────────────────────────

class _CompactCheckInDoneCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _CompactCheckInDoneCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.accent.withAlpha(22), c.accent.withAlpha(6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.accent.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: icon + done badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: c.accent.withAlpha(35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.check_rounded, size: 17, color: c.accent),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: c.accent.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('✓ FAIT',
                    style: TextStyle(
                      fontSize: 8, color: c.accent,
                      fontWeight: FontWeight.w800, letterSpacing: 0.5,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(l10n.checkInDone,
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w800, color: c.accent,
              )),
          const SizedBox(height: 5),
          Text(l10n.dataUpToDate,
              style: TextStyle(fontSize: 10, color: c.muted),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.verified_rounded, size: 12, color: c.accent),
              const SizedBox(width: 5),
              Text(l10n.syncedLabel,
                  style: TextStyle(fontSize: 11, color: c.accent, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Compact Goal Countdown Card ───────────────────────────────────────────────

class _CompactGoalCard extends StatelessWidget {
  final UserProfile profile;
  const _CompactGoalCard({required this.profile});

  int _daysToNextKg() {
    final kgPerDay = profile.goalKgPerWeek.abs() / 7.0;
    if (kgPerDay <= 0) return 0;
    return (1.0 / kgPerDay).round().clamp(1, 365);
  }

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
    final c = AppTheme.of(context);
    final isLoss  = profile.goalKgPerWeek < 0;
    final days    = _daysToNextKg();
    final date    = _milestoneDate(days);
    final kgLabel = isLoss ? '−1 kg' : '+1 kg';
    final color   = isLoss ? const Color(0xFF6BCB77) : const Color(0xFF4DA1FF);

    return _GoalCountdownPulse(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: color.withAlpha(35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isLoss ? Icons.trending_down_rounded : Icons.trending_up_rounded,
                    size: 17, color: color,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('PALIER',
                      style: TextStyle(
                        fontSize: 8, color: color,
                        fontWeight: FontWeight.w800, letterSpacing: 0.5,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Big kg number
            Text(kgLabel,
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800,
                  color: color, fontFamily: 'Syne',
                )),
            const SizedBox(height: 3),
            // Days row
            RichText(
              text: TextSpan(
                style: TextStyle(fontFamily: 'Syne'),
                children: [
                  const TextSpan(
                    text: 'dans ',
                    style: TextStyle(fontSize: 12, color: c.muted),
                  ),
                  TextSpan(
                    text: '$days jours',
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: c.text,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // Date row
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 10, color: color.withAlpha(180)),
                const SizedBox(width: 4),
                Text(date,
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: color,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Goal Countdown Pulse (kept for animation) ─────────────────────────────────
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
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.15, end: 0.45)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          color: widget.color.withAlpha(12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.color.withOpacity(_glow.value), width: 1.5),
          boxShadow: [
            BoxShadow(color: widget.color.withOpacity(_glow.value * 0.35), blurRadius: 12),
          ],
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}

// ── TODAY MISSION CARD ────────────────────────────────────────────────────────

class _TodayMissionCard extends StatelessWidget {
  final AppLocalizations l10n;
  final double missionPct;
  final int doneCount;
  final int total;
  final bool m1, m2, m3, m4, m5;
  final int targetProtein;
  final VoidCallback onToggleWater;
  final VoidCallback onToggleWalk;
  final VoidCallback? onSeePlan;

  const _TodayMissionCard({
    required this.l10n,
    required this.missionPct,
    required this.doneCount,
    required this.total,
    required this.m1, required this.m2, required this.m3,
    required this.m4, required this.m5,
    required this.targetProtein,
    required this.onToggleWater,
    required this.onToggleWalk,
    this.onSeePlan,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final missions = [
      _MissionItem(label: l10n.checkScan2Meals,   done: m1, onTap: null),
      _MissionItem(label: '${l10n.checkProteinGoal} (${targetProtein}g)', done: m2, onTap: null),
      _MissionItem(label: l10n.checkDrinkWater,   done: m3, onTap: onToggleWater),
      _MissionItem(label: l10n.checkWalk30,        done: m4, onTap: onToggleWalk),
      _MissionItem(label: l10n.completeDailyMeasures, done: m5, onTap: null),
    ];

    final pctDisplay = (missionPct * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.accent.withAlpha(60), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: c.accent.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: c.accent.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('🎯', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l10n.todayMission,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: c.text)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: c.accent.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$doneCount / $total complétées',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(l10n.stayFocused,
              style: TextStyle(fontSize: 12, color: c.muted)),
          const SizedBox(height: 16),

          // Checklist + circular arc
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checklist
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: missions.map((m) => _MissionRow(item: m)).toList(),
                ),
              ),
              const SizedBox(width: 12),
              // Circular progress
              ClipRect(
              child: SizedBox(
                width: 96, height: 96,
                child: CustomPaint(
                  painter: _MissionArcPainter(progress: missionPct),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$pctDisplay%',
                            style: TextStyle(
                                fontFamily: 'Syne',
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: c.accent)),
                        Text(l10n.dailyProgress,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 9, color: c.muted, height: 1.3)),
                      ],
                    ),
                  ),
                ),
              ),
              ), // ClipRect
            ],
          ),
          const SizedBox(height: 16),

          // CTA button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSeePlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.accent,
                foregroundColor: c.bg,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.seeDailyPlan,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionItem {
  final String label;
  final bool done;
  final VoidCallback? onTap;
  const _MissionItem({required this.label, required this.done, this.onTap});
}

class _MissionRow extends StatelessWidget {
  final _MissionItem item;
  const _MissionRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return GestureDetector(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: item.done ? c.accent : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.done ? c.accent : c.muted,
                  width: 2,
                ),
              ),
              child: item.done
                  ? Icon(Icons.check_rounded, size: 13, color: c.bg)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  color: item.done ? c.muted : c.text,
                  decoration: item.done ? TextDecoration.lineThrough : null,
                  decorationColor: c.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionArcPainter extends CustomPainter {
  final double progress;
  const _MissionArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7;
    const stroke = 8.0;
    const startAngle = -pi / 2;

    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = AppTheme.surface2;
    canvas.drawCircle(center, radius, bg);

    if (progress > 0) {
      final fg = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = AppTheme.accent;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * pi * progress,
        false,
        fg,
      );
    }
  }

  @override
  bool shouldRepaint(_MissionArcPainter old) => old.progress != progress;
}

// ── AI Daily Recommendation Card ──────────────────────────────────────────────

class _AiRecommendationCard extends StatelessWidget {
  final AppLocalizations l10n;
  final String text;
  final bool showProteinHighlight;
  final int currentKcal;
  final int targetKcal;
  final int currentProtein;
  final VoidCallback? onViewDishes;
  final VoidCallback? onScanMeal;
  final VoidCallback? onAdjustToday;

  const _AiRecommendationCard({
    required this.l10n,
    required this.text,
    required this.showProteinHighlight,
    required this.currentKcal,
    required this.targetKcal,
    required this.currentProtein,
    this.onViewDishes,
    this.onScanMeal,
    this.onAdjustToday,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    // Split text at the "Priorité" line for highlighting
    final parts = text.split('\n');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 16, color: c.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(l10n.aiRecommendation,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: c.text)),
              ),
              GestureDetector(
                onTap: onViewDishes,
                child: Text(l10n.viewMore,
                    style: TextStyle(fontSize: 12, color: c.accent, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Content row: brain icon + text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: c.accent.withAlpha(18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.psychology_rounded, color: c.accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats line
                    Text(
                      '$currentKcal kcal consommées · ${currentProtein}g protéines',
                      style: TextStyle(fontSize: 11, color: c.muted),
                    ),
                    const SizedBox(height: 4),
                    // Main text (with optional highlight)
                    if (parts.length > 1) ...[
                      Text(parts[0],
                          style: TextStyle(fontSize: 13, color: c.text, height: 1.4)),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontFamily: 'Syne', fontSize: 13, height: 1.4),
                          children: [
                            TextSpan(
                              text: 'Priorité : ',
                              style: TextStyle(
                                color: c.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: parts[1].replaceFirst('Priorité : ', ''),
                              style: TextStyle(color: c.accent),
                            ),
                          ],
                        ),
                      ),
                    ] else
                      Text(text, style: TextStyle(fontSize: 13, color: c.text, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Quick action chips
          Row(
            children: [
              _QuickActionChip(
                icon: Icons.restaurant_menu_rounded,
                label: l10n.viewDishes,
                onTap: onViewDishes,
              ),
              const SizedBox(width: 8),
              _QuickActionChip(
                icon: Icons.document_scanner_rounded,
                label: l10n.scanMeal,
                onTap: onScanMeal,
              ),
              const SizedBox(width: 8),
              _QuickActionChip(
                icon: Icons.tune_rounded,
                label: l10n.adjustToday,
                onTap: onAdjustToday,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _QuickActionChip({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: c.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.border),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: c.accent),
              const SizedBox(height: 4),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: c.muted, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Calorie Card ──────────────────────────────────────────────────────────────
class _CalorieCard extends StatelessWidget {
  final int totalKcal;
  final int target;
  final double pct;
  final bool fromPlanning;
  final AppLocalizations l10n;
  const _CalorieCard({
    required this.totalKcal,
    required this.target,
    required this.pct,
    required this.l10n,
    this.fromPlanning = false,
  });

  int get _remaining => target - totalKcal;

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
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
          ClipRect(child: SizedBox(
            width: 120, height: 120,
            child: CustomPaint(
              painter: _RingPainter(progress: pct),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department_rounded,
                        size: 16, color: c.accent),
                    Text('$totalKcal',
                        style: TextStyle(
                            fontFamily: 'Syne', fontSize: 20,
                            fontWeight: FontWeight.w800, color: c.text)),
                    const Text('kcal',
                        style: TextStyle(fontSize: 10, color: c.muted)),
                  ],
                ),
              ),
            ),
          )), // ClipRect
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(l10n.objectifQuotidien,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c.muted)),
                    if (fromPlanning) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: c.accent.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(l10n.planning,
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                                color: c.accent, letterSpacing: 0.3)),
                      ),
                    ],
                  ],
                ),
                Text('$target',
                    style: TextStyle(
                        fontFamily: 'Syne', fontSize: 36,
                        fontWeight: FontWeight.w800, color: c.text, height: 1)),
                Text(l10n.kcalPerDay,
                    style: TextStyle(fontSize: 12, color: c.muted)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.progression,
                        style: TextStyle(fontSize: 12, color: c.muted)),
                    Text('${(pct * 100).round()}%',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c.accent)),
                  ],
                ),
                const SizedBox(height: 4),
                _ProgressBar(value: pct, color: pct > 0.9 ? c.accent3 : c.accent),
                const SizedBox(height: 8),
                Builder(builder: (ctx) {
                  final rem = _remaining;
                  final isOver = rem < 0;
                  final color = isOver ? c.accent3 : c.accent;
                  return Row(
                    children: [
                      Icon(
                        isOver ? Icons.warning_amber_rounded : Icons.arrow_circle_down_rounded,
                        size: 13, color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOver ? '${(-rem)} ${l10n.kcalExceeded}' : '$rem ${l10n.kcalRemaining}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
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
      -pi / 2, 2 * pi * progress, false, paint,
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
    final c = AppTheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: c.surface,
        valueColor: AlwaysStoppedAnimation(color),
        minHeight: 5,
      ),
    );
  }
}

// ── Macro Row ─────────────────────────────────────────────────────────────────
class _MacroRow extends StatelessWidget {
  final double protein, carbs, fat, weight, target;
  const _MacroRow({
    required this.protein, required this.carbs, required this.fat,
    required this.weight, required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final macros = [
      (name: l10n.proteins, val: protein, color: c.accent2,
        pct: (protein / (weight * 1.8)).clamp(0.0, 1.0),
        target: (weight * 1.8).round(), unit: 'g'),
      (name: l10n.carbs, val: carbs, color: c.accent,
        pct: (carbs / (target * 0.5 / 4)).clamp(0.0, 1.0),
        target: (target * 0.5 / 4).round(), unit: 'g'),
      (name: l10n.fats, val: fat, color: c.accent3,
        pct: (fat / (target * 0.3 / 9)).clamp(0.0, 1.0),
        target: (target * 0.3 / 9).round(), unit: 'g'),
    ];

    return Row(
      children: macros.asMap().entries.map((e) {
        final i = e.key;
        final m = e.value;
        return Expanded(
          child: Container(
            margin: i < 2 ? const EdgeInsets.only(right: 8) : EdgeInsets.zero,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.surface2,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${m.val.round()}',
                        style: TextStyle(fontFamily: 'Syne', fontSize: 20,
                            fontWeight: FontWeight.w800, color: m.color)),
                    Text(' / ${m.target}${m.unit}',
                        style: TextStyle(fontSize: 10, color: c.muted)),
                  ],
                ),
                Text(m.name,
                    style: TextStyle(fontSize: 11, color: c.muted)),
                const SizedBox(height: 8),
                _ProgressBar(value: m.pct, color: m.color),
                const SizedBox(height: 2),
                Text('${(m.pct * 100).round()}%',
                    style: TextStyle(fontSize: 9, color: c.muted)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Weekly Chart ──────────────────────────────────────────────────────────────
class _WeeklyChart extends StatelessWidget {
  final List<Meal> meals;
  const _WeeklyChart({required this.meals});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final now = DateTime.now();
    final todayIdx = now.weekday - 1;

    // Compute real kcal per weekday from meal data
    final weekKcal = List<int>.filled(7, 0);
    for (final m in meals) {
      try {
        final d = DateTime.parse(m.date);
        final idx = d.weekday - 1;
        weekKcal[idx] += m.result.calories;
      } catch (_) {}
    }

    final maxKcal = weekKcal.reduce(max).clamp(1, 9999);
    final avgKcal = weekKcal.where((v) => v > 0).fold(0, (s, v) => s + v);
    final scannedDays = weekKcal.where((v) => v > 0).length;
    final avg = scannedDays > 0 ? avgKcal ~/ scannedDays : 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.last7Days,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              if (avg > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Moyenne', style: TextStyle(fontSize: 10, color: c.muted)),
                    Text('$avg kcal',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                            color: c.accent, fontFamily: 'Syne')),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final kcal = weekKcal[i];
                final heightPct = kcal > 0 ? (kcal / maxKcal).clamp(0.15, 1.0) : 0.0;
                final isToday = i == todayIdx;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isToday && kcal > 0)
                          Text('$kcal',
                              style: TextStyle(fontSize: 9, color: c.text,
                                  fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400 + i * 60),
                          height: heightPct > 0 ? 80 * heightPct : 4,
                          decoration: BoxDecoration(
                            color: isToday ? c.accent
                                : kcal > 0 ? c.accent.withAlpha(90)
                                : c.surface2,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(days[i],
                            style: TextStyle(
                                fontSize: 10,
                                color: isToday ? c.accent : c.muted,
                                fontWeight: isToday ? FontWeight.w700 : FontWeight.normal)),
                      ],
                    ),
                  ),
                );
              }),
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
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.todayMeals, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Icon(Icons.restaurant_outlined, size: 40, color: c.muted),
          const SizedBox(height: 10),
          Text(l10n.noMealsToday,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.muted, height: 1.5)),
        ],
      ),
    );
  }
}

// ── Image d'un repas (fichier local → thumbnail base64 → icône) ───────────────
class _MealImage extends StatelessWidget {
  final Meal meal;
  const _MealImage({required this.meal});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    // 1. Fichier local présent
    final file = meal.imagePath != null ? File(meal.imagePath!) : null;
    if (file != null && file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    // 2. Miniature base64 synchronisée depuis le serveur
    if (meal.thumbnailBase64 != null && meal.thumbnailBase64!.isNotEmpty) {
      try {
        final bytes = base64Decode(meal.thumbnailBase64!);
        return Image.memory(bytes, fit: BoxFit.cover);
      } catch (_) {}
    }
    // 3. Fallback icône
    return Icon(Icons.restaurant_rounded, color: c.muted);
  }
}

// ── Shared meal tile ──────────────────────────────────────────────────────────
class MealEntryTile extends StatelessWidget {
  final Meal meal;
  final bool showDate;
  const MealEntryTile({super.key, required this.meal, this.showDate = false});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: c.surface2,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: _MealImage(meal: meal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.result.name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                if (showDate)
                  Text(_formatDate(meal.date),
                      style: TextStyle(fontSize: 11, color: c.muted)),
                Row(
                  children: [
                    Text('${meal.result.protein.round()}g P',
                        style: TextStyle(fontSize: 11, color: c.accent2)),
                    Text(' · ', style: TextStyle(fontSize: 11, color: c.muted)),
                    Text('${meal.result.carbs.round()}g G',
                        style: TextStyle(fontSize: 11, color: c.accent)),
                    Text(' · ', style: TextStyle(fontSize: 11, color: c.muted)),
                    Text('${meal.result.fat.round()}g L',
                        style: TextStyle(fontSize: 11, color: c.accent3)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${meal.result.calories}',
                  style: TextStyle(fontFamily: 'Syne', fontSize: 16,
                      fontWeight: FontWeight.w700, color: c.accent)),
              Text(' kcal', style: TextStyle(fontSize: 10, color: c.muted)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    final d = DateTime.parse(iso);
    const months = [
      'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
      'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'
    ];
    return '${d.day} ${months[d.month - 1]} · ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
  }
}
