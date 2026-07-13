import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/request_model.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      requestList.add(
        Request(
          url: response.requestOptions.baseUrl + response.requestOptions.path,
          header: json.encode(response.requestOptions.headers),
          body: response.requestOptions.data != null
              ? json.encode(response.requestOptions.data)
              : null,
          status: response.statusCode.toString(),
          response: json.encode(response.data),
          actionType: response.requestOptions.method,
        ),
      );
    } catch (e) {
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      requestList.add(
        Request(
          url: err.requestOptions.path,
          header: json.encode(err.requestOptions.headers),
          body: err.requestOptions.data != null
              ? json.encode(err.requestOptions.data)
              : null,
          status: err.response?.statusCode?.toString() ?? 'Error',
          response: err.response?.data != null
              ? json.encode(err.response?.data)
              : err.message,
          actionType: err.requestOptions.method,
        ),
      );
    } catch (e) {
    }
    handler.next(err);
  }
}