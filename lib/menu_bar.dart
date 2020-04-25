import 'package:flutter/material.dart';
import 'package:o_jobs/appliedjobs_page.dart';
import 'package:o_jobs/favorite_page.dart';
import 'package:o_jobs/profile_page.dart';
import 'package:o_jobs/globals.dart' as globals;

class BaseAppBar extends StatelessWidget{
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(globals.currentUserInfo == null ? '' :globals.currentUserInfo.name),
              accountEmail: Text(globals.currentUserInfo == null ? '' :globals.currentUserInfo.email),
              currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage(globals.currentUserInfo.pic)),
            ),
            ListTile(
              title: Text('Go to profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
                // Navigator.pushNamed(context, '/profile');
              }
            ),
            ListTile(
              title: Text('Go to favorites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritePage(),
                  ),
                );
                //Navigator.pushNamed(context, '/favorite');
              }
            ),
            ListTile(
              title: Text('Go to applied jobs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppliedJobsPage(),
                  ),
                );
                // Navigator.pushNamed(context, '/appliedjobs');
              }
            ),
            ListTile(
              title: Text('Logout'),
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