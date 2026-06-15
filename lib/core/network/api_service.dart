import 'dart:io';
import 'package:dio/dio.dart';
import 'package:exp_intern/core/storage/token_storage.dart';
import 'package:exp_intern/core/utils/endpoint_manger.dart';

class ApiService {
  final Dio _dio;
  final TokenStorage _tokenStorage = TokenStorage();

  ApiService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: EndpointsManager.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          options.headers['source'] = '1';
          options.headers['version'] = '20.20.20';
          options.headers['platform'] = _getPlatform();

          final token = await _tokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('📤 ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  String _getPlatform() {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'unknown';
  }

  Future<Response> getData({required String path, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      // لو السيرفر رجع ريسبونس وفيه داتا مرره عشان نقرأ المسدج منه
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  Future<Response> postData({required String path, Object? data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      // لو السيرفر رجع ريسبونس وفيه داتا مرره عشان نقرأ المسدج منه
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  Future<Response> putData({required String path, Object? data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  Future<Response> deleteData({required String path, Object? data}) async {
    try {
      return await _dio.delete(path, data: data);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }
}