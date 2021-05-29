import 'package:dartz/dartz.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task_group/domain/entities/task_group.dart';

abstract class TaskGroupsRepository{
  Future<Either<Failure, List<TaskGroup>>> getTaskGroups();
  Future<Either<Failure, void>> setTaskGroup(TaskGroup taskGroup);
}