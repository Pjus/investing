import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index_page.dart'; // Index 페이지
import 'chart_page.dart'; // Chart 페이지
import 'portfolio_page.dart'; // Portfolio 페이지
import 'setting_page.dart'; // Settings 페이지
import 'login_page.dart'; // 로그인 페이지

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false; // 로그인 상태

  // 페이지 목록 (로그인 여부에 따라 다르게 구성)
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

  Future<void> _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      _isLoggedIn = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(_isLoggedIn ? 'Welcome Back!' : 'Please Log In'),
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logOut,
            ),
        ],
      ),
      body: _isLoggedIn
          ? _pages[_selectedIndex] // 로그인된 사용자
          : Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  ).then((_) => _checkLoginStatus()); // 로그인 후 상태 갱신
                },
                child: Text('Log In'),
              ),
            ),
      bottomNavigationBar: _isLoggedIn
          ? BottomNavigationBar(
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
            )
          : null, // 비로그인 시 네비게이션 바 숨김
    );
  }
}
