import 'package:dartz/dartz.dart';
import 'package:estimationer/features/task/domain/use_cases/calculate_estimate.dart';
import 'package:estimationer/features/task/domain/use_cases/params.dart';
import 'package:flutter_test/flutter_test.dart';

CalculateEstimate useCase;

void main(){
  setUp((){
    useCase = CalculateEstimate();
  });

  group('call', (){
    double tOptimistic;
    double tPesimistic;
    double tNormal;
    double tExpectedEstimate;
    setUp((){
      tOptimistic = 1.0;
      tPesimistic = 10.0;
      tNormal = 5.0;
      tExpectedEstimate = (tOptimistic + 4*tNormal + tPesimistic)/6;
    });

    test('should return Right(tExpectedEstimate) when all goes good', ()async{
      final result = await useCase(TaskCalculationParams(
        optimistic: tOptimistic,
        normal: tNormal,
        pesimistic: tPesimistic
      ));
      expect(result, Right(tExpectedEstimate));
    });
  });
}