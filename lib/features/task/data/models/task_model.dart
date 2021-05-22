import 'package:meta/meta.dart';
import 'package:estimationer/features/task/domain/entities/task.dart';

List<EstimatedTaskModel> tasksFromJson(List<Map<String, dynamic>> jsonTasks) => 
    jsonTasks.map((jT) => EstimatedTaskModel.fromJson(jT)).toList();

class EstimatedTaskModel extends EstimatedTask{
  EstimatedTaskModel({
    @required int id,
    @required String name,
    @required double pesimistic,
    @required double optimistic,
    @required double normal,
    @required double estimate,
    @required double uncertainty  
  }):super(
    id: id,
    name: name,
    pesimistic: pesimistic,
    optimistic: optimistic,
    normal: normal,
    estimate: estimate,
    uncertainty: uncertainty
  );

  factory EstimatedTaskModel.fromTask(EstimatedTask task)=>EstimatedTaskModel(
    id: task.id, 
    name: task.name, 
    pesimistic: task.pesimistic, 
    optimistic: task.optimistic, 
    normal: task.normal, 
    estimate: task.estimate, 
    uncertainty: task.uncertainty
  );

  factory EstimatedTaskModel.fromJson(Map<String, dynamic> json)=>EstimatedTaskModel(
    id: json['id'], 
    name: json['name'], 
    pesimistic: ( json['pesimistic'] as num ).toDouble(), 
    optimistic: ( json['optimistic'] as num ).toDouble(), 
    normal: ( json['normal'] as num ).toDouble(), 
    estimate: ( json['estimate'] as num ).toDouble(), 
    uncertainty: ( json['uncertainty'] as num ).toDouble()
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'name': this.name,
    'pesimistic': this.pesimistic,
    'optimistic': this.optimistic,
    'normal': this.normal,
    'estimate': this.estimate,
    'uncertainty': this.uncertainty,    
  };
}