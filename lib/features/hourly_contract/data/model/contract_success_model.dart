import '../../domain/entities/contract_success_entity.dart';

class ContractSuccessModel extends ContractSuccessEntity {
  const ContractSuccessModel({
    super.id,
    super.contractNo,
    super.finalPrice,
    super.paymentNote,
    super.canPay,
    super.contactName,
  });

  factory ContractSuccessModel.fromJson(Map<String, dynamic> json) {
    return ContractSuccessModel(
      id: json['id'],
      contractNo: json['contractNo'],
      finalPrice: json['finalPrice'],
      paymentNote: json['paymentNote'],
      canPay: json['canPay'],
      contactName: json['contactName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractNo': contractNo,
      'finalPrice': finalPrice,
      'paymentNote': paymentNote,
      'canPay': canPay,
      'contactName': contactName,
    };
  }
}