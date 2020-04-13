import 'package:flutter/material.dart';
import 'package:final6350/pages/PostList.dart';
import 'package:final6350/pages/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garage Sale Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        "/postlist": (_) => new PostList(),
      },
    );
  }
}
