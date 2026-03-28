import 'package:aloe_wellness_coach/features/goals/domain/wellness_goal.dart';
import 'package:aloe_wellness_coach/features/onboarding/domain/onboarding_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoalRecommendationEngine', () {
    test('upgrades to a 21-day plan when multiple goals are selected', () {
      final GoalRecommendation recommendation =
          GoalRecommendationEngine.evaluate(
            goals: <WellnessGoalId>[
              WellnessGoalId.hydrationSupport,
              WellnessGoalId.energySupport,
              WellnessGoalId.beautySkinSupport,
            ],
            activityLevel: ActivityLevel.active,
            hydrationBaselineMl: 1800,
            sleepBaselineHours: 6.8,
            requestedPlanLengthDays: 7,
          );

      expect(recommendation.planLengthDays, 21);
      expect(recommendation.hydrationTargetMl, greaterThan(1800));
      expect(recommendation.sleepTargetHours, greaterThanOrEqualTo(7.0));
      expect(recommendation.priorityTags, contains('hydration'));
      expect(recommendation.priorityTags, contains('energy'));
    });
  });
}
