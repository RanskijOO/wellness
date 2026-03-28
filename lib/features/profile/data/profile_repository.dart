import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/config/app_environment.dart';
import '../../../core/content/seed_catalog.dart';
import '../../goals/domain/wellness_goal.dart';
import '../../onboarding/domain/onboarding_models.dart';
import '../domain/profile_models.dart';

class ProfileRepository {
  ProfileRepository({
    required SharedPreferences preferences,
    required AppEnvironment environment,
    SupabaseClient? supabaseClient,
    Uuid? uuid,
  }) : _preferences = preferences,
       _environment = environment,
       _supabaseClient = supabaseClient,
       _uuid = uuid ?? const Uuid();

  final SharedPreferences _preferences;
  final AppEnvironment _environment;
  final SupabaseClient? _supabaseClient;
  final Uuid _uuid;

  Future<RemoteAppConfig> fetchRemoteConfig() async {
    RemoteAppConfig config = RemoteAppConfig(
      shopBaseUrl: _environment.shopBaseUrl,
      supportEmail: _environment.supportEmail,
      enableAiCoach: false,
      highlightMessage: _environment.highlightMessage,
    );

    if (_supabaseClient == null) {
      return config;
    }

    try {
      final List<dynamic> rows = await _supabaseClient
          .from('app_config')
          .select('key, value')
          .eq('is_active', true);

      final Map<String, dynamic> values = <String, dynamic>{};
      for (final dynamic row in rows) {
        final Map<dynamic, dynamic> map = row as Map<dynamic, dynamic>;
        values[map['key'].toString()] = map['value'];
      }

      config = config.copyWith(
        shopBaseUrl: values['shop_base_url']?.toString() ?? config.shopBaseUrl,
        supportEmail:
            values['support_email']?.toString() ?? config.supportEmail,
        enableAiCoach:
            values['enable_ai_coach'] as bool? ?? config.enableAiCoach,
        highlightMessage:
            values['highlight_message']?.toString() ?? config.highlightMessage,
      );
    } catch (_) {
      return config;
    }

    return config;
  }

  UserProfile buildProfile({
    required OnboardingDraft draft,
    String? existingUserId,
    String? email,
    String? displayName,
  }) {
    final List<WellnessGoalId> goals = draft.selectedGoalKeys
        .map(WellnessGoalId.fromStorage)
        .toList();
    final GoalRecommendation recommendation = GoalRecommendationEngine.evaluate(
      goals: goals,
      activityLevel: draft.activityLevel,
      hydrationBaselineMl: draft.hydrationBaselineMl,
      sleepBaselineHours: draft.sleepBaselineHours,
      requestedPlanLengthDays: draft.programLengthDays,
    );

    return UserProfile(
      id: existingUserId ?? _uuid.v4(),
      displayName: displayName ?? 'Aloe Friend',
      email: email,
      goalIds: goals,
      activityLevel: draft.activityLevel,
      hydrationBaselineMl: draft.hydrationBaselineMl,
      hydrationTargetMl: recommendation.hydrationTargetMl,
      sleepBaselineHours: draft.sleepBaselineHours,
      sleepTargetHours: recommendation.sleepTargetHours,
      programLengthDays: recommendation.planLengthDays,
      createdAt: DateTime.now(),
      personalNote: draft.personalNote,
      startingWeightKg: draft.startingWeightKg,
    );
  }

  AppPreferences defaultPreferences({required bool remindersEnabled}) {
    return AppPreferences(
      themePreference: ThemePreference.system,
      languageCode: 'uk',
      remindersEnabled: remindersEnabled,
      reminderSettings: defaultReminderSettings
          .map(
            (ReminderSetting reminder) => reminder.copyWith(
              isEnabled: remindersEnabled && reminder.isEnabled,
            ),
          )
          .toList(),
    );
  }

  Future<void> syncProfile({
    required UserProfile profile,
    required List<ConsentRecord> consentRecords,
    required AppPreferences preferences,
  }) async {
    if (_supabaseClient == null) {
      return;
    }

    try {
      await _supabaseClient.from('user_profiles').upsert(<String, dynamic>{
        'id': profile.id,
        'email': profile.email,
        'display_name': profile.displayName,
        'activity_level': profile.activityLevel.storageKey,
        'hydration_baseline_ml': profile.hydrationBaselineMl,
        'hydration_target_ml': profile.hydrationTargetMl,
        'sleep_baseline_hours': profile.sleepBaselineHours,
        'sleep_target_hours': profile.sleepTargetHours,
        'program_length_days': profile.programLengthDays,
        'starting_weight_kg': profile.startingWeightKg,
        'personal_note': profile.personalNote,
      });

      await _supabaseClient
          .from('user_goals')
          .delete()
          .eq('user_id', profile.id);
      if (profile.goalIds.isNotEmpty) {
        await _supabaseClient
            .from('user_goals')
            .insert(
              profile.goalIds
                  .map(
                    (WellnessGoalId item) => <String, dynamic>{
                      'user_id': profile.id,
                      'goal_key': item.storageKey,
                    },
                  )
                  .toList(),
            );
      }

      if (consentRecords.isNotEmpty) {
        await _supabaseClient
            .from('consents')
            .upsert(
              consentRecords
                  .map(
                    (ConsentRecord record) => <String, dynamic>{
                      'user_id': profile.id,
                      'consent_type': record.type.storageKey,
                      'consent_version': record.version,
                      'accepted_at': record.acceptedAt.toIso8601String(),
                      'source': record.source,
                    },
                  )
                  .toList(),
            );
      }

      for (final ReminderSetting reminder in preferences.reminderSettings) {
        await _supabaseClient.from('reminders').upsert(<String, dynamic>{
          'user_id': profile.id,
          'reminder_key': reminder.id,
          'type': reminder.type.storageKey,
          'title': reminder.title,
          'description': reminder.description,
          'hour': reminder.hour,
          'minute': reminder.minute,
          'is_enabled': reminder.isEnabled,
        });
      }
    } catch (_) {
      await _preferences.setString('profile_sync_pending', 'true');
    }
  }

  Future<void> syncReminders({
    required String userId,
    required List<ReminderSetting> reminders,
  }) async {
    if (_supabaseClient == null) {
      return;
    }

    try {
      for (final ReminderSetting reminder in reminders) {
        await _supabaseClient.from('reminders').upsert(<String, dynamic>{
          'user_id': userId,
          'reminder_key': reminder.id,
          'type': reminder.type.storageKey,
          'title': reminder.title,
          'description': reminder.description,
          'hour': reminder.hour,
          'minute': reminder.minute,
          'is_enabled': reminder.isEnabled,
        });
      }
    } catch (_) {
      await _preferences.setString('profile_sync_pending', 'true');
    }
  }

  Future<void> syncProgramLength({
    required String userId,
    required int programLengthDays,
  }) async {
    if (_supabaseClient == null) {
      return;
    }

    try {
      await _supabaseClient.from('user_profiles').upsert(<String, dynamic>{
        'id': userId,
        'program_length_days': programLengthDays,
      });
    } catch (_) {
      await _preferences.setString('profile_sync_pending', 'true');
    }
  }
}
