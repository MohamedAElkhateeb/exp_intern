class AddressEntity {
  final LocationItemEntity? mainLocation;
  final List<LocationItemEntity>? subLocations;

  const AddressEntity({this.mainLocation, this.subLocations});
}

class LocationItemEntity {
  final String? id;
  final String? displayValue;
  final String? cityName;
  final String? districtName;
  final bool? availableForHourly;
  final bool? availableForIndividual;
  final String? latitude;
  final String? longitude;

  const LocationItemEntity({
    this.id,
    this.displayValue,
    this.cityName,
    this.districtName,
    this.availableForHourly,
    this.availableForIndividual,
    this.latitude,
    this.longitude,
  });
}