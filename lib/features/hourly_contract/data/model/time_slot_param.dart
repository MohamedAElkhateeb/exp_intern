class TimeSlotParams {
  final String serviceId;
  final String stepId;
  final int shift;
  final int hours;

  TimeSlotParams({
    required this.serviceId,
    required this.stepId,
    required this.shift,
    required this.hours,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'stepId': stepId,
      'shift': shift,
      'hours': hours,
    };
  }
}