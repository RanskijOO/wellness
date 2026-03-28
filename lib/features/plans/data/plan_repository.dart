import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/content/seed_catalog.dart';
import '../../products/domain/product_models.dart';
import '../../profile/domain/profile_models.dart';
import '../domain/plan_models.dart';

class PlanRepository {
  PlanRepository({
    required SharedPreferences preferences,
    SupabaseClient? supabaseClient,
  }) : _preferences = preferences,
       _supabaseClient = supabaseClient;

  static const String activePlanKey = 'active_plan_v1';

  final SharedPreferences _preferences;
  final SupabaseClient? _supabaseClient;

  Future<WellnessPlan> loadOrCreatePlan({
    required UserProfile profile,
    required List<Product> recommendedProducts,
  }) async {
    final String? rawPlan = _preferences.getString(activePlanKey);
    if (rawPlan != null && rawPlan.isNotEmpty) {
      final WellnessPlan existing = WellnessPlan.fromJson(
        jsonDecode(rawPlan) as Map<String, dynamic>,
      );
      if (existing.durationDays == profile.programLengthDays &&
          _sameGoals(
            existing.goalKeys,
            profile.goalIds.map((item) => item.storageKey).toList(),
          )) {
        return existing;
      }
    }

    final WellnessPlan generated = _generatePlan(
      profile: profile,
      recommendedProducts: recommendedProducts,
    );
    return savePlan(generated, userId: profile.id);
  }

  Future<WellnessPlan> savePlan(WellnessPlan plan, {String? userId}) async {
    await _preferences.setString(activePlanKey, jsonEncode(plan.toJson()));

    if (_supabaseClient != null && userId != null) {
      try {
        await _supabaseClient
            .from('user_plan_assignments')
            .upsert(<String, dynamic>{
              'user_id': userId,
              'plan_code': plan.id,
              'title': plan.title,
              'description': plan.description,
              'duration_days': plan.durationDays,
              'goal_keys': plan.goalKeys,
              'start_date': plan.startDate.toIso8601String(),
              'adherence_score': plan.adherenceScore,
            });
      } catch (_) {
        // Local cache remains authoritative until remote config is enabled.
      }
    }

    return plan;
  }

  Future<WellnessPlan> toggleChecklistItem({
    required WellnessPlan plan,
    required int dayNumber,
    required String itemId,
    required String userId,
  }) async {
    final List<WellnessPlanDay> updatedDays = plan.days.map((
      WellnessPlanDay day,
    ) {
      if (day.dayNumber != dayNumber) {
        return day;
      }
      final List<ChecklistItem> updatedChecklist = day.checklist
          .map(
            (ChecklistItem item) => item.id == itemId
                ? item.copyWith(isCompleted: !item.isCompleted)
                : item,
          )
          .toList();
      return day.copyWith(checklist: updatedChecklist);
    }).toList();

    return savePlan(plan.copyWith(days: updatedDays), userId: userId);
  }

  WellnessPlan _generatePlan({
    required UserProfile profile,
    required List<Product> recommendedProducts,
  }) {
    final List<String> suggestionIds = recommendedProducts
        .take(3)
        .map((Product item) => item.id)
        .toList();
    final DateTime startDate = DateTime.now();
    final List<WellnessPlanDay>
    days = List<WellnessPlanDay>.generate(profile.programLengthDays, (
      int index,
    ) {
      final int dayNumber = index + 1;
      final String action = planActionPool[index % planActionPool.length];
      final String journalPrompt =
          journalPromptPool[index % journalPromptPool.length];
      final int hydrationGlassCount = (profile.hydrationTargetMl / 250).round();

      return WellnessPlanDay(
        dayNumber: dayNumber,
        title: 'День $dayNumber',
        hydrationTask:
            'Зробіть акцент на $hydrationGlassCount склянках води та зручній пляшці поруч.',
        wellnessAction: action,
        journalPrompt: journalPrompt,
        checklist: <ChecklistItem>[
          ChecklistItem(
            id: 'day-$dayNumber-water',
            label: 'Досягти водної цілі дня',
            isCompleted: false,
          ),
          ChecklistItem(
            id: 'day-$dayNumber-action',
            label: 'Виконати одну wellness-дію дня',
            isCompleted: false,
          ),
          ChecklistItem(
            id: 'day-$dayNumber-journal',
            label: 'Заповнити короткий вечірній check-in',
            isCompleted: false,
          ),
        ],
        suggestedProductIds: suggestionIds,
      );
    });

    final String primaryGoal = profile.goalIds.first.title;

    return WellnessPlan(
      id: 'plan-${profile.programLengthDays}-${profile.goalIds.first.storageKey}',
      title: '${profile.programLengthDays}-денний план: $primaryGoal',
      description:
          'Щоденна wellness-програма з м’яким ритмом, трекерами і продуктними підказками без медичних обіцянок.',
      durationDays: profile.programLengthDays,
      goalKeys: profile.goalIds.map((item) => item.storageKey).toList(),
      startDate: startDate,
      days: days,
    );
  }

  bool _sameGoals(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }
    final List<String> a = List<String>.from(left)..sort();
    final List<String> b = List<String>.from(right)..sort();
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) {
        return false;
      }
    }
    return true;
  }
}
