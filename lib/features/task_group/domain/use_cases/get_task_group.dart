import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task_group/domain/entities/task_group.dart';
import 'package:estimationer/features/task_group/domain/repository/tasks_repository.dart';


class GetTaskGroup implements UseCase<TaskGroup, TaskGroupParams>{
  final TasksRepository repository;

  GetTaskGroup({
    @required this.repository
  });
  @override
  Future<Either<Failure, TaskGroup>> call(TaskGroupParams params)async{
    return await repository.getTaskGroup(params.id);
  }

}

class TaskGroupParams extends Equatable{
  final int id;
  TaskGroupParams({
    @required this.id
  });
  @override
  List<Object> get props => [this.id];
}