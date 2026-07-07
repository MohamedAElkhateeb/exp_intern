import '../../domain/entities/available_day_with_date_entity.dart';

class AvailableDayWithDateModel extends AvailableDayWithDateEntity {
  const AvailableDayWithDateModel({
    required super.dayName,
    required super.date,
  });

  factory AvailableDayWithDateModel.fromJson(Map<String, dynamic> json) {
    return AvailableDayWithDateModel(
      dayName: json['dayName'] ?? '',
      date: json['date'] ?? '',
    );
  }
}