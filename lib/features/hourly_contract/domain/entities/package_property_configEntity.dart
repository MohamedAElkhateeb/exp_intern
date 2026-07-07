import 'package:flutter/material.dart';

class PackagePropertyConfigEntity {
  final String type;
  final int? round;
  final Color? color;
  final bool isBold;
  final bool isStrike;

  const PackagePropertyConfigEntity({
    required this.type,
    this.round,
    this.color,
    this.isBold = false,
    this.isStrike = false,
  });
}