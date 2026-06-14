// core/utils/validators.dart
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'locale_keys.g.dart';

class Validators {

  // فاليديشن الحقول المطلوبة
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '${fieldName} ${LocaleKeys.field_required.tr()}'
          : LocaleKeys.field_required.tr();
    }
    return null;
  }

  // فاليديشن الحقول الاختيارية (دايماً null)
  static String? optional(String? value) {
    return null;
  }

  // فاليديشن الأرقام
  static String? numeric(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.field_required.tr();
    }
    final number = num.tryParse(value.trim());
    if (number == null) {
      return LocaleKeys.enter_valid_number.tr();
    }
    return null;
  }

  // فاليديشن الإيميل
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.email_required.tr();
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return LocaleKeys.enter_valid_email.tr();
    }
    return null;
  }

  // فاليديشن رقم الموبايل المصري
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.phone_required.tr();
    }
    final phoneRegex = RegExp(r'^(01)[0-9]{9}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return LocaleKeys.enter_valid_phone.tr();
    }
    return null;
  }

  // فاليديشن كلمة المرور
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.password_required.tr();
    }
    if (value.length < 6) {
      return LocaleKeys.password_min_length.tr();
    }
    return null;
  }

  // فاليديشن تأكيد كلمة المرور
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.confirm_password_required.tr();
    }
    if (value != password) {
      return LocaleKeys.password_mismatch.tr();
    }
    return null;
  }

  // فاليديشن الاسم
  static String? name(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '${fieldName} ${LocaleKeys.field_required.tr()}'
          : LocaleKeys.field_required.tr();
    }
    if (value.trim().length < 2) {
      return LocaleKeys.name_min_length.tr();
    }
    return null;
  }
}