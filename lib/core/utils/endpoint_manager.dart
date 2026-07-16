import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EndpointsManager {
  static const String baseUrl = 'https://mueen-apitest.azurewebsites.net/';

  static BuildContext? _context;

  static void init(BuildContext context) {
    _context = context;
  }

  static String get locale {
    try {
      if (_context != null) {
        return EasyLocalization.of(_context!)?.locale.languageCode ?? 'ar';
      }
      return 'ar';
    } catch (e) {
      return 'ar';
    }
  }

  static String _getLocalizedPath(String path) {
    return '/$locale/api$path';
  }

  static String get login => _getLocalizedPath('/Account/Login');

  static String get firstStep => _getLocalizedPath('/Steps/FirstStep');

  static String get savedAddress =>
      _getLocalizedPath('/SavedContactLocation/ContactSavedAddress');

  static String get servicesForService =>
      _getLocalizedPath('/Service/ServicesForService');

  static String generateDynamicPath({
    required String controller,
    required String action,
  }) {
    return _getLocalizedPath('/$controller/$action');
  }

  static String get nationalities =>
      _getLocalizedPath('/ResourceGroup/GetResourceGroupsByService');

  static String get shifts => _getLocalizedPath('/HourlyContract/Shifts');

  static String get contractDurations =>
      _getLocalizedPath('/HourlyContract/ContractDuration');

  static String get numOfVisits =>
      _getLocalizedPath('/HourlyContract/NumOfVisits');

  static String get numOfWorkers =>
      _getLocalizedPath('/HourlyContract/NumOfWorkers');

  static String get getTimeSlotByServiceIdForDD =>
      _getLocalizedPath('/HourlyTimeSlot/GetTimeSlotByServiceIdForDDL');

  static String get shiftHours =>
      _getLocalizedPath('/HourlyContract/ShiftHours');

  static String get getArrivalTime =>
      _getLocalizedPath('/HourlyTimeSlot/GetArrivalTime');

  static String get availableDaysWithDate =>
      _getLocalizedPath('/HourlyPricing/AvailableDaysWithDate');

  static String get fixedPackages =>
      _getLocalizedPath('/HourlyContract/FixedPackage');

  static String get hourlyPricing =>
      _getLocalizedPath('/HourlyPricing/HourlyPricing');

  static String get stepDetailsByActionName =>
      _getLocalizedPath('/Steps/StepDetailsByActionName');
  static String get contractSuccessData =>
      _getLocalizedPath('/HourlyContract/contractSuccessData');
  static String get shopperResult =>
      _getLocalizedPath('/Payment/ShopperResult');
  static String get createPaymentCheckout =>
      _getLocalizedPath('/Payment/CheckOutId');
}
