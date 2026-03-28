import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';
import '../domain/product_models.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AppState> appState = ref.watch(appControllerProvider);
    final String searchQuery = _searchController.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Каталог')),
      body: appState.when(
        data: (AppState state) {
          final Iterable<Product> categoryFiltered = _selectedCategoryId == null
              ? state.products
              : state.products.where(
                  (Product item) => item.categoryId == _selectedCategoryId,
                );
          final List<Product> filteredProducts = categoryFiltered.where((
            Product item,
          ) {
            if (searchQuery.isEmpty) {
              return true;
            }
            return item.title.toLowerCase().contains(searchQuery) ||
                item.shortDescription.toLowerCase().contains(searchQuery) ||
                item.wellnessTags.any(
                  (String tag) => formatWellnessTag(
                    tag,
                  ).toLowerCase().contains(searchQuery),
                );
          }).toList();

          return AloePageBackground(
            child: ListView(
              padding: const EdgeInsets.all(AloeSpacing.xl),
              children: <Widget>[
                GradientHero(
                  eyebrow: 'Каталог',
                  title: 'Продуктні підказки',
                  subtitle:
                      'Каталог натхненний aloe-first wellness-підходом і веде на зовнішній сайт без in-app checkout у MVP.',
                  trailing: const AloeIconBadge(
                    icon: Icons.local_florist_outlined,
                    size: 74,
                    circular: true,
                  ),
                ),
                const SizedBox(height: AloeSpacing.xl),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: 'Пошук за назвою, категорією або wellness-тегом',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AloeSpacing.lg),
                Wrap(
                  spacing: AloeSpacing.sm,
                  runSpacing: AloeSpacing.sm,
                  children: <Widget>[
                    ChoiceChip(
                      label: const Text('Усе'),
                      selected: _selectedCategoryId == null,
                      onSelected: (_) =>
                          setState(() => _selectedCategoryId = null),
                    ),
                    ...state.categories.map(
                      (ProductCategory category) => ChoiceChip(
                        label: Text(category.title),
                        selected: _selectedCategoryId == category.id,
                        onSelected: (_) =>
                            setState(() => _selectedCategoryId = category.id),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AloeSpacing.xl),
                if (filteredProducts.isEmpty)
                  const EmptyStateView(
                    title: 'Нічого не знайдено',
                    body:
                        'Спробуйте іншу категорію або коротший пошуковий запит.',
                    icon: Icons.search_off_rounded,
                  ),
                for (final Product product in filteredProducts) ...<Widget>[
                  SectionSurface(
                    onTap: () => context.push('/product/${product.id}'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AloeIconBadge(
                          icon: resolveIcon(product.imageToken),
                          size: 72,
                        ),
                        const SizedBox(width: AloeSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                product.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AloeSpacing.xs),
                              Text(product.shortDescription),
                              const SizedBox(height: AloeSpacing.sm),
                              Wrap(
                                spacing: AloeSpacing.xs,
                                runSpacing: AloeSpacing.xs,
                                children: product.wellnessTags
                                    .take(2)
                                    .map(
                                      (String tag) => Chip(
                                        label: Text(formatWellnessTag(tag)),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: AloeSpacing.sm),
                              Text(
                                product.highlight,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AloeSpacing.lg),
                ],
              ],
            ),
          );
        },
        error: (Object error, StackTrace _) => AloePageBackground(
          child: ErrorStateView(
            title: 'Каталог недоступний',
            body:
                'Не вдалося завантажити каталог. Перевірте зʼєднання або повторіть спробу.',
            actionLabel: 'Спробувати ще раз',
            onRetry: () => ref.invalidate(appControllerProvider),
          ),
        ),
        loading: () => const AloePageBackground(
          child: LoadingStateView(label: 'Завантажуємо wellness-каталог...'),
        ),
      ),
    );
  }
}
