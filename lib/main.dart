import 'package:flutter/material.dart';

import 'core/constant/routes_creator.dart';
import 'injection_container.dart' as ic;
 
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      routes: navRoutes,
      initialRoute: initialNavRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        secondaryHeaderColor: Colors.white.withOpacity(0.925)
      ),
    );
  }
}