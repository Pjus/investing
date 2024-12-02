import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/auth_provider.dart'; // AuthProvider import

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: authProvider.isLoggedIn
          ? const Center(
              child: Text(
                'Your Portfolio Details Here',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please log in to view your portfolio.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
    );
  }
}
