import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:o_jobs/db.dart';
import 'package:o_jobs/globals.dart' as globals;

import 'menu_bar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BaseAppBar(),
      body: _buildBody(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(BuildContext context) {
    final emailField = RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(text: 'Email: ', style: TextStyle(fontSize: 20)),
      TextSpan(
          text: globals.currentUserInfo.email, style: TextStyle(fontSize: 20)),
    ]));
    final phoneField = RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(text: 'Phone number: ', style: TextStyle(fontSize: 20)),
      TextSpan(
          text: globals.currentUserInfo.mobile, style: TextStyle(fontSize: 20)),
    ]));
    final addressField = RichText(
        maxLines: 3,
        text: TextSpan(children: <TextSpan>[
          TextSpan(text: 'Address: ', style: TextStyle(fontSize: 20)),
          TextSpan(
              text: globals.currentUserInfo.adress,
              style: TextStyle(fontSize: 20)),
        ]));
    final countryField = RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(text: 'Country: ', style: TextStyle(fontSize: 20)),
      TextSpan(
          text: globals.currentUserInfo.country,
          style: TextStyle(fontSize: 20)),
    ]));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  globals.currentUserInfo.name,
                  style: Theme.of(context).textTheme.headline,
                ),
                Text(
                  globals.currentUserInfo.lastname.toUpperCase(),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 1, 20, 1),
              child: InkWell(
                onTap: () => _selectProfilePicture(),
                child: (globals.currentUserInfo.pic.isNotEmpty)
                    ? CircleAvatar(
                        minRadius: 40,
                        backgroundImage:
                            NetworkImage(globals.currentUserInfo.pic))
                    : Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 150,
                      ),
              ),
            ),
          ],
        ),
        Divider(
          height: 20,
          color: Colors.white,
          thickness: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(Icons.card_giftcard, color: Colors.green[500]),
                Text('CV 1'),
                OutlineButton(
                  child: const Text('EDIT'),
                  onPressed: () => _selectCV(true),
                  textColor: Theme.of(context).buttonColor,
                ),
              ],
            ),
            Column(
              children: [
                Icon(Icons.card_travel, color: Colors.green[500]),
                Text('CV 2'),
                OutlineButton(
                  child: const Text('EDIT'),
                  textColor: Theme.of(context).buttonColor,
                  onPressed: () => _selectCV(false),
                ),
              ],
            ),
          ],
        ),
        Divider(height: 20),
        Container(
            margin: EdgeInsets.only(left: 10, right: 10), child: emailField),
        SizedBox(height: 16),
        Container(
            margin: EdgeInsets.only(left: 10, right: 10), child: phoneField),
        SizedBox(height: 16),
        Container(
            child: addressField, margin: EdgeInsets.only(left: 10, right: 10)),
        SizedBox(height: 16),
        Container(
            margin: EdgeInsets.only(left: 10, right: 10), child: countryField),
      ],
    );
  }

  Future _selectProfilePicture() async {
    String path = await FilePicker.getFilePath(type: FileType.image);
    if (path.isNotEmpty) {
      File file = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Theme.of(context).backgroundColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
      );
      if (file != null) {
        uploadFile('pic', file, globals.currentUser.uid);
        setState(() {});
      }
    }
  }

  Future _selectCV(bool choice) async {
    File file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['docx', 'pdf']);
    if (file != null) {
      if (choice)
        uploadFile('cv1', file, globals.currentUser.uid);
      else
        uploadFile('cv2', file, globals.currentUser.uid);
    }
  }
}
