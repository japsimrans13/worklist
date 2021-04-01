import 'package:flutter/material.dart';
import 'package:worklistfrontend/Worklist.dart';


 
void main() async{
  runApp(MyApp());
}
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Worklist',
      home: Worklist()
    );
  }
}