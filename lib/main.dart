import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import 'searchjob_page.dart';
import 'signin_page.dart';
import 'favorite_page.dart';
import 'done_page.dart';
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
                builder: (context) => LoginPage(),
                settings: RouteSettings(name: '/login'));
            break;
          case '/register':
            return MaterialPageRoute(
                builder: (context) => RegisterPage(),
                settings: RouteSettings(name: '/register'));
            break;
          case '/search':
            return MaterialPageRoute(
                builder: (context) => SearchPage(),
                settings: RouteSettings(name: '/search'));
            break;
          case '/favorite':
            return MaterialPageRoute(
                builder: (context) => FavoritePage(),
                settings: RouteSettings(name: '/favorite'));
            break;
          case '/done':
            return MaterialPageRoute(
                builder: (context) => DonePage(),
                settings: RouteSettings(name: '/done'));
            break;
          case '/appliedjobs':
            return MaterialPageRoute(
                builder: (context) => AppliedJobsPage(),
                settings: RouteSettings(name: '/appliedjobs'));
            break;
          case '/profile':
            return MaterialPageRoute(
                builder: (context) => ProfilePage(),
                settings: RouteSettings(name: '/profile'));
            break;
          default:
            return null;
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
