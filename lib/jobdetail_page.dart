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
  Stream<User> userInfo;
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
       Widget _buildBody(BuildContext context) {
        return StreamBuilder<List<DocumentSnapshot>>(
          // stream: queryGeoKeyJob(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if(!snapshot.hasData) {
              return Center(
                        child: CircularProgressIndicator(),
                      );
            }
            return Center(
                        child: _buildList(context, snapshot.data),
                        child: cvchoiceRadio()
                      );
          },
        );
      }
       Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
        return ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children: snapshot.map((data) => _buildListItem(context, data)).toList(),
        );
      }
       Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
        final job = Job.fromSnapshot(data);

        return Padding(
          key: ValueKey(job.name),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text(job.name),
              trailing: Text(job.desc),
              onTap: () => print(job.desc),
            ),
          ),
        );
      }

}
