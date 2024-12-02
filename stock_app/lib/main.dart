import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/screens/main_screen.dart';
import 'package:stock_app/screens/login_page.dart';
import 'package:stock_app/screens/signup_page.dart';
import 'package:stock_app/screens/utils/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider()..checkLoginStatus()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData.dark(),
      home: MainScreen(),
      routes: {
        '/login': (context) => LoginPage(), // 로그인 페이지
        '/signup': (context) => SignUpPage(), // 회원가입 페이지
      },
    );
  }
}
