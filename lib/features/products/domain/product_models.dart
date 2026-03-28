class ProductCategory {
  const ProductCategory({
    required this.id,
    required this.titleUk,
    required this.subtitleUk,
    required this.iconKey,
    this.titleEn,
    this.subtitleEn,
  });

  final String id;
  final String titleUk;
  final String subtitleUk;
  final String iconKey;
  final String? titleEn;
  final String? subtitleEn;

  String get title => titleUk;
  String get subtitle => subtitleUk;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'titleUk': titleUk,
      'subtitleUk': subtitleUk,
      'titleEn': titleEn,
      'subtitleEn': subtitleEn,
      'iconKey': iconKey,
    };
  }

  static ProductCategory fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id']?.toString() ?? '',
      titleUk: json['titleUk']?.toString() ?? json['title']?.toString() ?? '',
      subtitleUk:
          json['subtitleUk']?.toString() ?? json['subtitle']?.toString() ?? '',
      titleEn: json['titleEn']?.toString(),
      subtitleEn: json['subtitleEn']?.toString(),
      iconKey: json['iconKey']?.toString() ?? 'spa',
    );
  }
}

class Product {
  const Product({
    required this.id,
    required this.categoryId,
    required this.titleUk,
    required this.shortDescriptionUk,
    required this.wellnessTags,
    required this.usageNotesUk,
    required this.cautionNotesUk,
    required this.imageToken,
    required this.externalProductUrl,
    required this.highlightUk,
    required this.isFeatured,
    this.titleEn,
    this.shortDescriptionEn,
    this.usageNotesEn,
    this.cautionNotesEn,
    this.highlightEn,
  });

  final String id;
  final String categoryId;
  final String titleUk;
  final String shortDescriptionUk;
  final List<String> wellnessTags;
  final String usageNotesUk;
  final String cautionNotesUk;
  final String imageToken;
  final String externalProductUrl;
  final String highlightUk;
  final bool isFeatured;
  final String? titleEn;
  final String? shortDescriptionEn;
  final String? usageNotesEn;
  final String? cautionNotesEn;
  final String? highlightEn;

  String get title => titleUk;
  String get shortDescription => shortDescriptionUk;
  String get usageNotes => usageNotesUk;
  String get cautionNotes => cautionNotesUk;
  String get highlight => highlightUk;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'titleUk': titleUk,
      'titleEn': titleEn,
      'shortDescriptionUk': shortDescriptionUk,
      'shortDescriptionEn': shortDescriptionEn,
      'wellnessTags': wellnessTags,
      'usageNotesUk': usageNotesUk,
      'usageNotesEn': usageNotesEn,
      'cautionNotesUk': cautionNotesUk,
      'cautionNotesEn': cautionNotesEn,
      'imageToken': imageToken,
      'externalProductUrl': externalProductUrl,
      'highlightUk': highlightUk,
      'highlightEn': highlightEn,
      'isFeatured': isFeatured,
    };
  }

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      titleUk: json['titleUk']?.toString() ?? json['title']?.toString() ?? '',
      titleEn: json['titleEn']?.toString(),
      shortDescriptionUk:
          json['shortDescriptionUk']?.toString() ??
          json['shortDescription']?.toString() ??
          '',
      shortDescriptionEn: json['shortDescriptionEn']?.toString(),
      wellnessTags: (json['wellnessTags'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(),
      usageNotesUk:
          json['usageNotesUk']?.toString() ??
          json['usageNotes']?.toString() ??
          '',
      usageNotesEn: json['usageNotesEn']?.toString(),
      cautionNotesUk:
          json['cautionNotesUk']?.toString() ??
          json['cautionNotes']?.toString() ??
          '',
      cautionNotesEn: json['cautionNotesEn']?.toString(),
      imageToken: json['imageToken']?.toString() ?? 'aloe',
      externalProductUrl: json['externalProductUrl']?.toString() ?? '',
      highlightUk:
          json['highlightUk']?.toString() ??
          json['highlight']?.toString() ??
          '',
      highlightEn: json['highlightEn']?.toString(),
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }
}
