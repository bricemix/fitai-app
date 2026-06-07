import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';
import '../models/profile.dart';
import '../models/planning.dart';
import 'auth_service.dart';

/// Retourne le code langue sélectionné par l'utilisateur dans l'app.
/// Priorité : préférence sauvegardée → 'fr' par défaut.
Future<String> _appLocale() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('locale') ?? 'en';
}

/// Nom complet de la langue pour les instructions à l'IA.
String _languageName(String code) {
  const names = {
    'fr': 'French',
    'en': 'English',
    'de': 'German',
    'es': 'Spanish',
    'pt': 'Portuguese',
    'zh': 'Chinese',
  };
  return names[code] ?? 'English';
}

class AiService {
  static String get _baseUrl => AuthService.baseUrl;

  // ── Food analysis ──────────────────────────────────────────────────────────
  // Throws an [AiException] on failure so callers can show a meaningful message.

  static Future<FoodResult> analyzeFood(String base64Image, {String? description}) async {
    final headers = await AuthService.authHeaders();
    final locale = await _appLocale();
    final http.Response response;
    final body = <String, dynamic>{
      'image': base64Image,
      'locale': locale,
    };
    if (description != null && description.trim().isNotEmpty) {
      body['description'] = description.trim();
    }
    try {
      response = await http
          .post(
            Uri.parse('$_baseUrl/ai/analyze'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 90));
    } on Exception catch (e) {
      throw AiException('Connection error: ${e.runtimeType}');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return FoodResult.fromJson(data);
    } else if (response.statusCode == 429) {
      Map<String, dynamic>? data;
      try { data = jsonDecode(response.body) as Map<String, dynamic>; } catch (_) {}
      throw AiLimitException(
        plan:  data?['plan']       as String? ?? 'free',
        limit: (data?['limit'] as num?)?.toInt() ?? 3,
        used:  (data?['used']  as num?)?.toInt() ?? 0,
        type:  data?['limit_type'] as String? ?? 'scan',
      );
    } else if (response.statusCode == 401) {
      final invalidated = await AuthService.handleUnauthorized(response);
      if (invalidated) throw AiException('SESSION_INVALIDATED');
      throw AiException('Session expirée — veuillez vous reconnecter.');
    } else {
      String message = 'Analyse échouée (code ${response.statusCode})';
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['error'] != null) message = data['error'].toString();
      } catch (_) {}
      throw AiException(message);
    }
  }

  // ── Text-only food analysis (no image) ────────────────────────────────────
  static Future<FoodResult> analyzeText(
    String description, {
    String? mealType,
  }) async {
    final headers = await AuthService.authHeaders();
    final locale  = await _appLocale();
    final body = <String, dynamic>{
      'description': description.trim(),
      'locale': locale,
      'text_only': true,
    };
    if (mealType != null && mealType.isNotEmpty) body['meal_type'] = mealType;
    final http.Response response;
    try {
      response = await http
          .post(
            Uri.parse('$_baseUrl/ai/analyze'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 90));
    } on Exception catch (e) {
      throw AiException('Connection error: ${e.runtimeType}');
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return FoodResult.fromJson(data);
    } else if (response.statusCode == 429) {
      Map<String, dynamic>? data;
      try { data = jsonDecode(response.body) as Map<String, dynamic>; } catch (_) {}
      throw AiLimitException(
        plan:  data?['plan']       as String? ?? 'free',
        limit: (data?['limit'] as num?)?.toInt() ?? 3,
        used:  (data?['used']  as num?)?.toInt() ?? 0,
        type:  data?['limit_type'] as String? ?? 'scan',
      );
    } else if (response.statusCode == 401) {
      final invalidated = await AuthService.handleUnauthorized(response);
      if (invalidated) throw AiException('SESSION_INVALIDATED');
      throw AiException('Session expirée — veuillez vous reconnecter.');
    } else {
      String message = 'Analyse échouée (code ${response.statusCode})';
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['error'] != null) message = data['error'].toString();
      } catch (_) {}
      throw AiException(message);
    }
  }

  // ── Coach chat ─────────────────────────────────────────────────────────────

  static Future<String> askCoach(
    List<Map<String, String>> messages,
    UserProfile profile, {
    List<Meal>? todayMeals,
  }) async {
    try {
      final headers = await AuthService.authHeaders();
      final locale  = await _appLocale();

      // Calcule le contexte nutritionnel du jour
      final kcalConsumed  = todayMeals?.fold(0, (s, m) => s + m.result.calories) ?? 0;
      final kcalTarget    = profile.tdee.round();
      final kcalRemaining = (kcalTarget - kcalConsumed).clamp(0, 9999);
      final proteinToday  = todayMeals?.fold(0.0, (s, m) => s + m.result.protein) ?? 0.0;
      final carbsToday    = todayMeals?.fold(0.0, (s, m) => s + m.result.carbs) ?? 0.0;
      final fatToday      = todayMeals?.fold(0.0, (s, m) => s + m.result.fat) ?? 0.0;
      final proteinTarget = (double.tryParse(profile.weight) ?? 70.0) * 1.6;

      final todayContext = {
        'date': DateTime.now().toIso8601String().substring(0, 10),
        'kcal_consumed':  kcalConsumed,
        'kcal_target':    kcalTarget,
        'kcal_remaining': kcalRemaining,
        'protein_g':      proteinToday.round(),
        'protein_target_g': proteinTarget.round(),
        'carbs_g':        carbsToday.round(),
        'carbs_target_g': profile.targetCarbs,
        'fat_g':          fatToday.round(),
        'fat_target_g':   profile.targetFat,
        'meals': todayMeals?.map((m) => {
          'name':     m.result.name,
          'calories': m.result.calories,
          'protein':  m.result.protein.round(),
          'carbs':    m.result.carbs.round(),
          'fat':      m.result.fat.round(),
        }).toList() ?? [],
      };

      final response = await http
          .post(
            Uri.parse('$_baseUrl/ai/coach'),
            headers: headers,
            body: jsonEncode({
              'messages':      messages,
              'profile':       profile.toJson(),
              'locale':        locale,
              'today_context': todayContext,
              'max_tokens':    1500,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['reply'] as String? ?? 'Sorry, I could not respond.';
      } else if (response.statusCode == 401) {
        final invalidated = await AuthService.handleUnauthorized(response);
        if (invalidated) throw AiException('SESSION_INVALIDATED');
        throw AiException('Session expirée — veuillez vous reconnecter.');
      } else if (response.statusCode == 429) {
        Map<String, dynamic>? data;
        try { data = jsonDecode(response.body) as Map<String, dynamic>; } catch (_) {}
        throw AiLimitException(
          plan:  data?['plan']       as String? ?? 'free',
          limit: (data?['limit'] as num?)?.toInt() ?? 3,
          used:  (data?['used']  as num?)?.toInt() ?? 0,
          type:  data?['limit_type'] as String? ?? 'chat',
        );
      }
      throw AiException('Connection error (code ${response.statusCode}).');
    } on AiLimitException {
      rethrow;
    } on AiException {
      rethrow;
    } catch (_) {
      throw AiException('Unable to reach the server.');
    }
  }

  // ── Dish recommendations ───────────────────────────────────────────────────

  static Future<List<DishRecommendation>> getDishRecommendations({
    required UserProfile profile,
    required List<Meal> todayMeals,
    String dietType = 'omnivore',
  }) async {
    final locale = await _appLocale();
    final lang = _languageName(locale);
    final todayKcal = todayMeals.fold(0, (s, m) => s + m.result.calories);
    final rawRemaining = profile.tdee.round() - todayKcal;
    final inSurplus   = rawRemaining < 0;
    final surplus     = inSurplus ? -rawRemaining : 0;
    final remaining   = rawRemaining.clamp(0, 9999);
    final restrictions = profile.restrictions.isEmpty ? 'none' : profile.restrictions.join(', ');

    // Instructions spécifiques selon le régime sélectionné (clés internes)
    final dietInstructions = _dietInstructions(dietType);

    // Contexte calorique selon la situation (normal vs surplus)
    final caloricContext = inSurplus
        ? 'Kcal consumed today: $todayKcal — EXCEEDED daily target by +$surplus kcal (caloric surplus)'
        : 'Kcal consumed today: $todayKcal — remaining: $remaining kcal';

    // Instruction supplémentaire si en surplus
    final surplusInstruction = inSurplus ? '''
IMPORTANT: The user has already exceeded their daily caloric goal by $surplus kcal.
You MUST still return 3 dish suggestions in JSON format — do NOT refuse or explain.
Recommend very light dishes under 350 kcal each: salads, soups, steamed vegetables, lean proteins.
Focus on micronutrients, fibre and hydration rather than calories.
''' : '';

    final prompt = '''
IMPORTANT: Respond ENTIRELY in $lang. All dish names, descriptions and ingredient names must be in $lang.

Recommend 3 detailed dishes adapted for this user today.
Goal: ${profile.goal} (${profile.tdee.round()} kcal/day)
$caloricContext
User weight: ${profile.weight} kg
Dietary restrictions: $restrictions
$surplusInstruction
SELECTED DIET: $dietType
$dietInstructions

For each dish, list EXACT ingredients with their weight in grams AND 4-5 preparation steps in $lang.
Return ONLY this JSON (no markdown, no explanation).
The "type" field must be EXACTLY one of: breakfast, lunch, dinner, snack (always in English, never translated).
Steps must be concise (1-2 sentences each), start with an emoji, and be written in $lang.
{"dishes":[{"name":"...","type":"breakfast|lunch|dinner|snack","calories":int,"protein":int,"carbs":int,"fat":int,"description":"short description in $lang","ingredients":[{"name":"Chicken","weight_g":150},{"name":"Basmati rice","weight_g":80}],"steps":["🧾 Gather all ingredients...","🍳 Heat a pan...","🧂 Season with...","🍽️ Serve immediately."]}]}
''';

    // Contexte nutritionnel du jour (mêmes champs que /ai/coach pour passer la validation backend)
    final proteinToday = todayMeals.fold(0.0, (s, m) => s + m.result.protein);
    final carbsToday   = todayMeals.fold(0.0, (s, m) => s + m.result.carbs);
    final fatToday     = todayMeals.fold(0.0, (s, m) => s + m.result.fat);
    final todayContext = {
      'date': DateTime.now().toIso8601String().substring(0, 10),
      'kcal_consumed':    todayKcal,
      'kcal_target':      profile.tdee.round(),
      'kcal_remaining':   remaining,
      'protein_g':        proteinToday.round(),
      'carbs_g':          carbsToday.round(),
      'carbs_target_g':   profile.targetCarbs,
      'fat_g':            fatToday.round(),
      'fat_target_g':     profile.targetFat,
      'meals': todayMeals.map((m) => {
        'name':     m.result.name,
        'calories': m.result.calories,
        'protein':  m.result.protein.round(),
        'carbs':    m.result.carbs.round(),
        'fat':      m.result.fat.round(),
      }).toList(),
    };

    final headers = await AuthService.authHeaders();
    final response = await http
        .post(
          Uri.parse('$_baseUrl/ai/dishes'),
          headers: headers,
          body: jsonEncode({
            'messages': [{'role': 'user', 'content': prompt}],
            'profile': profile.toJson(),
            'locale': locale,
            'today_context': todayContext,
            'max_tokens': 1800, // 3 dishes with ingredients + steps require ~1200-1600 tokens
          }),
        )
        .timeout(const Duration(seconds: 45));

    if (response.statusCode == 401) {
      final invalidated = await AuthService.handleUnauthorized(response);
      if (invalidated) throw AiException('SESSION_INVALIDATED');
      throw AiException('Session expirée — veuillez vous reconnecter.');
    }
    if (response.statusCode == 403) throw AiException('DISHES_PLAN_REQUIRED');
    if (response.statusCode == 429) {
      Map<String, dynamic>? data;
      try { data = jsonDecode(response.body) as Map<String, dynamic>; } catch (_) {}
      throw AiLimitException(
        plan:  data?['plan']       as String? ?? 'free',
        limit: (data?['limit'] as num?)?.toInt() ?? 3,
        used:  (data?['used']  as num?)?.toInt() ?? 0,
        type:  data?['limit_type'] as String? ?? 'dishes',
      );
    }
    if (response.statusCode != 200) {
      // Remonte le détail de validation FastAPI (422) pour faciliter le diagnostic
      String detail = '';
      try {
        final err = jsonDecode(response.body);
        if (err is Map && err['detail'] != null) detail = ' — ${err['detail']}';
      } catch (_) {}
      throw AiException('Server error (${response.statusCode})$detail');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final text = data['reply'] as String? ?? '';
    // Extraction robuste : trouver le premier { et le dernier }
    final start = text.indexOf('{');
    final end   = text.lastIndexOf('}');
    if (start == -1 || end == -1 || end <= start) {
      throw AiException('Réponse IA inattendue — réessayez.');
    }
    final jsonStr = text.substring(start, end + 1);
    final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
    final list = parsed['dishes'] as List? ?? [];
    return list
        .map((d) => DishRecommendation.fromJson(d as Map<String, dynamic>))
        .toList();
  }

  // ── Weekly planning generation ─────────────────────────────────────────────

  static Future<List<DayPlan>> generateWeeklyPlan(UserProfile profile, {String? preference}) async {
    final locale = await _appLocale();
    final lang = _languageName(locale);
    final now = DateTime.now();
    // Début de la semaine = lundi
    final monday = now.subtract(Duration(days: now.weekday - 1));
    // Noms de jours fixes (utilisés uniquement comme clé dans le JSON, pas affichés)
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    final dailyKcal = profile.tdee.round();
    final maintenance = profile.maintenance.round();
    final delta = dailyKcal - maintenance;
    final deltaStr = delta < 0 ? '$delta kcal (deficit)' : delta > 0 ? '+$delta kcal (surplus)' : 'maintenance';
    final rhythm = profile.goalKgPerWeek != 0
        ? 'Rhythm: ${profile.goalKgPerWeek > 0 ? '+' : ''}${profile.goalKgPerWeek} kg/week → $deltaStr/day'
        : '';
    final preferenceNote = preference != null
        ? '\nUSER PREFERENCE TO APPLY: $preference\nAdapt the plan accordingly.\n'
        : '';

    final prompt = '''
IMPORTANT: Write the "note" field in $lang only. All advice must be in $lang.

Create a 7-day nutritional plan for this user.
Goal: ${profile.goal}
Caloric maintenance: $maintenance kcal/day
MANDATORY daily target: $dailyKcal kcal/day (${rhythm.isNotEmpty ? rhythm : 'maintenance'})
Target protein: ${profile.targetProtein}g/day | Carbs: ${profile.targetCarbs}g/day | Fat: ${profile.targetFat}g/day
Restrictions: ${profile.restrictions.isEmpty ? 'none' : profile.restrictions.join(', ')}
$preferenceNote
IMPORTANT: Each day must have target_kcal = $dailyKcal (± 50 kcal max).
Macros may vary slightly per day for variety.
The "note" field must contain a short motivating tip for that day, written in $lang.
Return ONLY this JSON (no markdown):
{"days":[{"day":"Monday","target_kcal":int,"target_protein":int,"target_carbs":int,"target_fat":int,"note":"short tip in $lang"},...]}
''';

    try {
      final headers = await AuthService.authHeaders();
      final response = await http
          .post(
            Uri.parse('$_baseUrl/ai/coach'),
            headers: headers,
            body: jsonEncode({
              'messages': [{'role': 'user', 'content': prompt}],
              'profile': profile.toJson(),
              'locale': locale,
              'max_tokens': 1500, // 7-day plan with notes requires ~800-1200 tokens
            }),
          )
          .timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final text = data['reply'] as String? ?? '';
        final start = text.indexOf('{');
        final end   = text.lastIndexOf('}');
        if (start != -1 && end > start) {
          final parsed = jsonDecode(text.substring(start, end + 1)) as Map<String, dynamic>;
          final list = parsed['days'] as List? ?? [];
          return List.generate(list.length.clamp(0, 7), (i) {
            final d = list[i] as Map<String, dynamic>;
            final date = monday.add(Duration(days: i));
            final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            return DayPlan(
              date:          dateStr,
              targetKcal:    (d['target_kcal'] as num?)?.toInt() ?? profile.tdee.round(),
              targetProtein: (d['target_protein'] as num?)?.toInt() ?? profile.targetProtein,
              targetCarbs:   (d['target_carbs'] as num?)?.toInt() ?? profile.targetCarbs,
              targetFat:     (d['target_fat'] as num?)?.toInt() ?? profile.targetFat,
              note:          d['note'] as String?,
            );
          });
        }
      }
    } catch (_) {}

    // Fallback: planning identique chaque jour
    return List.generate(7, (i) {
      final date = monday.add(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return DayPlan(
        date:          dateStr,
        targetKcal:    profile.tdee.round(),
        targetProtein: profile.targetProtein,
        targetCarbs:   profile.targetCarbs,
        targetFat:     profile.targetFat,
        note:          days[i],
      );
    });
  }

  // ── Instructions régime → injectées dans le prompt IA ─────────────────────

  static String _dietInstructions(String dietType) {
    // dietType uses internal English keys (from coach_screen refactor)
    switch (dietType) {
      case 'halal':
        return 'IMPORTANT: All dishes must be strictly halal — certified halal meat only, zero pork or derivatives (gelatin, lard, cooking alcohol), zero alcohol in sauces and marinades. Prefer lamb, halal chicken, halal beef, fish, legumes.';
      case 'vegetarian':
        return 'IMPORTANT: Suggest ONLY vegetarian dishes — no meat or fish. Eggs and dairy products are allowed.';
      case 'vegan':
        return 'IMPORTANT: Suggest ONLY 100% vegan dishes — zero animal products (no meat, fish, eggs, milk, honey).';
      case 'keto':
        return 'IMPORTANT: Strict ketogenic diet — carbs < 20g per dish, very high in healthy fats, moderate protein. Zero grains, zero sugar, zero legumes.';
      case 'gluten-free':
        return 'IMPORTANT: All dishes must be strictly gluten-free — no wheat, rye, barley, or spelt. Use rice, quinoa, buckwheat, corn, potatoes.';
      case 'mediterranean':
        return 'Mediterranean diet: olive oil, legumes, vegetables, fish, fresh herbs, dried fruits. Limited red meat. No ultra-processed products.';
      case 'high-protein':
        return 'IMPORTANT: Each dish must provide at least 35g of protein. Prioritize lean meat, fish, eggs, legumes, cottage cheese, tofu.';
      case 'low-calorie':
        return 'IMPORTANT: Each dish must be under 400 kcal while being filling. Prefer vegetables, lean proteins, fiber. Avoid sauces and fried foods.';
      case 'paleo':
        return 'Paleolithic diet: meat, fish, fruits, vegetables, nuts, eggs only. FORBIDDEN: grains, legumes, dairy, refined sugar, processed foods.';
      default: // omnivore
        return 'Balanced omnivore diet — suggest varied dishes adapted to remaining calories.';
    }
  }
}

class AiException implements Exception {
  final String message;
  const AiException(this.message);
  @override
  String toString() => message;
}

class AiLimitException implements Exception {
  final String plan;
  final int limit;
  final int used;
  final String type; // 'scan' | 'chat'
  const AiLimitException({
    required this.plan,
    required this.limit,
    required this.used,
    this.type = 'scan',
  });
  @override
  String toString() => 'AiLimitException($type: $used/$limit)';
}
