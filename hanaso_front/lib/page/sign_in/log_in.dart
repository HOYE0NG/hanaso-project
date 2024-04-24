import 'package:flutter/material.dart';
import 'package:hanaso_front/page/sign_in/sign_in.dart';
import 'package:hanaso_front/page/sign_up/sign_up.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png'),
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
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: Text('로그인'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
            SizedBox(height: 20), // 간격
            OutlinedButton(
              onPressed: () {
                // 회원가입 버튼 클릭 시 회원가입 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('회원가입'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

