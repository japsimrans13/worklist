import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Worklist extends StatefulWidget {
  @override
  _WorklistState createState() => _WorklistState();
}

class _WorklistState extends State<Worklist> {
  var JWT =
      "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjExNzc3MzIyLCJqdGkiOiIwMDMwZGI4ZTdkNjQ0NjVlOTRmMDc3NjBlYTAxZTMzYiIsInVzZXJfaWQiOjJ9.MTrUygqP3sNWuUNPvcpZGD7wC5nO-FvSxEEz2JSWPmY";
  var getTaskUrl = 'https://todo13.herokuapp.com/api/list/';

  Future<List<MyTasks>> _getProjectDetails() async {
    var response =
        await http.get(getTaskUrl, headers: {"Authorization":JWT});
    print('Request sent to server');
    print(response.statusCode);
    var jsonResponse = convert.jsonDecode(response.body);

    List<MyTasks> tasks = [];
    for (var u in jsonResponse ) {
      
      MyTasks task =
          MyTasks(u['id'], u['task_name']);
      tasks.add(task);
    }
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worklist'),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getProjectDetails(),
          initialData: 'Loading',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Text('No data in snapshot'));
            }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  title: Text(snapshot.data[i].taskName),
                  subtitle: Text("task id is ${i+1}"),
                );
              },
            );
          }
          },
        ),
      ),
    );
  }
}

class MyTasks {
  final int id;
  final String taskName;

  MyTasks(this.id, this.taskName);
}
