import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'results_page.dart';
import 'register_page.dart';
import 'searchjob_page.dart';
import 'db.dart';
import 'map_page.dart';
import 'signin_page.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OJobs',
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
        brightness: Brightness.dark,
      ),
      routes: {
        '/login': (context) => LoginPage(title: 'OJobs'),
        '/register': (context) => RegisterPage(),
        '/search': (context) => SearchPage(),
        '/result': (context) => ResultsPage(lat: null, long: null, term: null),
        '/map': (context) => MapPage(lat: null, long: null, term: null),
      },
      home: BootPage(),
    );
  }
}


class BootPage extends StatefulWidget {
  @override
  BootPageState createState() => BootPageState();
}
class BootPageState extends State<BootPage> {
  @override
  Widget build(BuildContext context) {
    _handleBoot();
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _handleBoot() async{
  final FirebaseUser currentUser = await _auth.currentUser();
  if(currentUser == null)
    Navigator.pushReplacementNamed(context, '/login');
  else
    Navigator.pushReplacementNamed(context, '/search');
  }
}