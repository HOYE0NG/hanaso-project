import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hanaso_front/service/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? _image;
  final ApiClient _apiClient = ApiClient();

  ImageProvider<Object> displayImage =
      AssetImage('assets/default_avatar.png'); // デフォルト画像

  Future<void> signUp(BuildContext context) async {
    if (usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('아이디를 입력해주세요.')));
      return;
    }
    else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('비밀번호를 입력해주세요.')));
      return;
    }
    else if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('이미지를 업로드해주세요.')));
      return;
    }
    String imageUrl = await _apiClient.uploadImage(_image);
    try {
      Response response = await _apiClient.signUp(
          usernameController.text, passwordController.text, imageUrl);
      //print(response.statusCode);
      if (response.statusCode == 200) {
        var username = response.data['username'];
        var attendance = List<String>.from(response.data['attendance']);
        var profileImg = response.data['profileImg'];
        await saveLoginInfo(username, attendance, profileImg);
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('회원가입에 성공했습니다.')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to register user')));
      }
    } catch (e) {
      if (e is CustomException) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.message}')));
      } else if (e is FlutterError) {
        print(e.message);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.message}')));
      } else {
        throw e;
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      displayImage = FileImage(_image!) as ImageProvider<Object>;
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
