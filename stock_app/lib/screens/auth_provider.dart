import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getString('accessToken') != null; // Access Token 확인
    notifyListeners();
  }

  Future<void> logIn() async {
    _isLoggedIn = true; // 로그인 상태로 변경
    notifyListeners();
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // JWT 삭제
    _isLoggedIn = false; // 로그아웃 상태로 변경
    notifyListeners();
  }
}
