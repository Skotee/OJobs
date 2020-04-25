import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import 'globals.dart' as globals;
import 'jobdetail_page.dart';
import 'menu_bar.dart';

class AppliedJobsPage extends StatefulWidget {
  @override
  _AppliedJobsPageState createState() => _AppliedJobsPageState();
}

class _AppliedJobsPageState extends State<AppliedJobsPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  @override
      Widget build(BuildContext context) {

        return Scaffold(
          drawer: BaseAppBar(),
          appBar: AppBar(centerTitle: true,
            title: RichText(
              text: TextSpan(
                text: 'Applied jobs',
                style: style,
              ),
            ),
          ),
          body: _buildBody(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      }
       Widget _buildBody(BuildContext context) {
        return StreamBuilder<QuerySnapshot>(
          stream: queryAppliedList(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if(!snapshot.hasData) {
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
          padding: const EdgeInsets.only(top: 20.0),
          children: ListTile.divideTiles(
            color: Colors.white,
            context:context,
            tiles: snapshot.map((data) => _buildListItem(context, data)).toList()).toList(),
        );
      }
      Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
        final job = Job.fromSnapshot(data);
        bool fav = globals.currentUserInfo.favorite.contains(job.id);
        return ListTile(
              leading: Icon(Icons.check,color: Colors.grey,),
              title: Text(job.name),
              subtitle: Text(job.desc),
              trailing: fav ?
                IconButton(icon:Icon(Icons.favorite),color: Colors.grey,
                onPressed: (){
                  setState(() {
                    globals.currentUserInfo.favorite.remove(job.id);
                  });
                  Firestore.instance
                    .collection('USER')
                    .document(globals.currentUser.uid)
                    .updateData({'favorite':globals.currentUserInfo.favorite});
                },)
                :IconButton(icon:Icon(Icons.favorite_border),color: Colors.grey,
                onPressed: (){
                  setState(() {
                    globals.currentUserInfo.favorite.add(job.id);
                  });
                  Firestore.instance
                    .collection('USER')
                    .document(globals.currentUser.uid)
                    .updateData({'favorite':globals.currentUserInfo.favorite});
                },),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobdetailPage(id: job.id),
                ),
              ),
            );
        }
}
