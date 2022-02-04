import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:notes/data/model/preferences.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceProvider extends ChangeNotifier {
  SharedPreferences? sp;

  String? currentTheme;
  Locale? locale;
  bool? isBlackMode;
  bool? isLabels;
  bool? isFirst;
  String? color;

  PreferenceProvider() {
    _loadFromPrefs();
  }

  _initPrefs() async {
    sp ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    if (sp!.getBool('isLabels') == null) await sp!.setBool('isLabels', true);
    if (sp!.getString('mode') == null) await sp!.setString('mode', 'system');
    if (sp!.getString('color') == null) await sp!.setString('color', App.defColor);
    if (sp!.getBool('first') == null) await sp!.setBool('first', true);
    if (sp!.getString('language') == null) {
      switch (window.locale.languageCode) {
        case 'en':
        case 'ru':
          locale = Locale(window.locale.languageCode, '');
          break;
        default:
          locale = const Locale('en', '');
      }
    } else {
      locale = Locale(sp!.getString('language')!, '');
    }
    isLabels = sp!.getBool('isLabels');
    isFirst = sp!.getBool('first');
    color = sp!.getString('color');
    currentTheme = sp!.getString('mode');
    notifyListeners();
  }

  savePreference(String key, value) async {
    await _initPrefs();
    switch (key) {
      case 'mode':
      case 'language':
      case 'color':
        sp!.setString(key, value);
        break;
      case 'isLabels':
      case 'first':
        sp!.setBool(key, value);
        break;
    }
    locale = Locale(sp!.getString('language')!, '');
    isFirst = sp!.getBool('first');
    isLabels = sp!.getBool('isLabels');
    currentTheme = sp!.getString('mode');
    color = sp!.getString('color');
    notifyListeners();
  }

  Preferences get preferences => Preferences(
    currentTheme: currentTheme,
    color: color,
    locale: locale,
    isFirst: isFirst,
    isWithTitles: isLabels,
  );

  String? getThemeTitle(BuildContext context) {
    switch (sp!.getString("mode")) {
      case 'light':
        return AppLocalizations.of(context, 'lighttheme');
      case 'dark':
        return AppLocalizations.of(context, 'darktheme');
      case 'system':
        return AppLocalizations.of(context, 'systemtheme');
      default:
        return "";
    }
  }
}
