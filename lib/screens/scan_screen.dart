import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb, compute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../models/meal.dart';
import '../services/ai_service.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import 'subscription_screen.dart';

/// Fonction top-level pour compute() — doit être en dehors de toute classe.
String _compressImage(Uint8List rawBytes) {
  var decoded = img.decodeImage(rawBytes);
  if (decoded == null) throw Exception('Unsupported image format');
  if (decoded.width > 1024 || decoded.height > 1024) {
    decoded = img.copyResize(
      decoded,
      width: decoded.width > decoded.height ? 1024 : -1,
      height: decoded.height >= decoded.width ? 1024 : -1,
    );
  }
  final jpeg = img.encodeJpg(decoded, quality: 85);
  return base64Encode(jpeg);
}

class ScanScreen extends StatefulWidget {
  final void Function(Meal) onMealAdded;
  const ScanScreen({super.key, required this.onMealAdded});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  XFile? _xFile;           // fichier sélectionné (cross-platform)
  Uint8List? _imageBytes;  // octets pour affichage + encodage
  bool _analyzing = false;
  FoodResult? _result;
  String? _toast;
  int _portionGrams = 100;
  final _descCtrl = TextEditingController();

  bool get _hasImage => _imageBytes != null;

  static const _portions = [50, 100, 150, 200, 300, 400];

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  void _showToast(String msg) {
    setState(() => _toast = msg);
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  // Compresse en JPEG ≤ 1024px et retourne le base64.
  // Exécuté dans un isolate séparé via compute() pour éviter les janks.
  Future<String> _toBase64Jpeg(Uint8List rawBytes) async {
    return compute(_compressImage, rawBytes);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: source, maxWidth: 1200, maxHeight: 1200);
    if (picked == null) return;

    // readAsBytes() fonctionne sur web ET mobile
    final bytes = await picked.readAsBytes();
    setState(() {
      _xFile = picked;
      _imageBytes = bytes;
      _result = null;
      _analyzing = false;
    });
  }

  Future<void> _analyze() async {
    if (_imageBytes == null) return;

    final loggedIn = await AuthService.isLoggedIn();
    if (!loggedIn) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        _showToast(l10n.loginRequired);
      }
      return;
    }

    setState(() { _analyzing = true; _result = null; });

    try {
      final b64 = await _toBase64Jpeg(_imageBytes!);
      final result = await AiService.analyzeFood(
        b64,
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      );
      if (mounted) {
        setState(() {
          _analyzing = false;
          _result = result;
          if (result.estimatedGrams != null) {
            _portionGrams = result.estimatedGrams!.clamp(30, 1000);
          }
        });
      }
    } on AiException catch (e) {
      if (mounted) {
        setState(() => _analyzing = false);
        _showToast(e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _analyzing = false);
        final l10n = AppLocalizations.of(context);
        _showToast('${l10n.error} : $e');
      }
    }
  }

  Future<void> _showConfirmDialog() async {
    if (_result == null) return;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) =>
          _ConfirmMealSheet(result: _result!, portionGrams: _portionGrams),
    );
    if (confirmed == true) await _saveMeal();
  }

  Future<void> _saveMeal() async {
    if (_result == null) return;
    // Sur web, on ne stocke pas le chemin local (non accessible)
    final path = (!kIsWeb) ? _xFile?.path : null;

    // Ajuster les valeurs nutritionnelles à la portion choisie par l'utilisateur
    final adjustedResult =
        (_result!.estimatedGrams != null && _result!.estimatedGrams! > 0)
            ? _result!.scaledTo(_portionGrams)
            : _result!;

    final meal = Meal(
      date: DateTime.now().toIso8601String(),
      imagePath: path,
      result: adjustedResult,
    );
    widget.onMealAdded(meal);
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      _showToast(l10n.mealSaved);
    }
    setState(() {
      _xFile = null;
      _imageBytes = null;
      _result = null;
      _portionGrams = 100;
    });

    // Upsell après scan si plan free
    await _maybeShowUpsell();
  }

  Future<void> _maybeShowUpsell() async {
    if (!mounted) return;
    final cached = await AuthService.getCachedUser();
    final plan = (cached?['plan'] as String? ?? cached?['subscription_plan'] as String? ?? 'free').toLowerCase();
    if (plan != 'free') return;
    if (!mounted) return;
    // Laisser le temps au confirm dialog de se fermer complètement
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) => const _ScanUpsellSheet(),
    );
  }

  void _showSourceDialog() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppTheme.accent),
                title: Text(l10n.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: AppTheme.accent),
                title: Text(l10n.chooseGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.analyzeMeal,
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(
                    l10n.scanSubtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.muted),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _PhotoDrop(imageBytes: _imageBytes, onTap: _showSourceDialog),

              // ── Zone description + bouton analyser ────────────────────────
              if (_hasImage && _result == null && !_analyzing) ...[
                const SizedBox(height: 14),
                _DescriptionField(controller: _descCtrl),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _analyze,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: const Color(0xFF0A0A0F),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.document_scanner_rounded, size: 20),
                    label: Text(l10n.analyzeMeal,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                ),
              ],

              // Analyzing overlay is rendered in the Stack, not here

              if (_result != null) ...[
                const SizedBox(height: 16),
                _ResultCard(result: _result!),
                const SizedBox(height: 12),

                // Portion picker
                if (_result!.estimatedGrams != null) ...[
                  _PortionPicker(
                    selected: _portionGrams,
                    options: _portions,
                    onChanged: (g) => setState(() => _portionGrams = g),
                  ),
                  const SizedBox(height: 12),
                ],

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showConfirmDialog,
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(l10n.iWillEat),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() { _result = null; }),
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: Text(l10n.reanalyze),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() {
                          _xFile = null;
                          _imageBytes = null;
                          _result = null;
                          _descCtrl.clear();
                        }),
                        icon: const Icon(Icons.add_photo_alternate_rounded, size: 16),
                        label: Text(l10n.newPhoto),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
        if (_analyzing)
          const Positioned.fill(child: _AnalyzingOverlay()),
        if (_toast != null)
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(100)),
                child: Text(_toast!,
                    style: const TextStyle(
                        color: AppTheme.bg,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Confirmation Sheet ─────────────────────────────────────────────────────────

class _ConfirmMealSheet extends StatelessWidget {
  final FoodResult result;
  final int portionGrams;
  const _ConfirmMealSheet({required this.result, required this.portionGrams});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.restaurant_rounded, size: 40, color: AppTheme.accent),
          ),
          const SizedBox(height: 12),
          Text(result.name,
              style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 22,
                  fontWeight: FontWeight.w800),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(l10n.portionEstimated(portionGrams),
              style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MacroChip(
                  label: '${result.calories} kcal', color: AppTheme.accent),
              const SizedBox(width: 8),
              _MacroChip(
                  label: '${result.protein.round()}g prot',
                  color: AppTheme.accent2),
              const SizedBox(width: 8),
              _MacroChip(
                  label: '${result.carbs.round()}g gl',
                  color: AppTheme.accent3),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.confirmEat,
            textAlign: TextAlign.center,
            style:
                const TextStyle(color: AppTheme.muted, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.confirmEatButton),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MacroChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: color.withAlpha(24), borderRadius: BorderRadius.circular(100)),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

// ── Portion Picker ─────────────────────────────────────────────────────────────

class _PortionPicker extends StatelessWidget {
  final int selected;
  final List<int> options;
  final void Function(int) onChanged;
  const _PortionPicker(
      {required this.selected,
      required this.options,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.adjustPortion.toUpperCase(),
            style: const TextStyle(
                fontSize: 11,
                color: AppTheme.muted,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((g) {
            final sel = g == selected;
            return GestureDetector(
              onTap: () => onChanged(g),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? AppTheme.accent : AppTheme.surface2,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: sel ? AppTheme.accent : AppTheme.border),
                ),
                child: Text('${g}g',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: sel ? AppTheme.bg : AppTheme.muted)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Description Field ──────────────────────────────────────────────────────────

class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  const _DescriptionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note_rounded, size: 18, color: AppTheme.accent),
              const SizedBox(width: 8),
              Text(
                l10n.precisions,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.precisionsHint,
            style: const TextStyle(fontSize: 12, color: AppTheme.muted),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 2,
            style: const TextStyle(color: AppTheme.text, fontSize: 14),
            decoration: InputDecoration(
              hintText: l10n.precisionsPlaceholder,
              hintStyle: const TextStyle(color: AppTheme.muted, fontSize: 13),
              filled: true,
              fillColor: AppTheme.bg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Suggestions rapides
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              '100g', '150g', '200g', '300g', l10n.entirePlate, l10n.halfPortion,
            ].map((s) => GestureDetector(
              onTap: () {
                final current = controller.text.trim();
                controller.text = current.isEmpty ? s : '$current $s';
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(s, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Photo Drop ─────────────────────────────────────────────────────────────────

class _PhotoDrop extends StatelessWidget {
  final Uint8List? imageBytes;
  final VoidCallback onTap;
  const _PhotoDrop({required this.imageBytes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 180),
        decoration: BoxDecoration(
          border:
              Border.all(color: AppTheme.accent.withAlpha(128), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: imageBytes != null
            ? Image.memory(imageBytes!, fit: BoxFit.cover, height: 240)
            : Builder(
                builder: (ctx) {
                  final l10n = AppLocalizations.of(ctx);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_photo_alternate_rounded, size: 56, color: AppTheme.accent),
                        const SizedBox(height: 12),
                        Text(l10n.addPhoto,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(
                          l10n.photoHint,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppTheme.muted, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ── Analyzing Overlay ──────────────────────────────────────────────────────────

class _AnalyzingOverlay extends StatefulWidget {
  const _AnalyzingOverlay();

  @override
  State<_AnalyzingOverlay> createState() => _AnalyzingOverlayState();
}

class _AnalyzingOverlayState extends State<_AnalyzingOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _rotateCtrl;
  late final AnimationController _dotsCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _rotateCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      color: AppTheme.bg.withAlpha(210),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 36),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.accent.withAlpha(90)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withAlpha(40),
                blurRadius: 48,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Logo animé ──────────────────────────────────────────────
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Anneau rotatif
                    RotationTransition(
                      turns: _rotateCtrl,
                      child: CustomPaint(
                        size: const Size(120, 120),
                        painter: _ScanRingPainter(),
                      ),
                    ),
                    // Logo pulsant
                    ScaleTransition(
                      scale: _pulseAnim,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withAlpha(22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.accent.withAlpha(60),
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/logo/dietvision-icon.svg',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ── Titre ───────────────────────────────────────────────────
              Text(
                l10n.analyzing,
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.aiIdentification,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),

              // ── Dots pulsants ────────────────────────────────────────────
              AnimatedBuilder(
                animation: _dotsCtrl,
                builder: (_, __) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final phase = ((_dotsCtrl.value - i / 3) % 1.0);
                      final opacity = (sin(phase * pi)).clamp(0.15, 1.0);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withOpacity(opacity),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Anneau avec dégradé rotatif
class _ScanRingPainter extends CustomPainter {
  const _ScanRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    const stroke = 4.0;

    // Fond de l'anneau (très léger)
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = AppTheme.accent.withAlpha(30);
    canvas.drawCircle(center, radius, bgPaint);

    // Arc actif avec dégradé angulaire
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: [
        AppTheme.accent.withAlpha(0),
        AppTheme.accent.withAlpha(180),
        AppTheme.accent,
      ],
      stops: const [0.0, 0.6, 1.0],
    );
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);
    canvas.drawArc(rect, -pi / 2, 2 * pi * 0.75, false, arcPaint);
  }

  @override
  bool shouldRepaint(_ScanRingPainter old) => false;
}

// ── Result Card ────────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final FoodResult result;
  const _ResultCard({required this.result});

  Color _scoreColor(int s) =>
      s >= 7 ? AppTheme.accent : s >= 4 ? const Color(0xFFffcc00) : AppTheme.accent3;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent.withAlpha(64)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.name,
                        style: const TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    if (result.estimatedGrams != null)
                      Row(children: [
                        const Icon(Icons.scale_rounded,
                            size: 13, color: AppTheme.accent),
                        const SizedBox(width: 4),
                        Text(l10n.portionEstimated(result.estimatedGrams!),
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w600)),
                      ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text('${result.calories}',
                          style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.accent)),
                      const SizedBox(width: 6),
                      const Text('kcal',
                          style: TextStyle(
                              color: AppTheme.muted, fontSize: 14)),
                    ]),
                  ],
                ),
              ),
              Column(children: [
                Text('${result.healthScore}/10',
                    style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: _scoreColor(result.healthScore))),
                Text(l10n.healthScore,
                    style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
              ]),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.4,
            children: [
              _NutrientTile(
                  label: l10n.proteins,
                  value: result.protein,
                  unit: 'g',
                  color: AppTheme.accent2),
              _NutrientTile(
                  label: l10n.carbs,
                  value: result.carbs,
                  unit: 'g',
                  color: AppTheme.accent),
              _NutrientTile(
                  label: l10n.fats,
                  value: result.fat,
                  unit: 'g',
                  color: AppTheme.accent3),
              _NutrientTile(
                  label: l10n.fibers,
                  value: result.fiber,
                  unit: 'g',
                  color: const Color(0xFFa0ff5a)),
            ],
          ),
          if (result.vitamins.isNotEmpty || result.minerals.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.science_rounded, size: 13, color: AppTheme.muted),
                      const SizedBox(width: 5),
                      Text(l10n.micronutrients, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                    ]),
                    const SizedBox(height: 4),
                    Text('${result.vitamins} · ${result.minerals}',
                        style: const TextStyle(fontSize: 13)),
                  ]),
            ),
          ],
          if (result.tip.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(18),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.accent.withAlpha(48)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.lightbulb_rounded, size: 13, color: AppTheme.accent),
                      const SizedBox(width: 5),
                      Text(l10n.tip, style: const TextStyle(fontSize: 12, color: AppTheme.accent, fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 2),
                    Text(result.tip,
                        style: const TextStyle(fontSize: 13)),
                  ]),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Scan Upsell Sheet ─────────────────────────────────────────────────────────

class _ScanUpsellSheet extends StatelessWidget {
  const _ScanUpsellSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Icône
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt_rounded, color: AppTheme.accent, size: 36),
          ),
          const SizedBox(height: 16),
          // Titre
          Text(
            l10n.scanUpsellTitle,
            style: const TextStyle(
              fontFamily: 'Syne',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Corps
          Text(
            l10n.scanUpsellBody,
            style: const TextStyle(color: AppTheme.muted, fontSize: 14, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Bouton principal
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const SubscriptionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.bg,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.workspace_premium_rounded, size: 18),
              label: Text(
                l10n.upgradeNow,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Bouton secondaire
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.notNow,
                style: const TextStyle(color: AppTheme.muted, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutrientTile extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;
  const _NutrientTile(
      {required this.label,
      required this.value,
      required this.unit,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            Text('${value.round()}',
                style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: color)),
            Text(' $unit',
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.muted)),
          ]),
          Text(label,
              style:
                  const TextStyle(fontSize: 12, color: AppTheme.muted)),
        ],
      ),
    );
  }
}
