import 'dart:async';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:hanaso_front/model/word.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hanaso_front/interface/user_interface.dart';
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
    _dio.interceptors.add(
      //Cookie jar doesn't work with Dio's InterceptorsWrapper :(
      InterceptorsWrapper(
        onRequest: (options, handler) async{
          final prefs = await SharedPreferences.getInstance();
          List<String>? cookies = prefs.getStringList('cookies');
          if (cookies != null) {
            options.headers['cookie'] = cookies.join('; ');
          }
          print('Request headers: ${options.headers}');
          return handler.next(options); // continue// Print request headers

        },
        onResponse: (response, handler) async{
          // Extract cookies from response headers and save them in CookieJar
          var cookies = response.headers['set-cookie'];
          print(cookies);
          if (cookies != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setStringList('cookies', cookies);
          }
          return handler.next(response); // continueue
        },
      ),
    );
  }

  Future<Response> signUp(
      String username, String password, String imageUrl) async {
    try {
      Response response = await _dio.post(
        '$BASE_URL/api/users',
        data: {
          'username': username,
          'password': password,
          'profileImg': imageUrl
        },
      );
      login(username, password);
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
    var uri = Uri.parse('$BASE_URL/api/img/upload');
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

  FutureOr<bool> logout() async {
    try {
      Response response =
          await _dio.get('$BASE_URL/api/users/logout');
      if (response.statusCode != 200) {
        throw Exception('Failed to logout');
      }
      else{
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Clear all data
        return true;
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<Response> login(String username, String password) async {
    try {
      Response response = await _dio.post(
        '$BASE_URL/api/users/login',
        //in android studio, it uses 10.0.2.2 as localhost
        data: {'username': username, 'password': password},
      );
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


  Future<List<Word>> getWords(int id) async {
    try {
      Response response = await _dio.get('$BASE_URL/api/words/$id');
      if (response.statusCode == 200) {
        List<Word> words = (response.data as List).map((i) => Word.fromJson(i)).toList();
        return words;
      } else {
        throw Exception('Failed to load words');
      }
    } catch (e) {
      throw Exception('Failed to load words: $e');
    }
  }
  Future<void> addFavorite(String id) async {
    try {
      await _dio.post('$BASE_URL/api/favorites', data: {'wordId': id});
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _dio.delete('$BASE_URL/api/favorites/$id');
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }


  Future<bool> saveAttendanceToServer(String username, String date) async {
    try {
      var url = '$BASE_URL/api/users/attendance'; // Replace with your actual API endpoint
      var response = await _dio.post(
        url,
        data: {
          'date': date,
        },
      );

      if (response.statusCode == 200) {
        print('Attendance data saved successfully.');
        return true;
      } else {
        print('Failed to save attendance data.');
        return false;
      }
    } catch (e) {
      print('Failed to save attendance data: $e');
      return false;
    }
  }
}


