import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../services/consent_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import '../utils/legal_content.dart';

const _kApiBase = 'https://api.diet-vision.com';

/// Full-screen GDPR/EU consent screen shown on first launch.
/// The user must scroll to the bottom and tick the checkbox before
/// the "Accepter" button becomes active.
class ConsentScreen extends StatefulWidget {
  final VoidCallback onAccepted;
  const ConsentScreen({super.key, required this.onAccepted});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final _scrollCtrl = ScrollController();
  bool _scrolledToBottom = false;
  bool _checked = false;
  bool _saving = false;

  // RGPD document fetched from server
  String? _rgpdUrl;
  String? _rgpdVersion;
  bool _rgpdLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    _fetchRgpd();
  }

  /// Détecte la région depuis le pays de l'appareil (dart:ui locale)
  /// et retourne le code région compatible avec l'API.
  String _detectRegion() {
    final country = WidgetsBinding.instance.platformDispatcher
        .locale.countryCode?.toUpperCase() ?? '';
    const eu = {'AT','BE','BG','HR','CY','CZ','DK','EE','FI','FR','DE',
                 'GR','HU','IE','IT','LV','LT','LU','MT','NL','PL','PT',
                 'RO','SK','SI','ES','SE','MG','RE','GP','MQ','GF','NC'};
    if (eu.contains(country))    return 'eu';
    if (country == 'US')          return 'us';
    if (country == 'GB')          return 'uk';
    if (country == 'CA')          return 'ca';
    if (country == 'BR')          return 'br';
    return 'global';
  }

  Future<void> _fetchRgpd() async {
    final region = _detectRegion();
    // Pass the app locale so the server can serve the right language document
    final locale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    try {
      final res = await http
          .get(Uri.parse('$_kApiBase/api/v1/legal/rgpd?region=$region&lang=$locale'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _rgpdUrl     = data['url']     as String?;
            _rgpdVersion = data['version'] as String?;
            _rgpdLoading = false;
          });
        }
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _rgpdLoading = false);
  }

  Future<void> _openRgpd() async {
    if (_rgpdUrl == null) return;
    final uri = Uri.parse(_rgpdUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 40) {
      if (!_scrolledToBottom) setState(() => _scrolledToBottom = true);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _accept() async {
    setState(() => _saving = true);
    await ConsentService.accept();
    if (!mounted) return;
    widget.onAccepted();
  }

  void _refuse() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.leaveApp,
          style: const TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w700),
        ),
        content: Text(
          l10n.leaveAppDesc,
          style: const TextStyle(color: AppTheme.muted, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel,
                style: const TextStyle(color: AppTheme.muted)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(l10n.quit,
                style: const TextStyle(color: AppTheme.accent3,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canAccept = _scrolledToBottom && _checked;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border:
                    Border(bottom: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  // Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: SvgPicture.asset(
                      'assets/logo/dietvision-icon.svg',
                      width: 38,
                      height: 38,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.beforeStart,
                          style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          l10n.privacyTitle,
                          style: const TextStyle(
                              color: AppTheme.muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // RGPD badge + bouton doc officiel
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003399).withAlpha(40),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: const Color(0xFF4477FF).withAlpha(80)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.public_rounded,
                                size: 12, color: Color(0xFF88AAFF)),
                            const SizedBox(width: 4),
                            Text(
                              _rgpdVersion != null
                                  ? '${l10n.rgpdLabel} v$_rgpdVersion'
                                  : l10n.rgpdLabel,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF88AAFF),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                      if (_rgpdUrl != null) ...[
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: _openRgpd,
                          child: Text(
                            l10n.officialDoc,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.accent,
                              decoration: TextDecoration.underline,
                              decorationColor: AppTheme.accent,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ── Scroll indicator hint ────────────────────────────────────────
            if (!_scrolledToBottom)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                color: AppTheme.accent.withAlpha(12),
                child: Row(
                  children: [
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.accent, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      l10n.scrollToAccept,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.accent.withAlpha(200)),
                    ),
                  ],
                ),
              ),

            // ── Scrollable content — locale-aware ───────────────────────────
            Expanded(
              child: Builder(
                builder: (context) {
                  final locale = Localizations.localeOf(context).languageCode;
                  final sections = LegalContent.rgpd(locale);
                  // Map section index to icon
                  const icons = [
                    Icons.assignment_rounded,
                    Icons.storage_rounded,
                    Icons.balance_rounded,
                    Icons.track_changes_rounded,
                    Icons.link_rounded,
                    Icons.schedule_rounded,
                    Icons.shield_rounded,
                    Icons.lock_rounded,
                    Icons.contact_support_rounded,
                  ];
                  return ListView(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    children: [
                      for (var i = 0; i < sections.length; i++)
                        _PolicySection(
                          icon: i < icons.length ? icons[i] : Icons.info_rounded,
                          title: sections[i].title,
                          body: sections[i].body,
                        ),
                      const SizedBox(height: 8),
                      const _ScrollEndMarker(),
                    ],
                  );
                },
              ),
            ),

            // ── Checkbox + actions ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox row
                  GestureDetector(
                    onTap: _scrolledToBottom
                        ? () => setState(() => _checked = !_checked)
                        : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 22,
                          height: 22,
                          margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            color: _checked
                                ? AppTheme.accent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _scrolledToBottom
                                  ? (_checked
                                      ? AppTheme.accent
                                      : AppTheme.muted)
                                  : AppTheme.border,
                              width: 2,
                            ),
                          ),
                          child: _checked
                              ? const Icon(Icons.check,
                                  size: 14, color: AppTheme.bg)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.iAccept,
                            style: TextStyle(
                              fontSize: 13,
                              color: _scrolledToBottom
                                  ? AppTheme.text
                                  : AppTheme.muted,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    children: [
                      // Refuser
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _refuse,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.muted,
                            side: const BorderSide(color: AppTheme.border),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(l10n.refuseButton,
                              style: const TextStyle(fontSize: 14)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Accepter
                      Expanded(
                        flex: 2,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: canAccept ? 1.0 : 0.35,
                          child: ElevatedButton(
                            onPressed: (canAccept && !_saving)
                                ? _accept
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accent,
                              foregroundColor: AppTheme.bg,
                              disabledBackgroundColor: AppTheme.accent,
                              disabledForegroundColor: AppTheme.bg,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        color: AppTheme.bg, strokeWidth: 2))
                                : Text(l10n.acceptButton,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Hint when not scrolled yet
                  if (!_scrolledToBottom) ...[
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        l10n.scrollToBottom,
                        style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.muted.withAlpha(160)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Policy section widget ──────────────────────────────────────────────────────

class _PolicySection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _PolicySection(
      {required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.accent),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
                fontSize: 13,
                color: AppTheme.muted,
                height: 1.55),
          ),
        ],
      ),
    );
  }
}

// ── Marker that gets revealed when the user scrolls to the bottom ──────────────

class _ScrollEndMarker extends StatelessWidget {
  const _ScrollEndMarker();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.accent.withAlpha(14),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.accent.withAlpha(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline,
              color: AppTheme.accent, size: 15),
          const SizedBox(width: 8),
          Text(
            l10n.youReachedEnd,
            style: const TextStyle(
                fontSize: 12,
                color: AppTheme.accent,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
