import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:estimationer/features/task_group/domain/entities/task_group.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task_groups/data/data_sources/task_groups_local_data_source.dart';
import 'package:estimationer/features/task_groups/domain/repository/task_groups_repository.dart';

class TaskGroupsRepositoryImpl implements TaskGroupsRepository{
  final TaskGroupsLocalDataSource localDataSource;

  TaskGroupsRepositoryImpl({
    @required this.localDataSource
  });
  
  @override
  Future<Either<Failure, List<TaskGroup>>> getTaskGroups() {
    // TODO: implement getTaskGroups
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setTaskGroup(TaskGroup taskGroup) {
    // TODO: implement setTaskGroup
    throw UnimplementedError();
  }

}