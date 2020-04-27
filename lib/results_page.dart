import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import './map_page.dart';
import 'globals.dart' as globals;
import 'jobdetail_page.dart';
import 'menu_bar.dart';

class ResultsPage extends StatefulWidget {
  final double lat;
  final double long;
  final String term;
  final double range;
  ResultsPage(
      {Key key, @required this.term, @required this.lat, @required this.long, @required this.range})
      : super(key: key);

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
            builder: (context) =>
                MapPage(term: widget.term, lat: widget.lat, long: widget.long,range:widget.range),
          ),
        ),
        child: Text("Go to map",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      drawer: baseAppBar(context),
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            text: 'Search result',
            style: style,
          ),
        ),
      ),
      body: _buildBody(context),
      floatingActionButton: goToMapButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: queryGeoKeyJob(widget.term, widget.lat, widget.long,widget.range),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
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
      children: ListTile.divideTiles(
              color: Colors.white,
              context: context,
              tiles: snapshot
                  .map((data) => _buildListItem(context, data))
                  .toList())
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final job = Job.fromSnapshot(data);
    bool fav = globals.currentUserInfo.favorite.contains(job.id);
    bool app = globals.currentUserInfo.applied.contains(job.id);
    return ListTile(
      leading: app
          ? Icon(
              Icons.check,
              color: Colors.grey,
            )
          : null,
      title: Text(job.name),
      subtitle: Text(job.desc),
      trailing: fav
          ? IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.grey,
              onPressed: () {
                setState(() {
                  globals.currentUserInfo.favorite.remove(job.id);
                });
                Firestore.instance
                    .collection('USER')
                    .document(globals.currentUser.uid)
                    .updateData({'favorite': globals.currentUserInfo.favorite});
              },
            )
          : IconButton(
              icon: Icon(Icons.favorite_border),
              color: Colors.grey,
              onPressed: () {
                setState(() {
                  globals.currentUserInfo.favorite.add(job.id);
                });
                Firestore.instance
                    .collection('USER')
                    .document(globals.currentUser.uid)
                    .updateData({'favorite': globals.currentUserInfo.favorite});
              },
            ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobdetailPage(id: job.id),
        ),
      ),
    );
  }
}
