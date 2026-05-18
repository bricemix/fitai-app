class UserProfile {
  final String name;
  final String age;
  final String gender;
  final String weight;
  final String height;
  final String goal;
  final String activity;
  final List<String> restrictions;
  // Nouvelles mesures corporelles
  final String waistCm;
  final String bicepsCm;
  final String bellyCm;
  // Objectif hebdomadaire : négatif = perte, positif = prise (kg/semaine)
  final double goalKgPerWeek;
  // Préférence de devise (code ISO, ex: 'EUR', 'XOF')
  final String currencyCode;

  const UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.goal,
    required this.activity,
    required this.restrictions,
    this.waistCm = '',
    this.bicepsCm = '',
    this.bellyCm = '',
    this.goalKgPerWeek = 0,
    this.currencyCode = 'EUR',
  });

  UserProfile copyWith({
    String? name,
    String? age,
    String? gender,
    String? weight,
    String? height,
    String? goal,
    String? activity,
    List<String>? restrictions,
    String? waistCm,
    String? bicepsCm,
    String? bellyCm,
    double? goalKgPerWeek,
    String? currencyCode,
  }) {
    return UserProfile(
      name:           name ?? this.name,
      age:            age ?? this.age,
      gender:         gender ?? this.gender,
      weight:         weight ?? this.weight,
      height:         height ?? this.height,
      goal:           goal ?? this.goal,
      activity:       activity ?? this.activity,
      restrictions:   restrictions ?? this.restrictions,
      waistCm:        waistCm ?? this.waistCm,
      bicepsCm:       bicepsCm ?? this.bicepsCm,
      bellyCm:        bellyCm ?? this.bellyCm,
      goalKgPerWeek:  goalKgPerWeek ?? this.goalKgPerWeek,
      currencyCode:   currencyCode ?? this.currencyCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'name':            name,
        'age':             age,
        'gender':          gender,
        'weight':          weight,
        'height':          height,
        'goal':            goal,
        'activity':        activity,
        'restrictions':    restrictions,
        'waist_cm':        waistCm,
        'biceps_cm':       bicepsCm,
        'belly_cm':        bellyCm,
        'goal_kg_per_week': goalKgPerWeek,
        'currency_code':   currencyCode,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name:          json['name'] as String? ?? '',
        age:           json['age'] as String? ?? '',
        gender:        json['gender'] as String? ?? 'homme',
        weight:        json['weight'] as String? ?? '',
        height:        json['height'] as String? ?? '',
        goal:          json['goal'] as String? ?? '',
        activity:      json['activity'] as String? ?? 'Modéré (3-4j/sem)',
        restrictions:  List<String>.from(json['restrictions'] as List? ?? []),
        waistCm:       json['waist_cm'] as String? ?? '',
        bicepsCm:      json['biceps_cm'] as String? ?? '',
        bellyCm:       json['belly_cm'] as String? ?? '',
        goalKgPerWeek: (json['goal_kg_per_week'] as num?)?.toDouble() ?? 0,
        currencyCode:  json['currency_code'] as String? ?? 'EUR',
      );

  // ── Calculs nutritionnels ────────────────────────────────────────────────────

  /// Métabolisme de base (Mifflin-St Jeor)
  double get bmr {
    final w = double.tryParse(weight) ?? 70;
    final h = double.tryParse(height) ?? 170;
    final a = double.tryParse(age) ?? 25;
    return gender == 'femme'
        ? 10 * w + 6.25 * h - 5 * a - 161
        : 10 * w + 6.25 * h - 5 * a + 5;
  }

  /// Facteur d'activité
  double get activityMultiplier {
    const mults = {
      'sédentaire': 1.2,
      'léger (1-2j/sem)': 1.375,
      'modéré (3-4j/sem)': 1.55,
      'actif (5-6j/sem)': 1.725,
      'très actif': 1.9,
    };
    return mults[activity.toLowerCase()] ?? 1.55;
  }

  /// Besoins de maintenance
  double get maintenance => bmr * activityMultiplier;

  /// Objectif calorique journalier tenant compte du goal kg/semaine
  double get tdee {
    if (goalKgPerWeek != 0) {
      // 1 kg graisse ≈ 7700 kcal → déficit/surplus journalier
      final dailyDelta = (goalKgPerWeek * 7700.0 / 7.0).clamp(-1100.0, 600.0);
      return maintenance + dailyDelta;
    }
    // Fallback si pas encore de goalKgPerWeek défini
    if (goal.contains('Perdre')) return maintenance - 400;
    if (goal.contains('masse')) return maintenance + 300;
    return maintenance;
  }

  /// Réalisme du goal kg/semaine (true = ok, false = trop agressif)
  bool get isGoalRealistic {
    if (goalKgPerWeek == 0) return true;
    if (goal.contains('Perdre')) return goalKgPerWeek >= -1.0 && goalKgPerWeek < 0;
    if (goal.contains('masse')) return goalKgPerWeek <= 0.5 && goalKgPerWeek > 0;
    return true;
  }

  double get bmi {
    final w = double.tryParse(weight) ?? 0;
    final h = (double.tryParse(height) ?? 0) / 100;
    if (w == 0 || h == 0) return 0;
    return w / (h * h);
  }

  /// Macros cibles (g/jour) basées sur le profil
  int get targetProtein => ((double.tryParse(weight) ?? 70) * 1.8).round();
  int get targetFat     => ((tdee * 0.28) / 9).round();
  int get targetCarbs   => ((tdee - targetProtein * 4 - targetFat * 9) / 4).round().clamp(50, 500);
}
