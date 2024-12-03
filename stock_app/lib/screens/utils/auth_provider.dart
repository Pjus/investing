import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token; // JWT 토큰 저장

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getString('accessToken') != null; // Access Token 확인
    _token = prefs.getString('accessToken'); // 저장된 JWT 토큰 가져오기

    notifyListeners();
  }

  Future<void> logIn(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = true; // 로그인 상태로 변경
    _token = token; // 로그인 시 받은 JWT 토큰 저장
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('accessToken', token);
    notifyListeners();
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = false;
    _token = null; // 토큰 초기화
    await prefs.remove('isLoggedIn');
    await prefs.remove('accessToken');
    notifyListeners();
  }
}
