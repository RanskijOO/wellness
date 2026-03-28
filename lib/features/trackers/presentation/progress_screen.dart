import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';
import '../../profile/domain/profile_models.dart';
import '../domain/tracker_models.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _noteController;
  late final FocusNode _weightFocusNode;
  late final FocusNode _noteFocusNode;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _noteController = TextEditingController();
    _weightFocusNode = FocusNode();
    _noteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _noteController.dispose();
    _weightFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void _syncControllers(DailyLog log) {
    final String weightText = log.weightKg == null
        ? ''
        : log.weightKg!.toStringAsFixed(1);
    if (!_weightFocusNode.hasFocus && _weightController.text != weightText) {
      _weightController.text = weightText;
    }
    if (!_noteFocusNode.hasFocus && _noteController.text != log.note) {
      _noteController.text = log.note;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _saveWeight(AppController controller) async {
    final String raw = _weightController.text.trim().replaceAll(',', '.');
    if (raw.isEmpty) {
      await controller.updateWeight(null);
      return;
    }
    final double? parsed = double.tryParse(raw);
    if (parsed == null || parsed < 25 || parsed > 350) {
      _showMessage('Вкажіть коректну вагу в кілограмах.');
      return;
    }
    await controller.updateWeight(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AppState> appState = ref.watch(appControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Прогрес')),
      body: appState.when(
        data: (AppState state) {
          final UserProfile? profile = state.session.profile;
          if (profile == null) {
            return const AloePageBackground(
              child: EmptyStateView(
                title: 'Немає даних профілю',
                body: 'Завершіть onboarding, щоб почати відстеження.',
              ),
            );
          }

          _syncControllers(state.todayLog);
          final AppController controller = ref.read(
            appControllerProvider.notifier,
          );

          return AloePageBackground(
            child: ListView(
              padding: const EdgeInsets.all(AloeSpacing.xl),
              children: <Widget>[
                GradientHero(
                  eyebrow: 'Трекери',
                  title: 'Щоденний огляд',
                  subtitle:
                      'Відстежуйте воду, сон, вагу, настрій та короткі нотатки в одному місці.',
                  trailing: const AloeIconBadge(
                    icon: Icons.insights_outlined,
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
                        eyebrow: 'Вода',
                        title: 'Гідратація',
                        subtitle:
                            'Оновіть сьогоднішній обсяг та подивіться середнє.',
                      ),
                      Slider(
                        min: 0,
                        max: 3600,
                        divisions: 18,
                        value: state.todayLog.waterMl.toDouble().clamp(0, 3600),
                        label: '${state.todayLog.waterMl} мл',
                        onChanged: (double value) =>
                            controller.updateWater(value.round()),
                      ),
                      Text(
                        '${state.todayLog.waterMl} мл сьогодні • середнє ${state.progress.averageWaterMl} мл',
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
                        eyebrow: 'Сон',
                        title: 'Вечірній ритм',
                        subtitle: 'М’яка self-check метрика для вашого ритму.',
                      ),
                      Slider(
                        min: 0,
                        max: 10,
                        divisions: 20,
                        value: state.todayLog.sleepHours.clamp(0, 10),
                        label:
                            '${state.todayLog.sleepHours.toStringAsFixed(1)} год',
                        onChanged: controller.updateSleep,
                      ),
                      Text(
                        '${state.todayLog.sleepHours.toStringAsFixed(1)} год сьогодні • ціль ${profile.sleepTargetHours.toStringAsFixed(1)} год',
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
                        eyebrow: 'Настрій',
                        title: 'Поточний стан',
                        subtitle: 'Позначте поточний стан без зайвого тиску.',
                      ),
                      const SizedBox(height: AloeSpacing.md),
                      Wrap(
                        spacing: AloeSpacing.sm,
                        runSpacing: AloeSpacing.sm,
                        children: MoodLevel.values.map((MoodLevel mood) {
                          return ChoiceChip(
                            label: Text(mood.title),
                            selected: state.todayLog.mood == mood,
                            onSelected: (_) => controller.updateMood(mood),
                          );
                        }).toList(),
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
                        eyebrow: 'Нотатки',
                        title: 'Вага та нотатки',
                        subtitle:
                            'Це особисте відстеження. Метрика не використовується для медичних висновків.',
                      ),
                      const SizedBox(height: AloeSpacing.lg),
                      TextField(
                        controller: _weightController,
                        focusNode: _weightFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Поточна вага',
                          suffixText: 'кг',
                        ),
                        onSubmitted: (_) => _saveWeight(controller),
                      ),
                      const SizedBox(height: AloeSpacing.lg),
                      TextField(
                        controller: _noteController,
                        focusNode: _noteFocusNode,
                        minLines: 3,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          labelText: 'Коротка нотатка дня',
                          hintText: 'Що допомогло сьогодні залишатися в ритмі?',
                        ),
                        onSubmitted: controller.updateNote,
                      ),
                      const SizedBox(height: AloeSpacing.md),
                      Wrap(
                        spacing: AloeSpacing.sm,
                        runSpacing: AloeSpacing.sm,
                        children: <Widget>[
                          AppSecondaryButton(
                            label: 'Зберегти вагу',
                            onPressed: () => _saveWeight(controller),
                          ),
                          AppSecondaryButton(
                            label: 'Зберегти нотатку',
                            onPressed: () => controller.updateNote(
                              _noteController.text.trim(),
                            ),
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
                        eyebrow: 'Аналітика',
                        title: 'Останні записи',
                        subtitle: 'Легка візуалізація для самоусвідомлення.',
                      ),
                      const SizedBox(height: AloeSpacing.xl),
                      Container(
                        height: 220,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AloeSpacing.md,
                          vertical: AloeSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: AloeRadii.md,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.03)
                              : Colors.white.withValues(alpha: 0.42),
                        ),
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: 3600,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 900,
                              getDrawingHorizontalLine: (_) => FlLine(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.10),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: const FlTitlesData(
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: <LineChartBarData>[
                              LineChartBarData(
                                isCurved: true,
                                color: Theme.of(context).colorScheme.primary,
                                barWidth: 4,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.22),
                                      Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.02),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                spots: _buildWaterSpots(state.progress.logs),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.progress.logs.isEmpty) ...<Widget>[
                        const SizedBox(height: AloeSpacing.md),
                        const Text(
                          'Щойно з’являться перші записи, тут буде видно просту динаміку без медичних висновків.',
                        ),
                      ],
                      const SizedBox(height: AloeSpacing.lg),
                      Wrap(
                        spacing: AloeSpacing.sm,
                        runSpacing: AloeSpacing.sm,
                        children: <Widget>[
                          MetricPill(
                            label: 'Середня вода',
                            value: '${state.progress.averageWaterMl} мл',
                            icon: Icons.water_drop_outlined,
                          ),
                          MetricPill(
                            label: 'Середній сон',
                            value:
                                '${state.progress.averageSleepHours.toStringAsFixed(1)} год',
                            icon: Icons.bedtime_outlined,
                          ),
                          MetricPill(
                            label: 'Серія',
                            value: '${state.progress.currentStreak} дн.',
                            icon: Icons.local_fire_department_outlined,
                          ),
                        ],
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
            title: 'Не вдалося відкрити прогрес',
            body:
                'Не вдалося завантажити записи прогресу. Спробуйте ще раз трохи пізніше.',
            actionLabel: 'Спробувати ще раз',
            onRetry: () => ref.invalidate(appControllerProvider),
          ),
        ),
        loading: () => const AloePageBackground(
          child: LoadingStateView(label: 'Завантажуємо ваші трекери...'),
        ),
      ),
    );
  }

  List<FlSpot> _buildWaterSpots(List<DailyLog> logs) {
    final List<DailyLog> recent = logs.length <= 7
        ? logs
        : logs.sublist(logs.length - 7);
    if (recent.isEmpty) {
      return const <FlSpot>[FlSpot(0, 0), FlSpot(1, 0)];
    }

    return List<FlSpot>.generate(
      recent.length,
      (int index) => FlSpot(index.toDouble(), recent[index].waterMl.toDouble()),
    );
  }
}
