import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/content/seed_catalog.dart';
import '../../profile/domain/profile_models.dart';
import '../domain/auth_models.dart';

class AuthRepository {
  AuthRepository({
    required SharedPreferences preferences,
    required FlutterSecureStorage secureStorage,
    SupabaseClient? supabaseClient,
  }) : _preferences = preferences,
       _secureStorage = secureStorage,
       _supabaseClient = supabaseClient;

  static const String sessionKey = 'app_session_v1';
  static const String lastEmailKey = 'last_email';

  final SharedPreferences _preferences;
  final FlutterSecureStorage _secureStorage;
  final SupabaseClient? _supabaseClient;

  Future<AppSession> restoreSession() async {
    final User? currentUser = _supabaseClient?.auth.currentUser;
    final String? storedSession = _preferences.getString(sessionKey);
    if (storedSession == null || storedSession.isEmpty) {
      return AppSession(
        onboardingComplete: false,
        authMode: currentUser == null ? AuthMode.signedOut : AuthMode.email,
        preferences: const AppPreferences(
          themePreference: ThemePreference.system,
          languageCode: 'uk',
          remindersEnabled: true,
          reminderSettings: defaultReminderSettings,
        ),
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(storedSession) as Map<String, dynamic>;
    final AppSession stored = AppSession.fromJson(json);
    if (_supabaseClient == null || stored.authMode != AuthMode.email) {
      return stored;
    }

    if (currentUser == null) {
      return persistSession(stored.copyWith(authMode: AuthMode.signedOut));
    }

    final UserProfile? updatedProfile = stored.profile?.copyWith(
      email: currentUser.email,
      displayName: currentUser.email == null
          ? stored.profile?.displayName
          : _displayNameFromEmail(currentUser.email!),
    );

    return persistSession(
      stored.copyWith(authMode: AuthMode.email, profile: updatedProfile),
    );
  }

  Future<AppSession> persistSession(AppSession session) async {
    await _preferences.setString(sessionKey, jsonEncode(session.toJson()));
    if (session.profile?.email case final String email?) {
      await _secureStorage.write(key: lastEmailKey, value: email);
    }
    return session;
  }

  Future<AppSession> signInWithEmail({
    required AppSession currentSession,
    required String email,
    required String password,
  }) async {
    if (_supabaseClient != null) {
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    }

    final UserProfile? profile = currentSession.profile?.copyWith(
      email: email,
      displayName: _displayNameFromEmail(email),
    );
    return persistSession(
      currentSession.copyWith(
        authMode: AuthMode.email,
        onboardingComplete:
            currentSession.onboardingComplete || profile != null,
        profile: profile,
      ),
    );
  }

  Future<AppSession> signUpWithEmail({
    required AppSession currentSession,
    required String email,
    required String password,
  }) async {
    if (_supabaseClient != null) {
      await _supabaseClient.auth.signUp(email: email, password: password);
    }

    final UserProfile? profile = currentSession.profile?.copyWith(
      email: email,
      displayName: _displayNameFromEmail(email),
    );

    return persistSession(
      currentSession.copyWith(
        authMode: AuthMode.email,
        onboardingComplete:
            currentSession.onboardingComplete || profile != null,
        profile: profile,
      ),
    );
  }

  Future<AppSession> continueAsGuest(AppSession currentSession) async {
    return persistSession(currentSession.copyWith(authMode: AuthMode.guest));
  }

  Future<void> resetPassword(String email) async {
    if (_supabaseClient == null) {
      return;
    }
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }

  Future<AppSession> signOut(AppSession currentSession) async {
    if (_supabaseClient != null) {
      await _supabaseClient.auth.signOut();
    }

    return persistSession(
      currentSession.copyWith(authMode: AuthMode.signedOut),
    );
  }

  Future<String?> readLastEmail() => _secureStorage.read(key: lastEmailKey);

  String _displayNameFromEmail(String email) {
    final String handle = email.split('@').first.trim();
    if (handle.isEmpty) {
      return 'Aloe Friend';
    }
    return handle[0].toUpperCase() + handle.substring(1);
  }
}
