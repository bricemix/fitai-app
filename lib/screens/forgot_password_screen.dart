import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

/// Écran de réinitialisation du mot de passe — 2 étapes :
///   1. Saisie de l'email → envoi du code 6 chiffres
///   2. Saisie du code + nouveau mot de passe + confirmation
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  int _step = 1; // 1 = email, 2 = code + new password, 3 = success

  // Step 1
  final _emailFormKey = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  bool  _sendingCode  = false;
  String? _step1Error;

  // Step 2
  final _resetFormKey = GlobalKey<FormState>();
  final List<TextEditingController> _codeCtrl =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _codeFocus    = List.generate(6, (_) => FocusNode());
  final List<FocusNode> _rawCodeFocus = List.generate(6, (_) => FocusNode());
  final _newPassCtrl     = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscureNew       = true;
  bool _obscureConfirm   = true;
  bool _resetting        = false;
  String? _step2Error;

  // Cooldown renvoi (60s)
  int    _resendCountdown = 0;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _emailCtrl.dispose();
    for (final c in _codeCtrl) c.dispose();
    for (final f in _codeFocus) f.dispose();
    for (final f in _rawCodeFocus) f.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // ── Countdown ──────────────────────────────────────────────────────────────
  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _resendCountdown = 180); // 3 minutes = durée de validité du code
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_resendCountdown > 0) _resendCountdown--;
        else t.cancel();
      });
    });
  }

  String _formatCountdown(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  // ── Step 1 : envoyer le code ───────────────────────────────────────────────
  Future<void> _sendCode() async {
    if (!_emailFormKey.currentState!.validate()) return;
    setState(() { _sendingCode = true; _step1Error = null; });

    final result = await AuthService.forgotPassword(_emailCtrl.text.trim());

    if (!mounted) return;
    setState(() => _sendingCode = false);

    if (result.success) {
      _startCountdown();
      setState(() => _step = 2);
    } else {
      setState(() => _step1Error = result.error);
    }
  }

  // ── Step 2 : renvoyer le code ──────────────────────────────────────────────
  Future<void> _resendCode() async {
    if (_resendCountdown > 0) return;
    setState(() { _step2Error = null; });

    final result = await AuthService.forgotPassword(_emailCtrl.text.trim());
    if (!mounted) return;
    if (result.success) {
      _startCountdown();
    } else {
      setState(() => _step2Error = result.error);
    }
  }

  // ── Step 2 : OTP box handling ──────────────────────────────────────────────
  String get _currentCode => _codeCtrl.map((c) => c.text).join();

  void _onCodeBoxChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.length == 6) {
        for (var i = 0; i < 6; i++) _codeCtrl[i].text = digits[i];
        _codeFocus[5].requestFocus();
        setState(() {});
        return;
      }
      _codeCtrl[index].text = value[value.length - 1];
      _codeCtrl[index].selection =
          TextSelection.fromPosition(const TextPosition(offset: 1));
    }
    setState(() {});
    if (value.isNotEmpty && index < 5) _codeFocus[index + 1].requestFocus();
  }

  void _onCodeKeyDown(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _codeCtrl[index].text.isEmpty &&
        index > 0) {
      _codeFocus[index - 1].requestFocus();
      _codeCtrl[index - 1].clear();
      setState(() {});
    }
  }

  // ── Step 2 : réinitialiser ─────────────────────────────────────────────────
  Future<void> _resetPassword() async {
    if (!_resetFormKey.currentState!.validate()) return;
    if (_currentCode.length < 6) {
      setState(() => _step2Error = 'Veuillez saisir le code à 6 chiffres');
      return;
    }
    setState(() { _resetting = true; _step2Error = null; });

    final result = await AuthService.resetPassword(
      _emailCtrl.text.trim(),
      _currentCode,
      _newPassCtrl.text,
    );

    if (!mounted) return;
    setState(() => _resetting = false);

    if (result.success) {
      setState(() => _step = 3);
    } else {
      setState(() => _step2Error = result.error);
    }
  }

  // ── Password strength checker ──────────────────────────────────────────────
  bool get _hasMinLength  => _newPassCtrl.text.length >= 8;
  bool get _hasUppercase  => _newPassCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumberOrSp => _newPassCtrl.text.contains(RegExp(r'[\d!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]'));

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.text, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.forgotPasswordTitle,
          style: const TextStyle(
              fontFamily: 'Syne', fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: _step == 1
              ? _buildStep1(l10n)
              : _step == 2
                  ? _buildStep2(l10n)
                  : _buildSuccess(l10n),
        ),
      ),
    );
  }

  // ── Step 1 UI ──────────────────────────────────────────────────────────────
  Widget _buildStep1(AppLocalizations l10n) {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Icône
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(20),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accent.withAlpha(60), width: 2),
              ),
              child: const Icon(Icons.lock_reset_rounded,
                  color: AppTheme.accent, size: 32),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.forgotPasswordDesc,
            style: const TextStyle(
                fontSize: 14, color: AppTheme.muted, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          _label(l10n.email.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            style: const TextStyle(color: AppTheme.text),
            onFieldSubmitted: (_) => _sendCode(),
            decoration: InputDecoration(
              hintText: l10n.emailHint,
              prefixIcon: const Icon(Icons.email_outlined,
                  color: AppTheme.muted, size: 18),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.emailRequired;
              if (!v.contains('@')) return l10n.emailInvalid;
              return null;
            },
          ),

          if (_step1Error != null) ...[
            const SizedBox(height: 12),
            _errorBanner(_step1Error!),
          ],

          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _sendingCode ? null : _sendCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.bg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _sendingCode
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: AppTheme.bg, strokeWidth: 2.5))
                  : Text(l10n.sendResetCode,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 2 UI ──────────────────────────────────────────────────────────────
  Widget _buildStep2(AppLocalizations l10n) {
    return Form(
      key: _resetFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            l10n.resetPasswordDesc,
            style: const TextStyle(
                fontSize: 14, color: AppTheme.muted, height: 1.6),
          ),
          const SizedBox(height: 8),
          Text(
            _emailCtrl.text,
            style: const TextStyle(
                fontSize: 13,
                color: AppTheme.accent,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 28),

          // ── Code OTP ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) {
              final filled = _codeCtrl[i].text.isNotEmpty;
              return Container(
                width: 46,
                height: 56,
                margin: EdgeInsets.only(left: i == 0 ? 0 : (i == 3 ? 12 : 6)),
                decoration: BoxDecoration(
                  color: filled
                      ? AppTheme.accent.withAlpha(15)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _step2Error != null
                        ? Colors.red.shade400
                        : filled
                            ? AppTheme.accent.withAlpha(180)
                            : AppTheme.border,
                    width: filled || _step2Error != null ? 2 : 1.5,
                  ),
                ),
                child: RawKeyboardListener(
                  focusNode: _rawCodeFocus[i],
                  onKey: (e) => _onCodeKeyDown(i, e),
                  child: TextFormField(
                    controller: _codeCtrl[i],
                    focusNode: _codeFocus[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: i == 0 ? 6 : 1,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _step2Error != null
                          ? Colors.red.shade300
                          : AppTheme.text,
                      fontFamily: 'Syne',
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => _onCodeBoxChanged(i, v),
                  ),
                ),
              );
            }),
          ),

          // Renvoyer
          const SizedBox(height: 12),
          // Expiry bar + resend
          if (_resendCountdown > 0) ...[
            const SizedBox(height: 8),
            _CodeExpiryBar(seconds: _resendCountdown, total: 180),
            const SizedBox(height: 8),
          ],
          Center(
            child: GestureDetector(
              onTap: _resendCountdown == 0 ? _resendCode : null,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _resendCountdown == 0 ? 1.0 : 0.45,
                child: Text(
                  _resendCountdown > 0
                      ? '${l10n.resendCode} (${_formatCountdown(_resendCountdown)})'
                      : l10n.resendCode,
                  style: TextStyle(
                    fontSize: 13,
                    color: _resendCountdown == 0
                        ? AppTheme.accent
                        : AppTheme.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),
          const Divider(color: AppTheme.border),
          const SizedBox(height: 20),

          // ── Nouveau mot de passe ───────────────────────────────────
          _label(l10n.newPassword.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _newPassCtrl,
            obscureText: _obscureNew,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: AppTheme.text),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: l10n.passwordHint,
              prefixIcon: const Icon(Icons.lock_outline,
                  color: AppTheme.muted, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscureNew
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.muted,
                    size: 18),
                onPressed: () =>
                    setState(() => _obscureNew = !_obscureNew),
              ),
            ),
            validator: _validatePassword,
          ),

          // Indicateur de force
          if (_newPassCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 10),
            _PasswordStrengthHint(
              hasMinLength: _hasMinLength,
              hasUppercase: _hasUppercase,
              hasNumberOrSymbol: _hasNumberOrSp,
              l10n: l10n,
            ),
          ],

          const SizedBox(height: 14),
          _label(l10n.confirmPassword.toUpperCase()),
          const SizedBox(height: 6),
          TextFormField(
            controller: _confirmPassCtrl,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _resetPassword(),
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              hintText: l10n.passwordHint,
              prefixIcon: const Icon(Icons.lock_outline,
                  color: AppTheme.muted, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.muted,
                    size: 18),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (v) {
              if (v != _newPassCtrl.text) return l10n.passwordMismatch;
              return null;
            },
          ),

          if (_step2Error != null) ...[
            const SizedBox(height: 12),
            _errorBanner(_step2Error!),
          ],

          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _resetting ? null : _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.bg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _resetting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: AppTheme.bg, strokeWidth: 2.5))
                  : Text(l10n.resetPassword,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 3 : succès ────────────────────────────────────────────────────────
  Widget _buildSuccess(AppLocalizations l10n) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(20),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.accent.withAlpha(60), width: 2),
            ),
            child: const Icon(Icons.check_circle_outline_rounded,
                color: AppTheme.accent, size: 40),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.passwordResetSuccess,
          style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.text),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.passwordResetSuccessDesc,
          style: const TextStyle(
              fontSize: 14, color: AppTheme.muted, height: 1.6),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.bg,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(l10n.loginButton,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String? _validatePassword(String? v) {
    final l10n = AppLocalizations.of(context);
    if (v == null || v.isEmpty) return l10n.passwordRequired;
    if (v.length < 8) return l10n.passwordMin8;
    if (!v.contains(RegExp(r'[A-Z]'))) return l10n.passwordNeedsUppercase;
    if (!v.contains(RegExp(r'[\d!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]')))
      return l10n.passwordNeedsNumberOrSymbol;
    return null;
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppTheme.muted,
            letterSpacing: 0.8),
      );

  Widget _errorBanner(String msg) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.withAlpha(60)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
            const SizedBox(width: 8),
            Flexible(
              child: Text(msg,
                  style:
                      const TextStyle(color: Colors.redAccent, fontSize: 13)),
            ),
          ],
        ),
      );
}

// ── Code expiry progress bar ──────────────────────────────────────────────────
class _CodeExpiryBar extends StatelessWidget {
  final int seconds;
  final int total;
  const _CodeExpiryBar({required this.seconds, required this.total});

  @override
  Widget build(BuildContext context) {
    final ratio = (seconds / total).clamp(0.0, 1.0);
    // Couleur : vert → orange → rouge selon le temps restant
    final color = ratio > 0.5
        ? const Color(0xFF6BCB77)
        : ratio > 0.25
            ? const Color(0xFFFFD166)
            : Colors.redAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            height: 3,
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppTheme.surface,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 3,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Code expire dans ${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ── Password strength hint widget ─────────────────────────────────────────────
class _PasswordStrengthHint extends StatelessWidget {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasNumberOrSymbol;
  final AppLocalizations l10n;

  const _PasswordStrengthHint({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasNumberOrSymbol,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row(hasMinLength, l10n.passwordMin8),
        const SizedBox(height: 4),
        _row(hasUppercase, l10n.passwordNeedsUppercase),
        const SizedBox(height: 4),
        _row(hasNumberOrSymbol, l10n.passwordNeedsNumberOrSymbol),
      ],
    );
  }

  Widget _row(bool ok, String label) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          color: ok ? AppTheme.accent : AppTheme.muted,
          size: 14,
        ),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: ok ? AppTheme.accent : AppTheme.muted)),
      ],
    );
  }
}
