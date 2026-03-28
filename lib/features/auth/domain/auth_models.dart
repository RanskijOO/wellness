import '../../profile/domain/profile_models.dart';

enum AuthMode {
  signedOut,
  guest,
  email;

  String get storageKey => switch (this) {
    AuthMode.signedOut => 'signed_out',
    AuthMode.guest => 'guest',
    AuthMode.email => 'email',
  };

  static AuthMode fromStorage(String value) => switch (value) {
    'guest' => AuthMode.guest,
    'email' => AuthMode.email,
    _ => AuthMode.signedOut,
  };
}

class AppSession {
  const AppSession({
    required this.onboardingComplete,
    required this.authMode,
    required this.preferences,
    this.profile,
    this.consentRecords = const <ConsentRecord>[],
  });

  final bool onboardingComplete;
  final AuthMode authMode;
  final UserProfile? profile;
  final AppPreferences preferences;
  final List<ConsentRecord> consentRecords;

  bool get isAuthenticated =>
      authMode == AuthMode.guest || authMode == AuthMode.email;

  AppSession copyWith({
    bool? onboardingComplete,
    AuthMode? authMode,
    UserProfile? profile,
    AppPreferences? preferences,
    List<ConsentRecord>? consentRecords,
  }) {
    return AppSession(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      authMode: authMode ?? this.authMode,
      profile: profile ?? this.profile,
      preferences: preferences ?? this.preferences,
      consentRecords: consentRecords ?? this.consentRecords,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'onboardingComplete': onboardingComplete,
      'authMode': authMode.storageKey,
      'profile': profile?.toJson(),
      'preferences': preferences.toJson(),
      'consentRecords': consentRecords
          .map((ConsentRecord item) => item.toJson())
          .toList(),
    };
  }

  static AppSession fromJson(Map<String, dynamic> json) {
    final List<ConsentRecord> parsedConsentRecords =
        (json['consentRecords'] as List<dynamic>? ?? <dynamic>[])
            .map(
              (dynamic item) =>
                  ConsentRecord.fromJson(item as Map<String, dynamic>),
            )
            .toList();

    if (parsedConsentRecords.isEmpty &&
        json['consentRecord'] is Map<String, dynamic>) {
      parsedConsentRecords.add(
        ConsentRecord.fromJson(json['consentRecord'] as Map<String, dynamic>),
      );
    }

    return AppSession(
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      authMode: AuthMode.fromStorage(json['authMode']?.toString() ?? ''),
      profile: json['profile'] is Map<String, dynamic>
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      preferences: json['preferences'] is Map<String, dynamic>
          ? AppPreferences.fromJson(json['preferences'] as Map<String, dynamic>)
          : const AppPreferences(
              themePreference: ThemePreference.system,
              languageCode: 'uk',
              remindersEnabled: true,
              reminderSettings: <ReminderSetting>[],
            ),
      consentRecords: parsedConsentRecords,
    );
  }
}
