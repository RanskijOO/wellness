enum ActivityLevel {
  calm,
  balanced,
  active;

  String get storageKey => switch (this) {
    ActivityLevel.calm => 'calm',
    ActivityLevel.balanced => 'balanced',
    ActivityLevel.active => 'active',
  };

  String get title => switch (this) {
    ActivityLevel.calm => 'Спокійний ритм',
    ActivityLevel.balanced => 'Збалансований ритм',
    ActivityLevel.active => 'Активний ритм',
  };

  String get subtitle => switch (this) {
    ActivityLevel.calm => 'Потрібна м’яка структура без перевантаження.',
    ActivityLevel.balanced => 'Комфортно тримати стабільний щоденний режим.',
    ActivityLevel.active => 'Потрібна підтримка відновлення та енергії.',
  };

  static ActivityLevel fromStorage(String value) => switch (value) {
    'calm' => ActivityLevel.calm,
    'active' => ActivityLevel.active,
    _ => ActivityLevel.balanced,
  };
}

class OnboardingDraft {
  const OnboardingDraft({
    required this.selectedGoalKeys,
    required this.activityLevel,
    required this.hydrationBaselineMl,
    required this.sleepBaselineHours,
    required this.programLengthDays,
    required this.wantsReminders,
    required this.disclaimerAccepted,
    required this.privacyAccepted,
    required this.termsAccepted,
    this.startingWeightKg,
    this.personalNote = '',
  });

  final List<String> selectedGoalKeys;
  final ActivityLevel activityLevel;
  final int hydrationBaselineMl;
  final double sleepBaselineHours;
  final int programLengthDays;
  final bool wantsReminders;
  final bool disclaimerAccepted;
  final bool privacyAccepted;
  final bool termsAccepted;
  final double? startingWeightKg;
  final String personalNote;

  bool get hasRequiredConsents =>
      disclaimerAccepted && privacyAccepted && termsAccepted;

  OnboardingDraft copyWith({
    List<String>? selectedGoalKeys,
    ActivityLevel? activityLevel,
    int? hydrationBaselineMl,
    double? sleepBaselineHours,
    int? programLengthDays,
    bool? wantsReminders,
    bool? disclaimerAccepted,
    bool? privacyAccepted,
    bool? termsAccepted,
    double? startingWeightKg,
    String? personalNote,
  }) {
    return OnboardingDraft(
      selectedGoalKeys: selectedGoalKeys ?? this.selectedGoalKeys,
      activityLevel: activityLevel ?? this.activityLevel,
      hydrationBaselineMl: hydrationBaselineMl ?? this.hydrationBaselineMl,
      sleepBaselineHours: sleepBaselineHours ?? this.sleepBaselineHours,
      programLengthDays: programLengthDays ?? this.programLengthDays,
      wantsReminders: wantsReminders ?? this.wantsReminders,
      disclaimerAccepted: disclaimerAccepted ?? this.disclaimerAccepted,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      startingWeightKg: startingWeightKg ?? this.startingWeightKg,
      personalNote: personalNote ?? this.personalNote,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'selectedGoalKeys': selectedGoalKeys,
      'activityLevel': activityLevel.storageKey,
      'hydrationBaselineMl': hydrationBaselineMl,
      'sleepBaselineHours': sleepBaselineHours,
      'programLengthDays': programLengthDays,
      'wantsReminders': wantsReminders,
      'disclaimerAccepted': disclaimerAccepted,
      'privacyAccepted': privacyAccepted,
      'termsAccepted': termsAccepted,
      'startingWeightKg': startingWeightKg,
      'personalNote': personalNote,
    };
  }

  static OnboardingDraft fromJson(Map<String, dynamic> json) {
    return OnboardingDraft(
      selectedGoalKeys:
          (json['selectedGoalKeys'] as List<dynamic>? ?? <dynamic>[])
              .map((dynamic item) => item.toString())
              .toList(),
      activityLevel: ActivityLevel.fromStorage(
        json['activityLevel']?.toString() ?? '',
      ),
      hydrationBaselineMl:
          (json['hydrationBaselineMl'] as num?)?.toInt() ?? 1800,
      sleepBaselineHours:
          (json['sleepBaselineHours'] as num?)?.toDouble() ?? 7.0,
      programLengthDays: (json['programLengthDays'] as num?)?.toInt() ?? 14,
      wantsReminders: json['wantsReminders'] as bool? ?? true,
      disclaimerAccepted:
          json['disclaimerAccepted'] as bool? ??
          json['consentAccepted'] as bool? ??
          false,
      privacyAccepted: json['privacyAccepted'] as bool? ?? false,
      termsAccepted: json['termsAccepted'] as bool? ?? false,
      startingWeightKg: (json['startingWeightKg'] as num?)?.toDouble(),
      personalNote: json['personalNote']?.toString() ?? '',
    );
  }
}
