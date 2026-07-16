import 'package:dio/dio.dart';
import 'failures.dart';
import 'exceptions.dart';

class ErrorHandler {
  static Failure handleException(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is ServerException) {
      return ServerFailure(
        message: error.message,
      );
    }

    return ServerFailure(message: error.toString());
  }

  static Failure _handleDioException(DioException error) {
    final exception = DioServerException.fromDioException(error);

    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          message: exception.message,
        );

      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return ServerFailure(
          message: exception.message,
        );
      case DioExceptionType.transformTimeout:
        throw UnimplementedError();
    }
  }
}