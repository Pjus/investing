import 'package:flutter/material.dart';
import 'index_page.dart'; // Index 페이지
import 'chart_page.dart'; // Chart 페이지
import 'portfolio_page.dart'; // Portfolio 페이지
import 'setting_page.dart'; // Settings 페이지
import 'notification_page.dart'; // 알림 페이지
import 'account_page.dart'; // 계정 페이지
import 'auth_provider.dart'; // AuthProvider
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    IndexPage(), // Index 페이지
    ChartsPage(), // Charts 페이지
    PortfolioPage(), // Portfolio 페이지
    SettingsPage(), // Settings 페이지
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                MaterialPageRoute(builder: (context) =>  NotificationPage()),
              );
            },
          ),
          // 계정 아이콘
          IconButton(
            icon: authProvider.isLoggedIn
                ? const Icon(Icons.exit_to_app) // 로그인 상태일 때: 로그아웃 아이콘
                : const Icon(Icons.account_circle), // 비로그인 상태일 때: 계정 아이콘
            onPressed: () {
              if (authProvider.isLoggedIn) {
                // 로그인 상태: 로그아웃 처리
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 다이얼로그 닫기
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          authProvider.logOut(); // 로그아웃 처리
                          Navigator.pop(context); // 다이얼로그 닫기
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You have been logged out.'),
                            ),
                          );
                        },
                        child: const Text('Log Out'),
                      ),
                    ],
                  ),
                );
              } else {
                // 비로그인 상태: 로그인 및 회원가입 화면으로 이동
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Please log in or sign up'),
                    content: const Text('Choose an option to continue.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 다이얼로그 닫기
                          Navigator.pushNamed(context, '/login'); // 로그인 화면으로 이동
                        },
                        child: const Text('Log In'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 다이얼로그 닫기
                          Navigator.pushNamed(context, '/signup'); // 회원가입 화면으로 이동
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                );
              }
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
            label: 'Favorites',
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
