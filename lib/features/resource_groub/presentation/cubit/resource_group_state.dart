
import '../../../../core/utils/request_status_enum.dart';
import '../../domain/entities/nationality_entity.dart';

class ResourceGroupState {
  final RequestStatus resourceGroupsStatus;
  final List<NationalityEntity> resourceGroups;
  final String? errorMessage;

  const ResourceGroupState({
    this.resourceGroupsStatus = RequestStatus.initial,
    this.resourceGroups = const [],
    this.errorMessage,
  });

  bool get isInitial => resourceGroupsStatus == RequestStatus.initial;
  bool get isLoading => resourceGroupsStatus == RequestStatus.loading;
  bool get isSuccess => resourceGroupsStatus == RequestStatus.success;
  bool get isError => resourceGroupsStatus == RequestStatus.error;

  ResourceGroupState copyWith({
    RequestStatus? resourceGroupsStatus,
    List<NationalityEntity>? resourceGroups,
    String? errorMessage,
  }) {
    return ResourceGroupState(
      resourceGroupsStatus: resourceGroupsStatus ?? this.resourceGroupsStatus,
      resourceGroups: resourceGroups ?? this.resourceGroups,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}