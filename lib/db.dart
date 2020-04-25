import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'globals.dart' as globals;

Future<User> getUser(String id){
  return Firestore.instance
  .collection('USER')
  .document(id)
  .get()
  .then((snapshot) {
    try {
      return User.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  });
}

class User {
  String name;
  String lastname;
  String email;
  String mobile;
  String adress;
  String country;
  String cv1;
  String cv2;
  String pic;
  List<dynamic> favorite;
  List<dynamic> applied;

  User.fromSnapshot(DocumentSnapshot snapshot):
    name = snapshot['name'],
    lastname = snapshot['lastname'],
    email = snapshot['email'],
    mobile = snapshot['mobile'],
    adress = snapshot['adress'],
    country = snapshot['country'],
    favorite = snapshot['favorite'],
    applied = snapshot['applied'],
    cv1 = snapshot['CV1'],
    cv2 = snapshot['CV2'],
    pic = snapshot['pic'];
}

Stream<QuerySnapshot> getJobList(List<dynamic> id) {
  return Firestore.instance.collection('JOBS').where(FieldPath.documentId,whereIn:id).snapshots();
}

Future<Job> getJob(String id){
  return Firestore.instance
  .collection('JOBS')
  .document(id)
  .get()
  .then((snapshot) {
    try {
      return Job.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  });
}

class Job {
  String id;
  String name;
  String desc;
  GeoPoint position;
  List<dynamic> skillList;

  Job.fromSnapshot(DocumentSnapshot snapshot):
    id = snapshot.documentID,
    name = snapshot['name'],
    desc = snapshot['desc'],
    position = snapshot['position']['geopoint'],
    skillList = snapshot['skill_list'];
}

Future uploadFile(String path, String name, File img, String id) async {
  StorageReference reference = FirebaseStorage.instance.ref().child(path);
  if(path == 'CV1' || path == 'CV2')
    reference = FirebaseStorage.instance.ref().child('CV');

  StorageUploadTask uploadTask = reference.putFile(img);
  StorageTaskSnapshot storageTaskSnapshot;
  uploadTask.onComplete.then((onValue) {
    if(onValue.error == null)
    {
      storageTaskSnapshot = onValue;
      storageTaskSnapshot.ref.getDownloadURL().then((url) {
        Firestore.instance
        .collection('USER')
        .document(id)
        .updateData({path:url});
      });
    }
    else
    {
      Fluttertoast.showToast(msg: 'This file is not an image');
    }
  },onError: (err){
    Fluttertoast.showToast(msg: err.toString());
  });
}

Future<List<Job>> queryJob({List<String> terms, List<String> skills, GeoPoint coord}) async {
  if(terms != null)
  {
    QuerySnapshot qShot = 
      await Firestore.instance.collection('JOBS')
      .where('key_term',arrayContainsAny: terms)
      .getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  }
  else if(skills != null)
  {
    QuerySnapshot qShot = 
      await Firestore.instance.collection('JOBS')
      .where('skill_list',arrayContainsAny: skills)
      .getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  }
  else if(coord != null)
  {
    QuerySnapshot qShot = 
      await Firestore.instance.collection('JOBS')
      .where('key_term',arrayContainsAny: terms)
      .getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  }
  else {
    QuerySnapshot qShot = 
      await Firestore.instance.collection('JOBS').getDocuments();
    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  }
}

Stream<QuerySnapshot> queryFavoriteList() {
  return getJobList(globals.currentUserInfo.favorite);
}

Stream<QuerySnapshot> queryAppliedList(){
  return getJobList(globals.currentUserInfo.applied);
}

Stream<List<DocumentSnapshot>> queryGeoKeyJob(String name, double lat, double long) {
  var terms = name.split(" ");
  GeoFirePoint center = Geoflutterfire().point(latitude: lat, longitude: long);
  var collectionReference = Firestore.instance.collection('JOBS').where('key_term',arrayContainsAny: terms);
  var searchRef = Geoflutterfire().collection(collectionRef: collectionReference).within(
          center: center, radius: 20, field: 'position');
  return searchRef;
  //return searchRef.map((list) => list.map((doc) => Job.fromSnapshot(doc)).toList());
}