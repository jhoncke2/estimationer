import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:estimationer/features/task_group/data/models/task_group_model.dart';
import 'package:estimationer/features/task_group/domain/entities/task_group.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:estimationer/core/error/exceptions.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task_group/data/data_source/local_data_source.dart';
import 'package:estimationer/features/task_group/data/models/task_model.dart';
import 'package:estimationer/features/task_group/data/repository/tasks_repository.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockTasksLocalDataSource extends Mock implements TasksLocalDataSource{}

TasksRepositoryImpl repository;
MockTasksLocalDataSource localDataSource;

void main(){
  setUp((){
    localDataSource = MockTasksLocalDataSource();
    repository = TasksRepositoryImpl(localDataSource: localDataSource);
  });

  group('getTaskGroup', (){
    TaskGroup tTaskGroup;
    setUp((){
      tTaskGroup = _getTaskGroupFromFixture();
    });

    test('should call the localDataSource method', ()async{
      await repository.getTaskGroup(tTaskGroup.id);
      verify(localDataSource.getTaskGroup(tTaskGroup.id));
    });

    test('should return Right(tTaskGroup) when all goes good', ()async{
      when(localDataSource.getTaskGroup(any)).thenAnswer((_) async => tTaskGroup);
      final result = await repository.getTaskGroup(tTaskGroup.id);
      expect(result, Right(tTaskGroup));
    });

    test('should return Left(DBFailure) when localDataSource throws a DBException', ()async{
      when(localDataSource.getTaskGroup(any)).thenThrow(DBException(type: DBExceptionType.PLATFORM));
      final result = await repository.getTaskGroup(tTaskGroup.id);
      expect(result, Left(DBFailure(type: DBFailureType.PLATFORM)));
    });
  });

  group('getTasks', (){
    List<EstimatedTaskModel> tTasks;
    setUp((){
      tTasks = _getTasksFromFixture();
    });

    test('should call the localDataSource method', ()async{
      when(localDataSource.getTasks()).thenAnswer((_) async => tTasks);
      await repository.getTasks();
      verify(localDataSource.getTasks());
    });

    test('should return Right(tTasks) when all goes good', ()async{
      when(localDataSource.getTasks()).thenAnswer((_) async => tTasks);
      final result = await repository.getTasks();
      expect(result, Right(tTasks));
    });

    test('should return Left(StorageFailure(x)) when localDataSource throws ServerFailure(x)', ()async{
      when(localDataSource.getTasks()).thenThrow(DBException(type: DBExceptionType.PLATFORM));
      final result = await repository.getTasks();
      expect(result, Left(DBFailure(type: DBFailureType.PLATFORM)));
    });
  });

  group('setTask', (){
    EstimatedTaskModel tTask;
    setUp((){
      tTask = _getTasksFromFixture()[0];
    });

    test('should call the localDataSource method', ()async{
      await repository.setTask(tTask);
      verify(localDataSource.setTask(tTask));
    });

    test('should return Right(null) when all goes good', ()async{
      final result = await repository.setTask(tTask);
      expect(result, Right(null));
    });

    test('should return Left(StorageFailure(x)) when localDataSource throws ServerFailure(x)', ()async{
      when(localDataSource.setTask(any)).thenThrow(DBException(type: DBExceptionType.PLATFORM));
      final result = await repository.setTask(tTask);
      expect(result, Left(DBFailure(type: DBFailureType.PLATFORM)));
    });
  });

  group('removeTask', (){
    EstimatedTaskModel tTask;
    setUp((){
      tTask = _getTasksFromFixture()[0];
    });
    
    test('should call the localDataSource method with the specified task id', ()async{
      await repository.removeTask(tTask);
      verify(localDataSource.removeTask(tTask.id));
    });

    test('should return Right(null) when all goes good', ()async{
      final result = await repository.removeTask(tTask);
      expect(result, Right(null));
    });

    test('should return Left(Failure(x)) when localDataSource returns any error', ()async{
      when(localDataSource.removeTask(any)).thenThrow(DBException(type: DBExceptionType.PLATFORM));
      final result = await repository.removeTask(tTask);
      expect(result, Left(DBFailure(type: DBFailureType.PLATFORM)));
    });
  });
}

List<EstimatedTaskModel> _getTasksFromFixture(){
  String stringTasks = callFixture('tasks.json');
  List<Map<String, dynamic>> jsonTasks = jsonDecode(stringTasks).cast<Map<String, dynamic>>();
  return tasksFromJson(jsonTasks);
}

TaskGroup _getTaskGroupFromFixture(){
  final String stringTaskGroup = callFixture('task_group.json');
  final Map<String, dynamic> jsonTG = jsonDecode(stringTaskGroup);
  return TaskGroupModel.fromJson(jsonTG);
}