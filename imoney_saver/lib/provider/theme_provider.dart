import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneySaverThemeProvider with ChangeNotifier {
  bool _darkTheme = true;
  bool get darkTheme => _darkTheme;
  SharedPreferences? _prefs;

  MoneySaverThemeProvider() {
    loadfromPrefs();
  }

  initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  loadfromPrefs() async {
    await initPrefs();
    _darkTheme = _prefs?.getBool('theme') ?? true;
    notifyListeners();
  }

  savetoPrefs() async {
    await initPrefs();
    _prefs?.setBool('theme', _darkTheme);
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    savetoPrefs();
    notifyListeners();
  }
}
