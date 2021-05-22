import 'package:dartz/dartz.dart';
import 'package:estimationer/features/task/domain/use_cases/calculate_uncertainty.dart';
import 'package:estimationer/features/task/domain/use_cases/params.dart';
import 'package:flutter_test/flutter_test.dart';

CalculateUncertainty useCase;

void main(){
  setUp((){
    useCase = CalculateUncertainty();
  });

  group('call', (){
    double tOptimistic;
    double tPesimistic;
    double tNormal;
    double tExpectedUncertainty;
    setUp((){
      tOptimistic = 1.0;
      tPesimistic = 10.0;
      tNormal = 5.0;
      tExpectedUncertainty = (tPesimistic - tOptimistic)/6;
    });

    test('should return Right(tExpectedUncertainty)', ()async{
      final result = await useCase(TaskCalculationParams(
        optimistic: tOptimistic,
        normal: tNormal,
        pesimistic: tPesimistic
      ));
      expect(result, Right(tExpectedUncertainty));
    });
  });
}