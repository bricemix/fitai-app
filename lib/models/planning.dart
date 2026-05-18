class DayPlan {
  final String date;        // ISO YYYY-MM-DD
  final int targetKcal;
  final int targetProtein;
  final int targetCarbs;
  final int targetFat;
  final String? note;

  const DayPlan({
    required this.date,
    required this.targetKcal,
    this.targetProtein = 0,
    this.targetCarbs = 0,
    this.targetFat = 0,
    this.note,
  });

  factory DayPlan.fromJson(Map<String, dynamic> j) => DayPlan(
        date:           j['date'] as String,
        targetKcal:     (j['target_kcal'] as num?)?.toInt() ?? 0,
        targetProtein:  (j['target_protein'] as num?)?.toInt() ?? 0,
        targetCarbs:    (j['target_carbs'] as num?)?.toInt() ?? 0,
        targetFat:      (j['target_fat'] as num?)?.toInt() ?? 0,
        note:           j['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'date':           date,
        'target_kcal':    targetKcal,
        'target_protein': targetProtein,
        'target_carbs':   targetCarbs,
        'target_fat':     targetFat,
        if (note != null) 'note': note,
      };

  bool get isToday {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return date == today;
  }

  static String todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

class DishIngredient {
  final String name;
  final int weightG; // poids en grammes

  const DishIngredient({required this.name, required this.weightG});

  factory DishIngredient.fromJson(Map<String, dynamic> j) => DishIngredient(
        name:    j['name'] as String? ?? '',
        weightG: (j['weight_g'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {'name': name, 'weight_g': weightG};
}

class DishRecommendation {
  final String name;
  final String type; // petit-déjeuner, déjeuner, dîner, snack
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String description;
  final List<DishIngredient> ingredients;

  const DishRecommendation({
    required this.name,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.description,
    this.ingredients = const [],
  });

  factory DishRecommendation.fromJson(Map<String, dynamic> j) {
    final rawIngredients = j['ingredients'] as List? ?? [];
    return DishRecommendation(
      name:        j['name'] as String? ?? '',
      type:        j['type'] as String? ?? 'repas',
      calories:    (j['calories'] as num?)?.toInt() ?? 0,
      protein:     (j['protein'] as num?)?.toInt() ?? 0,
      carbs:       (j['carbs'] as num?)?.toInt() ?? 0,
      fat:         (j['fat'] as num?)?.toInt() ?? 0,
      description: j['description'] as String? ?? '',
      ingredients: rawIngredients
          .map((e) => DishIngredient.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name':        name,
        'type':        type,
        'calories':    calories,
        'protein':     protein,
        'carbs':       carbs,
        'fat':         fat,
        'description': description,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
      };
}
