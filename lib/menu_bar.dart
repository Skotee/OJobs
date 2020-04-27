import 'package:flutter/material.dart';
import 'package:o_jobs/globals.dart' as globals;

import 'db.dart';

Widget baseAppBar(BuildContext context) {
  return Drawer(
      child: ListView(children: <Widget>[
    UserAccountsDrawerHeader(
      accountName: Text(
          globals.currentUserInfo == null ? '' : globals.currentUserInfo.name),
      accountEmail: Text(
          globals.currentUserInfo == null ? '' : globals.currentUserInfo.email),
      currentAccountPicture: (globals.currentUserInfo.pic == null ||
              globals.currentUserInfo.pic.isNotEmpty)
          ? CircleAvatar(
              backgroundImage: NetworkImage(globals.currentUserInfo.pic))
          : Icon(
              Icons.account_circle,
              color: Colors.grey,
              size: 80,
            ),
    ),
    ListTile(
        title: Text('Go to profile'),
        onTap: () {
          if (ModalRoute.of(context).settings.name == '/profile')
            Navigator.pop(context);
          else if (ModalRoute.of(context).settings.name == '/favorite' ||
              ModalRoute.of(context).settings.name == '/appliedjobs') {
            Navigator.pushReplacementNamed(context, '/profile');
          } else {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/profile');
          }
        }),
    ListTile(
        title: Text('Go to favorites'),
        onTap: () {
          if (ModalRoute.of(context).settings.name == '/favorite')
            Navigator.pop(context);
          else if (ModalRoute.of(context).settings.name == '/profile' ||
              ModalRoute.of(context).settings.name == '/appliedjobs') {
            Navigator.pushReplacementNamed(context, '/favorite');
          } else {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/favorite');
          }
        }),
    ListTile(
        title: Text('Go to applied jobs'),
        onTap: () {
          if (ModalRoute.of(context).settings.name == '/appliedjobs')
            Navigator.pop(context);
          else if (ModalRoute.of(context).settings.name == '/favorite' ||
              ModalRoute.of(context).settings.name == '/profile') {
            Navigator.pushReplacementNamed(context, '/appliedjobs');
          } else {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/appliedjobs');
          }
        }),
    ListTile(
        title: Text('Logout'),
        onTap: () async {
          globals.currentUserInfo = new User();
          await globals.auth.signOut();
          print(Navigator.defaultRouteName.toString());
          Navigator.popUntil(
            context,
            ModalRoute.withName(Navigator.defaultRouteName),
          );
        })
  ]));
}
