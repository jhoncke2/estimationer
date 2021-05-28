import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task_group/domain/entities/task.dart';
import 'package:estimationer/features/task_group/domain/repository/tasks_repository.dart';

class GetTasks implements UseCase<List<EstimatedTask>, NoParams>{
  
  final TasksRepository repository;

  GetTasks({
    @required this.repository
  });

  @override
  Future<Either<Failure, List<EstimatedTask>>> call(NoParams params)async{
    return await repository.getTasks();
  }

}