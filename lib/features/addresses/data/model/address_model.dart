import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    super.mainLocation,
    super.subLocations,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      mainLocation: json['mainLocations'] != null
          ? LocationItemModel.fromJson(json['mainLocations'] as Map<String, dynamic>)
          : null,
      subLocations: json['subLocation'] != null
          ? (json['subLocation'] as List)
          .map((e) => LocationItemModel.fromJson(e as Map<String, dynamic>))
          .toList()
          : const [],
    );
  }
}

class LocationItemModel extends LocationItemEntity {
  LocationItemModel({
    super.id,
    super.displayValue,
    super.cityName,
    super.districtName,
    super.availableForHourly,
    super.availableForIndividual,
    super.latitude,
    super.longitude,
  });

  factory LocationItemModel.fromJson(Map<String, dynamic> json) {
    return LocationItemModel(
      id: json['id'] as String?,
      displayValue: json['displayValue'] as String?,
      cityName: json['cityName'] as String?,
      districtName: json['districtName'] as String?,
      availableForHourly: json['availableForHourly'] as bool?,
      availableForIndividual: json['availableForIndividual'] as bool?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }
}