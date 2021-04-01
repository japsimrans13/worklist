import 'dart:io';
import 'package:worklistfrontend/AddTask.dart';
import 'package:worklistfrontend/Settings.dart';

import 'LoginPage.dart';

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
  // var JWT =
  //     "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjExNzc3MzIyLCJqdGkiOiIwMDMwZGI4ZTdkNjQ0NjVlOTRmMDc3NjBlYTAxZTMzYiIsInVzZXJfaWQiOjJ9.MTrUygqP3sNWuUNPvcpZGD7wC5nO-FvSxEEz2JSWPmY";
  var getTaskUrl = 'https://todo13.herokuapp.com/api/list/';

  Box credBox;
  var token;
  var JWT = "Bearer ";

  @override
  void initState() {
    Hive.initFlutter();
    super.initState();
    openBox();
  }

  Future<String> openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    credBox = await Hive.openBox('Credentials');
    print('Cred bopx is open');
    var token = credBox.get('JWT');
    if (token == null || token == '') {
      print('Token is null');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => LoginPage()),
          ));
    }
    // JWT =  JWT+token;
    // print('initstate is working and jwt is $JWT and token is $token ');
    return token;
  }

  Future<List<MyTasks>> _getProjectDetails() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    credBox = await Hive.openBox('Credentials');
    print('Cred bopx is open');
    var JWT = credBox.get('JWT');

    // print('Jwt is : $JWT jajaja and token is $token ');
    var response =
        await http.get(getTaskUrl, headers: {"Authorization": "Bearer $JWT"});
    print('Request sent to server');
    print(response.statusCode);
    var jsonResponse = convert.json.decode(response.body);
    if (response.statusCode == 200) {
      print('Handshake with server is sucessfully completed');
    } else {
      print('Your token is expired');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => LoginPage()),
          ));
    }

    List<MyTasks> tasks = [];
    for (var u in jsonResponse) {
      MyTasks task = MyTasks(u['id'], u['task_name']);
      tasks.add(task);
      print('task is $task ');
    }
    print('object');
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worklist'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => Settings()),
                    ));
              },
            ),
            ListTile(
              title: Text('Add ToDo'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => AddTasks()),
                    ));
              },
            ),
            ListTile(
              title: Text('Show Tasks'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => Worklist()),
                    ));
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                credBox.clear();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getProjectDetails(),
          initialData: 'Loading...',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Text('No data in snapshot'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: Text(snapshot.data[i].taskName),
                    subtitle: Text("task id is ${i + 1}"),
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
