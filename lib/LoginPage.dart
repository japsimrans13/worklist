import 'package:flutter/material.dart';
// Import for http requests is below
import 'package:http/http.dart' as http;
// Imports for hive ar below
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import for request to json convert
import 'dart:convert' as convert;

import 'package:worklistfrontend/Worklist.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myUsernameController = TextEditingController();
  final myPasswordController = TextEditingController();

  Box credBox;
  var JWT;
  var username;
  var password;
  var getTokenUrl = 'https://todo13.herokuapp.com/api/token/';

  // void startHive() async {
  //   await Hive.initFlutter();
  // }

  @override
  void initState() {
    Hive.initFlutter();
    super.initState();
    openBox();
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    credBox = await Hive.openBox('Credentials');
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
                  print(JWT);
                  // Adding JWT to hive database
                  await credBox.put('JWT', JWT);
                  print('JWT has been added to box');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => Worklist()),
                      ));
                } else {
                  print('Request failed with status: ${response.statusCode}.');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
