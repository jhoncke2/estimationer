import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/core/helpers/string_to_double_converter.dart';
import 'package:estimationer/features/task/domain/use_cases/params.dart';
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
  static const BAD_INPUT_VALUE_MESSAGE = 'Todos los campos deben tener valores numéricos mayores a 0';
  static const UNCOMPLETE_INPUT_VALUES = 'Todos los campos deben estar llenos';

  final GetTasks getTasks;
  final SetTask setTask;
  final RemoveTask removeTask;
  final CalculateEstimate calculateEstimate;
  final CalculateUncertainty calculateUncertainty;
  final InputValuesManager inputsManager;

  TasksBloc({
    @required this.getTasks,
    @required this.setTask,
    @required this.removeTask,
    @required this.calculateEstimate,
    @required this.calculateUncertainty,
    @required this.inputsManager
  }) : super(TasksEmpty());

  @override
  Stream<TasksState> mapEventToState(
    TasksEvent event,
  ) async* {
    if(event is LoadTasks){
      yield * _loadTasks(event);
    }else if(event is InitTaskCreation){
      yield * _initTaskCreation();
    }else if(event is CalculateEstimateAndUncertainty){
      yield * _calculateEstimateAndUncertainty(event);
    }else if(event is CancelTaskCreation){
      yield * _cancelTaskCreation();
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

  Stream<TasksState> _calculateEstimateAndUncertainty(CalculateEstimateAndUncertainty event)async*{
    final List<EstimatedTask> tasks = (state as TasksLoaded).tasks;
    final eitherDoubleValues = inputsManager.convertListOfStringsToDoubles([
      event.optimistic,
      event.normal,
      event.pesimistic
    ]);

    yield * eitherDoubleValues.fold((failure)async*{
      if(failure is InputFormatFailure){
        yield TaskInputError(
          message: BAD_INPUT_VALUE_MESSAGE,
          tasks: tasks
        );
      }
    }, (values)async*{
      final TaskCalculationParams calcParams = TaskCalculationParams(
        optimistic: values[0],
        normal: values[1],
        pesimistic: values[2]
      );
      final eitherEstimate = await calculateEstimate(calcParams);
      yield * eitherEstimate.fold((_)async*{

      }, (estimate)async*{
        final eitherUncertainty = await calculateUncertainty(calcParams);
        yield * eitherUncertainty.fold((l)async*{

        }, (uncertainty)async*{
          yield OnTaskCreation(estimate: estimate, uncertainty: uncertainty, tasks: tasks);
        });
      });
    });
  }

  Stream<TasksState> _cancelTaskCreation()async*{
    final List<EstimatedTask> tasks = (state as TasksLoaded).tasks;
    yield OnTasks(tasks: tasks);
  }

  Stream<TasksState> _createTask(CreateTask event)async*{
    final double estimate = (state as OnTaskCreation).estimate;
    final double uncertainty = (state as OnTaskCreation).uncertainty;
    final List<EstimatedTask> tasks = (state as TasksLoaded).tasks;
    yield LoadingTaskCreation();
    final eitherNameEvaluation = inputsManager.evaluateStringValue(event.name);
    yield * eitherNameEvaluation.fold((_)async*{
      yield TaskInputError(message: UNCOMPLETE_INPUT_VALUES, tasks: tasks);
    }, (r)async*{
      final eitherDoubleValues = inputsManager.convertListOfStringsToDoubles([
        event.optimistic,
        event.normal,
        event.pesimistic
      ]);
      yield * eitherDoubleValues.fold((_)async*{
        yield TaskInputError(message: UNCOMPLETE_INPUT_VALUES, tasks: tasks);
      }, (values)async*{
        yield * _endTaskCreationProcess(event.name, values[0], values[1], values[2], estimate, uncertainty);
      });
    });
    
  }

  Stream<TasksState> _endTaskCreationProcess(String name, double optimistic, double normal, double pesimistic, double estimate, double uncertainty)async*{
    EstimatedTask newTask = EstimatedTask(
        id: null,
        name: name,
        optimistic: optimistic,
        normal: normal,
        pesimistic: pesimistic,
        estimate: estimate,
        uncertainty: uncertainty
      );
      final eitherSetTask = await setTask(SetTaskParams(task: newTask));
      yield * eitherSetTask.fold((_)async *{
        //TODO: Implement error management
      }, (_)async *{
        final eitherTasks = await getTasks(NoParams());       
        yield * eitherTasks.fold((l)async*{
          //TODO: Implement error managgement
        }, (tasks)async*{
          yield OnTasks(tasks: tasks);
        });
      });
  }

}
