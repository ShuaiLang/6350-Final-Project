import 'package:final6350/pages/addProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Garage Sale"),
        centerTitle: true,
        // need to think about layout
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: null),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () {},
            child:
                const Text('Browse products', style: TextStyle(fontSize: 20)),
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 5,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (BuildContext context) {
                return AddProduct();
              }));
            },
            child:
                const Text('Add new product', style: TextStyle(fontSize: 20)),
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 5,
          )
        ],
      )),
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Username from google sign in'),
            accountEmail: Text("useremail@gmail.com"),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 35)),
          ),
          ListTile(
            leading: Text(
              'Signin',
              style: TextStyle(fontSize: 18),
            ),
            trailing: CircleAvatar(
              child: Icon(Icons.arrow_back),
            ),
          ),
          ListTile(
            leading: Text(
              'Logout',
              style: TextStyle(fontSize: 18),
            ),
            trailing: CircleAvatar(
              child: Icon(Icons.arrow_forward),
            ),
          )
        ],
      )),
    );
  }
}
