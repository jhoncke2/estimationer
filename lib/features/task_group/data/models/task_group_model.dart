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
    tasks: json['tasks']!=null? tasksFromJson(json['tasks'].cast<Map<String, dynamic>>()) : [],
    totalEstimate: json['total_estimate'],
    totalUncertainty: json['total_uncertainty'],
    initialDate: _getDateTimeFromString( json['initial_date'] ),
    finalDate: _getDateTimeFromString( json['final_date'] )
  );
  
  static DateTime _getDateTimeFromString(String stringDT){
    List<String> stringDTParts = stringDT.split('/');
    return DateTime(
      int.parse(stringDTParts[2]),
      int.parse(stringDTParts[1]),
      int.parse(stringDTParts[0])
    );
  }
}