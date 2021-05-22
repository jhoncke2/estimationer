import 'package:estimationer/features/task/presentation/bloc/tasks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnCreationTask extends StatefulWidget {

  const OnCreationTask({Key key}) : super(key: key);

  @override
  _OnCreationTaskState createState() => _OnCreationTaskState();
}

class _OnCreationTaskState extends State<OnCreationTask> {
  TextEditingController nameController;
  TextEditingController optimisticController;
  TextEditingController normalController;
  TextEditingController pesimisticController;
  TextEditingController estimateController;
  TextEditingController uncertaintyController;

  @override
  void initState() {
    nameController = TextEditingController();
    optimisticController = TextEditingController();
    normalController = TextEditingController();
    pesimisticController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OnTaskCreation blocState = BlocProvider.of<TasksBloc>(context).state;
    estimateController = TextEditingController(text: (blocState.estimate ?? '').toString());
    uncertaintyController = TextEditingController(text: (blocState.uncertainty ?? '').toString());
    return Container(
      child: Column(
        children: [
          _createTaskBody(),
          Container(
            width: MediaQuery.of(context).size.width * 0.59,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _createCancelButton(),
                _createSuccessButton()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createTaskBody(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.17,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.015),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(15)
        )
      ),
      child: _createInnerElements()
    );
  }

  Widget _createInnerElements(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _createTextField(nameController, 'Name'),
        Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _createTextField(optimisticController, 'Optimistic'),
                  _createTextField(normalController, 'Expected'),
                  _createTextField(pesimisticController, 'Pesimistic')
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.32,
              padding: EdgeInsets.only(left: 12.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _crateEstimationText('Estimate:'),
                  _crateEstimationText('Uncertainty:')
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _createTextField(TextEditingController controller, String hintText){
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.031,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crateEstimationText(String text){
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16
      ),
    );
  }

  Widget _createCancelButton(){
    return _createButton(
      Colors.red,
      Icons.delete,
      (){}
    );
  }

  Widget _createSuccessButton(){
    return _createButton(
      Colors.green,
      Icons.done,
      (){},
      RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15.0)
        )
      )
    );
  }

  Widget _createButton(Color backgroundColor, IconData icon, Function onPressed, [ShapeBorder shape]){
    return MaterialButton(
      color: backgroundColor,
      child: Icon(
        icon,
        size: 22.5,
        color: Colors.white
      ),
      shape: shape,
      onPressed: onPressed
    );
  }
}