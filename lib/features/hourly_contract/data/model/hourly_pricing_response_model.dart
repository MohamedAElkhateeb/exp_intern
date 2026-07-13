import 'dart:convert';
import 'package:exp_intern/features/hourly_contract/data/model/package_property_configModel.dart';

class HourlyPricingResponseModel {
  final List<HourlyPackageModel> hourlyPackages;
  final Map<String, PackagePropertyConfigModel> packageProperties;

  HourlyPricingResponseModel({
    required this.hourlyPackages,
    required this.packageProperties,
  });

  factory HourlyPricingResponseModel.fromJson(Map<String, dynamic> json) {
    List<HourlyPackageModel> packages = [];
    Map<String, PackagePropertyConfigModel> properties = {};

    if (json['hourlyPackages'] != null) {
      packages = (json['hourlyPackages'] as List)
          .map((e) => HourlyPackageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (json['packageProperties'] != null) {
      final propsJson = json['packageProperties'];
      if (propsJson is String) {
        try {
          final decoded = jsonDecode(propsJson);
          properties = (decoded as Map<String, dynamic>).map((key, value) {
            return MapEntry(key, PackagePropertyConfigModel.fromJson(value));
          });
        } catch (_) {}
      }
    }

    return HourlyPricingResponseModel(
      hourlyPackages: packages,
      packageProperties: properties,
    );
  }
}

class HourlyPackageModel {
  final String hourlypricingId;
  final String? packageDisplayName;
  final String? resourceGroupName;
  final String? promotionCode;
  final double? packagePrice;
  final double? finalPrice;
  final double? oneVisitPrice;
  final double? promotionTotalDiscountAmount;
  final List<PromotionOfferModel>? promotionOfferList;
  final PromotionStateModel? promotionState;

  HourlyPackageModel({
    required this.hourlypricingId,
    this.packageDisplayName,
    this.resourceGroupName,
    this.promotionCode,
    this.packagePrice,
    this.finalPrice,
    this.oneVisitPrice,
    this.promotionTotalDiscountAmount,
    this.promotionOfferList,
    this.promotionState,
  });

  factory HourlyPackageModel.fromJson(Map<String, dynamic> json) {
    final packagePrice = (json['packagePrice'] as num?)?.toDouble() ?? 0;
    final totalDiscount = (json['totalDiscountAmount'] as num?)?.toDouble() ?? 0;

    return HourlyPackageModel(
      hourlypricingId: json['hourlypricingId'] ?? '',
      packageDisplayName: json['packageDisplayName'],
      resourceGroupName: json['resourceGroupName'],
      promotionCode: json['promotionCode'],
      packagePrice: packagePrice,
      finalPrice: packagePrice - totalDiscount,
      oneVisitPrice: (json['hourPrice'] as num?)?.toDouble(),
      promotionTotalDiscountAmount: totalDiscount,
      promotionOfferList: json['promotionOfferList'] != null
          ? (json['promotionOfferList'] as List)
          .map((e) => PromotionOfferModel.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
      promotionState: json['promotionState'] != null
          ? PromotionStateModel.fromJson(json['promotionState'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PromotionOfferModel {
  final int? promotionOfferType;
  final String? promotionDescription;

  PromotionOfferModel({this.promotionOfferType, this.promotionDescription});

  factory PromotionOfferModel.fromJson(Map<String, dynamic> json) {
    return PromotionOfferModel(
      promotionOfferType: json['promotionOfferType'],
      promotionDescription: json['promotionDescription'],
    );
  }
}

class PromotionStateModel {
  final String? promotionName;
  final int? promotionStatus;

  PromotionStateModel({this.promotionName, this.promotionStatus});

  factory PromotionStateModel.fromJson(Map<String, dynamic> json) {
    return PromotionStateModel(
      promotionName: json['promotionName'],
      promotionStatus: json['promotionStatus'],
    );
  }
}