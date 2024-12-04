import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/screens/pages/main_screen.dart';
import 'package:stock_app/screens/pages/login_page.dart';
import 'package:stock_app/screens/pages/signup_page.dart';
import 'package:stock_app/screens/utils/auth_provider.dart';
import 'package:stock_app/screens/utils/dark_mode_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider()..checkLoginStatus()),
        ChangeNotifierProvider(
          create: (_) => DarkModeProvider(), // 다크 모드 관리 Provider 추가
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        brightness:
            darkModeProvider.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: MainScreen(),
      routes: {
        '/login': (context) => LoginPage(), // 로그인 페이지
        '/signup': (context) => SignUpPage(), // 회원가입 페이지
      },
    );
  }
}
