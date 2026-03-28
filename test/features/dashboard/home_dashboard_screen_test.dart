import 'package:aloe_wellness_coach/app/providers.dart';
import 'package:aloe_wellness_coach/core/content/seed_catalog.dart';
import 'package:aloe_wellness_coach/features/auth/domain/auth_models.dart';
import 'package:aloe_wellness_coach/features/dashboard/presentation/home_dashboard_screen.dart';
import 'package:aloe_wellness_coach/features/goals/domain/wellness_goal.dart';
import 'package:aloe_wellness_coach/features/onboarding/domain/onboarding_models.dart';
import 'package:aloe_wellness_coach/features/plans/domain/plan_models.dart';
import 'package:aloe_wellness_coach/features/products/domain/product_models.dart';
import 'package:aloe_wellness_coach/features/profile/domain/profile_models.dart';
import 'package:aloe_wellness_coach/features/trackers/domain/tracker_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dashboard shows check-in and quick actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appControllerProvider.overrideWith(_FakeDashboardController.new),
        ],
        child: const MaterialApp(home: HomeDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Сьогоднішній огляд'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('Оберіть наступний крок'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Рекомендовані продукти'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Рекомендовані продукти'), findsOneWidget);
  });
}

class _FakeDashboardController extends AppController {
  @override
  Future<AppState> build() async {
    final UserProfile profile = UserProfile(
      id: 'user-1',
      displayName: 'Aloe Friend',
      goalIds: const <WellnessGoalId>[
        WellnessGoalId.hydrationSupport,
        WellnessGoalId.consistencySelfCare,
      ],
      activityLevel: ActivityLevel.balanced,
      hydrationBaselineMl: 1800,
      hydrationTargetMl: 2400,
      sleepBaselineHours: 7.0,
      sleepTargetHours: 7.5,
      programLengthDays: 14,
      createdAt: DateTime(2026, 3, 28),
      personalNote: 'Потрібно тримати м’який ритм.',
      startingWeightKg: 68.0,
    );

    final List<Product> recommendations = seedProducts.take(3).toList();
    final WellnessPlan plan = WellnessPlan(
      id: 'plan-14-hydration',
      title: '14-денний план',
      description: 'М’який ритм',
      durationDays: 14,
      goalKeys: profile.goalIds.map((item) => item.storageKey).toList(),
      startDate: DateTime.now(),
      days: <WellnessPlanDay>[
        WellnessPlanDay(
          dayNumber: 1,
          title: 'День 1',
          hydrationTask: 'Пийте воду маленькими ковтками протягом дня.',
          wellnessAction: 'Додайте один спокійний прийом їжі без поспіху.',
          journalPrompt: 'Що сьогодні підтримало вас найкраще?',
          checklist: <ChecklistItem>[
            ChecklistItem(
              id: 'water',
              label: 'Досягти водної цілі дня',
              isCompleted: false,
            ),
          ],
          suggestedProductIds: <String>['aloe-gel-classic'],
        ),
      ],
    );

    return AppState(
      session: AppSession(
        onboardingComplete: true,
        authMode: AuthMode.guest,
        profile: profile,
        preferences: const AppPreferences(
          themePreference: ThemePreference.system,
          languageCode: 'uk',
          remindersEnabled: true,
          reminderSettings: <ReminderSetting>[
            ReminderSetting(
              id: 'hydration',
              type: ReminderType.hydration,
              title: 'Вода',
              description: 'Нагадування випити воду',
              hour: 12,
              minute: 0,
              isEnabled: true,
            ),
          ],
        ),
      ),
      remoteConfig: const RemoteAppConfig(
        shopBaseUrl: 'https://www.foreverliving.com/',
        supportEmail: 'support@aloewellnesscoach.app',
        enableAiCoach: false,
        highlightMessage: 'Тримайте власний м’який ритм.',
      ),
      categories: seedCategories,
      products: seedProducts,
      recommendedProducts: recommendations,
      logs: <DailyLog>[
        DailyLog(
          date: DateTime(2026, 3, 28),
          waterMl: 1600,
          sleepHours: 7.2,
          weightKg: 67.8,
          mood: MoodLevel.calm,
          note: 'Спокійний день і хороша вода.',
          completedChecklistIds: <String>[],
        ),
      ],
      progress: ProgressSnapshot(
        logs: <DailyLog>[
          DailyLog(
            date: DateTime(2026, 3, 28),
            waterMl: 1600,
            sleepHours: 7.2,
            weightKg: 67.8,
            mood: MoodLevel.calm,
            note: 'Спокійний день і хороша вода.',
            completedChecklistIds: <String>[],
          ),
        ],
        currentStreak: 2,
        averageWaterMl: 1600,
        averageSleepHours: 7.2,
        averageMoodScore: 2.0,
        weightDeltaKg: -0.2,
      ),
      todayLog: DailyLog(
        date: DateTime(2026, 3, 28),
        waterMl: 1600,
        sleepHours: 7.2,
        weightKg: 67.8,
        mood: MoodLevel.calm,
        note: 'Спокійний день і хороша вода.',
        completedChecklistIds: <String>[],
      ),
      isOnline: true,
      activePlan: plan,
    );
  }
}
