import 'package:dartz/dartz.dart';
import 'package:estimationer/core/error/exceptions.dart';
import 'package:estimationer/features/task/data/models/task_model.dart';
import 'package:meta/meta.dart';
import 'package:estimationer/features/task/data/data_source/local_data_source.dart';
import 'package:estimationer/features/task/domain/entities/task.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task/domain/repository/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository{

  final TasksLocalDataSource localDataSource;

  TasksRepositoryImpl({
    @required this.localDataSource
  });

  @override
  Future<Either<Failure, List<EstimatedTask>>> getTasks()async{
    try{
      return Right( await localDataSource.getTasks() );
    }on DBException catch(exception){
      return Left(DBFailure(
        type: _getFailureTypeFromExceptionType(exception.type)
      ));
    }
  }

  @override
  Future<Either<Failure, void>> setTask(EstimatedTask task)async{
    try{
      await localDataSource.setTask(EstimatedTaskModel.fromTask(task));
    return Right(null);
    }on DBException catch(exception){
      return Left(DBFailure(type: _getFailureTypeFromExceptionType(exception.type)));
    }
  }

  @override
  Future<Either<Failure, void>> removeTask(EstimatedTask task)async{
    try{
      await localDataSource.removeTask(task.id);
      return Right(null);
    }on DBException catch(exception){
      return Left(DBFailure(type: _getFailureTypeFromExceptionType(exception.type)));
    }
  }

  DBFailureType _getFailureTypeFromExceptionType(DBExceptionType type){
    return type == DBExceptionType.PLATFORM ? DBFailureType.PLATFORM : DBFailureType.NORMAL;
  }
}