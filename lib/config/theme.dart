import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme _getTextTheme(TextTheme baseTextTheme, bool isDark) {
    if (Platform.isIOS) {
      return baseTextTheme.copyWith(
        bodyLarge: TextStyle(
          fontFamily: 'Avenir',
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Avenir',
          color: isDark ? Colors.white : Colors.black,
        ),
      );
    } else {
      return GoogleFonts.baloo2TextTheme(baseTextTheme).copyWith(
        bodyLarge: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        headlineSmall: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
      );
    }
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.orange,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    textTheme: _getTextTheme(ThemeData.light().textTheme, false),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.orangeAccent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.orange,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: _getTextTheme(ThemeData.dark().textTheme, true),
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
      secondary: Colors.deepOrangeAccent,
    ),
  );
}
