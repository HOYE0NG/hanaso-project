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
        var attendance = List<String>.from(response.data['attendance']);
        var profileImg = response.data['profileImg'];
        //print(attendance);
        // ログイン情報を保存
        await saveLoginInfo(username, attendance, profileImg);
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful.')));
      } else {
        //print(response);
        throw Exception('Unexpected error occurred.');
      }
    }on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${(e as CustomException).message}')));
    } on TypeError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('A type error occurred: $e')));
      print(e);
    }
  }

  Future<void> saveLoginInfo(String username, List<String> attendance,String profileImg) async {
   // print("saveLoginInfo");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userProfileImageUrl', profileImg);
    // Save attendance data
    List<DateTime> attendanceData = attendance.map((date) => DateTime.parse(date)).toList();
    // Save attendance data as List<String> in SharedPreferences
    List<String> attendanceStringData = attendanceData.map((date) => date.toIso8601String()).toList();

    await prefs.setStringList('attendance', attendanceStringData);
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
