import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import 'package:o_jobs/globals.dart' as globals;

import 'menu_bar.dart';

enum CV { cv1, cv2 }
CV groupcv = CV.cv1;

class JobdetailPage extends StatefulWidget {
  final String id;
  JobdetailPage({Key key, @required this.id}) : super(key: key);
  @override
  _JobdetailState createState() => _JobdetailState();
}

class _JobdetailState extends State<JobdetailPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    bool app = globals.currentUserInfo.applied.contains(widget.id);
    final applyButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).buttonColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(!app){
            globals.currentUserInfo.applied.add(widget.id);
            Firestore.instance
                .collection('USER')
                .document(globals.currentUser.uid)
                .updateData({'applied': globals.currentUserInfo.applied});
            Navigator.pushReplacementNamed(context, '/done');
          }
        },
        child: Text(app?'Already applied to this Job':"Apply",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      drawer: baseAppBar(context),
      body: _buildBody(context),
      floatingActionButton: applyButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(BuildContext context) {
    final cvchoiceRadio = Column(
      children: <Widget>[
        RadioListTile(
            title: const Text('CV 1'),
            value: CV.cv1,
            groupValue: groupcv,
            onChanged: (CV value) {
              setState(() {
                groupcv = value;
              });
            }),
        RadioListTile(
            title: const Text('CV 2'),
            value: CV.cv2,
            groupValue: groupcv,
            onChanged: (CV value) {
              setState(() {
                groupcv = value;
              });
            }),
      ],
    );

    return FutureBuilder<Job>(
      future: getJob(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(children: [
            Card(
              margin: EdgeInsets.only(top: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.album, size: 50),
                    title: Text(snapshot.data.name),
                    subtitle: Text(snapshot.data.desc),
                  ),
                  Wrap(
                    children: snapshot.data.skillList.map((skill) {
                      return Chip(
                        avatar: Icon(Icons.featured_play_list,
                            color: Theme.of(context).buttonColor),
                        label: Text(skill.toString()),
                      );
                    }).toList(),
                    spacing: 4,
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
            cvchoiceRadio,
          ]);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
