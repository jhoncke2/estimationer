import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:estimationer/features/task_group/data/models/task_group_model.dart';
import 'package:estimationer/features/task_group/domain/entities/task_group.dart';
import 'package:estimationer/features/task_group/domain/use_cases/get_task_group.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/core/helpers/string_to_double_converter.dart';
import 'package:estimationer/features/task_group/data/models/task_model.dart';
import 'package:estimationer/features/task_group/domain/entities/task.dart';
import 'package:estimationer/features/task_group/domain/use_cases/calculate_estimate.dart';
import 'package:estimationer/features/task_group/domain/use_cases/calculate_uncertainty.dart';
import 'package:estimationer/features/task_group/domain/use_cases/get_tasks.dart';
import 'package:estimationer/features/task_group/domain/use_cases/params.dart';
import 'package:estimationer/features/task_group/domain/use_cases/remove_task.dart';
import 'package:estimationer/features/task_group/domain/use_cases/set_task.dart';
import 'package:estimationer/features/task_group/presentation/bloc/tasks_bloc.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockGetTaskGroup extends Mock implements GetTaskGroup{}
class MockGetTasks extends Mock implements GetTasks{}
class MockSetTask extends Mock implements SetTask{}
class MockRemoveTask extends Mock implements RemoveTask{}
class MockCalculateEstimate extends Mock implements CalculateEstimate{}
class MockCalculateUncertainty extends Mock implements CalculateUncertainty{}
class MockStringToDoubleConverter extends Mock implements InputValuesManager{}

TasksBloc bloc;
MockGetTaskGroup getTaskGroup;
MockGetTasks getTasks;
MockSetTask setTask;
MockRemoveTask removeTask;
MockCalculateEstimate calculateEstimate;
MockCalculateUncertainty calculateUncertainty;
MockStringToDoubleConverter inputsManager;

void main(){
  setUp((){
    inputsManager = MockStringToDoubleConverter();
    calculateUncertainty = MockCalculateUncertainty();
    calculateEstimate = MockCalculateEstimate();
    removeTask = MockRemoveTask();
    setTask = MockSetTask();
    getTasks = MockGetTasks();
    getTaskGroup = MockGetTaskGroup();
    bloc = TasksBloc(
      getTaskGroup: getTaskGroup,
      getTasks: getTasks, 
      setTask: setTask, 
      removeTask: removeTask,
      calculateEstimate: calculateEstimate,
      calculateUncertainty: calculateUncertainty,
      inputsManager: inputsManager
    );
  });

  test('initialization', (){
    expect(bloc.state, TasksEmpty());
  });

  group('loadTaskGroup', (){
    TaskGroup tTaskGroup;
    setUp((){
      tTaskGroup = _getTaskGroupFromFixture();
    });

    test('should call the specified usecase', ()async{
      when(getTaskGroup.call(any)).thenAnswer((_) async => Right(tTaskGroup));
      bloc.add(LoadTaskGroup(id: tTaskGroup.id));
      await untilCalled(getTaskGroup(any));
      verify(getTaskGroup(TaskGroupParams(id: tTaskGroup.id)));
    });
    
    test('should yield the specified states when all goes good', ()async{
      when(getTaskGroup.call(any)).thenAnswer((_) async => Right(tTaskGroup));
      final expectedOrderedStates = [
        LoadingTaskGroup(),
        OnTaskGroup(taskGroup: tTaskGroup)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(LoadTaskGroup(id: tTaskGroup.id));
    });
  });

  group('loadTasks', (){
    List<EstimatedTask> tTasks;
    setUp((){
      tTasks = _getTasksFromFixture();
    });

    test('should call the specified useCase', ()async{
      when(getTasks.call(any)).thenAnswer((_) async => Right(tTasks));
      bloc.add(LoadTasks());
      await untilCalled(getTasks.call(any));
      verify(getTasks(NoParams()));
    });

    test('should yield the specified states when all goes good', ()async{
      when(getTasks.call(any)).thenAnswer((_) async => Right(tTasks));
      final expectedOrderedStates = [
        LoadingTasks(),
        OnTasks(tasks: tTasks)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(LoadTasks());
    });
  });

  group('initTaskCreation', (){
    List<EstimatedTask> tTasks;
    setUp((){
      tTasks = _getTasksFromFixture();
      bloc.emit(OnTasks(tasks: tTasks));
    });
    
    test('should yield the specified ordered states', ()async{
      final expectedOrderedStates = [
        OnGoodTaskCreation(
          tasks: tTasks,
          estimate: null,
          uncertainty: null
        )
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(InitTaskCreation());
    });
  });


  group('calculateEstimateAndUncertainty', (){
    List<EstimatedTask> tTasks;
    double tOptimistic;
    double tNormal;
    double tPesimistic;
    double tEstimate;
    double tUncertainty;
    setUp((){
      tTasks = _getTasksFromFixture();
      tOptimistic = 1;
      tNormal = 1.8;
      tPesimistic = 5;
      tEstimate = 2.3;
      tUncertainty = 0.5;
      bloc.emit(OnGoodTaskCreation(estimate: null, uncertainty: null, tasks: tTasks));  
    });

    test('should call the useCases', ()async{
      when(inputsManager.convertListOfStringsToDoubles(any)).thenAnswer((_) => Right([tOptimistic, tNormal, tPesimistic]));
      when(calculateEstimate.call(any)).thenAnswer((_) async => Right(tEstimate));
      when(calculateUncertainty.call(any)).thenAnswer((_) async => Right(tUncertainty));
      bloc.add(CalculateEstimateAndUncertainty(
        optimistic: tOptimistic.toString(),
        normal: tNormal.toString(),
        pesimistic: tPesimistic.toString()
      ));

      await untilCalled(inputsManager.convertListOfStringsToDoubles(any));
      verify(inputsManager.convertListOfStringsToDoubles([
        tOptimistic.toString(),
        tNormal.toString(),
        tPesimistic.toString()
      ]));
      
      await untilCalled(calculateEstimate.call(any));
      verify(calculateEstimate.call(
        TaskCalculationParams(pesimistic: tPesimistic, normal: tNormal, optimistic: tOptimistic)
      ));
      
      await untilCalled(calculateUncertainty(any));
      verify(calculateUncertainty.call(
        TaskCalculationParams(pesimistic: tPesimistic, normal: tNormal, optimistic: tOptimistic)
      ));
      
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(inputsManager.convertListOfStringsToDoubles(any)).thenAnswer((_) => Right([tOptimistic, tNormal, tPesimistic]));
      when(calculateEstimate.call(any)).thenAnswer((_) async => Right(tEstimate));
      when(calculateUncertainty.call(any)).thenAnswer((_) async => Right(tUncertainty));
      final expectedOrderedStates = [
        OnGoodTaskCreation(estimate: tEstimate, uncertainty: tUncertainty, tasks: tTasks)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(CalculateEstimateAndUncertainty(
        optimistic: tOptimistic.toString(),
        normal: tNormal.toString(),
        pesimistic: tPesimistic.toString()
      ));
    });

    test('should yield the specified ordered states when inputs are not correct', ()async{
      when(inputsManager.convertListOfStringsToDoubles(any)).thenAnswer((_) => Left(InputFormatFailure()));
      when(calculateEstimate.call(any)).thenAnswer((_) async => Right(tEstimate));
      when(calculateUncertainty.call(any)).thenAnswer((_) async => Right(tUncertainty));
      final expectedOrderedStates = [
        TaskInputError(
          message: TasksBloc.BAD_INPUT_VALUE_MESSAGE, 
          tasks: tTasks
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(CalculateEstimateAndUncertainty(
        optimistic: tOptimistic.toString(),
        normal: tNormal.toString(),
        pesimistic: tPesimistic.toString()
      ));
    });

    test('should do nothing when converter return Left(UncompletInformationFailure())', ()async{
      when(inputsManager.convertListOfStringsToDoubles(any)).thenAnswer((_) => Left(UncompleteInformationFailure()));
      when(calculateEstimate.call(any)).thenAnswer((_) async => Right(tEstimate));
      when(calculateUncertainty.call(any)).thenAnswer((_) async => Right(tUncertainty));
      final expectedOrderedStates = [
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(CalculateEstimateAndUncertainty(
        optimistic: tOptimistic.toString(),
        normal: tNormal.toString(),
        pesimistic: tPesimistic.toString()
      ));
    });
  });

  group('cancelTaskCreation', (){
    List<EstimatedTask> tTasks;
    setUp((){
      tTasks = _getTasksFromFixture();
      bloc.emit(OnGoodTaskCreation(
        tasks: tTasks,
        estimate: null,
        uncertainty: null
      ));
    });

    test('should call the specified ordered states', ()async{
      final expectedOrderedStates = [
        OnTasks(tasks: tTasks)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(CancelTaskCreation());
    });
  });

  group('createTask', (){
    List<EstimatedTask> tTasks;
    List<EstimatedTask> tUpdatedTasks;
    EstimatedTask tCreatedTask;
    setUp((){
      tTasks = _getTasksFromFixture();
      tUpdatedTasks = [_getTasksFromFixture()[0]];
      tCreatedTask = _getTasksFromFixture()[0];
      tCreatedTask = _getTaskFromTaskModel(tCreatedTask);
      bloc.emit(OnGoodTaskCreation(
        tasks: tTasks,
        estimate: tCreatedTask.estimate,
        uncertainty: tCreatedTask.uncertainty
      ));
    });

    test('should call the specified useCase, transformations and evaluations', ()async{
      when(inputsManager.evaluateStringValue(any)).thenReturn(Right(null));
      when(inputsManager.convertListOfStringsToDoubles(any)).thenReturn(Right( [
        tCreatedTask.optimistic,
        tCreatedTask.normal,
        tCreatedTask.pesimistic
      ] ));
      when(setTask.call(any)).thenAnswer((_) async => Right(null));
      when(getTasks.call(any)).thenAnswer((_) async => Right(tUpdatedTasks));
      bloc.add(CreateTask(
        name: tCreatedTask.name,
        optimistic: tCreatedTask.optimistic.toString(),
        normal: tCreatedTask.normal.toString(),
        pesimistic: tCreatedTask.pesimistic.toString()
      ));

      await untilCalled(inputsManager.evaluateStringValue(any));
      verify(inputsManager.evaluateStringValue(tCreatedTask.name));
      await untilCalled(inputsManager.convertListOfStringsToDoubles(any));
      verify(inputsManager.convertListOfStringsToDoubles([
        tCreatedTask.optimistic.toString(),
        tCreatedTask.normal.toString(),
        tCreatedTask.pesimistic.toString()
      ]));
      await untilCalled(setTask(any));
      verify(setTask(SetTaskParams(task: tCreatedTask)));
      await untilCalled(getTasks(any));
      verify(getTasks(NoParams()));
    });

    
    test('should yield the specified ordered states when all goes good', ()async{
      when(inputsManager.evaluateStringValue(any)).thenReturn(Right(null));
      when(inputsManager.convertListOfStringsToDoubles(any)).thenReturn(Right( [
        tCreatedTask.optimistic,
        tCreatedTask.normal,
        tCreatedTask.pesimistic
      ] ));
      when(setTask.call(any)).thenAnswer((_) async => Right(null));
      when(getTasks.call(any)).thenAnswer((_) async => Right(tUpdatedTasks));
      final expectedOrderedStates = [
        LoadingTaskCreation(),
        OnTasks(tasks: tUpdatedTasks)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(CreateTask(
        name: tCreatedTask.name,
        optimistic: tCreatedTask.optimistic.toString(),
        normal: tCreatedTask.normal.toString(),
        pesimistic: tCreatedTask.pesimistic.toString()
      ));
    });

    test('''should yield the specified ordered states when 
    .evaluateString return Left(UNCOMPLETEINFORMATION())''', ()async{
      when(inputsManager.evaluateStringValue(any)).thenReturn(Left(UncompleteInformationFailure()));
      final expectedOrderedStates = [
        LoadingTaskCreation(),
        TaskInputError(message: TasksBloc.UNCOMPLETE_INPUT_VALUES, tasks: tTasks)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(CreateTask(
        name: tCreatedTask.name,
        optimistic: tCreatedTask.optimistic.toString(),
        normal: tCreatedTask.normal.toString(),
        pesimistic: tCreatedTask.pesimistic.toString()
      ));
    });

    test('''should yield the specified ordered states when 
    .evaluateString return Left(UNCOMPLETEINFORMATION())''', ()async{
      when(inputsManager.evaluateStringValue(any)).thenReturn(Right(null));
      when(inputsManager.convertListOfStringsToDoubles(any)).thenReturn(Left(UncompleteInformationFailure()));
      final expectedOrderedStates = [
        LoadingTaskCreation(),
        TaskInputError(message: TasksBloc.UNCOMPLETE_INPUT_VALUES, tasks: tTasks)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(CreateTask(
        name: tCreatedTask.name,
        optimistic: tCreatedTask.optimistic.toString(),
        normal: tCreatedTask.normal.toString(),
        pesimistic: tCreatedTask.pesimistic.toString()
      ));
    });
  });
}

List<EstimatedTask> _getTasksFromFixture(){
  final List<Map<String, dynamic>> jsonTasks = jsonDecode( callFixture('tasks.json') ).map(
    (jT){
      jT['id'] = null;
      return jT;
    }
  ).toList().cast<Map<String, dynamic>>();
  return tasksFromJson(jsonTasks);
}

EstimatedTask _getTaskFromTaskModel(EstimatedTaskModel tModel)=>EstimatedTask(
  id: null, 
  name: tModel.name, 
  pesimistic: tModel.pesimistic, 
  optimistic: tModel.optimistic, 
  normal: tModel.normal,
  estimate: tModel.estimate, 
  uncertainty: tModel.uncertainty
);

TaskGroup _getTaskGroupFromFixture(){
  final String sTaskGroup = callFixture('task_group.json');
  final Map<String, dynamic> jTaskGroup = jsonDecode(sTaskGroup);
  return TaskGroupModel.fromJson(jTaskGroup);
}