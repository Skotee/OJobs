import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import 'package:o_jobs/globals.dart' as globals;

import 'menu_bar.dart';

enum CV { cv1, cv2 }

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

        final applyButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              globals.currentUserInfo.applied.add(widget.id);
              Firestore.instance
                .collection('USER')
                .document(widget.id)
                .updateData({'applied':globals.currentUserInfo.applied});
              Navigator.pushReplacementNamed(context, '/done');
            },
            child: Text("Apply",
                textAlign: TextAlign.center,
                style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        return Scaffold(
          drawer: BaseAppBar(),
          body: _buildBody(context),
          floatingActionButton: applyButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      }
      Widget _buildBody(BuildContext context){
        final cvchoiceRadio = Column(
          children: <Widget>[
            ListTile(
              title: const Text('CV 1'),
              leading: Radio(
                value: globals.currentUserInfo.cv1,
                // groupValue: _character,
                // onChanged: (SingingCharacter value) {
                //   setState(() { _character = value; });
                // },
              ),
            ),
            ListTile(
              title: const Text('CV 2'),
              leading: Radio(
                value: globals.currentUserInfo.cv2,
                // groupValue: _character,
                // onChanged: (SingingCharacter value) {
                //   setState(() { _character = value; });
                // },
              ),
            ),
          ],
        );
        return FutureBuilder<Job>(
          future: getJob(widget.id),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return Container(
                padding: EdgeInsets.only(top:21),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-200,
                child: Row(
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(12),
                      elevation: 4,
                      color: Color.fromRGBO(64, 75, 96, .9),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Jumping", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text("Activations 9", style: TextStyle(color: Colors.white70)),
                                Text("03-08-19", style: TextStyle(color: Colors.white70)),
                                Text(snapshot.data.name, style: TextStyle(fontSize: 20,backgroundColor: Colors.grey)),
                                Text(snapshot.data.desc, style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            Spacer(),
                            CircleAvatar(backgroundColor: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    cvchoiceRadio,
                  ],
                )
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      }
}
