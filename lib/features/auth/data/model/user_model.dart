// data/models/user_model.dart
import 'dart:convert';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? accessToken;

  UserModel({
    this.accessToken,
    super.id,
    super.userName,
    super.name,
    super.email,
    super.phoneNumber,
    super.securityStamp,
    super.crmUserId,
    super.userPoint,
    super.twoFactorAuthEnabled,
    super.isGiftFound,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? extractedToken;

    // فك تشفير التوكن بأمان
    if (json['token'] != null && json['token'] is String) {
      try {
        final Map<String, dynamic> tokenMap = jsonDecode(json['token']);
        extractedToken = tokenMap['access_token'];
      } catch (e) {
        print("🔴 خطأ أثناء فك تشفير نص التوكن المدمج: $e");
      }
    }

    // هنا بنفك الـ user object الداخلي لو جاي جوه حقل اسمه 'user'
    final Map<String, dynamic>? userMap = json['user'] as Map<String, dynamic>?;

    return UserModel(
      accessToken: extractedToken,
      // البيانات الأساسية بنقرأها من الـ user map الداخلي
      id: userMap?['id'] as String?,
      userName: userMap?['userName'] as String?,
      name: userMap?['name'] as String?,
      email: userMap?['email'] as String?,
      phoneNumber: userMap?['phoneNumber'] as String?,
      securityStamp: userMap?['securityStamp'] as String?,
      crmUserId: userMap?['crmUserId'] as String?, // 🌟 تم الإصلاح وقراءته بنجاح

      // البيانات الإضافية اللي جاية بره الـ user object مباشرة
      userPoint: json['userPoint'] as int?,
      twoFactorAuthEnabled: json['twoFactorAuthEnabled'] as bool?,
      isGiftFound: json['isGiftFound'] as bool?,
    );
  }
}