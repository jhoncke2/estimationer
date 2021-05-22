import 'package:estimationer/features/task/presentation/bloc/tasks_bloc.dart';
import 'package:estimationer/features/task/presentation/widgets/tasks_list.dart';
import 'package:estimationer/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<TasksBloc>(
          create: (context) => sl(),
          child: Container(
            child: Column(
              children: [_createTitle(context), _createTasks()],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
    );
  }

  Widget _createTitle(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.125,
      child: Center(
        child: Text(
          'Módulo x',
          style: TextStyle(
              fontSize: 27.5,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).secondaryHeaderColor),
        ),
      ),
    );
  }

  Widget _createTasks() {
    return Container(
      child: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state){
          if(state is TasksEmpty){
            _addPostFrameCallBackWithBlocEvent(context, LoadTasks());
            return Text('Empty tasks');
          }else if(state is OnTasks){
            return TasksList(tasks: state.tasks, isOnCreation: false);
          }else if(state is OnTaskCreation){
            return TasksList(tasks: state.tasks, isOnCreation: true);
          }
          return Container();
        },
      ),
    );
  }

  void _addPostFrameCallBackWithBlocEvent(BuildContext context, TasksEvent event){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<TasksBloc>(context).add(event);
    });
  }
}
