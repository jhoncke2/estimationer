part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class LoadTaskGroup extends TasksEvent{
  final int id;

  LoadTaskGroup({
    @required this.id
  });
}

class LoadTasks extends TasksEvent{}

class InitTaskCreation extends TasksEvent{}

class CalculateEstimateAndUncertainty extends TasksEvent{
  final String optimistic;
  final String normal;
  final String pesimistic;
  CalculateEstimateAndUncertainty({
    @required this.optimistic, 
    @required this.normal, 
    @required this.pesimistic
  });
}

class CancelTaskCreation extends TasksEvent{}

class CreateTask extends TasksEvent{
  final String name;
  final String optimistic;
  final String normal;
  final String pesimistic;
  CreateTask({
    @required this.name,
    @required this.optimistic,
    @required this.normal,
    @required this.pesimistic,
  });
}