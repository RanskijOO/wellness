import '../../features/goals/domain/wellness_goal.dart';
import '../../features/products/domain/product_models.dart';
import '../../features/profile/domain/profile_models.dart';
import 'storefront_catalog.dart';

const Set<String> legacyCatalogProductIds = <String>{
  'aloe-gel-classic',
  'aloe-berry-balance',
  'daily-shake-vanilla',
  'fiber-routine-mix',
  'bee-pollen-daily',
  'propolis-soft-support',
  'aloe-hydra-cream',
  'aloe-soothing-gelly',
  'aloe-body-cleanse',
  'fresh-smile-gel',
  'aloe-reset-pack',
  'aloe-glow-pack',
};

const List<ProductCategory> seedCategories = <ProductCategory>[
  ProductCategory(
    id: 'aloe_drinks',
    titleUk: 'Напої з Aloe',
    subtitleUk:
        'Aloe-гель, функціональні напої та travel-формати для щоденного ритму.',
    iconKey: 'water_drop',
    titleEn: 'Aloe drinks',
    subtitleEn:
        'Aloe gels, functional drinks, and portable formats for a steady routine.',
  ),
  ProductCategory(
    id: 'bee_products',
    titleUk: 'Bee-продукти',
    subtitleUk:
        'Мед, пилок, прополіс і маточне молочко для загальної wellness-рутини.',
    iconKey: 'hive',
    titleEn: 'Bee products',
    subtitleEn:
        'Honey, pollen, propolis, and royal jelly for a general wellness routine.',
  ),
  ProductCategory(
    id: 'combo_packs',
    titleUk: 'Набори та програми',
    subtitleUk:
        'Комбо-набори, програми та стартові рішення з Aloe Hub каталогу.',
    iconKey: 'pack',
    titleEn: 'Combo packs',
    subtitleEn:
        'Combo packs, programs, and starter solutions from the Aloe Hub catalog.',
  ),
  ProductCategory(
    id: 'supplements',
    titleUk: 'Харчові добавки',
    subtitleUk:
        'Daily wellness-support формати для харчування, енергії та послідовності.',
    iconKey: 'nutrition',
    titleEn: 'Supplements',
    subtitleEn:
        'Daily wellness-support formats for nutrition, energy, and consistency.',
  ),
  ProductCategory(
    id: 'skincare',
    titleUk: 'Догляд за шкірою',
    subtitleUk:
        'Aloe-first креми, сироватки, тонери та спеціалізований догляд.',
    iconKey: 'spa',
    titleEn: 'Skincare',
    subtitleEn: 'Aloe-first creams, serums, toners, and targeted care.',
  ),
  ProductCategory(
    id: 'personal_care',
    titleUk: 'Особиста гігієна',
    subtitleUk:
        'Щоденні продукти для чистоти, свіжості та комфортної self-care рутини.',
    iconKey: 'self_improvement',
    titleEn: 'Personal care',
    subtitleEn: 'Daily essentials for freshness, hygiene, and self-care.',
  ),
  ProductCategory(
    id: 'body_care',
    titleUk: 'Догляд за тілом',
    subtitleUk:
        'Body-care продукти для душу, тонусу та м’якого відчуття комфорту.',
    iconKey: 'body',
    titleEn: 'Body care',
    subtitleEn: 'Body-care products for shower rituals, toning, and comfort.',
  ),
  ProductCategory(
    id: 'hair_care',
    titleUk: 'Догляд за волоссям',
    subtitleUk: 'Шампуні та кондиціонери для щоденного догляду за волоссям.',
    iconKey: 'hair',
    titleEn: 'Hair care',
    subtitleEn: 'Shampoos and conditioners for everyday hair care.',
  ),
  ProductCategory(
    id: 'home_care',
    titleUk: 'Догляд за домом',
    subtitleUk: 'Практичні рішення для побутової рутини та чистоти.',
    iconKey: 'home',
    titleEn: 'Home care',
    subtitleEn: 'Practical solutions for cleaning and daily home routines.',
  ),
  ProductCategory(
    id: 'fragrances',
    titleUk: 'Аромати',
    subtitleUk: 'Легкі жіночі та чоловічі аромати для завершення образу.',
    iconKey: 'fragrance',
    titleEn: 'Fragrances',
    subtitleEn:
        'Light feminine and masculine fragrances for the finishing touch.',
  ),
];

const Map<String, List<String>> _defaultCategoryTags = <String, List<String>>{
  'aloe_drinks': <String>['hydration', 'aloe', 'daily-routine'],
  'bee_products': <String>['bee', 'balance', 'daily-routine'],
  'combo_packs': <String>['combo', 'daily-routine', 'self-care'],
  'supplements': <String>['nutrition', 'balance', 'energy'],
  'skincare': <String>['beauty', 'skin', 'self-care'],
  'personal_care': <String>['self-care', 'daily-routine', 'beauty'],
  'body_care': <String>['self-care', 'beauty', 'daily-routine'],
  'hair_care': <String>['self-care', 'beauty', 'balance'],
  'home_care': <String>['daily-routine', 'balance'],
  'fragrances': <String>['self-care', 'beauty'],
};

const Map<String, String> _defaultCategoryHighlights = <String, String>{
  'aloe_drinks': 'Напій для aloe-first рутини',
  'bee_products': 'Bee-підтримка щоденного ритму',
  'combo_packs': 'Готовий набір для структурованої рутини',
  'supplements': 'Доповнення до daily wellness-плану',
  'skincare': 'Щоденний догляд за шкірою',
  'personal_care': 'Основа щоденної гігієни',
  'body_care': 'Body-care ритуал без зайвого тиску',
  'hair_care': 'Hair-care підтримка на щодень',
  'home_care': 'Практичний формат для дому',
  'fragrances': 'Ароматний штрих до образу',
};

const Map<String, String> _defaultCategoryUsageNotes = <String, String>{
  'aloe_drinks':
      'Використовуйте як частину збалансованої daily wellness-рутини разом із водою та комфортним режимом дня.',
  'bee_products':
      'Додавайте до загальної wellness-рутини поступово та з урахуванням персональної переносимості інгредієнтів.',
  'combo_packs':
      'Обирайте як структурований wellness-формат для старту або перезапуску щоденної рутини без медичних очікувань.',
  'supplements':
      'Розглядайте як доповнення до харчування, сну, руху та базових щоденних звичок.',
  'skincare':
      'Наносьте у межах регулярного догляду за шкірою та послідовного self-care ритуалу.',
  'personal_care':
      'Використовуйте у щоденній ранковій або вечірній рутині догляду за собою.',
  'body_care':
      'Поєднуйте з базовими body-care звичками та комфортним темпом дня.',
  'hair_care':
      'Застосовуйте як частину регулярного догляду за волоссям і шкірою голови.',
  'home_care':
      'Використовуйте лише за побутовим призначенням і за інструкцією виробника.',
  'fragrances':
      'Наносьте помірно як завершальний ароматний штрих до щоденного образу.',
};

const Map<String, String> _defaultCategoryCautionNotes = <String, String>{
  'aloe_drinks':
      'Це wellness-продукт, а не медичний засіб. Перевіряйте склад і персональну переносимість.',
  'bee_products':
      'Містить або може містити компоненти бджільництва. Якщо є чутливість або алергії, потрібна додаткова обережність.',
  'combo_packs':
      'Набори поєднують кілька wellness-продуктів. Перевіряйте склад кожної позиції та обирайте формат, який підходить саме вам.',
  'supplements':
      'Не замінює індивідуальний план харчування або професійну медичну консультацію. Перевіряйте склад перед використанням.',
  'skincare':
      'Для зовнішнього використання, якщо інше не вказано виробником. Перед регулярним використанням перевіряйте індивідуальну чутливість.',
  'personal_care':
      'Використовуйте за інструкцією виробника. У разі подразнення припиніть використання та зверніться до фахівця.',
  'body_care':
      'Лише для зовнішнього використання. У разі подразнення або дискомфорту припиніть використання.',
  'hair_care':
      'Уникайте контакту з очима та не використовуйте за наявності вираженої індивідуальної чутливості.',
  'home_care':
      'Використовуйте тільки за призначенням і тримайте подалі від дітей.',
  'fragrances':
      'Тільки для зовнішнього використання. Не наносіть на чутливі ділянки шкіри без попередньої перевірки.',
};

const Map<String, String> _defaultCategoryImageTokens = <String, String>{
  'aloe_drinks': 'aloe',
  'bee_products': 'bee',
  'combo_packs': 'pack',
  'supplements': 'shake',
  'skincare': 'cream',
  'personal_care': 'smile',
  'body_care': 'body',
  'hair_care': 'hair',
  'home_care': 'home',
  'fragrances': 'fragrance',
};

class _SeedProductSeed {
  const _SeedProductSeed({
    required this.id,
    required this.catalogNumber,
    required this.categoryId,
    required this.titleUk,
    this.wellnessTags,
    this.imageToken,
    this.isFeatured = false,
    this.highlightUk,
    this.shortDescriptionUk,
  });

  final String id;
  final String catalogNumber;
  final String categoryId;
  final String titleUk;
  final List<String>? wellnessTags;
  final String? imageToken;
  final bool isFeatured;
  final String? highlightUk;
  final String? shortDescriptionUk;
}

const Map<String, String> _storefrontAliasCodeBySeedId = <String, String>{
  'aloe-vera-gel': '815',
  'aloe-berry-nectar': '834',
  'aloe-bits-n-peaches': '877',
  'forever-active-probiotic': '610',
  'forever-vision': '624',
  'mask-powder': '652',
  'aloe-activator': '612',
  'forever-alluring-eyes': '561',
  'aloe-deep-moisturizing-cream': '651',
  'aloe-liquid-soap': '633',
  'aloe-jojoba-shampoo': '640',
  'aloe-jojoba-conditioning-rinse': '641',
};

String _normalizeCatalogCode(String value) {
  final String cleaned = value.toUpperCase().replaceAll(
    RegExp(r'[^A-Z0-9]'),
    '',
  );
  if (cleaned.isEmpty) {
    return cleaned;
  }

  final String normalized = cleaned.replaceFirst(RegExp(r'^0+(?=[1-9])'), '');
  return normalized.isEmpty ? cleaned : normalized;
}

final Map<String, StorefrontCatalogEntry> _storefrontEntryByCode =
    <String, StorefrontCatalogEntry>{
      for (final StorefrontCatalogEntry entry in storefrontCatalogEntries)
        _normalizeCatalogCode(entry.code): entry,
    };

String _resolveStorefrontCategoryId(StorefrontCatalogEntry entry) {
  switch (entry.categoryPath) {
    case '/uk/catalog/category/aloe-drinks/':
      return 'aloe_drinks';
    case '/uk/catalog/category/bee-products/':
      return 'bee_products';
    case '/uk/catalog/category/combo-packs/':
      return 'combo_packs';
    case '/uk/catalog/category/nutrition/':
      return 'supplements';
    case '/uk/catalog/category/skincare/':
      return 'skincare';
    case '/uk/catalog/category/personal-care/':
      return _resolveStorefrontPersonalCareCategoryId(entry);
  }

  return 'supplements';
}

String _resolveStorefrontPersonalCareCategoryId(StorefrontCatalogEntry entry) {
  final String title = entry.titleUk.toLowerCase();

  if (entry.code == '040' || title.contains('фьорст')) {
    return 'aloe_drinks';
  }

  if (title.contains('шампун') ||
      title.contains('кондиціон') ||
      title.contains('волос')) {
    return 'hair_care';
  }

  if (title.contains('алофа') ||
      title.contains('малосі') ||
      title.contains('аромат')) {
    return 'fragrances';
  }

  if (title.contains('лосьйон для тіла') ||
      title.contains('гель для душу') ||
      title.contains('охолоджуючий лосьйон')) {
    return 'body_care';
  }

  return 'personal_care';
}

StorefrontCatalogEntry? _matchSeedToStorefrontEntry(_SeedProductSeed seed) {
  final String? aliasCode = _storefrontAliasCodeBySeedId[seed.id];
  final String lookupCode = aliasCode ?? seed.catalogNumber;
  return _storefrontEntryByCode[_normalizeCatalogCode(lookupCode)];
}

String _resolveStorefrontImageToken({
  required StorefrontCatalogEntry entry,
  required String categoryId,
}) {
  final String title = entry.titleUk.toLowerCase();

  if (categoryId == 'aloe_drinks') {
    if (title.contains('ягід') ||
        title.contains('персик') ||
        title.contains('манго') ||
        title.contains('fab')) {
      return 'berry';
    }
    return 'aloe';
  }

  if (categoryId == 'skincare' &&
      (title.contains('сироват') ||
          title.contains('маска') ||
          title.contains('тонер'))) {
    return 'glow';
  }

  return _defaultCategoryImageTokens[categoryId]!;
}

String _buildShortDescription(
  String categoryId,
  String titleUk,
) => switch (categoryId) {
  'aloe_drinks' =>
    '$titleUk для щоденного водного ритму та aloe-first wellness-звичок.',
  'bee_products' =>
    '$titleUk як частина загальної wellness-рутини без медичних обіцянок.',
  'combo_packs' =>
    '$titleUk як готовий wellness-набір для структурованого старту або перезапуску рутини.',
  'supplements' =>
    '$titleUk для щоденної nutrient-focused wellness-підтримки та структурованого ритму.',
  'skincare' =>
    '$titleUk для щоденного догляду за шкірою і м’якого self-care ритуалу.',
  'personal_care' =>
    '$titleUk для стабільного щоденного ритуалу особистої гігієни.',
  'body_care' =>
    '$titleUk для щоденного догляду за тілом і комфортного body-care ритуалу.',
  'hair_care' =>
    '$titleUk для щоденного догляду за волоссям та акуратного scalp-care ритму.',
  'home_care' =>
    '$titleUk для домашньої рутини та чистоти без зайвої складності.',
  'fragrances' =>
    '$titleUk для завершення образу легким wellness-inspired ароматним акцентом.',
  _ => '$titleUk для щоденної wellness-рутини.',
};

String _resolveHighlightUk({
  required String categoryId,
  required String storefrontCode,
  String? enrichedHighlightUk,
}) {
  final String? customSuffix = enrichedHighlightUk?.split('•').last.trim();
  final String suffix = (customSuffix == null || customSuffix.isEmpty)
      ? _defaultCategoryHighlights[categoryId]!.trim()
      : customSuffix;
  return 'SKU $storefrontCode • $suffix';
}

Product _buildLiveCatalogProduct(StorefrontCatalogEntry entry) {
  final _SeedProductSeed? enrichedSeed =
      _enrichedSeedByStorefrontCode[_normalizeCatalogCode(entry.code)];
  final String categoryId =
      enrichedSeed?.categoryId ?? _resolveStorefrontCategoryId(entry);

  return Product(
    id:
        enrichedSeed?.id ??
        'storefront-${_normalizeCatalogCode(entry.code).toLowerCase()}',
    categoryId: categoryId,
    titleUk: entry.titleUk,
    titleEn: enrichedSeed?.titleUk,
    shortDescriptionUk:
        enrichedSeed?.shortDescriptionUk ??
        _buildShortDescription(categoryId, entry.titleUk),
    wellnessTags:
        enrichedSeed?.wellnessTags ?? _defaultCategoryTags[categoryId]!,
    usageNotesUk: _defaultCategoryUsageNotes[categoryId]!,
    cautionNotesUk: _defaultCategoryCautionNotes[categoryId]!,
    imageToken:
        enrichedSeed?.imageToken ??
        _resolveStorefrontImageToken(entry: entry, categoryId: categoryId),
    externalProductUrl: entry.url,
    highlightUk: _resolveHighlightUk(
      categoryId: categoryId,
      storefrontCode: entry.code,
      enrichedHighlightUk: enrichedSeed?.highlightUk,
    ),
    highlightEn: 'SKU ${entry.code}',
    isFeatured:
        enrichedSeed?.isFeatured ??
        categoryId == 'combo_packs' || categoryId == 'aloe_drinks',
  );
}

const List<_SeedProductSeed> _seedProductSeeds = <_SeedProductSeed>[
  _SeedProductSeed(
    id: 'aloe-vera-gel',
    catalogNumber: '15',
    categoryId: 'aloe_drinks',
    titleUk: 'Aloe Vera Gel',
    imageToken: 'aloe',
    isFeatured: true,
    wellnessTags: <String>['hydration', 'aloe', 'daily-routine'],
    shortDescriptionUk:
        'Класичний aloe-first напій для щоденного wellness-ритму та підтримки водного балансу.',
    highlightUk: 'SKU 15 • База для aloe-first рутини',
  ),
  _SeedProductSeed(
    id: 'aloe-berry-nectar',
    catalogNumber: '34',
    categoryId: 'aloe_drinks',
    titleUk: 'Aloe Berry Nectar',
    imageToken: 'berry',
    isFeatured: true,
    wellnessTags: <String>['hydration', 'aloe', 'beauty'],
    highlightUk: 'SKU 34 • Ягідний aloe-формат',
  ),
  _SeedProductSeed(
    id: 'aloe-bits-n-peaches',
    catalogNumber: '77',
    categoryId: 'aloe_drinks',
    titleUk: "Aloe Bits N'Peaches",
    imageToken: 'berry',
    wellnessTags: <String>['hydration', 'aloe', 'beauty'],
  ),
  _SeedProductSeed(
    id: 'forever-freedom',
    catalogNumber: '196',
    categoryId: 'aloe_drinks',
    titleUk: 'Forever Freedom',
    imageToken: 'aloe',
    wellnessTags: <String>['hydration', 'balance', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'aloe-2-go',
    catalogNumber: '270',
    categoryId: 'aloe_drinks',
    titleUk: 'Aloe 2 Go',
    imageToken: 'aloe',
    wellnessTags: <String>['hydration', 'energy', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'joost-blueberry-acai-lemon',
    catalogNumber: '516',
    categoryId: 'aloe_drinks',
    titleUk: 'Joost Blueberry Acai Lemon',
    imageToken: 'berry',
    wellnessTags: <String>['energy', 'nutrition', 'daily-routine'],
    highlightUk: 'SKU 516 • Смак чорниці, асаї та лимона',
  ),
  _SeedProductSeed(
    id: 'joost-pineapple-coconut-ginger',
    catalogNumber: '517',
    categoryId: 'aloe_drinks',
    titleUk: 'Joost Pineapple Coconut Ginger',
    imageToken: 'berry',
    wellnessTags: <String>['energy', 'nutrition', 'daily-routine'],
    highlightUk: 'SKU 517 • Смак ананаса, кокосу та імбиру',
  ),
  _SeedProductSeed(
    id: 'freedom-2-go',
    catalogNumber: '306',
    categoryId: 'aloe_drinks',
    titleUk: 'Freedom 2 Go',
    imageToken: 'aloe',
    wellnessTags: <String>['balance', 'energy', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-pomesteen-power',
    catalogNumber: '262',
    categoryId: 'aloe_drinks',
    titleUk: 'Forever Pomesteen Power',
    imageToken: 'berry',
    wellnessTags: <String>['energy', 'nutrition', 'beauty'],
    highlightUk: 'SKU 262 • Фруктовий antioxidant-style формат',
  ),

  _SeedProductSeed(
    id: 'forever-bee-honey',
    catalogNumber: '207',
    categoryId: 'bee_products',
    titleUk: 'Forever Bee Honey',
    imageToken: 'bee',
    isFeatured: true,
    wellnessTags: <String>['bee', 'nutrition', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-bee-pollen',
    catalogNumber: '26',
    categoryId: 'bee_products',
    titleUk: 'Forever Bee Pollen',
    imageToken: 'bee',
    wellnessTags: <String>['bee', 'energy', 'nutrition'],
  ),
  _SeedProductSeed(
    id: 'forever-bee-propolis',
    catalogNumber: '27',
    categoryId: 'bee_products',
    titleUk: 'Forever Bee Propolis',
    imageToken: 'propolis',
    wellnessTags: <String>['bee', 'balance', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-royal-jelly',
    catalogNumber: '36',
    categoryId: 'bee_products',
    titleUk: 'Forever Royal Jelly',
    imageToken: 'bee',
    wellnessTags: <String>['bee', 'energy', 'balance'],
  ),

  _SeedProductSeed(
    id: 'forever-absorbent-c',
    catalogNumber: '48',
    categoryId: 'supplements',
    titleUk: 'Forever Absorbent C',
    wellnessTags: <String>['nutrition', 'balance', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-daily',
    catalogNumber: '439',
    categoryId: 'supplements',
    titleUk: 'Forever Daily',
    isFeatured: true,
    wellnessTags: <String>['nutrition', 'balance', 'daily-routine'],
    highlightUk: 'SKU 439 • Daily базова підтримка',
  ),
  _SeedProductSeed(
    id: 'nature-min',
    catalogNumber: '37',
    categoryId: 'supplements',
    titleUk: 'Nature-Min',
    wellnessTags: <String>['nutrition', 'balance', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-kids',
    catalogNumber: '354',
    categoryId: 'supplements',
    titleUk: 'Forever Kids',
    wellnessTags: <String>['nutrition', 'balance', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-gin-chia',
    catalogNumber: '47',
    categoryId: 'supplements',
    titleUk: 'Forever Gin-Chia',
    wellnessTags: <String>['energy', 'focus', 'nutrition'],
  ),
  _SeedProductSeed(
    id: 'forever-arctic-sea',
    catalogNumber: '376',
    categoryId: 'supplements',
    titleUk: 'Forever Arctic Sea',
    wellnessTags: <String>['nutrition', 'balance', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'aloe-blossom-herbal-tea',
    catalogNumber: '200',
    categoryId: 'supplements',
    titleUk: 'Aloe Blossom Herbal Tea',
    imageToken: 'fiber',
    wellnessTags: <String>['hydration', 'balance', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-ginkgo-plus',
    catalogNumber: '73',
    categoryId: 'supplements',
    titleUk: 'Forever Ginkgo Plus',
    wellnessTags: <String>['focus', 'energy', 'balance'],
  ),
  _SeedProductSeed(
    id: 'forever-active-probiotic',
    catalogNumber: '222',
    categoryId: 'supplements',
    titleUk: 'Forever Active Probiotic',
    wellnessTags: <String>['balance', 'nutrition', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-garlic-thyme',
    catalogNumber: '65',
    categoryId: 'supplements',
    titleUk: 'Forever Garlic-Thyme',
    wellnessTags: <String>['balance', 'nutrition', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-a-beta-care',
    catalogNumber: '54',
    categoryId: 'supplements',
    titleUk: 'Forever A-Beta-Care',
    wellnessTags: <String>['nutrition', 'beauty', 'balance'],
  ),
  _SeedProductSeed(
    id: 'forever-calcium',
    catalogNumber: '206',
    categoryId: 'supplements',
    titleUk: 'Forever Calcium',
    wellnessTags: <String>['nutrition', 'balance', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-b12-plus',
    catalogNumber: '188',
    categoryId: 'supplements',
    titleUk: 'Forever B12 Plus',
    wellnessTags: <String>['energy', 'focus', 'nutrition'],
  ),
  _SeedProductSeed(
    id: 'forever-multi-maca',
    catalogNumber: '215',
    categoryId: 'supplements',
    titleUk: 'Forever Multi-Maca',
    wellnessTags: <String>['energy', 'nutrition', 'balance'],
  ),
  _SeedProductSeed(
    id: 'forever-lite-ultra-vanilla',
    catalogNumber: '470',
    categoryId: 'supplements',
    titleUk: 'Forever Lite Ultra Vanilla',
    imageToken: 'shake',
    isFeatured: true,
    wellnessTags: <String>['nutrition', 'energy', 'healthy-routine'],
    highlightUk: 'SKU 470 • Ванільний shake-формат',
  ),
  _SeedProductSeed(
    id: 'forever-lite-ultra-chocolate',
    catalogNumber: '471',
    categoryId: 'supplements',
    titleUk: 'Forever Lite Ultra Chocolate',
    imageToken: 'shake',
    wellnessTags: <String>['nutrition', 'energy', 'healthy-routine'],
    highlightUk: 'SKU 471 • Шоколадний shake-формат',
  ),
  _SeedProductSeed(
    id: 'forever-garcinia-plus',
    catalogNumber: '71',
    categoryId: 'supplements',
    titleUk: 'Forever Garcinia Plus',
    wellnessTags: <String>['healthy-routine', 'balance', 'nutrition'],
  ),
  _SeedProductSeed(
    id: 'forever-vision',
    catalogNumber: '235',
    categoryId: 'supplements',
    titleUk: 'Forever Vision',
    wellnessTags: <String>['focus', 'balance', 'nutrition'],
  ),
  _SeedProductSeed(
    id: 'forever-active-ha',
    catalogNumber: '264',
    categoryId: 'supplements',
    titleUk: 'Forever Active HA',
    wellnessTags: <String>['balance', 'self-care', 'nutrition'],
  ),
  _SeedProductSeed(
    id: 'forever-lean',
    catalogNumber: '289',
    categoryId: 'supplements',
    titleUk: 'Forever Lean',
    wellnessTags: <String>['healthy-routine', 'nutrition', 'energy'],
  ),
  _SeedProductSeed(
    id: 'cardio-health',
    catalogNumber: '312',
    categoryId: 'supplements',
    titleUk: 'Cardio Health',
    wellnessTags: <String>['balance', 'energy', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'forever-argi-plus',
    catalogNumber: '473',
    categoryId: 'supplements',
    titleUk: 'Forever ARGI+',
    wellnessTags: <String>['energy', 'focus', 'nutrition'],
  ),
  _SeedProductSeed(
    id: 'forever-immublend',
    catalogNumber: '355',
    categoryId: 'supplements',
    titleUk: 'Forever ImmuBlend',
    wellnessTags: <String>['balance', 'nutrition', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'vitolize-men',
    catalogNumber: '374',
    categoryId: 'supplements',
    titleUk: 'Vitolize Men',
    wellnessTags: <String>['balance', 'self-care', 'nutrition'],
  ),
  _SeedProductSeed(
    id: 'vitolize-women',
    catalogNumber: '375',
    categoryId: 'supplements',
    titleUk: 'Vitolize Women',
    wellnessTags: <String>['balance', 'self-care', 'beauty'],
  ),

  _SeedProductSeed(
    id: 'aloe-fleur-de-jouvence',
    catalogNumber: '337',
    categoryId: 'skincare',
    titleUk: 'Aloe Fleur de Jouvence',
    imageToken: 'glow',
    isFeatured: true,
  ),
  _SeedProductSeed(
    id: 'rehydrating-toner',
    catalogNumber: '338',
    categoryId: 'skincare',
    titleUk: 'Rehydrating Toner',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'exfoliating-cleanser',
    catalogNumber: '339',
    categoryId: 'skincare',
    titleUk: 'Exfoliating Cleanser',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'firming-day-lotion',
    catalogNumber: '340',
    categoryId: 'skincare',
    titleUk: 'Firming Day Lotion',
    imageToken: 'cream',
  ),
  _SeedProductSeed(
    id: 'mask-powder',
    catalogNumber: '341',
    categoryId: 'skincare',
    titleUk: 'Mask Powder',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'recovering-night-creme',
    catalogNumber: '342',
    categoryId: 'skincare',
    titleUk: 'Recovering Night Creme',
    imageToken: 'cream',
  ),
  _SeedProductSeed(
    id: 'aloe-activator',
    catalogNumber: '343',
    categoryId: 'skincare',
    titleUk: 'Aloe Activator',
    imageToken: 'aloe',
  ),
  _SeedProductSeed(
    id: 'aloe-first',
    catalogNumber: '40',
    categoryId: 'skincare',
    titleUk: 'Aloe First',
    imageToken: 'aloe',
    wellnessTags: <String>['self-care', 'skin', 'balance'],
  ),
  _SeedProductSeed(
    id: 'aloe-propolis-creme',
    catalogNumber: '51',
    categoryId: 'skincare',
    titleUk: 'Aloe Propolis Creme',
    imageToken: 'cream',
    isFeatured: true,
  ),
  _SeedProductSeed(
    id: 'aloe-vera-gelly',
    catalogNumber: '61',
    categoryId: 'skincare',
    titleUk: 'Aloe Vera Gelly',
    imageToken: 'gelly',
    isFeatured: true,
  ),
  _SeedProductSeed(
    id: 'aloe-lotion',
    catalogNumber: '62',
    categoryId: 'skincare',
    titleUk: 'Aloe Lotion',
    imageToken: 'cream',
  ),
  _SeedProductSeed(
    id: 'aloe-moisturizing-lotion',
    catalogNumber: '63',
    categoryId: 'skincare',
    titleUk: 'Aloe Moisturizing Lotion',
    imageToken: 'cream',
    isFeatured: true,
  ),
  _SeedProductSeed(
    id: 'aloe-heat-lotion',
    catalogNumber: '64',
    categoryId: 'skincare',
    titleUk: 'Aloe Heat Lotion',
    imageToken: 'cream',
    wellnessTags: <String>['self-care', 'balance', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'r3-factor',
    catalogNumber: '69',
    categoryId: 'skincare',
    titleUk: 'R3 Factor',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'forever-alpha-e-factor',
    catalogNumber: '187',
    categoryId: 'skincare',
    titleUk: 'Forever Alpha-E Factor',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'aloe-msm-gel',
    catalogNumber: '205',
    categoryId: 'skincare',
    titleUk: 'Aloe MSM Gel',
    imageToken: 'gelly',
  ),
  _SeedProductSeed(
    id: 'forever-alluring-eyes',
    catalogNumber: '233',
    categoryId: 'skincare',
    titleUk: 'Forever Alluring Eyes',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'forever-marine-mask',
    catalogNumber: '234',
    categoryId: 'skincare',
    titleUk: 'Forever Marine Mask',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'forever-epiblanc',
    catalogNumber: '236',
    categoryId: 'skincare',
    titleUk: 'Forever Epiblanc',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'forever-aloe-scrub',
    catalogNumber: '238',
    categoryId: 'skincare',
    titleUk: 'Forever Aloe Scrub',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'aloe-sunscreen',
    catalogNumber: '199',
    categoryId: 'skincare',
    titleUk: 'Aloe Sunscreen',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'aloe-sunscreen-spray',
    catalogNumber: '319',
    categoryId: 'skincare',
    titleUk: 'Aloe Sunscreen Spray',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'gentlemans-pride',
    catalogNumber: '70',
    categoryId: 'skincare',
    titleUk: "Gentleman's Pride",
    imageToken: 'smile',
    wellnessTags: <String>['self-care', 'beauty', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'aloe-shave',
    catalogNumber: '515',
    categoryId: 'skincare',
    titleUk: 'Aloe Shave',
    imageToken: 'smile',
    wellnessTags: <String>['self-care', 'beauty', 'daily-routine'],
  ),
  _SeedProductSeed(
    id: 'sonya-skin-care-collection',
    catalogNumber: '282',
    categoryId: 'skincare',
    titleUk: 'Sonya Skin Care Collection',
    imageToken: 'glow',
    isFeatured: true,
  ),
  _SeedProductSeed(
    id: 'aloe-purifying-cleanser',
    catalogNumber: '277',
    categoryId: 'skincare',
    titleUk: 'Aloe Purifying Cleanser',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'aloe-deep-cleansing-exfoliator',
    catalogNumber: '278',
    categoryId: 'skincare',
    titleUk: 'Aloe Deep-Cleansing Exfoliator',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'aloe-refreshing-toner',
    catalogNumber: '279',
    categoryId: 'skincare',
    titleUk: 'Aloe Refreshing Toner',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'aloe-balancing-cream',
    catalogNumber: '280',
    categoryId: 'skincare',
    titleUk: 'Aloe Balancing Cream',
    imageToken: 'cream',
  ),
  _SeedProductSeed(
    id: 'aloe-nourishing-serum',
    catalogNumber: '281',
    categoryId: 'skincare',
    titleUk: 'Aloe Nourishing Serum',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'aloe-deep-moisturizing-cream',
    catalogNumber: '311',
    categoryId: 'skincare',
    titleUk: 'Aloe Deep Moisturizing Cream',
    imageToken: 'cream',
  ),

  _SeedProductSeed(
    id: 'aloe-lips',
    catalogNumber: '22',
    categoryId: 'personal_care',
    titleUk: 'Aloe Lips',
    imageToken: 'smile',
    isFeatured: true,
  ),
  _SeedProductSeed(
    id: 'forever-bright-toothgel',
    catalogNumber: '28',
    categoryId: 'personal_care',
    titleUk: 'Forever Bright Toothgel',
    imageToken: 'smile',
    isFeatured: true,
    highlightUk: 'SKU 28 • Щоденна oral-care рутина',
  ),
  _SeedProductSeed(
    id: 'aloe-liquid-soap',
    catalogNumber: '523',
    categoryId: 'personal_care',
    titleUk: 'Aloe Liquid Soap',
    imageToken: 'body',
  ),
  _SeedProductSeed(
    id: 'aloe-ever-shield-deodorant-stick',
    catalogNumber: '67',
    categoryId: 'personal_care',
    titleUk: 'Aloe Ever-Shield Deodorant Stick',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'avocado-face-body-soap',
    catalogNumber: '284',
    categoryId: 'personal_care',
    titleUk: 'Avocado Face & Body Soap',
    imageToken: 'body',
  ),
  _SeedProductSeed(
    id: 'travel-kit',
    catalogNumber: '524',
    categoryId: 'personal_care',
    titleUk: 'Travel Kit',
    imageToken: 'pack',
    wellnessTags: <String>['self-care', 'daily-routine', 'beauty'],
  ),

  _SeedProductSeed(
    id: 'aloe-eye-makeup-remover',
    catalogNumber: '186',
    categoryId: 'body_care',
    titleUk: 'Aloe Eye Makeup Remover',
    imageToken: 'glow',
  ),
  _SeedProductSeed(
    id: 'aloe-body-toning-kit',
    catalogNumber: '55',
    categoryId: 'body_care',
    titleUk: 'Aloe Body Toning Kit',
    imageToken: 'body',
    isFeatured: true,
  ),
  _SeedProductSeed(
    id: 'aloe-bath-gelee',
    catalogNumber: '14',
    categoryId: 'body_care',
    titleUk: 'Aloe Bath Gelee',
    imageToken: 'body',
  ),
  _SeedProductSeed(
    id: 'aloe-body-toner',
    catalogNumber: '56',
    categoryId: 'body_care',
    titleUk: 'Aloe Body Toner',
    imageToken: 'body',
  ),
  _SeedProductSeed(
    id: 'aloe-body-conditioning-creme',
    catalogNumber: '57',
    categoryId: 'body_care',
    titleUk: 'Aloe Body Conditioning Creme',
    imageToken: 'body',
  ),

  _SeedProductSeed(
    id: 'aloe-jojoba-shampoo',
    catalogNumber: '521',
    categoryId: 'hair_care',
    titleUk: 'Aloe-Jojoba Shampoo',
    imageToken: 'hair',
    isFeatured: true,
  ),
  _SeedProductSeed(
    id: 'aloe-jojoba-conditioning-rinse',
    catalogNumber: '522',
    categoryId: 'hair_care',
    titleUk: 'Aloe-Jojoba Conditioning Rinse',
    imageToken: 'hair',
  ),
  _SeedProductSeed(
    id: 'sonya-hydrate-shampoo',
    catalogNumber: '349',
    categoryId: 'hair_care',
    titleUk: 'Sonya Hydrate Shampoo',
    imageToken: 'hair',
  ),
  _SeedProductSeed(
    id: 'sonya-volume-shampoo',
    catalogNumber: '351',
    categoryId: 'hair_care',
    titleUk: 'Sonya Volume Shampoo',
    imageToken: 'hair',
  ),

  _SeedProductSeed(
    id: 'multi-purpose-detergent-2x-ultra',
    catalogNumber: '307',
    categoryId: 'home_care',
    titleUk: 'Multi Purpose Detergent 2X Ultra',
    imageToken: 'home',
  ),

  _SeedProductSeed(
    id: 'forever-25th-edition-women',
    catalogNumber: '208',
    categoryId: 'fragrances',
    titleUk: 'Forever 25th Edition Women',
    imageToken: 'fragrance',
    isFeatured: true,
  ),
  _SeedProductSeed(
    id: 'forever-25th-edition-men',
    catalogNumber: '209',
    categoryId: 'fragrances',
    titleUk: 'Forever 25th Edition Men',
    imageToken: 'fragrance',
  ),
];

final Map<String, _SeedProductSeed> _enrichedSeedByStorefrontCode =
    <String, _SeedProductSeed>{
      for (final _SeedProductSeed seed in _seedProductSeeds)
        if (_matchSeedToStorefrontEntry(seed)
            case final StorefrontCatalogEntry entry)
          _normalizeCatalogCode(entry.code): seed,
    };

final List<Product> seedProducts = storefrontCatalogEntries
    .map(_buildLiveCatalogProduct)
    .toList(growable: false);

final List<ProductCategory> availableSeedCategories = seedCategories
    .where(
      (ProductCategory category) =>
          seedProducts.any((Product item) => item.categoryId == category.id),
    )
    .toList(growable: false);

const List<String> planActionPool = <String>[
  'Почніть день зі склянки води та короткого налаштування на ритм дня.',
  'Заплануйте один спокійний прийом їжі без поспіху та екранів.',
  'Додайте 10 хвилин легкої прогулянки або розтяжки після обіду.',
  'Перевірте, чи є у вас під рукою пляшка води на другу половину дня.',
  'Завершіть день коротким check-in: як почувається тіло і що допомогло сьогодні.',
  'Зробіть паузу на 3 глибокі вдихи перед головною справою дня.',
  'Влаштуйте один маленький self-care ритуал увечері.',
];

const List<String> journalPromptPool = <String>[
  'Що сьогодні дало вам найбільше відчуття стабільності?',
  'Яка звичка сьогодні спрацювала найпростіше?',
  'Що варто спростити завтра, щоб залишитися в ритмі?',
  'Коли сьогодні вам було найкомфортніше фізично?',
  'Яка одна дія допомогла відчути більше контролю над днем?',
  'Що ви хочете повторити завтра без зайвого тиску?',
  'Який настрій ви хочете перенести у завтрашній день?',
];

const List<ReminderSetting> defaultReminderSettings = <ReminderSetting>[
  ReminderSetting(
    id: 'daily-plan',
    type: ReminderType.dailyPlan,
    title: 'Ранковий план',
    description: 'Нагадування відкрити сьогоднішній checklist.',
    hour: 8,
    minute: 30,
    isEnabled: true,
  ),
  ReminderSetting(
    id: 'hydration',
    type: ReminderType.hydration,
    title: 'Вода протягом дня',
    description: 'М’яке нагадування випити воду без тиску.',
    hour: 12,
    minute: 0,
    isEnabled: true,
  ),
  ReminderSetting(
    id: 'evening-checkin',
    type: ReminderType.eveningCheckIn,
    title: 'Вечірній check-in',
    description: 'Час внести сон, настрій та коротку нотатку.',
    hour: 20,
    minute: 30,
    isEnabled: true,
  ),
  ReminderSetting(
    id: 'streak-recovery',
    type: ReminderType.streakRecovery,
    title: 'Повернення в ритм',
    description: 'Нагадування, коли день пропущено і час повернутись м’яко.',
    hour: 18,
    minute: 15,
    isEnabled: false,
  ),
];

List<WellnessGoalId> allGoals() => WellnessGoalId.values;
