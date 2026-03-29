const String defaultShopBaseUrl = 'https://aloe-hub.flpuretail.com/uk/';

const Set<String> _legacyForeverHosts = <String>{
  'foreverliving.com',
  'www.foreverliving.com',
};

String normalizeShopBaseUrl(String rawUrl) {
  final String trimmed = rawUrl.trim();
  if (trimmed.isEmpty) {
    return defaultShopBaseUrl;
  }

  final Uri? uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme) {
    return defaultShopBaseUrl;
  }

  if (_legacyForeverHosts.contains(uri.host.toLowerCase())) {
    return defaultShopBaseUrl;
  }

  if (uri.host.toLowerCase() == 'aloe-hub.flpuretail.com' &&
      (uri.path.isEmpty || uri.path == '/')) {
    return defaultShopBaseUrl;
  }

  if (trimmed.endsWith('/en') || trimmed.endsWith('/uk')) {
    return '$trimmed/';
  }

  return trimmed;
}

String resolveProductDestinationUrl({
  required String productUrl,
  required String shopBaseUrl,
}) {
  final String normalizedShopBaseUrl = normalizeShopBaseUrl(shopBaseUrl);
  final String trimmedProductUrl = productUrl.trim();

  if (trimmedProductUrl.isEmpty) {
    return normalizedShopBaseUrl;
  }

  final Uri? uri = Uri.tryParse(trimmedProductUrl);
  if (uri == null || !uri.hasScheme) {
    return normalizedShopBaseUrl;
  }

  if (_legacyForeverHosts.contains(uri.host.toLowerCase())) {
    return normalizedShopBaseUrl;
  }

  return trimmedProductUrl;
}
