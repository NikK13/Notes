import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes/data/utils/app.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en':{
      'start': "Let's start",
      'continue': "Continue",
      'description': "Leave your thoughts here",
      'appearance': "Appearance",
      'common': "Common",
      'app': "Application",
      'changelang': "Current language",
      'currenttheme': "Current theme",
      'darktheme': "Dark",
      'lighttheme': "Light",
      'systemtheme': "System",
      'themes': "Available themes",
      'langs': "Available languages",
      'settings': "Settings",
      'labels': "Menu labels",
      'appcolor': 'Design color',
      'cancel': "Cancel",
      "typehint": "Type here something",
      "save": "Save",
      'nodata': "Let's create your first note",
      'tryagain': "Try again",
      'wrongerror': "Something went wrong",
      'all': "All",
      'explore': "Explore",
      'create': "Create",
      'notes': "Notes",
      'title': "Title",
      'desc': "Description",
      "createnote": "Create a note",
      "add": "Add note",
      "editnote": "Edit note",
      "lastedit": "Last edited",
      "simple_note": "Simple note",
      "shop_note": "Shop item list",
      "task_note": "Tasks list",
      "priority": "Priority",
      "low": "Low",
      "medium": "Medium",
      "high": "High",
      "tasks": "Tasks"
    },
    'ru':{
      'start': "Начать",
      'continue': "Продолжить",
      'description': "Оставьте свои мысли здесь",
      'appearance': "Дизайн",
      'common': "Общие",
      'app': "Приложение",
      'changelang': "Текущий язык",
      'currenttheme': "Текущая тема",
      'darktheme': "Темная",
      'lighttheme': "Светлая",
      'systemtheme': "Тема устройства",
      'themes': "Доступные темы",
      'langs': "Доступные языки",
      'settings': "Настройки",
      'labels': "Заголовки меню",
      'appcolor': 'Цвет дизайна',
      'cancel': "Отмена",
      "typehint": "Напишите что-нибудь",
      "save": "Сохранить",
      'nodata': "Создайте свою первую заметку",
      'tryagain': "Попробовать снова",
      'wrongerror': "Что-то пошло не так",
      'all': "Все",
      'explore': "Главная",
      'create': "Создать",
      'notes': "Закладки",
      'title': "Заголовок",
      'desc': "Описание",
      "createnote": "Создать заметку",
      "add": "Добавить",
      "editnote": "Изменить заметку",
      "lastedit": "Изменено",
      "simple_note": "Обычная заметка",
      "shop_note": "Список покупок",
      "task_note": "Список задач",
      "priority": "Приоритет",
      "low": "Низкий",
      "medium": "Средний",
      "high": "Высокий",
      "tasks": "Задачи"
    },
  };

  String get langCode => locale.languageCode.toString();

  String translate(key) => _localizedValues[locale.languageCode]![key]!;

  static String of(BuildContext context, String key) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!
          .translate(key);
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
