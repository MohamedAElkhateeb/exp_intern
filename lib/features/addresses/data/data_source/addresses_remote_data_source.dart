// features/addresses/data/data_source/addresses_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/endpoint_manger.dart';

@LazySingleton()
class AddressesRemoteDataSource {
  final ApiService _apiService;


  AddressesRemoteDataSource(this._apiService);

  Future<Response> getSavedAddresses({required String contactId,String? serviceId,}) async {
    return await _apiService.getData(
      path: EndpointsManager.savedAddress,
      queryParameters: {
        'contactId': contactId,
        'serviceId': ?serviceId,

      },

    );
  }
}