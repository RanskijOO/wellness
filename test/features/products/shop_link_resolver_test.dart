import 'package:aloe_wellness_coach/core/utils/shop_link_resolver.dart';
import 'package:aloe_wellness_coach/features/products/presentation/product_webview_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shop link resolver', () {
    test(
      'normalizes empty and legacy shop URLs to Aloe Hub Ukrainian route',
      () {
        expect(normalizeShopBaseUrl(''), defaultShopBaseUrl);
        expect(
          normalizeShopBaseUrl('https://www.foreverliving.com/'),
          defaultShopBaseUrl,
        );
        expect(
          normalizeShopBaseUrl('https://aloe-hub.flpuretail.com'),
          defaultShopBaseUrl,
        );
      },
    );

    test('replaces legacy product links with the configured shop base URL', () {
      expect(
        resolveProductDestinationUrl(
          productUrl: 'https://www.foreverliving.com/',
          shopBaseUrl: 'https://aloe-hub.flpuretail.com',
        ),
        defaultShopBaseUrl,
      );
      expect(
        resolveProductDestinationUrl(
          productUrl: '',
          shopBaseUrl: 'https://aloe-hub.flpuretail.com/uk/',
        ),
        defaultShopBaseUrl,
      );
      expect(
        resolveProductDestinationUrl(
          productUrl: 'https://aloe-hub.flpuretail.com/uk/some-page',
          shopBaseUrl: defaultShopBaseUrl,
        ),
        'https://aloe-hub.flpuretail.com/uk/some-page',
      );
    });
  });

  group('webview error overlay', () {
    test('shows blocking state only for main frame failures', () {
      expect(shouldShowWebViewErrorOverlay(true), isTrue);
      expect(shouldShowWebViewErrorOverlay(null), isTrue);
      expect(shouldShowWebViewErrorOverlay(false), isFalse);
    });
  });
}
