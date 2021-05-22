import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class EstimatedTask extends Equatable{
  final int id;
  final String name;
  final double pesimistic;
  final double optimistic;
  final double normal;
  final double estimate;
  final double uncertainty;

  EstimatedTask({
    @required this.id, 
    @required this.name, 
    @required this.pesimistic, 
    @required this.optimistic, 
    @required this.normal, 
    @required this.estimate, 
    @required this.uncertainty
  });

  @override
  List<Object> get props => [
    this.id,
    this.name,
    this.pesimistic,
    this.optimistic,
    this.normal,
    this.estimate,
    this.uncertainty
  ];
}