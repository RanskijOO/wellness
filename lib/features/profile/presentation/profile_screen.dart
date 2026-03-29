import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';
import '../../goals/domain/wellness_goal.dart';
import '../domain/profile_models.dart';

const String _accountDeletionUrl =
    'https://ranskijoo.github.io/wellness/account-deletion/';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppState> appState = ref.watch(appControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: appState.when(
        data: (AppState state) {
          final UserProfile? profile = state.session.profile;
          if (profile == null) {
            return const AloePageBackground(
              child: EmptyStateView(
                title: 'Профіль недоступний',
                body:
                    'Після onboarding тут з’являться ваші налаштування та дані.',
              ),
            );
          }

          return AloePageBackground(
            child: ListView(
              padding: const EdgeInsets.all(AloeSpacing.xl),
              children: <Widget>[
                GradientHero(
                  eyebrow: 'Профіль',
                  title: profile.displayName,
                  subtitle:
                      'Ваш wellness-профіль готовий до щоденного використання. Архітектура локалізації вже підготовлена для англійської.',
                  trailing: const AloeIconBadge(
                    icon: Icons.person_outline,
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
                        eyebrow: 'Цілі',
                        title: 'Ваші wellness-фокуси',
                        subtitle:
                            'Вони впливають на ритм плану та product-підказки.',
                      ),
                      const SizedBox(height: AloeSpacing.lg),
                      Wrap(
                        spacing: AloeSpacing.sm,
                        runSpacing: AloeSpacing.sm,
                        children: profile.goalIds
                            .map<Widget>(
                              (WellnessGoalId item) =>
                                  Chip(label: Text(item.title)),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: AloeSpacing.lg),
                      Wrap(
                        spacing: AloeSpacing.sm,
                        runSpacing: AloeSpacing.sm,
                        children: <Widget>[
                          MetricPill(
                            label: 'Вода',
                            value: '${profile.hydrationTargetMl} мл',
                            icon: Icons.water_drop_outlined,
                          ),
                          MetricPill(
                            label: 'Сон',
                            value:
                                '${profile.sleepTargetHours.toStringAsFixed(1)} год',
                            icon: Icons.bedtime_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AloeSpacing.lg),
                SectionSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SectionTitle(
                        eyebrow: 'Мова',
                        title: 'Локалізація',
                        subtitle:
                            'Українська активна за замовчуванням. Англійська підготовлена на рівні архітектури.',
                      ),
                      const SizedBox(height: AloeSpacing.lg),
                      Wrap(
                        spacing: AloeSpacing.sm,
                        runSpacing: AloeSpacing.sm,
                        children: <Widget>[
                          ChoiceChip(
                            label: const Text('Українська'),
                            selected: true,
                            onSelected: (_) => ref
                                .read(appControllerProvider.notifier)
                                .setLanguagePreference('uk'),
                          ),
                          const Chip(label: Text('Англійська скоро')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AloeSpacing.lg),
                SectionSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SectionTitle(
                        eyebrow: 'Тема',
                        title: 'Візуальний режим',
                        subtitle:
                            'Оберіть візуальний режим, який зручний саме вам.',
                      ),
                      const SizedBox(height: AloeSpacing.lg),
                      Wrap(
                        spacing: AloeSpacing.sm,
                        children: <Widget>[
                          _ThemeChip(
                            title: 'Системна',
                            selected:
                                state.session.preferences.themePreference ==
                                ThemePreference.system,
                            onTap: () => ref
                                .read(appControllerProvider.notifier)
                                .setThemePreference(ThemePreference.system),
                          ),
                          _ThemeChip(
                            title: 'Світла',
                            selected:
                                state.session.preferences.themePreference ==
                                ThemePreference.light,
                            onTap: () => ref
                                .read(appControllerProvider.notifier)
                                .setThemePreference(ThemePreference.light),
                          ),
                          _ThemeChip(
                            title: 'Темна',
                            selected:
                                state.session.preferences.themePreference ==
                                ThemePreference.dark,
                            onTap: () => ref
                                .read(appControllerProvider.notifier)
                                .setThemePreference(ThemePreference.dark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AloeSpacing.lg),
                SectionSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SectionTitle(
                        eyebrow: 'Нагадування',
                        title: 'Пуші та локальні нагадування',
                        subtitle:
                            'Керуйте м’якими пушами та локальними нагадуваннями.',
                      ),
                      const SizedBox(height: AloeSpacing.md),
                      ...state.session.preferences.reminderSettings.map(
                        (ReminderSetting reminder) => SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          value: reminder.isEnabled,
                          onChanged: (bool value) => ref
                              .read(appControllerProvider.notifier)
                              .toggleReminder(reminder.id, value),
                          title: Text(reminder.title),
                          subtitle: Text(
                            '${reminder.description}\n${reminder.hour.toString().padLeft(2, '0')}:${reminder.minute.toString().padLeft(2, '0')}',
                          ),
                          secondary: IconButton(
                            icon: const Icon(Icons.schedule_outlined),
                            tooltip: 'Змінити час',
                            onPressed: () =>
                                _pickReminderTime(context, ref, reminder),
                          ),
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
                      const SectionTitle(
                        eyebrow: 'Документи',
                        title: 'Документи та підтримка',
                        subtitle:
                            'Усі юридичні матеріали та контактні точки в одному місці.',
                      ),
                      const SizedBox(height: AloeSpacing.md),
                      _ProfileAction(
                        title: 'Дисклеймер',
                        icon: Icons.health_and_safety_outlined,
                        onTap: () => context.push('/legal/disclaimer'),
                      ),
                      _ProfileAction(
                        title: 'Політика конфіденційності',
                        icon: Icons.privacy_tip_outlined,
                        onTap: () => context.push('/legal/privacy'),
                      ),
                      _ProfileAction(
                        title: 'Умови використання',
                        icon: Icons.description_outlined,
                        onTap: () => context.push('/legal/terms'),
                      ),
                      _ProfileAction(
                        title: 'Запит на видалення акаунта',
                        icon: Icons.person_remove_outlined,
                        onTap: () => ref
                            .read(appServicesProvider)
                            .externalLinks
                            .open(_accountDeletionUrl),
                      ),
                      _ProfileAction(
                        title: 'Підтримка',
                        icon: Icons.support_agent_outlined,
                        onTap: () => context.push('/legal/support'),
                      ),
                      _ProfileAction(
                        title: 'Написати в підтримку',
                        icon: Icons.mail_outline,
                        onTap: () => ref
                            .read(appServicesProvider)
                            .externalLinks
                            .openMail(
                              state.remoteConfig.supportEmail,
                              subject: 'Aloe Wellness Coach support',
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AloeSpacing.lg),
                SectionSurface(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Версія ${ref.read(appServicesProvider).packageInfo.version}',
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.read(appControllerProvider.notifier).signOut(),
                        child: const Text('Вийти'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (Object error, StackTrace _) => AloePageBackground(
          child: ErrorStateView(
            title: 'Профіль не відкрився',
            body:
                'Не вдалося завантажити профіль і налаштування. Спробуйте ще раз.',
            actionLabel: 'Спробувати ще раз',
            onRetry: () => ref.invalidate(appControllerProvider),
          ),
        ),
        loading: () => const AloePageBackground(
          child: LoadingStateView(label: 'Завантажуємо ваш профіль...'),
        ),
      ),
    );
  }
}

Future<void> _pickReminderTime(
  BuildContext context,
  WidgetRef ref,
  ReminderSetting reminder,
) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: reminder.hour, minute: reminder.minute),
  );
  if (picked == null) {
    return;
  }
  await ref
      .read(appControllerProvider.notifier)
      .updateReminderTime(
        reminder.id,
        hour: picked.hour,
        minute: picked.minute,
      );
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(title),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AloeRadii.md,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AloeSpacing.sm),
        child: Row(
          children: <Widget>[
            AloeIconBadge(icon: icon, size: 42),
            const SizedBox(width: AloeSpacing.md),
            Expanded(child: Text(title)),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
