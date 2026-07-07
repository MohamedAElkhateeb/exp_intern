import '../../domain/entities/shift_entity.dart';

class ShiftModel extends ShiftEntity {
  const ShiftModel({super.id, super.name, super.image});

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['key'] as int?,
      name: json['value'] as String?,
      image: json['image'] as String?,
    );
  }
}