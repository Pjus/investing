import 'package:flutter/material.dart';

class DarkModeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // 다크 모드 상태 변경
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // 시스템 설정 기반 초기화
  void initializeWithSystemSettings() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    notifyListeners();
  }
}
