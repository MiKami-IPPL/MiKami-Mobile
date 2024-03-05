import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6200EE),
  secondary: Color(0xFF03DAC6),
  surface: Color(0xFFFFFFFF),
  background: Color(0xFFFFFFFF),
  error: Color(0xFFB00020),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFF000000),
  onSurface: Color(0xFF000000),
  onBackground: Color(0xFF000000),
  onError: Color(0xFFFFFFFF),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFBB86FC),
  secondary: Color(0xFF03DAC6),
  surface: Color(0xFF121212),
  background: Color(0xFF121212),
  error: Color(0xFFCF6679),
  onPrimary: Color(0xFF000000),
  onSecondary: Color(0xFF000000),
  onSurface: Color(0xFFFFFFFF),
  onBackground: Color(0xFFFFFFFF),
  onError: Color(0xFF000000),
);

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF6200EE)),
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
      elevation: MaterialStateProperty.all<double>(0),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(15)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      )),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFFBB86FC)),
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF000000)),
      elevation: MaterialStateProperty.all<double>(0),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(15)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      )),
    ),
  ),
);
