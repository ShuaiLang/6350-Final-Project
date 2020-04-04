import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:final6350/Post.dart';
import 'package:final6350/PostDetail.dart';

class PostList extends StatefulWidget {
  PostList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(child: _buildBody(context)),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget _buildBody(BuildContext context) {
  // fetch data from firebase db
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('post').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
  return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList()
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final post = Post.fromSnapshot(data);

  return Padding(
    key: ValueKey(post.title),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        title: Text(post.title),
//        trailing: Text(post.description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostDetail(post: post)),
          );
        },
      ),
    ),
  );
}

//class PostDetail extends StatelessWidget {
//  // Declare a field that holds the post detail.
//  final Post post;
//
//  // In the constructor, require a post.
//  PostDetail({Key key, @required this.post}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(post.title),
//      ),
//      body: Padding(
//        padding: EdgeInsets.all(16.0),
//        child: Text(post.description),
//      ),
//    );
//  }
//}

var posts = [
  {
    "title": "Empire",
    "description": "Big big"
  },
  {
    "title": "kingdom",
    "description": "huge huge"
  }
];

