import '../../../../core/errors/failures.dart';
import '../../domain/entity/service_entity.dart';

abstract class ServiceState {}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceSuccess extends ServiceState {
  final List<ServiceEntity> services;
  ServiceSuccess(this.services);
}

class ServiceError extends ServiceState {
  final Failure failure;
  ServiceError(this.failure);
}