import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../domain/repositories/nationality_repository.dart';
import 'resource_group_state.dart';

@injectable
class ResourceGroupCubit extends Cubit<ResourceGroupState> {
  final NationalityRepository _repo;

  ResourceGroupCubit(this._repo) : super(const ResourceGroupState());

  Future<void> getResourceGroups({required String serviceId}) async {
    emit(state.copyWith(resourceGroupsStatus: RequestStatus.loading));

    final result = await _repo.getNationalities(serviceId: serviceId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            resourceGroupsStatus: RequestStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (resourceGroupsList) {
        emit(
          state.copyWith(
            resourceGroupsStatus: RequestStatus.success,
            resourceGroups: resourceGroupsList,
          ),
        );
      },
    );
  }
}
