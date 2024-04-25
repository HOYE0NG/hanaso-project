import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class CustomException implements Exception {
  final String message;

  CustomException(this.message);
}

class ApiClient {
  late Dio _dio;
  late CookieJar _cookieJar;

  ApiClient() {
    _cookieJar = CookieJar();
    _dio = Dio();
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<Response> signUp(
      String username, String password, String imageUrl) async {
    try {
      Response response = await _dio.post(
        'http://10.0.2.2:4000/api/users',
        data: {
          'username': username,
          'password': password,
          'profileImg': imageUrl
        },
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userProfileImageUrl', response.data['profileImg']);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            throw CustomException('${e.response}');
          case 409:
            throw CustomException('중복된 닉네임입니다.');
          case 500:
            throw CustomException('서버에 에러가 발생했습니다.');
          default:
            throw CustomException('Unexpected error occurred: ${e.response}');
        }
      } else {
        throw Exception('Failed to register: ${e.message}');
      }
    }
  }

  Future<String> uploadImage(File? image) async {
    var uri = Uri.parse('http://10.0.2.2:4000/api/img/upload');
    var request = http.MultipartRequest('POST', uri);
    if (image == null) {
      ByteData data = await rootBundle.load('assets/default_avatar.png');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      request.files.add(http.MultipartFile.fromBytes(
        'img',
        bytes,
        filename: 'default_avatar.png',
        contentType: MediaType('image', 'png'),
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
        'img',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var result = jsonDecode(responseData);
      return result['url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> logout() async {
    try {
      Response response =
          await _dio.get('http://10.0.2.2:4000/api/users/logout');
      if (response.statusCode != 200) {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<Response> login(String username, String password) async {
    try {
      Response response = await _dio.post(
        'http://10.0.2.2:4000/api/users/login',
        //in android studio, it uses 10.0.2.2 as localhost
        data: {'username': username, 'password': password},
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userProfileImageUrl', response.data['profileImg']);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response);
        switch (e.response!.statusCode) {
          case 400:
            throw CustomException('${e.response}');
          case 401:
            throw CustomException('사용자를 찾을 수 없습니다.');
          case 500:
            throw CustomException('서버에 에러가 발생했습니다.');
          default:
            throw CustomException('Unexpected error occurred: ${e.response}');
        }
      } else {
        throw Exception('Failed to login: ${e.message}');
      }
    }
  }
}
