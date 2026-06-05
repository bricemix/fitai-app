import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

// ── Typed exceptions ──────────────────────────────────────────────────────────

/// Aucune connexion réseau (SocketException, ClientException, etc.)
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = '']);
  @override
  String toString() => message;
}

/// Requête expirée (TimeoutException)
class TimeoutNetworkException implements Exception {
  const TimeoutNetworkException();
}

/// Erreur HTTP serveur (4xx / 5xx non auth)
class ApiException implements Exception {
  final String message;
  final int statusCode;
  const ApiException(this.message, {this.statusCode = 0});
  @override
  String toString() => message;
}

/// Session expirée (HTTP 401)
class SessionExpiredException implements Exception {
  const SessionExpiredException();
}

// ── Helper : classifier une exception brute ───────────────────────────────────

/// Transforme une exception brute (http / dart:io) en exception typée.
/// À appeler dans les catch blocks des services.
Exception classifyError(Object e) {
  if (e is NetworkException ||
      e is TimeoutNetworkException ||
      e is ApiException ||
      e is SessionExpiredException) {
    return e as Exception;
  }
  if (e is TimeoutException) return const TimeoutNetworkException();
  if (e is SocketException)  return NetworkException(e.message);
  // http.ClientException (pas de socket, hôte injoignable…)
  final msg = e.toString().toLowerCase();
  if (msg.contains('socketexception') ||
      msg.contains('failed host') ||
      msg.contains('connection refused') ||
      msg.contains('network is unreachable') ||
      msg.contains('no address associated') ||
      msg.contains('clientexception')) {
    return NetworkException(e.toString());
  }
  return Exception(e.toString());
}

// ── ErrorDialog ───────────────────────────────────────────────────────────────

enum _ErrorKind { noConnection, timeout, sessionExpired, server, generic }

class ErrorDialog extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onRetry;

  const ErrorDialog._({
    required this.title,
    required this.body,
    required this.icon,
    required this.iconColor,
    this.onRetry,
  });

  // ── Factory constructors pour chaque scénario ─────────────────────────────

  /// Affiche le bon dialog selon le type d'exception.
  /// [onRetry] : callback si l'utilisateur appuie sur "Réessayer" (null = pas de bouton retry).
  static Future<void> showForException(
    BuildContext context,
    Object error, {
    VoidCallback? onRetry,
  }) {
    final l10n = AppLocalizations.of(context);
    final _ErrorKind kind;

    if (error is NetworkException)         kind = _ErrorKind.noConnection;
    else if (error is TimeoutNetworkException) kind = _ErrorKind.timeout;
    else if (error is SessionExpiredException) kind = _ErrorKind.sessionExpired;
    else if (error is ApiException)        kind = _ErrorKind.server;
    else {
      final msg = error.toString().toLowerCase();
      if (msg.contains('socketexception') ||
          msg.contains('failed host') ||
          msg.contains('network is unreachable') ||
          msg.contains('clientexception') ||
          msg.contains('unable to reach')) {
        kind = _ErrorKind.noConnection;
      } else if (msg.contains('timeoutexception') || msg.contains('timed out')) {
        kind = _ErrorKind.timeout;
      } else if (msg.contains('session') && msg.contains('expir')) {
        kind = _ErrorKind.sessionExpired;
      } else {
        kind = _ErrorKind.generic;
      }
    }

    final String title;
    final String body;
    final IconData icon;
    final Color iconColor;

    switch (kind) {
      case _ErrorKind.noConnection:
        title     = l10n.noConnectionTitle;
        body      = l10n.noConnectionBody;
        icon      = Icons.wifi_off_rounded;
        iconColor = Colors.orange.shade400;
        break;
      case _ErrorKind.timeout:
        title     = l10n.timeoutErrorTitle;
        body      = l10n.timeoutErrorBody;
        icon      = Icons.hourglass_empty_rounded;
        iconColor = Colors.orange.shade400;
        break;
      case _ErrorKind.sessionExpired:
        title     = l10n.sessionExpiredDialogTitle;
        body      = l10n.sessionExpiredDialogBody;
        icon      = Icons.lock_outline_rounded;
        iconColor = Colors.red.shade400;
        break;
      case _ErrorKind.server:
        title     = l10n.serverErrorTitle;
        body      = l10n.serverErrorBody;
        icon      = Icons.cloud_off_rounded;
        iconColor = Colors.red.shade400;
        break;
      case _ErrorKind.generic:
        title     = l10n.serverErrorTitle;
        body      = (error is Exception || error is Error)
            ? error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')
            : l10n.serverErrorBody;
        icon      = Icons.error_outline_rounded;
        iconColor = Colors.red.shade400;
        break;
    }

    return showDialog(
      context: context,
      barrierDismissible: kind != _ErrorKind.sessionExpired,
      builder: (_) => ErrorDialog._(
        title:     title,
        body:      body,
        icon:      icon,
        iconColor: iconColor,
        onRetry:   onRetry,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c    = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
      child: Container(
        decoration: BoxDecoration(
          color:        c.surface,
          borderRadius: BorderRadius.circular(24),
          border:       Border.all(color: c.border),
          boxShadow: [
            BoxShadow(
              color:       Colors.black.withAlpha(80),
              blurRadius:  32,
              offset:      const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icône animée ───────────────────────────────────────────────
              _AnimatedIcon(icon: icon, color: iconColor),
              const SizedBox(height: 20),

              // ── Titre ──────────────────────────────────────────────────────
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color:      Colors.white,
                  fontSize:   18,
                  fontWeight: FontWeight.w800,
                  height:     1.2,
                ),
              ),
              const SizedBox(height: 10),

              // ── Corps ──────────────────────────────────────────────────────
              Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:  c.muted,
                  fontSize: 13,
                  height:   1.55,
                ),
              ),
              const SizedBox(height: 28),

              // ── Boutons ────────────────────────────────────────────────────
              Row(
                children: [
                  // Fermer
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side:             BorderSide(color: c.border),
                        foregroundColor:  c.muted,
                        padding:          const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        l10n.close,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),

                  // Réessayer (optionnel)
                  if (onRetry != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onRetry!();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.accent,
                          foregroundColor: const Color(0xFF0A0A0F),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          l10n.retry,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Icône avec animation d'entrée ─────────────────────────────────────────────

class _AnimatedIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  const _AnimatedIcon({required this.icon, required this.color});

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width:  72,
          height: 72,
          decoration: BoxDecoration(
            color:        widget.color.withAlpha(22),
            shape:        BoxShape.circle,
            border:       Border.all(color: widget.color.withAlpha(60), width: 1.5),
          ),
          child: Icon(widget.icon, color: widget.color, size: 32),
        ),
      ),
    );
  }
}
