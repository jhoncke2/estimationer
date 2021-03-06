import 'package:meta/meta.dart';
import 'package:estimationer/core/constant/constants.dart';
import 'package:estimationer/features/task_group/data/models/task_group_model.dart';
import 'package:estimationer/core/platform/database.dart';
import 'package:estimationer/features/task_group/data/models/task_model.dart';

abstract class TasksLocalDataSource{
  Future<TaskGroupModel> getTaskGroup(int id);
  Future<List<EstimatedTaskModel>> getTasks();
  Future<int> setTask(EstimatedTaskModel task);
  Future<void> removeTask(int task);
}

class TasksLocalDataSourceImpl implements TasksLocalDataSource{

  final DataBaseManager dbManager;

  TasksLocalDataSourceImpl({
    @required this.dbManager
  });

  @override
  Future<List<EstimatedTaskModel>> getTasks()async{
    return tasksFromJson( await dbManager.queryAll(TASKS_TABLE_NAME) );
  }

  @override
  Future<int> setTask(EstimatedTaskModel task)async{
    return await dbManager.insert(TASKS_TABLE_NAME, task.toJson());
  }

  @override
  Future<void> removeTask(int taskId)async{
    await dbManager.remove(TASKS_TABLE_NAME, taskId);
  }

  @override
  Future<TaskGroupModel> getTaskGroup(int id)async{
    final List<Map<String, dynamic>> jsonTasks = await dbManager.queryWhere(
      TASKS_TABLE_NAME, 
      '$TASKS_TASK_GROUP_ID = ?', 
      [id]
    );
    final Map<String, dynamic> jsonTaskGroup = await dbManager.querySingleOne(
      TASK_GROUPS_TABLE_NAME, 
      id
    );
    jsonTaskGroup['tasks'] = jsonTasks;
    return TaskGroupModel.fromJson(jsonTaskGroup);
  }
}