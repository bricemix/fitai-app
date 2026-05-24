import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/profile.dart';
import 'models/meal.dart';
import 'models/body_entry.dart';
import 'models/planning.dart';
import 'services/storage_service.dart';
import 'services/auth_service.dart';
import 'services/consent_service.dart';
import 'services/notification_service.dart';
import 'services/sync_service.dart';
import 'services/payment_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'screens/splash_screen.dart';
import 'screens/paywall_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/coach_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/profile_screen.dart';
import 'theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
  ));
  // Init notifications (does not request permission yet)
  await NotificationService.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const FitAIApp(),
    ),
  );
}

class FitAIApp extends StatelessWidget {
  const FitAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return MaterialApp(
      title: 'DietVision',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supported) {
        if (locale == null) return const Locale('fr');
        for (final s in supported) {
          if (s.languageCode == locale.languageCode) return s;
        }
        return const Locale('fr');
      },
      home: const _AppLoader(),
    );
  }
}

// ── App Loader ─────────────────────────────────────────────────────────────────

class _AppLoader extends StatefulWidget {
  const _AppLoader();

  @override
  State<_AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<_AppLoader> {
  // Étapes du flux
  bool _splashDone   = false;   // splash en cours
  bool _paywallDone  = false;   // paywall en cours (1ère ouverture)
  bool _isFirstOpen  = false;   // true = 1ère ouverture

  bool _loading          = true;
  bool _consentAccepted  = false;
  bool _loggedIn         = false;
  UserProfile? _profile;
  SubscriptionStatus? _subscriptionStatus;
  // Gate vérification email : non-null si l'utilisateur est connecté mais email non vérifié
  String? _pendingVerificationEmail;

  @override
  void initState() {
    super.initState();
    _init();
    // Écouter les invalidations de session (autre appareil connecté)
    AuthService.sessionInvalidated.addListener(_onSessionInvalidated);
  }

  @override
  void dispose() {
    AuthService.sessionInvalidated.removeListener(_onSessionInvalidated);
    super.dispose();
  }

  void _onSessionInvalidated() {
    final msg = AuthService.sessionInvalidated.value;
    if (msg == null || !mounted) return;
    // Réinitialiser le notifier AVANT le setState pour éviter une boucle
    AuthService.sessionInvalidated.value = null;
    setState(() { _loggedIn = false; _profile = null; });
    // Afficher le dialogue après le prochain frame (le widget est déjà reconstruit)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          final l10n = AppLocalizations.of(ctx);
          return AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.devices_other_rounded, color: Colors.orangeAccent, size: 22),
                const SizedBox(width: 10),
                Text(l10n.sessionExpired,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
            content: Text(
              msg,
              style: const TextStyle(color: Color(0xFF94A3B8), height: 1.5),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: AppTheme.bg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.reconnect, style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> _init() async {
    // Vérifier si c'est la première ouverture (avant de charger quoi que ce soit)
    _isFirstOpen = await StorageService.isFirstOpen();

    final consent = await ConsentService.hasAccepted();
    if (!consent) {
      if (mounted) setState(() { _consentAccepted = false; _loading = false; });
      return;
    }
    final loggedIn = await AuthService.isLoggedIn();
    UserProfile? profile;
    SubscriptionStatus? subscriptionStatus;
    String? pendingVerificationEmail;
    if (loggedIn) {
      profile = await StorageService.loadProfile();

      // Pas de profil local (ex : réinstallation, données effacées) → télécharger depuis le serveur
      if (profile == null) {
        try {
          final gotProfile = await SyncService.downloadAll();
          if (gotProfile) profile = await StorageService.loadProfile();
        } catch (_) {
          // Ne pas bloquer le démarrage si le serveur est inaccessible
        }
      } else {
        // Profil local présent → sync serveur en arrière-plan pour rester à jour
        SyncService.downloadAll().ignore();
        // Upload silencieux de tout ce qui est local → garantit que rien n'est perdu
        // si l'upload avait échoué lors d'une session précédente.
        _uploadAllLocal(profile!).ignore();
      }

      subscriptionStatus = await PaymentService.fetchSubscriptionStatus();
      // Programmer les notifications trial si trial en cours
      if (subscriptionStatus?.trialEndsAt != null && !(subscriptionStatus!.trialExpired)) {
        try {
          await NotificationService.scheduleTrialExpiryNotifications(subscriptionStatus.trialEndsAt!);
        } catch (_) {
          // Ne pas bloquer le démarrage si les notifications échouent
        }
      }
      // Vérifier si l'email est validé — si non, bloquer avant l'onboarding
      final cachedUser = await AuthService.getCachedUser();
      final emailVerified = cachedUser?['email_verified'] as bool? ?? true;
      if (!emailVerified) {
        pendingVerificationEmail = cachedUser?['email'] as String?;
        profile = null; // forcer le gate, pas l'onboarding
      }
    }
    if (mounted) {
      setState(() {
        _consentAccepted = true;
        _loggedIn = loggedIn;
        _profile = profile;
        _subscriptionStatus = subscriptionStatus;
        _pendingVerificationEmail = pendingVerificationEmail;
        _loading = false;
      });
    }
  }

  void _onConsentAccepted() async {
    final loggedIn = await AuthService.isLoggedIn();
    UserProfile? profile;
    SubscriptionStatus? subscriptionStatus;
    if (loggedIn) {
      profile = await StorageService.loadProfile();
      subscriptionStatus = await PaymentService.fetchSubscriptionStatus();
    }
    if (mounted) {
      setState(() {
        _consentAccepted = true;
        _loggedIn = loggedIn;
        _profile = profile;
        _subscriptionStatus = subscriptionStatus;
      });
    }
  }

  /// Rafraîchit le statut d'abonnement depuis le serveur.
  Future<void> _refreshSubscription() async {
    final status = await PaymentService.fetchSubscriptionStatus();
    if (mounted) setState(() => _subscriptionStatus = status);
  }

  // Called after login/register
  void _onAuthenticated(bool isNewAccount) async {
    // Vérifier le statut d'abonnement dès le login
    final subscriptionStatus = await PaymentService.fetchSubscriptionStatus();
    // Programmer les notifications trial si trial en cours
    if (subscriptionStatus?.trialEndsAt != null && !(subscriptionStatus!.trialExpired)) {
      try {
        await NotificationService.scheduleTrialExpiryNotifications(subscriptionStatus.trialEndsAt!);
      } catch (_) {
        // Ne pas bloquer la connexion si les notifications échouent
      }
    }

    if (isNewAccount) {
      // Nouveau compte : vérifier si l'email est validé avant d'aller à l'onboarding
      final cachedUser = await AuthService.getCachedUser();
      final emailVerified = cachedUser?['email_verified'] as bool? ?? true;
      final userEmail = cachedUser?['email'] as String?;
      if (!emailVerified && userEmail != null) {
        // Email non vérifié → gate de vérification (pas l'onboarding)
        if (mounted) setState(() {
          _loggedIn = true;
          _profile = null;
          _subscriptionStatus = subscriptionStatus;
          _pendingVerificationEmail = userEmail;
        });
        return;
      }
      // Email vérifié (ou pas de donnée) → onboarding normal
      if (mounted) setState(() { _loggedIn = true; _profile = null; _subscriptionStatus = subscriptionStatus; });
      return;
    }

    // Utilisateur existant : vérifier aussi si son email est validé
    final cachedUser = await AuthService.getCachedUser();
    final emailVerified = cachedUser?['email_verified'] as bool? ?? true;
    final userEmail = cachedUser?['email'] as String?;
    if (!emailVerified && userEmail != null) {
      if (mounted) setState(() {
        _loggedIn = true;
        _profile = null;
        _subscriptionStatus = subscriptionStatus;
        _pendingVerificationEmail = userEmail;
      });
      return;
    }

    // Utilisateur existant : charger le profil local d'abord (affichage immédiat si dispo)
    UserProfile? profile = await StorageService.loadProfile();

    if (profile != null) {
      // Profil en cache → on affiche immédiatement, puis on sync en arrière-plan
      if (mounted) setState(() { _loggedIn = true; _profile = profile; _subscriptionStatus = subscriptionStatus; });
      _syncFromServer(hadLocalProfile: true);
    } else {
      // Pas de profil local → on attend le serveur avant de décider (onboarding ou accueil)
      if (mounted) setState(() { _loggedIn = true; _loading = true; _subscriptionStatus = subscriptionStatus; });
      final gotProfile = await SyncService.downloadAll();
      if (!mounted) return;
      if (gotProfile) {
        final serverProfile = await StorageService.loadProfile();
        setState(() { _profile = serverProfile; _loading = false; });
      } else {
        // Vraiment aucun profil → onboarding
        setState(() { _profile = null; _loading = false; });
      }
    }
  }

  Future<void> _syncFromServer({required bool hadLocalProfile}) async {
    // Télécharge profil + mesures + planning depuis le serveur en arrière-plan
    final gotProfile = await SyncService.downloadAll();

    // Si on n'avait pas de profil local mais qu'on en a trouvé un sur le serveur
    if (!hadLocalProfile && gotProfile && mounted) {
      final profile = await StorageService.loadProfile();
      if (profile != null && mounted) {
        setState(() => _profile = profile);
      }
    }
  }

  /// Upload silencieux de toutes les données locales vers le serveur.
  /// Appelé au démarrage quand un profil local existe — corrige les comptes
  /// dont les données n'avaient jamais été synchronisées.
  Future<void> _uploadAllLocal(UserProfile profile) async {
    try {
      await SyncService.uploadProfile(profile);
      final bodyEntries = await StorageService.loadBodyEntries();
      if (bodyEntries.isNotEmpty) {
        await SyncService.uploadBodyEntries(bodyEntries);
      }
      final meals = await StorageService.loadMeals();
      if (meals.isNotEmpty) {
        await SyncService.uploadMeals(meals);
      }
      final planning = await StorageService.loadPlanning();
      if (planning.isNotEmpty) {
        await SyncService.uploadPlanning(planning);
      }
    } catch (_) {
      // Silencieux — ne bloque jamais le démarrage
    }
  }

  void _onOnboardingDone(UserProfile p) {
    setState(() => _profile = p);
    // Upload vers le serveur pour persistance cross-appareils
    SyncService.uploadProfile(p);
    // Schedule daily motivation notification after onboarding
    _scheduleNotification();
  }

  Future<void> _scheduleNotification() async {
    final granted = await NotificationService.requestPermission();
    if (granted) {
      await NotificationService.scheduleDailyMotivation(hour: 8, minute: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ── 1. Splash (toujours, à chaque ouverture) ───────────────────────────
    if (!_splashDone) {
      return SplashScreen(onDone: () => setState(() => _splashDone = true));
    }

    // ── 2. Paywall (seulement à la 1ère ouverture) ─────────────────────────
    if (_isFirstOpen && !_paywallDone) {
      return PaywallScreen(
        onContinue: () async {
          await StorageService.markFirstOpenDone();
          if (mounted) setState(() { _isFirstOpen = false; _paywallDone = true; });
        },
      );
    }

    // ── 3. Chargement des données ──────────────────────────────────────────
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppTheme.bg,
        body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
      );
    }

    // ── 4. Consentement RGPD ───────────────────────────────────────────────
    if (!_consentAccepted) {
      return ConsentScreen(onAccepted: _onConsentAccepted);
    }

    // ── 5. Authentification ────────────────────────────────────────────────
    if (!_loggedIn) {
      return AuthScreen(onAuthenticated: _onAuthenticated);
    }

    // ── 5b. Gate vérification email ────────────────────────────────────────
    // L'utilisateur est connecté mais n'a pas encore validé son email.
    // Bloque l'accès à l'onboarding jusqu'à validation.
    if (_pendingVerificationEmail != null) {
      return EmailVerificationScreen(
        email: _pendingVerificationEmail!,
        onContinue: () {
          // Email vérifié → lever le gate et laisser l'onboarding s'afficher
          setState(() => _pendingVerificationEmail = null);
        },
        onBack: () async {
          // Revenir = déconnexion (l'utilisateur ne peut pas sauter cette étape)
          await AuthService.logout();
          if (mounted) {
            setState(() {
              _loggedIn = false;
              _profile = null;
              _pendingVerificationEmail = null;
              _subscriptionStatus = null;
            });
          }
        },
      );
    }

    // ── 5c. Gate abonnement (trial expiré ou abo inactif) ──────────────────
    if (_subscriptionStatus?.needsPayment == true) {
      return _SubscriptionGate(
        subscriptionStatus: _subscriptionStatus!,
        onUnlocked: _refreshSubscription,
        onLogout: () async {
          await AuthService.logout();
          if (mounted) setState(() { _loggedIn = false; _profile = null; _subscriptionStatus = null; });
        },
      );
    }

    // ── 6. Onboarding (nouveau compte, email vérifié) ──────────────────────
    if (_profile == null) {
      return OnboardingScreen(onDone: _onOnboardingDone);
    }

    // ── 7. App principale ──────────────────────────────────────────────────
    return HomeShell(
      profile: _profile!,
      onLogout: () => setState(() {
        _loggedIn = false;
        _profile = null;
      }),
    );
  }
}

// ── Subscription Gate ──────────────────────────────────────────────────────────
// Écran incontournable affiché quand le trial/abo est expiré.
// L'utilisateur ne peut qu'acheter un plan ou se déconnecter.

class _SubscriptionGate extends StatefulWidget {
  final SubscriptionStatus subscriptionStatus;
  final Future<void> Function() onUnlocked;
  final Future<void> Function() onLogout;

  const _SubscriptionGate({
    required this.subscriptionStatus,
    required this.onUnlocked,
    required this.onLogout,
  });

  @override
  State<_SubscriptionGate> createState() => _SubscriptionGateState();
}

class _SubscriptionGateState extends State<_SubscriptionGate> {
  bool _checking = false;
  String? _errorMsg;
  int _mealsCount = 0;
  DateTime? _offerExpiresAt;
  // Timer annulable pour le compte à rebours de l'offre
  Timer? _countdownTick;
  int _tickCount = 0;

  static const _offerStartKey = 'dv_gate_offer_start';

  @override
  void initState() {
    super.initState();
    _loadStats();
    _initOfferCountdown();
    // Rafraîchir l'affichage toutes les minutes
    _countdownTick = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() => _tickCount++);
    });
  }

  @override
  void dispose() {
    _countdownTick?.cancel();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final meals = await StorageService.loadMeals();
    if (mounted) setState(() => _mealsCount = meals.length);
  }

  Future<void> _initOfferCountdown() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getInt(_offerStartKey);
    if (stored == null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_offerStartKey, now);
      if (mounted) setState(() => _offerExpiresAt = DateTime.now().add(const Duration(hours: 48)));
    } else {
      final start = DateTime.fromMillisecondsSinceEpoch(stored);
      final expires = start.add(const Duration(hours: 48));
      if (mounted) setState(() => _offerExpiresAt = expires);
    }
  }

  (int, int) _countdown() {
    if (_offerExpiresAt == null) return (0, 0);
    final diff = _offerExpiresAt!.difference(DateTime.now());
    if (diff.isNegative) return (0, 0);
    return (diff.inHours, diff.inMinutes % 60);
  }

  Future<void> _recheck() async {
    setState(() { _checking = true; _errorMsg = null; });
    final status = await PaymentService.fetchSubscriptionStatus();
    if (!mounted) return;
    if (status != null && !status.needsPayment) {
      // Abonnement confirmé → déverrouiller l'app
      await widget.onUnlocked();
    } else {
      final l10n = AppLocalizations.of(context);
      setState(() { _checking = false; _errorMsg = l10n.noActiveSubscription; });
    }
  }

  Future<void> _openSubscription() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SubscriptionScreen(onSubscribed: _recheck),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final daysLeft = widget.subscriptionStatus.trialDaysRemaining;
    final (countH, countM) = _countdown();
    final offerActive = countH > 0 || countM > 0;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // ── Logo ────────────────────────────────────────────────────
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(20),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.accent.withAlpha(60)),
                ),
                padding: const EdgeInsets.all(14),
                child: SvgPicture.asset('assets/logo/dietvision-icon.svg'),
              ),
              const SizedBox(height: 24),

              // ── Titre ────────────────────────────────────────────────────
              Text(
                l10n.trialExpiredTitle,
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.trialExpiredSubtitle,
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 14,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              // ── Stats accomplies ─────────────────────────────────────────
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.trialSummaryTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.restaurant_rounded, size: 14, color: AppTheme.accent),
                        const SizedBox(width: 6),
                        Text(
                          l10n.mealsScannedCount(_mealsCount),
                          style: const TextStyle(color: AppTheme.muted, fontSize: 13),
                        ),
                        if (daysLeft != null) ...[
                          const SizedBox(width: 16),
                          const Icon(Icons.schedule_rounded, size: 14, color: AppTheme.accent3),
                          const SizedBox(width: 6),
                          Text(
                            daysLeft == 0
                                ? l10n.trialExpiredToday
                                : l10n.trialExpiredDaysAgo(daysLeft),
                            style: const TextStyle(fontSize: 13, color: AppTheme.accent3),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // ── Badge offre spéciale + countdown ─────────────────────────
              if (offerActive) ...[
                const SizedBox(height: 14),
                Builder(builder: (ctx) {
                    final (h, m) = _countdown();
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.accent3.withAlpha(30), AppTheme.accent.withAlpha(20)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.accent3.withAlpha(80)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: AppTheme.accent3, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.specialOffer,
                                  style: const TextStyle(
                                    color: AppTheme.accent3,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  l10n.offerExpiresIn(h, m),
                                  style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],

              const SizedBox(height: 28),

              // ── Erreur ───────────────────────────────────────────────────
              if (_errorMsg != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accent3.withAlpha(18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.accent3),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMsg!, style: const TextStyle(fontSize: 13, color: AppTheme.accent3))),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // ── CTA principal : choisir un plan ─────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _checking ? null : _openSubscription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: AppTheme.bg,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.workspace_premium_rounded, size: 20),
                  label: Text(l10n.upgradeNow,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 12),

              // ── Déjà payé ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _checking ? null : _recheck,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _checking
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accent)),
                            const SizedBox(width: 10),
                            Text(l10n.checkingSubscription, style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
                          ],
                        )
                      : Text(l10n.alreadyPaidCheck,
                          style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
                ),
              ),
              const SizedBox(height: 20),

              // ── Déconnexion ──────────────────────────────────────────────
              TextButton(
                onPressed: () => widget.onLogout(),
                child: Text(
                  l10n.logout,
                  style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Home Shell ─────────────────────────────────────────────────────────────────

class HomeShell extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onLogout;
  const HomeShell({super.key, required this.profile, required this.onLogout});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  late UserProfile _profile;
  List<Meal> _meals = [];
  BodyEntry? _todayBodyEntry;
  DayPlan? _todayPlan;
  String _userPlan = 'free'; // 'free' | 'starter' | 'pro' | 'premium'
  DateTime? _trialEndsAt;

  // Triggers for deep navigation from Dashboard
  final _bodyEntryTrigger   = ValueNotifier<int>(0);
  final _coachPlanningTrigger = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
    _loadAll();
    _loadUserPlan();
  }

  Future<void> _loadUserPlan() async {
    // 1. Plan depuis le cache local (affichage immédiat) — normalisé
    final cached = await AuthService.getCachedUser();
    final rawPlan = cached?['plan'] as String?
        ?? cached?['subscription_plan'] as String?
        ?? 'free';
    final localPlan = SubscriptionStatus.normalizePlan(rawPlan);
    if (mounted) setState(() => _userPlan = localPlan);
    // 2. Rafraîchir depuis le serveur + récupérer trialEndsAt
    final status = await PaymentService.fetchSubscriptionStatus();
    if (status != null && mounted) {
      setState(() {
        _userPlan = status.plan;
        if (status.trialEndsAt != null && !status.trialExpired) {
          _trialEndsAt = status.trialEndsAt;
        }
      });
    }
  }

  Future<void> _loadAll() async {
    final meals   = await StorageService.loadMeals();
    final today   = await StorageService.todayBodyEntry();
    final plan    = await StorageService.todayPlan();
    if (mounted) setState(() {
      _meals          = meals;
      _todayBodyEntry = today;
      _todayPlan      = plan;
    });
  }

  Future<void> _addMeal(Meal meal) async {
    final updated = [..._meals, meal];
    await StorageService.saveMeals(updated);
    setState(() { _meals = updated; _tab = 0; });
    // Sync silencieux : envoie les repas au serveur (récupérables sur autre appareil)
    SyncService.uploadMeals(updated);
  }

  void _goToBodyLog() {
    setState(() => _tab = 3);
    // Tiny delay so IndexedStack has time to show ProgressScreen before opening sheet
    Future.delayed(const Duration(milliseconds: 120), () {
      _bodyEntryTrigger.value++;
    });
  }

  void _goToCoachPlanning() {
    setState(() => _tab = 2);
    Future.delayed(const Duration(milliseconds: 120), () {
      _coachPlanningTrigger.value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch locale so HomeShell rebuilds when language changes
    context.watch<LocaleProvider>();
    // IndexedStack préserve l'état de chaque onglet sans recréer les widgets
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [
            DashboardScreen(
              profile: _profile,
              meals: _meals,
              todayBodyEntry: _todayBodyEntry,
              todayPlan: _todayPlan,
              onLogBody: _goToBodyLog,
              onGoToScan:  () => setState(() => _tab = 1),
              onGoToCoach: _goToCoachPlanning,
              userPlan: _userPlan,
              trialEndsAt: _trialEndsAt,
            ),
            ScanScreen(onMealAdded: _addMeal),
            CoachScreen(
              profile: _profile,
              meals: _meals,
              userPlan: _userPlan,
              onPlanChanged: _loadUserPlan,
              openPlanningTrigger: _coachPlanningTrigger,
            ),
            ProgressScreen(
              meals: _meals,
              profile: _profile,
              openBodyEntryTrigger: _bodyEntryTrigger,
              onBodyEntrySaved: () async {
                final today = await StorageService.todayBodyEntry();
                if (mounted) setState(() => _todayBodyEntry = today);
              },
            ),
            ProfileScreen(
              profile: _profile,
              onUpdate: (p) => setState(() => _profile = p),
              onLogout: widget.onLogout,
              userPlan: _userPlan,
              trialEndsAt: _trialEndsAt,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        current: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

// ── Bottom Nav ─────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int current;
  final void Function(int) onTap;

  const _BottomNav({required this.current, required this.onTap});

  static const _icons = [
    Icons.grid_view_rounded,
    Icons.document_scanner_rounded,
    Icons.smart_toy_rounded,
    Icons.analytics_rounded,
    Icons.manage_accounts_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.navHome,
      l10n.navScan,
      l10n.navCoach,
      l10n.navProgress,
      l10n.navProfile,
    ];
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(_icons.length, (i) {
            final active = i == current;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? AppTheme.accent.withAlpha(24) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_icons[i], size: 22, color: active ? AppTheme.accent : AppTheme.muted),
                      const SizedBox(height: 4),
                      Text(labels[i], style: TextStyle(fontSize: 10, color: active ? AppTheme.accent : AppTheme.muted)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
