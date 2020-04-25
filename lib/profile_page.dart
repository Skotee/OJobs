import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  Stream<User> userInfo;

  @override
      Widget build(BuildContext context) {
        final emailField = RichText(
          text: TextSpan(
            children: <TextSpan>[
            TextSpan(text: 'Email', style: TextStyle(fontSize: 20)),
          ]
          )
        );
        final phoneField = RichText(
          text: TextSpan(
            children: <TextSpan>[
            TextSpan(text: 'Mobile phone number', style: TextStyle(fontSize: 20)),
          ]
          )
        );
        final addressField = RichText(
          text: TextSpan(
            children: <TextSpan>[
            TextSpan(text: 'Address', style: TextStyle(fontSize: 20)),
          ]
          )
        );
        final countryField = RichText(
          text: TextSpan(
            children: <TextSpan>[
            TextSpan(text: 'Country', style: TextStyle(fontSize: 20)),
          ]
          )
        );
        return Scaffold(
          body: _buildBody(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      }
       Widget _buildBody(BuildContext context) {
        return StreamBuilder<QuerySnapshot>(
          stream: queryFavoriteList(),
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
          children: snapshot.map((data) => _buildListItem(context, data)).toList(),
        );
      }
       Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
        final user = User.fromSnapshot(data);

        return Padding(
          key: ValueKey(user.name),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text(user.name),
              // trailing: Text(job.desc),
            ),
          ),
        );
      }
}
