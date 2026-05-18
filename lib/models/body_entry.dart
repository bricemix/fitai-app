class BodyEntry {
  final String date;
  final double? weight;
  final double? waist;   // tour de taille
  final double? chest;   // poitrine
  final double? hips;    // hanches
  final double? biceps;
  final double? thigh;   // cuisse

  const BodyEntry({
    required this.date,
    this.weight,
    this.waist,
    this.chest,
    this.hips,
    this.biceps,
    this.thigh,
  });

  bool get isEmpty =>
      weight == null && waist == null && chest == null &&
      hips == null && biceps == null && thigh == null;

  bool get isToday {
    final d = DateTime.parse(date);
    final n = DateTime.now();
    return d.year == n.year && d.month == n.month && d.day == n.day;
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'weight': weight,
        'waist': waist,
        'chest': chest,
        'hips': hips,
        'biceps': biceps,
        'thigh': thigh,
      };

  factory BodyEntry.fromJson(Map<String, dynamic> j) => BodyEntry(
        date: j['date'] as String,
        weight: (j['weight'] as num?)?.toDouble(),
        waist: (j['waist'] as num?)?.toDouble(),
        chest: (j['chest'] as num?)?.toDouble(),
        hips: (j['hips'] as num?)?.toDouble(),
        biceps: (j['biceps'] as num?)?.toDouble(),
        thigh: (j['thigh'] as num?)?.toDouble(),
      );
}
