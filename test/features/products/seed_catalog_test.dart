import 'package:aloe_wellness_coach/core/content/seed_catalog.dart';
import 'package:aloe_wellness_coach/core/content/storefront_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('seed catalog storefront sync', () {
    test('maps core catalog products to exact Aloe Hub product URLs', () {
      expect(
        seedProducts
            .firstWhere((item) => item.id == 'aloe-vera-gel')
            .externalProductUrl,
        'https://aloe-hub.flpuretail.com/uk/catalog/product/296/',
      );
      expect(
        seedProducts
            .firstWhere((item) => item.id == 'forever-active-probiotic')
            .externalProductUrl,
        'https://aloe-hub.flpuretail.com/uk/catalog/product/28/',
      );
      expect(
        seedProducts
            .firstWhere((item) => item.id == 'aloe-jojoba-shampoo')
            .externalProductUrl,
        'https://aloe-hub.flpuretail.com/uk/catalog/product/3/',
      );
    });

    test(
      'uses the live storefront as the only catalog source and keeps combo packs',
      () {
        expect(seedCategories.any((item) => item.id == 'combo_packs'), isTrue);
        expect(seedProducts, hasLength(storefrontCatalogEntries.length));

        final storefrontOnlyProduct = seedProducts.firstWhere(
          (item) => item.id == 'storefront-668',
        );
        expect(storefrontOnlyProduct.titleUk, 'Logic Балансуючий тонер');
        expect(
          storefrontOnlyProduct.externalProductUrl,
          'https://aloe-hub.flpuretail.com/uk/catalog/product/280/',
        );

        expect(
          seedProducts.any((item) => item.id == 'storefront-8154'),
          isTrue,
        );
        expect(
          seedProducts.any((item) => item.id == 'forever-freedom'),
          isFalse,
        );
      },
    );
  });
}
