import 'dart:convert';
import '../../domin/entities/user_entity.dart';

class UserModel extends UserEntity {
  final int? status;
  final String? message;
  final String? code;
  final LoginData? loginData;

  UserModel({this.status, this.message, this.code, this.loginData})
      : super(
    id: loginData?.user?.id,
    userName: loginData?.user?.userName,
    name: loginData?.user?.name,
    email: loginData?.user?.email,
    phoneNumber: loginData?.user?.phoneNumber,
    userPoint: loginData?.userPoint,
    twoFactorAuthEnabled: loginData?.twoFactorAuthEnabled,
    isGiftFound: loginData?.isGiftFound,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      message: json['message'],
      code: json['code'],
      loginData: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class LoginData {
  final String? accessToken;
  final UserInfo? user;
  final int? userPoint;
  final bool? twoFactorAuthEnabled;
  final bool? isGiftFound;

  LoginData({
    this.accessToken,
    this.user,
    this.userPoint,
    this.twoFactorAuthEnabled,
    this.isGiftFound,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    String? extractedToken;

    // فك تشفير الحقل النصي المعقد الخاص بالتوكن المستلم من السيرفر
    if (json['token'] != null && json['token'] is String) {
      try {
        final Map<String, dynamic> tokenMap = jsonDecode(json['token']);
        extractedToken = tokenMap['access_token'];
      } catch (e) {
        print("🔴 خطأ أثناء فك تشفير نص التوكن المدمج: $e");
      }
    }

    return LoginData(
      accessToken: extractedToken,
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
      userPoint: json['userPoint'],
      twoFactorAuthEnabled: json['twoFactorAuthEnabled'],
      isGiftFound: json['isGiftFound'],
    );
  }
}

class UserInfo {
  final String? id;
  final String? userName;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? securityStamp;

  UserInfo({
    this.id,
    this.userName,
    this.name,
    this.email,
    this.phoneNumber,
    this.securityStamp,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      userName: json['userName'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      securityStamp: json['securityStamp'],
    );
  }
}