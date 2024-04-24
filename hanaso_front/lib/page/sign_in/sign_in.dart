import 'package:flutter/material.dart';
import 'package:hanaso_front/page/sign_in/sign_in_controller.dart';
import 'package:hanaso_front/page/sign_up/sign_up.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // SignInControllerのインスタンスを作成
  final SignInController _controller = SignInController();

  @override
  void dispose() {
    // コントローラのリソースを解放
    _controller.usernameController.dispose();
    _controller.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller.usernameController,
              decoration: InputDecoration(labelText: '사용자 이름'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _controller.passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _controller.login(context); // loginメソッドを呼び出す際にcontextを渡す
              },
              child: Text('로그인'),
            ),
            TextButton(
              onPressed: () {
                // 新規アカウント作成画面へ遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('계정 생성'),
            ),
          ],
        ),
      ),
    );
  }
}