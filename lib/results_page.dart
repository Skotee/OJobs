import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import './map_page.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

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
        final logoField = RichText(
          text: TextSpan(
            children: <TextSpan>[
            TextSpan(text: 'O', style: TextStyle(fontSize: 100, fontWeight: FontWeight.w100)),
            TextSpan(text: 'JOBS', style: TextStyle(fontSize: 20)),
          ]
          )
        );
        final listField = ListView(
        children: const <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('iOS Dev'),
              subtitle: Text(
                'A sufficiently long subtitle warrants three lines.'
              ),
              trailing: Icon(Icons.favorite_border),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Android Dev'),
              subtitle: Text(
                'A sufficiently long subtitle warrants three lines.'
              ),
              trailing: Icon(Icons.favorite_border),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Web Dev'),
              subtitle: Text(
                'A sufficiently long subtitle warrants three lines.'
              ),
              trailing: Icon(Icons.favorite_border),
              isThreeLine: true,
            ),
          ),
        ],
      );
        final goToMapButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            // onPressed: () => _pushPage(context, MapPage()),
            child: Text("Go to map",
                textAlign: TextAlign.center,
                style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
        return Scaffold(
          body: Form(
            key: _formKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    logoField,
                    SizedBox(height: 20.0),
                    listField,
                    SizedBox(height: 20.0),
                    goToMapButton
                  ],
                ),
              ),
            ),
          ),
        );
      }
      @override
      void dispose() {
        super.dispose();
      }

    void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}