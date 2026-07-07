import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:exp_intern/core/utils/endpoint_manger.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_service.dart';

@LazySingleton()
class DynamicStepsDataSource {
  final ApiService _apiService;


  DynamicStepsDataSource(this._apiService);

  Future<Response> getFirstStep(
      {required int serviceType, required String serviceId}) async {
    return await _apiService.getData(
      path: EndpointsManager.firstStep,
      queryParameters: {
        "serviceType": serviceType,
        'Object': jsonEncode({'ServiceId': serviceId,'FromOffer': false,} ),
      },
    );
  }
}