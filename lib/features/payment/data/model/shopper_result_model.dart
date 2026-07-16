import '../../domain/entities/entity.dart';

class ShopperResultModel extends ShopperResultEntity {
  const ShopperResultModel({
    super.gateway,
    super.paymentCredentials,
    super.isBankTransferAvailable,
    super.paymentMethods,
  });

  factory ShopperResultModel.fromJson(Map<String, dynamic> json) {
    return ShopperResultModel(
      gateway: json['gatway'] as int?,
      isBankTransferAvailable: json['isbankTransferAvailable'] as bool?,
      paymentCredentials: json['paymentCredintials'] != null
          ? PaymentCredentialsModel.fromJson(json['paymentCredintials'] as Map<String, dynamic>)
          : null,
      paymentMethods: json['paymentMethods'] != null
          ? (json['paymentMethods'] as List)
          .map((item) => PaymentMethodModel.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
    );
  }
}

class PaymentCredentialsModel extends PaymentCredentialsEntity {
  const PaymentCredentialsModel({
    super.contactId,
    super.contactName,
    super.sequenceNumber,
    super.finalPrice,
  });

  factory PaymentCredentialsModel.fromJson(Map<String, dynamic> json) {
    return PaymentCredentialsModel(
      contactId: json['contactId'] as String?,
      contactName: json['contactName'] as String?,
      sequenceNumber: json['sequenceNumber'] as String?,
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
    );
  }
}

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    super.brandName,
    super.imageUrl,
    super.imageDark,
    super.order,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      brandName: json['brandName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      imageDark: json['imageDark'] as String?,
      order: json['order'] as int?,
    );
  }
}