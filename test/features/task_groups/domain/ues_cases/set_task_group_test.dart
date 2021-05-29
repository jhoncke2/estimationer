import 'package:estimationer/features/task_group/domain/entities/task_group.dart';
import 'package:estimationer/features/task_groups/domain/repository/task_groups_repository.dart';
import 'package:estimationer/features/task_groups/domain/use_cases/set_task_group.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTaskGroupsRepository extends Mock implements TaskGroupsRepository{}

SetTaskGroup useCase;
MockTaskGroupsRepository repository;

void main(){
  TaskGroup tTaskGroup;
  setUp((){
    repository = MockTaskGroupsRepository();
    useCase = SetTaskGroup(repository: repository);
    tTaskGroup = TaskGroup(
      id: null, 
      name: 'tg_1', 
      tasks: null, 
      totalEstimate: 10.8, 
      totalUncertainty: 2.3, 
      initialDate: DateTime.now(), 
      finalDate: DateTime.now()..add(Duration(days: 1))
    );
  });


  test('should call the repository method', ()async{
    await useCase(SetTaskGroupParams(taskGroup: tTaskGroup));
    verify(repository.setTaskGroup(tTaskGroup));
  });
}