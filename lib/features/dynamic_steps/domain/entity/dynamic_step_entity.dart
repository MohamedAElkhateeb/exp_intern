class DynamicStepEntity {
  final String? stepId;
  final dynamic data;
  final String? stepHeaderId;
  final int? stepOrder;
  final String? name;
  final String? controller;
  final String? action;
  final String? nextStepAction;
  final String? previousStepAction;
  final String? httpMethod;
  final String? stepKeyword;
  final String? description;
  final String? dbResourceName;
  final String? dbResourceFieldName;
  final String? iconClass;
  final int? stepType;
  final bool? isAvailable;
  final bool? isAuthorized;
  final bool? isVisible;

  const DynamicStepEntity({
    this.stepId,
    this.data,
    this.stepHeaderId,
    this.stepOrder,
    this.name,
    this.controller,
    this.action,
    this.nextStepAction,
    this.previousStepAction,
    this.httpMethod,
    this.stepKeyword,
    this.description,
    this.dbResourceName,
    this.dbResourceFieldName,
    this.iconClass,
    this.stepType,
    this.isAvailable,
    this.isAuthorized,
    this.isVisible,
  });
}