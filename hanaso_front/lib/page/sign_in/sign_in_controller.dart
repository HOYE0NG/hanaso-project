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
      //print(username+""+password);
      Response response = await _apiClient.login(username, password);
      if (response.statusCode == 200) {
        var username = response.data['username'];
        // ログイン情報を保存
        await saveLoginInfo(username);
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful.')));
      } else {
        //print(response);
        throw Exception('Unexpected error occurred.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${(e as CustomException).message}')));
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
