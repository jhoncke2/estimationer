import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/features/task/data/models/task_model.dart';
import 'package:estimationer/features/task/domain/entities/task.dart';
import 'package:estimationer/features/task/domain/use_cases/calculate_estimate.dart';
import 'package:estimationer/features/task/domain/use_cases/calculate_uncertainty.dart';
import 'package:estimationer/features/task/domain/use_cases/get_tasks.dart';
import 'package:estimationer/features/task/domain/use_cases/remove_task.dart';
import 'package:estimationer/features/task/domain/use_cases/set_task.dart';
import 'package:estimationer/features/task/presentation/bloc/tasks_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetTasks extends Mock implements GetTasks{}
class MockSetTask extends Mock implements SetTask{}
class MockRemoveTask extends Mock implements RemoveTask{}
class MockCalculateEstimate extends Mock implements CalculateEstimate{}
class MockCalculateUncertainty extends Mock implements CalculateUncertainty{}

TasksBloc bloc;
MockGetTasks getTasks;
MockSetTask setTask;
MockRemoveTask removeTask;
MockCalculateEstimate calculateEstimate;
MockCalculateUncertainty calculateUncertainty;

void main(){
  setUp((){
    calculateUncertainty = MockCalculateUncertainty();
    calculateEstimate = MockCalculateEstimate();
    removeTask = MockRemoveTask();
    setTask = MockSetTask();
    getTasks = MockGetTasks();
    bloc = TasksBloc(
      getTasks: getTasks, 
      setTask: setTask, 
      removeTask: removeTask,
      calculateEstimate: calculateEstimate,
      calculateUncertainty: calculateUncertainty
    );
  });

  test('initialization', (){
    expect(bloc.state, TasksEmpty());
  });

  group('getTasks', (){
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
        OnTaskCreation(
          tasks: tTasks,
          estimate: null,
          uncertainty: null
        )
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(InitTaskCreation());
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
      bloc.emit(OnTaskCreation(
        tasks: tTasks,
        estimate: tCreatedTask.estimate,
        uncertainty: tCreatedTask.uncertainty
      ));
    });

    test('should call the specified useCase', ()async{
      when(setTask.call(any)).thenAnswer((_) async => Right(null));
      when(getTasks.call(any)).thenAnswer((_) async => Right(tUpdatedTasks));
      bloc.add(CreateTask(
        name: tCreatedTask.name,
        optimistic: tCreatedTask.optimistic,
        normal: tCreatedTask.normal,
        pesimistic: tCreatedTask.pesimistic,
        task: tCreatedTask
      ));
      await untilCalled(setTask(any));
      verify(setTask(SetTaskParams(task: tCreatedTask)));
      await untilCalled(getTasks(any));
      verify(getTasks(NoParams()));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(setTask.call(any)).thenAnswer((_) async => Right(null));
      when(getTasks.call(any)).thenAnswer((_) async => Right(tUpdatedTasks));
      final expectedOrderedStates = [
        LoadingTasks(),
        OnTasks(tasks: tUpdatedTasks)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedOrderedStates));
      bloc.add(CreateTask(
        name: tCreatedTask.name,
        optimistic: tCreatedTask.optimistic,
        normal: tCreatedTask.normal,
        pesimistic: tCreatedTask.pesimistic,
        task: tCreatedTask
      ));
    });
  });

  group('calculateEstimateAndUncertainty', (){
    double tOptimistic;
    double tNormal;
    double tPesimistic;
    double tEstimate;
    double tUncertainty;
    setUp((){
      tOptimistic = 1.0;
      tNormal = 2.0;
      tPesimistic = 3.0;
      tEstimate = 4.0;
      tUncertainty = 0.5;
    });

    test('should call the specified useCases when all goes good', ()async{
      when(calculateEstimate.call(any)).thenAnswer((_)async => Right(tEstimate));
      when(calculateUncertainty.call(any)).thenAnswer((_)async => Right(tUncertainty));
      bloc.add(CalculateEstimateAndUncertainty(
        normal: tNormal.toString(),
        pesimistic: tPesimistic.toString(),
        optimistic: tOptimistic.toString()
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