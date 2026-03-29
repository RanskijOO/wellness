class StorefrontCatalogEntry {
  const StorefrontCatalogEntry({
    required this.code,
    required this.titleUk,
    required this.url,
    required this.categoryPath,
  });

  final String code;
  final String titleUk;
  final String url;
  final String categoryPath;

  static StorefrontCatalogEntry fromLine(String line) {
    final List<String> parts = line.split('|');
    return StorefrontCatalogEntry(
      code: parts[0],
      categoryPath: parts[1],
      titleUk: parts[2],
      url: parts[3],
    );
  }
}

final List<StorefrontCatalogEntry> storefrontCatalogEntries =
    _storefrontCatalogCsv
        .trim()
        .split('\n')
        .where((String line) => line.trim().isNotEmpty)
        .map(StorefrontCatalogEntry.fromLine)
        .toList(growable: false);

const String _storefrontCatalogCsv = '''
002|/uk/catalog/category/combo-packs/|Фаворит|https://aloe-hub.flpuretail.com/uk/catalog/product/121/
004|/uk/catalog/category/combo-packs/|Свобода руху|https://aloe-hub.flpuretail.com/uk/catalog/product/122/
005|/uk/catalog/category/combo-packs/|Кардіо здоров'я|https://aloe-hub.flpuretail.com/uk/catalog/product/123/
022|/uk/catalog/category/personal-care/|Гігієнічна Помада Алое Ліпс|https://aloe-hub.flpuretail.com/uk/catalog/product/126/
026|/uk/catalog/category/bee-products/|Форевер Бджолиний пилок|https://aloe-hub.flpuretail.com/uk/catalog/product/226/
027|/uk/catalog/category/bee-products/|Форевер Бджолиний прополіс|https://aloe-hub.flpuretail.com/uk/catalog/product/128/
028|/uk/catalog/category/personal-care/|Зубна Паста Форевер Брайт|https://aloe-hub.flpuretail.com/uk/catalog/product/129/
028S|/uk/catalog/category/personal-care/|Промо Зубна паста (2=3)|https://aloe-hub.flpuretail.com/uk/catalog/product/300/
036|/uk/catalog/category/bee-products/|Форевер Бджолине молочко|https://aloe-hub.flpuretail.com/uk/catalog/product/132/
037|/uk/catalog/category/nutrition/|Форевер Натур-мін|https://aloe-hub.flpuretail.com/uk/catalog/product/133/
040|/uk/catalog/category/personal-care/|Алое Фьорст|https://aloe-hub.flpuretail.com/uk/catalog/product/134/
048|/uk/catalog/category/nutrition/|Форевер Абсорбент-С|https://aloe-hub.flpuretail.com/uk/catalog/product/135/
051|/uk/catalog/category/skincare/|Крем Алое з прополісом|https://aloe-hub.flpuretail.com/uk/catalog/product/136/
061|/uk/catalog/category/skincare/|Желе Алое вера|https://aloe-hub.flpuretail.com/uk/catalog/product/137/
063|/uk/catalog/category/skincare/|Алое Зволожуючий лосьон|https://aloe-hub.flpuretail.com/uk/catalog/product/138/
064|/uk/catalog/category/personal-care/|Алое Хіт лосьйон|https://aloe-hub.flpuretail.com/uk/catalog/product/139/
065|/uk/catalog/category/nutrition/|Форевер Часник-чебрець|https://aloe-hub.flpuretail.com/uk/catalog/product/140/
067|/uk/catalog/category/personal-care/|Евер-Шилд дезодорант|https://aloe-hub.flpuretail.com/uk/catalog/product/141/
068|/uk/catalog/category/nutrition/|Форевер Філдз оф Грінз|https://aloe-hub.flpuretail.com/uk/catalog/product/142/
070|/uk/catalog/category/personal-care/|Лосьйон після гоління|https://aloe-hub.flpuretail.com/uk/catalog/product/144/
071|/uk/catalog/category/nutrition/|Форевер Гарсинія плюс|https://aloe-hub.flpuretail.com/uk/catalog/product/145/
072|/uk/catalog/category/nutrition/|Форевер Лайсіум плюс|https://aloe-hub.flpuretail.com/uk/catalog/product/146/
1572|/uk/catalog/category/combo-packs/|Фаворит Міні|https://aloe-hub.flpuretail.com/uk/catalog/product/186/
1575|/uk/catalog/category/combo-packs/|Програма "Міцний імунітет"|https://aloe-hub.flpuretail.com/uk/catalog/product/188/
1577|/uk/catalog/category/combo-packs/|Програма "Здоров'я дитини"|https://aloe-hub.flpuretail.com/uk/catalog/product/189/
1585|/uk/catalog/category/combo-packs/|Знайомство з Форевер|https://aloe-hub.flpuretail.com/uk/catalog/product/286/
188|/uk/catalog/category/nutrition/|Форевер В12 Плюс|https://aloe-hub.flpuretail.com/uk/catalog/product/62/
200|/uk/catalog/category/aloe-drinks/|Чай з квітів Алое з травами|https://aloe-hub.flpuretail.com/uk/catalog/product/1/
205|/uk/catalog/category/skincare/|Алое МСМ Гель|https://aloe-hub.flpuretail.com/uk/catalog/product/60/
206|/uk/catalog/category/nutrition/|Форевер Кальцій|https://aloe-hub.flpuretail.com/uk/catalog/product/50/
207|/uk/catalog/category/bee-products/|Форевер Бджолиний мед|https://aloe-hub.flpuretail.com/uk/catalog/product/289/
215|/uk/catalog/category/nutrition/|Форевер Мульти-Мака|https://aloe-hub.flpuretail.com/uk/catalog/product/47/
238|/uk/catalog/category/skincare/|Форевер Скраб Алое|https://aloe-hub.flpuretail.com/uk/catalog/product/63/
264|/uk/catalog/category/nutrition/|Форевер Ектив Гіалурон|https://aloe-hub.flpuretail.com/uk/catalog/product/35/
284|/uk/catalog/category/personal-care/|Косметичне мило з авокадо|https://aloe-hub.flpuretail.com/uk/catalog/product/71/
289|/uk/catalog/category/nutrition/|Форевер Лін|https://aloe-hub.flpuretail.com/uk/catalog/product/33/
312|/uk/catalog/category/nutrition/|Форевер Кардіо Тонік|https://aloe-hub.flpuretail.com/uk/catalog/product/49/
354|/uk/catalog/category/nutrition/|Форевер Кідз|https://aloe-hub.flpuretail.com/uk/catalog/product/68/
355|/uk/catalog/category/nutrition/|Форевер Імубленд|https://aloe-hub.flpuretail.com/uk/catalog/product/61/
374|/uk/catalog/category/nutrition/|Вітолайз Чоловіча Енергія|https://aloe-hub.flpuretail.com/uk/catalog/product/39/
375|/uk/catalog/category/nutrition/|Вітолайз Жіноча Енергія|https://aloe-hub.flpuretail.com/uk/catalog/product/36/
376|/uk/catalog/category/nutrition/|Форевер Арктичне Море|https://aloe-hub.flpuretail.com/uk/catalog/product/37/
439|/uk/catalog/category/nutrition/|Форевер Дейлі|https://aloe-hub.flpuretail.com/uk/catalog/product/59/
456|/uk/catalog/category/combo-packs/|Вайтал5 (Гель Алое Вера)|https://aloe-hub.flpuretail.com/uk/catalog/product/81/
457|/uk/catalog/category/combo-packs/|"Вайтал 5" Ягідний Нектар|https://aloe-hub.flpuretail.com/uk/catalog/product/82/
458|/uk/catalog/category/combo-packs/|"Вайтал 5" Алое з персиком|https://aloe-hub.flpuretail.com/uk/catalog/product/83/
459|/uk/catalog/category/combo-packs/|"Вайтал 5" Форевер Свобода|https://aloe-hub.flpuretail.com/uk/catalog/product/209/
463|/uk/catalog/category/nutrition/|Форевер Терм|https://aloe-hub.flpuretail.com/uk/catalog/product/30/
464|/uk/catalog/category/nutrition/|Форевер Файбер|https://aloe-hub.flpuretail.com/uk/catalog/product/53/
470|/uk/catalog/category/nutrition/|Лайт Ультра Ванільний|https://aloe-hub.flpuretail.com/uk/catalog/product/51/
471|/uk/catalog/category/nutrition/|Лайт Ультра Шоколадний|https://aloe-hub.flpuretail.com/uk/catalog/product/52/
473|/uk/catalog/category/nutrition/|АРДЖІ+|https://aloe-hub.flpuretail.com/uk/catalog/product/25/
475|/uk/catalog/category/combo-packs/|Програма Очистки С9 Ваніль|https://aloe-hub.flpuretail.com/uk/catalog/product/84/
476|/uk/catalog/category/combo-packs/|Програма Очистки С9 Шоколад|https://aloe-hub.flpuretail.com/uk/catalog/product/85/
520|/uk/catalog/category/nutrition/|Батончик Форевер Фаст Брейк|https://aloe-hub.flpuretail.com/uk/catalog/product/72/
551|/uk/catalog/category/nutrition/|Форевер Мув|https://aloe-hub.flpuretail.com/uk/catalog/product/116/
553|/uk/catalog/category/skincare/|Набір "Інфініт від Форевер"|https://aloe-hub.flpuretail.com/uk/catalog/product/114/
554|/uk/catalog/category/skincare/|Зволожуючий комплекс Інфініт|https://aloe-hub.flpuretail.com/uk/catalog/product/94/
555|/uk/catalog/category/skincare/|Зміцнююча Сироватка Інфініт|https://aloe-hub.flpuretail.com/uk/catalog/product/95/
556|/uk/catalog/category/skincare/|Зміцнюючий комплекс Інфініт|https://aloe-hub.flpuretail.com/uk/catalog/product/96/
558|/uk/catalog/category/skincare/|Відновлюючий крем Інфініт від Форевер|https://aloe-hub.flpuretail.com/uk/catalog/product/97/
559|/uk/catalog/category/skincare/|Очищуючий та Вирівнюючий Скраб|https://aloe-hub.flpuretail.com/uk/catalog/product/98/
561|/uk/catalog/category/skincare/|Крем Навколо Очей|https://aloe-hub.flpuretail.com/uk/catalog/product/100/
564|/uk/catalog/category/personal-care/|Алое Охолоджуючий лосьйон|https://aloe-hub.flpuretail.com/uk/catalog/product/235/
566|/uk/catalog/category/nutrition/|Форевер Імун Ґаммі|https://aloe-hub.flpuretail.com/uk/catalog/product/233/
610|/uk/catalog/category/nutrition/|Форевер Ектів Про-Бі|https://aloe-hub.flpuretail.com/uk/catalog/product/28/
612|/uk/catalog/category/skincare/|Алое Активатор|https://aloe-hub.flpuretail.com/uk/catalog/product/105/
613|/uk/catalog/category/nutrition/|Форевер Морський колаген|https://aloe-hub.flpuretail.com/uk/catalog/product/232/
618|/uk/catalog/category/skincare/|Зволожуюча Сироватка|https://aloe-hub.flpuretail.com/uk/catalog/product/106/
622|/uk/catalog/category/nutrition/|Форевер Фокус|https://aloe-hub.flpuretail.com/uk/catalog/product/24/
624|/uk/catalog/category/nutrition/|Форевер АйВіжн|https://aloe-hub.flpuretail.com/uk/catalog/product/29/
625|/uk/catalog/category/combo-packs/|С9 (Нектар & Лайт Ваніль)|https://aloe-hub.flpuretail.com/uk/catalog/product/228/
633|/uk/catalog/category/personal-care/|Рідке Мило з Алое|https://aloe-hub.flpuretail.com/uk/catalog/product/78/
640|/uk/catalog/category/personal-care/|Шампунь Алое-Жожоба|https://aloe-hub.flpuretail.com/uk/catalog/product/3/
641|/uk/catalog/category/personal-care/|Кондиціонер Алое-Жожоба|https://aloe-hub.flpuretail.com/uk/catalog/product/10/
642|/uk/catalog/category/personal-care/|Живильна Олія для Волосся|https://aloe-hub.flpuretail.com/uk/catalog/product/250/
643|/uk/catalog/category/personal-care/|Алофа (жіночий аромат)|https://aloe-hub.flpuretail.com/uk/catalog/product/258/
644|/uk/catalog/category/personal-care/|Малосі (чоловічий аромат)|https://aloe-hub.flpuretail.com/uk/catalog/product/259/
645|/uk/catalog/category/skincare/|Захисний Денний Лосьйон|https://aloe-hub.flpuretail.com/uk/catalog/product/225/
646|/uk/catalog/category/personal-care/|Алое Гель для Душу|https://aloe-hub.flpuretail.com/uk/catalog/product/11/
647|/uk/catalog/category/personal-care/|Алое Лосьйон для Тіла|https://aloe-hub.flpuretail.com/uk/catalog/product/76/
650|/uk/catalog/category/skincare/|Відновлювальний крем для шкіри|https://aloe-hub.flpuretail.com/uk/catalog/product/291/
651|/uk/catalog/category/skincare/|Глибоко Зволожуючий Крем|https://aloe-hub.flpuretail.com/uk/catalog/product/234/
652|/uk/catalog/category/skincare/|Ліфтингова маска-пудра|https://aloe-hub.flpuretail.com/uk/catalog/product/283/
653|/uk/catalog/category/skincare/|Відновлююча олія для шкіри|https://aloe-hub.flpuretail.com/uk/catalog/product/267/
656|/uk/catalog/category/nutrition/|Форевер Рослинний протеїн|https://aloe-hub.flpuretail.com/uk/catalog/product/115/
659|/uk/catalog/category/combo-packs/|DX4|https://aloe-hub.flpuretail.com/uk/catalog/product/112/
664|/uk/catalog/category/skincare/|Алое Біоцелюлозна маска|https://aloe-hub.flpuretail.com/uk/catalog/product/257/
665|/uk/catalog/category/nutrition/|Форевер Сенсатіабль|https://aloe-hub.flpuretail.com/uk/catalog/product/239/
667|/uk/catalog/category/skincare/|Logic Очищуючий гель з алое|https://aloe-hub.flpuretail.com/uk/catalog/product/279/
668|/uk/catalog/category/skincare/|Logic Балансуючий тонер|https://aloe-hub.flpuretail.com/uk/catalog/product/280/
669|/uk/catalog/category/skincare/|Logic Заспокійливий зволожуючий гель|https://aloe-hub.flpuretail.com/uk/catalog/product/281/
672|/uk/catalog/category/nutrition/|Форевер Абсорбент-D|https://aloe-hub.flpuretail.com/uk/catalog/product/261/
673|/uk/catalog/category/skincare/|Logic Система догляду за шкірою|https://aloe-hub.flpuretail.com/uk/catalog/product/288/
676|/uk/catalog/category/nutrition/|Форевер Алое Куркума|https://aloe-hub.flpuretail.com/uk/catalog/product/264/
67610|/uk/catalog/category/nutrition/|Форевер Алое Куркума (набір з 10 упаковок)|https://aloe-hub.flpuretail.com/uk/catalog/product/282/
677|/uk/catalog/category/skincare/|Гель-маска "Досконалість"|https://aloe-hub.flpuretail.com/uk/catalog/product/290/
815|/uk/catalog/category/aloe-drinks/|Форевер Гель Алое Вера|https://aloe-hub.flpuretail.com/uk/catalog/product/296/
8154|/uk/catalog/category/combo-packs/|Квартет Класика|https://aloe-hub.flpuretail.com/uk/catalog/product/297/
821|/uk/catalog/category/aloe-drinks/|Енергетичний напій FAB|https://aloe-hub.flpuretail.com/uk/catalog/product/269/
822|/uk/catalog/category/aloe-drinks/|FAB X нуль калорій без цукру|https://aloe-hub.flpuretail.com/uk/catalog/product/268/
8234|/uk/catalog/category/combo-packs/|Квартет Мікс|https://aloe-hub.flpuretail.com/uk/catalog/product/298/
834|/uk/catalog/category/aloe-drinks/|Форевер Алое Ягідний Нектар|https://aloe-hub.flpuretail.com/uk/catalog/product/292/
8344|/uk/catalog/category/combo-packs/|Квартет Нектар|https://aloe-hub.flpuretail.com/uk/catalog/product/293/
836|/uk/catalog/category/aloe-drinks/|Форевер Алое-Манго|https://aloe-hub.flpuretail.com/uk/catalog/product/284/
8364|/uk/catalog/category/combo-packs/|Квартет Манго (ПЕТ)|https://aloe-hub.flpuretail.com/uk/catalog/product/285/
877|/uk/catalog/category/aloe-drinks/|Форевер Гель Алое з Персиком|https://aloe-hub.flpuretail.com/uk/catalog/product/294/
8774|/uk/catalog/category/combo-packs/|Квартет Персик|https://aloe-hub.flpuretail.com/uk/catalog/product/295/
''';
