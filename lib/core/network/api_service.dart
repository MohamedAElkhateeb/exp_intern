import 'dart:io';
import 'package:dio/dio.dart';
import 'package:exp_intern/core/storage/token_storage.dart';
import 'package:exp_intern/core/utils/endpoint_manager.dart';
import 'package:injectable/injectable.dart';

import '../interceptors/request_interceptor.dart';

@LazySingleton()
class ApiService {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  ApiService(this._tokenStorage) : _dio = Dio() {
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

          return handler.next(options);
        },
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    );
    _dio.interceptors.add(RequestInterceptor());

  }


  String _getPlatform() {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'unknown';
  }

  Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException {
      rethrow;
    }
  }

  Future<Response> postData({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (data != null) {
        return await _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
        );
      } else {
        return await _dio.post(
          path,
          queryParameters: queryParameters,
        );
      }
    } on DioException {
      rethrow;
    }
  }

  Future<Response> putData({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (data != null) {
        return await _dio.put(
          path,
          data: data,
          queryParameters: queryParameters,
        );
      } else {
        return await _dio.put(
          path,
          queryParameters: queryParameters,
        );
      }
    } on DioException {
      rethrow;
    }
  }

  Future<Response> deleteData({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (data != null) {
        return await _dio.delete(
          path,
          data: data,
          queryParameters: queryParameters,
        );
      } else {
        return await _dio.delete(
          path,
          queryParameters: queryParameters,
        );
      }
    } on DioException {
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



      switch (upperMethod) {
        case 'POST':
          if (data != null) {
            return await _dio.post(
              path,
              data: data,
              queryParameters: queryParameters,
            );
          } else {
            return await _dio.post(
              path,
              queryParameters: queryParameters,
            );
          }

        case 'PUT':
          if (data != null) {
            return await _dio.put(
              path,
              data: data,
              queryParameters: queryParameters,
            );
          } else {
            return await _dio.put(
              path,
              queryParameters: queryParameters,
            );
          }

        case 'DELETE':
          if (data != null) {
            return await _dio.delete(
              path,
              data: data,
              queryParameters: queryParameters,
            );
          } else {
            return await _dio.delete(
              path,
              queryParameters: queryParameters,
            );
          }

        default:
          return await _dio.get(
            path,
            queryParameters: queryParameters,
          );
      }
    } on DioException {
      rethrow;
    }
  }
}