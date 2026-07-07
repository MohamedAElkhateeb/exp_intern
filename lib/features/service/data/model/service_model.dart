import '../../domain/entity/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    required super.description,
    super.iconUrl,
    super.serviceNote,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      title: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'] as String?,
      serviceNote: json['serviceNote'] as String?,
    );
  }
}