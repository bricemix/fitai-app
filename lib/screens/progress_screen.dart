import 'dart:convert';
import 'dart:io';
import 'dart:math' show min, max;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../providers/locale_provider.dart';
import '../models/meal.dart';
import '../models/body_entry.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

class ProgressScreen extends StatefulWidget {
  final List<Meal> meals;
  final UserProfile profile;
  final VoidCallback? onBodyEntrySaved;
  final ValueNotifier<int>? openBodyEntryTrigger;
  const ProgressScreen({
    super.key,
    required this.meals,
    required this.profile,
    this.onBodyEntrySaved,
    this.openBodyEntryTrigger,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  AppColors get c => AppTheme.of(context);

  late TabController _tabs;
  List<BodyEntry> _entries = [];
  String? _toast;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _load();
    widget.openBodyEntryTrigger?.addListener(_onBodyEntryTrigger);
  }

  void _onBodyEntryTrigger() {
    // Switch to body tab (index 0) and open the entry sheet
    _tabs.animateTo(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openEntrySheet();
    });
  }

  Future<void> _load() async {
    final entries = await StorageService.loadBodyEntries();
    if (mounted) setState(() => _entries = entries);
  }

  Future<void> _saveEntry(BodyEntry entry) async {
    // Replace today's entry if exists, else append
    final updated = _entries.where((e) => !e.isToday).toList()..add(entry);
    await StorageService.saveBodyEntries(updated);
    setState(() => _entries = updated);
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      _showToast(l10n.saveMeasurements);
    }
    // Sync vers le serveur en arrière-plan (silencieux)
    SyncService.uploadBodyEntries(updated);
  }

  void _showToast(String msg) {
    setState(() => _toast = msg);
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  void _openEntrySheet() async {
    final today = _entries.where((e) => e.isToday).firstOrNull;
    final result = await showModalBottomSheet<BodyEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _BodyEntrySheet(existing: today, profile: widget.profile),
    );
    if (result != null) {
      await _saveEntry(result);
      widget.onBodyEntrySaved?.call();
    }
  }

  @override
  void dispose() {
    widget.openBodyEntryTrigger?.removeListener(_onBodyEntryTrigger);
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final todayEntry = _entries.where((e) => e.isToday).firstOrNull;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(l10n.progressTitle, style: Theme.of(context).textTheme.headlineMedium),
                          Text(l10n.mealsAndEntries(widget.meals.length, _entries.length),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.muted)),
                        ]),
                      ),
                      // Daily entry button
                      GestureDetector(
                        onTap: _openEntrySheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: todayEntry != null ? c.accent.withAlpha(24) : c.accent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(
                              todayEntry != null ? Icons.check_circle_rounded : Icons.add_rounded,
                              size: 16,
                              color: todayEntry != null ? c.accent : c.bg,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              todayEntry != null ? l10n.measurementsOk : l10n.todayLabel,
                              style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700,
                                color: todayEntry != null ? c.accent : c.bg,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.border)),
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabs,
                      indicator: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(9)),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: c.bg,
                      unselectedLabelColor: c.muted,
                      labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.receipt_long_rounded, size: 15), const SizedBox(width: 6), Text(l10n.mealsTab)])),
                        Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.monitor_weight_rounded, size: 15), const SizedBox(width: 6), Text(l10n.bodyTab)])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _HistoryTab(meals: widget.meals, profile: widget.profile),
                  _BodyTab(entries: _entries, profile: widget.profile, onAddEntry: _openEntrySheet),
                ],
              ),
            ),
          ],
        ),
        if (_toast != null)
          Positioned(
            top: 20, left: 16, right: 16,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(100)),
                child: Text(_toast!, style: TextStyle(color: c.bg, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Body Entry Sheet ──────────────────────────────────────────────────────────
class _BodyEntrySheet extends StatefulWidget {
  final BodyEntry? existing;
  final UserProfile profile;
  const _BodyEntrySheet({required this.existing, required this.profile});

  @override
  State<_BodyEntrySheet> createState() => _BodyEntrySheetState();
}

class _BodyEntrySheetState extends State<_BodyEntrySheet> {
  late final Map<String, TextEditingController> _ctrls;

  static const _fieldKeys = [
    (key: 'weight', unit: 'kg',  icon: Icons.monitor_weight_rounded),
    (key: 'waist',  unit: 'cm',  icon: Icons.straighten_rounded),
    (key: 'chest',  unit: 'cm',  icon: Icons.accessibility_new_rounded),
    (key: 'hips',   unit: 'cm',  icon: Icons.swap_vert_rounded),
    (key: 'biceps', unit: 'cm',  icon: Icons.fitness_center_rounded),
    (key: 'thigh',  unit: 'cm',  icon: Icons.directions_run_rounded),
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _ctrls = {
      'weight': TextEditingController(text: e?.weight?.toString() ?? widget.profile.weight),
      'waist':  TextEditingController(text: e?.waist?.toString() ?? ''),
      'chest':  TextEditingController(text: e?.chest?.toString() ?? ''),
      'hips':   TextEditingController(text: e?.hips?.toString() ?? ''),
      'biceps': TextEditingController(text: e?.biceps?.toString() ?? ''),
      'thigh':  TextEditingController(text: e?.thigh?.toString() ?? ''),
    };
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) c.dispose();
    super.dispose();
  }

  double? _parse(String key) => double.tryParse(_ctrls[key]!.text.replaceAll(',', '.'));

  void _save() {
    final entry = BodyEntry(
      date: DateTime.now().toIso8601String(),
      weight: _parse('weight'),
      waist:  _parse('waist'),
      chest:  _parse('chest'),
      hips:   _parse('hips'),
      biceps: _parse('biceps'),
      thigh:  _parse('thigh'),
    );
    if (entry.isEmpty) return;
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';

    final fieldLabels = [
      l10n.weight,
      l10n.waist,
      l10n.chest,
      l10n.hips,
      l10n.biceps,
      l10n.thighs,
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: Text(l10n.todayMeasurements, style: TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w800))),
              Text(dateStr, style: TextStyle(color: c.muted, fontSize: 13)),
            ]),
            const SizedBox(height: 4),
            Text(l10n.fillAvailable, style: TextStyle(color: c.muted, fontSize: 12)),
            const SizedBox(height: 20),
            ...List.generate(_fieldKeys.length, (i) {
              final f = _fieldKeys[i];
              final label = fieldLabels[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(f.icon, size: 20, color: c.muted),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(label.toUpperCase(), style: TextStyle(fontSize: 10, color: c.muted, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _ctrls[f.key],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(hintText: '—', suffixText: f.unit, suffixStyle: TextStyle(color: c.muted)),
                          style: TextStyle(color: c.text),
                        ),
                      ]),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _save, child: Text(l10n.saveMeasurements))),
          ],
        ),
      ),
    );
  }
}

// ── Body Tab ──────────────────────────────────────────────────────────────────
class _BodyTab extends StatelessWidget {
  final List<BodyEntry> entries;
  final UserProfile profile;
  final VoidCallback onAddEntry;
  const _BodyTab({required this.entries, required this.profile, required this.onAddEntry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center_rounded, size: 48, color: c.muted),
            const SizedBox(height: 12),
            Text(l10n.noMeasurements, style: TextStyle(color: c.muted, fontSize: 15)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onAddEntry, child: Text(l10n.addFirstMeasures)),
          ],
        ),
      );
    }

    final recent = entries.length > 8 ? entries.sublist(entries.length - 8) : entries;
    final latest = entries.last;
    final previous = entries.length >= 2 ? entries[entries.length - 2] : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          // Latest snapshot
          _LatestCard(entry: latest, previous: previous),
          const SizedBox(height: 14),

          // Goal projection
          _GoalProjectionCard(profile: profile, entries: entries),
          const SizedBox(height: 14),

          // Weight trend chart
          if (entries.any((e) => e.weight != null))
            _TrendChart(
              title: l10n.weight,
              unit: 'kg',
              icon: Icons.monitor_weight_rounded,
              entries: recent,
              getValue: (e) => e.weight,
              color: c.accent,
              lowerIsBetter: true,
            ),

          // Waist trend
          if (entries.any((e) => e.waist != null)) ...[
            const SizedBox(height: 14),
            _TrendChart(
              title: l10n.waist,
              unit: 'cm',
              icon: Icons.straighten_rounded,
              entries: recent,
              getValue: (e) => e.waist,
              color: c.accent3,
              lowerIsBetter: true,
            ),
          ],

          // Biceps trend
          if (entries.any((e) => e.biceps != null)) ...[
            const SizedBox(height: 14),
            _TrendChart(
              title: l10n.biceps,
              unit: 'cm',
              icon: Icons.fitness_center_rounded,
              entries: recent,
              getValue: (e) => e.biceps,
              color: c.accent2,
              lowerIsBetter: false,
            ),
          ],

          // Chest trend
          if (entries.any((e) => e.chest != null)) ...[
            const SizedBox(height: 14),
            _TrendChart(
              title: l10n.chest,
              unit: 'cm',
              icon: Icons.accessibility_new_rounded,
              entries: recent,
              getValue: (e) => e.chest,
              color: const Color(0xFFa0ff5a),
              lowerIsBetter: false,
            ),
          ],

          const SizedBox(height: 14),

          // Full history list
          _MeasurementHistory(entries: entries),
        ],
      ),
    );
  }
}

// ── Latest snapshot card ──────────────────────────────────────────────────────
class _LatestCard extends StatelessWidget {
  final BodyEntry entry;
  final BodyEntry? previous;
  const _LatestCard({required this.entry, required this.previous});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final metrics = [
      if (entry.weight != null) (label: l10n.weight, val: entry.weight!, unit: 'kg', prev: previous?.weight, color: c.accent),
      if (entry.waist  != null) (label: l10n.waist,  val: entry.waist!,  unit: 'cm', prev: previous?.waist, color: c.accent3),
      if (entry.chest  != null) (label: l10n.chest,  val: entry.chest!,  unit: 'cm', prev: previous?.chest, color: const Color(0xFFa0ff5a)),
      if (entry.biceps != null) (label: l10n.biceps, val: entry.biceps!, unit: 'cm', prev: previous?.biceps, color: c.accent2),
      if (entry.hips   != null) (label: l10n.hips,   val: entry.hips!,   unit: 'cm', prev: previous?.hips,  color: const Color(0xFFffcc00)),
      if (entry.thigh  != null) (label: l10n.thighs, val: entry.thigh!,  unit: 'cm', prev: previous?.thigh, color: const Color(0xFFff9a5a)),
    ];

    if (metrics.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [c.surface, Color(0xFF1a1a30)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(l10n.lastMeasurements, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(_formatDate(entry.date), style: TextStyle(fontSize: 12, color: c.muted)),
          ]),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: metrics.map((m) => _MetricChip(
              label: m.label,
              val: m.val,
              unit: m.unit,
              prev: m.prev,
              color: m.color,
              goodIfDown: m.color == c.accent || m.color == c.accent3 || m.color == Color(0xFFffcc00),
            )).toList(),
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    final d = DateTime.parse(iso);
    return '${d.day}/${d.month}/${d.year}';
  }
}

class _MetricChip extends StatelessWidget {
  final String label, unit;
  final double val;
  final double? prev;
  final Color color;
  final bool goodIfDown;
  const _MetricChip({required this.label, required this.val, required this.unit, required this.prev, required this.color, this.goodIfDown = false});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    double? diff = prev != null ? val - prev! : null;
    String? diffStr;
    Color? diffColor;
    if (diff != null && diff.abs() > 0.05) {
      // For weight/waist/hips: decrease = good (green). For biceps/chest: increase = good
      final isPositive = diff > 0;
      diffColor = (goodIfDown ? !isPositive : isPositive) ? c.accent : c.accent3;
      diffStr = '${isPositive ? '+' : ''}${diff.toStringAsFixed(1)}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: color.withAlpha(18), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withAlpha(48))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: c.muted)),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(val.toStringAsFixed(1), style: TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(width: 3),
              Padding(padding: const EdgeInsets.only(bottom: 3), child: Text(unit, style: TextStyle(fontSize: 11, color: c.muted))),
              if (diffStr != null) ...[
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(diffStr, style: TextStyle(fontSize: 11, color: diffColor, fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Trend Chart (line chart) ──────────────────────────────────────────────────
class _TrendChart extends StatelessWidget {
  final String title;
  final String unit;
  final IconData icon;
  final List<BodyEntry> entries;
  final double? Function(BodyEntry) getValue;
  final Color color;
  final bool lowerIsBetter;
  const _TrendChart({
    required this.title, required this.icon,
    required this.entries, required this.getValue,
    required this.color, this.lowerIsBetter = false,
    this.unit = '',
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final points = entries
        .map((e) => (date: e.date, val: getValue(e)))
        .where((p) => p.val != null)
        .toList();
    if (points.isEmpty) return const SizedBox();

    final vals = points.map((p) => p.val!).toList();
    final current = vals.last;
    final previous = vals.length >= 2 ? vals[vals.length - 2] : null;
    final prevDate = points.length >= 2 ? DateTime.parse(points[points.length - 2].date) : null;

    final diff = previous != null ? current - previous : null;
    final isRising = diff != null && diff > 0.05;
    final isFalling = diff != null && diff < -0.05;
    final good = lowerIsBetter ? isFalling : isRising;
    final trendColor = (isRising || isFalling)
        ? (good ? c.accent : c.accent3)
        : c.muted;
    final trendLabel = isRising ? l10n.trendRising
        : isFalling ? l10n.trendFalling
        : l10n.stable;

    final dateLabels = points
        .map((p) { final d = DateTime.parse(p.date); return '${d.day}/${d.month}'; })
        .toList();

    return GestureDetector(
      onTap: () => _showDetailSheet(context, title: title, unit: unit, color: color,
          points: points, lowerIsBetter: lowerIsBetter),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────
            Row(children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, size: 16, color: c.muted),
            ]),
            const SizedBox(height: 14),
            // ── Chart + value side by side ───────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Chart
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 90,
                    child: CustomPaint(
                      painter: _LineChartPainter(
                        values: vals,
                        color: color,
                        labels: dateLabels,
                        mutedColor: c.muted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Value + trend
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(
                          text: current.toStringAsFixed(1),
                          style: TextStyle(fontFamily: 'Syne', fontSize: 26,
                              fontWeight: FontWeight.w900, color: color),
                        ),
                        TextSpan(
                          text: ' $unit',
                          style: TextStyle(fontSize: 12, color: c.muted),
                        ),
                      ],
                    )),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: trendColor.withAlpha(24),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(trendLabel,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: trendColor)),
                    ),
                    if (diff != null && diff.abs() > 0.05 && prevDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} $unit',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: trendColor),
                      ),
                      Text(
                        'vs ${prevDate.day}/${prevDate.month}',
                        style: TextStyle(fontSize: 10, color: c.muted),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailSheet(BuildContext ctx, {
    required String title, required String unit, required Color color,
    required List<({String date, double? val})> points, required bool lowerIsBetter,
  }) {
    final c = AppTheme.of(ctx);
    final vals = points.map((p) => p.val!).toList();
    final labels = points.map((p) { final d = DateTime.parse(p.date); return '${d.day}/${d.month}'; }).toList();
    showModalBottomSheet(
      context: ctx, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 340,
        decoration: BoxDecoration(
          color: c.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Row(children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 20),
          Expanded(child: CustomPaint(
            painter: _LineChartPainter(values: vals, color: color, labels: labels,
                mutedColor: c.muted, showYAxis: true),
          )),
        ]),
      ),
    );
  }
}

// ── Line Chart CustomPainter ──────────────────────────────────────────────────
class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final List<String> labels;
  final Color mutedColor;
  final bool showYAxis;

  const _LineChartPainter({
    required this.values, required this.color,
    this.labels = const [], required this.mutedColor,
    this.showYAxis = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) {
      // Single point — draw a dot
      final paint = Paint()..color = color..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2 - 10), 5, paint);
      return;
    }

    final labelH = labels.isNotEmpty ? 18.0 : 0.0;
    final chartH = size.height - labelH;
    final w = size.width;

    final minV = values.reduce(min);
    final maxV = values.reduce(max);
    final range = (maxV - minV).clamp(1.0, double.infinity);
    final pad = range * 0.15;

    double toY(double v) =>
        chartH - ((v - (minV - pad)) / (range + pad * 2) * chartH * 0.90 + chartH * 0.05);
    double toX(int i) => i / (values.length - 1) * w;

    final pts = List.generate(values.length, (i) => Offset(toX(i), toY(values[i])));

    // ── Gradient fill ──────────────────────────────────────────────
    final fillPath = Path()
      ..moveTo(pts.first.dx, chartH)
      ..lineTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final cp1 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i].dy);
      final cp2 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i + 1].dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i + 1].dx, pts[i + 1].dy);
    }
    fillPath
      ..lineTo(pts.last.dx, chartH)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withAlpha(70), color.withAlpha(0)],
      ).createShader(Rect.fromLTWH(0, 0, w, chartH))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // ── Curve ──────────────────────────────────────────────────────
    final linePath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final cp1 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i].dy);
      final cp2 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i + 1].dy);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i + 1].dx, pts[i + 1].dy);
    }
    canvas.drawPath(linePath, Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round);

    // ── Dots ───────────────────────────────────────────────────────
    for (int i = 0; i < pts.length; i++) {
      final isLast = i == pts.length - 1;
      if (isLast) {
        canvas.drawCircle(pts[i], 6, Paint()..color = color.withAlpha(30));
        canvas.drawCircle(pts[i], 4, Paint()..color = color);
        canvas.drawCircle(pts[i], 2.5, Paint()..color = Colors.white.withAlpha(200));
      } else {
        canvas.drawCircle(pts[i], 3, Paint()..color = color.withAlpha(150));
      }
    }

    // ── X date labels ──────────────────────────────────────────────
    if (labels.isNotEmpty) {
      final textStyle = TextStyle(
        fontSize: 8, color: mutedColor, fontWeight: FontWeight.w500,
      );
      for (int i = 0; i < labels.length; i++) {
        // Show first, last, and evenly spaced
        if (labels.length > 5 && i != 0 && i != labels.length - 1 && i % 2 != 0) continue;
        final tp = TextPainter(
          text: TextSpan(text: labels[i], style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        final x = (toX(i) - tp.width / 2).clamp(0.0, w - tp.width);
        tp.paint(canvas, Offset(x, chartH + 3));
      }
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.values != values || old.color != color;
}

class _DeltaBadge extends StatelessWidget {
  final double first, last;
  final bool lowerIsBetter;
  const _DeltaBadge({required this.first, required this.last, required this.lowerIsBetter});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    final diff = last - first;
    if (diff.abs() < 0.05) return const SizedBox();
    final good = lowerIsBetter ? diff < 0 : diff > 0;
    final color = good ? c.accent : c.accent3;
    final sign = diff > 0 ? '+' : '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withAlpha(24), borderRadius: BorderRadius.circular(100)),
      child: Text('$sign${diff.toStringAsFixed(1)}', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

// ── Measurement History List ───────────────────────────────────────────────────
class _MeasurementHistory extends StatelessWidget {
  final List<BodyEntry> entries;
  const _MeasurementHistory({required this.entries});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final reversed = entries.reversed.toList();
    return Container(
      decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: c.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Text(l10n.fullHistory, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          ...reversed.take(30).toList().asMap().entries.map((e) {
            final entry = e.value;
            final isLast = e.key == (reversed.length - 1).clamp(0, 29);
            final d = DateTime.parse(entry.date);
            final dateStr = '${d.day}/${d.month} · ${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';

            final parts = <String>[];
            if (entry.weight != null) parts.add('${entry.weight!.toStringAsFixed(1)} kg');
            if (entry.waist  != null) parts.add('${l10n.waist} ${entry.waist!.toStringAsFixed(1)} cm');
            if (entry.chest  != null) parts.add('${l10n.chest} ${entry.chest!.toStringAsFixed(1)} cm');
            if (entry.biceps != null) parts.add('${l10n.biceps} ${entry.biceps!.toStringAsFixed(1)} cm');
            if (entry.hips   != null) parts.add('${l10n.hips} ${entry.hips!.toStringAsFixed(1)} cm');
            if (entry.thigh  != null) parts.add('${l10n.thighs} ${entry.thigh!.toStringAsFixed(1)} cm');

            return Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(border: isLast ? null : Border(bottom: BorderSide(color: c.border))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.rule_rounded, size: 16, color: c.muted),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateStr, style: TextStyle(fontSize: 12, color: c.muted)),
                        const SizedBox(height: 3),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: parts.map((p) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(100)),
                            child: Text(p, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Goal Projection ───────────────────────────────────────────────────────────

/// Données calculées pour la projection d'objectif.
class _Projection {
  final double currentWeight;
  final double targetWeight;
  final double kgToGo;         // négatif = perte, positif = prise
  final double weeklyRate;     // rythme réel en kg/semaine
  final DateTime? projectedDate;
  final double percentDone;    // 0–100
  final bool isOnTrack;        // rythme réel ≥ 70 % du rythme cible
  final bool wrongDirection;   // poids évolue à l'inverse de l'objectif

  const _Projection({
    required this.currentWeight,
    required this.targetWeight,
    required this.kgToGo,
    required this.weeklyRate,
    required this.projectedDate,
    required this.percentDone,
    required this.isOnTrack,
    required this.wrongDirection,
  });

  /// Calcule la projection à partir du profil + historique corporel.
  /// Retourne null si l'objectif est "Maintenir" ou si les données sont insuffisantes.
  static _Projection? compute(UserProfile profile, List<BodyEntry> entries) {
    // Filtrer les entrées avec poids
    final withWeight = entries.where((e) => e.weight != null).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    if (withWeight.isEmpty) return null;

    final currentWeight = withWeight.last.weight!;
    final startWeight   = double.tryParse(profile.weight) ?? currentWeight;
    final height        = double.tryParse(profile.height) ?? 170.0;
    // Use goalKgPerWeek (locale-independent) to detect goal type
    final isLoss = profile.goalKgPerWeek < -0.05 ||
        (profile.goalKgPerWeek == 0 &&
          (profile.goal.toLowerCase().contains('perd') ||
           profile.goal.toLowerCase().contains('loss') ||
           profile.goal.toLowerCase().contains('perd') ||
           profile.goal.toLowerCase().contains('abnehm') ||
           profile.goal.toLowerCase().contains('bajar')));
    final isGain = profile.goalKgPerWeek > 0.05 ||
        (profile.goalKgPerWeek == 0 &&
          (profile.goal.toLowerCase().contains('masse') ||
           profile.goal.toLowerCase().contains('gain') ||
           profile.goal.toLowerCase().contains('muscle') ||
           profile.goal.toLowerCase().contains('zunehm') ||
           profile.goal.toLowerCase().contains('ganar')));
    if (!isLoss && !isGain) return null; // Maintain → no projection

    // ── Poids cible ─────────────────────────────────────────────────────
    double targetWeight;
    if (isLoss) {
      // IMC sain = 22
      targetWeight = 22.0 * (height / 100) * (height / 100);
      // Si déjà sous l'objectif IMC, projeter –5 kg supplémentaires
      if (targetWeight >= currentWeight) targetWeight = currentWeight - 5;
    } else {
      // Prise de masse : +10 % du poids de départ
      targetWeight = startWeight * 1.10;
      if (targetWeight <= currentWeight) targetWeight = currentWeight + 3;
    }

    // ── Rythme réel (tendance linéaire sur l'historique disponible) ──────
    double weeklyRate;
    if (withWeight.length >= 2) {
      final first = withWeight.first;
      final last  = withWeight.last;
      final days  = DateTime.parse(last.date)
          .difference(DateTime.parse(first.date))
          .inDays;
      weeklyRate = days > 0
          ? (last.weight! - first.weight!) / days * 7
          : (profile.goalKgPerWeek != 0 ? profile.goalKgPerWeek : (isLoss ? -0.3 : 0.3));
    } else {
      weeklyRate = profile.goalKgPerWeek != 0
          ? profile.goalKgPerWeek
          : (isLoss ? -0.3 : 0.3);
    }

    final kgToGo       = targetWeight - currentWeight;
    final wrongDir     = (isLoss && weeklyRate > 0.05) || (isGain && weeklyRate < -0.05);
    final stagnant     = weeklyRate.abs() < 0.05;

    // ── Date projetée ────────────────────────────────────────────────────
    DateTime? projectedDate;
    if (!wrongDir && !stagnant && (kgToGo / weeklyRate) > 0) {
      final weeksLeft = kgToGo / weeklyRate;
      projectedDate = DateTime.now().add(Duration(days: (weeksLeft * 7).round()));
    }

    // ── Progression % ───────────────────────────────────────────────────
    final totalKg  = (targetWeight - startWeight).abs().clamp(0.1, 500.0);
    final doneKg   = (currentWeight - startWeight).abs();
    final pct      = (doneKg / totalKg * 100).clamp(0.0, 100.0);

    // ── Sur la bonne voie ? ──────────────────────────────────────────────
    final goalRate = profile.goalKgPerWeek.abs();
    final isOnTrack = goalRate == 0
        ? !stagnant
        : (!wrongDir && weeklyRate.abs() >= goalRate * 0.7);

    return _Projection(
      currentWeight: currentWeight,
      targetWeight:  targetWeight,
      kgToGo:        kgToGo,
      weeklyRate:    weeklyRate,
      projectedDate: projectedDate,
      percentDone:   pct,
      isOnTrack:     isOnTrack,
      wrongDirection: wrongDir,
    );
  }
}

class _GoalProjectionCard extends StatelessWidget {
  final UserProfile profile;
  final List<BodyEntry> entries;
  const _GoalProjectionCard({required this.profile, required this.entries});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final proj = _Projection.compute(profile, entries);

    // Pas de projection possible → card vide
    if (proj == null) return const SizedBox();

    final isLoss   = proj.kgToGo < 0;
    final accent   = isLoss ? c.accent3 : c.accent2; // rouge perte, violet gain
    final goalIcon = isLoss ? Icons.trending_down_rounded : Icons.trending_up_rounded;

    // Statut
    final (statusLabel, statusColor) = proj.wrongDirection
        ? (l10n.wrongDirection, c.accent3)
        : proj.isOnTrack
            ? (l10n.onTrack, c.accent)
            : (l10n.late, const Color(0xFFffcc00));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.surface, accent.withAlpha(18)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withAlpha(48)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête ────────────────────────────────────────────────────
          Row(children: [
            Icon(goalIcon, size: 18, color: accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.projectionGoal,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(28),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: statusColor.withAlpha(60)),
              ),
              child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor)),
            ),
          ]),
          const SizedBox(height: 16),

          // ── Barre de progression ───────────────────────────────────────
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${proj.currentWeight.toStringAsFixed(1)} kg',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${proj.targetWeight.toStringAsFixed(1)} kg',
                      style: TextStyle(fontSize: 12, color: c.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: proj.percentDone / 100,
                    backgroundColor: c.border,
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${proj.percentDone.toStringAsFixed(0)} % ${l10n.accomplished.toLowerCase()}',
                      style: TextStyle(fontSize: 10, color: accent, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${proj.kgToGo.abs().toStringAsFixed(1)} kg',
                      style: TextStyle(fontSize: 10, color: c.muted),
                    ),
                  ],
                ),
              ]),
            ),
          ]),
          const SizedBox(height: 16),

          // ── Statistiques en grille ─────────────────────────────────────
          Row(children: [
            _ProjStat(
              icon: Icons.calendar_today_rounded,
              label: l10n.estimatedDate,
              value: proj.projectedDate != null
                  ? _formatDate(proj.projectedDate!, l10n)
                  : proj.wrongDirection ? l10n.reverseTrend : l10n.stable,
              color: accent,
            ),
            const SizedBox(width: 10),
            _ProjStat(
              icon: Icons.speed_rounded,
              label: l10n.currentRhythm,
              value: proj.weeklyRate.abs() < 0.05
                  ? l10n.stable
                  : '${proj.weeklyRate > 0 ? '+' : ''}${proj.weeklyRate.toStringAsFixed(2)} kg/sem',
              color: accent,
            ),
          ]),

          // ── Conseil ───────────────────────────────────────────────────
          if (proj.projectedDate != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.surface2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, size: 15, color: accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _tip(proj, l10n),
                      style: TextStyle(fontSize: 12, color: c.muted, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime d, AppLocalizations l10n) {
    final diff = d.difference(DateTime.now());
    final weeks = (diff.inDays / 7).round();
    if (weeks <= 0) return l10n.goalReached;
    if (weeks == 1) return l10n.in1Week;
    if (weeks < 5)  return l10n.inXWeeks(weeks);
    if (weeks < 9)  return l10n.inXWeeks((weeks / 4).round() * 4);
    return '${d.day}/${d.month}/${d.year}';
  }

  String _tip(_Projection p, AppLocalizations l10n) {
    if (p.wrongDirection) {
      return l10n.weightGoingWrong;
    }
    if (!p.isOnTrack) {
      return l10n.reverseTrend;
    }
    final weeks = p.projectedDate!.difference(DateTime.now()).inDays ~/ 7;
    if (weeks <= 4) return l10n.goalReached;
    return l10n.inXWeeks(weeks);
  }
}

class _ProjStat extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _ProjStat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(36)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 10, color: c.muted)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ]),
      ),
    );
  }
}

// ── History Tab (repas) ───────────────────────────────────────────────────────
class _HistoryTab extends StatelessWidget {
  final List<Meal> meals;
  final UserProfile profile;
  const _HistoryTab({required this.meals, required this.profile});

  Map<String, List<Meal>> _groupByDate(AppLocalizations l10n) {
    final map = <String, List<Meal>>{};
    for (final m in meals.reversed) {
      final d = DateTime.parse(m.date);
      final key = _dateLabel(d, l10n);
      map.putIfAbsent(key, () => []).add(m);
    }
    return map;
  }

  String _dateLabel(DateTime d, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    if (day == today) return l10n.todayLabel;
    return '${d.day}/${d.month}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    if (meals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_rounded, size: 48, color: c.muted),
            const SizedBox(height: 12),
            Text(l10n.noMeals, style: TextStyle(color: c.muted, fontSize: 15)),
            const SizedBox(height: 4),
            Text(l10n.scanFirst, style: TextStyle(color: c.muted, fontSize: 13)),
          ],
        ),
      );
    }

    final grouped = _groupByDate(l10n);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: grouped.length + 1,
      itemBuilder: (_, i) {
        // ── Summary card (item 0) ──────────────────────────────────────
        if (i == 0) return _MealSummaryCard(meals: meals, profile: profile);

        final label = grouped.keys.elementAt(i - 1);
        final dayMeals = grouped[label]!;
        final dayKcal = dayMeals.fold(0, (s, m) => s + m.result.calories);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 4),
              child: Row(children: [
                Icon(Icons.calendar_month_rounded, size: 14, color: c.accent),
                const SizedBox(width: 6),
                Text(label, style: TextStyle(fontFamily: 'Syne', fontSize: 15, fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: c.accent.withAlpha(24), borderRadius: BorderRadius.circular(100)),
                  child: Text('$dayKcal kcal', style: TextStyle(fontSize: 12, color: c.accent, fontWeight: FontWeight.w600)),
                ),
              ]),
            ),
            Container(
              decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.border)),
              child: Column(
                children: dayMeals.asMap().entries.map((e) {
                  return _MealTile(meal: e.value, isLast: e.key == dayMeals.length - 1);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

// ── Meal Summary Card ─────────────────────────────────────────────────────────
class _MealSummaryCard extends StatelessWidget {
  final List<Meal> meals;
  final UserProfile profile;
  const _MealSummaryCard({required this.meals, required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayMeals = meals.where((m) {
      final d = DateTime.parse(m.date);
      return DateTime(d.year, d.month, d.day) == today;
    }).toList();

    final todayKcal = todayMeals.fold(0, (s, m) => s + m.result.calories);
    final target = profile.tdee.round();
    final progress = (todayKcal / target.clamp(1, 99999)).clamp(0.0, 1.0);

    final avgScore = meals.isEmpty
        ? 0.0
        : meals.fold(0.0, (s, m) => s + m.result.healthScore) / meals.length;

    String qualityLabel(double sc) {
      if (sc >= 7) return l10n.veryGood;
      if (sc >= 4) return l10n.goodLabel;
      return l10n.fairLabel;
    }

    Color qualityColor(double sc) {
      if (sc >= 7) return c.accent;
      if (sc >= 4) return const Color(0xFFffcc00);
      return c.accent3;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.border),
        ),
        child: Column(
          children: [
            // ── Stat row ────────────────────────────────────────────
            IntrinsicHeight(
              child: Row(
                children: [
                  // Kcal today
                  Expanded(child: _SummaryStatCell(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: c.accent,
                    label: l10n.totalTodayLabel,
                    value: '$todayKcal kcal',
                    subtitle: l10n.kcalTargetValue(target),
                    border: false,
                  )),
                  VerticalDivider(width: 1, color: c.border),
                  // Meals today / total
                  Expanded(child: _SummaryStatCell(
                    icon: Icons.restaurant_rounded,
                    iconColor: const Color(0xFF4DA1FF),
                    label: l10n.mealsLoggedLabel,
                    value: '${todayMeals.length} / ${meals.length}',
                    subtitle: l10n.todayLabel,
                    border: false,
                  )),
                  VerticalDivider(width: 1, color: c.border),
                  // Avg health score
                  Expanded(child: _SummaryStatCell(
                    icon: Icons.star_rounded,
                    iconColor: qualityColor(avgScore),
                    label: l10n.avgHealthScoreLabel,
                    value: '${avgScore.toStringAsFixed(1)} / 10',
                    subtitle: qualityLabel(avgScore),
                    subtitleColor: qualityColor(avgScore),
                    border: false,
                  )),
                ],
              ),
            ),
            // ── Calorie progress bar ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  Divider(color: c.border, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$todayKcal kcal',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.accent)),
                      Text('$target kcal',
                          style: TextStyle(fontSize: 11, color: c.muted)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: c.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 1.0 ? c.accent3 : c.accent,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStatCell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, value, subtitle;
  final Color? subtitleColor;
  final bool border;
  const _SummaryStatCell({
    required this.icon, required this.iconColor,
    required this.label, required this.value, required this.subtitle,
    this.subtitleColor, this.border = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 5),
            Expanded(child: Text(label,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: c.muted))),
          ]),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(
              fontFamily: 'Syne', fontSize: 15, fontWeight: FontWeight.w800,
              color: iconColor)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(
              fontSize: 10, color: subtitleColor ?? c.muted,
              fontWeight: subtitleColor != null ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }
}

/// Affiche la miniature d'un repas — fichier local OU base64 synchronisé (nouveau téléphone).
Widget _buildProgressMealThumb(Meal meal) {
  // 1. Fichier local présent sur cet appareil
  if (meal.imagePath != null) {
    final file = File(meal.imagePath!);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover,
          cacheWidth: 120, cacheHeight: 120,
          errorBuilder: (_, __, ___) => _progressMealIcon());
    }
  }
  // 2. Miniature base64 synchronisée depuis le serveur (nouveau téléphone / réinstallation)
  if (meal.thumbnailBase64 != null && meal.thumbnailBase64!.isNotEmpty) {
    try {
      final bytes = base64Decode(meal.thumbnailBase64!);
      return Image.memory(bytes, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _progressMealIcon());
    } catch (_) {}
  }
  // 3. Fallback icône
  return _progressMealIcon();
}

Widget _progressMealIcon({Color? color}) =>
    Center(child: Icon(Icons.restaurant_rounded, size: 22, color: color ?? AppTheme.muted));

class _MealTile extends StatelessWidget {
  final Meal meal;
  final bool isLast;
  const _MealTile({required this.meal, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.of(context);
    Color scoreColor(int s) => s >= 7 ? c.accent : s >= 4 ? const Color(0xFFffcc00) : c.accent3;
    final d = DateTime.parse(meal.date);
    final time = '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(border: isLast ? null : Border(bottom: BorderSide(color: c.border))),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(time, style: TextStyle(fontSize: 12, color: c.muted, fontWeight: FontWeight.w500))),
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: _buildProgressMealThumb(meal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(meal.result.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Builder(builder: (ctx) {
                final l = AppLocalizations.of(ctx);
                return Text(
                  '${meal.result.protein.round()}g ${l.proteins} · ${meal.result.carbs.round()}g ${l.carbs} · ${meal.result.fat.round()}g ${l.fats}',
                  style: TextStyle(fontSize: 11, color: c.muted),
                );
              }),
            ]),
          ),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${meal.result.calories}', style: TextStyle(fontFamily: 'Syne', fontSize: 16, fontWeight: FontWeight.w700, color: c.accent)),
            Text('kcal', style: TextStyle(fontSize: 10, color: c.muted)),
            const SizedBox(height: 2),
            Text('${meal.result.healthScore}/10', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: scoreColor(meal.result.healthScore))),
          ]),
        ],
      ),
    );
  }
}
