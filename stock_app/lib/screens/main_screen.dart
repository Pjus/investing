import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index_page.dart'; // Index 페이지
import 'chart_page.dart'; // Chart 페이지
import 'portfolio_page.dart'; // Portfolio 페이지
import 'setting_page.dart'; // Settings 페이지
import 'notification_page.dart'; // 알림 페이지
import 'account_page.dart'; // 계정 페이지

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false; // 로그인 상태

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 로그인 상태 확인
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = loggedIn;
      _pages = [
        IndexPage(isLoggedIn: _isLoggedIn), // Index 페이지
        ChartsPage(), // Charts 페이지
        PortfolioPage(isLoggedIn: _isLoggedIn), // Portfolio 페이지
        SettingsPage(), // Settings 페이지
      ];
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Index Page'),
        actions: [
          // 알림 아이콘
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
          // 계정 아이콘
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
        ],
      ),
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
            label: 'Favoriates',
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
