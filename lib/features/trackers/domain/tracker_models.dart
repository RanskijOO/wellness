enum MoodLevel {
  grounded,
  calm,
  balanced,
  upbeat,
  radiant;

  String get storageKey => switch (this) {
    MoodLevel.grounded => 'grounded',
    MoodLevel.calm => 'calm',
    MoodLevel.balanced => 'balanced',
    MoodLevel.upbeat => 'upbeat',
    MoodLevel.radiant => 'radiant',
  };

  String get title => switch (this) {
    MoodLevel.grounded => 'Потрібно більше ресурсу',
    MoodLevel.calm => 'Спокійно',
    MoodLevel.balanced => 'Збалансовано',
    MoodLevel.upbeat => 'Бадьоро',
    MoodLevel.radiant => 'На підйомі',
  };

  int get score => index + 1;

  static MoodLevel fromStorage(String value) => switch (value) {
    'grounded' => MoodLevel.grounded,
    'calm' => MoodLevel.calm,
    'upbeat' => MoodLevel.upbeat,
    'radiant' => MoodLevel.radiant,
    _ => MoodLevel.balanced,
  };
}

class DailyLog {
  const DailyLog({
    required this.date,
    required this.waterMl,
    required this.sleepHours,
    required this.mood,
    required this.completedChecklistIds,
    this.weightKg,
    this.note = '',
  });

  final DateTime date;
  final int waterMl;
  final double sleepHours;
  final double? weightKg;
  final MoodLevel mood;
  final String note;
  final List<String> completedChecklistIds;

  DailyLog copyWith({
    DateTime? date,
    int? waterMl,
    double? sleepHours,
    double? weightKg,
    MoodLevel? mood,
    String? note,
    List<String>? completedChecklistIds,
  }) {
    return DailyLog(
      date: date ?? this.date,
      waterMl: waterMl ?? this.waterMl,
      sleepHours: sleepHours ?? this.sleepHours,
      weightKg: weightKg ?? this.weightKg,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      completedChecklistIds:
          completedChecklistIds ?? this.completedChecklistIds,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date.toIso8601String(),
      'waterMl': waterMl,
      'sleepHours': sleepHours,
      'weightKg': weightKg,
      'mood': mood.storageKey,
      'note': note,
      'completedChecklistIds': completedChecklistIds,
    };
  }

  static DailyLog fromJson(Map<String, dynamic> json) {
    return DailyLog(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      waterMl: (json['waterMl'] as num?)?.toInt() ?? 0,
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      mood: MoodLevel.fromStorage(json['mood']?.toString() ?? ''),
      note: json['note']?.toString() ?? '',
      completedChecklistIds:
          (json['completedChecklistIds'] as List<dynamic>? ?? <dynamic>[])
              .map((dynamic item) => item.toString())
              .toList(),
    );
  }
}

class ProgressSnapshot {
  const ProgressSnapshot({
    required this.logs,
    required this.currentStreak,
    required this.averageWaterMl,
    required this.averageSleepHours,
    required this.averageMoodScore,
    required this.weightDeltaKg,
  });

  final List<DailyLog> logs;
  final int currentStreak;
  final int averageWaterMl;
  final double averageSleepHours;
  final double averageMoodScore;
  final double? weightDeltaKg;
}
