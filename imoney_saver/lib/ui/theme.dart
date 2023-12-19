import 'package:flutter/material.dart';

MaterialColor _orangeColor = Colors.orange;
MaterialColor _greyColor = Colors.grey;

ThemeMode get lightThememode => ThemeMode.dark;
ThemeMode get darkThememode => ThemeMode.light;

class Themes {
  static final lightTheme = ThemeData(
      primarySwatch: _orangeColor,
      brightness: Brightness.light,
      textTheme: const TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle())
          .apply(bodyColor: _orangeColor, displayColor: _orangeColor));

  static final darkTheme = ThemeData(
      primarySwatch: _greyColor,
      brightness: Brightness.dark,
      textTheme: const TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle())
          .apply(bodyColor: _greyColor, displayColor: _greyColor));
}
