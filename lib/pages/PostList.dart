import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final6350/pages/Post.dart';
import 'package:final6350/pages/PostDetail.dart';
import 'package:final6350/pages/AddPost.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PostList extends StatefulWidget {
  PostList({Key key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool _isSignIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  String currentUserEmail = '';

  _login() async {

    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    setState(() {
      currentUserEmail = currentUser.email;
    });
    assert(user.uid == currentUser.uid);
    setState(() {
      _isSignIn = true;
    });

    return 'signInWithGoogle succeeded: $user';
  }

  _logout() {
    _googleSignIn.signOut();
    setState(() {
      _isSignIn = false;
      currentUserEmail = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        title: Text('Garage Sale Item List'),
      ),
      body: Center(child: _buildBody(context, currentUserEmail)),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            if (!_isSignIn) {
              _drawerKey.currentState.openDrawer();
            } else {
              _navigateAndDisplaySnackbar(context, currentUserEmail);
            }
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
      drawer: Drawer(
          child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: _isSignIn
                  ?  Text(_googleSignIn.currentUser.displayName)
                  : Text('Username from google sign in'),
              accountEmail: _isSignIn
                  ?  Text(_googleSignIn.currentUser.email)
                  : Text("useremail@gmail.com"),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: _isSignIn
                      ? Image.network(_googleSignIn.currentUser.photoUrl)
                      : Icon(Icons.person, size: 35)),
            ),
            !_isSignIn ? ListTile(
              leading: Text(
                'Signin',
                style: TextStyle(fontSize: 18),
              ),
              trailing: CircleAvatar(
                child: Icon(Icons.arrow_back),
              ),
              onTap: () => _login(),
            ) : new Container(width: 0, height: 0),
            _isSignIn ? ListTile(
              leading: Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
              trailing: CircleAvatar(
                child: Icon(Icons.arrow_forward),
              ),
              onTap: () => _logout(),
            ) : new Container(width: 0, height: 0)
          ],
      )),
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
