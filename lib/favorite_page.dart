import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import 'globals.dart' as globals;
import 'jobdetail_page.dart';
import 'menu_bar.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: baseAppBar(context),
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            text: 'Favorite jobs',
            style: style,
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (globals.currentUserInfo.favorite.isEmpty)
      return Center(child: Text('Favorite job list is empty', style: style));
    else
      return StreamBuilder<QuerySnapshot>(
        stream: queryFavoriteList(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _buildList(context, snapshot.data.documents);
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
      trailing: IconButton(
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
