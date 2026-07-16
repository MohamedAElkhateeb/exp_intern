import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/endpoint_manager.dart'; // تأكد من إضافة مسار الـ Endpoint داخل الـ manager الخاص بك

@LazySingleton()
class PaymentDataSource {
  final ApiService _apiService;

  PaymentDataSource(this._apiService);

  Future<Response> getShopperResult({required String id, required int type}) async {
    return await _apiService.getData(
      path: EndpointsManager.shopperResult,
      queryParameters: {
        'id': id,
        'type': type,
      },
    );
  }
  Future<Response> getCheckOutId({
    required String id,
    required int type,
    required String cardBrand,
  }) async {
    return await _apiService.getData(
      path: EndpointsManager.createPaymentCheckout,
      queryParameters: {
        'id': id,
        'type': type,
        'CardBrand': cardBrand,
        'customerIP': '',
        'paymentSignature': '',
      },
    );
  }

}