import 'package:flutter/material.dart';
// Import for http requests is below
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:worklistfrontend/LoginPage.dart';
import 'package:worklistfrontend/Worklist.dart';

class AddTasks extends StatefulWidget {
  AddTasks({Key key}) : super(key: key);

  @override
  _AddTasksState createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  final addTaskUrl = 'https://todo13.herokuapp.com/api/add/';
  final myTaskController = TextEditingController();

  Box credBox;
  var JWT;

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
    print(' token is $token ');
    JWT = token;
    return token;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Tasks'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: myTaskController,
              maxLength: 30,
              decoration: InputDecoration(labelText: 'Enter your Task'),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () async {
                var task = myTaskController.text;
                print(JWT);
                var response = await http.post(addTaskUrl,
                    headers: {"Authorization": "Bearer $JWT"},
                    body: {"task_name": task});
                print('Data for tasks sent to server');
                print(response.body);
                // Add a popup modal type which asks the user to continue adding more tasks or go to worklist page. Till then open worklist page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => Worklist()),
                    ));
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
