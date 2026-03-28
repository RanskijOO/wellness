import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/app_environment.dart';
import '../core/services/app_services.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/domain/auth_models.dart';
import '../features/dashboard/domain/dashboard_models.dart';
import '../features/onboarding/domain/onboarding_models.dart';
import '../features/plans/data/plan_repository.dart';
import '../features/plans/domain/plan_models.dart';
import '../features/products/data/product_repository.dart';
import '../features/products/domain/product_models.dart';
import '../features/profile/data/profile_repository.dart';
import '../features/profile/domain/profile_models.dart';
import '../features/trackers/data/tracker_repository.dart';
import '../features/trackers/domain/tracker_models.dart';

final appEnvironmentProvider = Provider<AppEnvironment>(
  (Ref ref) => throw UnimplementedError(),
);

final appServicesProvider = Provider<AppServices>(
  (Ref ref) => throw UnimplementedError(),
);

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (Ref ref) => throw UnimplementedError(),
);

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (Ref ref) => throw UnimplementedError(),
);

final supabaseClientProvider = Provider<SupabaseClient?>(
  (Ref ref) => throw UnimplementedError(),
);

final authRepositoryProvider = Provider<AuthRepository>((Ref ref) {
  return AuthRepository(
    preferences: ref.watch(sharedPreferencesProvider),
    secureStorage: ref.watch(secureStorageProvider),
    supabaseClient: ref.watch(supabaseClientProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((Ref ref) {
  return ProfileRepository(
    preferences: ref.watch(sharedPreferencesProvider),
    environment: ref.watch(appEnvironmentProvider),
    supabaseClient: ref.watch(supabaseClientProvider),
  );
});

final productRepositoryProvider = Provider<ProductRepository>((Ref ref) {
  return ProductRepository(
    preferences: ref.watch(sharedPreferencesProvider),
    supabaseClient: ref.watch(supabaseClientProvider),
  );
});

final planRepositoryProvider = Provider<PlanRepository>((Ref ref) {
  return PlanRepository(
    preferences: ref.watch(sharedPreferencesProvider),
    supabaseClient: ref.watch(supabaseClientProvider),
  );
});

final trackerRepositoryProvider = Provider<TrackerRepository>((Ref ref) {
  return TrackerRepository(
    preferences: ref.watch(sharedPreferencesProvider),
    supabaseClient: ref.watch(supabaseClientProvider),
  );
});

class AppState {
  const AppState({
    required this.session,
    required this.remoteConfig,
    required this.categories,
    required this.products,
    required this.recommendedProducts,
    required this.logs,
    required this.progress,
    required this.todayLog,
    required this.isOnline,
    this.activePlan,
  });

  final AppSession session;
  final RemoteAppConfig remoteConfig;
  final List<ProductCategory> categories;
  final List<Product> products;
  final List<Product> recommendedProducts;
  final List<DailyLog> logs;
  final ProgressSnapshot progress;
  final DailyLog todayLog;
  final bool isOnline;
  final WellnessPlan? activePlan;

  DashboardSnapshot? get dashboardSnapshot {
    final UserProfile? profile = session.profile;
    final WellnessPlan? plan = activePlan;
    if (profile == null || plan == null) {
      return null;
    }
    return DashboardSnapshot(
      profile: profile,
      activePlan: plan,
      todaysLog: todayLog,
      progress: progress,
      recommendedProducts: recommendedProducts,
      highlightMessage: remoteConfig.highlightMessage,
    );
  }

  int get currentPlanDayNumber {
    if (activePlan == null) {
      return 1;
    }

    final int dayOffset =
        DateTime.now().difference(activePlan!.startDate).inDays + 1;
    return dayOffset.clamp(1, activePlan!.durationDays);
  }

  AppState copyWith({
    AppSession? session,
    RemoteAppConfig? remoteConfig,
    List<ProductCategory>? categories,
    List<Product>? products,
    List<Product>? recommendedProducts,
    List<DailyLog>? logs,
    ProgressSnapshot? progress,
    DailyLog? todayLog,
    bool? isOnline,
    WellnessPlan? activePlan,
  }) {
    return AppState(
      session: session ?? this.session,
      remoteConfig: remoteConfig ?? this.remoteConfig,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      logs: logs ?? this.logs,
      progress: progress ?? this.progress,
      todayLog: todayLog ?? this.todayLog,
      isOnline: isOnline ?? this.isOnline,
      activePlan: activePlan ?? this.activePlan,
    );
  }
}

final appControllerProvider = AsyncNotifierProvider<AppController, AppState>(
  AppController.new,
);

class AppController extends AsyncNotifier<AppState> {
  StreamSubscription<bool>? _connectivitySubscription;

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);
  ProfileRepository get _profileRepository =>
      ref.read(profileRepositoryProvider);
  ProductRepository get _productRepository =>
      ref.read(productRepositoryProvider);
  PlanRepository get _planRepository => ref.read(planRepositoryProvider);
  TrackerRepository get _trackerRepository =>
      ref.read(trackerRepositoryProvider);
  AppServices get _services => ref.read(appServicesProvider);

  @override
  Future<AppState> build() async {
    ref.onDispose(() => _connectivitySubscription?.cancel());

    final AppSession session = await _authRepository.restoreSession();
    final RemoteAppConfig remoteConfig = await _profileRepository
        .fetchRemoteConfig();
    final List<ProductCategory> categories = await _productRepository
        .fetchCategories();
    final List<Product> products = await _productRepository.fetchProducts();
    final bool isOnline = await _services.connectivity.isOnline();

    final AppState initial = await _composeState(
      session: session,
      remoteConfig: remoteConfig,
      categories: categories,
      products: products,
      logs: _trackerRepository.loadLogs(),
      isOnline: isOnline,
    );

    _connectivitySubscription = _services.connectivity.onlineStream().listen((
      bool online,
    ) {
      if (!state.hasValue) {
        return;
      }
      state = AsyncData(state.requireValue.copyWith(isOnline: online));
    });

    return initial;
  }

  Future<void> completeOnboarding(OnboardingDraft draft) async {
    final AppState current = state.requireValue;
    final UserProfile profile = _profileRepository.buildProfile(
      draft: draft,
      existingUserId: current.session.profile?.id,
      email: current.session.profile?.email,
      displayName: current.session.profile?.displayName,
    );
    final AppPreferences preferences = _profileRepository.defaultPreferences(
      remindersEnabled: draft.wantsReminders,
    );
    final DateTime acceptedAt = DateTime.now();
    final List<ConsentRecord> consentRecords = <ConsentRecord>[
      ConsentRecord(
        type: ConsentType.disclaimer,
        version: 'v1',
        acceptedAt: acceptedAt,
        source: 'onboarding',
      ),
      ConsentRecord(
        type: ConsentType.privacyPolicy,
        version: 'v1',
        acceptedAt: acceptedAt,
        source: 'onboarding',
      ),
      ConsentRecord(
        type: ConsentType.termsOfUse,
        version: 'v1',
        acceptedAt: acceptedAt,
        source: 'onboarding',
      ),
    ];
    final AppSession session = await _authRepository.persistSession(
      current.session.copyWith(
        onboardingComplete: true,
        profile: profile,
        preferences: preferences,
        consentRecords: consentRecords,
      ),
    );

    await _profileRepository.syncProfile(
      profile: profile,
      consentRecords: consentRecords,
      preferences: preferences,
    );
    await _services.notifications.syncReminders(preferences.reminderSettings);
    _services.analytics.track('onboarding_completed', <String, Object?>{
      'goal_count': profile.goalIds.length,
      'program_length_days': profile.programLengthDays,
      'reminders_enabled': preferences.remindersEnabled,
    });

    state = AsyncData(
      await _composeState(
        session: session,
        remoteConfig: current.remoteConfig,
        categories: current.categories,
        products: current.products,
        logs: current.logs,
        isOnline: current.isOnline,
      ),
    );
  }

  Future<void> signIn(String email, String password) async {
    final AppState current = state.requireValue;
    final AppSession session = await _authRepository.signInWithEmail(
      currentSession: current.session,
      email: email,
      password: password,
    );
    _services.analytics.track('auth_sign_in', <String, Object?>{
      'auth_mode': 'email',
    });
    state = AsyncData(
      await _composeState(
        session: session,
        remoteConfig: current.remoteConfig,
        categories: current.categories,
        products: current.products,
        logs: current.logs,
        isOnline: current.isOnline,
      ),
    );
  }

  Future<void> signUp(String email, String password) async {
    final AppState current = state.requireValue;
    final AppSession session = await _authRepository.signUpWithEmail(
      currentSession: current.session,
      email: email,
      password: password,
    );
    _services.analytics.track('auth_sign_up', <String, Object?>{
      'auth_mode': 'email',
    });
    state = AsyncData(
      await _composeState(
        session: session,
        remoteConfig: current.remoteConfig,
        categories: current.categories,
        products: current.products,
        logs: current.logs,
        isOnline: current.isOnline,
      ),
    );
  }

  Future<void> continueAsGuest() async {
    final AppState current = state.requireValue;
    final AppSession session = await _authRepository.continueAsGuest(
      current.session,
    );
    _services.analytics.track('auth_continue_as_guest');
    state = AsyncData(
      await _composeState(
        session: session,
        remoteConfig: current.remoteConfig,
        categories: current.categories,
        products: current.products,
        logs: current.logs,
        isOnline: current.isOnline,
      ),
    );
  }

  Future<void> signOut() async {
    final AppState current = state.requireValue;
    final AppSession session = await _authRepository.signOut(current.session);
    _services.analytics.track('auth_sign_out');
    state = AsyncData(current.copyWith(session: session));
  }

  Future<void> resetPassword(String email) =>
      _authRepository.resetPassword(email);

  Future<void> setThemePreference(ThemePreference preference) async {
    final AppState current = state.requireValue;
    final AppSession session = await _authRepository.persistSession(
      current.session.copyWith(
        preferences: current.session.preferences.copyWith(
          themePreference: preference,
        ),
      ),
    );
    _services.analytics.track('theme_changed', <String, Object?>{
      'theme': preference.storageKey,
    });
    state = AsyncData(current.copyWith(session: session));
  }

  Future<void> setLanguagePreference(String languageCode) async {
    final AppState current = state.requireValue;
    final AppSession session = await _authRepository.persistSession(
      current.session.copyWith(
        preferences: current.session.preferences.copyWith(
          languageCode: languageCode,
        ),
      ),
    );
    _services.analytics.track('language_changed', <String, Object?>{
      'language_code': languageCode,
    });
    state = AsyncData(current.copyWith(session: session));
  }

  Future<void> toggleReminder(String reminderId, bool enabled) async {
    final AppState current = state.requireValue;
    final UserProfile? profile = current.session.profile;
    final List<ReminderSetting> reminders = current
        .session
        .preferences
        .reminderSettings
        .map(
          (ReminderSetting reminder) => reminder.id == reminderId
              ? reminder.copyWith(isEnabled: enabled)
              : reminder,
        )
        .toList();

    final AppSession session = await _authRepository.persistSession(
      current.session.copyWith(
        preferences: current.session.preferences.copyWith(
          reminderSettings: reminders,
          remindersEnabled: reminders.any(
            (ReminderSetting item) => item.isEnabled,
          ),
        ),
      ),
    );
    await _services.notifications.syncReminders(reminders);
    if (profile != null) {
      await _profileRepository.syncReminders(
        userId: profile.id,
        reminders: reminders,
      );
    }
    _services.analytics.track('reminder_toggled', <String, Object?>{
      'reminder_id': reminderId,
      'enabled': enabled,
    });
    state = AsyncData(current.copyWith(session: session));
  }

  Future<void> updateReminderTime(
    String reminderId, {
    required int hour,
    required int minute,
  }) async {
    final AppState current = state.requireValue;
    final UserProfile? profile = current.session.profile;
    final List<ReminderSetting> reminders = current
        .session
        .preferences
        .reminderSettings
        .map(
          (ReminderSetting reminder) => reminder.id == reminderId
              ? reminder.copyWith(hour: hour, minute: minute)
              : reminder,
        )
        .toList();

    final AppSession session = await _authRepository.persistSession(
      current.session.copyWith(
        preferences: current.session.preferences.copyWith(
          reminderSettings: reminders,
        ),
      ),
    );
    await _services.notifications.syncReminders(reminders);
    if (profile != null) {
      await _profileRepository.syncReminders(
        userId: profile.id,
        reminders: reminders,
      );
    }
    _services.analytics.track('reminder_time_changed', <String, Object?>{
      'reminder_id': reminderId,
      'hour': hour,
      'minute': minute,
    });
    state = AsyncData(current.copyWith(session: session));
  }

  Future<void> updateProgramLength(int days) async {
    final AppState current = state.requireValue;
    final UserProfile? profile = current.session.profile;
    if (profile == null) {
      return;
    }

    final UserProfile updatedProfile = profile.copyWith(
      programLengthDays: days,
    );
    final AppSession session = await _authRepository.persistSession(
      current.session.copyWith(profile: updatedProfile),
    );
    await _profileRepository.syncProgramLength(
      userId: updatedProfile.id,
      programLengthDays: updatedProfile.programLengthDays,
    );
    _services.analytics.track('program_length_changed', <String, Object?>{
      'program_length_days': days,
    });
    state = AsyncData(
      await _composeState(
        session: session,
        remoteConfig: current.remoteConfig,
        categories: current.categories,
        products: current.products,
        logs: current.logs,
        isOnline: current.isOnline,
      ),
    );
  }

  Future<void> updateWater(int waterMl) async {
    await _saveTodayLog((DailyLog log) => log.copyWith(waterMl: waterMl));
  }

  Future<void> updateSleep(double hours) async {
    await _saveTodayLog((DailyLog log) => log.copyWith(sleepHours: hours));
  }

  Future<void> updateWeight(double? weightKg) async {
    await _saveTodayLog((DailyLog log) => log.copyWith(weightKg: weightKg));
  }

  Future<void> updateMood(MoodLevel mood) async {
    await _saveTodayLog((DailyLog log) => log.copyWith(mood: mood));
  }

  Future<void> updateNote(String note) async {
    await _saveTodayLog((DailyLog log) => log.copyWith(note: note));
  }

  Future<void> toggleChecklistItem({
    required int dayNumber,
    required String itemId,
  }) async {
    final AppState current = state.requireValue;
    final WellnessPlan? plan = current.activePlan;
    final UserProfile? profile = current.session.profile;
    if (plan == null || profile == null) {
      return;
    }

    final WellnessPlan updatedPlan = await _planRepository.toggleChecklistItem(
      plan: plan,
      dayNumber: dayNumber,
      itemId: itemId,
      userId: profile.id,
    );

    final WellnessPlanDay updatedDay = updatedPlan.days.firstWhere(
      (WellnessPlanDay day) => day.dayNumber == dayNumber,
    );

    final List<String> completedIds = updatedDay.checklist
        .where((ChecklistItem item) => item.isCompleted)
        .map((ChecklistItem item) => item.id)
        .toList();

    final List<DailyLog> logs = await _trackerRepository.saveLog(
      log: current.todayLog.copyWith(completedChecklistIds: completedIds),
      userId: profile.id,
    );

    state = AsyncData(
      current.copyWith(
        activePlan: updatedPlan,
        logs: logs,
        todayLog: _trackerRepository.currentLogOrDefault(),
        progress: _trackerRepository.buildSnapshot(logs),
      ),
    );
    _services.analytics.track('plan_checklist_toggled', <String, Object?>{
      'day_number': dayNumber,
      'item_id': itemId,
    });
  }

  Future<void> recordOutboundClick({
    required Product product,
    required String destinationUrl,
    required String source,
  }) async {
    final UserProfile? profile = state.requireValue.session.profile;
    if (profile == null) {
      return;
    }
    _services.analytics.track('outbound_click', <String, Object?>{
      'product_id': product.id,
      'destination_url': destinationUrl,
      'source': source,
    });
    await _productRepository.recordOutboundClick(
      product: product,
      userId: profile.id,
      destinationUrl: destinationUrl,
      source: source,
    );
  }

  Future<void> _saveTodayLog(
    DailyLog Function(DailyLog current) transform,
  ) async {
    final AppState current = state.requireValue;
    final UserProfile? profile = current.session.profile;
    if (profile == null) {
      return;
    }

    final DailyLog updatedLog = transform(current.todayLog);
    final List<DailyLog> logs = await _trackerRepository.saveLog(
      log: updatedLog,
      userId: profile.id,
    );
    state = AsyncData(
      current.copyWith(
        logs: logs,
        todayLog: updatedLog,
        progress: _trackerRepository.buildSnapshot(logs),
      ),
    );
  }

  Future<AppState> _composeState({
    required AppSession session,
    required RemoteAppConfig remoteConfig,
    required List<ProductCategory> categories,
    required List<Product> products,
    required List<DailyLog> logs,
    required bool isOnline,
  }) async {
    final UserProfile? profile = session.profile;
    if (profile == null || !session.onboardingComplete) {
      return AppState(
        session: session,
        remoteConfig: remoteConfig,
        categories: categories,
        products: products,
        recommendedProducts: products
            .where((Product item) => item.isFeatured)
            .take(4)
            .toList(),
        logs: logs,
        progress: _trackerRepository.buildSnapshot(logs),
        todayLog: _trackerRepository.currentLogOrDefault(),
        isOnline: isOnline,
      );
    }

    final ProgressSnapshot progress = _trackerRepository.buildSnapshot(logs);
    final List<Product> recommendedProducts = _productRepository
        .recommendProducts(
          profile: profile,
          products: products,
          progress: progress,
        );
    final WellnessPlan plan = await _planRepository.loadOrCreatePlan(
      profile: profile,
      recommendedProducts: recommendedProducts,
    );
    await _services.notifications.syncReminders(
      session.preferences.reminderSettings,
    );

    final DailyLog todayLog = _trackerRepository.currentLogOrDefault();

    return AppState(
      session: session,
      remoteConfig: remoteConfig,
      categories: categories,
      products: products,
      recommendedProducts: recommendedProducts,
      activePlan: plan,
      logs: logs,
      progress: progress,
      todayLog: todayLog,
      isOnline: isOnline,
    );
  }
}
