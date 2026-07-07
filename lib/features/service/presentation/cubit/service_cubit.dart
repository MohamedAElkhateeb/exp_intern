import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exp_intern/features/service/presentation/cubit/service_state.dart'; // تأكد من المسار
import 'package:injectable/injectable.dart';
import '../../domain/repositories/service_repository.dart';
@injectable
class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepository _repository;

  ServiceCubit(this._repository) : super(ServiceInitial());

  Future<void> getServices({required int serviceType}) async {
    emit(ServiceLoading());

    final result = await _repository.fetchServices(serviceType: serviceType);

    result.fold(
          (failure) => emit(ServiceError(failure)),
          (services) => emit(ServiceSuccess(services)),
    );
  }
}