import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system/app_theme.dart';
import '../features/profile/domain/profile_models.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'router/app_router.dart';

class AloeWellnessCoachApp extends ConsumerWidget {
  const AloeWellnessCoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String languageCode = ref.watch(
      appControllerProvider.select(
        (AsyncValue<AppState> asyncState) =>
            asyncState.asData?.value.session.preferences.languageCode ?? 'uk',
      ),
    );
    final ThemeMode themeMode = ref.watch(
      appControllerProvider.select(
        (AsyncValue<AppState> asyncState) => switch (asyncState
            .asData
            ?.value
            .session
            .preferences
            .themePreference) {
          ThemePreference.dark => ThemeMode.dark,
          ThemePreference.light => ThemeMode.light,
          _ => ThemeMode.system,
        },
      ),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Aloe Wellness Coach',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: Locale(languageCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.delegates,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
