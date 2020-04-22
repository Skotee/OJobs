import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import './map_page.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final dummySnapshot = [
  {"title": "iOS Dev", "description": "15hehehehe"},
  {"title": "Android Dev", "description": "14hehehe"},
  {"title": "Web Dev", "description": "11heheheh"},
];

class ResultsPage extends StatefulWidget {
  ResultsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  FirebaseUser user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Stream<User> userInfo;

  @override
      Widget build(BuildContext context) {
          final goToMapButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () => _pushPage(context, MapPage()),
            child: Text("Go to map",
                textAlign: TextAlign.center,
                style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        //I need to include somewhere goToMapButton button
        return Scaffold(
          body: _buildBody(context),
        );
      }
       Widget _buildBody(BuildContext context) {
        // TODO: get actual snapshot from Cloud Firestore
        return _buildList(context, dummySnapshot);
      }
       Widget _buildList(BuildContext context, List<Map> snapshot) {
        return ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children: snapshot.map((data) => _buildListItem(context, data)).toList(),
        );
      }
       Widget _buildListItem(BuildContext context, Map data) {
        final record = Record.fromMap(data);

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

    void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
