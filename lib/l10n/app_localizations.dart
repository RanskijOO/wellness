import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = <Locale>[
    Locale('uk'),
    Locale('en'),
  ];

  static const List<LocalizationsDelegate<dynamic>> delegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _values =
      <String, Map<String, String>>{
        'uk': <String, String>{
          'appName': 'Aloe Wellness Coach',
          'continue': 'Продовжити',
          'save': 'Зберегти',
          'guestMode': 'Гостьовий режим',
          'emailAuth': 'Вхід за email',
          'signIn': 'Увійти',
          'signUp': 'Створити акаунт',
          'forgotPassword': 'Скинути пароль',
          'home': 'Сьогодні',
          'progress': 'Прогрес',
          'plans': 'Плани',
          'products': 'Каталог',
          'profile': 'Профіль',
          'recommendations': 'Рекомендовані продукти',
          'hydration': 'Вода',
          'sleep': 'Сон',
          'weight': 'Вага',
          'mood': 'Настрій',
          'notes': 'Нотатки',
          'emptyState': 'Поки що тут спокійно',
          'loadError': 'Не вдалося завантажити дані',
          'retry': 'Спробувати ще',
          'openProductPage': 'Відкрити сторінку',
          'openInApp': 'Відкрити в застосунку',
          'openBrowser': 'Відкрити в браузері',
          'shop': 'Магазин',
          'dailyPlan': 'План на сьогодні',
          'reminders': 'Нагадування',
          'analytics': 'Аналітика',
          'settings': 'Налаштування',
          'privacy': 'Політика конфіденційності',
          'terms': 'Умови використання',
          'support': 'Підтримка',
          'disclaimer': 'Дисклеймер',
          'language': 'Мова',
          'darkMode': 'Темна тема',
          'theme': 'Тема',
          'logout': 'Вийти',
          'todayCheckIn': 'Щоденний огляд',
          'programLength': 'Тривалість програми',
          'goals': 'Цілі',
          'questionnaire': 'Анкета',
          'consent': 'Згода',
          'startNow': 'Почати зараз',
          'personalRoutine': 'Персональний wellness-ритм',
          'dailyTracking': 'Щоденні трекери',
          'hydrationTarget': 'Ціль води',
          'sleepTarget': 'Ціль сну',
          'adherence': 'Виконання',
          'streak': 'Серія днів',
          'viewAll': 'Усе',
          'guestHint': 'Гість може користуватися додатком без реєстрації.',
          'comingSoon': 'Скоро',
          'englishReady': 'Архітектура готова для англійської локалізації.',
          'notificationsOff': 'Нагадування вимкнено',
          'notificationsOn': 'Нагадування увімкнено',
          'baseline': 'Базовий рівень',
          'currentPlan': 'Поточний план',
          'catalogHint': 'М’які product-підказки на основі ваших цілей.',
          'supportEmail': 'Email підтримки',
          'buildReady': 'Готово до запуску',
          'legal': 'Юридичні документи',
        },
        'en': <String, String>{
          'appName': 'Aloe Wellness Coach',
          'continue': 'Continue',
          'save': 'Save',
          'guestMode': 'Guest mode',
          'emailAuth': 'Email access',
          'signIn': 'Sign in',
          'signUp': 'Create account',
          'forgotPassword': 'Reset password',
          'home': 'Today',
          'progress': 'Progress',
          'plans': 'Plans',
          'products': 'Catalog',
          'profile': 'Profile',
          'recommendations': 'Recommended products',
          'hydration': 'Hydration',
          'sleep': 'Sleep',
          'weight': 'Weight',
          'mood': 'Mood',
          'notes': 'Notes',
          'emptyState': 'Nothing here yet',
          'loadError': 'Unable to load data',
          'retry': 'Try again',
          'openProductPage': 'Open page',
          'openInApp': 'Open in app',
          'openBrowser': 'Open in browser',
          'shop': 'Shop',
          'dailyPlan': 'Today plan',
          'reminders': 'Reminders',
          'analytics': 'Analytics',
          'settings': 'Settings',
          'privacy': 'Privacy policy',
          'terms': 'Terms of use',
          'support': 'Support',
          'disclaimer': 'Disclaimer',
          'language': 'Language',
          'darkMode': 'Dark mode',
          'theme': 'Theme',
          'logout': 'Sign out',
          'todayCheckIn': 'Daily check-in',
          'programLength': 'Program length',
          'goals': 'Goals',
          'questionnaire': 'Questionnaire',
          'consent': 'Consent',
          'startNow': 'Start now',
          'personalRoutine': 'Personal wellness rhythm',
          'dailyTracking': 'Daily tracking',
          'hydrationTarget': 'Hydration target',
          'sleepTarget': 'Sleep target',
          'adherence': 'Adherence',
          'streak': 'Streak',
          'viewAll': 'All',
          'guestHint': 'Guest mode works without account creation.',
          'comingSoon': 'Coming soon',
          'englishReady': 'English localization support is ready.',
          'notificationsOff': 'Reminders are off',
          'notificationsOn': 'Reminders are on',
          'baseline': 'Baseline',
          'currentPlan': 'Current plan',
          'catalogHint': 'Soft product guidance based on your goals.',
          'supportEmail': 'Support email',
          'buildReady': 'Ready to launch',
          'legal': 'Legal',
        },
      };

  String _read(String key) {
    return _values[locale.languageCode]?[key] ?? _values['uk']![key] ?? key;
  }

  String get appName => _read('appName');
  String get continueLabel => _read('continue');
  String get save => _read('save');
  String get guestMode => _read('guestMode');
  String get emailAuth => _read('emailAuth');
  String get signIn => _read('signIn');
  String get signUp => _read('signUp');
  String get forgotPassword => _read('forgotPassword');
  String get home => _read('home');
  String get progress => _read('progress');
  String get plans => _read('plans');
  String get products => _read('products');
  String get profile => _read('profile');
  String get recommendations => _read('recommendations');
  String get hydration => _read('hydration');
  String get sleep => _read('sleep');
  String get weight => _read('weight');
  String get mood => _read('mood');
  String get notes => _read('notes');
  String get emptyState => _read('emptyState');
  String get loadError => _read('loadError');
  String get retry => _read('retry');
  String get openProductPage => _read('openProductPage');
  String get openInApp => _read('openInApp');
  String get openBrowser => _read('openBrowser');
  String get shop => _read('shop');
  String get dailyPlan => _read('dailyPlan');
  String get reminders => _read('reminders');
  String get analytics => _read('analytics');
  String get settings => _read('settings');
  String get privacy => _read('privacy');
  String get terms => _read('terms');
  String get support => _read('support');
  String get disclaimer => _read('disclaimer');
  String get language => _read('language');
  String get darkMode => _read('darkMode');
  String get theme => _read('theme');
  String get logout => _read('logout');
  String get todayCheckIn => _read('todayCheckIn');
  String get programLength => _read('programLength');
  String get goals => _read('goals');
  String get questionnaire => _read('questionnaire');
  String get consent => _read('consent');
  String get startNow => _read('startNow');
  String get personalRoutine => _read('personalRoutine');
  String get dailyTracking => _read('dailyTracking');
  String get hydrationTarget => _read('hydrationTarget');
  String get sleepTarget => _read('sleepTarget');
  String get adherence => _read('adherence');
  String get streak => _read('streak');
  String get viewAll => _read('viewAll');
  String get guestHint => _read('guestHint');
  String get comingSoon => _read('comingSoon');
  String get englishReady => _read('englishReady');
  String get notificationsOff => _read('notificationsOff');
  String get notificationsOn => _read('notificationsOn');
  String get baseline => _read('baseline');
  String get currentPlan => _read('currentPlan');
  String get catalogHint => _read('catalogHint');
  String get supportEmail => _read('supportEmail');
  String get buildReady => _read('buildReady');
  String get legal => _read('legal');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (Locale item) => item.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations)!;
}
