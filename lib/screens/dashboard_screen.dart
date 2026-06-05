import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';
import '../providers/locale_provider.dart';
import '../models/meal.dart';
import '../models/body_entry.dart';
import '../models/planning.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/premium_banner_card.dart';
import '../services/mission_sync_service.dart';

class DashboardScreen extends StatefulWidget {
  final UserProfile profile;
  final List<Meal> meals;
  final BodyEntry? todayBodyEntry;
  final DayPlan? todayPlan;
  final VoidCallback? onLogBody;
  final VoidCallback? onGoToScan;
  final VoidCallback? onGoToCoach;
  final VoidCallback? onGoToChat;
  final String userPlan;
  final DateTime? trialEndsAt;
  final ValueNotifier<int>? missionReloadTrigger;

  const DashboardScreen({
    super.key,
    required this.profile,
    required this.meals,
    this.todayBodyEntry,
    this.todayPlan,
    this.onLogBody,
    this.onGoToScan,
    this.onGoToCoach,
    this.onGoToChat,
    this.userPlan = 'free',
    this.trialEndsAt,
    this.missionReloadTrigger,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  // Manual mission toggles — persisted per day, auto-reset tomorrow
  bool _missionWater    = false;
  bool _missionWalk     = false;
  bool _missionNoSugar  = false;
  bool _missionCalorie  = false; // used only on days when it's selected

  // Last computed auto states (updated in build, used by _syncMissions)
  bool _autoScan    = false;
  bool _autoProtein = false;
  bool _autoCalorie = false;
  List<String> _activeSlots = [];

  static String get _todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Which 5 of the 6 slots are active today (based on day of week)
  // Slots: 0=scan2meals, 1=protein, 2=water, 3=walk, 4=measures, 5=noSugar+calorie swap
  // Each weekday drops one optional slot and adds a different one.
  // Returns a list of 5 slot IDs for today: 'scan','prot','water','walk','meas','calorie','nosugar'
  static List<String> _todaySlots() {
    // Day 0=Mon … 6=Sun
    // Core: scan, prot, meas are always present (3 fixed)
    // Rotating pair from: water, walk, calorie, nosugar (pick 2 per day)
    const rotating = [
      ['water', 'walk'],    // Mon
      ['water', 'calorie'], // Tue
      ['walk',  'nosugar'], // Wed
      ['water', 'nosugar'], // Thu
      ['walk',  'calorie'], // Fri
      ['water', 'walk'],    // Sat
      ['calorie','nosugar'],// Sun
    ];
    final day = DateTime.now().weekday - 1; // 0=Mon
    return ['scan', 'prot', ...rotating[day], 'meas'];
  }

  Future<void> _loadMissionState() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _todayKey;
    if (mounted) {
      setState(() {
        _missionWater   = prefs.getBool('miss_water_$key')   ?? false;
        _missionWalk    = prefs.getBool('miss_walk_$key')    ?? false;
        _missionNoSugar = prefs.getBool('miss_nosugar_$key') ?? false;
        _missionCalorie = prefs.getBool('miss_calorie_$key') ?? false;
      });
    }
  }

  Future<void> _saveToggle(String name, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('miss_${name}_${_todayKey}', value);
  }

  /// Sync today's full mission snapshot to server (called after any toggle)
  void _syncMissions() {
    MissionSyncService.syncToday(
      autoStates: {
        'scan':    _autoScan,
        'protein': _autoProtein,
        'calorie': _autoCalorie,
      },
      slots: _activeSlots,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMissionState();
    // Reload missions when returning to home tab (e.g. after toggling in planning)
    widget.missionReloadTrigger?.addListener(_loadMissionState);
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
    widget.missionReloadTrigger?.removeListener(_loadMissionState);
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
    final slots = _todaySlots();
    // Update auto states for sync (stored as instance vars)
    _autoScan    = today.length >= 2;
    _autoProtein = totalProtein >= targetProtein * 0.9;
    _autoCalorie = totalKcal >= target * 0.9;
    _activeSlots = slots;
    bool slotBool(String s) {
      if (s == 'scan')    return _autoScan;
      if (s == 'prot')    return _autoProtein;
      if (s == 'water')   return _missionWater;
      if (s == 'walk')    return _missionWalk;
      if (s == 'nosugar') return _missionNoSugar;
      if (s == 'calorie') return _missionCalorie;
      if (s == 'meas')    return widget.todayBodyEntry != null;
      return false;
    }
    final slotDones  = slots.map(slotBool).toList();
    final doneCount  = slotDones.where((v) => v).length;
    final missionPct = doneCount / slotDones.length;

    // ── AI Recommendation text ───────────────────────────────────────────────
    final String aiRecText;
    if (today.isEmpty) {
      aiRecText = l10n.aiRecNoScan;
    } else if (totalKcal > target * 0.95) {
      aiRecText = l10n.aiRecCaloriesHigh;
    } else if (totalProtein < targetProtein * 0.7) {
      aiRecText = l10n.aiRecProteinLow;
    } else {
      aiRecText = l10n.aiRecOnTrack;
    }

    // Macro targets
    final weight = double.tryParse(widget.profile.weight) ?? 70;
    final protTarget  = (weight * 1.8).round();
    final carbTarget  = (target * 0.5 / 4).round();
    final fatTarget   = (target * 0.3 / 9).round();

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

              // ── Today Score card ─────────────────────────────────────────────
              _TodayScoreCard(
                l10n: l10n,
                scorePct: missionPct,
                mealCount: today.length,
                onScanMeal: widget.onGoToScan,
              ),
              const SizedBox(height: 14),

              // ── Ask coach button ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onGoToChat ?? widget.onGoToCoach,
                  icon: const Icon(Icons.smart_toy_rounded, size: 18),
                  label: Text(l10n.askCoachLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E3D8F),
                    side: const BorderSide(color: Color(0xFF1E3D8F), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── Daily Nutrition card ──────────────────────────────────────────
              _DailyNutritionCard(
                l10n: l10n,
                totalKcal: totalKcal,
                target: target,
                pct: pct,
                fromPlanning: widget.todayPlan != null,
                protein: totalProtein,
                carbs: totalCarbs,
                fat: totalFat,
                protTarget: protTarget,
                carbTarget: carbTarget,
                fatTarget: fatTarget,
              ),
              const SizedBox(height: 14),

              // ── Mission + AI Reco side by side ───────────────────────────────
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _TodayMissionCard(
                        l10n: l10n,
                        slots: slots,
                        slotDones: slotDones,
                        doneCount: doneCount,
                        targetProtein: targetProtein,
                        onToggleWater: () {
                          final nv = !_missionWater;
                          setState(() => _missionWater = nv);
                          _saveToggle('water', nv);
                          _syncMissions();
                        },
                        onToggleWalk: () {
                          final nv = !_missionWalk;
                          setState(() => _missionWalk = nv);
                          _saveToggle('walk', nv);
                          _syncMissions();
                        },
                        onToggleNoSugar: () {
                          final nv = !_missionNoSugar;
                          setState(() => _missionNoSugar = nv);
                          _saveToggle('nosugar', nv);
                          _syncMissions();
                        },
                        onToggleCalorie: () {
                          final nv = !_missionCalorie;
                          setState(() => _missionCalorie = nv);
                          _saveToggle('calorie', nv);
                          _syncMissions();
                        },
                        onSeePlan: widget.onGoToCoach,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _AiRecommendationCard(
                        l10n: l10n,
                        text: aiRecText,
                        onViewMore: widget.onGoToCoach,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Next milestone ───────────────────────────────────────────────
              if (widget.profile.goalKgPerWeek != 0)
                _NextMilestoneCard(profile: widget.profile, l10n: l10n),
              if (widget.profile.goalKgPerWeek != 0)
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

// ── Today Score Card ─────────────────────────────────────────────────────────

class _TodayScoreCard extends StatelessWidget {
  final AppLocalizations l10n;
  final double scorePct;
  final int mealCount;
  final VoidCallback? onScanMeal;
  const _TodayScoreCard({
    required this.l10n,
    required this.scorePct,
    required this.mealCount,
    this.onScanMeal,
  });

  static const _purple = Color(0xFF7C5CFC);

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.accent.withAlpha(100), width: 1.5),
        boxShadow: [BoxShadow(color: c.accent.withAlpha(28), blurRadius: 24, spreadRadius: 0)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Ring ──────────────────────────────────────────────────────────
          SizedBox(
            width: 96, height: 96,
            child: CustomPaint(
              painter: _RingPainter(progress: scorePct),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(scorePct * 100).round()}%',
                      style: TextStyle(
                        fontFamily: 'Syne', fontSize: 22,
                        fontWeight: FontWeight.w800, color: c.text,
                      ),
                    ),
                    Text(
                      l10n.ofDailyGoal,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 8, color: c.muted, height: 1.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // ── Center content ───────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + AI badge
                Row(
                  children: [
                    Text(
                      l10n.todayScore,
                      style: TextStyle(
                        fontFamily: 'Syne', fontSize: 15,
                        fontWeight: FontWeight.w800, color: c.text,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.auto_awesome_rounded, size: 13, color: c.accent),
                  ],
                ),
                const SizedBox(height: 6),
                // AI Coach badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _purple.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _purple.withAlpha(70)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome_rounded, size: 10, color: _purple),
                      const SizedBox(width: 4),
                      Text('AI COACH',
                          style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w800,
                            color: _purple, letterSpacing: 0.6,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mealCount == 0 ? l10n.scoreScanFirstMeal : l10n.aiRecOnTrack,
                  style: TextStyle(fontSize: 12, color: c.muted, height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onScanMeal,
                    icon: const Icon(Icons.document_scanner_rounded, size: 15),
                    label: Text(l10n.scanMeal,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.accent,
                      foregroundColor: c.bg,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hologram Body Painter (unused — kept for reference) ──────────────────────

class _HologramBodyPainter extends CustomPainter {
  static const _g = Color(0xFFc8ff5a);

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = _g.withAlpha(30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final line = Paint()
      ..color = _g.withAlpha(180)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dot = Paint()
      ..color = _g
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;

    // Head
    final headR = size.width * 0.16;
    final headY = headR + 2;
    canvas.drawCircle(Offset(cx, headY), headR + 4, glow);
    canvas.drawCircle(Offset(cx, headY), headR, line);

    // Neck
    canvas.drawLine(Offset(cx, headY + headR), Offset(cx, headY + headR + 8), line);

    // Shoulders
    final shoulderY = headY + headR + 8;
    canvas.drawLine(Offset(cx - size.width * 0.38, shoulderY + 6),
        Offset(cx + size.width * 0.38, shoulderY + 6), line);

    // Arms
    // Left arm
    canvas.drawLine(Offset(cx - size.width * 0.38, shoulderY + 6),
        Offset(cx - size.width * 0.42, shoulderY + 26), line);
    canvas.drawLine(Offset(cx - size.width * 0.42, shoulderY + 26),
        Offset(cx - size.width * 0.36, shoulderY + 44), line);
    // Right arm
    canvas.drawLine(Offset(cx + size.width * 0.38, shoulderY + 6),
        Offset(cx + size.width * 0.42, shoulderY + 26), line);
    canvas.drawLine(Offset(cx + size.width * 0.42, shoulderY + 26),
        Offset(cx + size.width * 0.36, shoulderY + 44), line);

    // Torso
    final torsoTop = shoulderY + 6;
    final torsoBot = torsoTop + 38;
    canvas.drawLine(Offset(cx - size.width * 0.22, torsoTop),
        Offset(cx - size.width * 0.16, torsoBot), line);
    canvas.drawLine(Offset(cx + size.width * 0.22, torsoTop),
        Offset(cx + size.width * 0.16, torsoBot), line);
    canvas.drawLine(Offset(cx - size.width * 0.16, torsoBot),
        Offset(cx + size.width * 0.16, torsoBot), line);

    // Pelvis
    canvas.drawLine(Offset(cx - size.width * 0.2, torsoBot + 2),
        Offset(cx + size.width * 0.2, torsoBot + 2), line);

    // Legs
    final legTop = torsoBot + 2;
    final legBot = size.height - 4;
    // Left leg
    canvas.drawLine(Offset(cx - size.width * 0.1, legTop),
        Offset(cx - size.width * 0.14, legTop + (legBot - legTop) * 0.5), line);
    canvas.drawLine(Offset(cx - size.width * 0.14, legTop + (legBot - legTop) * 0.5),
        Offset(cx - size.width * 0.1, legBot), line);
    // Right leg
    canvas.drawLine(Offset(cx + size.width * 0.1, legTop),
        Offset(cx + size.width * 0.14, legTop + (legBot - legTop) * 0.5), line);
    canvas.drawLine(Offset(cx + size.width * 0.14, legTop + (legBot - legTop) * 0.5),
        Offset(cx + size.width * 0.1, legBot), line);

    // Glow dots at joints
    for (final p in [
      Offset(cx, headY),
      Offset(cx - size.width * 0.38, shoulderY + 6),
      Offset(cx + size.width * 0.38, shoulderY + 6),
      Offset(cx - size.width * 0.14, legTop + (legBot - legTop) * 0.5),
      Offset(cx + size.width * 0.14, legTop + (legBot - legTop) * 0.5),
    ]) {
      canvas.drawCircle(p, 4, Paint()..color = _g.withAlpha(40)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
      canvas.drawCircle(p, 2, dot);
    }

    // Ground glow ring
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, size.height - 2), width: size.width * 0.7, height: 8),
      Paint()
        ..color = _g.withAlpha(50)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
  }

  @override
  bool shouldRepaint(_HologramBodyPainter _) => false;
}

// ── Quick Actions Row ─────────────────────────────────────────────────────────

class _QuickActionsRow extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback? onScan;
  final VoidCallback? onMeasurements;
  final VoidCallback? onAskCoach;
  const _QuickActionsRow({
    required this.l10n,
    this.onScan,
    this.onMeasurements,
    this.onAskCoach,
  });

  static const _purple = Color(0xFF7C5CFC);

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final actions = [
      (icon: Icons.document_scanner_rounded, label: l10n.scanMeal,      color: c.accent,  onTap: onScan),
      (icon: Icons.restaurant_menu_rounded,  label: l10n.addFoodLabel,   color: _purple,   onTap: onAskCoach),
      (icon: Icons.straighten_rounded,       label: l10n.bodyTab,        color: _purple,   onTap: onMeasurements),
      (icon: Icons.smart_toy_rounded,        label: l10n.askCoachLabel,  color: _purple,   onTap: onAskCoach),
    ];
    return Row(
      children: actions.asMap().entries.map((e) {
        final i = e.key;
        final a = e.value;
        return Expanded(
          child: GestureDetector(
            onTap: a.onTap,
            child: Container(
              margin: i < actions.length - 1
                  ? const EdgeInsets.only(right: 8)
                  : EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(a.icon, size: 22, color: a.color),
                  const SizedBox(height: 6),
                  Text(
                    a.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10, color: c.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Daily Nutrition Card ──────────────────────────────────────────────────────

class _DailyNutritionCard extends StatelessWidget {
  final AppLocalizations l10n;
  final int totalKcal;
  final int target;
  final double pct;
  final bool fromPlanning;
  final double protein, carbs, fat;
  final int protTarget, carbTarget, fatTarget;

  const _DailyNutritionCard({
    required this.l10n,
    required this.totalKcal,
    required this.target,
    required this.pct,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.protTarget,
    required this.carbTarget,
    required this.fatTarget,
    this.fromPlanning = false,
  });

  int get _remaining => target - totalKcal;

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    const protColor = Color(0xFF6BCB77);
    const carbColor = Color(0xFF4DA1FF);
    const fatColor  = Color(0xFFFF9F43);

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
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              Text('${l10n.dailyNutrition} 🔥',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: c.text)),
              const Spacer(),
              Text('${l10n.labelGoal}: $target kcal',
                  style: TextStyle(fontSize: 11, color: c.muted)),
              if (fromPlanning) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: c.accent.withAlpha(30),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(l10n.planning,
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700,
                          color: c.accent, letterSpacing: 0.3)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          // ── Body row ─────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: consumed + progress bar
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.consumed,
                        style: TextStyle(fontSize: 11, color: c.muted)),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$totalKcal',
                          style: TextStyle(
                            fontFamily: 'Syne', fontSize: 28,
                            fontWeight: FontWeight.w800, color: c.text,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('kcal',
                              style: TextStyle(fontSize: 12, color: c.muted)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: c.surface2,
                        valueColor: AlwaysStoppedAnimation(
                          pct > 0.95 ? const Color(0xFFFF6B6B) : c.accent,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Center: remaining ring
              SizedBox(
                width: 84, height: 84,
                child: CustomPaint(
                  painter: _RingPainter(progress: (1 - pct).clamp(0.0, 1.0)),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_remaining.abs()}',
                          style: TextStyle(
                            fontFamily: 'Syne', fontSize: 17,
                            fontWeight: FontWeight.w800, color: c.text,
                          ),
                        ),
                        Text(
                          'kcal\n${l10n.kcalRemaining}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 8, color: c.muted, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Right: macro bars
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MacroBar(name: l10n.proteins, val: protein, target: protTarget, color: protColor),
                    const SizedBox(height: 8),
                    _MacroBar(name: l10n.carbs,    val: carbs,   target: carbTarget, color: carbColor),
                    const SizedBox(height: 8),
                    _MacroBar(name: l10n.fats,     val: fat,     target: fatTarget,  color: fatColor),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String name;
  final double val;
  final int target;
  final Color color;
  const _MacroBar({required this.name, required this.val, required this.target, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final pct = (val / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
            const Spacer(),
            Text('${val.round()} / ${target}g',
                style: TextStyle(fontSize: 10, color: c.muted)),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: c.surface2,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}

// ── (legacy compact cards removed — replaced by _TodayScoreCard) ─────────────

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

  @override
  Widget build(BuildContext context) {
    final c      = AppTheme.of(context);
    final l10n   = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final isLoss = profile.goalKgPerWeek < 0;
    final days   = _daysToNextKg();
    final date   = DateFormat('d MMM', locale).format(DateTime.now().add(Duration(days: days)));
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
                  child: Text(l10n.milestoneLabel,
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
            Text(
              l10n.inDaysLabel(days),
              style: TextStyle(fontSize: 12, color: c.muted, fontFamily: 'Syne'),
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

// ── TODAY MISSION CARD (compact — side-by-side with AI Reco) ─────────────────

class _TodayMissionCard extends StatelessWidget {
  final AppLocalizations l10n;
  final List<String> slots;
  final List<bool>   slotDones;
  final int doneCount;
  final int targetProtein;
  final VoidCallback onToggleWater;
  final VoidCallback onToggleWalk;
  final VoidCallback onToggleNoSugar;
  final VoidCallback onToggleCalorie;
  final VoidCallback? onSeePlan;

  const _TodayMissionCard({
    required this.l10n,
    required this.slots,
    required this.slotDones,
    required this.doneCount,
    required this.targetProtein,
    required this.onToggleWater,
    required this.onToggleWalk,
    required this.onToggleNoSugar,
    required this.onToggleCalorie,
    this.onSeePlan,
  });

  _MissionItem _itemFor(int i) {
    final slot = slots[i];
    final done = slotDones[i];
    switch (slot) {
      case 'scan':    return _MissionItem(label: l10n.checkScan2Meals, done: done);
      case 'prot':    return _MissionItem(label: l10n.checkProteinGoal, done: done);
      case 'water':   return _MissionItem(label: l10n.checkDrinkWater,    done: done, onTap: onToggleWater);
      case 'walk':    return _MissionItem(label: l10n.checkWalk30,         done: done, onTap: onToggleWalk);
      case 'nosugar': return _MissionItem(label: l10n.checkNoSugarAfter8pm, done: done, onTap: onToggleNoSugar);
      case 'calorie': return _MissionItem(label: l10n.checkHitCalorie,    done: done, onTap: onToggleCalorie);
      case 'meas':    return _MissionItem(label: l10n.completeDailyMeasures, done: done);
      default:        return _MissionItem(label: slot, done: done);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final missions = List.generate(slots.length, _itemFor);
    final total = slots.length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(l10n.todayMission,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: c.text),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Done badge
          Text(
            '$doneCount / $total ${l10n.completedFraction}',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.accent),
          ),
          const SizedBox(height: 10),
          // Checklist (compact rows)
          ...missions.map((m) => _MissionRow(item: m, compact: true)),
          const SizedBox(height: 10),
          // Golf flag illustration
          SizedBox(
            height: 52,
            child: CustomPaint(painter: _GolfFlagPainter()),
          ),
          const SizedBox(height: 8),
          // CTA link
          GestureDetector(
            onTap: onSeePlan,
            child: Row(
              children: [
                Text(l10n.seeDailyPlan,
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: c.accent,
                    )),
                const SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, size: 14, color: c.accent),
              ],
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
  final bool compact;
  const _MissionRow({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final size = compact ? 18.0 : 22.0;
    final fontSize = compact ? 11.0 : 13.0;
    return GestureDetector(
      onTap: item.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: compact ? 3 : 5),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size, height: size,
              decoration: BoxDecoration(
                color: item.done ? c.accent : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.done ? c.accent : c.muted,
                  width: 1.8,
                ),
              ),
              child: item.done
                  ? Icon(Icons.check_rounded, size: size * 0.6, color: c.bg)
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: fontSize,
                  color: item.done ? c.muted : c.text,
                  decoration: item.done ? TextDecoration.lineThrough : null,
                  decorationColor: c.muted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Golf Flag Painter ─────────────────────────────────────────────────────────

class _GolfFlagPainter extends CustomPainter {
  static const _g = Color(0xFFc8ff5a);

  @override
  void paint(Canvas canvas, Size size) {
    final hillPaint = Paint()
      ..color = _g.withAlpha(18)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = _g.withAlpha(120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final glowPaint = Paint()
      ..color = _g.withAlpha(60)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    // Hill
    final hillPath = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.2, size.width, size.height)
      ..close();
    canvas.drawPath(hillPath, hillPaint);
    canvas.drawPath(hillPath, linePaint..style = PaintingStyle.stroke..strokeWidth = 1);

    // Flag pole
    final poleX = size.width * 0.6;
    final poleTop = size.height * 0.05;
    final poleBot = size.height * 0.65;
    canvas.drawLine(Offset(poleX, poleBot), Offset(poleX, poleTop), linePaint..strokeWidth = 1.5..style = PaintingStyle.stroke);

    // Flag triangle
    final flagPath = Path()
      ..moveTo(poleX, poleTop)
      ..lineTo(poleX + size.width * 0.22, poleTop + 8)
      ..lineTo(poleX, poleTop + 16)
      ..close();
    canvas.drawPath(flagPath, Paint()..color = _g..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(poleX, poleBot), 6, glowPaint);
    canvas.drawCircle(Offset(poleX, poleBot), 3, Paint()..color = _g);
  }

  @override
  bool shouldRepaint(_GolfFlagPainter _) => false;
}

// ── AI Recommendation Card (compact — side-by-side) ───────────────────────────

class _AiRecommendationCard extends StatelessWidget {
  final AppLocalizations l10n;
  final String text;
  final VoidCallback? onViewMore;

  const _AiRecommendationCard({
    required this.l10n,
    required this.text,
    this.onViewMore,
  });

  static const _purple = Color(0xFF7C5CFC);

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 14, color: _purple),
              const SizedBox(width: 6),
              Expanded(
                child: Text(l10n.aiRecommendation,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: c.text),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Content box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.surface2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.psychology_rounded, color: _purple, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 11, color: c.text, height: 1.4),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onViewMore,
            child: Row(
              children: [
                Text(l10n.viewMore,
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: _purple,
                    )),
                const SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, size: 14, color: _purple),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Next Milestone Card ───────────────────────────────────────────────────────

class _NextMilestoneCard extends StatelessWidget {
  final UserProfile profile;
  final AppLocalizations l10n;
  const _NextMilestoneCard({required this.profile, required this.l10n});

  int get _days {
    final kgPerDay = profile.goalKgPerWeek.abs() / 7.0;
    if (kgPerDay <= 0) return 0;
    return (1.0 / kgPerDay).round().clamp(1, 365);
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final isLoss = profile.goalKgPerWeek < 0;
    final days = _days;
    final kgLabel = isLoss ? '−1 kg' : '+1 kg';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.accent.withAlpha(60)),
      ),
      child: Row(
        children: [
          // Trophy circle
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.accent.withAlpha(20),
              border: Border.all(color: c.accent.withAlpha(80)),
            ),
            child: Icon(Icons.emoji_events_rounded, color: c.accent, size: 24),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.nextMilestone,
                    style: TextStyle(fontSize: 11, color: c.muted)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      kgLabel,
                      style: TextStyle(
                        fontFamily: 'Syne', fontSize: 22,
                        fontWeight: FontWeight.w800, color: c.accent,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        l10n.inDaysLabel(days),
                        style: TextStyle(fontSize: 12, color: c.muted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Wave chart
          SizedBox(
            width: 100, height: 48,
            child: CustomPaint(
              painter: _MilestoneWavePainter(days: days),
            ),
          ),
          const SizedBox(width: 8),
          // Arrow button
          GestureDetector(
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: c.surface2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.border),
              ),
              child: Icon(Icons.chevron_right_rounded, size: 18, color: c.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneWavePainter extends CustomPainter {
  final int days;
  const _MilestoneWavePainter({required this.days});

  static const _g = Color(0xFFc8ff5a);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = _g.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final dashPaint = Paint()
      ..color = _g.withAlpha(140)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final glowPaint = Paint()
      ..color = _g.withAlpha(80)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    final dotPaint = Paint()..color = _g;
    final flagPaint = Paint()..color = _g..style = PaintingStyle.fill;

    // Wave path (sine-like)
    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.7);
    for (int i = 0; i <= 60; i++) {
      final x = i / 60.0 * size.width * 0.75;
      final y = size.height * 0.7 -
          sin(i / 60.0 * pi * 2) * size.height * 0.25;
      if (i == 0) wavePath.moveTo(x, y);
      else wavePath.lineTo(x, y);
    }
    canvas.drawPath(wavePath, linePaint);

    // Dotted line to flag
    final dotX0 = size.width * 0.75;
    final dotY0 = size.height * 0.3;
    final flagX  = size.width * 0.95;
    final flagY  = size.height * 0.15;
    _drawDashed(canvas, Offset(dotX0, dotY0), Offset(flagX, flagY), dashPaint);

    // Glowing dot at start of dash
    canvas.drawCircle(Offset(dotX0, dotY0), 6, glowPaint);
    canvas.drawCircle(Offset(dotX0, dotY0), 3, dotPaint);

    // Mini flag
    canvas.drawLine(Offset(flagX, flagY + 2), Offset(flagX, flagY + 18), dashPaint..color = _g);
    final f = Path()
      ..moveTo(flagX, flagY + 2)
      ..lineTo(flagX + 10, flagY + 8)
      ..lineTo(flagX, flagY + 14)
      ..close();
    canvas.drawPath(f, flagPaint);
  }

  void _drawDashed(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final dist = sqrt(dx * dx + dy * dy);
    const dash = 5.0, gap = 4.0;
    double drawn = 0;
    while (drawn < dist) {
      final end = (drawn + dash).clamp(0, dist);
      canvas.drawLine(
        Offset(p1.dx + dx * drawn / dist, p1.dy + dy * drawn / dist),
        Offset(p1.dx + dx * end / dist, p1.dy + dy * end / dist),
        paint,
      );
      drawn += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_MilestoneWavePainter old) => old.days != days;
}

// ── Ring Painter ──────────────────────────────────────────────────────────────

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

// ── Weekly Chart ──────────────────────────────────────────────────────────────
class _WeeklyChart extends StatelessWidget {
  final List<Meal> meals;
  const _WeeklyChart({required this.meals});

  @override
  Widget build(BuildContext context) {
    final l10n   = AppLocalizations.of(context);
    final c      = AppTheme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final monday = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    final days   = List.generate(7, (i) => DateFormat('E', locale).format(monday.add(Duration(days: i))));
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
      return Image.file(file, fit: BoxFit.cover, cacheWidth: 120, cacheHeight: 120);
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
                  Text(_formatDate(context, meal.date),
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

  String _formatDate(BuildContext context, String iso) {
    final d      = DateTime.parse(iso);
    final locale = Localizations.localeOf(context).toString();
    return '${DateFormat('d MMM', locale).format(d)} · ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
  }
}
