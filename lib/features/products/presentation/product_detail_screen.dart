import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';
import '../domain/product_models.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState? state = ref.watch(appControllerProvider).asData?.value;
    final Product? product = state?.products
        .where((Product item) => item.id == productId)
        .firstOrNull;

    if (product == null) {
      return const Scaffold(
        body: SafeArea(
          child: EmptyStateView(
            title: 'Продукт не знайдено',
            body:
                'Схоже, цей елемент більше не доступний у локальному каталозі.',
          ),
        ),
      );
    }

    final String targetUrl = product.externalProductUrl.isEmpty
        ? state!.remoteConfig.shopBaseUrl
        : product.externalProductUrl;
    final Uri? targetUri = Uri.tryParse(targetUrl);
    final bool canOpenTarget = targetUri != null && targetUri.hasScheme;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: AloePageBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AloeSpacing.xl),
            children: <Widget>[
              GradientHero(
                eyebrow: 'Деталі',
                title: product.title,
                subtitle: product.shortDescription,
                trailing: AloeIconBadge(
                  icon: resolveIcon(product.imageToken),
                  size: 88,
                  circular: true,
                ),
              ),
              const SizedBox(height: AloeSpacing.xl),
              SectionSurface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SectionTitle(
                      eyebrow: 'Рутина',
                      title: 'Як використовувати',
                      subtitle: 'Лише в межах загальної wellness-рутини.',
                    ),
                    const SizedBox(height: AloeSpacing.md),
                    Text(product.usageNotes),
                    const SizedBox(height: AloeSpacing.xl),
                    const SectionTitle(
                      eyebrow: 'Обережність',
                      title: 'На що звернути увагу',
                      subtitle:
                          'Без медичних обіцянок. Завжди перевіряйте склад та особисту сумісність.',
                    ),
                    const SizedBox(height: AloeSpacing.md),
                    Text(product.cautionNotes),
                    const SizedBox(height: AloeSpacing.xl),
                    Wrap(
                      spacing: AloeSpacing.sm,
                      runSpacing: AloeSpacing.sm,
                      children: product.wellnessTags
                          .map(
                            (String tag) =>
                                Chip(label: Text(formatWellnessTag(tag))),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AloeSpacing.xl),
              AppPrimaryButton(
                label: 'Відкрити в застосунку',
                onPressed: !canOpenTarget
                    ? null
                    : () async {
                        try {
                          await ref
                              .read(appControllerProvider.notifier)
                              .recordOutboundClick(
                                product: product,
                                destinationUrl: targetUrl,
                                source: 'webview',
                              );
                          if (context.mounted) {
                            context.push(
                              '/browser?title=${Uri.encodeComponent(product.title)}&url=${Uri.encodeComponent(targetUrl)}',
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Не вдалося відкрити сторінку в застосунку.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                icon: Icons.open_in_new,
              ),
              const SizedBox(height: AloeSpacing.md),
              AppSecondaryButton(
                label: 'Відкрити в браузері',
                onPressed: !canOpenTarget
                    ? null
                    : () async {
                        try {
                          await ref
                              .read(appControllerProvider.notifier)
                              .recordOutboundClick(
                                product: product,
                                destinationUrl: targetUrl,
                                source: 'external',
                              );
                          await ref
                              .read(appServicesProvider)
                              .externalLinks
                              .open(targetUrl);
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Не вдалося відкрити зовнішній браузер.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                icon: Icons.language,
              ),
              if (!canOpenTarget) ...<Widget>[
                const SizedBox(height: AloeSpacing.md),
                const SectionSurface(
                  child: Text(
                    'Для цього продукту ще не налаштовано коректне зовнішнє посилання.',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
