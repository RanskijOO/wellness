import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/content/legal_content.dart';
import '../../../core/content/seed_catalog.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';
import '../../goals/domain/wellness_goal.dart';
import '../domain/onboarding_models.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int _pageIndex = 0;
  bool _submitting = false;
  OnboardingDraft _draft = const OnboardingDraft(
    selectedGoalKeys: <String>[],
    activityLevel: ActivityLevel.balanced,
    hydrationBaselineMl: 1900,
    sleepBaselineHours: 7.0,
    programLengthDays: 14,
    wantsReminders: true,
    disclaimerAccepted: false,
    privacyAccepted: false,
    termsAccepted: false,
  );

  @override
  void dispose() {
    _pageController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_pageIndex == 1 && _draft.selectedGoalKeys.isEmpty) {
      _showMessage('Оберіть хоча б одну wellness-ціль.');
      return;
    }
    if (_pageIndex < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _finish() async {
    if (!_draft.hasRequiredConsents) {
      _showMessage(
        'Потрібно прийняти дисклеймер, політику конфіденційності та умови.',
      );
      return;
    }

    final double? weight = double.tryParse(
      _weightController.text.replaceAll(',', '.'),
    );
    if (_weightController.text.trim().isNotEmpty &&
        (weight == null || weight < 25 || weight > 350)) {
      _showMessage('Вкажіть коректну вагу або залиште поле порожнім.');
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref
          .read(appControllerProvider.notifier)
          .completeOnboarding(
            _draft.copyWith(
              startingWeightKg: weight,
              personalNote: _noteController.text.trim(),
            ),
          );
    } catch (error) {
      _showMessage('Не вдалося завершити onboarding. Спробуйте ще раз.');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Widget> pages = <Widget>[
      _WelcomeStep(theme: theme),
      _GoalsStep(
        selectedGoalKeys: _draft.selectedGoalKeys,
        onToggle: (WellnessGoalId goal) {
          setState(() {
            final List<String> goals = List<String>.from(
              _draft.selectedGoalKeys,
            );
            if (goals.contains(goal.storageKey)) {
              goals.remove(goal.storageKey);
            } else {
              goals.add(goal.storageKey);
            }
            _draft = _draft.copyWith(selectedGoalKeys: goals);
          });
        },
      ),
      _QuestionnaireStep(
        draft: _draft,
        onActivityChanged: (ActivityLevel value) {
          setState(() => _draft = _draft.copyWith(activityLevel: value));
        },
        onProgramChanged: (int value) {
          setState(() => _draft = _draft.copyWith(programLengthDays: value));
        },
      ),
      _BaselineStep(
        draft: _draft,
        weightController: _weightController,
        noteController: _noteController,
        onHydrationChanged: (double value) {
          setState(
            () => _draft = _draft.copyWith(hydrationBaselineMl: value.round()),
          );
        },
        onSleepChanged: (double value) {
          setState(() => _draft = _draft.copyWith(sleepBaselineHours: value));
        },
        onRemindersChanged: (bool value) {
          setState(() => _draft = _draft.copyWith(wantsReminders: value));
        },
      ),
      _ConsentStep(
        draft: _draft,
        onDisclaimerChanged: (bool value) {
          setState(() => _draft = _draft.copyWith(disclaimerAccepted: value));
        },
        onPrivacyChanged: (bool value) {
          setState(() => _draft = _draft.copyWith(privacyAccepted: value));
        },
        onTermsChanged: (bool value) {
          setState(() => _draft = _draft.copyWith(termsAccepted: value));
        },
      ),
    ];

    return Scaffold(
      body: AloePageBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AloeSpacing.xl,
                  AloeSpacing.xl,
                  AloeSpacing.xl,
                  AloeSpacing.md,
                ),
                child: Row(
                  children: <Widget>[
                    if (_pageIndex > 0)
                      IconButton(
                        onPressed: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                        ),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      )
                    else
                      const SizedBox(width: 48),
                    const SizedBox(width: AloeSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Aloe Wellness Coach',
                            style: theme.textTheme.labelMedium?.copyWith(
                              letterSpacing: 1.1,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.82,
                              ),
                            ),
                          ),
                          const SizedBox(height: AloeSpacing.sm),
                          LinearProgressIndicator(
                            value: (_pageIndex + 1) / pages.length,
                            minHeight: 10,
                            borderRadius: AloeRadii.pill,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int index) =>
                      setState(() => _pageIndex = index),
                  children: pages,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AloeSpacing.xl,
                  AloeSpacing.lg,
                  AloeSpacing.xl,
                  AloeSpacing.xxl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Крок ${_pageIndex + 1} з ${pages.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AloeSpacing.md),
                    AppPrimaryButton(
                      label: _submitting
                          ? 'Зберігаємо...'
                          : _pageIndex == pages.length - 1
                          ? 'Завершити onboarding'
                          : 'Далі',
                      onPressed: _submitting
                          ? null
                          : _pageIndex == pages.length - 1
                          ? _finish
                          : _nextPage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AloeSpacing.xl),
      children: <Widget>[
        GradientHero(
          eyebrow: 'Старт',
          title: 'Aloe Wellness Coach',
          subtitle:
              'Преміальний wellness-компаньйон для води, сну, настрою та м’яких продуктних підказок.',
          trailing: const AloeIconBadge(
            icon: Icons.eco_outlined,
            size: 88,
            circular: true,
          ),
        ),
        const SizedBox(height: AloeSpacing.xxl),
        Wrap(
          spacing: AloeSpacing.sm,
          runSpacing: AloeSpacing.sm,
          children: const <Widget>[
            Chip(label: Text('7 / 14 / 21 днів')),
            Chip(label: Text('Вода • Сон • Настрій')),
            Chip(label: Text('Без медичних обіцянок')),
          ],
        ),
        const SizedBox(height: AloeSpacing.xl),
        SectionSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Що ви отримаєте', style: theme.textTheme.titleLarge),
              const SizedBox(height: AloeSpacing.lg),
              const _FeatureRow(
                icon: Icons.tips_and_updates_outlined,
                title: 'Персональний щоденний ритм',
                body: '7, 14 або 21 день із простими кроками на кожен день.',
              ),
              const SizedBox(height: AloeSpacing.lg),
              const _FeatureRow(
                icon: Icons.water_drop_outlined,
                title: 'Щоденні трекери',
                body:
                    'Вода, сон, вага, настрій і виконання плану в одному просторі.',
              ),
              const SizedBox(height: AloeSpacing.lg),
              const _FeatureRow(
                icon: Icons.local_florist_outlined,
                title: 'М’які product-підказки',
                body:
                    'Рекомендації формулюються як wellness-support, а не як медичні поради.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalsStep extends StatelessWidget {
  const _GoalsStep({required this.selectedGoalKeys, required this.onToggle});

  final List<String> selectedGoalKeys;
  final ValueChanged<WellnessGoalId> onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AloeSpacing.xl),
      children: <Widget>[
        const _OnboardingIntro(
          eyebrow: 'Крок 1',
          title: 'Оберіть ваші wellness-цілі',
          subtitle:
              'Вони допоможуть сформувати тон плану та підказати релевантні продукти.',
          icon: Icons.flag_outlined,
        ),
        const SizedBox(height: AloeSpacing.xl),
        const SectionTitle(
          title: 'Оберіть ваші wellness-цілі',
          subtitle:
              'Вони допоможуть сформувати тон плану та підказати релевантні продукти.',
        ),
        const SizedBox(height: AloeSpacing.xl),
        for (final WellnessGoalId goal in allGoals()) ...<Widget>[
          _GoalCard(
            goal: goal,
            selected: selectedGoalKeys.contains(goal.storageKey),
            onTap: () => onToggle(goal),
          ),
          const SizedBox(height: AloeSpacing.lg),
        ],
      ],
    );
  }
}

class _QuestionnaireStep extends StatelessWidget {
  const _QuestionnaireStep({
    required this.draft,
    required this.onActivityChanged,
    required this.onProgramChanged,
  });

  final OnboardingDraft draft;
  final ValueChanged<ActivityLevel> onActivityChanged;
  final ValueChanged<int> onProgramChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AloeSpacing.xl),
      children: <Widget>[
        const _OnboardingIntro(
          eyebrow: 'Крок 2',
          title: 'Ваш ритм життя',
          subtitle: 'Це допоможе підібрати м’який, реалістичний темп програми.',
          icon: Icons.self_improvement_outlined,
        ),
        const SizedBox(height: AloeSpacing.xl),
        SectionSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Темп дня', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AloeSpacing.lg),
              Wrap(
                spacing: AloeSpacing.sm,
                runSpacing: AloeSpacing.sm,
                children: ActivityLevel.values.map((ActivityLevel level) {
                  return ChoiceChip(
                    label: Text(level.title),
                    selected: draft.activityLevel == level,
                    onSelected: (_) => onActivityChanged(level),
                  );
                }).toList(),
              ),
              const SizedBox(height: AloeSpacing.lg),
              Text(
                draft.activityLevel.subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AloeSpacing.xl),
        SectionSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Тривалість програми',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AloeSpacing.lg),
              Wrap(
                spacing: AloeSpacing.sm,
                runSpacing: AloeSpacing.sm,
                children: const <int>[7, 14, 21].map((int days) {
                  return ChoiceChip(
                    label: Text('$days днів'),
                    selected: draft.programLengthDays == days,
                    onSelected: (_) => onProgramChanged(days),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BaselineStep extends StatelessWidget {
  const _BaselineStep({
    required this.draft,
    required this.weightController,
    required this.noteController,
    required this.onHydrationChanged,
    required this.onSleepChanged,
    required this.onRemindersChanged,
  });

  final OnboardingDraft draft;
  final TextEditingController weightController;
  final TextEditingController noteController;
  final ValueChanged<double> onHydrationChanged;
  final ValueChanged<double> onSleepChanged;
  final ValueChanged<bool> onRemindersChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AloeSpacing.xl),
      children: <Widget>[
        const _OnboardingIntro(
          eyebrow: 'Крок 3',
          title: 'Базовий рівень',
          subtitle:
              'Ці значення потрібні лише для персоналізації wellness-плану, а не для медичних висновків.',
          icon: Icons.water_drop_outlined,
        ),
        const SizedBox(height: AloeSpacing.xl),
        const SectionTitle(
          title: 'Базовий рівень',
          subtitle:
              'Ці значення потрібні лише для персоналізації wellness-плану, а не для медичних висновків.',
        ),
        const SizedBox(height: AloeSpacing.xl),
        SectionSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Скільки води ви зазвичай випиваєте?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                min: 1200,
                max: 3200,
                divisions: 20,
                value: draft.hydrationBaselineMl.toDouble(),
                label: '${draft.hydrationBaselineMl} мл',
                onChanged: onHydrationChanged,
              ),
              Text('${draft.hydrationBaselineMl} мл / день'),
            ],
          ),
        ),
        const SizedBox(height: AloeSpacing.lg),
        SectionSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Скільки годин сну ви отримуєте в середньому?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                min: 5,
                max: 10,
                divisions: 10,
                value: draft.sleepBaselineHours,
                label: '${draft.sleepBaselineHours.toStringAsFixed(1)} год',
                onChanged: onSleepChanged,
              ),
              Text('${draft.sleepBaselineHours.toStringAsFixed(1)} год / ніч'),
            ],
          ),
        ),
        const SizedBox(height: AloeSpacing.lg),
        SectionSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Початкова вага, якщо хочете відстежувати',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AloeSpacing.md),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Наприклад, 68.5',
                  suffixText: 'кг',
                ),
              ),
              const SizedBox(height: AloeSpacing.lg),
              TextField(
                controller: noteController,
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'Що для вас зараз найважливіше: стабільність, вода, спокійний ритм, догляд?',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AloeSpacing.lg),
        SectionSurface(
          child: SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: draft.wantsReminders,
            onChanged: onRemindersChanged,
            title: const Text('Увімкнути м’які нагадування'),
            subtitle: const Text(
              'Вода, вечірній огляд та нагадування про план.',
            ),
          ),
        ),
      ],
    );
  }
}

class _ConsentStep extends StatelessWidget {
  const _ConsentStep({
    required this.draft,
    required this.onDisclaimerChanged,
    required this.onPrivacyChanged,
    required this.onTermsChanged,
  });

  final OnboardingDraft draft;
  final ValueChanged<bool> onDisclaimerChanged;
  final ValueChanged<bool> onPrivacyChanged;
  final ValueChanged<bool> onTermsChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AloeSpacing.xl),
      children: <Widget>[
        const _OnboardingIntro(
          eyebrow: 'Крок 4',
          title: 'Згода та безпечне використання',
          subtitle:
              'Ми формулюємо рекомендації як lifestyle-support. Без діагнозів, лікування чи медичних обіцянок.',
          icon: Icons.verified_user_outlined,
        ),
        const SizedBox(height: AloeSpacing.xl),
        const SectionTitle(
          title: 'Згода та безпечне використання',
          subtitle:
              'Ми формулюємо рекомендації як lifestyle-support. Без діагнозів, лікування чи медичних обіцянок.',
        ),
        const SizedBox(height: AloeSpacing.xl),
        SectionSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SelectableText(wellnessDisclaimerBody),
              const SizedBox(height: AloeSpacing.lg),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: draft.disclaimerAccepted,
                onChanged: (bool? value) => onDisclaimerChanged(value ?? false),
                title: const Text('Я прочитав(ла) дисклеймер'),
                subtitle: const Text(
                  'Розумію, що застосунок не дає медичних порад і не обіцяє лікувальних результатів.',
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.push('/legal/disclaimer'),
                  child: const Text('Відкрити повний дисклеймер'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AloeSpacing.lg),
        SectionSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(privacyConsentSummary),
              const SizedBox(height: AloeSpacing.md),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: draft.privacyAccepted,
                onChanged: (bool? value) => onPrivacyChanged(value ?? false),
                title: const Text('Я погоджуюсь із політикою конфіденційності'),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.push('/legal/privacy'),
                  child: const Text('Прочитати політику конфіденційності'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AloeSpacing.lg),
        SectionSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(termsConsentSummary),
              const SizedBox(height: AloeSpacing.md),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: draft.termsAccepted,
                onChanged: (bool? value) => onTermsChanged(value ?? false),
                title: const Text('Я приймаю умови використання'),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.push('/legal/terms'),
                  child: const Text('Прочитати умови використання'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnboardingIntro extends StatelessWidget {
  const _OnboardingIntro({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GradientHero(
      eyebrow: eyebrow,
      title: title,
      subtitle: subtitle,
      trailing: AloeIconBadge(icon: icon, size: 74, circular: true),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final WellnessGoalId goal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primary = Theme.of(context).colorScheme.primary;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: AloeRadii.lg,
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(AloeSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: AloeRadii.lg,
            gradient: LinearGradient(
              colors: selected
                  ? dark
                        ? <Color>[
                            primary.withValues(alpha: 0.20),
                            AloeColors.darkElevated,
                          ]
                        : <Color>[
                            primary.withValues(alpha: 0.16),
                            Colors.white.withValues(alpha: 0.95),
                          ]
                  : dark
                  ? <Color>[
                      AloeColors.darkCard.withValues(alpha: 0.98),
                      AloeColors.darkElevated.withValues(alpha: 0.94),
                    ]
                  : <Color>[
                      Colors.white.withValues(alpha: 0.94),
                      AloeColors.cloud.withValues(alpha: 0.92),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: selected
                  ? primary.withValues(alpha: 0.24)
                  : dark
                  ? Colors.white.withValues(alpha: 0.06)
                  : AloeColors.forest.withValues(alpha: 0.06),
            ),
            boxShadow: AloeShadows.soft(dark),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AloeIconBadge(icon: resolveIcon(goal.iconKey), size: 52),
              const SizedBox(width: AloeSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      goal.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AloeSpacing.sm),
                    Text(goal.description),
                  ],
                ),
              ),
              const SizedBox(width: AloeSpacing.md),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.add_circle_outline_rounded,
                color: selected
                    ? primary
                    : Theme.of(context).textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AloeIconBadge(icon: icon, size: 44),
        const SizedBox(width: AloeSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AloeSpacing.xs),
              Text(body),
            ],
          ),
        ),
      ],
    );
  }
}
