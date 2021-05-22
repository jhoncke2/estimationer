import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
abstract class Failure extends Equatable{
  final List properties;
  Failure({
    @required this.properties
  });

  @override
  List<Object> get props => properties;
}

enum DBFailureType{
  PLATFORM,
  NORMAL
}

class DBFailure extends Failure{
  final DBFailureType type;

  DBFailure({
    @required DBFailureType type
  }):
    this.type = type,
    super(
      properties: [type]
    );
}

class UncompleteInformationFailure extends Failure{
  
}