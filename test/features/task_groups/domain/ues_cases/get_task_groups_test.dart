import 'package:estimationer/core/domain/use_cases/use_case.dart';
import 'package:estimationer/features/task_groups/domain/repository/task_groups_repository.dart';
import 'package:estimationer/features/task_groups/domain/use_cases/get_task_groups.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTaskGroupsRepository extends Mock implements TaskGroupsRepository{}

GetTaskGroups useCase;
MockTaskGroupsRepository repository;

void main(){
  setUp((){
    repository = MockTaskGroupsRepository();
    useCase = GetTaskGroups(repository: repository);
  });

  test('should call the repository method', ()async{
    await useCase(NoParams());
    verify(repository.getTaskGroups());
  });
}