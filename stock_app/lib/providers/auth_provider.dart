import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isAdmin = false;
  String? _token; // JWT 토큰 저장

  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _isAdmin;
  String? get token => _token;

  Future<void> logIn(String token, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = true; // 로그인 상태로 변경
    _isAdmin = role == "admin"; // 관리자 권한 확인
    _token = token; // 로그인 시 받은 JWT 토큰 저장

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('accessToken', token);
    await prefs.setString('role', role); // 역할 저장
    notifyListeners();
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = false;
    _token = null; // 토큰 초기화
    _isAdmin = false;

    await prefs.remove('isLoggedIn');
    await prefs.remove('accessToken');
    await prefs.remove('role'); // 역할 삭제
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getString('accessToken') != null; // Access Token 확인
    _token = prefs.getString('accessToken'); // 저장된 JWT 토큰 가져오기
    _isAdmin = prefs.getString('role') == "admin"; // 역할 확인
    notifyListeners();
  }
}
