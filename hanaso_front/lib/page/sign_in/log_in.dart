import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png'), // 로고 이미지. assets 폴더에 로고 이미지를 넣어주세요.
            Text(
              'hanaso',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50), // 간격
            ElevatedButton(
              onPressed: () {
                // 로그인 버튼 클릭 시 로그인 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: Text('로그인'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // 버튼 크기
              ),
            ),
            SizedBox(height: 20), // 간격
            OutlinedButton(
              onPressed: () {
                // 회원가입 버튼 클릭 시 회원가입 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('회원가입'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(200, 50), // 버튼 크기
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 로그인 페이지 구현
    return Scaffold();
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 회원가입 페이지 구현
    return Scaffold();
  }
}