import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/locale_provider.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

/// Écran de vérification de l'adresse e-mail par code à 6 chiffres.
/// Affiché après inscription. onContinue n'est appelé QUE si la vérification réussit.
/// onBack est appelé quand l'utilisateur tape "Revenir" :
///   - si null  → Navigator.pop() (cas pushed depuis auth_screen)
///   - si fourni → callback personnalisé (cas affiché comme step de main.dart → logout)
class EmailVerificationScreen extends StatefulWidget {
  final String email;
  /// Appelé UNIQUEMENT après vérification réussie
  final VoidCallback onContinue;
  /// Appelé quand l'utilisateur revient en arrière (Revenir)
  final VoidCallback? onBack;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.onContinue,
    this.onBack,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  // 6 contrôleurs pour les 6 boîtes OTP
  final List<TextEditingController> _ctrls      = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes              = List.generate(6, (_) => FocusNode());
  // FocusNodes pour RawKeyboardListener (créés ici pour éviter les fuites mémoire)
  final List<FocusNode> _rawFocusNodes           = List.generate(6, (_) => FocusNode());

  bool _verifying  = false;
  bool _sending    = false;
  String? _error;
  String? _success;

  // Countdown renvoi (60s)
  int _resendCountdown = 60;
  Timer? _countdownTimer;

  late final AnimationController _shakeCtrl;
  late final Animation<double>   _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticOut),
    );
    // Le code a déjà été envoyé au moment de l'inscription — démarre le countdown
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _shakeCtrl.dispose();
    for (final c in _ctrls) c.dispose();
    for (final f in _focusNodes) f.dispose();
    for (final f in _rawFocusNodes) f.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _resendCountdown = 60);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          t.cancel();
        }
      });
    });
  }

  String get _currentCode =>
      _ctrls.map((c) => c.text).join();

  bool get _codeComplete => _currentCode.length == 6;

  // Gère la saisie dans une boîte OTP
  void _onBoxChanged(int index, String value) {
    if (value.length > 1) {
      // Coller un code complet
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.length == 6) {
        for (var i = 0; i < 6; i++) {
          _ctrls[i].text = digits[i];
        }
        _focusNodes[5].requestFocus();
        setState(() {});
        return;
      }
      // Garder seulement le premier chiffre
      _ctrls[index].text = value[value.length - 1];
      _ctrls[index].selection = TextSelection.fromPosition(
        TextPosition(offset: 1),
      );
    }
    setState(() {});
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    // Auto-vérifier quand les 6 cases sont remplies
    if (_codeComplete) {
      Future.delayed(const Duration(milliseconds: 150), _verify);
    }
  }

  void _onBoxKeyDown(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _ctrls[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _ctrls[index - 1].clear();
      setState(() {});
    }
  }

  Future<void> _verify() async {
    if (!_codeComplete || _verifying) return;
    setState(() { _verifying = true; _error = null; _success = null; });

    final result = await AuthService.verifyEmail(widget.email, _currentCode);

    if (!mounted) return;
    setState(() => _verifying = false);

    if (result.success) {
      setState(() => _success = 'Email vérifié avec succès !');
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      widget.onContinue();
      // Si l'écran a été pushé via Navigator (depuis auth_screen),
      // onBack == null et il faut pop la route pour afficher l'onboarding.
      // Si c'est le mode gate (main.dart), onBack != null → le parent gère lui-même.
      if (mounted && widget.onBack == null && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    } else {
      // Animation shake
      _shakeCtrl.forward(from: 0);
      // Vider les cases
      for (final c in _ctrls) c.clear();
      _focusNodes[0].requestFocus();
      setState(() => _error = result.error);
    }
  }

  Future<void> _resend() async {
    if (_resendCountdown > 0 || _sending) return;
    setState(() { _sending = true; _error = null; _success = null; });

    final result = await AuthService.sendVerificationCode(widget.email);

    if (!mounted) return;
    setState(() => _sending = false);

    if (result.success) {
      _startCountdown();
      setState(() => _success = 'Nouveau code envoyé à ${widget.email}');
    } else {
      setState(() => _error = result.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);
    final c = AppTheme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  // Pas de retour (on vient de l'inscription)
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.verifyEmailTitle,
                      style: const TextStyle(
                          fontFamily: 'Syne',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  // Revenir — jamais onContinue, toujours retour
                  TextButton(
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      l10n.skipForNow,
                      style: TextStyle(color: c.muted, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // ── Icône ──────────────────────────────────────────────
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: c.accent.withAlpha(20),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: c.accent.withAlpha(60), width: 2),
                      ),
                      child: Icon(Icons.mark_email_unread_rounded,
                          color: c.accent, size: 36),
                    ),
                    const SizedBox(height: 28),

                    // ── Titre ──────────────────────────────────────────────
                    Text(
                      l10n.verifyEmailTitle,
                      style: TextStyle(
                          fontFamily: 'Syne',
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 14,
                            color: c.muted,
                            height: 1.55),
                        children: [
                          TextSpan(text: l10n.verifyEmailDesc),
                          const TextSpan(text: '\n'),
                          TextSpan(
                            text: widget.email,
                            style: TextStyle(
                                color: c.accent,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Boîtes OTP ─────────────────────────────────────────
                    AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (_, child) {
                        final shake = (_shakeAnim.value * 12 *
                                (0.5 - (_shakeAnim.value % 0.5)).abs())
                            .toDouble();
                        return Transform.translate(
                          offset: Offset(shake, 0),
                          child: child,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (i) {
                          final filled = _ctrls[i].text.isNotEmpty;
                          return Container(
                            width: 46,
                            height: 56,
                            margin: EdgeInsets.only(
                                left: i == 0 ? 0 : (i == 3 ? 12 : 6)),
                            decoration: BoxDecoration(
                              color: filled
                                  ? c.accent.withAlpha(15)
                                  : c.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _error != null
                                    ? Colors.red.shade400
                                    : _success != null
                                        ? c.accent
                                        : filled
                                            ? c.accent.withAlpha(180)
                                            : c.border,
                                width: filled || _error != null ? 2 : 1.5,
                              ),
                            ),
                            child: RawKeyboardListener(
                              focusNode: _rawFocusNodes[i],
                              onKey: (e) => _onBoxKeyDown(i, e),
                              child: TextFormField(
                                controller: _ctrls[i],
                                focusNode: _focusNodes[i],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: i == 0 ? 6 : 1,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _error != null
                                      ? Colors.red.shade300
                                      : _success != null
                                          ? c.accent
                                          : c.text,
                                  fontFamily: 'Syne',
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                  contentPadding: EdgeInsets.zero,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (v) => _onBoxChanged(i, v),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Messages ───────────────────────────────────────────
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.redAccent, size: 16),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _error!,
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_success != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: c.accent.withAlpha(18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: c.accent.withAlpha(80)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: c.accent, size: 16),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _success!,
                                style: TextStyle(
                                    color: c.accent, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),

                    // ── Bouton Vérifier ────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_codeComplete && !_verifying) ? _verify : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.accent,
                          foregroundColor: c.bg,
                          disabledBackgroundColor:
                              c.accent.withAlpha(60),
                          disabledForegroundColor:
                              c.bg.withAlpha(120),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _verifying
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: c.bg, strokeWidth: 2.5))
                            : Text(
                                l10n.verifyCode,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Bouton Renvoyer ────────────────────────────────────
                    GestureDetector(
                      onTap: _resendCountdown == 0 ? _resend : null,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _resendCountdown == 0 ? 1.0 : 0.45,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: c.border),
                          ),
                          child: _sending
                              ? const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        color: c.muted, strokeWidth: 2),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send_rounded,
                                        color: c.muted, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      _resendCountdown > 0
                                          ? '${l10n.resendCode} (${_resendCountdown}s)'
                                          : l10n.resendCode,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _resendCountdown == 0
                                            ? c.text
                                            : c.muted,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Hint
                    Text(
                      l10n.checkSpam,
                      style: TextStyle(
                          fontSize: 12,
                          color: c.muted,
                          height: 1.5),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
