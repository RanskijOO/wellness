import 'package:aloe_wellness_coach/features/trackers/data/tracker_repository.dart';
import 'package:aloe_wellness_coach/features/trackers/domain/tracker_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TrackerRepository', () {
    test('persists logs and calculates averages', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final TrackerRepository repository = TrackerRepository(
        preferences: preferences,
      );

      await repository.saveLog(
        log: DailyLog(
          date: DateTime(2026, 3, 27),
          waterMl: 2000,
          sleepHours: 7.5,
          weightKg: 70,
          mood: MoodLevel.balanced,
          note: 'Solid day',
          completedChecklistIds: const <String>['a'],
        ),
      );
      await repository.saveLog(
        log: DailyLog(
          date: DateTime(2026, 3, 28),
          waterMl: 2500,
          sleepHours: 8,
          weightKg: 69.5,
          mood: MoodLevel.upbeat,
          note: 'Even better',
          completedChecklistIds: const <String>['a', 'b'],
        ),
      );

      final ProgressSnapshot snapshot = repository.buildSnapshot(
        repository.loadLogs(),
      );

      expect(snapshot.logs.length, 2);
      expect(snapshot.averageWaterMl, 2250);
      expect(snapshot.averageSleepHours, 7.75);
      expect(snapshot.averageMoodScore, 3.5);
      expect(snapshot.weightDeltaKg, -0.5);
    });
  });
}
