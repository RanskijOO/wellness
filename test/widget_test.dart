import 'package:aloe_wellness_coach/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('onboarding advances from welcome to goals step', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: OnboardingScreen())),
    );

    expect(find.text('СТАРТ'), findsOneWidget);

    await tester.tap(find.text('Далі'));
    await tester.pumpAndSettle();

    expect(find.text('Оберіть ваші wellness-цілі'), findsAtLeastNWidgets(1));
  });

  testWidgets('onboarding does not skip required steps by swipe gesture', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: OnboardingScreen())),
    );

    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pumpAndSettle();

    expect(find.text('СТАРТ'), findsOneWidget);
  });
}
