import '../../domain/entities/worker_count_entity.dart';

class WorkerCountModel extends WorkerCountEntity {
  const WorkerCountModel({
    super.id,
    super.value,
  });

  factory WorkerCountModel.fromJson(Map<String, dynamic> json) {
    return WorkerCountModel(
      id: json['key'] as int?,
      value: json['value'] as String?,
    );
  }
}