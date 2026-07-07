import 'dart:convert';

import 'package:exp_intern/features/hourly_contract/data/model/package_property_configModel.dart';

import 'fixed_package_model.dart';
import '../../domain/entities/hourly_packages_result_entity.dart';

class HourlyPackagesResultModel extends HourlyPackagesResultEntity {
  const HourlyPackagesResultModel({
    required super.packages,
    required super.packageProperties,
  });

  factory HourlyPackagesResultModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> packagesList = json['selectedPackages'] as List? ?? [];
    final parsedPackages = packagesList.map((e) => FixedPackageModel.fromJson(e)).toList();

    Map<String, PackagePropertyConfigModel> parsedProperties = {};
    final rawPropertiesStr = json['packageProperties'];

    if (rawPropertiesStr != null && rawPropertiesStr is String && rawPropertiesStr.isNotEmpty) {
      try {
        final Map<String, dynamic> decodedMap = jsonDecode(rawPropertiesStr);
        decodedMap.forEach((key, value) {
          parsedProperties[key] = PackagePropertyConfigModel.fromJson(value);
        });
      } catch (_) {
        parsedProperties = {};
      }
    }

    return HourlyPackagesResultModel(
      packages: parsedPackages,
      packageProperties: parsedProperties,
    );
  }
}