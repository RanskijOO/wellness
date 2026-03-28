import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';
import '../domain/plan_models.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppState> appState = ref.watch(appControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Плани')),
      body: appState.when(
        data: (AppState state) {
          final WellnessPlan? plan = state.activePlan;
          if (plan == null) {
            return const AloePageBackground(
              child: EmptyStateView(
                title: 'План ще не створено',
                body:
                    'Завершіть onboarding, щоб отримати 7/14/21-денний wellness-план.',
              ),
            );
          }

          return AloePageBackground(
            child: ListView(
              padding: const EdgeInsets.all(AloeSpacing.xl),
              children: <Widget>[
                GradientHero(
                  eyebrow: 'Програма',
                  title: plan.title,
                  subtitle: plan.description,
                  trailing: const AloeIconBadge(
                    icon: Icons.event_note_outlined,
                    size: 74,
                    circular: true,
                  ),
                ),
                const SizedBox(height: AloeSpacing.xl),
                SectionSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SectionTitle(
                        eyebrow: 'Формат',
                        title: 'Тривалість програми',
                        subtitle: 'Змінюйте формат залежно від вашого ритму.',
                      ),
                      const SizedBox(height: AloeSpacing.lg),
                      Wrap(
                        spacing: AloeSpacing.sm,
                        runSpacing: AloeSpacing.sm,
                        children: <Widget>[
                          for (final int days in <int>[7, 14, 21])
                            ChoiceChip(
                              label: Text('$days днів'),
                              selected: plan.durationDays == days,
                              onSelected: (_) => ref
                                  .read(appControllerProvider.notifier)
                                  .updateProgramLength(days),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AloeSpacing.xl),
                SectionSurface(
                  child: Wrap(
                    spacing: AloeSpacing.sm,
                    runSpacing: AloeSpacing.sm,
                    children: <Widget>[
                      MetricPill(
                        label: 'Виконання',
                        value: '${(plan.adherenceScore * 100).round()}%',
                        icon: Icons.insights_outlined,
                      ),
                      MetricPill(
                        label: 'Готово днів',
                        value:
                            '${plan.completedDaysCount}/${plan.durationDays}',
                        icon: Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AloeSpacing.xl),
                for (final WellnessPlanDay day in plan.days) ...<Widget>[
                  _PlanDayCard(
                    day: day,
                    isToday: day.dayNumber == state.currentPlanDayNumber,
                  ),
                  const SizedBox(height: AloeSpacing.lg),
                ],
                const SizedBox(height: AloeSpacing.xl),
                AppSecondaryButton(
                  label: 'Перейти до каталогу',
                  onPressed: () => context.go('/products'),
                  icon: Icons.local_florist_outlined,
                ),
              ],
            ),
          );
        },
        error: (Object error, StackTrace _) => AloePageBackground(
          child: ErrorStateView(
            title: 'План не завантажився',
            body:
                'Не вдалося підготувати поточну програму. Спробуйте перезавантажити дані.',
            actionLabel: 'Спробувати ще раз',
            onRetry: () => ref.invalidate(appControllerProvider),
          ),
        ),
        loading: () => const AloePageBackground(
          child: LoadingStateView(label: 'Готуємо вашу wellness-програму...'),
        ),
      ),
    );
  }
}

class _PlanDayCard extends ConsumerWidget {
  const _PlanDayCard({required this.day, required this.isToday});

  final WellnessPlanDay day;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              AloeIconBadge(icon: Icons.calendar_today_outlined, size: 42),
              const SizedBox(width: AloeSpacing.md),
              Expanded(
                child: Text(
                  day.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AloeSpacing.md,
                    vertical: AloeSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: AloeRadii.pill,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12),
                  ),
                  child: const Text('Сьогодні'),
                ),
            ],
          ),
          const SizedBox(height: AloeSpacing.md),
          Text(day.hydrationTask),
          const SizedBox(height: AloeSpacing.sm),
          Text(day.wellnessAction),
          const SizedBox(height: AloeSpacing.sm),
          Text('Питання для нотатки: ${day.journalPrompt}'),
          if (day.suggestedProductIds.isNotEmpty) ...<Widget>[
            const SizedBox(height: AloeSpacing.md),
            Wrap(
              spacing: AloeSpacing.sm,
              runSpacing: AloeSpacing.sm,
              children: day.suggestedProductIds
                  .take(2)
                  .map(
                    (String _) => const Chip(label: Text('Опційна підтримка')),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: AloeSpacing.md),
          ...day.checklist.map(
            (ChecklistItem item) => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: item.isCompleted,
              onChanged: (_) => ref
                  .read(appControllerProvider.notifier)
                  .toggleChecklistItem(
                    dayNumber: day.dayNumber,
                    itemId: item.id,
                  ),
              title: Text(item.label),
            ),
          ),
        ],
      ),
    );
  }
}
