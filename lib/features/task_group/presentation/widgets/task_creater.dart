import 'package:estimationer/features/task_group/presentation/widgets/task_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../bloc/tasks_bloc.dart';

class TaskCreater extends StatefulWidget {

  const TaskCreater({Key key}) : super(key: key);

  @override
  _TaskCreaterState createState() => _TaskCreaterState();
}

class _TaskCreaterState extends State<TaskCreater> {
  TextEditingController nameController;
  TextEditingController optimisticController;
  TextEditingController normalController;
  TextEditingController pesimisticController;

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
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              TaskContainer(
                topChild: _createNameTextField(), 
                leftChild: _createLeftElements(), 
                rightChild: _createRightElements(), 
                width: MediaQuery.of(context).size.width * 0.6, 
                height: MediaQuery.of(context).size.height * 0.17
              ),
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
          _createErrorMessage()
        ],
      ),
    );
  }

  Widget _createErrorMessage(){
    TasksState state = BlocProvider.of<TasksBloc>(context).state;
    if(state is TaskInputError){
      return Container(
        child: Center(
          child: Text(
            '${state.message}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor.withOpacity(0.9),
              fontSize: 15
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(17.5)
        ),
        margin: EdgeInsets.only(left: 5, top: MediaQuery.of(context).size.height * 0.02),
        padding: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.15,
        
      );
    }else
      return Container();
  }

  Widget _createLeftElements(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _createNumberTextField(optimisticController, 'Optimistic'),
          _createNumberTextField(normalController, 'Expected'),
          _createNumberTextField(pesimisticController, 'Pesimistic')
        ],
      ),
    );
  }
  
  Widget _createRightElements(){
    final TasksState state = BlocProvider.of<TasksBloc>(context).state;
    final String stringEstimate = _getStateEstimate(state);
    final String stringUncertainty = _getStateUncertainty(state);
    return Container(
      width: MediaQuery.of(context).size.width * 0.32,
      padding: EdgeInsets.only(left: 12.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _crateEstimationText('Estimate: $stringEstimate'),
          _crateEstimationText('Uncertainty: $stringUncertainty')
        ],
      ),
    );
  }

  String _getStateEstimate(TasksState state){
    if(state is OnGoodTaskCreation)
      return state.estimate != null? state.estimate.toStringAsFixed(2) : '';
    return '';
  }

  String _getStateUncertainty(TasksState state){
    if(state is OnGoodTaskCreation)
      return state.uncertainty != null? state.uncertainty.toStringAsFixed(2) : '';
    return '';
  }

  Widget _createNameTextField(){
    return _createTextField(this.nameController, 'name', TextInputType.name);
  }

  Widget _createNumberTextField(TextEditingController controller, String hintText){
    return _createTextField(controller, hintText, TextInputType.number);
  }

  Widget _createTextField(TextEditingController controller, String hintText, TextInputType keyboardType){
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.031,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
        onChanged: _onTextFieldChanged,
      ),
    );
  }

  void _onTextFieldChanged(String newValue){
    BlocProvider.of<TasksBloc>(context).add(CalculateEstimateAndUncertainty(
      optimistic: optimisticController.text,
      normal: normalController.text,
      pesimistic: pesimisticController.text
    ));
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
      (){
        BlocProvider.of<TasksBloc>(context).add(CancelTaskCreation());
      }
    );
  }

  Widget _createSuccessButton(){
    return _createButton(
      Colors.green,
      Icons.done,
      (){
        BlocProvider.of<TasksBloc>(context).add(CreateTask(
          name: nameController.text,
          optimistic: optimisticController.text,
          normal: normalController.text,
          pesimistic: pesimisticController.text
        ));
      },
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