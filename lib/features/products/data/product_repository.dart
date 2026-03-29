import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/content/seed_catalog.dart';
import '../../profile/domain/profile_models.dart';
import '../../trackers/domain/tracker_models.dart';
import '../domain/product_models.dart';

class ProductRepository {
  ProductRepository({
    required SharedPreferences preferences,
    SupabaseClient? supabaseClient,
  }) : _preferences = preferences,
       _supabaseClient = supabaseClient;

  static const String outboundClicksKey = 'outbound_clicks_v1';

  final SharedPreferences _preferences;
  final SupabaseClient? _supabaseClient;

  Future<List<ProductCategory>> fetchCategories() async {
    if (_supabaseClient == null) {
      return availableSeedCategories;
    }

    try {
      final Set<String> supportedCategoryIds = availableSeedCategories
          .map((ProductCategory item) => item.id)
          .toSet();
      final List<dynamic> rows = await _supabaseClient
          .from('product_categories')
          .select('id, title_uk, title_en, subtitle_uk, subtitle_en, icon_key');
      final List<ProductCategory> remoteCategories = rows
          .map(
            (dynamic row) => ProductCategory(
              id: (row as Map<dynamic, dynamic>)['id'].toString(),
              titleUk: row['title_uk'].toString(),
              titleEn: row['title_en']?.toString(),
              subtitleUk: row['subtitle_uk'].toString(),
              subtitleEn: row['subtitle_en']?.toString(),
              iconKey: row['icon_key'].toString(),
            ),
          )
          .where(
            (ProductCategory item) => supportedCategoryIds.contains(item.id),
          )
          .toList();
      return _mergeCategories(remoteCategories);
    } catch (_) {
      return availableSeedCategories;
    }
  }

  Future<List<Product>> fetchProducts() async {
    if (_supabaseClient == null) {
      return seedProducts;
    }

    try {
      final Set<String> supportedCategoryIds = availableSeedCategories
          .map((ProductCategory item) => item.id)
          .toSet();
      final Set<String> supportedProductIds = seedProducts
          .map((Product item) => item.id)
          .toSet();
      final List<dynamic> rows = await _supabaseClient
          .from('products')
          .select(
            'id, category_id, title_uk, title_en, short_description_uk, short_description_en, usage_notes_uk, usage_notes_en, caution_notes_uk, caution_notes_en, image_token, external_product_url, highlight_uk, highlight_en, is_featured, wellness_tags',
          );

      final List<Product> remoteProducts = rows
          .map(
            (dynamic row) => Product(
              id: (row as Map<dynamic, dynamic>)['id'].toString(),
              categoryId: row['category_id'].toString(),
              titleUk: row['title_uk'].toString(),
              titleEn: row['title_en']?.toString(),
              shortDescriptionUk: row['short_description_uk'].toString(),
              shortDescriptionEn: row['short_description_en']?.toString(),
              usageNotesUk: row['usage_notes_uk'].toString(),
              usageNotesEn: row['usage_notes_en']?.toString(),
              cautionNotesUk: row['caution_notes_uk'].toString(),
              cautionNotesEn: row['caution_notes_en']?.toString(),
              imageToken: row['image_token'].toString(),
              externalProductUrl: row['external_product_url'].toString(),
              highlightUk: row['highlight_uk'].toString(),
              highlightEn: row['highlight_en']?.toString(),
              isFeatured: row['is_featured'] as bool? ?? false,
              wellnessTags:
                  (row['wellness_tags'] as List<dynamic>? ?? <dynamic>[])
                      .map((dynamic item) => item.toString())
                      .toList(),
            ),
          )
          .where(
            (Product item) =>
                supportedCategoryIds.contains(item.categoryId) &&
                supportedProductIds.contains(item.id) &&
                !legacyCatalogProductIds.contains(item.id),
          )
          .toList();
      return _mergeProducts(remoteProducts);
    } catch (_) {
      return seedProducts;
    }
  }

  List<Product> recommendProducts({
    required UserProfile profile,
    required List<Product> products,
    ProgressSnapshot? progress,
  }) {
    final Set<String> desiredTags = profile.goalIds
        .expand((item) => item.productTags)
        .toSet();
    final bool needsHydrationSupport =
        progress != null &&
        progress.averageWaterMl > 0 &&
        progress.averageWaterMl < (profile.hydrationTargetMl * 0.7).round();
    final bool needsSleepSupport =
        progress != null &&
        progress.averageSleepHours > 0 &&
        progress.averageSleepHours + 0.4 < profile.sleepTargetHours;
    final bool needsMoodSupport =
        progress != null &&
        progress.averageMoodScore > 0 &&
        progress.averageMoodScore < 3.0;
    final bool needsConsistencySupport =
        progress != null &&
        progress.logs.isNotEmpty &&
        progress.currentStreak <= 1;

    if (progress != null) {
      if (needsHydrationSupport) {
        desiredTags.addAll(<String>{'hydration', 'aloe', 'combo'});
      }

      if (needsSleepSupport) {
        desiredTags.addAll(<String>{'self-care', 'balance', 'beauty'});
      }

      if (needsMoodSupport) {
        desiredTags.addAll(<String>{'self-care', 'balance'});
      }

      if (needsConsistencySupport) {
        desiredTags.addAll(<String>{'combo', 'daily-routine', 'self-care'});
      }
    }

    final List<Product> sorted = List<Product>.from(products)
      ..sort((Product a, Product b) {
        final int aTagMatches = a.wellnessTags
            .where(desiredTags.contains)
            .length;
        final int bTagMatches = b.wellnessTags
            .where(desiredTags.contains)
            .length;
        final int aScore =
            (aTagMatches * 3) +
            (a.isFeatured ? 2 : 0) +
            _contextualRecommendationBonus(
              a,
              needsHydrationSupport: needsHydrationSupport,
              needsSleepSupport: needsSleepSupport,
              needsMoodSupport: needsMoodSupport,
              needsConsistencySupport: needsConsistencySupport,
            );
        final int bScore =
            (bTagMatches * 3) +
            (b.isFeatured ? 2 : 0) +
            _contextualRecommendationBonus(
              b,
              needsHydrationSupport: needsHydrationSupport,
              needsSleepSupport: needsSleepSupport,
              needsMoodSupport: needsMoodSupport,
              needsConsistencySupport: needsConsistencySupport,
            );
        return bScore.compareTo(aScore);
      });

    return sorted.take(6).toList();
  }

  int _contextualRecommendationBonus(
    Product product, {
    required bool needsHydrationSupport,
    required bool needsSleepSupport,
    required bool needsMoodSupport,
    required bool needsConsistencySupport,
  }) {
    int score = 0;

    if (needsHydrationSupport &&
        (product.wellnessTags.contains('hydration') ||
            product.wellnessTags.contains('aloe'))) {
      score += 5;
    }

    if (needsSleepSupport &&
        (product.wellnessTags.contains('self-care') ||
            product.wellnessTags.contains('beauty'))) {
      score += 2;
    }

    if (needsMoodSupport && product.wellnessTags.contains('balance')) {
      score += 2;
    }

    if (needsConsistencySupport &&
        (product.wellnessTags.contains('combo') ||
            product.wellnessTags.contains('daily-routine'))) {
      score += 3;
    }

    return score;
  }

  Future<void> recordOutboundClick({
    required Product product,
    required String userId,
    required String destinationUrl,
    required String source,
  }) async {
    final List<Map<String, dynamic>> existing = _readClickCache();
    existing.add(<String, dynamic>{
      'product_id': product.id,
      'user_id': userId,
      'destination_url': destinationUrl,
      'source': source,
      'created_at': DateTime.now().toIso8601String(),
    });
    await _preferences.setString(outboundClicksKey, jsonEncode(existing));

    if (_supabaseClient == null) {
      return;
    }

    try {
      await _supabaseClient.from('outbound_clicks').insert(<String, dynamic>{
        'product_id': product.id,
        'user_id': userId,
        'destination_url': destinationUrl,
        'source': source,
      });
    } catch (_) {
      // Keep the local cache for a future sync pass.
    }
  }

  List<Map<String, dynamic>> _readClickCache() {
    final String? raw = _preferences.getString(outboundClicksKey);
    if (raw == null || raw.isEmpty) {
      return <Map<String, dynamic>>[];
    }

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((dynamic item) => item as Map<String, dynamic>).toList();
  }

  List<ProductCategory> _mergeCategories(
    List<ProductCategory> remoteCategories,
  ) {
    final Map<String, ProductCategory> merged = <String, ProductCategory>{
      for (final ProductCategory item in availableSeedCategories) item.id: item,
      for (final ProductCategory item in remoteCategories) item.id: item,
    };

    final List<String> seedIds = availableSeedCategories
        .map((ProductCategory item) => item.id)
        .toList(growable: false);
    final Set<String> knownIds = seedIds.toSet();
    final List<String> orderedIds = <String>[
      ...seedIds,
      ...remoteCategories
          .map((ProductCategory item) => item.id)
          .where((String id) => !knownIds.contains(id)),
    ];

    return orderedIds.map((String id) => merged[id]!).toList(growable: false);
  }

  List<Product> _mergeProducts(List<Product> remoteProducts) {
    final Map<String, Product> merged = <String, Product>{
      for (final Product item in seedProducts) item.id: item,
      for (final Product item in remoteProducts) item.id: item,
    };

    final List<String> seedIds = seedProducts
        .map((Product item) => item.id)
        .toList(growable: false);
    final Set<String> knownIds = seedIds.toSet();
    final List<String> orderedIds = <String>[
      ...seedIds,
      ...remoteProducts
          .map((Product item) => item.id)
          .where((String id) => !knownIds.contains(id)),
    ];

    return orderedIds.map((String id) => merged[id]!).toList(growable: false);
  }
}
