import 'package:flutter/material.dart';
import 'package:hanaso_front/service/api_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  Future<void> login(BuildContext context) async {
    try {
      String username = usernameController.text;
      String password = passwordController.text;
      Response response = await _apiClient.login(username, password);

      if (response.statusCode == 200) {
        var username = response.data['username'];
        // ログイン情報を保存
        await saveLoginInfo(username);
        Navigator.of(context).pushReplacementNamed('/home');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ログイン成功: $username')));
      } else if (response.statusCode == 401) {
        var reason = response.data['reason'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ログイン失敗: $reason')));
      } else {
        throw Exception('Unexpected error occurred.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ログインエラー: $e')));
    }
  }

  Future<void> saveLoginInfo(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setBool('isLoggedIn', true);
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
