import 'package:flutter/material.dart';

import '../../../core/content/legal_content.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({required this.documentKey, super.key});

  final String documentKey;

  @override
  Widget build(BuildContext context) {
    final (String title, String content)? document = switch (documentKey) {
      'privacy' => ('Політика конфіденційності', privacyPolicyTemplate),
      'terms' => ('Умови використання', termsTemplate),
      'support' => ('Підтримка', supportTemplate),
      'disclaimer' => ('Дисклеймер', wellnessDisclaimerBody),
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(title: Text(document?.$1 ?? 'Документ недоступний')),
      body: AloePageBackground(
        child: document == null
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(AloeSpacing.xl),
                  child: Text(
                    'Запитаний документ не знайдено. Поверніться до профілю або відкрийте один із доступних legal-розділів.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(AloeSpacing.xl),
                children: <Widget>[
                  GradientHero(
                    eyebrow: 'Документ',
                    title: document.$1,
                    subtitle:
                        'Прозора інформація про використання застосунку, приватність і підтримку.',
                    trailing: const AloeIconBadge(
                      icon: Icons.description_outlined,
                      size: 74,
                      circular: true,
                    ),
                  ),
                  const SizedBox(height: AloeSpacing.xl),
                  SectionSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: document.$2
                          .split('\n')
                          .where((String line) => line.trim().isNotEmpty)
                          .map((String line) {
                            if (line.startsWith('# ')) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AloeSpacing.md,
                                ),
                                child: Text(
                                  line.replaceFirst('# ', ''),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              );
                            }
                            if (line.startsWith('## ')) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: AloeSpacing.lg,
                                  bottom: AloeSpacing.sm,
                                ),
                                child: Text(
                                  line.replaceFirst('## ', ''),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AloeSpacing.md,
                              ),
                              child: SelectableText(line),
                            );
                          })
                          .toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
