import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'results_page.dart';
import 'register_page.dart';
import 'searchjob_page.dart';
import 'db.dart';
import 'map_page.dart';
import 'signin_page.dart';
import 'favorite_page.dart';
import 'done_page.dart';
import 'jobdetail_page.dart';
import 'appliedjobs_page.dart';
import 'profile_page.dart';
import 'globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OJobs',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      onGenerateRoute: (settings){
        switch (settings.name) {
          case '/login': MaterialPageRoute(builder: (context) => LoginPage());
            break;
          case '/register': MaterialPageRoute(builder: (context) => RegisterPage());
            break;
          case '/search': MaterialPageRoute(builder: (context) => SearchPage());
            break;
          case '/favorite': MaterialPageRoute(builder: (context) => FavoritePage());
            break;
          case '/done': MaterialPageRoute(builder: (context) => DonePage());
            break;
          case '/appliedjobs': MaterialPageRoute(builder: (context) => AppliedJobsPage());
            break;
          case '/profile': MaterialPageRoute(builder: (context) => ProfilePage());
            break;
          default:
        }
      },
      routes: {
        '/': (context) {
          return StreamBuilder<FirebaseUser>(
          stream: globals.auth.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              FirebaseUser user = snapshot.data;
              if (user == null) {
                return LoginPage();
              }
              globals.currentUser = user;
              globals.update();
              return SearchPage();

            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          );
        },
        /*'/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/search': (context) => SearchPage(),
        '/result': (context) => ResultsPage(lat: null, long: null, term: null),
        '/map': (context) => MapPage(lat: null, long: null, term: null),
        '/favorite': (context) => FavoritePage(),
        '/done': (context) => DonePage(),
        '/jobdetail': (context) => JobdetailPage(id: null),
*/
      },
    );
  }
}
/*
class BootPage extends StatefulWidget {
  
  @override
  BootPageState createState() => BootPageState();
}
class BootPageState extends State<BootPage> {
  @override
  Widget build(BuildContext context) {
    _handleBoot();
    return Scaffold(
      body:Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _handleBoot() async{
    final FirebaseUser currentUser = await globals.auth.currentUser();
    if(currentUser == null)
      Navigator.pushNamed(context, '/login');
    else
    {
      globals.currentUser = currentUser;
      globals.currentUserInfo = await getUser(currentUser.uid);
      Navigator.pushNamed(context, '/search');
    }
  }
}
*/