import 'package:flutter/material.dart';
class TaskContainer extends StatelessWidget {
  final Widget topChild;
  final Widget leftChild;
  final Widget rightChild;
  final double width;
  final double height;
  TaskContainer({
    @required this.topChild,
    @required this.leftChild,
    @required this.rightChild,
    @required this.width,
    @required this.height, 
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.015),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(15)
        )
      ),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        topChild,
        Row(
          children: [
            leftChild,
            rightChild
          ],
        )
      ],
    )
    );
  }
}