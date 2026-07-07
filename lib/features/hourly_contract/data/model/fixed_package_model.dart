import '../../domain/entities/selected_package_entity.dart';

class FixedPackageModel extends SelectedPackageEntity {
  const FixedPackageModel({
    required super.selectedHourlyPricingId,
    required super.displayName,
    required super.serviceId,
    required super.resourceGroupId,
    required super.resourceGroupName,
    required super.employeeNumber,
    required super.employeeNumberName,
    required super.hoursNumber,
    required super.visitHours,
    required super.weeklyVisits,
    required super.weeklyVisitName,
    required super.contractDuration,
    required super.contractDurationName,
    required super.visitShift,
    required super.visitShiftName,
    required super.timeSlotId,
    required super.timeSlotDisplayName,
    super.promotionCode,
    super.promotionCodeDescription,
    required super.oneVisitPrice,
    required super.totalVisits,
    required super.packagePrice,
    required super.totalPriceWithVatBeforePromotion,
    required super.discountAmount,
    required super.promotionTotalDiscountAmount,
    required super.priceAfterTotalDiscount,
    required super.finalPrice,
    required super.vatRate,
    required super.vatAmount,
    super.promotionOfferList,
  });

  factory FixedPackageModel.fromJson(Map<String, dynamic> json) {
    return FixedPackageModel(
      selectedHourlyPricingId: json['selectedHourlyPricingId'] ?? '',
      displayName: json['displayName'] ?? '',
      serviceId: json['serviceId'] ?? '',
      resourceGroupId: json['resourceGroupId'] ?? '',
      resourceGroupName: json['resourceGroupName'] ?? '',
      employeeNumber: json['employeeNumber'] ?? 0,
      employeeNumberName: json['employeeNumberName'] ?? '',
      hoursNumber: json['hoursNumber'] ?? 0,
      visitHours: json['visitHours'] ?? 0,
      weeklyVisits: json['weeklyVisits'] ?? 0,
      weeklyVisitName: json['weeklyVisitName'] ?? '',
      contractDuration: json['contractDuration'] ?? 0,
      contractDurationName: json['contractDurationName'] ?? '',
      visitShift: json['visitShift'] ?? 0,
      visitShiftName: json['visitShiftName'] ?? '',
      timeSlotId: json['timeSlotId'] ?? '',
      timeSlotDisplayName: json['timeSlotDisplayName'] ?? '',
      promotionCode: json['promotionCode'],
      promotionCodeDescription: json['promotionCodeDescription'],
      oneVisitPrice: (json['oneVisitPrice'] ?? 0).toDouble(),
      totalVisits: json['totalVisits'] ?? 0,
      packagePrice: (json['packagePrice'] ?? 0).toDouble(),
      totalPriceWithVatBeforePromotion: (json['totalPriceWithVatBeforePromotion'] ?? 0).toDouble(),
      discountAmount: (json['totalDiscountAmount'] ?? 0).toDouble(),
      promotionTotalDiscountAmount: (json['promotionTotalDiscountAmount'] ?? 0).toDouble(),
      priceAfterTotalDiscount: (json['priceAfterTotalDiscount'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      vatRate: (json['vatRate'] ?? 0).toDouble(),
      vatAmount: (json['vatAmount'] ?? 0).toDouble(),
      promotionOfferList: json['promotionOfferList'] != null
          ? (json['promotionOfferList'] as List)
          .map((i) => PromotionOfferModel.fromJson(i))
          .toList()
          : null,
    );
  }
}

class PromotionOfferModel extends PromotionOfferEntity {
  const PromotionOfferModel({
    required super.promotionOfferType,
    required super.promotionDescription,
  });

  factory PromotionOfferModel.fromJson(Map<String, dynamic> json) {
    return PromotionOfferModel(
      promotionOfferType: json['promotionOfferType'] ?? 0,
      promotionDescription: json['promotionDescription'] ?? '',
    );
  }
}