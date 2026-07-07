import 'package:dio/dio.dart';
import 'package:exp_intern/core/utils/endpoint_manger.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_service.dart';
@LazySingleton()
class AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSource(this._apiService);

  Future<Response> login({
    required String userName,
    required String password,
    bool rememberMe = true,
    String? autoFillCode,
  }) async {
    return await _apiService.postData(
      path: EndpointsManager.login,
      data: {
        "userName": userName,
        "password": password,
        "rememberMe": rememberMe,
        "autoFillCode": autoFillCode ?? "",
      },
    );
  }
}