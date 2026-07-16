import 'dart:io';

import '../utils/endpoint_manager.dart';


class InAppPaymentSetting {
  static const String paymentMode="TEST";
  static const String MADA="MADA";
  static const String APPLEPAY="APPLEPAY";
  static const String Credit="credit";
  static const String STC_PAY="STC_PAY";
  static const String ReadyUI="ReadyUI";
  static const String CustomUI="CustomUI";
  static const String gethyperpayresponse="gethyperpayresponse";
  static const String success="success";
  static const String SYNC="SYNC";
  static const String PayTypeSotredCard="PayTypeSotredCard";
  static const String PayTypeFromInput="PayTypeFromInput";
  static const String EnabledTokenization="true";
  static const String DisableTokenization="false";
  static const String ShopperResultUrl="com.example.exp_intern";
  static const String TestMode="TEST";
  static const String LiveMode="LIVE";
  static const String ApplePaybundel="merchant.com.excprotection.sracoapp";
  static const String CountryCode="SA";
  static const String CurrencyCode="SAR";
  static const String channel="Hyperpay.demo.fultter/channel";
  static String getLang(){
    bool isArabic = EndpointsManager.locale == "ar";
    if(Platform.isIOS){
      return isArabic?"ar":"en";
    }else{
      return isArabic?"ar_AR":"en_US";
    }
  }
}


class PaymentType {
  static const int HourlyContract = 1;
  static const int FlexibleService = 2;
  static const int IndividualContractRequest = 3;
  static const int IndividualContract = 4;
  static const int RenewIndividualContract = 5;
  static const int FinancialRequest = 6;
  static const int Enterprise = 7;
  static const int IndvProcedure = 8;
  static const int Points = 20;
}
