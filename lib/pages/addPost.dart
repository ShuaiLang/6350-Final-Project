import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addPost extends StatefulWidget {
  @override
  _addPostState createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Garage Sale"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Enter title of item'),
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Enter price'),
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter description of the item'),
            ),
            Divider(
              height: 10,
              color: Colors.black,
              thickness: 1,
            ),
            // not figure out how to make it to the most buttom
            Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.bottomRight,
                child: StatelessButtonBody()
            )
          ],
        ),
      ),
    );
  }

}

class StatelessButtonBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: Text('POST'),
        onPressed: () {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Added a new post!'),
            ),
          );
        },
      ),
    );
  }
}