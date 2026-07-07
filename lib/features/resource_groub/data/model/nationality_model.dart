import '../../domain/entities/nationality_entity.dart';

class NationalityModel extends NationalityEntity {
  const NationalityModel({
    super.image,
    super.hasPackage,
    super.id,
    super.name,
  });

  factory NationalityModel.fromJson(Map<String, dynamic> json) {
    return NationalityModel(
      image: json['image'] as String?,
      hasPackage: json['hasPackage'] as bool?,
      id: json['key'] as String?,
      name: json['value'] as String?,
    );
  }
}