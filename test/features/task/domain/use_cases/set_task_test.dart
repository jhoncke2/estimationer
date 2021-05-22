import 'dart:convert';

import 'package:estimationer/features/task/data/models/task_model.dart';
import 'package:estimationer/features/task/domain/entities/task.dart';
import 'package:estimationer/features/task/domain/repository/tasks_repository.dart';
import 'package:estimationer/features/task/domain/use_cases/set_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTasksRepository extends Mock implements TasksRepository{}

SetTask useCase;
MockTasksRepository repository;

void main(){
  setUp((){
    repository = MockTasksRepository();
    useCase = SetTask(repository: repository);
  });

  group('call', (){
    EstimatedTask tTask;

    setUp((){
      tTask = _getTaskFromFixture();
    });

    test('should call the repository method', ()async{
      await useCase(SetTaskParams(
        task: tTask
      ));
      verify(repository.setTask(tTask));
    });

    
  });
}

EstimatedTask _getTaskFromFixture(){
  String stringTasks = callFixture('tasks.json');
  List<Map<String, dynamic>> jsonTasks = jsonDecode(stringTasks).cast<Map<String, dynamic>>();
  return tasksFromJson(jsonTasks)[0];
}