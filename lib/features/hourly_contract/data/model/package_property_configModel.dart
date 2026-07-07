import 'package:flutter/material.dart';
import '../../domain/entities/package_property_configEntity.dart';

class PackagePropertyConfigModel extends PackagePropertyConfigEntity {
  const PackagePropertyConfigModel({
    required super.type,
    super.round,
    super.color,
    super.isBold,
    super.isStrike,
  });

  factory PackagePropertyConfigModel.fromJson(Map<String, dynamic> json) {
    return PackagePropertyConfigModel(
      type: json['type'] ?? 'string',
      round: json['round'],
      color: _parseColor(json['style']?['color']),
      isBold: json['style']?['isBold'] == 'true',
      isStrike: json['style']?['isStrike'] == 'true',
    );
  }

  static Color? _parseColor(String? colorStr) {
    if (colorStr == null) return null;
    try {
      final cleanHex = colorStr.replaceAll('0x', '').replaceAll('#', '');
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      } else if (cleanHex.length == 8) {
        return Color(int.parse(cleanHex, radix: 16));
      }
    } catch (_) {
      return Colors.black;
    }
    return Colors.black;
  }
}