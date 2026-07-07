import '../../domain/entities/time_slot_entity.dart';

class TimeSlotModel extends TimeSlotEntity {
  const TimeSlotModel({
    super.key,
    super.value,
    super.minDate,
    super.maxDate,
    super.enableDays,
    super.disableDates,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      key: json['key'] as String?,
      value: json['value'] as String?,
      minDate: json['minDate'] as String?,
      maxDate: json['maxDate'] as String?,
      enableDays: (json['enableDays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      disableDates: json['disableDates'] as List<dynamic>?,
    );
  }
}