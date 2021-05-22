import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/features/task/domain/use_cases/get_tasks.dart';
import 'package:estimationer/features/task/domain/use_cases/calculate_estimate.dart';
import 'package:estimationer/features/task/domain/use_cases/calculate_uncertainty.dart';
import 'package:estimationer/features/task/domain/use_cases/remove_task.dart';
import 'package:estimationer/features/task/domain/use_cases/set_task.dart';
import 'package:estimationer/features/task/domain/entities/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasks getTasks;
  final SetTask setTask;
  final RemoveTask removeTask;
  final CalculateEstimate calculateEstimate;
  final CalculateUncertainty calculateUncertainty;

  TasksBloc({
    @required this.getTasks,
    @required this.setTask,
    @required this.removeTask,
    @required this.calculateEstimate,
    @required this.calculateUncertainty
  }) : super(TasksEmpty());

  @override
  Stream<TasksState> mapEventToState(
    TasksEvent event,
  ) async* {
    if(event is LoadTasks){
      yield * _loadTasks(event);
    }else if(event is InitTaskCreation){
      yield * _initTaskCreation();
    }else if(event is CreateTask){
      yield * _createTask(event);
    }
  }

  Stream<TasksState> _loadTasks(LoadTasks event)async*{
    yield LoadingTasks();
    final eitherTasks = await getTasks(NoParams());
    yield * eitherTasks.fold((_)async*{

    }, (tasks)async*{
      yield OnTasks(tasks: tasks);
    });
  }

  Stream<TasksState> _initTaskCreation()async*{
    final List<EstimatedTask> tasks = (state as TasksLoaded).tasks;
    yield OnTaskCreation(
      tasks: tasks,
      estimate: null,
      uncertainty: null
    );
  }

  Stream<TasksState> _createTask(CreateTask event)async*{
    OnTaskCreation specifiedState = state;
    yield LoadingTasks();
    EstimatedTask newTask = EstimatedTask(
      id: null,
      name: event.name, 
      pesimistic: event.pesimistic, 
      optimistic: event.optimistic, 
      normal: event.normal, 
      estimate: specifiedState.estimate, 
      uncertainty: specifiedState.uncertainty
    );
    final eitherSetTask = await setTask(SetTaskParams(task: newTask));
    yield * eitherSetTask.fold((_)async *{

    }, (_)async *{
      final eitherGetTasks = await getTasks(NoParams());
      yield * eitherGetTasks.fold((_)async*{

      }, (tasks)async*{
        yield OnTasks(tasks: tasks);
      });
      
    });
  }
}
