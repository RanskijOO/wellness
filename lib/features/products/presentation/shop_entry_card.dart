import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';

bool canOpenShopUrl(String url) {
  final Uri? uri = Uri.tryParse(url);
  return uri != null && uri.hasScheme;
}

Future<void> openShopInApp({
  required BuildContext context,
  required WidgetRef ref,
  required String url,
  required String title,
  required String source,
}) async {
  if (!canOpenShopUrl(url)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Для магазину ще не налаштовано коректне посилання.'),
      ),
    );
    return;
  }

  ref.read(appServicesProvider).analytics.track(
    'shop_opened',
    <String, Object?>{'mode': 'in_app', 'source': source, 'url': url},
  );

  if (!context.mounted) {
    return;
  }

  context.push(
    '/browser?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}',
  );
}

Future<void> openShopInBrowser({
  required BuildContext context,
  required WidgetRef ref,
  required String url,
  required String source,
}) async {
  if (!canOpenShopUrl(url)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Для магазину ще не налаштовано коректне посилання.'),
      ),
    );
    return;
  }

  ref.read(appServicesProvider).analytics.track(
    'shop_opened',
    <String, Object?>{'mode': 'browser', 'source': source, 'url': url},
  );

  try {
    await ref.read(appServicesProvider).externalLinks.open(url);
  } catch (_) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Не вдалося відкрити магазин у браузері.')),
    );
  }
}

class ShopEntryCard extends StatelessWidget {
  const ShopEntryCard({
    required this.url,
    required this.title,
    required this.subtitle,
    required this.onOpenInApp,
    required this.onOpenInBrowser,
    super.key,
  });

  final String url;
  final String title;
  final String subtitle;
  final VoidCallback onOpenInApp;
  final VoidCallback onOpenInBrowser;

  @override
  Widget build(BuildContext context) {
    final bool canOpen = canOpenShopUrl(url);
    final String host = Uri.tryParse(url)?.host ?? url;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 360;

        return SectionSurface(
          padding: EdgeInsets.all(compact ? AloeSpacing.lg : AloeSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionTitle(
                eyebrow: 'Магазин',
                title: title,
                subtitle: subtitle,
              ),
              const SizedBox(height: AloeSpacing.lg),
              Wrap(
                spacing: AloeSpacing.sm,
                runSpacing: AloeSpacing.sm,
                children: <Widget>[
                  _ShopMetaPill(
                    icon: Icons.language_rounded,
                    label: host,
                    maxWidth: constraints.maxWidth - (compact ? 24 : 32),
                  ),
                  _ShopMetaPill(
                    icon: Icons.verified_user_outlined,
                    label: 'Офіційний shop URL',
                    maxWidth: constraints.maxWidth - (compact ? 24 : 32),
                  ),
                ],
              ),
              const SizedBox(height: AloeSpacing.lg),
              AppPrimaryButton(
                label: 'Відкрити в застосунку',
                onPressed: canOpen ? onOpenInApp : null,
                icon: Icons.open_in_new_rounded,
              ),
              const SizedBox(height: AloeSpacing.md),
              AppSecondaryButton(
                label: 'Відкрити в браузері',
                onPressed: canOpen ? onOpenInBrowser : null,
                icon: Icons.language_rounded,
              ),
              if (!canOpen) ...<Widget>[
                const SizedBox(height: AloeSpacing.md),
                Text(
                  'Посилання магазину поки невалідне. Перевірте remote config або `SHOP_BASE_URL`.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ShopMetaPill extends StatelessWidget {
  const _ShopMetaPill({
    required this.icon,
    required this.label,
    required this.maxWidth,
  });

  final IconData icon;
  final String label;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AloeRadii.pill,
          color: dark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.56),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.14),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AloeSpacing.md,
            vertical: AloeSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(icon, size: 18),
              ),
              const SizedBox(width: AloeSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
