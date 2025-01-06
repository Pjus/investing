import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Log in to view your portfolio.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
              },
              child: const Text('Log In'),
            ),
            const SizedBox(width: 20), // 버튼 사이의 공간
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup'); // 회원가입 페이지로 이동
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ],
    );
  }
}
