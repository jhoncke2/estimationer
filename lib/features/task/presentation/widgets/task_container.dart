import 'package:estimationer/features/task/domain/entities/task.dart';
import 'package:estimationer/features/task/presentation/bloc/tasks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExistingTask extends StatelessWidget {
  final EstimatedTask task;
  ExistingTask({
    @required this.task,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(task.name),
          Row(
            children: [
              _createLeftData(task),
              _createRightData(task)
            ],
          )
        ],
      ),
    );
  }

  Widget _createLeftData(EstimatedTask task){
    return Column(
      children: [
        Text('O: ${task.optimistic}'),
        Text('N: ${task.normal}'),
        Text('P: ${task.pesimistic}')
      ],
    );
  }

  Widget _createRightData(EstimatedTask task){
    return Column(
      children: [
        Text('Est: ${task.estimate}'),
        Text('Unc: ${task.uncertainty}'),
      ],
    );
  }
}