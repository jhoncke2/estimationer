import 'package:dartz/dartz.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task/domain/entities/task.dart';

abstract class TasksRepository{
  Future<Either<Failure, List<EstimatedTask>>> getTasks();
  Future<Either<Failure, void>> setTask(EstimatedTask task);
  Future<Either<Failure, void>> removeTask(EstimatedTask task);
}