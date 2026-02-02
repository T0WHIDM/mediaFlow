import 'package:flutter/material.dart';
import 'package:mediaflow/theme/my_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = dartMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
