import 'package:estimationer/features/task_group/data/models/task_group_model.dart';

abstract class TaskGroupsLocalDataSource{
  Future<List<TaskGroupModel>> getTaskGroups();
  Future<void> setTaskGroup(TaskGroupModel taskGroup);
}