import '../../features/goals/domain/wellness_goal.dart';
import '../../features/products/domain/product_models.dart';
import '../../features/profile/domain/profile_models.dart';

const List<ProductCategory> seedCategories = <ProductCategory>[
  ProductCategory(
    id: 'aloe_drinks',
    titleUk: 'Aloe напої та гелі',
    subtitleUk: 'Щоденна база для водного ритму та wellness-звичок.',
    iconKey: 'water_drop',
  ),
  ProductCategory(
    id: 'nutrition',
    titleUk: 'Харчова підтримка',
    subtitleUk: 'Шейки, протеїн і щоденні форматні рішення.',
    iconKey: 'nutrition',
  ),
  ProductCategory(
    id: 'bee_products',
    titleUk: 'Bee-продукти',
    subtitleUk: 'Комплекси з пилком, прополісом та honey-inspired формулами.',
    iconKey: 'hive',
  ),
  ProductCategory(
    id: 'skincare',
    titleUk: 'Skincare',
    subtitleUk: 'М’який догляд, комфорт шкіри та aloe-first текстури.',
    iconKey: 'spa',
  ),
  ProductCategory(
    id: 'personal_care',
    titleUk: 'Особистий догляд',
    subtitleUk: 'Щоденна гігієна та ритуали турботи про себе.',
    iconKey: 'self_improvement',
  ),
  ProductCategory(
    id: 'combo_packs',
    titleUk: 'Комбо-набори',
    subtitleUk: 'Готові поєднання для старту 7/14/21-денних програм.',
    iconKey: 'inventory_2',
  ),
];

const List<Product> seedProducts = <Product>[
  Product(
    id: 'aloe-gel-classic',
    categoryId: 'aloe_drinks',
    titleUk: 'Aloe Gel Classic',
    shortDescriptionUk:
        'Класичний aloe-first напій для щоденного wellness-ритму та гідратаційної рутини.',
    wellnessTags: <String>['hydration', 'aloe', 'daily-routine'],
    usageNotesUk:
        'Використовуйте як частину ранкового або денного ритуалу разом із достатнім споживанням води.',
    cautionNotesUk:
        'Не є медичним продуктом. Якщо ви маєте індивідуальні обмеження у харчуванні, перевіряйте склад та порадьтеся з фахівцем.',
    imageToken: 'aloe',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'База для щоденного aloe-ритму',
    isFeatured: true,
  ),
  Product(
    id: 'aloe-berry-balance',
    categoryId: 'aloe_drinks',
    titleUk: 'Aloe Berry Balance',
    shortDescriptionUk:
        'Aloe-напій із ягідним смаком для тих, хто хоче підтримати питний ритм більш м’яко.',
    wellnessTags: <String>['hydration', 'beauty', 'aloe'],
    usageNotesUk:
        'Підійде для ротації смаків у 14- чи 21-денному плані без перевантаження рутини.',
    cautionNotesUk:
        'Завжди звіряйте індивідуальну переносимість інгредієнтів. Це загальна wellness-підтримка.',
    imageToken: 'berry',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'Смаковий варіант для гідратаційного плану',
    isFeatured: false,
  ),
  Product(
    id: 'daily-shake-vanilla',
    categoryId: 'nutrition',
    titleUk: 'Daily Shake Vanilla',
    shortDescriptionUk:
        'Поживний shake для структурованого початку дня або контрольованого перекусу.',
    wellnessTags: <String>['nutrition', 'energy', 'healthy-routine'],
    usageNotesUk:
        'Найкраще працює як частина збалансованого меню та стабільного режиму харчування.',
    cautionNotesUk:
        'Не замінює повноцінний індивідуальний план харчування та не призначений для лікувальних цілей.',
    imageToken: 'shake',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'Комфортний формат для ранкового старту',
    isFeatured: true,
  ),
  Product(
    id: 'fiber-routine-mix',
    categoryId: 'nutrition',
    titleUk: 'Fiber Routine Mix',
    shortDescriptionUk:
        'Формат для доповнення щоденної рутини, коли хочеться більше структури в меню.',
    wellnessTags: <String>['balance', 'healthy-routine', 'daily-routine'],
    usageNotesUk:
        'Поєднуйте з водою та базовими харчовими звичками, а не як ізольоване рішення.',
    cautionNotesUk:
        'Підходить не всім раціонам. Перед використанням перевірте склад і спосіб споживання.',
    imageToken: 'fiber',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'Зручний супровід для щоденного меню',
    isFeatured: false,
  ),
  Product(
    id: 'bee-pollen-daily',
    categoryId: 'bee_products',
    titleUk: 'Bee Pollen Daily',
    shortDescriptionUk:
        'Bee-комплекс для тих, хто хоче урізноманітнити свій щоденний wellness-набір.',
    wellnessTags: <String>['energy', 'nutrition', 'focus'],
    usageNotesUk:
        'Додавайте поступово, відстежуючи комфорт використання та власний режим.',
    cautionNotesUk:
        'Містить компоненти бджільництва. У разі чутливості або алергій потрібна додаткова обережність.',
    imageToken: 'bee',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'Bee-support для структурованого дня',
    isFeatured: false,
  ),
  Product(
    id: 'propolis-soft-support',
    categoryId: 'bee_products',
    titleUk: 'Propolis Soft Support',
    shortDescriptionUk:
        'Делікатний bee-продукт для побудови стабільної особистої рутини.',
    wellnessTags: <String>['daily-routine', 'balance', 'bee'],
    usageNotesUk:
        'Використовуйте лише в межах загального wellness-підходу та без очікування медичних ефектів.',
    cautionNotesUk:
        'Не використовуйте без перевірки складу, якщо маєте індивідуальні реакції на продукти бджільництва.',
    imageToken: 'propolis',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'М’яка bee-підтримка для щоденного ритуалу',
    isFeatured: false,
  ),
  Product(
    id: 'aloe-hydra-cream',
    categoryId: 'skincare',
    titleUk: 'Aloe Hydra Cream',
    shortDescriptionUk:
        'Крем для комфортного щоденного догляду з акцентом на aloe-inspired текстуру.',
    wellnessTags: <String>['beauty', 'skin', 'hydration'],
    usageNotesUk:
        'Поєднуйте з достатнім сном, водою та базовою рутиною догляду.',
    cautionNotesUk:
        'Для зовнішнього використання. Перед регулярним застосуванням перевірте індивідуальну чутливість.',
    imageToken: 'cream',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'Щоденний догляд для beauty-ритуалу',
    isFeatured: true,
  ),
  Product(
    id: 'aloe-soothing-gelly',
    categoryId: 'skincare',
    titleUk: 'Aloe Soothing Gelly',
    shortDescriptionUk:
        'Легка aloe-формула для домашнього self-care ритуалу та комфорту шкіри.',
    wellnessTags: <String>['skin', 'beauty', 'aloe'],
    usageNotesUk:
        'Підходить як частина базового догляду, коли потрібне відчуття м’якості та свіжості.',
    cautionNotesUk:
        'Це не лікувальний засіб. Не використовуйте на подразнених ділянках без професійної поради.',
    imageToken: 'gelly',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'Self-care доповнення до beauty-програми',
    isFeatured: false,
  ),
  Product(
    id: 'aloe-body-cleanse',
    categoryId: 'personal_care',
    titleUk: 'Aloe Body Cleanse',
    shortDescriptionUk:
        'М’який очищувальний формат для щоденного догляду за собою.',
    wellnessTags: <String>['self-care', 'daily-routine', 'beauty'],
    usageNotesUk:
        'Використовуйте як частину спокійного ранкового або вечірнього ritual care набору.',
    cautionNotesUk:
        'Лише для зовнішнього використання. Слідкуйте за реакцією шкіри.',
    imageToken: 'body',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'М’який daily care формат',
    isFeatured: false,
  ),
  Product(
    id: 'fresh-smile-gel',
    categoryId: 'personal_care',
    titleUk: 'Fresh Smile Gel',
    shortDescriptionUk:
        'Щоденний personal care продукт для стабільного відчуття чистоти та свіжості.',
    wellnessTags: <String>['daily-routine', 'self-care'],
    usageNotesUk: 'Добре доповнює ранкову та вечірню звичку турботи про себе.',
    cautionNotesUk:
        'Використовуйте за інструкцією виробника. Не призначено для медичних цілей.',
    imageToken: 'smile',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'Компактний елемент щоденної дисципліни',
    isFeatured: false,
  ),
  Product(
    id: 'aloe-reset-pack',
    categoryId: 'combo_packs',
    titleUk: 'Aloe Reset Pack 7',
    shortDescriptionUk:
        'Стартовий набір для короткої 7-денної wellness-програми з водним фокусом.',
    wellnessTags: <String>['combo', 'hydration', 'daily-routine'],
    usageNotesUk:
        'Підійде для м’якого старту, коли потрібен готовий набір без складного вибору.',
    cautionNotesUk:
        'Комбо-набір не замінює індивідуальну консультацію та не дає лікувальних обіцянок.',
    imageToken: 'pack',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'Готовий старт для 7-денного плану',
    isFeatured: true,
  ),
  Product(
    id: 'aloe-glow-pack',
    categoryId: 'combo_packs',
    titleUk: 'Aloe Glow Pack 21',
    shortDescriptionUk:
        'Розширений beauty та hydration pack для більш структурованої 21-денної рутини.',
    wellnessTags: <String>['combo', 'beauty', 'hydration', 'skin'],
    usageNotesUk:
        'Підходить для користувачів, які хочуть мати один зібраний набір для тривалішої програми.',
    cautionNotesUk:
        'Залишається wellness-рішенням і не є лікувальною рекомендацією.',
    imageToken: 'glow',
    externalProductUrl: 'https://www.foreverliving.com/',
    highlightUk: 'Розширений pack для тривалого ритму',
    isFeatured: true,
  ),
];

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
