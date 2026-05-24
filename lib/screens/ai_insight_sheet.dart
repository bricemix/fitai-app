import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

// ── Insight type enum ─────────────────────────────────────────────────────────

enum InsightType { noScan, caloriesHigh, proteinLow, carbsHigh, onTrack }

// ── Public entry point ────────────────────────────────────────────────────────

void showAiInsightSheet(
  BuildContext context, {
  required InsightType type,
  required int currentKcal,
  required int targetKcal,
  required int currentProtein,
  required int targetProtein,
  VoidCallback? onApply,
  VoidCallback? onAlternatives,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, ctrl) => _AiInsightSheet(
        type: type,
        currentKcal: currentKcal,
        targetKcal: targetKcal,
        currentProtein: currentProtein,
        targetProtein: targetProtein,
        scrollController: ctrl,
        onApply: onApply,
        onAlternatives: onAlternatives,
      ),
    ),
  );
}

// ── Main sheet widget ─────────────────────────────────────────────────────────

class _AiInsightSheet extends StatelessWidget {
  final InsightType type;
  final int currentKcal;
  final int targetKcal;
  final int currentProtein;
  final int targetProtein;
  final ScrollController scrollController;
  final VoidCallback? onApply;
  final VoidCallback? onAlternatives;

  const _AiInsightSheet({
    required this.type,
    required this.currentKcal,
    required this.targetKcal,
    required this.currentProtein,
    required this.targetProtein,
    required this.scrollController,
    this.onApply,
    this.onAlternatives,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final IconData headerIcon;
    final Color headerColor;
    final String analysisText;
    final String whyText;
    final List<_ActionCardData> actions;

    switch (type) {
      case InsightType.proteinLow:
        headerIcon = Icons.fitness_center_rounded;
        headerColor = const Color(0xFF4DA1FF);
        final gap = targetProtein - currentProtein;
        analysisText = l10n.insightProteinAnalysis(currentProtein, targetProtein, gap);
        whyText = l10n.insightWhyProtein;
        actions = [
          _ActionCardData(
            icon: Icons.egg_alt_rounded,
            color: const Color(0xFF4DA1FF),
            title: l10n.insightAction1Protein,
            detail: l10n.insightAction1ProteinDetail,
          ),
          _ActionCardData(
            icon: Icons.restaurant_rounded,
            color: const Color(0xFF4DA1FF),
            title: l10n.insightAction2Protein,
            detail: l10n.insightAction2ProteinDetail,
          ),
          _ActionCardData(
            icon: Icons.skip_next_rounded,
            color: AppTheme.muted,
            title: l10n.insightIgnoreToday,
            detail: '',
          ),
        ];
        break;

      case InsightType.caloriesHigh:
        headerIcon = Icons.local_fire_department_rounded;
        headerColor = const Color(0xFFFF6B6B);
        analysisText = l10n.insightCaloriesAnalysis(currentKcal, targetKcal);
        whyText = l10n.insightWhyCalories;
        actions = [
          _ActionCardData(
            icon: Icons.no_food_rounded,
            color: const Color(0xFFFF6B6B),
            title: l10n.insightAction1Protein,
            detail: l10n.insightAction1ProteinDetail,
          ),
          _ActionCardData(
            icon: Icons.directions_walk_rounded,
            color: const Color(0xFF6BCB77),
            title: l10n.insightAction2Protein,
            detail: l10n.insightAction2ProteinDetail,
          ),
          _ActionCardData(
            icon: Icons.skip_next_rounded,
            color: AppTheme.muted,
            title: l10n.insightIgnoreToday,
            detail: '',
          ),
        ];
        break;

      case InsightType.carbsHigh:
        headerIcon = Icons.grain_rounded;
        headerColor = const Color(0xFFFFB347);
        analysisText = l10n.insightCaloriesAnalysis(currentKcal, targetKcal);
        whyText = l10n.insightWhyCarbs;
        actions = [
          _ActionCardData(
            icon: Icons.swap_horiz_rounded,
            color: const Color(0xFFFFB347),
            title: l10n.insightAction1Protein,
            detail: l10n.insightAction1ProteinDetail,
          ),
          _ActionCardData(
            icon: Icons.restaurant_menu_rounded,
            color: const Color(0xFFFFB347),
            title: l10n.insightAction2Protein,
            detail: l10n.insightAction2ProteinDetail,
          ),
          _ActionCardData(
            icon: Icons.skip_next_rounded,
            color: AppTheme.muted,
            title: l10n.insightIgnoreToday,
            detail: '',
          ),
        ];
        break;

      case InsightType.noScan:
        headerIcon = Icons.document_scanner_rounded;
        headerColor = AppTheme.muted;
        analysisText = l10n.insightWhyNoScan;
        whyText = l10n.insightWhyNoScan;
        actions = [
          _ActionCardData(
            icon: Icons.qr_code_scanner_rounded,
            color: AppTheme.accent,
            title: l10n.insightAction1Protein,
            detail: l10n.insightAction1ProteinDetail,
          ),
          _ActionCardData(
            icon: Icons.skip_next_rounded,
            color: AppTheme.muted,
            title: l10n.insightIgnoreToday,
            detail: '',
          ),
        ];
        break;

      case InsightType.onTrack:
        headerIcon = Icons.check_circle_outline_rounded;
        headerColor = const Color(0xFF6BCB77);
        analysisText = l10n.insightCaloriesAnalysis(currentKcal, targetKcal);
        whyText = l10n.insightWhyProtein;
        actions = [
          _ActionCardData(
            icon: Icons.thumb_up_alt_rounded,
            color: const Color(0xFF6BCB77),
            title: l10n.insightAction1Protein,
            detail: l10n.insightAction1ProteinDetail,
          ),
          _ActionCardData(
            icon: Icons.skip_next_rounded,
            color: AppTheme.muted,
            title: l10n.insightIgnoreToday,
            detail: '',
          ),
        ];
        break;
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
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
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [

                // ── Header ───────────────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: headerColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.psychology_rounded, color: AppTheme.accent, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.aiInsightTitle,
                        style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.text,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.surface2,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close_rounded, size: 18, color: AppTheme.muted),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Analysis section ─────────────────────────────────────────
                _SectionTitle(
                  icon: headerIcon,
                  color: headerColor,
                  title: l10n.insightAnalysisTitle,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: headerColor.withAlpha(15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: headerColor.withAlpha(50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        analysisText,
                        style: const TextStyle(fontSize: 14, color: AppTheme.text, height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      // Metrics row
                      Row(
                        children: [
                          _MetricPill(
                            label: '${currentKcal} kcal',
                            sublabel: 'consumed',
                            color: headerColor,
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 14, color: AppTheme.muted),
                          const SizedBox(width: 8),
                          _MetricPill(
                            label: '${targetKcal} kcal',
                            sublabel: 'target',
                            color: AppTheme.muted,
                          ),
                        ],
                      ),
                      if (type == InsightType.proteinLow) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _MetricPill(
                              label: '${currentProtein}g',
                              sublabel: 'protein now',
                              color: const Color(0xFF4DA1FF),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 14, color: AppTheme.muted),
                            const SizedBox(width: 8),
                            _MetricPill(
                              label: '${targetProtein}g',
                              sublabel: 'protein target',
                              color: AppTheme.muted,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Why it matters ───────────────────────────────────────────
                _SectionTitle(
                  icon: Icons.info_outline_rounded,
                  color: AppTheme.accent,
                  title: l10n.insightWhyTitle,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surface2,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded, size: 18, color: AppTheme.accent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          whyText,
                          style: const TextStyle(fontSize: 13, color: AppTheme.muted, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Actions ──────────────────────────────────────────────────
                _SectionTitle(
                  icon: Icons.bolt_rounded,
                  color: AppTheme.accent,
                  title: l10n.insightActionsTitle,
                ),
                const SizedBox(height: 10),
                ...actions.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ActionCard(data: a),
                )),

                const SizedBox(height: 8),

                // ── Bottom buttons ───────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onApply?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: AppTheme.bg,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.applySuggestion,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onAlternatives?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.text,
                          side: const BorderSide(color: AppTheme.border),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(l10n.showAlternatives,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.muted,
                          side: const BorderSide(color: AppTheme.border),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(l10n.remindMeLater,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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

// ── Data class for action cards ───────────────────────────────────────────────

class _ActionCardData {
  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  const _ActionCardData({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
  });
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  const _SectionTitle({required this.icon, required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.4,
            )),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String sublabel;
  final Color color;
  const _MetricPill({required this.label, required this.sublabel, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
          Text(sublabel,
              style: const TextStyle(fontSize: 10, color: AppTheme.muted)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final _ActionCardData data;
  const _ActionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: data.color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, size: 20, color: data.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title,
                    style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.text,
                    )),
                if (data.detail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(data.detail,
                      style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.muted),
        ],
      ),
    );
  }
}
