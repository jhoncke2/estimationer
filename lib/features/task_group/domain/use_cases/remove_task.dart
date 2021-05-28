import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:estimationer/features/task_group/domain/repository/tasks_repository.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task_group/domain/entities/task.dart';

class RemoveTask implements UseCase<void, RemoveTaskParams>{

  final TasksRepository repository;

  RemoveTask({
    @required this.repository
  });

  @override
  Future<Either<Failure, void>> call(RemoveTaskParams params)async{
    return await repository.removeTask(params.task);
  }

}

class RemoveTaskParams extends Equatable{
  final EstimatedTask task;
  RemoveTaskParams({
    @required this.task
  });

  @override
  List<Object> get props => [this.task];
}