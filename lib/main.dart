import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:final6350/pages/PostList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garage Sale Page',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostList(),
    );
  }
}
