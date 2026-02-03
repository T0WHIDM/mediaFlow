import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
);

ThemeData dartMode = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
);
