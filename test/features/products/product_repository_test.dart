import 'package:aloe_wellness_coach/core/content/seed_catalog.dart';
import 'package:aloe_wellness_coach/features/goals/domain/wellness_goal.dart';
import 'package:aloe_wellness_coach/features/onboarding/domain/onboarding_models.dart';
import 'package:aloe_wellness_coach/features/products/data/product_repository.dart';
import 'package:aloe_wellness_coach/features/products/domain/product_models.dart';
import 'package:aloe_wellness_coach/features/profile/domain/profile_models.dart';
import 'package:aloe_wellness_coach/features/trackers/domain/tracker_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProductRepository recommendations', () {
    test(
      'boost hydration and routine products when tracking signals need support',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        final ProductRepository repository = ProductRepository(
          preferences: preferences,
        );

        final UserProfile profile = UserProfile(
          id: 'user-1',
          displayName: 'Aloe Friend',
          goalIds: const <WellnessGoalId>[WellnessGoalId.energySupport],
          activityLevel: ActivityLevel.balanced,
          hydrationBaselineMl: 1500,
          hydrationTargetMl: 2400,
          sleepBaselineHours: 6.5,
          sleepTargetHours: 7.8,
          programLengthDays: 14,
          createdAt: DateTime(2026, 3, 28),
          personalNote: '',
        );

        final ProgressSnapshot progress = ProgressSnapshot(
          logs: <DailyLog>[
            DailyLog(
              date: DateTime(2026, 3, 27),
              waterMl: 900,
              sleepHours: 6.1,
              mood: MoodLevel.grounded,
              completedChecklistIds: <String>[],
              note: '',
            ),
          ],
          currentStreak: 0,
          averageWaterMl: 900,
          averageSleepHours: 6.1,
          averageMoodScore: 1.0,
          weightDeltaKg: null,
        );

        final List<Product> recommendations = repository.recommendProducts(
          profile: profile,
          products: seedProducts,
          progress: progress,
        );

        expect(
          recommendations.take(3).map((item) => item.id),
          contains('aloe-reset-pack'),
        );
        expect(
          recommendations.take(3).map((item) => item.id),
          contains('aloe-gel-classic'),
        );
        expect(
          recommendations.indexWhere((item) => item.id == 'aloe-reset-pack'),
          lessThan(
            recommendations.indexWhere((item) => item.id == 'bee-pollen-daily'),
          ),
        );
      },
    );
  });
}
