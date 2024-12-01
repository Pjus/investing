import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final url = Uri.parse(
        'http://127.0.0.1:8000/api/accounts/token/'); // Django 백엔드 JWT 엔드포인트

    try {
      final response = await http.post(
        url,
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        // 로그인 성공: JWT 토큰 저장
        final data = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['access']);
        await prefs.setString('refreshToken', data['refresh']);

        Navigator.pop(context); // 메인 페이지로 복귀
      } else {
        // 로그인 실패
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    } catch (error) {
      // 네트워크 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
