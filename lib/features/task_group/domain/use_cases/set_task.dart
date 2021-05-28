import 'package:estimationer/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:estimationer/features/task_group/domain/entities/task.dart';
import 'package:estimationer/features/task_group/domain/repository/tasks_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';

class SetTask implements UseCase<void, SetTaskParams>{

  final TasksRepository repository;

  SetTask({
    @required this.repository
  });

  @override
  Future<Either<Failure, void>> call(SetTaskParams params) {
    return repository.setTask(params.task);
  }
  
}

class SetTaskParams extends Equatable{
  final EstimatedTask task;

  SetTaskParams({
    @required this.task
  });

  @override
  List<Object> get props => [
    this.task
  ];
}