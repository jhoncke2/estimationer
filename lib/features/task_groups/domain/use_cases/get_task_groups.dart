import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/features/task_group/domain/entities/task_group.dart';
import 'package:estimationer/features/task_groups/domain/repository/task_groups_repository.dart';

class GetTaskGroups implements UseCase<List<TaskGroup>, NoParams>{
  final TaskGroupsRepository repository;

  GetTaskGroups({
    @required this.repository
  });

  @override
  Future<Either<Failure, List<TaskGroup>>> call(NoParams params)async{
    return await repository.getTaskGroups();
  }
}