class UserEntity {
  final String? id;
  final String? userName;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final int? userPoint;
  final bool? twoFactorAuthEnabled;
  final bool? isGiftFound;

  UserEntity({
    this.id,
    this.userName,
    this.name,
    this.email,
    this.phoneNumber,
    this.userPoint,
    this.twoFactorAuthEnabled,
    this.isGiftFound,
  });
}