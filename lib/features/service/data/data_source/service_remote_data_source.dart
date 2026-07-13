import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/endpoint_manager.dart';

@LazySingleton()
class ServiceRemoteDataSource {
  final ApiService _apiService;

  ServiceRemoteDataSource(this._apiService);

  Future<Response> getServices({required int serviceType}) async {
    return await _apiService.getData(
      path: EndpointsManager.servicesForService,
      queryParameters: {
        'serviceType': serviceType,
      },
    );
  }
}