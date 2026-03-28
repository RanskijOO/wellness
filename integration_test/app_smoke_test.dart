import 'package:aloe_wellness_coach/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding flow reaches questionnaire step', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: OnboardingScreen())),
    );

    await tester.tap(find.text('Далі'));
    await tester.pumpAndSettle();
    expect(find.text('Оберіть ваші wellness-цілі'), findsOneWidget);

    await tester.tap(find.text('Підтримка гідратації'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Далі'));
    await tester.pumpAndSettle();

    expect(find.text('Ваш ритм життя'), findsOneWidget);
  });
}
