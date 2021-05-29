import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:estimationer/features/task_group/domain/entities/task_group.dart';
import 'package:estimationer/features/task_group/data/models/task_group_model.dart';
import 'package:estimationer/features/task_group/domain/use_cases/get_task_group.dart';
import 'package:estimationer/features/task_group/domain/repository/tasks_repository.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockTasksRepository extends Mock implements TasksRepository{}

GetTaskGroup useCase;
MockTasksRepository repository;

void main(){
  TaskGroup tTaskGroup;
  setUp((){
    repository = MockTasksRepository();
    useCase = GetTaskGroup(repository: repository);
    tTaskGroup = _getTaskGroupFromFixture();
  });

  test('should call the repository method', ()async{
    await useCase(TaskGroupParams(id: tTaskGroup.id));
    verify(repository.getTaskGroup(tTaskGroup.id));
  });

  test('should return the repository return', ()async{
    when(repository.getTaskGroup(any)).thenAnswer((_) async => Right(tTaskGroup));
    final result = await useCase(TaskGroupParams(id: tTaskGroup.id));
    expect(result, Right(tTaskGroup));
  });
}

TaskGroup _getTaskGroupFromFixture(){
  final String stringTaskGroup = callFixture('task_group.json');
  final Map<String, dynamic> jsonTG = jsonDecode(stringTaskGroup);
  return TaskGroupModel.fromJson(jsonTG);
}