import 'package:meta/meta.dart';
enum DBExceptionType{
  PLATFORM,
  NORMAL
}

class DBException implements Exception{
  final DBExceptionType type;

  DBException({
    @required this.type
  });
}