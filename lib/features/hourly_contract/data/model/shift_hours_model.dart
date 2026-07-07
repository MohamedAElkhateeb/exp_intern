import 'package:exp_intern/features/hourly_contract/domain/entities/shift_hours_entity.dart';

class ShiftHoursModel extends ShiftHoursEntity {
  const ShiftHoursModel({super.id, super.value});

  factory ShiftHoursModel.fromJson(Map<String, dynamic> json) {
    return ShiftHoursModel(
      id: json['key'] as int?,
      value: json['value'] as String?,
    );
  }
}
