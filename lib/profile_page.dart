import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import 'package:o_jobs/globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);

  @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: _buildBody(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      }
      Widget _buildBody(BuildContext context){
        final emailField = RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: 'Email', style: TextStyle(fontSize: 20)),
              TextSpan(text: globals.currentUserInfo.email, style: TextStyle(fontSize: 20)),
          ]
          )
        );
        final phoneField = RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: 'Mobile phone number', style: TextStyle(fontSize: 20)),
              TextSpan(text: globals.currentUserInfo.mobile, style: TextStyle(fontSize: 20)),
          ]
          )
        );
        final addressField = RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: 'Address', style: TextStyle(fontSize: 20)),
              TextSpan(text: globals.currentUserInfo.adress, style: TextStyle(fontSize: 20)),
          ]
          )
        );
        final countryField = RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: 'Country', style: TextStyle(fontSize: 20)),
              TextSpan(text: globals.currentUserInfo.country, style: TextStyle(fontSize: 20)),
          ]
          )
        );
        return FutureBuilder<User>(
          future: getUser(globals.currentUser.uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child:  RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: globals.currentUserInfo.name, style: TextStyle(fontSize: 20)),
                                  TextSpan(text: globals.currentUserInfo.lastname.toUpperCase(), style: TextStyle(fontSize: 30)),
                              ]
                              )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: CircleAvatar(backgroundImage: NetworkImage(globals.currentUserInfo.pic)),
                          ),
                        ]
                      ),
                      Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.green,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget> [
                        emailField,
                        phoneField,
                        addressField,
                        countryField
                      ]
                    )
                  ],
                ),
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