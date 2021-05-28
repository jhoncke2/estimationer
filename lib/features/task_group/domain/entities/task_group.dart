import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:estimationer/features/task_group/domain/entities/task.dart';

class TaskGroup extends Equatable{
  final int id;
  final String name;
  final List<EstimatedTask> tasks;
  final double totalEstimate;
  final double totalUncertainty;
  final DateTime initialDate;
  final DateTime finalDate;

  TaskGroup({
    @required this.id, 
    @required this.name, 
    @required this.tasks, 
    @required this.totalEstimate, 
    @required this.totalUncertainty,
    @required this.initialDate,
    @required this.finalDate
  });

  @override
  List<Object> get props => [
    this.id,
    this.name,
    this.tasks,
    this.totalEstimate,
    this.totalUncertainty,
    this.initialDate,
    this.finalDate
  ];
}