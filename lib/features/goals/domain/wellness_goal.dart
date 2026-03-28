import '../../onboarding/domain/onboarding_models.dart';

enum WellnessGoalId {
  hydrationSupport,
  dailyWellnessRoutine,
  energySupport,
  beautySkinSupport,
  healthyRoutineSupport,
  consistencySelfCare;

  String get storageKey => switch (this) {
    WellnessGoalId.hydrationSupport => 'hydration_support',
    WellnessGoalId.dailyWellnessRoutine => 'daily_wellness_routine',
    WellnessGoalId.energySupport => 'energy_support',
    WellnessGoalId.beautySkinSupport => 'beauty_skin_support',
    WellnessGoalId.healthyRoutineSupport => 'healthy_routine_support',
    WellnessGoalId.consistencySelfCare => 'consistency_self_care',
  };

  String get title => switch (this) {
    WellnessGoalId.hydrationSupport => 'Підтримка гідратації',
    WellnessGoalId.dailyWellnessRoutine => 'Щоденний wellness-ритм',
    WellnessGoalId.energySupport => 'Підтримка енергії',
    WellnessGoalId.beautySkinSupport => 'Краса та wellness шкіри',
    WellnessGoalId.healthyRoutineSupport => 'Підтримка здорової рутини',
    WellnessGoalId.consistencySelfCare => 'Послідовність і self-care',
  };

  String get subtitle => switch (this) {
    WellnessGoalId.hydrationSupport =>
      'Вода, м’які нагадування та aloe-first звички.',
    WellnessGoalId.dailyWellnessRoutine =>
      'Стабільний день із простими діями без стресу.',
    WellnessGoalId.energySupport =>
      'Фокус на ритмі дня, харчуванні та відновленні.',
    WellnessGoalId.beautySkinSupport =>
      'Питний режим, догляд і підтримка внутрішньої рутини.',
    WellnessGoalId.healthyRoutineSupport =>
      'Комфортний темп, базові звички та простий щоденний порядок.',
    WellnessGoalId.consistencySelfCare =>
      'М’яка дисципліна, відновлення та турбота про себе.',
  };

  String get description => switch (this) {
    WellnessGoalId.hydrationSupport =>
      'Підійде, якщо хочеться пити більше води та тримати комфортний щоденний ритм.',
    WellnessGoalId.dailyWellnessRoutine =>
      'Для тих, хто хоче зібрати базовий wellness-план без складних правил.',
    WellnessGoalId.energySupport =>
      'Для користувачів, яким потрібен більш структурований день і м’яка підтримка бадьорості.',
    WellnessGoalId.beautySkinSupport =>
      'Для поєднання питного режиму, сну та базового догляду за собою.',
    WellnessGoalId.healthyRoutineSupport =>
      'Для формування спокійних щоденних звичок навколо води, харчування та відновлення.',
    WellnessGoalId.consistencySelfCare =>
      'Для тих, хто хоче зберігати ритм без жорстких правил і не випадати з турботи про себе.',
  };

  String get iconKey => switch (this) {
    WellnessGoalId.hydrationSupport => 'water_drop',
    WellnessGoalId.dailyWellnessRoutine => 'sunny',
    WellnessGoalId.energySupport => 'bolt',
    WellnessGoalId.beautySkinSupport => 'spa',
    WellnessGoalId.healthyRoutineSupport => 'check_circle',
    WellnessGoalId.consistencySelfCare => 'self_improvement',
  };

  List<String> get productTags => switch (this) {
    WellnessGoalId.hydrationSupport => <String>[
      'hydration',
      'aloe',
      'daily-routine',
    ],
    WellnessGoalId.dailyWellnessRoutine => <String>[
      'daily-routine',
      'balance',
      'combo',
    ],
    WellnessGoalId.energySupport => <String>['energy', 'nutrition', 'focus'],
    WellnessGoalId.beautySkinSupport => <String>['beauty', 'skin', 'hydration'],
    WellnessGoalId.healthyRoutineSupport => <String>[
      'healthy-routine',
      'balance',
      'nutrition',
    ],
    WellnessGoalId.consistencySelfCare => <String>[
      'self-care',
      'combo',
      'balance',
    ],
  };

  static WellnessGoalId fromStorage(String value) => switch (value) {
    'hydration_support' => WellnessGoalId.hydrationSupport,
    'daily_wellness_routine' => WellnessGoalId.dailyWellnessRoutine,
    'daily_routine' => WellnessGoalId.dailyWellnessRoutine,
    'energy_support' => WellnessGoalId.energySupport,
    'beauty_skin_support' => WellnessGoalId.beautySkinSupport,
    'beauty_support' => WellnessGoalId.beautySkinSupport,
    'healthy_routine_support' => WellnessGoalId.healthyRoutineSupport,
    'weight_routine' => WellnessGoalId.healthyRoutineSupport,
    'consistency_self_care' => WellnessGoalId.consistencySelfCare,
    _ => WellnessGoalId.dailyWellnessRoutine,
  };
}

class GoalRecommendation {
  const GoalRecommendation({
    required this.planLengthDays,
    required this.hydrationTargetMl,
    required this.sleepTargetHours,
    required this.priorityTags,
    required this.headline,
    required this.summary,
  });

  final int planLengthDays;
  final int hydrationTargetMl;
  final double sleepTargetHours;
  final List<String> priorityTags;
  final String headline;
  final String summary;
}

class GoalRecommendationEngine {
  const GoalRecommendationEngine._();

  static GoalRecommendation evaluate({
    required List<WellnessGoalId> goals,
    required ActivityLevel activityLevel,
    required int hydrationBaselineMl,
    required double sleepBaselineHours,
    required int requestedPlanLengthDays,
  }) {
    final Set<String> tags = <String>{};
    for (final WellnessGoalId goal in goals) {
      tags.addAll(goal.productTags);
    }

    final int planLength = switch (goals.length) {
      >= 3 => 21,
      2 => requestedPlanLengthDays < 14 ? 14 : requestedPlanLengthDays,
      _ => requestedPlanLengthDays,
    };

    final int activityBonusMl = switch (activityLevel) {
      ActivityLevel.calm => 250,
      ActivityLevel.balanced => 450,
      ActivityLevel.active => 650,
    };

    final int hydrationTarget = (hydrationBaselineMl + activityBonusMl).clamp(
      1800,
      3400,
    );
    final double sleepTarget =
        (sleepBaselineHours < 7.5 ? sleepBaselineHours + 0.5 : 8.0).clamp(
          7.0,
          8.5,
        );

    final String headline;
    if (goals.contains(WellnessGoalId.hydrationSupport)) {
      headline = 'Фокус тижня: м’яка гідратація та стабільний день';
    } else if (goals.contains(WellnessGoalId.energySupport)) {
      headline = 'Фокус тижня: ритм, відновлення та рівна енергія';
    } else if (goals.contains(WellnessGoalId.beautySkinSupport)) {
      headline = 'Фокус тижня: внутрішній баланс і догляд за собою';
    } else if (goals.contains(WellnessGoalId.consistencySelfCare)) {
      headline = 'Фокус тижня: м’яка послідовність і турбота про себе';
    } else {
      headline = 'Фокус тижня: спокійний wellness-ритм без перевантаження';
    }

    return GoalRecommendation(
      planLengthDays: planLength,
      hydrationTargetMl: hydrationTarget,
      sleepTargetHours: sleepTarget,
      priorityTags: tags.toList(),
      headline: headline,
      summary:
          'План зібрано як загальну wellness-підтримку без медичних обіцянок: вода, сон, прості щоденні дії та м’які продуктні підказки.',
    );
  }
}
