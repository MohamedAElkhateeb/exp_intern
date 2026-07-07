import '../../domain/entity/dynamic_step_entity.dart';

class DynamicStepModel extends DynamicStepEntity {
  const DynamicStepModel({
    super.stepId,
    super.data,
    super.stepHeaderId,
    super.stepOrder,
    super.name,
    super.controller,
    super.action,
    super.nextStepAction,
    super.previousStepAction,
    super.httpMethod,
    super.stepKeyword,
    super.description,
    super.dbResourceName,
    super.dbResourceFieldName,
    super.iconClass,
    super.stepType,
    super.isAvailable,
    super.isAuthorized,
    super.isVisible,
  });

  factory DynamicStepModel.fromJson(Map<String, dynamic> json) {
    // استخراج الخريطة الداخلية لتفاصيل الخطوة إذا كانت موجودة في الـ JSON
    final stepDetails = json['stepDetailsVm'] as Map<String, dynamic>? ??
        json['stepDetails'] as Map<String, dynamic>?;

    return DynamicStepModel(
      // قراءة الحقول الأساسية من الـ JSON الخارجي
      stepId: json['stepId'] as String? ?? stepDetails?['stepId'] as String?,
      data: json['data'],

      // قراءة باقي الحقول من الكائن الداخلي (مع دعم قراءتها من الخارجي كاحتياط)
      stepHeaderId: stepDetails?['stepHeaderId'] as String? ?? json['stepHeaderId'] as String?,
      stepOrder: stepDetails?['stepOrder'] as int? ?? json['stepOrder'] as int?,
      name: stepDetails?['name'] as String? ?? json['name'] as String?,
      controller: stepDetails?['controller'] as String? ?? json['controller'] as String?,
      action: stepDetails?['action'] as String? ?? json['action'] as String?,
      nextStepAction: stepDetails?['nextStepAction'] as String? ?? json['nextStepAction'] as String?,
      previousStepAction: stepDetails?['previousStepAction'] as String? ?? json['previousStepAction'] as String?,
      httpMethod: stepDetails?['httpMethod'] as String? ?? json['httpMethod'] as String?,
      stepKeyword: stepDetails?['stepKeyword'] as String? ?? json['stepKeyword'] as String?,
      description: stepDetails?['description'] as String? ?? json['description'] as String?,
      dbResourceName: stepDetails?['dbResourceName'] as String? ?? json['dbResourceName'] as String?,
      dbResourceFieldName: stepDetails?['dbResourceFieldName'] as String? ?? json['dbResourceFieldName'] as String?,
      iconClass: stepDetails?['iconClass'] as String? ?? json['iconClass'] as String?,
      stepType: stepDetails?['stepType'] as int? ?? json['stepType'] as int?,
      isAvailable: stepDetails?['isAvailable'] as bool? ?? json['isAvailable'] as bool?,
      isAuthorized: stepDetails?['isAuthorized'] as bool? ?? json['isAuthorized'] as bool?,
      isVisible: stepDetails?['isVisible'] as bool? ?? json['isVisible'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepId': stepId,
      'data': data,
      'stepDetailsVm': {
        'stepId': stepId,
        'stepHeaderId': stepHeaderId,
        'stepOrder': stepOrder,
        'name': name,
        'controller': controller,
        'action': action,
        'nextStepAction': nextStepAction,
        'previousStepAction': previousStepAction,
        'httpMethod': httpMethod,
        'stepKeyword': stepKeyword,
        'description': description,
        'dbResourceName': dbResourceName,
        'dbResourceFieldName': dbResourceFieldName,
        'iconClass': iconClass,
        'stepType': stepType,
        'isAvailable': isAvailable,
        'isAuthorized': isAuthorized,
        'isVisible': isVisible,
      }
    };
  }
}