class ShopperResultEntity {
  final int? gateway;
  final PaymentCredentialsEntity? paymentCredentials;
  final bool? isBankTransferAvailable;
  final List<PaymentMethodEntity>? paymentMethods;

  const ShopperResultEntity({
    this.gateway,
    this.paymentCredentials,
    this.isBankTransferAvailable,
    this.paymentMethods,
  });
}

class PaymentCredentialsEntity {
  final String? contactId;
  final String? contactName;
  final String? sequenceNumber;
  final double? finalPrice;

  const PaymentCredentialsEntity({
    this.contactId,
    this.contactName,
    this.sequenceNumber,
    this.finalPrice,
  });
}

class PaymentMethodEntity {
  final String? brandName;
  final String? imageUrl;
  final String? imageDark;
  final int? order;

  const PaymentMethodEntity({
    this.brandName,
    this.imageUrl,
    this.imageDark,
    this.order,
  });
}