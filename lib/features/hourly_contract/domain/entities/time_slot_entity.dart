class TimeSlotEntity {
  final String? key;
  final String? value;
  final String? minDate;
  final String? maxDate;
  final List<String>? enableDays;
  final List<dynamic>? disableDates;

  const TimeSlotEntity({
    this.key,
    this.value,
    this.minDate,
    this.maxDate,
    this.enableDays,
    this.disableDates,
  });
}