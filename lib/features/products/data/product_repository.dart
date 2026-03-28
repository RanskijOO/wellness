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
      return seedCategories;
    }

    try {
      final List<dynamic> rows = await _supabaseClient
          .from('product_categories')
          .select('id, title_uk, title_en, subtitle_uk, subtitle_en, icon_key');
      return rows
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
          .toList();
    } catch (_) {
      return seedCategories;
    }
  }

  Future<List<Product>> fetchProducts() async {
    if (_supabaseClient == null) {
      return seedProducts;
    }

    try {
      final List<dynamic> rows = await _supabaseClient
          .from('products')
          .select(
            'id, category_id, title_uk, title_en, short_description_uk, short_description_en, usage_notes_uk, usage_notes_en, caution_notes_uk, caution_notes_en, image_token, external_product_url, highlight_uk, highlight_en, is_featured, wellness_tags',
          );

      return rows
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
          .toList();
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

    if (progress != null) {
      if (progress.averageWaterMl > 0 &&
          progress.averageWaterMl < (profile.hydrationTargetMl * 0.7).round()) {
        desiredTags.addAll(<String>{'hydration', 'aloe', 'combo'});
      }

      if (progress.averageSleepHours > 0 &&
          progress.averageSleepHours + 0.4 < profile.sleepTargetHours) {
        desiredTags.addAll(<String>{'self-care', 'balance', 'beauty'});
      }

      if (progress.averageMoodScore > 0 && progress.averageMoodScore < 3.0) {
        desiredTags.addAll(<String>{'self-care', 'balance'});
      }

      if (progress.logs.isNotEmpty && progress.currentStreak <= 1) {
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
        final int aScore = (aTagMatches * 3) + (a.isFeatured ? 2 : 0);
        final int bScore = (bTagMatches * 3) + (b.isFeatured ? 2 : 0);
        return bScore.compareTo(aScore);
      });

    return sorted.take(6).toList();
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
}
