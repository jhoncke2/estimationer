part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class TasksEmpty extends TasksState {}

class LoadingTasks extends TasksState {}

abstract class TasksLoaded extends TasksState{
  final List<EstimatedTask> tasks;
  TasksLoaded({
    @required this.tasks
  });
  @override
  List<Object> get props => [...super.props, this.tasks];
}

class OnTasks extends TasksLoaded{
  OnTasks({
    @required List<EstimatedTask> tasks
  }):super(tasks: tasks);
}


class OnGoodTaskCreation extends TasksLoaded{
  final double estimate;
  final double uncertainty;
  OnGoodTaskCreation({
    @required this.estimate,
    @required this.uncertainty,    
    @required List<EstimatedTask> tasks
  }):super(tasks: tasks);
  @override
  List<Object> get props => [
    ...super.props,
    this.estimate,
    this.uncertainty  
  ];
}

class LoadingTaskCreation extends TasksLoaded{}

class TaskInputError extends TasksLoaded{
  final String message;

  TaskInputError({
    @required this.message,
    @required List<EstimatedTask> tasks
  }):super(
    tasks: tasks
  );

  @override
  List<Object> get props => [
    ...super.props,
    this.message
  ];
}