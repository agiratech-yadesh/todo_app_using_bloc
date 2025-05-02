import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: const Color(0XFFF5DAD2),
      foregroundColor: const Color(0XFF75A47F),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Color(0XFFBACD92),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    subtitleTextStyle: TextStyle(color: Colors.white),
  ),
  scaffoldBackgroundColor: const Color(0XFFFCFFE0),
  dialogBackgroundColor: Colors.white,
  dialogTheme: const DialogTheme(
    barrierColor: Color(0XFFBACD92),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0XFFF5DAD2), foregroundColor: Color(0XFF75A47F)),
  bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white, modalBarrierColor: Color(0XFFFCFFE0)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0XFFFCFFE0),
      unselectedItemColor: Colors.black54,
      selectedItemColor: const Color(0XFF75A47F)),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0XFFFCFFE0),
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0XFF75A47F),
    brightness: Brightness.light,
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  listTileTheme: ListTileThemeData(
      tileColor: Colors.grey[800],
      titleTextStyle: const TextStyle(color: Color(0XFF75A47F), fontSize: 20),
      subtitleTextStyle: const TextStyle(color: Colors.white)),
  brightness: Brightness.dark,
  dialogBackgroundColor: Colors.grey[800],
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  dialogTheme: const DialogTheme(
    barrierColor: Colors.black,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0XFFF5DAD2),
      backgroundColor: const Color(0XFF75A47F),
    ),
  ),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(foregroundColor: Colors.white),
  bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.grey[800], modalBarrierColor: Colors.black),
  bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(backgroundColor: Colors.black),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0XFF75A47F),
    brightness: Brightness.dark,
  ),
);
