import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final6350/pages/Post.dart';
import 'package:final6350/pages/PostDetail.dart';
import 'package:final6350/pages/AddPost.dart';
import 'package:final6350/pages/Profile.dart';
import 'package:final6350/service/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PostList extends StatefulWidget {
  PostList({Key key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        title: Text('Garage Sale Item List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Profile();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Center(child: _buildBody(context, email)),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            _navigateAndDisplaySnackbar(context, email);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

_navigateAndDisplaySnackbar(BuildContext context, email) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  // print('email before nav : ' + email);
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddPost(email: email)),
  );

  // After the Selection Screen returns a result, hide any previous snackbars
  // and show the new result.
  if (result != null) {
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
  }
}

Widget _buildBody(BuildContext context, currentUserEmail) {
  // print('here');
  // print(currentUserEmail);

  if (currentUserEmail == '') {
    return Text("Please login to view and add new posts!");
  }
  // fetch data from firebase db
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('garage-sale-lang-meng').document(currentUserEmail).collection('post').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  if (snapshot.length == 0) {
    return Text("You have no post yet.");
  }
  return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList());
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final post = Post.fromSnapshot(data);
  final ref = FirebaseStorage.instance.ref().child("garagesale-images");
  String iconName = "";
  if (post.images.length > 0) {
    iconName = post.images[0];
  }
  return FutureBuilder<Uint8List> (
    future: getIcon(ref, iconName),
    builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
      return Padding(
        key: ValueKey(post.title),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            leading: snapshot.data == null
              ? Icon(Icons.image, size: 50)
              : Image.memory(snapshot.data, height: 100),
            title: Text(post.title),
            subtitle: Text(post.description, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDetail(post: post)),
              );
            },
          ),
        ),
      );
    },
  );

}

Future<Uint8List> getIcon (StorageReference ref, String name) async {
  return await ref.child(name).getData(10000000);
}