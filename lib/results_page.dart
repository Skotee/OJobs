import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import './map_page.dart';
import 'jobdetail_page.dart';

class ResultsPage extends StatefulWidget {
  final double lat;
  final double long;
  final String term;
  ResultsPage({Key key, @required this.term, @required this.lat,@required this.long}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  @override
      Widget build(BuildContext context) {
          final goToMapButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapPage(term: widget.term,lat: widget.lat,long: widget.long),
              ),
            ),
            child: Text("Go to map",
                textAlign: TextAlign.center,
                style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        return Scaffold(
          body: _buildBody(context),
          floatingActionButton: goToMapButton,
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobdetailPage(id: job.id),
                ),
              ),
            ),
          ),
        );
      }

}
