import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/pages/main_screen.dart';
import 'package:stock_app/providers/auth_provider.dart';
import 'package:stock_app/providers/news_provider.dart';
import 'package:stock_app/routes.dart';
import 'package:stock_app/utils/dark_mode_provider.dart';
import 'package:stock_app/providers/favorites_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider()..checkLoginStatus()),
        ChangeNotifierProvider(create: (_) => DarkModeProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
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
      home: const MainScreen(),
      routes: appRoutes, // 추가 라우트 관리
    );
  }
}
