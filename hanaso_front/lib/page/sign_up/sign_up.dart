import 'package:flutter/material.dart';
import 'sign_up_controller.dart'; // コントローラーをインポート

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController _controller = SignUpController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('계정생성')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            Image(image: _controller.displayImage, width: 120, height: 120),
            // 画像を表示
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                await _controller.pickImage();
                setState(() {}); // 상태를 업데이트하고 UI를 다시 빌드합니다.
              },
              child: Text('사진 업로드'),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0), // 양옆에 빈 공간 추가
              child: TextField(
                controller: _controller.usernameController,
                decoration: InputDecoration(labelText: '사용자 이름'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0), // 양옆에 빈 공간 추가
              child: TextField(
                controller: _controller.passwordController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _controller.signUp(context),
              child: Text('계정생성'),
            ),
          ],
        ),
      ),
    );
  }
}
