import '../../domain/entities/contract_duration_entity.dart';

class ContractDurationModel extends ContractDurationEntity {
  const ContractDurationModel({super.id, super.value});

  factory ContractDurationModel.fromJson(Map<String, dynamic> json) {
    return ContractDurationModel(
      id: json['key'] as int?,
      value: json['value'] as String?,
    );
  }
}