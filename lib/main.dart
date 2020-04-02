import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Browse Posts',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'posts'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(child: _buildBody()),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget _buildBody() {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('post').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(snapshot.data.documents);
    },
  );
}

Widget _buildList(List<DocumentSnapshot> snapshot){
  // fetch data from firebase db

  return ListView(
    children: snapshot.map((data) => _buildListItem(data)).toList()
  );
}

Widget _buildListItem(DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);

  return Padding(
    key: ValueKey(record.title),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        title: Text(record.title),
        trailing: Text(record.description),
        onTap: () => print(record),
      ),
    ),
  );
}

class Record {
  final String title;
  final String description;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['description'] != null),
        title = map['title'],
        description = map['description'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$description>";
}

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

//_tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
//_tile('The Castro Theater', '429 Castro St', Icons.theaters),
//_tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
//_tile('Roxie Theater', '3117 16th St', Icons.theaters),
//_tile('United Artists Stonestown Twin', '501 Buckingham Way',
//Icons.theaters),
//_tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
//Divider(),
//_tile('Kescaped_code#39;s Kitchen', '757 Monterey Blvd', Icons.restaurant),
//_tile('Emmyescaped_code#39;s Restaurant', '1923 Ocean Ave', Icons.restaurant),
//_tile(
//'Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
//_tile('La Ciccia', '291 30th St', Icons.restaurant),