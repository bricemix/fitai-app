import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/planning.dart';
import '../models/profile.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

// ── Day status ────────────────────────────────────────────────────────────────

enum _DayStatus { onTrack, attention, offTrack, notStarted }

_DayStatus _computeStatus(DayPlan plan, List<Meal> dayMeals, bool isFuture) {
  if (isFuture) return _DayStatus.notStarted;
  if (dayMeals.isEmpty) return _DayStatus.notStarted;
  final kcal    = dayMeals.fold(0, (s, m) => s + m.result.calories);
  final protein = dayMeals.fold(0.0, (s, m) => s + m.result.protein);
  final kcalOk    = kcal    >= plan.targetKcal    * 0.85 && kcal    <= plan.targetKcal    * 1.15;
  final proteinOk = protein >= plan.targetProtein * 0.85;
  if (kcalOk && proteinOk) return _DayStatus.onTrack;
  if (kcal >= plan.targetKcal * 0.70 || protein >= plan.targetProtein * 0.70) return _DayStatus.attention;
  return _DayStatus.offTrack;
}

// ── Public entry-point ────────────────────────────────────────────────────────

void showWeeklyDetailsSheet(
  BuildContext context, {
  required List<DayPlan> plans,
  required List<Meal> meals,
  required UserProfile profile,
  required VoidCallback onBalanceWeek,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) => _WeeklyDetailsSheet(
        scrollCtrl: ctrl,
        plans: plans,
        meals: meals,
        profile: profile,
        onBalanceWeek: onBalanceWeek,
      ),
    ),
  );
}

// ── Sheet widget ──────────────────────────────────────────────────────────────

class _WeeklyDetailsSheet extends StatelessWidget {
  final ScrollController scrollCtrl;
  final List<DayPlan> plans;
  final List<Meal> meals;
  final UserProfile profile;
  final VoidCallback onBalanceWeek;

  const _WeeklyDetailsSheet({
    required this.scrollCtrl,
    required this.plans,
    required this.meals,
    required this.profile,
    required this.onBalanceWeek,
  });

  List<Meal> _mealsForDate(String date) =>
      meals.where((m) => m.date.startsWith(date)).toList();

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context);
    final today = DayPlan.todayKey();
    final now   = DateTime.now();

    // Weekly stats
    final totalKcal = plans.fold(0, (s, p) => s + p.targetKcal);
    final avgKcal   = plans.isEmpty ? 0 : totalKcal ~/ plans.length;
    final targetKcal = profile.tdee.round();
    final diffKcal  = avgKcal - targetKcal;
    final proteinDays = plans.where((p) {
      final m = _mealsForDate(p.date);
      if (m.isEmpty) return false;
      final pr = m.fold(0.0, (s, x) => s + x.result.protein);
      return pr >= p.targetProtein * 0.85;
    }).length;

    // Day names short
    final dayShorts = [l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu, l10n.dayFri, l10n.daySat, l10n.daySun];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF12121f),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          // Title bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: AppTheme.accent, size: 20),
                const SizedBox(width: 10),
                Text(l10n.weeklyDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.text)),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppTheme.muted, size: 20),
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.border, height: 1),
          // Scrollable content
          Expanded(
            child: ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                // ── Weekly Summary ────────────────────────────────────────────
                _SectionTitle(l10n.weeklySummaryTitle),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1a2a1a), Color(0xFF0d0d1a)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.accent.withAlpha(40)),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: l10n.avgKcalPerDay,   value: '$avgKcal kcal/day',  accent: true),
                      const Divider(color: AppTheme.border, height: 16),
                      _SummaryRow(label: l10n.targetKcalDay2,  value: '$targetKcal kcal/day'),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: l10n.differenceKcal,
                        value: '${diffKcal >= 0 ? '+' : ''}$diffKcal kcal/day',
                        color: diffKcal.abs() <= 50
                            ? const Color(0xFF6BCB77)
                            : diffKcal.abs() <= 150
                                ? const Color(0xFFFFB347)
                                : const Color(0xFFFF5252),
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: l10n.proteinTargetReached(proteinDays, plans.length),
                        value: '$proteinDays/${plans.length}',
                        color: proteinDays >= 5 ? const Color(0xFF6BCB77) : const Color(0xFFFFB347),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Day-by-day ────────────────────────────────────────────────
                _SectionTitle(l10n.dayDetail),
                const SizedBox(height: 10),

                ...List.generate(plans.length, (i) {
                  final plan   = plans[i];
                  final planDate = DateTime.tryParse(plan.date) ?? now;
                  final isFuture = planDate.isAfter(now) && plan.date != today;
                  final isToday  = plan.date == today;
                  final dayMeals = _mealsForDate(plan.date);
                  final status   = _computeStatus(plan, dayMeals, isFuture);
                  final kcalUsed = dayMeals.fold(0, (s, m) => s + m.result.calories);
                  final proteinUsed = dayMeals.fold(0.0, (s, m) => s + m.result.protein);
                  final carbsUsed   = dayMeals.fold(0.0, (s, m) => s + m.result.carbs);
                  final fatUsed     = dayMeals.fold(0.0, (s, m) => s + m.result.fat);
                  final checkCount  = _checklistCount(plan, dayMeals);

                  final statusColor = _statusColor(status);
                  final statusLabel = _statusLabel(status, l10n);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isToday ? AppTheme.accent.withAlpha(12) : AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isToday ? AppTheme.accent.withAlpha(60) : AppTheme.border,
                        width: isToday ? 1.5 : 1,
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                        leading: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(22),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(_statusIcon(status), color: statusColor, size: 18),
                        ),
                        title: Row(
                          children: [
                            Text(
                              i < dayShorts.length ? dayShorts[i] : 'Day ${i + 1}',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            Text(_formatDate(plan.date), style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(6)),
                                child: Text(l10n.todayLabel, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF0A0A0F))),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Text('${plan.targetKcal} kcal', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.accent)),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(22),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(statusLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          const Divider(color: AppTheme.border, height: 1),
                          const SizedBox(height: 10),
                          // Macros
                          Row(
                            children: [
                              _MacroChip(label: 'P', value: isFuture ? '${plan.targetProtein}g' : '${proteinUsed.round()}g / ${plan.targetProtein}g', color: const Color(0xFF6BCB77)),
                              const SizedBox(width: 8),
                              _MacroChip(label: 'C', value: isFuture ? '${plan.targetCarbs}g'   : '${carbsUsed.round()}g / ${plan.targetCarbs}g',   color: const Color(0xFF4DA1FF)),
                              const SizedBox(width: 8),
                              _MacroChip(label: 'F', value: isFuture ? '${plan.targetFat}g'     : '${fatUsed.round()}g / ${plan.targetFat}g',       color: const Color(0xFFFFB347)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Checklist + kcal used
                          if (!isFuture && dayMeals.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 14, color: AppTheme.accent),
                                const SizedBox(width: 6),
                                Text(l10n.completedOfTotal(checkCount, 6), style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                                const Spacer(),
                                Text('$kcalUsed / ${plan.targetKcal} kcal', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                              ],
                            ),
                          // kcal progress bar
                          if (!isFuture && plan.targetKcal > 0) ...[
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (kcalUsed / plan.targetKcal).clamp(0.0, 1.0),
                                backgroundColor: AppTheme.surface2,
                                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                minHeight: 5,
                              ),
                            ),
                          ],
                          // Action buttons
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8, runSpacing: 8,
                            children: [
                              _ActionChip(label: l10n.editThisDay,  icon: Icons.edit_rounded,   onTap: () {}),
                              _ActionChip(label: l10n.replaceMeals, icon: Icons.swap_horiz_rounded, onTap: () {}),
                              _ActionChip(label: l10n.copyThisDay,  icon: Icons.copy_rounded,   onTap: () {}),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // ── Balance week CTA ──────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onBalanceWeek();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: const Color(0xFF0A0A0F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.balance_rounded, size: 18),
                    label: Text(l10n.balanceWeek, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _checklistCount(DayPlan plan, List<Meal> dayMeals) {
    int count = 0;
    final kcal    = dayMeals.fold(0, (s, m) => s + m.result.calories);
    final protein = dayMeals.fold(0.0, (s, m) => s + m.result.protein);
    if (kcal    >= plan.targetKcal    * 0.9) count++;
    if (dayMeals.length >= 2)                count++;
    if (protein >= plan.targetProtein * 0.9) count++;
    return count;
  }

  Color _statusColor(_DayStatus s) {
    switch (s) {
      case _DayStatus.onTrack:    return const Color(0xFF6BCB77);
      case _DayStatus.attention:  return const Color(0xFFFFB347);
      case _DayStatus.offTrack:   return const Color(0xFFFF5252);
      case _DayStatus.notStarted: return AppTheme.muted;
    }
  }

  IconData _statusIcon(_DayStatus s) {
    switch (s) {
      case _DayStatus.onTrack:    return Icons.check_circle_rounded;
      case _DayStatus.attention:  return Icons.warning_amber_rounded;
      case _DayStatus.offTrack:   return Icons.cancel_rounded;
      case _DayStatus.notStarted: return Icons.radio_button_unchecked_rounded;
    }
  }

  String _statusLabel(_DayStatus s, AppLocalizations l10n) {
    switch (s) {
      case _DayStatus.onTrack:    return l10n.statusOnTrack;
      case _DayStatus.attention:  return l10n.statusAttention;
      case _DayStatus.offTrack:   return l10n.statusOffTrack;
      case _DayStatus.notStarted: return l10n.statusNotStarted;
    }
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.accent, letterSpacing: 1.2),
      );
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool accent;
  final Color? color;
  const _SummaryRow({required this.label, required this.value, this.accent = false, this.color});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.muted))),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color ?? (accent ? AppTheme.accent : AppTheme.text),
            ),
          ),
        ],
      );
}

class _MacroChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MacroChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(color: color.withAlpha(18), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Text('$label: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
              Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: AppTheme.muted), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      );
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.surface2,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: AppTheme.muted),
              const SizedBox(width: 5),
              Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.muted, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
}
