import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/tracker_models.dart';

class TrackerRepository {
  TrackerRepository({
    required SharedPreferences preferences,
    SupabaseClient? supabaseClient,
  }) : _preferences = preferences,
       _supabaseClient = supabaseClient;

  static const String dailyLogsKey = 'daily_logs_v1';

  final SharedPreferences _preferences;
  final SupabaseClient? _supabaseClient;

  List<DailyLog> loadLogs() {
    final String? raw = _preferences.getString(dailyLogsKey);
    if (raw == null || raw.isEmpty) {
      return <DailyLog>[];
    }

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((dynamic item) => DailyLog.fromJson(item as Map<String, dynamic>))
        .toList()
      ..sort((DailyLog a, DailyLog b) => a.date.compareTo(b.date));
  }

  DailyLog currentLogOrDefault() {
    final DateTime today = DateTime.now();
    final List<DailyLog> logs = loadLogs();
    for (final DailyLog log in logs) {
      if (_sameDate(log.date, today)) {
        return log;
      }
    }

    return DailyLog(
      date: DateTime(today.year, today.month, today.day),
      waterMl: 0,
      sleepHours: 0,
      mood: MoodLevel.balanced,
      completedChecklistIds: <String>[],
      note: '',
    );
  }

  Future<List<DailyLog>> saveLog({
    required DailyLog log,
    String? userId,
  }) async {
    final List<DailyLog> logs = loadLogs();
    bool replaced = false;
    final List<DailyLog> updated = logs.map((DailyLog item) {
      if (_sameDate(item.date, log.date)) {
        replaced = true;
        return log;
      }
      return item;
    }).toList();

    if (!replaced) {
      updated.add(log);
    }

    updated.sort((DailyLog a, DailyLog b) => a.date.compareTo(b.date));
    await _preferences.setString(
      dailyLogsKey,
      jsonEncode(updated.map((DailyLog item) => item.toJson()).toList()),
    );

    if (_supabaseClient != null && userId != null) {
      try {
        await _supabaseClient.from('daily_logs').upsert(<String, dynamic>{
          'user_id': userId,
          'log_date': log.date.toIso8601String(),
          'water_ml': log.waterMl,
          'sleep_hours': log.sleepHours,
          'weight_kg': log.weightKg,
          'mood_score': log.mood.score,
          'notes': log.note,
          'completed_checklist_ids': log.completedChecklistIds,
        });
      } catch (_) {
        // Local persistence already succeeded.
      }
    }

    return updated;
  }

  ProgressSnapshot buildSnapshot(List<DailyLog> logs) {
    if (logs.isEmpty) {
      return const ProgressSnapshot(
        logs: <DailyLog>[],
        currentStreak: 0,
        averageWaterMl: 0,
        averageSleepHours: 0,
        averageMoodScore: 0,
        weightDeltaKg: null,
      );
    }

    final List<DailyLog> sorted = List<DailyLog>.from(logs)
      ..sort((DailyLog a, DailyLog b) => a.date.compareTo(b.date));

    final int waterAverage =
        sorted.fold<int>(
          0,
          (int value, DailyLog item) => value + item.waterMl,
        ) ~/
        sorted.length;
    final double sleepAverage =
        sorted.fold<double>(
          0,
          (double value, DailyLog item) => value + item.sleepHours,
        ) /
        sorted.length;
    final double moodAverage =
        sorted.fold<double>(
          0,
          (double value, DailyLog item) => value + item.mood.score,
        ) /
        sorted.length;

    final List<double> weights = sorted
        .where((DailyLog item) => item.weightKg != null)
        .map((DailyLog item) => item.weightKg!)
        .toList();

    final double? weightDelta = weights.length >= 2
        ? weights.last - weights.first
        : null;

    return ProgressSnapshot(
      logs: sorted,
      currentStreak: _computeStreak(sorted),
      averageWaterMl: waterAverage,
      averageSleepHours: sleepAverage,
      averageMoodScore: moodAverage,
      weightDeltaKg: weightDelta,
    );
  }

  int _computeStreak(List<DailyLog> logs) {
    if (logs.isEmpty) {
      return 0;
    }

    final List<DateTime> dates =
        logs
            .map(
              (DailyLog item) =>
                  DateTime(item.date.year, item.date.month, item.date.day),
            )
            .toSet()
            .toList()
          ..sort((DateTime a, DateTime b) => b.compareTo(a));

    int streak = 0;
    DateTime cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    for (final DateTime date in dates) {
      if (date == cursor) {
        streak += 1;
        cursor = cursor.subtract(const Duration(days: 1));
      } else if (date == cursor.subtract(const Duration(days: 1)) &&
          streak == 0) {
        cursor = date;
      } else {
        break;
      }
    }
    return streak;
  }

  bool _sameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}
