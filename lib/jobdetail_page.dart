import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';

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
         final cvchoiceRadio = Column(
          children: <Widget>[
            ListTile(
              title: const Text('Lafayette'),
              leading: Radio(
                // value: SingingCharacter.lafayette,
                // groupValue: _character,
                // onChanged: (SingingCharacter value) {
                //   setState(() { _character = value; });
                // },
              ),
            ),
            ListTile(
              title: const Text('Thomas Jefferson'),
              leading: Radio(
                // value: SingingCharacter.jefferson,
                // groupValue: _character,
                // onChanged: (SingingCharacter value) {
                //   setState(() { _character = value; });
                // },
              ),
            ),
          ],
        );
        final applyButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () => Navigator.pushNamed(context, '/done'),
            child: Text("Apply",
                textAlign: TextAlign.center,
                style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        return Scaffold(
          body: _buildBody(context),
          floatingActionButton: applyButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      }
      Widget _buildBody(BuildContext context){
        return FutureBuilder<Job>(
          future: getJob(widget.id),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return Container(
                padding: EdgeInsets.only(top:21),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-200,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(snapshot.data.name, style: TextStyle(fontSize: 20,backgroundColor: Colors.grey)),
                      Text(snapshot.data.desc, style: TextStyle(fontSize: 12)),
                    ],
                  ),
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
