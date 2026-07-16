import 'package:flutter_hyperpay/flutter_hyperpay.dart';
import 'package:injectable/injectable.dart';
import '../payment/in_app_payment.dart';

@module
abstract class HyperpayModule {
  @lazySingleton
  FlutterHyperpay get flutterHyperpay {
    final isTest = InAppPaymentSetting.paymentMode == InAppPaymentSetting.TestMode;
    final mode = isTest ? PaymentMode.TEST : PaymentMode.LIVE;

    return FlutterHyperpay(
      channeleName: InAppPaymentSetting.channel,
      shopperResultUrl: InAppPaymentSetting.ShopperResultUrl,
      paymentMode: mode,
      lang: InAppPaymentSetting.getLang(),
    );
  }
}