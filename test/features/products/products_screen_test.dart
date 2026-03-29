import 'package:aloe_wellness_coach/app/providers.dart';
import 'package:aloe_wellness_coach/core/content/seed_catalog.dart';
import 'package:aloe_wellness_coach/core/design_system/app_theme.dart';
import 'package:aloe_wellness_coach/features/auth/domain/auth_models.dart';
import 'package:aloe_wellness_coach/features/goals/domain/wellness_goal.dart';
import 'package:aloe_wellness_coach/features/onboarding/domain/onboarding_models.dart';
import 'package:aloe_wellness_coach/features/plans/domain/plan_models.dart';
import 'package:aloe_wellness_coach/features/products/domain/product_models.dart';
import 'package:aloe_wellness_coach/features/products/presentation/products_screen.dart';
import 'package:aloe_wellness_coach/features/profile/domain/profile_models.dart';
import 'package:aloe_wellness_coach/features/trackers/domain/tracker_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('catalog screen keeps key text visible on a narrow phone', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(337, 740));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appControllerProvider.overrideWith(_FakeProductsController.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(337, 740),
              textScaler: TextScaler.linear(1.1),
            ),
            child: const ProductsScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Продуктні підказки'), findsOneWidget);
    expect(find.text('Офіційний shop Aloe Hub'), findsOneWidget);
    expect(find.text('Відкрити в застосунку'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeProductsController extends AppController {
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
          checklist: const <ChecklistItem>[
            ChecklistItem(
              id: 'water',
              label: 'Досягти водної цілі дня',
              isCompleted: false,
            ),
          ],
          suggestedProductIds: const <String>['aloe-vera-gel'],
        ),
      ],
    );

    final List<Product> products = seedProducts.take(12).toList();

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
        shopBaseUrl: 'https://aloe-hub.flpuretail.com/uk/',
        supportEmail: 'ranskijoo@gmail.com',
        enableAiCoach: false,
        highlightMessage: 'Тримайте власний м’який ритм.',
      ),
      categories: seedCategories,
      products: products,
      recommendedProducts: products.take(3).toList(),
      logs: <DailyLog>[
        DailyLog(
          date: DateTime(2026, 3, 28),
          waterMl: 1600,
          sleepHours: 7.2,
          weightKg: 67.8,
          mood: MoodLevel.calm,
          note: 'Спокійний день і хороша вода.',
          completedChecklistIds: const <String>[],
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
            completedChecklistIds: const <String>[],
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
        completedChecklistIds: const <String>[],
      ),
      isOnline: true,
      activePlan: plan,
    );
  }
}
