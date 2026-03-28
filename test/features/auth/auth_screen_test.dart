import 'package:aloe_wellness_coach/app/providers.dart';
import 'package:aloe_wellness_coach/core/config/app_environment.dart';
import 'package:aloe_wellness_coach/features/auth/presentation/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('auth screen validates empty credentials before submit', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appEnvironmentProvider.overrideWithValue(
            const AppEnvironment(
              environmentName: 'test',
              demoMode: true,
              enableSupabase: false,
              enableFirebase: false,
              supabaseUrl: '',
              supabaseAnonKey: '',
              shopBaseUrl: 'https://example.com',
              supportEmail: 'support@example.com',
              highlightMessage: 'Test highlight',
              firebaseApiKey: '',
              firebaseAndroidAppId: '',
              firebaseIosAppId: '',
              firebaseProjectId: '',
              firebaseMessagingSenderId: '',
              firebaseStorageBucket: '',
            ),
          ),
          sharedPreferencesProvider.overrideWithValue(preferences),
          secureStorageProvider.overrideWithValue(const FlutterSecureStorage()),
          supabaseClientProvider.overrideWithValue(null),
        ],
        child: const MaterialApp(home: AuthScreen()),
      ),
    );

    final Finder submitButton = find.widgetWithText(FilledButton, 'Увійти');
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Введіть email.'), findsOneWidget);
    expect(find.text('Введіть пароль.'), findsOneWidget);
  });
}
