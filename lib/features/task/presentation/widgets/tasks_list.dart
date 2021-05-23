import 'package:estimationer/features/task/domain/entities/task.dart';
import 'package:estimationer/features/task/presentation/bloc/tasks_bloc.dart';
import 'package:estimationer/features/task/presentation/widgets/task_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_creater.dart';
// ignore: must_be_immutable
class TasksList extends StatelessWidget {
  final List<EstimatedTask> tasks;
  final bool isOnCreation;
  BuildContext context;
  TasksList({
    @required this.tasks,
    @required this.isOnCreation,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    this.context = context;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20
      ),
      child: SingleChildScrollView(
        child: Row(
          children: [
            _createLeftLine(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _createTasks(),
                _createPlusButton()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createLeftLine(){
    return Container(
      width: 15,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.0)
      ),
    );
  }

  Widget _createTasks(){
    List<Widget> tasksWidgets = tasks.map<Widget>(
      (t) => ExistingTask(task: t)
    ).toList();
    if(isOnCreation){
      tasksWidgets.add(TaskCreater());
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tasksWidgets,
      ),
    );
  }

  Widget _createPlusButton(){
    return MaterialButton(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0)
        )
      ),
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: isOnCreation? null : _initTaskCreation
    );
  }

  void _initTaskCreation(){
    BlocProvider.of<TasksBloc>(context).add(InitTaskCreation());
  }
}