import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:exp_intern/core/utils/locale_keys.g.dart';

abstract class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
}

class DioServerException extends ServerException {
  const DioServerException({required super.message, super.statusCode});

  factory DioServerException.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return DioServerException(message: LocaleKeys.connection_timeout_error.tr());
      case DioExceptionType.sendTimeout:
        return  DioServerException(message: LocaleKeys.send_timeout_error.tr());
      case DioExceptionType.receiveTimeout:
        return  DioServerException(message: LocaleKeys.receive_timeout_error.tr());
      case DioExceptionType.badCertificate:
        return  DioServerException(message: LocaleKeys.bad_certificate_error.tr());

      case DioExceptionType.badResponse:
        return DioServerException.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );

      case DioExceptionType.cancel:
        return  DioServerException(message: LocaleKeys.request_cancelled_error.tr());
      case DioExceptionType.connectionError:
        return  DioServerException(message: LocaleKeys.no_internet_error.tr());
      case DioExceptionType.unknown:
        return DioServerException(message: LocaleKeys.unexpected_error.tr());
    }
  }

  factory DioServerException.fromResponse(int? statusCode, dynamic response) {
    if (response != null && response is Map && response.containsKey('message')) {
      return DioServerException(
        message: response['message']?.toString() ?? LocaleKeys.unexpected_error.tr(),
        statusCode: statusCode,
      );
    }

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return DioServerException(message: LocaleKeys.unauthorized_error.tr(), statusCode: statusCode);
    } else if (statusCode == 404) {
      return DioServerException(message: LocaleKeys.request_not_found_error.tr(), statusCode: statusCode);
    } else if (statusCode == 500) {
      return DioServerException(message: LocaleKeys.server_internal_error.tr(), statusCode: statusCode);
    } else {
      return DioServerException(message: LocaleKeys.unexpected_error.tr(), statusCode: statusCode);
    }
  }
}

