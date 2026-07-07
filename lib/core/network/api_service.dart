import 'dart:io';
import 'package:dio/dio.dart';
import 'package:exp_intern/core/storage/token_storage.dart';
import 'package:exp_intern/core/utils/endpoint_manger.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ApiService {
  final Dio _dio;
  final TokenStorage _tokenStorage; // 💡 تم التعديل: حقن الـ TokenStorage من الخارج للـ DI

  ApiService(this._tokenStorage) : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: EndpointsManager.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );
    _dio.interceptors.add(LogInterceptor(
        requestBody: true, responseBody: true, requestHeader: true));
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
      ),
    );
  }

  String _getPlatform() {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'unknown';
  }

  Future<Response> getData(
      {required String path, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException {
      rethrow;
    }
  }

  Future<Response> postData({required String path, Object? data,Map<String,dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path, data: data,queryParameters: queryParameters);
    } on DioException {
      rethrow;
    }
  }

  Future<Response> putData({required String path, Object? data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException {
      rethrow;
    }
  }

  Future<Response> deleteData({required String path, Object? data}) async {
    try {
      return await _dio.delete(path, data: data);
    }
    on DioException {
      rethrow;
    }
  }

  Future<Response> executeDynamicStep({
    required String path,
    required String method,
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    try {
      final String upperMethod = method.toUpperCase();
      if (upperMethod == 'POST') {
        return await _dio.post(path, data: data, queryParameters: queryParameters);
      } else if (upperMethod == 'PUT') {
        return await _dio.put(path, data: data, queryParameters: queryParameters);
      } else if (upperMethod == 'DELETE') {
        return await _dio.delete(path, data: data, queryParameters: queryParameters);
      } else {
        return await _dio.get(path, queryParameters: queryParameters);
      }
    } on DioException {
      rethrow;
    }
  }

}