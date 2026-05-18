class FoodResult {
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final String vitamins;
  final String minerals;
  final int healthScore;
  final String tip;
  /// Portion estimée par l'IA en grammes (null = non estimée)
  final int? estimatedGrams;

  const FoodResult({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.vitamins,
    required this.minerals,
    required this.healthScore,
    required this.tip,
    this.estimatedGrams,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'fiber': fiber,
        'vitamins': vitamins,
        'minerals': minerals,
        'healthScore': healthScore,
        'tip': tip,
        if (estimatedGrams != null) 'estimatedGrams': estimatedGrams,
      };

  /// Retourne un nouveau FoodResult avec les valeurs nutritionnelles
  /// proportionnellement ajustées à [grams] par rapport à [estimatedGrams].
  FoodResult scaledTo(int grams) {
    if (estimatedGrams == null || estimatedGrams! <= 0) return this;
    final ratio = grams / estimatedGrams!;
    return FoodResult(
      name:          name,
      calories:      (calories * ratio).round(),
      protein:       double.parse((protein * ratio).toStringAsFixed(1)),
      carbs:         double.parse((carbs   * ratio).toStringAsFixed(1)),
      fat:           double.parse((fat     * ratio).toStringAsFixed(1)),
      fiber:         double.parse((fiber   * ratio).toStringAsFixed(1)),
      vitamins:      vitamins,
      minerals:      minerals,
      healthScore:   healthScore,
      tip:           tip,
      estimatedGrams: grams,
    );
  }

  factory FoodResult.fromJson(Map<String, dynamic> json) => FoodResult(
        name: json['name'] ?? 'Aliment',
        calories: (json['calories'] as num?)?.toInt() ?? 0,
        protein: (json['protein'] as num?)?.toDouble() ?? 0,
        carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
        fat: (json['fat'] as num?)?.toDouble() ?? 0,
        fiber: (json['fiber'] as num?)?.toDouble() ?? 0,
        vitamins: json['vitamins'] ?? '',
        minerals: json['minerals'] ?? '',
        healthScore: (json['healthScore'] as num?)?.toInt() ?? 5,
        tip: json['tip'] ?? '',
        estimatedGrams: (json['estimatedGrams'] as num?)?.toInt(),
      );
}

class Meal {
  final String date;
  final String? imagePath;
  final FoodResult result;

  const Meal({
    required this.date,
    this.imagePath,
    required this.result,
  });

  bool get isToday {
    final d = DateTime.parse(date);
    final n = DateTime.now();
    return d.year == n.year && d.month == n.month && d.day == n.day;
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'imagePath': imagePath,
        'result': result.toJson(),
      };

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        date: json['date'],
        imagePath: json['imagePath'],
        result: FoodResult.fromJson(json['result']),
      );
}
