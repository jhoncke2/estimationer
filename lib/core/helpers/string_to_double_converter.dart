import 'package:dartz/dartz.dart';
import 'package:estimationer/core/error/failures.dart';

abstract class InputValuesManager{
  Either<Failure, List<double>> convertListOfStringsToDoubles(List<String> strings);
  Either<Failure, void> evaluateStringValue(String value);
}

class InputValuesManagerImpl implements InputValuesManager{

  @override
  Either<Failure, List<double>> convertListOfStringsToDoubles(List<String> strings) {
    try{
      final List<double> values = [];
      for(String stringV in strings){
        if([null, ''].contains( stringV ))
          return Left(UncompleteInformationFailure());
        double value = double.parse(stringV);
        if(value <= 0)
          throw Exception();
        values.add(value);
      }
      return Right(values);
    }catch(exception){
      return Left(InputFormatFailure());
    }
  }

  @override
  Either<Failure, void> evaluateStringValue(String value) {
    if([null, ''].contains(value))
      return Left(UncompleteInformationFailure());
    else
      return Right(null);
  }

}