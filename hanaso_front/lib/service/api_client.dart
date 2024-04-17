import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ApiClient {
  late Dio _dio;
  late CookieJar _cookieJar;

  ApiClient() {
    _cookieJar = CookieJar();
    _dio = Dio();
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<Response> login(String username, String password) async {
    try {
      Response response = await _dio.post(
        'http://localhost:4000/api/users/login',
        data: {'username': username, 'password': password},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
