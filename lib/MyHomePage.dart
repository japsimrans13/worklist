import 'package:flutter/material.dart';
import 'package:worklistfrontend/EmptyWidget.dart';

import 'Worklist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myUsernameController = TextEditingController();
  final myPasswordController = TextEditingController();

  Box credBox;
  var JWT;
  var username;
  var password;
  var getTokenUrl = 'https://todo13.herokuapp.com/api/token/';

  void main() async {
    await Hive.initFlutter();
  }
  


  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    credBox = await Hive.openBox('Credentials');
    print('Box named test box is opened');
    return;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myUsernameController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 20.0,
              height: 20.0,
            ),
            TextFormField(
              controller: myUsernameController,
              decoration: InputDecoration(labelText: 'Enter your username'),
            ),
            TextFormField(
              controller: myPasswordController,
              decoration: InputDecoration(labelText: 'Enter your password'),
            ),
            RaisedButton(
              onPressed: () async {
                username = myUsernameController.text;
                password = myPasswordController.text;
                print("username is $username and password is $password");
                var response = await http.post(getTokenUrl,
                    body: {"username": username, "password": password});
                if (response.statusCode == 200) {
                  var jsonResponse = convert.jsonDecode(response.body);
                  JWT = jsonResponse['access'];
                  // Adding JWT to hive database
                  await credBox.put('JWT', JWT);

                } else {
                  print('Request failed with status: ${response.statusCode}.');
                }
              },
              child: Text('Add data'),
            ),
            RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: ((context) => Worklist()),
                ));
              },
              child: Text('Change Screen '),
            )
          ],
        ),
      ),
    );
  }
}
