import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
class TaskCalculationParams extends Equatable{
  final double optimistic;
  final double pesimistic;
  final double normal;
  TaskCalculationParams({
    @required this.optimistic, this.pesimistic, this.normal
  });
  @override
  List<Object> get props => [this.optimistic, this.pesimistic, this.normal];
}