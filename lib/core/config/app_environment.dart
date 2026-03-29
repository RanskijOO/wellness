import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import '../utils/shop_link_resolver.dart';

class AppEnvironment {
  const AppEnvironment({
    required this.environmentName,
    required this.demoMode,
    required this.enableSupabase,
    required this.enableFirebase,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.shopBaseUrl,
    required this.supportEmail,
    required this.highlightMessage,
    required this.firebaseApiKey,
    required this.firebaseAndroidAppId,
    required this.firebaseIosAppId,
    required this.firebaseProjectId,
    required this.firebaseMessagingSenderId,
    required this.firebaseStorageBucket,
  });

  final String environmentName;
  final bool demoMode;
  final bool enableSupabase;
  final bool enableFirebase;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String shopBaseUrl;
  final String supportEmail;
  final String highlightMessage;
  final String firebaseApiKey;
  final String firebaseAndroidAppId;
  final String firebaseIosAppId;
  final String firebaseProjectId;
  final String firebaseMessagingSenderId;
  final String firebaseStorageBucket;

  bool get shouldEnableSupabase =>
      enableSupabase && supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  bool get shouldEnableFirebase {
    return enableFirebase &&
        firebaseApiKey.isNotEmpty &&
        firebaseProjectId.isNotEmpty &&
        firebaseMessagingSenderId.isNotEmpty &&
        (firebaseAndroidAppId.isNotEmpty || firebaseIosAppId.isNotEmpty);
  }

  FirebaseOptions? firebaseOptions(TargetPlatform targetPlatform) {
    if (!shouldEnableFirebase) {
      return null;
    }

    final String appId = switch (targetPlatform) {
      TargetPlatform.iOS || TargetPlatform.macOS => firebaseIosAppId,
      _ => firebaseAndroidAppId,
    };

    if (appId.isEmpty) {
      return null;
    }

    return FirebaseOptions(
      apiKey: firebaseApiKey,
      appId: appId,
      messagingSenderId: firebaseMessagingSenderId,
      projectId: firebaseProjectId,
      storageBucket: firebaseStorageBucket.isEmpty
          ? null
          : firebaseStorageBucket,
    );
  }

  static Future<AppEnvironment> load() async {
    final String content = await rootBundle.loadString('assets/env/app.env');
    final Map<String, String> values = <String, String>{};

    for (final String rawLine in content.split('\n')) {
      final String line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }
      final int separatorIndex = line.indexOf('=');
      if (separatorIndex <= 0) {
        continue;
      }
      final String key = line.substring(0, separatorIndex).trim();
      final String value = line.substring(separatorIndex + 1).trim();
      values[key] = value;
    }

    return AppEnvironment(
      environmentName: values['APP_ENV'] ?? 'development',
      demoMode: _readBool(values['DEMO_MODE'], fallback: true),
      enableSupabase: _readBool(values['ENABLE_SUPABASE'], fallback: false),
      enableFirebase: _readBool(values['ENABLE_FIREBASE'], fallback: false),
      supabaseUrl: values['SUPABASE_URL'] ?? '',
      supabaseAnonKey: values['SUPABASE_ANON_KEY'] ?? '',
      shopBaseUrl: normalizeShopBaseUrl(
        values['SHOP_BASE_URL'] ?? defaultShopBaseUrl,
      ),
      supportEmail: values['SUPPORT_EMAIL'] ?? 'ranskijoo@gmail.com',
      highlightMessage:
          values['HIGHLIGHT_MESSAGE'] ??
          'Рухайтесь у власному темпі: вода, сон і спокійний щоденний ритм.',
      firebaseApiKey: values['FIREBASE_API_KEY'] ?? '',
      firebaseAndroidAppId: values['FIREBASE_ANDROID_APP_ID'] ?? '',
      firebaseIosAppId: values['FIREBASE_IOS_APP_ID'] ?? '',
      firebaseProjectId: values['FIREBASE_PROJECT_ID'] ?? '',
      firebaseMessagingSenderId: values['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      firebaseStorageBucket: values['FIREBASE_STORAGE_BUCKET'] ?? '',
    );
  }

  static bool _readBool(String? value, {required bool fallback}) {
    if (value == null) {
      return fallback;
    }
    return switch (value.toLowerCase()) {
      '1' || 'true' || 'yes' || 'on' => true,
      '0' || 'false' || 'no' || 'off' => false,
      _ => fallback,
    };
  }
}
