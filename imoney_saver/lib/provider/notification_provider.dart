import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleProvider with ChangeNotifier {
  String _schedule = '';
  String get schedule => _schedule;
  SharedPreferences? _prefs;

  ScheduleProvider() {
    loadfromPrefs();
  }

  initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  loadfromPrefs() async {
    await initPrefs();
    _schedule = _prefs?.getString('notif') ?? '00:00';
    notifyListeners();
  }

  savetoPrefs() async {
    await initPrefs();
    _prefs?.setString('notif', _schedule);
  }

  setPrefs(String time) {
    _schedule = time;
    savetoPrefs();
    notifyListeners();
  }
}
