class SelectedPackageEntity {
  final String selectedHourlyPricingId;
  final String displayName;
  final String serviceId;
  final String resourceGroupId;
  final String resourceGroupName;
  final int employeeNumber;
  final String employeeNumberName;
  final int hoursNumber;
  final int visitHours;
  final int weeklyVisits;
  final String weeklyVisitName;
  final int contractDuration;
  final String contractDurationName;
  final int visitShift;
  final String visitShiftName;
  final String timeSlotId;
  final String timeSlotDisplayName;
  final String? promotionCode;
  final String? promotionCodeDescription;
  final double oneVisitPrice;
  final int totalVisits;
  final double packagePrice;
  final double totalPriceWithVatBeforePromotion;
  final double discountAmount;
  final double promotionTotalDiscountAmount;
  final double priceAfterTotalDiscount;
  final double finalPrice;
  final double vatRate;
  final double vatAmount;
  final List<PromotionOfferEntity>? promotionOfferList;

  const SelectedPackageEntity({
    required this.selectedHourlyPricingId,
    required this.displayName,
    required this.serviceId,
    required this.resourceGroupId,
    required this.resourceGroupName,
    required this.employeeNumber,
    required this.employeeNumberName,
    required this.hoursNumber,
    required this.visitHours,
    required this.weeklyVisits,
    required this.weeklyVisitName,
    required this.contractDuration,
    required this.contractDurationName,
    required this.visitShift,
    required this.visitShiftName,
    required this.timeSlotId,
    required this.timeSlotDisplayName,
    this.promotionCode,
    this.promotionCodeDescription,
    required this.oneVisitPrice,
    required this.totalVisits,
    required this.packagePrice,
    required this.totalPriceWithVatBeforePromotion,
    required this.discountAmount,
    required this.promotionTotalDiscountAmount,
    required this.priceAfterTotalDiscount,
    required this.finalPrice,
    required this.vatRate,
    required this.vatAmount,
    this.promotionOfferList,
  });
}

class PromotionOfferEntity {
  final int promotionOfferType;
  final String promotionDescription;

  const PromotionOfferEntity({
    required this.promotionOfferType,
    required this.promotionDescription,
  });
}