import 'package:dartz/dartz.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task_group/domain/use_cases/params.dart';

class CalculateUncertainty implements UseCase<double, TaskCalculationParams>{
  @override
  Future<Either<Failure, double>> call(TaskCalculationParams params)async{
    final double uncertainty = (params.pesimistic - params.optimistic)/6;
    return Right(uncertainty);
  }
}