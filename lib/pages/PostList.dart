import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:final6350/pages/Post.dart';
import 'package:final6350/pages/PostDetail.dart';
import 'package:final6350/pages/AddPost.dart';

class PostList extends StatefulWidget {
  PostList({Key key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Garage Sale Item List'),
      ),
      body: Center(child: _buildBody(context)),
      floatingActionButton: Builder(
        builder: (context) =>
            FloatingActionButton(
              onPressed: () {
                _navigateAndDisplaySnackbar(context);
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
      ),
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
                onTap: () {},
              ),
              ListTile(
                leading: Text(
                  'Logout',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: CircleAvatar(
                  child: Icon(Icons.arrow_forward),
                ),
                onTap: () {},
              )
            ],
          )),
    );
  }
}

_navigateAndDisplaySnackbar(BuildContext context) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddPost()),
  );

  // After the Selection Screen returns a result, hide any previous snackbars
  // and show the new result.
  if (result != null) {
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
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

