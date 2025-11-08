import 'package:flutter/material.dart';
import 'package:quiz_ai/models/user_model.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  User? _currentUser;

  ThemeMode get themeMode => _themeMode;
  User? get currentUser => _currentUser;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
