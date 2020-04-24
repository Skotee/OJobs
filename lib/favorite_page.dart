import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class FavoritePage extends StatefulWidget {
  final double lat;
  final double long;
  final String term;
  FavoritePage({Key key, @required this.term, @required this.lat,@required this.long}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  Stream<User> userInfo;
  @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: _buildBody(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      }
       Widget _buildBody(BuildContext context) {
        return StreamBuilder<List<DocumentSnapshot>>(
          stream: queryGeoKeyJob(widget.term,widget.lat,widget.long),
          builder: (context, snapshot) {
            print(snapshot.data);
            if(!snapshot.hasData) {
              return Center(
                        child: CircularProgressIndicator(),
                      );
            }
            return _buildList(context, snapshot.data);
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
