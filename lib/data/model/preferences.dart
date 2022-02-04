import 'package:flutter/material.dart';

class Preferences {
  String? currentTheme;
  String? color;
  Locale? locale;
  bool? isFirst;
  bool? isWithTitles;

  Preferences({
    required this.currentTheme,
    required this.locale,
    required this.isFirst,
    required this.isWithTitles,
    required this.color
  });
}
