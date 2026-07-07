import '../../domain/entities/num_of_visits_entity.dart';

class NumOfVisitsModel extends NumOfVisitsEntity {
  const NumOfVisitsModel({super.id, super.value});

  factory NumOfVisitsModel.fromJson(Map<String, dynamic> json) {
    return NumOfVisitsModel(
      id: json['key'] as int?,
      value: json['value'] as String?,
    );
  }
}