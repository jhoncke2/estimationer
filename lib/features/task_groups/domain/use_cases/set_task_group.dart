import 'package:estimationer/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:estimationer/features/task_groups/domain/repository/task_groups_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/features/task_group/domain/entities/task_group.dart';

class SetTaskGroup implements UseCase<void, SetTaskGroupParams>{
  final TaskGroupsRepository repository;

  SetTaskGroup({
    @required this.repository
  });
  @override
  Future<Either<Failure, void>> call(SetTaskGroupParams params)async{
    return await repository.setTaskGroup(params.taskGroup);
  }

}

class SetTaskGroupParams extends Equatable{
  final TaskGroup taskGroup;
  SetTaskGroupParams({
    @required this.taskGroup
  });
  @override
  List<Object> get props => [this.taskGroup];
}