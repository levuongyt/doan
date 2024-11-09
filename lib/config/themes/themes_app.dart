import 'package:flutter/material.dart';

class ThemesApp {
  static final light = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.green,
      appBarTheme: const AppBarTheme(color: Colors.blueAccent),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.grey[300],
      canvasColor: Colors.white,
      focusColor: Colors.grey[100],
      hintColor: Colors.grey,

      ///tabar, button
      indicatorColor: Colors.blueAccent,
      dividerColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ));

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.red,
    appBarTheme: AppBarTheme(color: Colors.blueGrey[900]),
    scaffoldBackgroundColor: Colors.black12,
    cardColor: Colors.grey[900],
    canvasColor: Colors.blueGrey[700],
    focusColor: Colors.grey[850],
    indicatorColor: Colors.blueGrey[700],
    dividerColor: Colors.black,
    hintColor: Colors.grey,
    textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )),
  );
}
