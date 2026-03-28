import 'package:aloe_wellness_coach/features/plans/domain/plan_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adherence score reflects completed checklist items', () {
    final WellnessPlan plan = WellnessPlan(
      id: 'demo',
      title: 'Demo plan',
      description: 'A simple plan',
      durationDays: 2,
      goalKeys: const <String>['hydration_support'],
      startDate: DateTime(2026, 3, 28),
      days: const <WellnessPlanDay>[
        WellnessPlanDay(
          dayNumber: 1,
          title: 'Day 1',
          hydrationTask: 'Drink water',
          wellnessAction: 'Walk',
          journalPrompt: 'How do you feel?',
          suggestedProductIds: <String>[],
          checklist: <ChecklistItem>[
            ChecklistItem(id: '1', label: 'One', isCompleted: true),
            ChecklistItem(id: '2', label: 'Two', isCompleted: false),
          ],
        ),
        WellnessPlanDay(
          dayNumber: 2,
          title: 'Day 2',
          hydrationTask: 'Drink more water',
          wellnessAction: 'Stretch',
          journalPrompt: 'What worked?',
          suggestedProductIds: <String>[],
          checklist: <ChecklistItem>[
            ChecklistItem(id: '3', label: 'Three', isCompleted: true),
            ChecklistItem(id: '4', label: 'Four', isCompleted: true),
          ],
        ),
      ],
    );

    expect(plan.completedDaysCount, 1);
    expect(plan.adherenceScore, 0.75);
  });
}
