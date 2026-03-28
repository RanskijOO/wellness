import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

import '../../features/profile/domain/profile_models.dart';
import '../config/app_environment.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    debugPrint('Background message received: ${message.messageId}');
  }
}

class AnalyticsService {
  const AnalyticsService();

  void track(
    String event, [
    Map<String, Object?> payload = const <String, Object?>{},
  ]) {
    if (kDebugMode) {
      debugPrint('analytics::$event => $payload');
    }
  }
}

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> isOnline() async {
    final List<ConnectivityResult> results = await _connectivity
        .checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  Stream<bool> onlineStream() {
    return _connectivity.onConnectivityChanged.map((
      List<ConnectivityResult> results,
    ) {
      return !results.contains(ConnectivityResult.none);
    }).distinct();
  }
}

class ExternalLinkService {
  const ExternalLinkService();

  Future<void> open(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw StateError('Unable to open $url');
    }
  }

  Future<void> openMail(String email, {String? subject}) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: subject == null
          ? null
          : <String, String>{'subject': subject},
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw StateError('Unable to open mail client');
    }
  }
}

class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz_data.initializeTimeZones();

    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  Future<void> syncReminders(List<ReminderSetting> reminders) async {
    await initialize();
    await _plugin.cancelAll();

    int id = 1;
    for (final ReminderSetting reminder in reminders.where(
      (ReminderSetting item) => item.isEnabled,
    )) {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime schedule = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        reminder.hour,
        reminder.minute,
      );

      if (schedule.isBefore(now)) {
        schedule = schedule.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        id: id,
        title: reminder.title,
        body: reminder.description,
        scheduledDate: schedule,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'wellness_reminders',
            'Wellness reminders',
            channelDescription: 'Daily wellness reminders and streak recovery',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      id += 1;
    }
  }
}

class PushMessagingService {
  const PushMessagingService();

  Future<void> initialize(AppEnvironment environment) async {
    final FirebaseOptions? options = environment.firebaseOptions(
      defaultTargetPlatform,
    );
    if (options == null) {
      return;
    }

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: options);
    }

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
  }
}

class AppServices {
  AppServices({
    required this.environment,
    required this.analytics,
    required this.connectivity,
    required this.externalLinks,
    required this.notifications,
    required this.pushMessaging,
    required this.packageInfo,
  });

  final AppEnvironment environment;
  final AnalyticsService analytics;
  final ConnectivityService connectivity;
  final ExternalLinkService externalLinks;
  final NotificationService notifications;
  final PushMessagingService pushMessaging;
  final PackageInfo packageInfo;

  static Future<AppServices> create(AppEnvironment environment) async {
    final NotificationService notifications = NotificationService();
    await notifications.initialize();

    final PushMessagingService pushMessaging = const PushMessagingService();
    await pushMessaging.initialize(environment);

    return AppServices(
      environment: environment,
      analytics: const AnalyticsService(),
      connectivity: ConnectivityService(),
      externalLinks: const ExternalLinkService(),
      notifications: notifications,
      pushMessaging: pushMessaging,
      packageInfo: await PackageInfo.fromPlatform(),
    );
  }
}
