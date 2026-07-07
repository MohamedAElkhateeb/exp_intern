import 'package:exp_intern/features/hourly_contract/domain/entities/package_property_configEntity.dart';

import '../entities/selected_package_entity.dart';

class HourlyPackagesResultEntity {
  final List<SelectedPackageEntity> packages;
  final Map<String, PackagePropertyConfigEntity> packageProperties;

  const HourlyPackagesResultEntity({
    required this.packages,
    required this.packageProperties,
  });
}