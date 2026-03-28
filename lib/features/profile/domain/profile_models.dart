import '../../goals/domain/wellness_goal.dart';
import '../../onboarding/domain/onboarding_models.dart';

enum ThemePreference {
  system,
  light,
  dark;

  String get storageKey => switch (this) {
    ThemePreference.system => 'system',
    ThemePreference.light => 'light',
    ThemePreference.dark => 'dark',
  };

  static ThemePreference fromStorage(String value) => switch (value) {
    'light' => ThemePreference.light,
    'dark' => ThemePreference.dark,
    _ => ThemePreference.system,
  };
}

enum ReminderType {
  dailyPlan,
  hydration,
  eveningCheckIn,
  streakRecovery;

  String get storageKey => switch (this) {
    ReminderType.dailyPlan => 'daily_plan',
    ReminderType.hydration => 'hydration',
    ReminderType.eveningCheckIn => 'evening_check_in',
    ReminderType.streakRecovery => 'streak_recovery',
  };

  static ReminderType fromStorage(String value) => switch (value) {
    'hydration' => ReminderType.hydration,
    'evening_check_in' => ReminderType.eveningCheckIn,
    'streak_recovery' => ReminderType.streakRecovery,
    _ => ReminderType.dailyPlan,
  };
}

class ReminderSetting {
  const ReminderSetting({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.hour,
    required this.minute,
    required this.isEnabled,
  });

  final String id;
  final ReminderType type;
  final String title;
  final String description;
  final int hour;
  final int minute;
  final bool isEnabled;

  ReminderSetting copyWith({
    String? id,
    ReminderType? type,
    String? title,
    String? description,
    int? hour,
    int? minute,
    bool? isEnabled,
  }) {
    return ReminderSetting(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type.storageKey,
      'title': title,
      'description': description,
      'hour': hour,
      'minute': minute,
      'isEnabled': isEnabled,
    };
  }

  static ReminderSetting fromJson(Map<String, dynamic> json) {
    return ReminderSetting(
      id: json['id']?.toString() ?? '',
      type: ReminderType.fromStorage(json['type']?.toString() ?? ''),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      hour: (json['hour'] as num?)?.toInt() ?? 9,
      minute: (json['minute'] as num?)?.toInt() ?? 0,
      isEnabled: json['isEnabled'] as bool? ?? false,
    );
  }
}

enum ConsentType {
  disclaimer,
  privacyPolicy,
  termsOfUse;

  String get storageKey => switch (this) {
    ConsentType.disclaimer => 'disclaimer',
    ConsentType.privacyPolicy => 'privacy_policy',
    ConsentType.termsOfUse => 'terms_of_use',
  };

  String get title => switch (this) {
    ConsentType.disclaimer => 'Дисклеймер',
    ConsentType.privacyPolicy => 'Політика конфіденційності',
    ConsentType.termsOfUse => 'Умови використання',
  };

  static ConsentType fromStorage(String value) => switch (value) {
    'disclaimer' => ConsentType.disclaimer,
    'privacy_policy' => ConsentType.privacyPolicy,
    'terms_of_use' => ConsentType.termsOfUse,
    _ => ConsentType.disclaimer,
  };
}

class ConsentRecord {
  const ConsentRecord({
    required this.type,
    required this.version,
    required this.acceptedAt,
    required this.source,
  });

  final ConsentType type;
  final String version;
  final DateTime acceptedAt;
  final String source;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.storageKey,
      'version': version,
      'acceptedAt': acceptedAt.toIso8601String(),
      'source': source,
    };
  }

  static ConsentRecord fromJson(Map<String, dynamic> json) {
    return ConsentRecord(
      type: ConsentType.fromStorage(json['type']?.toString() ?? ''),
      version: json['version']?.toString() ?? 'v1',
      acceptedAt:
          DateTime.tryParse(json['acceptedAt']?.toString() ?? '') ??
          DateTime.now(),
      source: json['source']?.toString() ?? 'onboarding',
    );
  }
}

class AppPreferences {
  const AppPreferences({
    required this.themePreference,
    required this.languageCode,
    required this.remindersEnabled,
    required this.reminderSettings,
  });

  final ThemePreference themePreference;
  final String languageCode;
  final bool remindersEnabled;
  final List<ReminderSetting> reminderSettings;

  AppPreferences copyWith({
    ThemePreference? themePreference,
    String? languageCode,
    bool? remindersEnabled,
    List<ReminderSetting>? reminderSettings,
  }) {
    return AppPreferences(
      themePreference: themePreference ?? this.themePreference,
      languageCode: languageCode ?? this.languageCode,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderSettings: reminderSettings ?? this.reminderSettings,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'themePreference': themePreference.storageKey,
      'languageCode': languageCode,
      'remindersEnabled': remindersEnabled,
      'reminderSettings': reminderSettings
          .map((ReminderSetting item) => item.toJson())
          .toList(),
    };
  }

  static AppPreferences fromJson(Map<String, dynamic> json) {
    return AppPreferences(
      themePreference: ThemePreference.fromStorage(
        json['themePreference']?.toString() ?? '',
      ),
      languageCode: json['languageCode']?.toString() ?? 'uk',
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
      reminderSettings:
          (json['reminderSettings'] as List<dynamic>? ?? <dynamic>[])
              .map(
                (dynamic item) =>
                    ReminderSetting.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class RemoteAppConfig {
  const RemoteAppConfig({
    required this.shopBaseUrl,
    required this.supportEmail,
    required this.enableAiCoach,
    required this.highlightMessage,
  });

  final String shopBaseUrl;
  final String supportEmail;
  final bool enableAiCoach;
  final String highlightMessage;

  RemoteAppConfig copyWith({
    String? shopBaseUrl,
    String? supportEmail,
    bool? enableAiCoach,
    String? highlightMessage,
  }) {
    return RemoteAppConfig(
      shopBaseUrl: shopBaseUrl ?? this.shopBaseUrl,
      supportEmail: supportEmail ?? this.supportEmail,
      enableAiCoach: enableAiCoach ?? this.enableAiCoach,
      highlightMessage: highlightMessage ?? this.highlightMessage,
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.goalIds,
    required this.activityLevel,
    required this.hydrationBaselineMl,
    required this.hydrationTargetMl,
    required this.sleepBaselineHours,
    required this.sleepTargetHours,
    required this.programLengthDays,
    required this.createdAt,
    required this.personalNote,
    this.email,
    this.startingWeightKg,
  });

  final String id;
  final String displayName;
  final String? email;
  final List<WellnessGoalId> goalIds;
  final ActivityLevel activityLevel;
  final int hydrationBaselineMl;
  final int hydrationTargetMl;
  final double sleepBaselineHours;
  final double sleepTargetHours;
  final int programLengthDays;
  final DateTime createdAt;
  final String personalNote;
  final double? startingWeightKg;

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? email,
    List<WellnessGoalId>? goalIds,
    ActivityLevel? activityLevel,
    int? hydrationBaselineMl,
    int? hydrationTargetMl,
    double? sleepBaselineHours,
    double? sleepTargetHours,
    int? programLengthDays,
    DateTime? createdAt,
    String? personalNote,
    double? startingWeightKg,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      goalIds: goalIds ?? this.goalIds,
      activityLevel: activityLevel ?? this.activityLevel,
      hydrationBaselineMl: hydrationBaselineMl ?? this.hydrationBaselineMl,
      hydrationTargetMl: hydrationTargetMl ?? this.hydrationTargetMl,
      sleepBaselineHours: sleepBaselineHours ?? this.sleepBaselineHours,
      sleepTargetHours: sleepTargetHours ?? this.sleepTargetHours,
      programLengthDays: programLengthDays ?? this.programLengthDays,
      createdAt: createdAt ?? this.createdAt,
      personalNote: personalNote ?? this.personalNote,
      startingWeightKg: startingWeightKg ?? this.startingWeightKg,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'email': email,
      'goalIds': goalIds
          .map((WellnessGoalId goalId) => goalId.storageKey)
          .toList(),
      'activityLevel': activityLevel.storageKey,
      'hydrationBaselineMl': hydrationBaselineMl,
      'hydrationTargetMl': hydrationTargetMl,
      'sleepBaselineHours': sleepBaselineHours,
      'sleepTargetHours': sleepTargetHours,
      'programLengthDays': programLengthDays,
      'createdAt': createdAt.toIso8601String(),
      'personalNote': personalNote,
      'startingWeightKg': startingWeightKg,
    };
  }

  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? 'Aloe Friend',
      email: json['email']?.toString(),
      goalIds: (json['goalIds'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => WellnessGoalId.fromStorage(item.toString()))
          .toList(),
      activityLevel: ActivityLevel.fromStorage(
        json['activityLevel']?.toString() ?? '',
      ),
      hydrationBaselineMl:
          (json['hydrationBaselineMl'] as num?)?.toInt() ?? 1800,
      hydrationTargetMl: (json['hydrationTargetMl'] as num?)?.toInt() ?? 2200,
      sleepBaselineHours:
          (json['sleepBaselineHours'] as num?)?.toDouble() ?? 7.0,
      sleepTargetHours: (json['sleepTargetHours'] as num?)?.toDouble() ?? 7.5,
      programLengthDays: (json['programLengthDays'] as num?)?.toInt() ?? 14,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      personalNote: json['personalNote']?.toString() ?? '',
      startingWeightKg: (json['startingWeightKg'] as num?)?.toDouble(),
    );
  }
}
