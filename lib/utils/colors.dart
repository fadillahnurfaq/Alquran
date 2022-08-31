import 'package:flutter/material.dart';

const Color appOrange = Color(0xFFE6704A);
const Color appWhite = Color(0xFFFAF8FC);
const Color appPurple = Color(0xFF431AA1);
const Color appPurpleDark = Color(0xFF1E0771);
const Color appPurpleLight1 = Color(0xFF9345F2);
const Color appPurpleLight2 = Color(0xFFB9A2D8);

const Color iconColor1 = Color(0xFFffd28d);
const Color iconColor2 = Color(0xFFfcab88);

ThemeData themeLight = ThemeData(
  brightness: Brightness.light,
  primaryColor: appPurple,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appPurpleDark,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: appPurple,
    elevation: 4,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      color: appPurpleDark,
    ),
    bodyText2: TextStyle(
      color: appPurpleDark,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: appPurpleDark,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appPurpleDark,
    unselectedLabelColor: Colors.grey,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: appPurpleDark),
      ),
    ),
  ),
);

ThemeData themeDark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: appPurpleLight2,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appWhite,
  ),
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: appPurpleDark,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      color: appWhite,
    ),
    bodyText2: TextStyle(
      color: appWhite,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: appWhite,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appWhite,
    unselectedLabelColor: Colors.grey,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: appWhite),
      ),
    ),
  ),
);
