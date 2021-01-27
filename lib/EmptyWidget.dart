import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var JWT =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjExNjk4Mzg1LCJqdGkiOiIxYjEzMTk3NDNkMTg0NDdjOTM2NjgxNTAwMDZmOTEzOCIsInVzZXJfaWQiOjJ9.vD5tULUXKvZNxHIPS9oJP7XkTNzomTs3-mWlwxY4ksE";
    var getTaskUrl = 'https://todo13.herokuapp.com/api/list/';
    var result =
        http.get(getTaskUrl, headers: {'Authorization': 'Bearer $JWT'});
    var initialData = 'Loading';

    return FutureBuilder(
      initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Text('This is test container inside list view builder'),
          ) ;
         },
        );
      },
      future: result,
    );
  }
}
