import 'package:flutter/material.dart';

import 'app.dart';

Color getThemedBackgroundColor(BuildContext context){
  return Theme.of(context).brightness == Brightness.light ?
  App.colorLight : const Color(0xFF212121);
}

Color accent(context) => Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;

void showSnackBar(context, text) {
  final isLight = Theme.of(context).brightness == Brightness.light;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 12
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isLight ? Colors.white : Colors.grey[850],
      content: Text(
        text,
        style: TextStyle(color: isLight ? Colors.black : Colors.white),
      ),
    ),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}