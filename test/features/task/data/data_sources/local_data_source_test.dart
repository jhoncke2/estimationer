import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:estimationer/core/platform/database.dart';
import 'package:estimationer/core/constant/constants.dart';
import 'package:estimationer/features/task_group/data/models/task_model.dart';
import 'package:estimationer/features/task_group/data/data_source/local_data_source.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockDataBaseManager extends Mock implements DataBaseManager{}

TasksLocalDataSourceImpl dataSource;
MockDataBaseManager dbManager;

void main(){
  setUp((){
    dbManager = MockDataBaseManager();
    dataSource = TasksLocalDataSourceImpl(dbManager: dbManager);
  });

  group('getTasks', (){
    List<Map<String, dynamic>> tJsonTasks;
    List<EstimatedTaskModel> tTasks;
    setUp((){
      tJsonTasks = jsonDecode( callFixture('tasks.json') ).cast<Map<String, dynamic>>();
      tTasks = tasksFromJson( tJsonTasks );
    });

    test('should call the dbManager method with the specified tableName', ()async{
      when(dbManager.queryAll(any)).thenAnswer((realInvocation) async => tJsonTasks);
      await dataSource.getTasks();
      verify(dbManager.queryAll(TASKS_TABLE_NAME));
    });

    test('should return the tasks returned from the dbManager', ()async{
      when(dbManager.queryAll(any)).thenAnswer((realInvocation) async => tJsonTasks);
      final List<EstimatedTaskModel> tasks = await dataSource.getTasks();
      expect(tasks, tTasks);
    });
  });

  group('setTask', (){
    int tNewId;
    EstimatedTaskModel tTask;
    setUp((){
      tNewId = 1;
      tTask = tasksFromJson( jsonDecode( callFixture('tasks.json') ).cast<Map<String, dynamic>>() )[0];
    });

    test('should call the dbManager method with the specified values', ()async{
      await dataSource.setTask(tTask);
      verify(dbManager.insert(TASKS_TABLE_NAME, tTask.toJson()));
    });

    test('should return the dbManager method returned value', ()async{
      when(dbManager.insert(any, any)).thenAnswer((_) async => tNewId);
      final int newId = await dataSource.setTask(tTask);
      expect(newId, tNewId);
    });
  });

  group('removeTask', (){
    EstimatedTaskModel tTask;
    setUp((){
      tTask = tasksFromJson( jsonDecode( callFixture('tasks.json') ).cast<Map<String, dynamic>>() )[0];
    });

    test('should call the dbManager method with the specified values', ()async{
      await dataSource.removeTask(tTask.id);
      verify(dbManager.remove(TASKS_TABLE_NAME, tTask.id));
    });
  });
}