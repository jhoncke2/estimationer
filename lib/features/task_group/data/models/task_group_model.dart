import 'package:meta/meta.dart';
import 'package:estimationer/features/task_group/data/models/task_model.dart';
import 'package:estimationer/features/task_group/domain/entities/task_group.dart';

class TaskGroupModel extends TaskGroup{
  TaskGroupModel({
    @required int id,
    @required String name,
    @required List<EstimatedTaskModel> tasks,
    @required double totalEstimate,
    @required double totalUncertainty,
    @required DateTime initialDate,
    @required DateTime finalDate,
  });

  factory TaskGroupModel.fromJson(Map<String, dynamic> json)=>TaskGroupModel(
    id: json['id'], 
    name: json['name'], 
    tasks: tasksFromJson(json['tasks']), 
    totalEstimate: json['totalEstimate'], 
    totalUncertainty: json['totalUncertainty'], 
    initialDate: json['initialDate'], 
    finalDate: json['finalDate']
  );
}