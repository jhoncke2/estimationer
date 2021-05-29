import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/core/error/failures.dart';
import 'package:estimationer/features/task_group/data/models/task_model.dart';
import 'package:estimationer/features/task_group/domain/entities/task.dart';
import 'package:estimationer/features/task_group/domain/repository/tasks_repository.dart';
import 'package:estimationer/features/task_group/domain/use_cases/get_tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTasksRepository extends Mock implements TasksRepository{}

GetTasks useCase;
MockTasksRepository repository;

void main(){
  setUp((){
    repository = MockTasksRepository();
    useCase = GetTasks(repository: repository);
  });

  group('call', (){
    List<EstimatedTask> tTasks;
    setUp((){
      tTasks = _getTasksFromFixture();
    });

    test('should call the repository method', ()async{
      when(repository.getTasks()).thenAnswer((_) async => Right(tTasks));
      final result = await useCase(NoParams());
      expect(result, Right(tTasks));
    });

    test('should return what the repository returns when all goes good', ()async{
      when(repository.getTasks()).thenAnswer((_) async => Left(DBFailure(type: DBFailureType.PLATFORM)));
      final result = await useCase(NoParams());
      expect(result, Left(DBFailure(type: DBFailureType.PLATFORM)));
      
    });
  });
}

List<EstimatedTask> _getTasksFromFixture(){
  String stringTasks = callFixture('tasks.json');
  List<Map<String, dynamic>> jsonTasks = jsonDecode(stringTasks).cast<Map<String, dynamic>>();
  return tasksFromJson(jsonTasks);
}