import 'package:injectable/injectable.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/base_model.dart';
import '../../../../core/utils/endpoint_manger.dart';
import '../model/nationality_model.dart';

abstract class NationalityRemoteDataSource {
  Future<BaseResponse<List<NationalityModel>>> getNationalities({
    required String serviceId,
  });
}

@LazySingleton(as: NationalityRemoteDataSource)
class NationalityRemoteDataSourceImpl implements NationalityRemoteDataSource {
  final ApiService _apiService;

  NationalityRemoteDataSourceImpl(this._apiService);

  @override
  Future<BaseResponse<List<NationalityModel>>> getNationalities({
    required String serviceId,
  }) async {
    final response = await _apiService.getData(
      path: EndpointsManager.nationalities,
      queryParameters: {'serviceId': serviceId},
    );

    return BaseResponse.fromJson(
      response.data,
      (jsonT) =>
          (jsonT as List).map((e) => NationalityModel.fromJson(e)).toList(),
    );
  }
}
