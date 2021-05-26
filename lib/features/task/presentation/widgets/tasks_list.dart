import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:estimationer/core/presentation/notifiers/keyboard_notifier.dart';
import 'package:estimationer/features/task/domain/entities/task.dart';
import 'package:estimationer/features/task/presentation/bloc/tasks_bloc.dart';
import 'package:estimationer/features/task/presentation/widgets/existing_task.dart';
import '../../../../injection_container.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20
      ),
      child: ChangeNotifierProvider<KeyboardNotifier>(
        lazy: true,
        create: (_) => sl(),
        builder: (context, _){
          this.context = context;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createLeftLine(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _createTasks(),
                  _createTaskCreationComponent()
                ],
              )
            ],
          );
        } 
      ),
    );
  }

  Widget _createLeftLine(){
    final double heightPercent = 
      Provider.of<KeyboardNotifier>(context).isActive?
      0.45 : 
      0.7;
    return Container(
      width: 15,
      height: MediaQuery.of(context).size.height * heightPercent,
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      height: _getExistingTasksHeight(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tasksWidgets,
        ),
      )
    );
  }

  double _getExistingTasksHeight(){
    double heightFactor;
    double heightPercentage = 0.195;
    TasksState tasksState = BlocProvider.of<TasksBloc>(context).state;
    if(Provider.of<KeyboardNotifier>(context).isActive){
      heightFactor = 1;
    }else if(tasksState is OnGoodTaskCreation || tasksState is TaskInputError){
      heightFactor = 2;
    }else{
      heightFactor = (tasks.length < 4? tasks.length : 3).toDouble();
      
      (tasks.length % 3).toDouble();
      if(heightFactor == 0)
        heightFactor = 3;
    }
    if(heightFactor > 1)
        heightPercentage = 0.1855;
    double height = heightFactor * MediaQuery.of(context).size.height * heightPercentage;
    return height;
  }


  Widget _createTaskCreationComponent(){
    if(isOnCreation)
      return TaskCreater();
    else
      return _createPlusButton();
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
      onPressed: _initTaskCreation
    );
  }

  void _initTaskCreation(){
    BlocProvider.of<TasksBloc>(context).add(InitTaskCreation());
  }
}