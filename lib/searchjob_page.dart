import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import './main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  FirebaseUser user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _whatjobController = TextEditingController();
  final TextEditingController _wherejobController = TextEditingController();
  Stream<User> userInfo;
  bool _success;

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
        final whatjobField = TextFormField(
          controller: _whatjobController,
          validator: (String value) {
            if (value.isEmpty) {
              return "Please enter job' name you're looking for";
            }
            return null;
          },
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "What job?",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final wherejobField = TextFormField(
          controller: _wherejobController,
          validator: (String value) {
            if (value.isEmpty) {
              return "Please enter job' localization you're looking for";
            }
            return null;
          },
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Where?",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final searchButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _search();

                }
              },
            child: Text("Search",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
        final addButton = ClipOval(
          child: Material(
            color: Colors.blue, // button color
            child: InkWell(
              splashColor: Colors.red, // inkwell color
              child: SizedBox(width: 56, height: 56, child: Icon(Icons.add_circle)),
              onTap: () {},
            ),
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
                    whatjobField,
                    SizedBox(height: 20.0),
                    wherejobField,
                    SizedBox(height: 20.0),
                    searchButton,
                    SizedBox(height: 30.0),
                    SizedBox(height: 20.0),
                    addButton
                  ],
                ),
              ),
            ),
          ),
        );
      }
      @override
      void dispose() {
        _whatjobController.dispose();
        _wherejobController.dispose();
        super.dispose();
      }


    void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
  void _search() async {
  }
}