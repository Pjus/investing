import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/pages/main_screen.dart';
import 'package:stock_app/providers/auth_provider.dart';
import 'package:stock_app/providers/news_provider.dart';
import 'package:stock_app/routes.dart';
import 'package:stock_app/utils/dark_mode_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkLoginStatus(),  // AuthProvider 추가
        ),
        ChangeNotifierProvider(
          create: (_) => DarkModeProvider(), // 다크 모드 관리 Provider 추가
        ),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(), // NewsProvider 추가
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
      routes: appRoutes,
    );
  }
}
