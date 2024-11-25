import 'package:flutter/material.dart';
import 'index_page.dart'; // Index 페이지
import 'chart_page.dart'; // Chart 페이지
import 'portfolio_page.dart'; // Portfolio 페이지
import 'setting_page.dart'; // Settings 페이지

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false; // 로그인 상태

  // 페이지 목록
  final List<Widget> _pages = [
    IndexPage(isLoggedIn: false), // Index 페이지
    ChartsPage(), // Charts 페이지
    PortfolioPage(isLoggedIn: false), // Portfolio 페이지
    SettingsPage(), // Settings 페이지
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // 배경색 검정
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Index',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
