import 'package:flutter/material.dart';
import 'package:o_jobs/globals.dart' as globals;

class BaseAppBar extends StatelessWidget{
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(globals.currentUserInfo == null ? '' :globals.currentUserInfo.name),
              accountEmail: new Text(globals.currentUserInfo == null ? '' :globals.currentUserInfo.email),
              // 
              // currentUserInfo.email
              // currentAccountPicture: new CircleAvatar(
              //   backgroundImage:
              // )
            ),
            new ListTile(
              title: new Text('Go to profile'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/profile');
              }
            ),
            new ListTile(
              title: new Text('Go to favorites'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/favorite');
              }
            ),
            new ListTile(
              title: new Text('Go to applied jobs'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/applied');
              }
            ),
            new ListTile(
              title: new Text('Logout'),
              onTap: () async {
                globals.currentUserInfo = null;
                await globals.auth.signOut();
                print(Navigator.defaultRouteName.toString());
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(Navigator.defaultRouteName),
                );
              }
            )
        ]
      )
      );
  }
}