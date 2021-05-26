import 'package:estimationer/features/task/domain/entities/task.dart';
import 'package:estimationer/features/task/presentation/widgets/task_container.dart';
import 'package:flutter/material.dart';

class ExistingTask extends StatelessWidget {
  final EstimatedTask task;
  ExistingTask({
    @required this.task,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TaskContainer(
        topChild: _createText(task.name), 
        leftChild: _createLeftData(context), 
        rightChild: _createRightData(),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.145,
      ),
    );
  }

  Widget _createLeftData(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createText('O: ${task.optimistic}'),
          _createText('N: ${task.normal}'),
          _createText('P: ${task.pesimistic}')
        ],
      ),
    );
  }

  Widget _createText(String text){
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18
      ),
    );
  }

  Widget _createRightData(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createText('Est: ${task.estimate.toStringAsFixed(3)}'),
        _createText('Unc: ${task.uncertainty.toStringAsFixed(3)}')
      ],
    );
  }
}