class AvailableDaysParams {
  final String? selectedHourlyPricingId;
  final String resourceGroupId;
  final String serviceId;
  final String contractStartDate;
  final String contractDuration;
  final String hoursCount;
  final String empcount;
  final String weeklyvisits;
  final String visitShift;
  final String? promotionCode;
  final String days;
  final String timeSlotId;

  const AvailableDaysParams({
    this.selectedHourlyPricingId,
    required this.resourceGroupId,
    required this.serviceId,
    required this.contractStartDate,
    required this.contractDuration,
    required this.hoursCount,
    required this.empcount,
    required this.weeklyvisits,
    required this.visitShift,
    this.promotionCode,
    required this.days,
    required this.timeSlotId,
  });

  Map<String, dynamic> toJson() {
    return {
      'selectedHourlyPricingId': selectedHourlyPricingId,
      'resourceGroupId': resourceGroupId,
      'serviceId': serviceId,
      'contractStartDate': contractStartDate,
      'contractDuration': contractDuration,
      'hoursCount': hoursCount,
      'empcount': empcount,
      'weeklyvisits': weeklyvisits,
      'visitShift': visitShift,
      'promotionCode': promotionCode,
      'days': days,
      'timeSlotId': timeSlotId,
    };
  }
}