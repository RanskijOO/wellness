import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';
import '../../plans/domain/plan_models.dart';
import '../../products/domain/product_models.dart';
import '../../products/presentation/shop_entry_card.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppState> appState = ref.watch(appControllerProvider);

    return Scaffold(
      body: appState.when(
        data: (AppState state) {
          final dashboard = state.dashboardSnapshot;
          if (dashboard == null) {
            return const AloePageBackground(
              child: SafeArea(
                child: EmptyStateView(
                  title: 'Підготуємо ваш wellness-ритм',
                  body:
                      'Після onboarding тут з’являться персональний план, трекери та продуктні підказки.',
                ),
              ),
            );
          }

          final WellnessPlanDay todayPlan =
              dashboard.activePlan.days[state.currentPlanDayNumber - 1];
          final double waterProgress =
              dashboard.todaysLog.waterMl / dashboard.profile.hydrationTargetMl;
          final int enabledReminders = state
              .session
              .preferences
              .reminderSettings
              .where((item) => item.isEnabled)
              .length;

          return AloePageBackground(
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AloeSpacing.xl,
                  AloeSpacing.lg,
                  AloeSpacing.xl,
                  AloeSpacing.xxxl,
                ),
                children: <Widget>[
                  if (!state.isOnline)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AloeSpacing.lg),
                      child: SectionSurface(
                        child: Row(
                          children: <Widget>[
                            const AloeIconBadge(
                              icon: Icons.cloud_off_outlined,
                              size: 42,
                            ),
                            const SizedBox(width: AloeSpacing.md),
                            Expanded(
                              child: Text(
                                'Ви офлайн. Локальні дані продовжують працювати, а синхронізація відновиться пізніше.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final double textScale = MediaQuery.textScalerOf(
                        context,
                      ).scale(1);
                      final bool compactHero =
                          constraints.maxWidth < 420 || textScale > 1.05;

                      return GradientHero(
                        eyebrow: 'Сьогодні',
                        title:
                            'День ${state.currentPlanDayNumber} із ${dashboard.activePlan.durationDays}',
                        subtitle: dashboard.highlightMessage,
                        trailing: WaterRing(
                          progress: waterProgress,
                          valueLabel: '${dashboard.todaysLog.waterMl} мл',
                          caption: 'з ${dashboard.profile.hydrationTargetMl} мл',
                          size: compactHero ? 136 : 158,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AloeSpacing.xl),
                  Wrap(
                    spacing: AloeSpacing.sm,
                    runSpacing: AloeSpacing.sm,
                    children: <Widget>[
                      MetricPill(
                        label: 'Сон',
                        value:
                            '${dashboard.todaysLog.sleepHours.toStringAsFixed(1)} год',
                        icon: Icons.bedtime_outlined,
                      ),
                      MetricPill(
                        label: 'Настрій',
                        value: dashboard.todaysLog.mood.title,
                        icon: Icons.sentiment_satisfied_alt_outlined,
                      ),
                      MetricPill(
                        label: 'Вага',
                        value: dashboard.todaysLog.weightKg == null
                            ? 'Не внесено'
                            : '${dashboard.todaysLog.weightKg!.toStringAsFixed(1)} кг',
                        icon: Icons.monitor_weight_outlined,
                      ),
                      MetricPill(
                        label: 'Серія',
                        value: '${dashboard.progress.currentStreak} дн.',
                        icon: Icons.local_fire_department_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: AloeSpacing.xl),
                  SectionSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SectionTitle(
                          eyebrow: 'Сьогодні',
                          title: 'Сьогоднішній огляд',
                          subtitle:
                              'Сон, нотатки та нагадування, які допомагають тримати спокійний ритм.',
                        ),
                        const SizedBox(height: AloeSpacing.lg),
                        Text(
                          dashboard.todaysLog.note.isEmpty
                              ? 'Нотатка на сьогодні ще не додана. Додайте кілька слів про самопочуття або про те, що спрацювало найкраще.'
                              : dashboard.todaysLog.note,
                        ),
                        const SizedBox(height: AloeSpacing.lg),
                        Wrap(
                          spacing: AloeSpacing.sm,
                          runSpacing: AloeSpacing.sm,
                          children: <Widget>[
                            MetricPill(
                              label: 'Нагадування',
                              value: '$enabledReminders актив.',
                              icon: Icons.notifications_active_outlined,
                            ),
                            MetricPill(
                              label: 'Виконання',
                              value:
                                  '${(dashboard.activePlan.adherenceScore * 100).round()}%',
                              icon: Icons.checklist_rtl_outlined,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AloeSpacing.xl),
                  ShopEntryCard(
                    url: state.remoteConfig.shopBaseUrl,
                    title: 'Відкрити весь Aloe Hub shop',
                    subtitle:
                        'Повний сайт магазину доступний і в застосунку, і в зовнішньому браузері.',
                    onOpenInApp: () => openShopInApp(
                      context: context,
                      ref: ref,
                      url: state.remoteConfig.shopBaseUrl,
                      title: 'Aloe Hub Shop',
                      source: 'dashboard_shop_card',
                    ),
                    onOpenInBrowser: () => openShopInBrowser(
                      context: context,
                      ref: ref,
                      url: state.remoteConfig.shopBaseUrl,
                      source: 'dashboard_shop_card',
                    ),
                  ),
                  const SizedBox(height: AloeSpacing.xl),
                  SectionSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SectionTitle(
                          eyebrow: 'План',
                          title: 'План на сьогодні',
                          subtitle:
                              'Маленькі кроки, які легко повторювати щодня.',
                        ),
                        const SizedBox(height: AloeSpacing.lg),
                        _PlanLine(
                          icon: Icons.water_drop_outlined,
                          text: todayPlan.hydrationTask,
                        ),
                        const SizedBox(height: AloeSpacing.md),
                        _PlanLine(
                          icon: Icons.spa_outlined,
                          text: todayPlan.wellnessAction,
                        ),
                        const SizedBox(height: AloeSpacing.md),
                        _PlanLine(
                          icon: Icons.edit_note_outlined,
                          text:
                              'Питання для нотатки: ${todayPlan.journalPrompt}',
                        ),
                        const SizedBox(height: AloeSpacing.lg),
                        ...todayPlan.checklist.map(
                          (ChecklistItem item) => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: item.isCompleted,
                            onChanged: (_) => ref
                                .read(appControllerProvider.notifier)
                                .toggleChecklistItem(
                                  dayNumber: todayPlan.dayNumber,
                                  itemId: item.id,
                                ),
                            title: Text(item.label),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AloeSpacing.xl),
                  SectionSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SectionTitle(
                          eyebrow: 'Швидкі дії',
                          title: 'Оберіть наступний крок',
                          subtitle:
                              'Відкрийте прогрес, плани, каталог або налаштування в один дотик.',
                        ),
                        const SizedBox(height: AloeSpacing.lg),
                        Wrap(
                          spacing: AloeSpacing.md,
                          runSpacing: AloeSpacing.md,
                          children: <Widget>[
                            ActionTileButton(
                              label: 'Прогрес',
                              subtitle: 'Вода, сон, настрій',
                              icon: Icons.insights_outlined,
                              onTap: () => context.go('/progress'),
                            ),
                            ActionTileButton(
                              label: 'Плани',
                              subtitle: '7 / 14 / 21 днів',
                              icon: Icons.event_note_outlined,
                              onTap: () => context.go('/plans'),
                            ),
                            ActionTileButton(
                              label: 'Каталог',
                              subtitle: 'Wellness-категорії',
                              icon: Icons.shopping_bag_outlined,
                              onTap: () => context.go('/products'),
                            ),
                            ActionTileButton(
                              label: 'Профіль',
                              subtitle: 'Налаштування та legal',
                              icon: Icons.settings_outlined,
                              onTap: () => context.go('/profile'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AloeSpacing.xl),
                  SectionSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SectionTitle(
                          eyebrow: 'Гідратація',
                          title: 'Швидкий water-boost',
                          subtitle:
                              'Оновіть воду одним натисканням або перейдіть до повного щоденного огляду.',
                        ),
                        const SizedBox(height: AloeSpacing.lg),
                        Wrap(
                          spacing: AloeSpacing.sm,
                          runSpacing: AloeSpacing.sm,
                          children: <Widget>[
                            for (final int value in <int>[250, 500, 750])
                              FilledButton.tonal(
                                onPressed: () => ref
                                    .read(appControllerProvider.notifier)
                                    .updateWater(
                                      dashboard.todaysLog.waterMl + value,
                                    ),
                                child: Text('+$value мл'),
                              ),
                          ],
                        ),
                        const SizedBox(height: AloeSpacing.md),
                        TextButton(
                          onPressed: () => context.go('/progress'),
                          child: const Text('Відкрити повний щоденний огляд'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AloeSpacing.xl),
                  SectionSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SectionTitle(
                          eyebrow: 'Каталог',
                          title: 'Рекомендовані продукти',
                          subtitle:
                              'Усі рекомендації формулюються як загальна wellness-підтримка.',
                        ),
                        const SizedBox(height: AloeSpacing.lg),
                        if (dashboard.recommendedProducts.isEmpty)
                          const EmptyStateView(
                            title: 'Поки що без product-підказок',
                            body:
                                'Продовжуйте вносити щоденні відмітки, і тут з’являться більш релевантні wellness-рекомендації.',
                            icon: Icons.local_florist_outlined,
                          )
                        else
                          for (final Product product
                              in dashboard.recommendedProducts.take(3))
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AloeSpacing.lg,
                              ),
                              child: InkWell(
                                borderRadius: AloeRadii.md,
                                onTap: () =>
                                    context.push('/product/${product.id}'),
                                child: Ink(
                                  padding: const EdgeInsets.all(AloeSpacing.md),
                                  decoration: BoxDecoration(
                                    borderRadius: AloeRadii.md,
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withValues(alpha: 0.02)
                                        : Colors.white.withValues(alpha: 0.42),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      AloeIconBadge(
                                        icon: resolveIcon(product.imageToken),
                                        size: 62,
                                      ),
                                      const SizedBox(width: AloeSpacing.lg),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              product.title,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                            const SizedBox(
                                              height: AloeSpacing.xs,
                                            ),
                                            Text(product.highlight),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right_rounded),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (Object error, StackTrace _) => AloePageBackground(
          child: SafeArea(
            child: ErrorStateView(
              title: 'Не вдалося відкрити головний екран',
              body:
                  'Схоже, сталася тимчасова помилка даних або синхронізації. Спробуйте ще раз.',
              actionLabel: 'Спробувати ще раз',
              onRetry: () => ref.invalidate(appControllerProvider),
            ),
          ),
        ),
        loading: () => const AloePageBackground(
          child: SafeArea(
            child: LoadingStateView(
              label: 'Формуємо ваш сьогоднішній wellness-план...',
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanLine extends StatelessWidget {
  const _PlanLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AloeIconBadge(icon: icon, size: 36),
        const SizedBox(width: AloeSpacing.sm),
        Expanded(child: Text(text)),
      ],
    );
  }
}
